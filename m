Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42531 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753761AbbEOGa3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 02:30:29 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 2/4] btrfs-progs: Add ability to restore unfinished fsid change.
Date: Fri, 15 May 2015 14:28:24 +0800
Message-ID: <1431671306-22262-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431671306-22262-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431671306-22262-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now change_uuid() can auto detected unfinished fsid change and restore
it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 7 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 36d7a00..1d5af33 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -267,7 +267,9 @@ out:
 
 static int change_fsid_prepare(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_root *tree_root = fs_info->tree_root;
 	u64 flags = btrfs_super_flags(fs_info->super_copy);
+	int ret = 0;
 
 	if (!fs_info->new_fsid && !fs_info->new_chunk_tree_uuid)
 		return 0;
@@ -276,7 +278,16 @@ static int change_fsid_prepare(struct btrfs_fs_info *fs_info)
 		flags |= BTRFS_SUPER_FLAG_CHANGING_FSID;
 	btrfs_set_super_flags(fs_info->super_copy, flags);
 
-	return write_all_supers(fs_info->tree_root);
+	memcpy(fs_info->super_copy->fsid, fs_info->new_fsid, BTRFS_FSID_SIZE);
+	ret = write_all_supers(tree_root);
+	if (ret < 0)
+		return ret;
+
+	/* also restore new chunk_tree_id into tree_root for restore */
+	write_extent_buffer(tree_root->node, fs_info->new_chunk_tree_uuid,
+			    btrfs_header_chunk_tree_uuid(tree_root->node),
+			    BTRFS_UUID_SIZE);
+	return write_tree_block(NULL, tree_root, tree_root->node);
 }
 
 static int change_fsid_done(struct btrfs_fs_info *fs_info)
@@ -294,9 +305,31 @@ static int change_fsid_done(struct btrfs_fs_info *fs_info)
 }
 
 /*
+ * Return 0 for no unfinished fsid change.
+ * Return >0 for unfinished fsid change, and restore unfinished fsid/
+ * chunk_tree_id into fsid_ret/chunk_id_ret.
+ */
+static int check_unfinished_fsid_change(struct btrfs_fs_info *fs_info,
+					uuid_t fsid_ret, uuid_t chunk_id_ret)
+{
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	u64 flags = btrfs_super_flags(fs_info->super_copy);
+
+	if (flags & BTRFS_SUPER_FLAG_CHANGING_FSID) {
+		memcpy(fsid_ret, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
+		read_extent_buffer(tree_root->node, chunk_id_ret,
+				btrfs_header_chunk_tree_uuid(tree_root->node),
+				BTRFS_UUID_SIZE);
+		return 1;
+	}
+	return 0;
+}
+
+/*
  * Change fsid of a given fs.
  *
  * If new_fsid_str is not given, use a random generated UUID.
+ * Caller should check new_fsid_str is valid
  */
 static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
 {
@@ -305,13 +338,26 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
 	char uuid_buf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret = 0;
 
-	/* caller should do extra check on passed uuid */
-	if (new_fsid_str)
-		uuid_parse(new_fsid_str, new_fsid);
-	else
-		uuid_generate(new_fsid);
+	if (check_unfinished_fsid_change(fs_info, new_fsid, new_chunk_id)) {
+		if (new_fsid_str) {
+			uuid_t tmp;
 
-	uuid_generate(new_chunk_id);
+			uuid_parse(new_fsid_str, tmp);
+			if (memcmp(tmp, new_fsid, BTRFS_FSID_SIZE)) {
+				fprintf(stderr,
+					"ERROR: New fsid %s is not the same with unfinished fsid change\n",
+					new_fsid_str);
+				return -EINVAL;
+			}
+		}
+	} else {
+		if (new_fsid_str)
+			uuid_parse(new_fsid_str, new_fsid);
+		else
+			uuid_generate(new_fsid);
+
+		uuid_generate(new_chunk_id);
+	}
 	fs_info->new_fsid = new_fsid;
 	fs_info->new_chunk_tree_uuid = new_chunk_id;
 
-- 
2.4.0

