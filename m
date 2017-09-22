Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:17546 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdIVF7U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 01:59:20 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 4E1A8AC0170
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Sep 2017 14:59:17 +0900 (JST)
Subject: [PATCH v2 2/3] btrfs: split parse_early_options() in two
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <anand.jain@oracle.com>
References: <afc0d4c0-e89c-9786-8583-e4bedaf9557e@jp.fujitsu.com>
Message-ID: <663bd94f-29da-5881-c8b1-86cf119f38dc@jp.fujitsu.com>
Date: Fri, 22 Sep 2017 14:59:12 +0900
MIME-Version: 1.0
In-Reply-To: <afc0d4c0-e89c-9786-8583-e4bedaf9557e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Extract the part related to subvol option from parse_early_options() and
move it to new parse function (parse_subvol_options()).

This is because mount_root() doesn't need to handle subvol options.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/super.c | 75 +++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 58 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3c32677..9498743 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -448,7 +448,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		case Opt_subvolrootid:
 		case Opt_device:
 			/*
-			 * These are parsed by btrfs_parse_early_options
+			 * These are parsed by btrfs_parse_subvol_options
+			 * and btrfs_parse_early_options
 			 * and can be happily ignored here.
 			 */
 			break;
@@ -855,11 +856,63 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_device:
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
+			break;
+		default:
+			break;
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
+ * The parsed value is later passed to mount_subvol()
+ */
+static int btrfs_parse_subvol_options(const char *options, fmode_t flags,
+		void *holder, char **subvol_name, u64 *subvol_objectid)
+{
+	substring_t args[MAX_OPT_ARGS];
+	char *opts, *orig, *p;
 	char *num = NULL;
 	int error = 0;
 
@@ -867,8 +920,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		return 0;
 
 	/*
-	 * strsep changes the string, duplicate it because parse_options
-	 * gets called twice
+	 * strsep changes the string, duplicate it because
+	 * btrfs_parse_early_options gets called later
 	 */
 	opts = kstrdup(options, GFP_KERNEL);
 	if (!opts)
@@ -907,18 +960,6 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
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
-- 
2.9.5

