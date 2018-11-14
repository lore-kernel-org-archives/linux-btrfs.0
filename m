Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C1EC07E85
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2BA922419
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2BA922419
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732575AbeKNXiq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:38:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:52888 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728085AbeKNXiq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:38:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3FD2BB086
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:35:28 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 1/6] btrfs: remove unused drop_on_err in btrfs_mkdir()
Date:   Wed, 14 Nov 2018 14:35:15 +0100
Message-Id: <20181114133520.16069-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181114133520.16069-1-jthumshirn@suse.de>
References: <20181114133520.16069-1-jthumshirn@suse.de>
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
---
 fs/btrfs/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4a2f9f7fd96e..7d17b0a654e6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6677,7 +6677,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	int err = 0;
-	int drop_on_err = 0;
 	u64 objectid = 0;
 	u64 index = 0;
 
@@ -6703,7 +6702,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		goto out_fail;
 	}
 
-	drop_on_err = 1;
 	/* these must be set before we unlock the inode */
 	inode->i_op = &btrfs_dir_inode_operations;
 	inode->i_fop = &btrfs_dir_file_operations;
@@ -6724,7 +6722,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		goto out_fail;
 
 	d_instantiate_new(dentry, inode);
-	drop_on_err = 0;
 
 out_fail:
 	btrfs_end_transaction(trans);
-- 
2.16.4

