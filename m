From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] Generate btrfs-progs version.h from git too
Date: Tue, 19 Aug 2008 19:00:08 +0100
Message-ID: <1219168808.2988.5.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This allows version.h to be generated from either git or hg.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 version.sh |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/version.sh b/version.sh
index d7988bf..209b7d1 100644
--- a/version.sh
+++ b/version.sh
@@ -8,7 +8,23 @@
  
 v="Btrfs v0.16"
 
-which hg > /dev/null
+which git &> /dev/null
+if [ $? == 0 -a -d .git ]; then
+    if head=`git rev-parse --verify HEAD 2>/dev/null`; then
+        if tag=`git describe --tags 2>/dev/null`; then
+            v="$tag"
+        fi
+
+        # Are there uncommitted changes?
+        git update-index --refresh --unmerged > /dev/null
+        if git diff-index --name-only HEAD | grep -v "^scripts/package" \
+            | read dummy; then
+            v="$v"-dirty
+        fi
+    fi
+fi
+
+which hg &> /dev/null
 if [ $? == 0 -a -d .hg ]; then
 	last=$(hg tags | grep -m1 -o '^v[0-9.]\+')
 	 
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



