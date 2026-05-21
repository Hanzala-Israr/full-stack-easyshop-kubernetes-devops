@Library('Shared') _

pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE_NAME = 'mhanzala/easyshop-app'
        DOCKER_MIGRATION_IMAGE_NAME = 'mhanzala/easyshop-migration'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        GIT_BRANCH = "main"
        GIT_REPO = "https://github.com/Hanzala-Israr/full-stack-easyshop-kubernetes-devops.git"
    }
    
    stages {
        stage('Cleanup Workspace') {
            steps {
                script {
                    clean_ws()
                }
            }
        }
        
        stage('Clone Repository') {
            steps {
                script {
                    clone(GIT_REPO, GIT_BRANCH)
                }
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    nodejs('node18') {
                        echo "Building application assets securely using Jenkins NodeJS tool layer..."
                        sh """
                            npm install --legacy-peer-deps
                            
                            # This compiles your production .next folder natively on the host!
                            npm run build
                            
                            echo "Pre-compiling migration script to pure JavaScript..."
                            ./node_modules/.bin/tsc scripts/migrate-data.ts --target es2020 --module commonjs --allowSyntheticDefaultImports true
                            
                            echo "Creating unignored layers for containers..."
                            cp -r node_modules migration_modules
                            
                            # --- CRUCIAL FIX: Bypass .dockerignore for build assets ---
                            cp -r .next migration_next
                        """
                    }

                    echo "Starting Main Application Build..."
                    docker_build(
                        imageName: env.DOCKER_IMAGE_NAME,
                        imageTag: env.DOCKER_IMAGE_TAG,
                        dockerfile: 'Dockerfile',
                        context: '.'
                    )
                    
                    echo "Starting Database Migration Build..."
                    docker_build(
                        imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                        imageTag: env.DOCKER_IMAGE_TAG,
                        dockerfile: 'scripts/Dockerfile.migration',
                        context: '.'
                    )

                    sh "rm -rf migration_modules migration_next"
                }
            }
        }
        
        
        stage('Run Unit Tests') {
            steps {
                script {
                    run_tests()
                }
            }
        }
        
        stage('Security Scan with Trivy') {
            steps {
                script {
                    trivy_scan()
                }
            }
        }
        
        stage('Push Docker Images') {
            parallel {
                stage('Push Main App Image') {
                    steps {
                        script {
                            docker_push(
                                imageName: env.DOCKER_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                credentials: 'docker-hub-credentials'
                            )
                        }
                    }
                }
                
                stage('Push Migration Image') {
                    steps {
                        script {
                            docker_push(
                                imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                credentials: 'docker-hub-credentials'
                            )
                        }
                    }
                }
            }
        }
        
        stage('Update Kubernetes Manifests') {
            steps {
                script {
                    update_k8s_manifests(
                        imageTag: env.DOCKER_IMAGE_TAG,
                        manifestsPath: 'kubernetes',
                        gitCredentials: 'github-credentials',
                        gitUserName: 'Hanzala-Israr',
                        gitUserEmail: 'hanzala.coder@gmail.com'
                    )
                }
            }
        }
    }
}
