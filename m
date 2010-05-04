From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: [PATCH 2/2] Fix version.sh to work with dash
Date: Tue, 04 May 2010 09:12:07 -0700
Message-ID: <20100504161207.3720.32821.stgit@localhost.localdomain>
References: <20100504161201.3720.37609.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100504161201.3720.37609.stgit@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


---

 fs/btrfs/version.h  |    6 +++---
 fs/btrfs/version.sh |   16 ++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/version.h b/fs/btrfs/version.h
index 9bf3946..12f7e5c 100644
--- a/fs/btrfs/version.h
+++ b/fs/btrfs/version.h
@@ -1,4 +1,4 @@
-#ifndef __BTRFS_VERSION_H
-#define __BTRFS_VERSION_H
-#define BTRFS_BUILD_VERSION "Btrfs"
+#ifndef __BUILD_VERSION
+#define __BUILD_VERSION
+#define BTRFS_BUILD_VERSION "Btrfs 2010-05-04_08:46:49_-0700_ea1dcb3-dirty"
 #endif
diff --git a/fs/btrfs/version.sh b/fs/btrfs/version.sh
index a4576f2..0733eef 100755
--- a/fs/btrfs/version.sh
+++ b/fs/btrfs/version.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/dash
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

