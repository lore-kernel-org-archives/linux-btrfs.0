Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748F1C2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 14:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3ACD82075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 14:43:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3ACD82075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbeJ3XhT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 19:37:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:42336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725853AbeJ3XhT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 19:37:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B74BCB0F6
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 14:43:32 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/6] btrfs: Remove fsid/metadata_fsid fields from btrfs_info
Date:   Tue, 30 Oct 2018 16:43:24 +0200
Message-Id: <1540910608-4121-3-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1540910608-4121-1-git-send-email-nborisov@suse.com>
References: <1540910608-4121-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently btrfs_fs_info structure contains a copy of the
fsid/metadata_uuid fields. Same values are also contained in the
btrfs_fs_devices structure which fs_info has a reference to. Let's
reduce duplication by removing the fields from fs_info and always refer
to the ones in fs_devices. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/check-integrity.c   |  2 +-
 fs/btrfs/ctree.c             |  5 +++--
 fs/btrfs/ctree.h             |  2 --
 fs/btrfs/disk-io.c           | 21 ++++++++++++---------
 fs/btrfs/extent-tree.c       |  2 +-
 fs/btrfs/ioctl.c             |  2 +-
 fs/btrfs/super.c             |  2 +-
 fs/btrfs/volumes.c           | 10 ++++------
 include/trace/events/btrfs.h |  2 +-
 9 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 2e43fba44035..781cae168d2a 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1720,7 +1720,7 @@ static int btrfsic_test_for_metadata(struct btrfsic_state *state,
 	num_pages = state->metablock_size >> PAGE_SHIFT;
 	h = (struct btrfs_header *)datav[0];
 
-	if (memcmp(h->fsid, fs_info->fsid, BTRFS_FSID_SIZE))
+	if (memcmp(h->fsid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE))
 		return 1;
 
 	for (i = 0; i < num_pages; i++) {
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 75cd41bf12f7..61f14a9836a1 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -12,6 +12,7 @@
 #include "transaction.h"
 #include "print-tree.h"
 #include "locking.h"
+#include "volumes.h"
 
 static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level);
@@ -224,7 +225,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, new_root_objectid);
 
-	write_extent_buffer_fsid(cow, fs_info->metadata_fsid);
+	write_extent_buffer_fsid(cow, fs_info->fs_devices->metadata_uuid);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (new_root_objectid == BTRFS_TREE_RELOC_OBJECTID)
@@ -1050,7 +1051,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, root->root_key.objectid);
 
-	write_extent_buffer_fsid(cow, fs_info->metadata_fsid);
+	write_extent_buffer_fsid(cow, fs_info->fs_devices->metadata_uuid);
 
 	ret = update_ref_for_cow(trans, root, buf, cow, &last_ref);
 	if (ret) {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 501ada9ec7bd..8531f0f5d672 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -749,8 +749,6 @@ struct btrfs_delayed_root;
 #define BTRFS_FS_BALANCE_RUNNING		18
 
 struct btrfs_fs_info {
-	u8 fsid[BTRFS_FSID_SIZE]; /* User-visible fs UUID */
-	u8 metadata_fsid[BTRFS_FSID_SIZE]; /* UUID written to btree blocks */
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
 	unsigned long flags;
 	struct btrfs_root *extent_root;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b76b18388b93..a458ef5b605e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -551,7 +551,7 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 	if (WARN_ON(!PageUptodate(page)))
 		return -EUCLEAN;
 
-	ASSERT(memcmp_extent_buffer(eb, fs_info->metadata_fsid,
+	ASSERT(memcmp_extent_buffer(eb, fs_info->fs_devices->metadata_uuid,
 			btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
 
 	return csum_tree_block(fs_info, eb, 0);
@@ -2490,11 +2490,12 @@ static int validate_super(struct btrfs_fs_info *fs_info,
 		ret = -EINVAL;
 	}
 
-	if (memcmp(fs_info->metadata_fsid, sb->dev_item.fsid,
+	if (memcmp(fs_info->fs_devices->metadata_uuid, sb->dev_item.fsid,
 		   BTRFS_FSID_SIZE) != 0) {
 		btrfs_err(fs_info,
 			   "dev_item UUID does not match metadata fsid: %pU != %pU",
-			   fs_info->metadata_fsid, sb->dev_item.fsid);
+			   fs_info->fs_devices->metadata_uuid,
+			   sb->dev_item.fsid);
 		ret = -EINVAL;
 	}
 
@@ -2834,14 +2835,16 @@ int open_ctree(struct super_block *sb,
 	       sizeof(*fs_info->super_for_commit));
 	brelse(bh);
 
-	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
+	ASSERT(!memcmp(fs_info->fs_devices->fsid, fs_info->super_copy->fsid,
+		       BTRFS_FSID_SIZE));
+
 	if (btrfs_fs_incompat(fs_info, METADATA_UUID)) {
-		memcpy(fs_info->metadata_fsid,
-		       fs_info->super_copy->metadata_uuid, BTRFS_FSID_SIZE);
-	} else {
-		memcpy(fs_info->metadata_fsid, fs_info->fsid, BTRFS_FSID_SIZE);
+		ASSERT(!memcmp(fs_info->fs_devices->metadata_uuid,
+				fs_info->super_copy->metadata_uuid,
+				BTRFS_FSID_SIZE));
 	}
 
+
 	ret = btrfs_validate_mount_super(fs_info);
 	if (ret) {
 		btrfs_err(fs_info, "superblock contains fatal errors");
@@ -2961,7 +2964,7 @@ int open_ctree(struct super_block *sb,
 
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
-	memcpy(&sb->s_uuid, fs_info->fsid, BTRFS_FSID_SIZE);
+	memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
 
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(fs_info);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 047fba06a8d8..c98638155652 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8169,7 +8169,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	btrfs_set_header_generation(buf, trans->transid);
 	btrfs_set_header_backref_rev(buf, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(buf, owner);
-	write_extent_buffer_fsid(buf, fs_info->metadata_fsid);
+	write_extent_buffer_fsid(buf, fs_info->fs_devices->metadata_uuid);
 	write_extent_buffer_chunk_tree_uuid(buf, fs_info->chunk_tree_uuid);
 	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
 		buf->log_index = root->log_transid % 2;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a990a9045139..510635e49319 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3135,7 +3135,7 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
 	}
 	rcu_read_unlock();
 
-	memcpy(&fi_args->fsid, fs_info->fsid, sizeof(fi_args->fsid));
+	memcpy(&fi_args->fsid, fs_devices->fsid, sizeof(fi_args->fsid));
 	fi_args->nodesize = fs_info->nodesize;
 	fi_args->sectorsize = fs_info->sectorsize;
 	fi_args->clone_alignment = fs_info->sectorsize;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b362b45dd757..1163183fe6dd 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2090,7 +2090,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u64 total_free_data = 0;
 	u64 total_free_meta = 0;
 	int bits = dentry->d_sb->s_blocksize_bits;
-	__be32 *fsid = (__be32 *)fs_info->fsid;
+	__be32 *fsid = (__be32 *)fs_info->fs_devices->fsid;
 	unsigned factor = 1;
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e3e12c94834f..bf0aa900f22c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1744,8 +1744,8 @@ static int btrfs_add_dev_item(struct btrfs_trans_handle *trans,
 	ptr = btrfs_device_uuid(dev_item);
 	write_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
 	ptr = btrfs_device_fsid(dev_item);
-	write_extent_buffer(leaf, trans->fs_info->metadata_fsid, ptr,
-			    BTRFS_FSID_SIZE);
+	write_extent_buffer(leaf, trans->fs_info->fs_devices->metadata_uuid,
+			    ptr, BTRFS_FSID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 
 	ret = 0;
@@ -2278,9 +2278,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	fs_devices->seed = seed_devices;
 
 	generate_random_uuid(fs_devices->fsid);
-	memcpy(fs_info->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
 	memcpy(fs_devices->metadata_uuid, fs_devices->fsid, BTRFS_FSID_SIZE);
-	memcpy(fs_info->metadata_fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
 	memcpy(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
 	mutex_unlock(&fs_devices->device_list_mutex);
 
@@ -2522,7 +2520,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		 * so rename the fsid on the sysfs
 		 */
 		snprintf(fsid_buf, BTRFS_UUID_UNPARSED_SIZE, "%pU",
-						fs_info->fsid);
+						fs_info->fs_devices->fsid);
 		if (kobject_rename(&fs_devices->fsid_kobj, fsid_buf))
 			btrfs_warn(fs_info,
 				   "sysfs: failed to create fsid for sprout");
@@ -6671,7 +6669,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 			   BTRFS_FSID_SIZE);
 
-	if (memcmp(fs_uuid, fs_info->metadata_fsid, BTRFS_FSID_SIZE)) {
+	if (memcmp(fs_uuid, fs_devices->metadata_uuid, BTRFS_FSID_SIZE)) {
 		fs_devices = open_seed_devices(fs_info, fs_uuid);
 		if (IS_ERR(fs_devices))
 			return PTR_ERR(fs_devices);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 8568946f491d..4b8400f7d4fa 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -92,7 +92,7 @@ TRACE_DEFINE_ENUM(COMMIT_TRANS);
 #define TP_STRUCT__entry_fsid __array(u8, fsid, BTRFS_FSID_SIZE)
 
 #define TP_fast_assign_fsid(fs_info)					\
-	memcpy(__entry->fsid, fs_info->fsid, BTRFS_FSID_SIZE)
+	memcpy(__entry->fsid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE)
 
 #define TP_STRUCT__entry_btrfs(args...)					\
 	TP_STRUCT__entry(						\
-- 
2.7.4

