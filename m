Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D17C677D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C21632075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C21632075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbeJKWbp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:50054 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726843AbeJKWbo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B293EB615
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:04:08 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/8] btrfs-progs: Remove fsid/metdata_uuid fields from fs_info
Date:   Thu, 11 Oct 2018 18:04:02 +0300
Message-Id: <1539270244-27076-7-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539270244-27076-1-git-send-email-nborisov@suse.com>
References: <1539270244-27076-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfstune.c     |  5 +++--
 check/main.c    |  2 +-
 chunk-recover.c | 11 +++++------
 ctree.c         | 11 ++++++-----
 ctree.h         |  2 --
 disk-io.c       | 18 +++++++++---------
 volumes.c       |  5 +++--
 7 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 29610476cd99..c1e4fa8067e8 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -360,7 +360,8 @@ static int change_fsid_prepare(struct btrfs_fs_info *fs_info)
 		return ret;
 
 	/* Also need to change the metadatauuid of the fs info */
-	memcpy(fs_info->metadata_uuid, fs_info->new_fsid, BTRFS_FSID_SIZE);
+	memcpy(fs_info->fs_devices->metadata_uuid, fs_info->new_fsid,
+	       BTRFS_FSID_SIZE);
 
 	/* also restore new chunk_tree_id into tree_root for restore */
 	write_extent_buffer(tree_root->node, fs_info->new_chunk_tree_uuid,
@@ -417,7 +418,7 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
 	fs_info->new_fsid = new_fsid;
 	fs_info->new_chunk_tree_uuid = new_chunk_id;
 
-	memcpy(old_fsid, (const char*)fs_info->fsid, BTRFS_UUID_SIZE);
+	memcpy(old_fsid, (const char*)fs_info->fs_devices->fsid, BTRFS_UUID_SIZE);
 	uuid_unparse(old_fsid, uuid_buf);
 	printf("Current fsid: %s\n", uuid_buf);
 
diff --git a/check/main.c b/check/main.c
index 0790264190f2..0aede2742dcf 100644
--- a/check/main.c
+++ b/check/main.c
@@ -8418,7 +8418,7 @@ static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(c, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(c, root->root_key.objectid);
 
-	write_extent_buffer(c, root->fs_info->metadata_uuid,
+	write_extent_buffer(c, root->fs_info->fs_devices->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
diff --git a/chunk-recover.c b/chunk-recover.c
index 31325bfc54e0..959c169f79a4 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1155,7 +1155,7 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_level(cow, 0);
 	btrfs_set_header_backref_rev(cow, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(cow, BTRFS_CHUNK_TREE_OBJECTID);
-	write_extent_buffer(cow, root->fs_info->metadata_uuid,
+	write_extent_buffer(cow, root->fs_info->fs_devices->metadata_uuid,
 			btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(cow, root->fs_info->chunk_tree_uuid,
@@ -1457,7 +1457,7 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 		goto out_devices;
 	}
 
-	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
+	ASSERT(!memcmp(disk_super->fsid, rc->fs_devices->fsid, BTRFS_FSID_SIZE));
 	fs_info->sectorsize = btrfs_super_sectorsize(disk_super);
 	fs_info->nodesize = btrfs_super_nodesize(disk_super);
 	fs_info->stripesize = btrfs_super_stripesize(disk_super);
@@ -1469,10 +1469,9 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 	features = btrfs_super_incompat_flags(disk_super);
 
 	if (features & BTRFS_FEATURE_INCOMPAT_METADATA_UUID)
-		memcpy(fs_info->metadata_uuid, disk_super->metadata_uuid,
-		       BTRFS_FSID_SIZE);
-	else
-		memcpy(fs_info->metadata_uuid, fs_info->fsid, BTRFS_FSID_SIZE);
+		ASSERT(!memcmp(disk_super->metadata_uuid,
+			       fs_info->fs_devices->metadata_uuid,
+			       BTRFS_FSID_SIZE));
 
 	btrfs_setup_root(fs_info->chunk_root, fs_info,
 			 BTRFS_CHUNK_TREE_OBJECTID);
diff --git a/ctree.c b/ctree.c
index 883c2ae1861d..c79837e0206f 100644
--- a/ctree.c
+++ b/ctree.c
@@ -23,6 +23,7 @@
 #include "internal.h"
 #include "sizes.h"
 #include "messages.h"
+#include "volumes.h"
 
 static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level);
@@ -134,7 +135,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, new_root_objectid);
 
-	write_extent_buffer(cow, root->fs_info->metadata_uuid,
+	write_extent_buffer(cow, root->fs_info->fs_devices->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
@@ -308,7 +309,7 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, root->root_key.objectid);
 
-	write_extent_buffer(cow, root->fs_info->metadata_uuid,
+	write_extent_buffer(cow, root->fs_info->fs_devices->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	WARN_ON(!(buf->flags & EXTENT_BAD_TRANSID) &&
@@ -1474,7 +1475,7 @@ static int noinline insert_new_root(struct btrfs_trans_handle *trans,
 
 	root_add_used(root, root->fs_info->nodesize);
 
-	write_extent_buffer(c, root->fs_info->metadata_uuid,
+	write_extent_buffer(c, root->fs_info->fs_devices->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
@@ -1595,7 +1596,7 @@ static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_set_header_generation(split, trans->transid);
 	btrfs_set_header_backref_rev(split, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(split, root->root_key.objectid);
-	write_extent_buffer(split, root->fs_info->metadata_uuid,
+	write_extent_buffer(split, root->fs_info->fs_devices->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 	write_extent_buffer(split, root->fs_info->chunk_tree_uuid,
 			    btrfs_header_chunk_tree_uuid(split),
@@ -2177,7 +2178,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(right, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(right, root->root_key.objectid);
 	btrfs_set_header_level(right, 0);
-	write_extent_buffer(right, root->fs_info->metadata_uuid,
+	write_extent_buffer(right, root->fs_info->fs_devices->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
diff --git a/ctree.h b/ctree.h
index ff2ae9fecc11..bf0c0ca86219 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1080,8 +1080,6 @@ struct btrfs_block_group_cache {
 struct btrfs_device;
 struct btrfs_fs_devices;
 struct btrfs_fs_info {
-	u8 fsid[BTRFS_FSID_SIZE];
-	u8 metadata_uuid[BTRFS_FSID_SIZE];
 	u8 *new_fsid;
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
 	u8 *new_chunk_tree_uuid;
diff --git a/disk-io.c b/disk-io.c
index c3be4a1017b7..e17fed13302b 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -118,7 +118,7 @@ static void print_tree_block_error(struct btrfs_fs_info *fs_info,
 		read_extent_buffer(eb, buf, btrfs_header_fsid(),
 				   BTRFS_UUID_SIZE);
 		uuid_unparse(buf, found_uuid);
-		uuid_unparse(fs_info->metadata_uuid, fs_uuid);
+		uuid_unparse(fs_info->fs_devices->metadata_uuid, fs_uuid);
 		fprintf(stderr, "fsid mismatch, want=%s, have=%s\n",
 			fs_uuid, found_uuid);
 		break;
@@ -1183,13 +1183,12 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		goto out_devices;
 	}
 
-	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
-	if (btrfs_fs_incompat(fs_info, METADATA_UUID)) {
-		memcpy(fs_info->metadata_uuid, disk_super->metadata_uuid,
-		       BTRFS_FSID_SIZE);
-	} else {
-		memcpy(fs_info->metadata_uuid, fs_info->fsid, BTRFS_FSID_SIZE);
-	}
+	ASSERT(!memcmp(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE));
+	ASSERT(!memcmp(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE));
+	if (btrfs_fs_incompat(fs_info, METADATA_UUID))
+		ASSERT(!memcmp(disk_super->metadata_uuid,
+			       fs_devices->metadata_uuid, BTRFS_FSID_SIZE));
+
 	fs_info->sectorsize = btrfs_super_sectorsize(disk_super);
 	fs_info->nodesize = btrfs_super_nodesize(disk_super);
 	fs_info->stripesize = btrfs_super_stripesize(disk_super);
@@ -1640,7 +1639,8 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
 		btrfs_set_stack_device_io_width(dev_item, dev->io_width);
 		btrfs_set_stack_device_sector_size(dev_item, dev->sector_size);
 		memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
-		memcpy(dev_item->fsid, fs_info->metadata_uuid, BTRFS_FSID_SIZE);
+		memcpy(dev_item->fsid, fs_info->fs_devices->metadata_uuid,
+		       BTRFS_FSID_SIZE);
 
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
diff --git a/volumes.c b/volumes.c
index b8388194c38f..e13f120e2296 100644
--- a/volumes.c
+++ b/volumes.c
@@ -732,7 +732,8 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	write_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
 	ptr = (unsigned long)btrfs_device_fsid(dev_item);
-	write_extent_buffer(leaf, fs_info->metadata_uuid, ptr, BTRFS_UUID_SIZE);
+	write_extent_buffer(leaf, fs_info->fs_devices->metadata_uuid, ptr,
+			    BTRFS_UUID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 	ret = 0;
 
@@ -2027,7 +2028,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 			   (unsigned long)btrfs_device_fsid(dev_item),
 			   BTRFS_FSID_SIZE);
 
-	if (memcmp(fs_uuid, fs_info->fsid, BTRFS_UUID_SIZE)) {
+	if (memcmp(fs_uuid, fs_info->fs_devices->fsid, BTRFS_UUID_SIZE)) {
 		ret = open_seed_devices(fs_info, fs_uuid);
 		if (ret)
 			return ret;
-- 
2.7.4

