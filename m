Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:36375 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966502AbbDWQvf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 12:51:35 -0400
Received: by qku63 with SMTP id 63so14249697qku.3
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 09:51:35 -0700 (PDT)
Message-ID: <55392315.8040306@gmail.com>
Date: Thu, 23 Apr 2015 12:51:33 -0400
From: Dan Merillat <dan.merillat@gmail.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs-progs: separate the overwrite check.
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <55392221.6090502@gmail.com>

Symlink restore needs this, but the cut&paste became
too complicated.  Simplify everything.

Signed-off-by: Dan Merillat <dan.merillat@gmail.com>
---
 cmds-restore.c | 53 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index e877548..8869f2a 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -781,6 +781,37 @@ out:
 	return ret;
 }
 
+/* returns:
+ *  0 if the file exists and should be skipped.
+ *  1 if the file does NOT exist
+ *  2 if the file exists but is OK to overwrite
+ */
+
+static int overwrite_ok(const char * path)
+{
+	static int warn = 0;
+	struct stat st;
+	int ret;
+
+	/* don't be fooled by symlinks */
+	ret = fstatat(-1, path_name, &st, AT_SYMLINK_NOFOLLOW);
+
+	if (!ret) {
+		if (overwrite)
+			return 2;
+
+		if (verbose || !warn)
+			printf("Skipping existing file"
+				   " %s\n", path);
+		if (!warn)
+			printf("If you wish to overwrite use "
+				   "the -o option to overwrite\n");
+		warn = 1;
+		return 0;
+	}
+	return 1;
+}
+
 static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		      const char *output_rootdir, const char *in_dir,
 		      const regex_t *mreg)
@@ -897,25 +928,9 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		 * files, no symlinks or anything else.
 		 */
 		if (type == BTRFS_FT_REG_FILE) {
-			if (!overwrite) {
-				static int warn = 0;
-				struct stat st;
-
-				ret = stat(path_name, &st);
-				if (!ret) {
-					loops = 0;
-					if (verbose || !warn)
-						printf("Skipping existing file"
-						       " %s\n", path_name);
-					if (warn)
-						goto next;
-					printf("If you wish to overwrite use "
-					       "the -o option to overwrite\n");
-					warn = 1;
-					goto next;
-				}
-				ret = 0;
-			}
+			if (!overwrite_ok(path_name))
+				goto next;
+
 			if (verbose)
 				printf("Restoring %s\n", path_name);
 			if (dry_run)
-- 
2.1.4

