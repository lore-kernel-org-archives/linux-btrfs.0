From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH] bcp: fix off-by-one errors in path handling
Date: Sun, 14 Feb 2010 09:26:55 +0200
Message-ID: <1266132415-17837-1-git-send-email-eduard.munteanu@linux360.ro>
Cc: linux-btrfs@vger.kernel.org,
	Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This fixes a bug which causes the first character of each filename in
the destination to be omitted.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 bcp |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/bcp b/bcp
index 5729e91..c6b4bef 100755
--- a/bcp
+++ b/bcp
@@ -137,7 +137,7 @@ for srci in xrange(0, src_args):
             statinfo = os.lstat(srcname)
 
             if srcname.startswith(src):
-                part = srcname[len(src) + 1:]
+                part = srcname[len(src):]
 
             if stat.S_ISLNK(statinfo.st_mode):
                 copylink(srcname, dst, part, statinfo, None)
@@ -153,7 +153,7 @@ for srci in xrange(0, src_args):
         for f in filenames:
             srcname = os.path.join(dirpath, f)
             if srcname.startswith(src):
-                part = srcname[len(src) + 1:]
+                part = srcname[len(src):]
 
             statinfo = os.lstat(srcname)
             copyfile(srcname, dst, part, statinfo, None)
-- 
1.6.4.4

