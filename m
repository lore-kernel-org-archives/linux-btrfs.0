Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34769 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753724AbbEOGa3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 02:30:29 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 1/4] btrfs-progs: Minor change of change_uuid().
Date: Fri, 15 May 2015 14:28:23 +0800
Message-ID: <1431671306-22262-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change the change_uuid():
1) Remove new_chunk_tree_uuid para
As chunk_tree_uuid is only internal used, no need to manual specify it.
Use random generated UUID instead.

2) Don't use heap allocated memory for fs_info->new_fsid/chunk_tree_id.
It's easy to forgot free or double free heap memory.
Use stack memory instead.
(In fact, I forgot to free them in previous patchset)

3) Print dst fsid.
As now it's possible to change fsid to random uuid, it's better to print
it out.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c | 63 ++++++++++++++++++++++++++++---------------------------------
 1 file changed, 29 insertions(+), 34 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 7b8090a..36d7a00 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -293,36 +293,30 @@ static int change_fsid_done(struct btrfs_fs_info *fs_info)
 	return write_all_supers(fs_info->tree_root);
 }
 
-static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid,
-		       const char *new_chunk_uuid)
+/*
+ * Change fsid of a given fs.
+ *
+ * If new_fsid_str is not given, use a random generated UUID.
+ */
+static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
 {
+	uuid_t new_fsid;
+	uuid_t new_chunk_id;
+	char uuid_buf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret = 0;
 
 	/* caller should do extra check on passed uuid */
-	if (new_fsid) {
-		/* allocated mem will be freed at close_ctree() */
-		fs_info->new_fsid = malloc(BTRFS_FSID_SIZE);
-		if (!fs_info->new_fsid) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		ret = uuid_parse(new_fsid, fs_info->new_fsid);
-		if (ret < 0)
-			goto out;
-	}
+	if (new_fsid_str)
+		uuid_parse(new_fsid_str, new_fsid);
+	else
+		uuid_generate(new_fsid);
 
-	if (new_chunk_uuid) {
-		/* allocated mem will be freed at close_ctree() */
-		fs_info->new_chunk_tree_uuid = malloc(BTRFS_UUID_SIZE);
-		if (!fs_info->new_chunk_tree_uuid) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		ret = uuid_parse(new_chunk_uuid, fs_info->new_chunk_tree_uuid);
-		if (ret < 0)
-			goto out;
-	}
+	uuid_generate(new_chunk_id);
+	fs_info->new_fsid = new_fsid;
+	fs_info->new_chunk_tree_uuid = new_chunk_id;
 
+	uuid_unparse_upper(new_fsid, uuid_buf);
+	printf("Changing fsid to %s\n", uuid_buf);
 	/* Now we can begin fsid change */
 	ret = change_fsid_prepare(fs_info);
 	if (ret < 0)
@@ -342,19 +336,20 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid,
 		goto out;
 	}
 
-	/* Last, change fsid in super, only fsid change needs this */
-	if (new_fsid) {
-		memcpy(fs_info->fs_devices->fsid, fs_info->new_fsid,
-		       BTRFS_FSID_SIZE);
-		memcpy(fs_info->super_copy->fsid, fs_info->new_fsid,
-		       BTRFS_FSID_SIZE);
-		ret = write_all_supers(fs_info->tree_root);
-		if (ret < 0)
-			goto out;
-	}
+	/* Last, change fsid in super */
+	memcpy(fs_info->fs_devices->fsid, fs_info->new_fsid,
+	       BTRFS_FSID_SIZE);
+	memcpy(fs_info->super_copy->fsid, fs_info->new_fsid,
+	       BTRFS_FSID_SIZE);
+	ret = write_all_supers(fs_info->tree_root);
+	if (ret < 0)
+		goto out;
 
 	/* Now fsid change is done */
 	ret = change_fsid_done(fs_info);
+	fs_info->new_fsid = NULL;
+	fs_info->new_chunk_tree_uuid = NULL;
+	printf("Fsid changed to %s\n", uuid_buf);
 out:
 	return ret;
 }
-- 
2.4.0

