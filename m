Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35307 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757164Ab3IEIBx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Sep 2013 04:01:53 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8581pbm006970
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Sep 2013 16:01:51 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH V3 5/5] btrfs-progs:free strdup()s that are not freed
Date: Thu, 5 Sep 2013 16:00:43 +0800
Message-Id: <1378368043-29714-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The strdup()s not freed are reported as memory leaks by valgrind.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
Changelog V1 -> V2:
- remove the "if" decision before free()
Changelog V2 -> V3:
- correct confusing subject and add changelog
---
 cmds-subvolume.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e1fa81a..f7a0c5f 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -75,6 +75,8 @@ static int cmd_subvol_create(int argc, char **argv)
 {
 	int	retval, res, len;
 	int	fddst = -1;
+	char	*dupname = NULL;
+	char	*dupdir = NULL;
 	char	*newname;
 	char	*dstdir;
 	char	*dst;
@@ -119,10 +121,10 @@ static int cmd_subvol_create(int argc, char **argv)
 		goto out;
 	}
 
-	newname = strdup(dst);
-	newname = basename(newname);
-	dstdir = strdup(dst);
-	dstdir = dirname(dstdir);
+	dupname = strdup(dst);
+	newname = basename(dupname);
+	dupdir = strdup(dst);
+	dstdir = dirname(dupdir);
 
 	if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
 	     strchr(newname, '/') ){
@@ -174,6 +176,8 @@ static int cmd_subvol_create(int argc, char **argv)
 out:
 	close_file_or_dir(fddst, dirstream);
 	free(inherit);
+	free(dupname);
+	free(dupdir);
 
 	return retval;
 }
@@ -208,6 +212,8 @@ static int cmd_subvol_delete(int argc, char **argv)
 	int	res, fd, len, e, cnt = 1, ret = 0;
 	struct btrfs_ioctl_vol_args	args;
 	char	*dname, *vname, *cpath;
+	char	*dupdname = NULL;
+	char	*dupvname = NULL;
 	char	*path;
 	DIR	*dirstream = NULL;
 
@@ -230,10 +236,10 @@ again:
 	}
 
 	cpath = realpath(path, NULL);
-	dname = strdup(cpath);
-	dname = dirname(dname);
-	vname = strdup(cpath);
-	vname = basename(vname);
+	dupdname = strdup(cpath);
+	dname = dirname(dupdname);
+	dupvname = strdup(cpath);
+	vname = basename(dupvname);
 	free(cpath);
 
 	if( !strcmp(vname,".") || !strcmp(vname,"..") ||
@@ -274,6 +280,8 @@ again:
 	}
 
 out:
+	free(dupdname);
+	free(dupvname);
 	cnt++;
 	if (cnt < argc)
 		goto again;
@@ -495,6 +503,8 @@ static int cmd_snapshot(int argc, char **argv)
 	int	res, retval;
 	int	fd = -1, fddst = -1;
 	int	len, readonly = 0;
+	char	*dupname = NULL;
+	char	*dupdir = NULL;
 	char	*newname;
 	char	*dstdir;
 	struct btrfs_ioctl_vol_args_v2	args;
@@ -562,14 +572,14 @@ static int cmd_snapshot(int argc, char **argv)
 	}
 
 	if (res > 0) {
-		newname = strdup(subvol);
-		newname = basename(newname);
+		dupname = strdup(subvol);
+		newname = basename(dupname);
 		dstdir = dst;
 	} else {
-		newname = strdup(dst);
-		newname = basename(newname);
-		dstdir = strdup(dst);
-		dstdir = dirname(dstdir);
+		dupname = strdup(dst);
+		newname = basename(dupname);
+		dupdir = strdup(dst);
+		dstdir = dirname(dupdir);
 	}
 
 	if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
@@ -629,6 +639,8 @@ out:
 	close_file_or_dir(fddst, dirstream1);
 	close_file_or_dir(fd, dirstream2);
 	free(inherit);
+	free(dupname);
+	free(dupdir);
 
 	return retval;
 }
-- 
1.8.0.1

