Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F8AC10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D5A2206B6
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 16:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbfDPQma (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:42:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:36320 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729237AbfDPQm1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 12:42:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 48C22B0C6;
        Tue, 16 Apr 2019 16:42:25 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com,
        willy@infradead.org, hch@lst.de, darrick.wong@oracle.com,
        kilobyte@angband.pl, dsterba@suse.cz, nborisov@suse.com,
        linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 09/18] btrfs: Add dax specific address_space_operations
Date:   Tue, 16 Apr 2019 11:41:45 -0500
Message-Id: <20190416164154.30390-10-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/inode.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7fc778eb6bd2..c2c0544009a7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -28,6 +28,7 @@
 #include <linux/magic.h>
 #include <linux/iversion.h>
 #include <linux/swap.h>
+#include <linux/dax.h>
 #include <asm/unaligned.h>
 #include "ctree.h"
 #include "disk-io.h"
@@ -65,6 +66,7 @@ static const struct inode_operations btrfs_dir_ro_inode_operations;
 static const struct inode_operations btrfs_special_inode_operations;
 static const struct inode_operations btrfs_file_inode_operations;
 static const struct address_space_operations btrfs_aops;
+static const struct address_space_operations btrfs_dax_aops;
 static const struct file_operations btrfs_dir_file_operations;
 static const struct extent_io_ops btrfs_extent_io_ops;
 
@@ -3757,7 +3759,10 @@ static int btrfs_read_locked_inode(struct inode *inode,
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
-		inode->i_mapping->a_ops = &btrfs_aops;
+		if (btrfs_test_opt(fs_info, DAX))
+			inode->i_mapping->a_ops = &btrfs_dax_aops;
+		else
+			inode->i_mapping->a_ops = &btrfs_aops;
 		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
 		inode->i_fop = &btrfs_file_operations;
 		inode->i_op = &btrfs_file_inode_operations;
@@ -3778,6 +3783,7 @@ static int btrfs_read_locked_inode(struct inode *inode,
 	}
 
 	btrfs_sync_inode_flags_to_i_flags(inode);
+
 	return 0;
 }
 
@@ -6538,7 +6544,10 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	*/
 	inode->i_fop = &btrfs_file_operations;
 	inode->i_op = &btrfs_file_inode_operations;
-	inode->i_mapping->a_ops = &btrfs_aops;
+	if (IS_DAX(inode) && S_ISREG(mode))
+		inode->i_mapping->a_ops = &btrfs_dax_aops;
+	else
+		inode->i_mapping->a_ops = &btrfs_aops;
 
 	err = btrfs_init_inode_security(trans, inode, dir, &dentry->d_name);
 	if (err)
@@ -8665,6 +8674,15 @@ static int btrfs_writepages(struct address_space *mapping,
 	return extent_writepages(mapping, wbc);
 }
 
+static int btrfs_dax_writepages(struct address_space *mapping,
+			    struct writeback_control *wbc)
+{
+	struct inode *inode = mapping->host;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	return dax_writeback_mapping_range(mapping, fs_info->fs_devices->latest_bdev,
+			wbc);
+}
+
 static int
 btrfs_readpages(struct file *file, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
@@ -10436,7 +10454,10 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	inode->i_fop = &btrfs_file_operations;
 	inode->i_op = &btrfs_file_inode_operations;
 
-	inode->i_mapping->a_ops = &btrfs_aops;
+	if (IS_DAX(inode))
+		inode->i_mapping->a_ops = &btrfs_dax_aops;
+	else
+		inode->i_mapping->a_ops = &btrfs_aops;
 	BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
 
 	ret = btrfs_init_inode_security(trans, inode, dir, NULL);
@@ -10892,6 +10913,13 @@ static const struct address_space_operations btrfs_aops = {
 	.swap_deactivate = btrfs_swap_deactivate,
 };
 
+static const struct address_space_operations btrfs_dax_aops = {
+	.writepages             = btrfs_dax_writepages,
+	.direct_IO              = noop_direct_IO,
+	.set_page_dirty         = noop_set_page_dirty,
+	.invalidatepage         = noop_invalidatepage,
+};
+
 static const struct inode_operations btrfs_file_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
-- 
2.16.4

