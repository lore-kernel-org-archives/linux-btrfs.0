Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:39505 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdLNIZi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 03:25:38 -0500
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 3B3C8AC0155
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:25:32 +0900 (JST)
Received: from g01jpexchkw38.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 58C8A328850
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 17:25:31 +0900 (JST)
Subject: [PATCH v4 3/4] btrfs: split parse_early_options() in two
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
Message-ID: <aa504d5f-8ef6-c518-da0b-d9ecef07bd9d@jp.fujitsu.com>
Date: Thu, 14 Dec 2017 17:25:28 +0900
MIME-Version: 1.0
In-Reply-To: <7dbb897c-1f1d-b54b-0cea-2a1c6c1d5027@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now parse_early_options() is used by both btrfs_mount() and
btrfs_mount_root(). However, the former only needs subvol related part
and the latter needs the others.

Therefore extract the subvol related parts from parse_early_options() and
move it to new parse function (parse_subvol_options()).

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 82 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ce93d87b2a69..f0ecba7a1190 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -460,7 +460,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_subvolrootid:
 		case Opt_device:
 			/*
-			 * These are parsed by btrfs_parse_early_options
+			 * These are parsed by btrfs_parse_subvol_options
+			 * and btrfs_parse_early_options
 			 * and can be happily ignored here.
 			 */
 			break;
@@ -894,11 +895,60 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
  * only when we need to allocate a new super block.
  */
 static int btrfs_parse_early_options(const char *options, fmode_t flags,
-		void *holder, char **subvol_name, u64 *subvol_objectid,
-		struct btrfs_fs_devices **fs_devices)
+		void *holder, struct btrfs_fs_devices **fs_devices)
 {
 	substring_t args[MAX_OPT_ARGS];
 	char *device_name, *opts, *orig, *p;
+	int error = 0;
+
+	if (!options)
+		return 0;
+
+	/*
+	 * strsep changes the string, duplicate it because btrfs_parse_options
+	 * gets called later
+	 */
+	opts = kstrdup(options, GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
+	orig = opts;
+
+	while ((p = strsep(&opts, ",")) != NULL) {
+		int token;
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		if (token == Opt_device) {
+			device_name = match_strdup(&args[0]);
+			if (!device_name) {
+				error = -ENOMEM;
+				goto out;
+			}
+			error = btrfs_scan_one_device(device_name,
+					flags, holder, fs_devices);
+			kfree(device_name);
+			if (error)
+				goto out;
+		}
+	}
+
+out:
+	kfree(orig);
+	return error;
+}
+
+/*
+ * Parse mount options that are related to subvolume id
+ *
+ * The value is later passed to mount_subvol()
+ */
+static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
+		void *holder, char **subvol_name, u64 *subvol_objectid)
+{
+	substring_t args[MAX_OPT_ARGS];
+	char *opts, *orig, *p;
 	char *num = NULL;
 	int error = 0;
 
@@ -906,8 +956,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		return 0;
 
 	/*
-	 * strsep changes the string, duplicate it because parse_options
-	 * gets called twice
+	 * strsep changes the string, duplicate it because
+	 * btrfs_parse_early_options gets called later
 	 */
 	opts = kstrdup(options, GFP_KERNEL);
 	if (!opts)
@@ -946,18 +996,6 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		case Opt_subvolrootid:
 			pr_warn("BTRFS: 'subvolrootid' mount option is deprecated and has no effect\n");
 			break;
-		case Opt_device:
-			device_name = match_strdup(&args[0]);
-			if (!device_name) {
-				error = -ENOMEM;
-				goto out;
-			}
-			error = btrfs_scan_one_device(device_name,
-					flags, holder, fs_devices);
-			kfree(device_name);
-			if (error)
-				goto out;
-			break;
 		default:
 			break;
 		}
@@ -1538,18 +1576,14 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 	struct btrfs_fs_info *fs_info = NULL;
 	struct security_mnt_opts new_sec_opts;
 	fmode_t mode = FMODE_READ;
-	char *subvol_name = NULL;
-	u64 subvol_objectid = 0;
 	int error = 0;
 
 	if (!(flags & SB_RDONLY))
 		mode |= FMODE_WRITE;
 
 	error = btrfs_parse_early_options(data, mode, fs_type,
-					  &subvol_name, &subvol_objectid,
 					  &fs_devices);
 	if (error) {
-		kfree(subvol_name);
 		return ERR_PTR(error);
 	}
 
@@ -1661,7 +1695,6 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 		const char *device_name, void *data)
 {
-	struct btrfs_fs_devices *fs_devices = NULL;
 	struct vfsmount *mnt_root;
 	struct dentry *root;
 	fmode_t mode = FMODE_READ;
@@ -1672,9 +1705,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	if (!(flags & SB_RDONLY))
 		mode |= FMODE_WRITE;
 
-	error = btrfs_parse_early_options(data, mode, fs_type,
-					  &subvol_name, &subvol_objectid,
-					  &fs_devices);
+	error = btrfs_parse_subvol_options(data, mode, fs_type,
+					  &subvol_name, &subvol_objectid);
 	if (error) {
 		kfree(subvol_name);
 		return ERR_PTR(error);
-- 
2.13.6

