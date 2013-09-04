Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39662 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3IDPWt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:22:49 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp13so572728pab.7
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:22:49 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 02/20] Btrfs-progs: fix magic return value in cmds-subvolume.c
Date: Wed,  4 Sep 2013 23:22:19 +0800
Message-Id: <1378308157-4621-3-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

The patch also fixes some coding styles problems.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-subvolume.c | 45 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e1fa81a..2c62492 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -218,14 +218,14 @@ again:
 	path = argv[cnt];
 
 	res = test_issubvolume(path);
-	if(res<0){
+	if (res < 0) {
 		fprintf(stderr, "ERROR: error accessing '%s'\n", path);
-		ret = 12;
+		ret = 1;
 		goto out;
 	}
-	if(!res){
+	if (!res) {
 		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", path);
-		ret = 13;
+		ret = 1;
 		goto out;
 	}
 
@@ -236,11 +236,11 @@ again:
 	vname = basename(vname);
 	free(cpath);
 
-	if( !strcmp(vname,".") || !strcmp(vname,"..") ||
-	     strchr(vname, '/') ){
+	if (!strcmp(vname, ".") || !strcmp(vname, "..") ||
+	     strchr(vname, '/')) {
 		fprintf(stderr, "ERROR: incorrect subvolume name ('%s')\n",
 			vname);
-		ret = 14;
+		ret = 1;
 		goto out;
 	}
 
@@ -248,14 +248,14 @@ again:
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
 		fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
 			vname);
-		ret = 14;
+		ret = 1;
 		goto out;
 	}
 
 	fd = open_file_or_dir(dname, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", dname);
-		ret = 12;
+		ret = 1;
 		goto out;
 	}
 
@@ -269,7 +269,7 @@ again:
 	if(res < 0 ){
 		fprintf( stderr, "ERROR: cannot delete '%s/%s' - %s\n",
 			dname, vname, strerror(e));
-		ret = 11;
+		ret = 1;
 		goto out;
 	}
 
@@ -471,8 +471,7 @@ out:
 		btrfs_list_free_comparer_set(comparer_set);
 	if (uerr)
 		usage(cmd_subvol_list_usage);
-
-	return ret;
+	return !!ret;
 }
 
 static const char * const cmd_snapshot_usage[] = {
@@ -694,9 +693,7 @@ static int cmd_subvol_get_default(int argc, char **argv)
 		btrfs_list_free_filter_set(filter_set);
 out:
 	close_file_or_dir(fd, dirstream);
-	if (ret)
-		return 1;
-	return 0;
+	return !!ret;
 }
 
 static const char * const cmd_subvol_set_default_usage[] = {
@@ -765,23 +762,21 @@ static int cmd_find_new(int argc, char **argv)
 	ret = test_issubvolume(subvol);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
-		return 12;
+		return 1;
 	}
 	if (!ret) {
 		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
-		return 13;
+		return 1;
 	}
 
 	fd = open_file_or_dir(subvol, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
-		return 12;
+		return 1;
 	}
 	ret = btrfs_list_find_updated_files(fd, 0, last_gen);
 	close_file_or_dir(fd, dirstream);
-	if (ret)
-		return 19;
-	return 0;
+	return !!ret;
 }
 
 static const char * const cmd_subvol_show_usage[] = {
@@ -800,7 +795,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	char raw_prefix[] = "\t\t\t\t";
 	u64 sv_id, mntid;
 	int fd = -1, mntfd = -1;
-	int ret = -1;
+	int ret = 1;
 	DIR *dirstream1 = NULL, *dirstream2 = NULL;
 
 	if (check_argc_exact(argc, 2))
@@ -820,7 +815,6 @@ static int cmd_subvol_show(int argc, char **argv)
 	}
 	if (!ret) {
 		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", fullpath);
-		ret = -1;
 		goto out;
 	}
 
@@ -830,7 +824,7 @@ static int cmd_subvol_show(int argc, char **argv)
 				"%s\n", fullpath, strerror(-ret));
 		goto out;
 	}
-	ret = -1;
+	ret = 1;
 	svpath = get_subvol_name(mnt, fullpath);
 
 	fd = open_file_or_dir(fullpath, &dirstream1);
@@ -935,8 +929,7 @@ out:
 		free(mnt);
 	if (fullpath)
 		free(fullpath);
-
-	return ret;
+	return !!ret;
 }
 
 const struct cmd_group subvolume_cmd_group = {
-- 
1.7.11.7

