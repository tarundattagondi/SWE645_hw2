pipeline {
  agent any
  options {
    timestamps()
  }
  environment {
    REGISTRY = 'docker.io'
    IMAGE    = 'tgondi/swe645-site'    // Docker Hub repo
    KNS      = 'swe645-hw2'            // Namespace
    DEPLOY   = 'swe645-site'           // Deployment name
    TAG      = "b${env.BUILD_NUMBER}"  // Unique tag per build
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Inject build footer (optional)') {
      steps {
        sh '''
          # If index.html exists at repo root, append a tiny version footer
          if [ -f index.html ]; then
            printf '\\n<!-- build %s at %s -->\\n<footer style="text-align:center;opacity:.7;padding:8px 0;">Version %s</footer>\\n' \
              "${TAG}" "$(date)" "${TAG}" >> index.html
          fi
        '''
      }
    }

    stage('Build image') {
      steps {
        sh """
          docker build -t ${REGISTRY}/${IMAGE}:${TAG} .
          docker tag  ${REGISTRY}/${IMAGE}:${TAG} ${REGISTRY}/${IMAGE}:latest
        """
      }
    }

    stage('Push image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DU', passwordVariable: 'DP')]) {
          sh """
            echo "$DP" | docker login -u "$DU" --password-stdin ${REGISTRY}
            docker push ${REGISTRY}/${IMAGE}:${TAG}
            docker push ${REGISTRY}/${IMAGE}:latest
          """
        }
      }
    }

    stage('Deploy to K8s') {
      steps {
        sh """
          # Ensure the deployment always re-pulls the image
          kubectl -n ${KNS} patch deploy/${DEPLOY} --type=strategic -p \
            '{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"web\",\"imagePullPolicy\":\"Always\"}]}}}}' || true

          # Point to the build-specific tag (best for traceability)
          kubectl -n ${KNS} set image deploy/${DEPLOY} web=${REGISTRY}/${IMAGE}:${TAG}

          # Wait for rollout
          kubectl -n ${KNS} rollout status deploy/${DEPLOY} --timeout=180s

          # Show what image the deployment is now using
          echo "Deployed image:"
          kubectl -n ${KNS} get deploy/${DEPLOY} -o=jsonpath='{.spec.template.spec.containers[0].image}'; echo
        """
      }
    }
  }

  post {
    success {
      echo "Build ${env.BUILD_NUMBER} deployed. Visit your app at http://34.239.64.159:30000/"
    }
    always {
      sh 'docker image prune -f || true'
    }
  }
}
