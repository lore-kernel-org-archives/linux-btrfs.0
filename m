From: cwillu <cwillu@cwillu.com>
Subject: [PATCH] Btrfs-progs: Correct path munging in bcp
Date: Mon, 13 Jun 2011 16:24:11 -0600
Message-ID: <BANLkTikN-Ueh6vfuSGgn+Bvxuco-kxdAcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Bcp was assuming that a path on the command line would never have a slash after
it, which is silly, and would cause the first letter of everything in the root
of the source to be truncated.  Instead, use os.path.relpath to handle
it properly.

Signed-off-by: Carey Underwood <cwillu@cwillu.com>
---
 bcp |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/bcp b/bcp
index 5729e91..e7ca641 100755
--- a/bcp
+++ b/bcp
@@ -136,8 +136,7 @@ for srci in xrange(0, src_args):
             srcname = os.path.join(dirpath, x)
             statinfo = os.lstat(srcname)

-            if srcname.startswith(src):
-                part = srcname[len(src) + 1:]
+            part = os.path.relpath(srcname, src)

             if stat.S_ISLNK(statinfo.st_mode):
                 copylink(srcname, dst, part, statinfo, None)
@@ -152,8 +151,7 @@ for srci in xrange(0, src_args):

         for f in filenames:
             srcname = os.path.join(dirpath, f)
-            if srcname.startswith(src):
-                part = srcname[len(src) + 1:]
+            part = os.path.relpath(srcname, src)

             statinfo = os.lstat(srcname)
             copyfile(srcname, dst, part, statinfo, None)
-- 
1.7.4.1
