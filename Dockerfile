FROM ubuntu:22.04

# Install dependencies (including git)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    curl \
    gnupg \
    git \
    unzip \
    zip \
    openjdk-11-jdk \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Install Bazel (official method)
RUN curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel.gpg && \
    mv bazel.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" > /etc/apt/sources.list.d/bazel.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y bazel && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install SWE-ReX requirements
RUN pip3 install pipx
RUN pipx install swe-rex
RUN pipx ensurepath

# Create a non-root user (for potential commands that require it)
RUN useradd -ms /bin/bash bazeluser

# Set up the preexisting repository
WORKDIR /bazel_hello_world
# Copies content of /data/dingkwang/CKT21662/bazel_hello_world into /bazel_hello_world
COPY . .  

# Ensure it's a git repository
RUN git init && \
    git config --global user.email "sweagent@example.com" && \
    git config --global user.name "SWE-Agent Build" && \
    # Add safe.directory to allow git operations by any user on this path
    git config --global --add safe.directory /bazel_hello_world && \
    git add . && \
    git commit --allow-empty -m "Initial commit for preexisting image content"

# Set environment variables for both root and bazeluser paths
ENV PATH="/root/.local/bin:/home/bazeluser/.local/bin:${PATH}"

# Create a wrapper script to ensure PATH is properly set
RUN echo '#!/bin/bash\nexport PATH="/root/.local/bin:/home/bazeluser/.local/bin:${PATH}"\nexec swerex-remote $@' > /usr/local/bin/swerex-remote-wrapper && \
    chmod +x /usr/local/bin/swerex-remote-wrapper

# Default command (will run from /bazel_hello_world)
CMD ["bazel", "run", "hello_world"] 