Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DEAC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62E1F2075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62E1F2075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbeJKWbp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:50060 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727370AbeJKWbo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 020DBACB5
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:04:09 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 7/8] btrfs-progs: Remove btrfs_fs_info::new_fsid
Date:   Thu, 11 Oct 2018 18:04:03 +0300
Message-Id: <1539270244-27076-8-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539270244-27076-1-git-send-email-nborisov@suse.com>
References: <1539270244-27076-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This member was used only by btrfstune when using the old method to
change fsid. It's only an in-memory value with a very specific
purpose so it makes no sense to pollute a generic structure such as
btrfs_fs_info with it. Just remove it and pass it as a function
argument where pertinent. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfstune.c | 46 +++++++++++++++++++++-------------------------
 ctree.h     |  1 -
 2 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index c1e4fa8067e8..d093d26f288c 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -202,15 +202,15 @@ static int set_super_incompat_flags(struct btrfs_root *root, u64 flags)
 	return ret;
 }
 
-static int change_buffer_header_uuid(struct extent_buffer *eb)
+static int change_buffer_header_uuid(struct extent_buffer *eb, uuid_t new_fsid)
 {
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 	int same_fsid = 1;
 	int same_chunk_tree_uuid = 1;
 	int ret;
 
-	same_fsid = !memcmp_extent_buffer(eb, fs_info->new_fsid,
-			btrfs_header_fsid(), BTRFS_FSID_SIZE);
+	same_fsid = !memcmp_extent_buffer(eb, new_fsid, btrfs_header_fsid(),
+					  BTRFS_FSID_SIZE);
 	same_chunk_tree_uuid =
 		!memcmp_extent_buffer(eb, fs_info->new_chunk_tree_uuid,
 				btrfs_header_chunk_tree_uuid(eb),
@@ -218,7 +218,7 @@ static int change_buffer_header_uuid(struct extent_buffer *eb)
 	if (same_fsid && same_chunk_tree_uuid)
 		return 0;
 	if (!same_fsid)
-		write_extent_buffer(eb, fs_info->new_fsid, btrfs_header_fsid(),
+		write_extent_buffer(eb, new_fsid, btrfs_header_fsid(),
 				    BTRFS_FSID_SIZE);
 	if (!same_chunk_tree_uuid)
 		write_extent_buffer(eb, fs_info->new_chunk_tree_uuid,
@@ -229,7 +229,7 @@ static int change_buffer_header_uuid(struct extent_buffer *eb)
 	return ret;
 }
 
-static int change_extents_uuid(struct btrfs_fs_info *fs_info)
+static int change_extents_uuid(struct btrfs_fs_info *fs_info, uuid_t new_fsid)
 {
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_path path;
@@ -268,7 +268,7 @@ static int change_extents_uuid(struct btrfs_fs_info *fs_info)
 			ret = PTR_ERR(eb);
 			goto out;
 		}
-		ret = change_buffer_header_uuid(eb);
+		ret = change_buffer_header_uuid(eb, new_fsid);
 		free_extent_buffer(eb);
 		if (ret < 0) {
 			error("failed to change uuid of tree block: %llu",
@@ -290,27 +290,27 @@ static int change_extents_uuid(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-static int change_device_uuid(struct extent_buffer *eb, int slot)
+static int change_device_uuid(struct extent_buffer *eb, int slot,
+			      uuid_t new_fsid)
 {
 	struct btrfs_dev_item *di;
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 	int ret = 0;
 
 	di = btrfs_item_ptr(eb, slot, struct btrfs_dev_item);
-	if (!memcmp_extent_buffer(eb, fs_info->new_fsid,
+	if (!memcmp_extent_buffer(eb, new_fsid,
 				  (unsigned long)btrfs_device_fsid(di),
 				  BTRFS_FSID_SIZE))
 		return ret;
 
-	write_extent_buffer(eb, fs_info->new_fsid,
-			    (unsigned long)btrfs_device_fsid(di),
+	write_extent_buffer(eb, new_fsid, (unsigned long)btrfs_device_fsid(di),
 			    BTRFS_FSID_SIZE);
 	ret = write_tree_block(NULL, fs_info, eb);
 
 	return ret;
 }
 
-static int change_devices_uuid(struct btrfs_fs_info *fs_info)
+static int change_devices_uuid(struct btrfs_fs_info *fs_info, uuid_t new_fsid)
 {
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_path path;
@@ -328,7 +328,8 @@ static int change_devices_uuid(struct btrfs_fs_info *fs_info)
 		if (key.type != BTRFS_DEV_ITEM_KEY ||
 		    key.objectid != BTRFS_DEV_ITEMS_OBJECTID)
 			goto next;
-		ret = change_device_uuid(path.nodes[0], path.slots[0]);
+		ret = change_device_uuid(path.nodes[0], path.slots[0],
+					 new_fsid);
 		if (ret < 0)
 			goto out;
 next:
@@ -345,7 +346,7 @@ static int change_devices_uuid(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-static int change_fsid_prepare(struct btrfs_fs_info *fs_info)
+static int change_fsid_prepare(struct btrfs_fs_info *fs_info, uuid_t new_fsid)
 {
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	u64 flags = btrfs_super_flags(fs_info->super_copy);
@@ -354,14 +355,13 @@ static int change_fsid_prepare(struct btrfs_fs_info *fs_info)
 	flags |= BTRFS_SUPER_FLAG_CHANGING_FSID;
 	btrfs_set_super_flags(fs_info->super_copy, flags);
 
-	memcpy(fs_info->super_copy->fsid, fs_info->new_fsid, BTRFS_FSID_SIZE);
+	memcpy(fs_info->super_copy->fsid, new_fsid, BTRFS_FSID_SIZE);
 	ret = write_all_supers(fs_info);
 	if (ret < 0)
 		return ret;
 
 	/* Also need to change the metadatauuid of the fs info */
-	memcpy(fs_info->fs_devices->metadata_uuid, fs_info->new_fsid,
-	       BTRFS_FSID_SIZE);
+	memcpy(fs_info->fs_devices->metadata_uuid, new_fsid, BTRFS_FSID_SIZE);
 
 	/* also restore new chunk_tree_id into tree_root for restore */
 	write_extent_buffer(tree_root->node, fs_info->new_chunk_tree_uuid,
@@ -415,7 +415,6 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
 
 		uuid_generate(new_chunk_id);
 	}
-	fs_info->new_fsid = new_fsid;
 	fs_info->new_chunk_tree_uuid = new_chunk_id;
 
 	memcpy(old_fsid, (const char*)fs_info->fs_devices->fsid, BTRFS_UUID_SIZE);
@@ -426,13 +425,13 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
 	printf("New fsid: %s\n", uuid_buf);
 	/* Now we can begin fsid change */
 	printf("Set superblock flag CHANGING_FSID\n");
-	ret = change_fsid_prepare(fs_info);
+	ret = change_fsid_prepare(fs_info, new_fsid);
 	if (ret < 0)
 		goto out;
 
 	/* Change extents first */
 	printf("Change fsid in extents\n");
-	ret = change_extents_uuid(fs_info);
+	ret = change_extents_uuid(fs_info, new_fsid);
 	if (ret < 0) {
 		error("failed to change UUID of metadata: %d", ret);
 		goto out;
@@ -440,17 +439,15 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
 
 	/* Then devices */
 	printf("Change fsid on devices\n");
-	ret = change_devices_uuid(fs_info);
+	ret = change_devices_uuid(fs_info, new_fsid);
 	if (ret < 0) {
 		error("failed to change UUID of devices: %d", ret);
 		goto out;
 	}
 
 	/* Last, change fsid in super */
-	memcpy(fs_info->fs_devices->fsid, fs_info->new_fsid,
-	       BTRFS_FSID_SIZE);
-	memcpy(fs_info->super_copy->fsid, fs_info->new_fsid,
-	       BTRFS_FSID_SIZE);
+	memcpy(fs_info->fs_devices->fsid, new_fsid, BTRFS_FSID_SIZE);
+	memcpy(fs_info->super_copy->fsid, new_fsid, BTRFS_FSID_SIZE);
 	ret = write_all_supers(fs_info);
 	if (ret < 0)
 		goto out;
@@ -458,7 +455,6 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
 	/* Now fsid change is done */
 	printf("Clear superblock flag CHANGING_FSID\n");
 	ret = change_fsid_done(fs_info);
-	fs_info->new_fsid = NULL;
 	fs_info->new_chunk_tree_uuid = NULL;
 	printf("Fsid change finished\n");
 out:
diff --git a/ctree.h b/ctree.h
index bf0c0ca86219..3938e8e8b0e5 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1080,7 +1080,6 @@ struct btrfs_block_group_cache {
 struct btrfs_device;
 struct btrfs_fs_devices;
 struct btrfs_fs_info {
-	u8 *new_fsid;
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
 	u8 *new_chunk_tree_uuid;
 	struct btrfs_root *fs_root;
-- 
2.7.4

