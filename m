From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: [Patch] version.sh: clean up the code
Date: Mon, 19 Jan 2009 21:51:05 +0800
Message-ID: <20090119135105.GB7863@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


- In bash, integer comparation should use '-eq', not '=='.
- Remove code for Mercurial, since btrfs now uses git.

Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/version.sh b/version.sh
index 92c3953..e69f8f8 100644
--- a/version.sh
+++ b/version.sh
@@ -9,7 +9,7 @@
 v="Btrfs v0.17"
 
 which git &> /dev/null
-if [ $? == 0 -a -d .git ]; then
+if [ $? -eq 0 -a -d .git ]; then
     if head=`git rev-parse --verify HEAD 2>/dev/null`; then
         if tag=`git describe --tags 2>/dev/null`; then
             v="$tag"
@@ -23,26 +23,6 @@ if [ $? == 0 -a -d .git ]; then
         fi
     fi
 fi
-
-which hg &> /dev/null
-if [ $? == 0 -a -d .hg ]; then
-	last=$(hg tags | grep -m1 -o '^v[0-9.]\+')
-	 
-	# now check if the repo has commits since then...
-	if [[ $(hg id -t) == $last || \
-	    $(hg di -r "$last:." | awk '/^diff/{print $NF}' | sort -u) == .hgtags ]]
-	then
-	    # check if it's dirty
-	    if [[ $(hg id | cut -d' ' -f1) == *+ ]]; then
-		v=$last+
-	    else
-		v=$last
-	    fi
-	else
-	    # includes dirty flag
-	    v=$last+$(hg id -i)
-	fi
-fi
  
 echo "#ifndef __BUILD_VERSION" > .build-version.h
 echo "#define __BUILD_VERSION" >> .build-version.h
@@ -51,7 +31,7 @@ echo "#endif" >> .build-version.h
 
 diff -q version.h .build-version.h >& /dev/null
 
-if [ $? == 0 ]; then
+if [ $? -eq 0 ]; then
     rm .build-version.h
     exit 0
 fi


