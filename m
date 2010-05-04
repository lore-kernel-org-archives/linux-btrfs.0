From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: [PATCH v2 2/2] Fix version.sh to work with dash
Date: Tue, 04 May 2010 10:47:38 -0700
Message-ID: <20100504174738.4526.46612.stgit@localhost.localdomain>
References: <20100504174733.4526.23527.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100504174733.4526.23527.stgit@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


---

 fs/btrfs/version.sh |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/version.sh b/fs/btrfs/version.sh
index a4576f2..d87daf4 100755
--- a/fs/btrfs/version.sh
+++ b/fs/btrfs/version.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/sh
 #
 # determine-version -- report a useful version for releases
 #
@@ -8,10 +8,10 @@
  
 v="v0.16"
 
-which git &> /dev/null
-if [ $? == 0 ]; then
-    git branch >& /dev/null
-    if [ $? == 0 ]; then
+which git 2>&1 > /dev/null
+if [ $? -eq 0 ]; then
+    git branch 2>&1 > /dev/null
+    if [ $? -eq 0 ]; then
 		v="`git show --format='%ci_%h'|head -n 1|sed 's/[^a-z0-9_-:]/_/ig'`"
 
 		# Are there uncommitted changes?
@@ -19,7 +19,7 @@ if [ $? == 0 ]; then
 		if git diff-index --name-only HEAD | \
 		    grep -v "^scripts/package" \
 		    | read dummy; then
-		    v="$v"-dirty
+		    v="${v}-dirty"
 		fi
     fi
 fi
@@ -29,9 +29,9 @@ echo "#define __BUILD_VERSION" >> .build-version.h
 echo "#define BTRFS_BUILD_VERSION \"Btrfs $v\"" >> .build-version.h
 echo "#endif" >> .build-version.h
 
-diff -q version.h .build-version.h >& /dev/null
+diff -q version.h .build-version.h 2>&1 > /dev/null
 
-if [ $? == 0 ]; then
+if [ $? -eq 0 ]; then
     rm .build-version.h
     exit 0
 fi

