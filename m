Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5674EC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28C0220823
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:38:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28C0220823
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbeKSUBl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 15:01:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:60160 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727306AbeKSUBl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 15:01:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CE34FAEC6
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 09:38:35 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 1/5] btrfs: remove unused drop_on_err in btrfs_mkdir()
Date:   Mon, 19 Nov 2018 10:38:13 +0100
Message-Id: <20181119093817.9291-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181119093817.9291-1-jthumshirn@suse.de>
References: <20181119093817.9291-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Up to commit 32955c5422a8 (btrfs: switch to discard_new_inode()) the
drop_on_err variable in btrfs_mkdir() was used to check whether the inode had
to be dropped via iput().

After commit 32955c5422a8 (btrfs: switch to discard_new_inode())
discard_new_inode() is called when err is set and inode is non NULL. Therefore
drop_on_err is not used anymore and thus causes a warning when building with
-Wunused-but-set-variable.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2585200cb43a..9becf8543489 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6645,7 +6645,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	int err = 0;
-	int drop_on_err = 0;
 	u64 objectid = 0;
 	u64 index = 0;
 
@@ -6671,7 +6670,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		goto out_fail;
 	}
 
-	drop_on_err = 1;
 	/* these must be set before we unlock the inode */
 	inode->i_op = &btrfs_dir_inode_operations;
 	inode->i_fop = &btrfs_dir_file_operations;
@@ -6692,7 +6690,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		goto out_fail;
 
 	d_instantiate_new(dentry, inode);
-	drop_on_err = 0;
 
 out_fail:
 	btrfs_end_transaction(trans);
-- 
2.16.4

