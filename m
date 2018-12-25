Return-Path: <SRS0=rxi5=PC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31130C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Dec 2018 05:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 004DE21736
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Dec 2018 05:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbeLYF2v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Dec 2018 00:28:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:37578 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725791AbeLYF2u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Dec 2018 00:28:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 81072AB9D
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Dec 2018 05:28:48 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Update backup roots when writing super blocks
Date:   Tue, 25 Dec 2018 13:28:45 +0800
Message-Id: <20181225052845.26322-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The code is mostly ported from kernel with minimal change.

Since btrfs-progs doesn't support replaying log, there is some code
unnecessary for btrfs-progs, but to keep the code the same, that
unnecessary code is kept as it.

Now "btrfs check --repair" will update backup roots correctly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index 133835a4d063..f28a6b526391 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1621,6 +1621,83 @@ write_err:
 	return ret;
 }
 
+/*
+ * copy all the root pointers into the super backup array.
+ * this will bump the backup pointer by one when it is
+ * done
+ */
+static void backup_super_roots(struct btrfs_fs_info *info)
+{
+	struct btrfs_root_backup *root_backup;
+	int next_backup;
+	int last_backup;
+
+	last_backup = find_best_backup_root(info->super_copy);
+	next_backup = (last_backup + 1) % BTRFS_NUM_BACKUP_ROOTS;
+
+	/* just overwrite the last backup if we're at the same generation */
+	root_backup = info->super_copy->super_roots + last_backup;
+	if (btrfs_backup_tree_root_gen(root_backup) ==
+	    btrfs_header_generation(info->tree_root->node))
+		next_backup = last_backup;
+
+	root_backup = info->super_copy->super_roots + next_backup;
+
+	/*
+	 * make sure all of our padding and empty slots get zero filled
+	 * regardless of which ones we use today
+	 */
+	memset(root_backup, 0, sizeof(*root_backup));
+	btrfs_set_backup_tree_root(root_backup, info->tree_root->node->start);
+	btrfs_set_backup_tree_root_gen(root_backup,
+			       btrfs_header_generation(info->tree_root->node));
+	btrfs_set_backup_tree_root_level(root_backup,
+			       btrfs_header_level(info->tree_root->node));
+
+	btrfs_set_backup_chunk_root(root_backup, info->chunk_root->node->start);
+	btrfs_set_backup_chunk_root_gen(root_backup,
+			       btrfs_header_generation(info->chunk_root->node));
+	btrfs_set_backup_chunk_root_level(root_backup,
+			       btrfs_header_level(info->chunk_root->node));
+
+	btrfs_set_backup_extent_root(root_backup, info->extent_root->node->start);
+	btrfs_set_backup_extent_root_gen(root_backup,
+			       btrfs_header_generation(info->extent_root->node));
+	btrfs_set_backup_extent_root_level(root_backup,
+			       btrfs_header_level(info->extent_root->node));
+	/*
+	 * we might commit during log recovery, which happens before we set
+	 * the fs_root.  Make sure it is valid before we fill it in.
+	 */
+	if (info->fs_root && info->fs_root->node) {
+		btrfs_set_backup_fs_root(root_backup,
+					 info->fs_root->node->start);
+		btrfs_set_backup_fs_root_gen(root_backup,
+			       btrfs_header_generation(info->fs_root->node));
+		btrfs_set_backup_fs_root_level(root_backup,
+			       btrfs_header_level(info->fs_root->node));
+	}
+
+	btrfs_set_backup_dev_root(root_backup, info->dev_root->node->start);
+	btrfs_set_backup_dev_root_gen(root_backup,
+			       btrfs_header_generation(info->dev_root->node));
+	btrfs_set_backup_dev_root_level(root_backup,
+				       btrfs_header_level(info->dev_root->node));
+
+	btrfs_set_backup_csum_root(root_backup, info->csum_root->node->start);
+	btrfs_set_backup_csum_root_gen(root_backup,
+			       btrfs_header_generation(info->csum_root->node));
+	btrfs_set_backup_csum_root_level(root_backup,
+			       btrfs_header_level(info->csum_root->node));
+
+	btrfs_set_backup_total_bytes(root_backup,
+			     btrfs_super_total_bytes(info->super_copy));
+	btrfs_set_backup_bytes_used(root_backup,
+			     btrfs_super_bytes_used(info->super_copy));
+	btrfs_set_backup_num_devices(root_backup,
+			     btrfs_super_num_devices(info->super_copy));
+};
+
 int write_all_supers(struct btrfs_fs_info *fs_info)
 {
 	struct list_head *head = &fs_info->fs_devices->devices;
@@ -1630,6 +1707,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
 	int ret;
 	u64 flags;
 
+	backup_super_roots(fs_info);
 	sb = fs_info->super_copy;
 	dev_item = &sb->dev_item;
 	list_for_each_entry(dev, head, dev_list) {
-- 
2.20.1

