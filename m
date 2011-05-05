From: Jamey Sharp <jamey@minilop.net>
Subject: [PATCH] btrfs: Delete unused version.sh script.
Date: Thu,  5 May 2011 12:03:46 -0700
Message-ID: <1304622227-18204-1-git-send-email-jamey@minilop.net>
Cc: Josh Triplett <josh@joshtriplett.org>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In 2008, commit b4f6c45dfbf84f47c21f73f6370ad1292b0627fd dropped the use
of fs/btrfs/version.sh, but left the script behind. Kill it.

Commit by Jamey Sharp and Josh Triplett.

Signed-off-by: Jamey Sharp <jamey@minilop.net>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Chris Mason <chris.mason@oracle.com>
---
 fs/btrfs/version.sh |   43 -------------------------------------------
 1 files changed, 0 insertions(+), 43 deletions(-)
 delete mode 100644 fs/btrfs/version.sh

diff --git a/fs/btrfs/version.sh b/fs/btrfs/version.sh
deleted file mode 100644
index 1ca1952..0000000
--- a/fs/btrfs/version.sh
+++ /dev/null
@@ -1,43 +0,0 @@
-#!/bin/bash
-#
-# determine-version -- report a useful version for releases
-#
-# Copyright 2008, Aron Griffis <agriffis@n01se.net>
-# Copyright 2008, Oracle
-# Released under the GNU GPLv2
- 
-v="v0.16"
-
-which git &> /dev/null
-if [ $? == 0 ]; then
-    git branch >& /dev/null
-    if [ $? == 0 ]; then
-	    if head=`git rev-parse --verify HEAD 2>/dev/null`; then
-		if tag=`git describe --tags 2>/dev/null`; then
-		    v="$tag"
-		fi
-
-		# Are there uncommitted changes?
-		git update-index --refresh --unmerged > /dev/null
-		if git diff-index --name-only HEAD | \
-		    grep -v "^scripts/package" \
-		    | read dummy; then
-		    v="$v"-dirty
-		fi
-	    fi
-    fi
-fi
- 
-echo "#ifndef __BUILD_VERSION" > .build-version.h
-echo "#define __BUILD_VERSION" >> .build-version.h
-echo "#define BTRFS_BUILD_VERSION \"Btrfs $v\"" >> .build-version.h
-echo "#endif" >> .build-version.h
-
-diff -q version.h .build-version.h >& /dev/null
-
-if [ $? == 0 ]; then
-    rm .build-version.h
-    exit 0
-fi
-
-mv .build-version.h version.h
-- 
1.7.4.4

