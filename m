Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B219EC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 07:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89D0321736
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 07:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbeLXHl5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Dec 2018 02:41:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:33004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726702AbeLXHl5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Dec 2018 02:41:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5F42EADDF;
        Mon, 24 Dec 2018 07:41:54 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Peter Chant <pete@petezilla.co.uk>
Subject: [PATCH] btrfs: Validate generation of btrfs super blocks before writing it to disk
Date:   Mon, 24 Dec 2018 15:41:50 +0800
Message-Id: <20181224074150.2722-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[PROBLEM]
One user reports strange super block generation like:
  generation              7937947
        backup 0:
                backup_tree_root:       1113909100544   gen: 7937935    level: 1
        backup 1:
                backup_tree_root:       1113907347456   gen: 7937936    level: 1
        backup 2:
                backup_tree_root:       1113911951360   gen: 7937937    level: 1
        backup 3:
                backup_tree_root:       1113907494912   gen: 7937934    level: 1

sb gen:		7937947 = 0x791f9b
backup gen:	7937937 = 0x791f91

The reason why such mismatch happens is still uknown, but one assumption
is 2 bits flipped at runtime.

[SOLUTION]
Even we did super block verification in commit 75cb857d2618
("btrfs: Do super block verification before writing it to disk"), it
doesn't check generation against transaction as generation corruption is
not that obvious.
This allows super block generation corruption sneak in.

So in this patch, btrfs will check super block generation by:
- Check it against expected transid
  We have 2 different callers who writes all super blocks:
  * btrfs_commit_transaction()
    The expected generation is trans->transid.
  * btrfs_sync_log()
    The expected generation is trans->transid - 1, since we only
    update log_root, while not updating generation.

- Chech it against backup roots
  If we have any valid backup roots (new fs can have no backup root at
  all), we should find one backup root matching the generation, and no
  backup root newer than current generation.

With above solution, at least we should be able to catch potential
generation corruption early on.

Reported-by: Peter Chant <pete@petezilla.co.uk>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c     | 49 +++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/disk-io.h     |  2 +-
 fs/btrfs/transaction.c |  2 +-
 fs/btrfs/tree-log.c    |  2 +-
 4 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5228320030a5..c972baafe664 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2573,9 +2573,14 @@ static int btrfs_validate_mount_super(struct btrfs_fs_info *fs_info)
  * Extra checks like csum type and incompat flags will be done here.
  */
 static int btrfs_validate_write_super(struct btrfs_fs_info *fs_info,
-				      struct btrfs_super_block *sb)
+				      struct btrfs_super_block *sb,
+				      u64 expected_gen)
 {
+	u64 sb_gen = btrfs_super_generation(sb);
+	u64 newest_gen = 0;
+	bool found = false;
 	int ret;
+	int i;
 
 	ret = validate_super(fs_info, sb, -1);
 	if (ret < 0)
@@ -2594,6 +2599,44 @@ static int btrfs_validate_write_super(struct btrfs_fs_info *fs_info,
 			  (unsigned long long)BTRFS_FEATURE_INCOMPAT_SUPP);
 		goto out;
 	}
+
+	/* super block generation check */
+	if (sb_gen != expected_gen) {
+		ret = -EUCLEAN;
+		btrfs_err(fs_info,
+			"invalid generation detected, has %llu expect %llu",
+			sb_gen, expected_gen);
+		goto out;
+	}
+
+	/* check against backup roots */
+	for (i = 0; i < BTRFS_NUM_BACKUP_ROOTS; i++) {
+		struct btrfs_root_backup *root_backup = sb->super_roots + i;
+		u64 backup_gen = btrfs_backup_tree_root_gen(root_backup);
+
+		if (backup_gen > sb_gen) {
+			ret = -EUCLEAN;
+			btrfs_err(fs_info,
+	"invalid backup root generation detected, slot %u has %llu expect <%llu",
+				  i, backup_gen, sb_gen);
+			goto out;
+		}
+		newest_gen = max(newest_gen, backup_gen);
+		if (backup_gen == expected_gen)
+			found = true;
+	}
+
+	/*
+	 * If we have any valid backup roots but still fail to find one
+	 * matching sb generation, either backup roots or sb itself is
+	 * corrupted.
+	 */
+	if (newest_gen && !found && newest_gen < expected_gen) {
+		ret = -EUCLEAN;
+		btrfs_err(fs_info,
+"no backup root generation matches current, found newest %llu expect %llu",
+			  newest_gen, expected_gen);
+	}
 out:
 	if (ret < 0)
 		btrfs_err(fs_info,
@@ -3721,7 +3764,7 @@ int btrfs_get_num_tolerated_disk_barrier_failures(u64 flags)
 	return min_tolerated;
 }
 
-int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
+int write_all_supers(struct btrfs_fs_info *fs_info, u64 gen, int max_mirrors)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
@@ -3786,7 +3829,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
 
-		ret = btrfs_validate_write_super(fs_info, sb);
+		ret = btrfs_validate_write_super(fs_info, sb, gen);
 		if (ret < 0) {
 			mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 			btrfs_handle_fs_error(fs_info, -EUCLEAN,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 4cccba22640f..9f8fd0a9a3a4 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -53,7 +53,7 @@ int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options);
 void close_ctree(struct btrfs_fs_info *fs_info);
-int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
+int write_all_supers(struct btrfs_fs_info *fs_info, u64 gen, int max_mirrors);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
 int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 			struct buffer_head **bh_ret);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d1eeef9ec5da..b61cec2780b9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2241,7 +2241,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		goto scrub_continue;
 	}
 
-	ret = write_all_supers(fs_info, 0);
+	ret = write_all_supers(fs_info, trans->transid, 0);
 	/*
 	 * the super is written, we can safely allow the tree-loggers
 	 * to go about their business
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e07f3376b7df..4f84345fdbb6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3155,7 +3155,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	 * the running transaction open, so a full commit can't hop
 	 * in and cause problems either.
 	 */
-	ret = write_all_supers(fs_info, 1);
+	ret = write_all_supers(fs_info, trans->transid - 1, 1);
 	if (ret) {
 		btrfs_set_log_full_commit(fs_info, trans);
 		btrfs_abort_transaction(trans, ret);
-- 
2.20.1

