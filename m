From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: [PATCH 1/2] Change version.sh from last tag and hash to output last
	commit date and hash
Date: Tue, 04 May 2010 09:12:01 -0700
Message-ID: <20100504161201.3720.37609.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs git repo doesn't have all of the tags from the base 2.6.32 kernel
it's currently based upon and the btrfs module is regularly compiled
against other kernels so this changes the version to be based upon the date
and hash of the latest commit instead which is more relevant to most people
testing.

An example version string with this change:
Btrfs 2010-04-06_09:37:47_-0400_9f680ce
---

 fs/btrfs/version.sh |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)
 mode change 100644 => 100755 fs/btrfs/version.sh

diff --git a/fs/btrfs/version.sh b/fs/btrfs/version.sh
old mode 100644
new mode 100755
index 1ca1952..a4576f2
--- a/fs/btrfs/version.sh
+++ b/fs/btrfs/version.sh
@@ -12,10 +12,7 @@ which git &> /dev/null
 if [ $? == 0 ]; then
     git branch >& /dev/null
     if [ $? == 0 ]; then
-	    if head=`git rev-parse --verify HEAD 2>/dev/null`; then
-		if tag=`git describe --tags 2>/dev/null`; then
-		    v="$tag"
-		fi
+		v="`git show --format='%ci_%h'|head -n 1|sed 's/[^a-z0-9_-:]/_/ig'`"
 
 		# Are there uncommitted changes?
 		git update-index --refresh --unmerged > /dev/null
@@ -24,7 +21,6 @@ if [ $? == 0 ]; then
 		    | read dummy; then
 		    v="$v"-dirty
 		fi
-	    fi
     fi
 fi
  

