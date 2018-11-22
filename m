Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07EDC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 13:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0B9420684
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 13:15:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0B9420684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391080AbeKVXy4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 18:54:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:50504 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727034AbeKVXyz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 18:54:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2A48ABE2
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 13:15:36 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] btrfs: improve error handling of btrfs_add_link()
Date:   Thu, 22 Nov 2018 14:15:28 +0100
Message-Id: <20181122131528.19421-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

err holds the return value of either btrfs_del_root_ref() or
btrfs_del_inode_ref() but it hasn't been checked since it's
introduction with commit fe66a05a0679 (Btrfs: improve error handling
for btrfs_insert_dir_item callers) in 2012.

The first attempt in removing the variable was rejected, so instead of
removing 'err', start handling the errors of
btrfs_del_root_ref()/btrfs_del_inode_ref() by aborting the transaction in
btrfs_add_link() directly instead of the call-sites.

Link: https://lore.kernel.org/linux-btrfs/20181119141323.GC24115@twin.jikos.cz/
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/inode.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9becf8543489..314142ea9d80 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6351,6 +6351,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = parent_inode->root;
 	u64 ino = btrfs_ino(inode);
 	u64 parent_ino = btrfs_ino(parent_inode);
+	int err = 0;
 
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		memcpy(&key, &inode->root->root_key, sizeof(key));
@@ -6395,18 +6396,20 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 fail_dir_item:
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		u64 local_index;
-		int err;
+
 		err = btrfs_del_root_ref(trans, key.objectid,
 					 root->root_key.objectid, parent_ino,
 					 &local_index, name, name_len);
 
 	} else if (add_backref) {
 		u64 local_index;
-		int err;
 
 		err = btrfs_del_inode_ref(trans, root, name, name_len,
 					  ino, parent_ino, &local_index);
 	}
+
+	btrfs_abort_transaction(trans, err ? err : ret);
+
 	return ret;
 }
 
@@ -9502,18 +9505,14 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	ret = btrfs_add_link(trans, BTRFS_I(new_dir), BTRFS_I(old_inode),
 			     new_dentry->d_name.name,
 			     new_dentry->d_name.len, 0, old_idx);
-	if (ret) {
-		btrfs_abort_transaction(trans, ret);
+	if (ret)
 		goto out_fail;
-	}
 
 	ret = btrfs_add_link(trans, BTRFS_I(old_dir), BTRFS_I(new_inode),
 			     old_dentry->d_name.name,
 			     old_dentry->d_name.len, 0, new_idx);
-	if (ret) {
-		btrfs_abort_transaction(trans, ret);
+	if (ret)
 		goto out_fail;
-	}
 
 	if (old_inode->i_nlink == 1)
 		BTRFS_I(old_inode)->dir_index = old_idx;
@@ -9822,10 +9821,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	ret = btrfs_add_link(trans, BTRFS_I(new_dir), BTRFS_I(old_inode),
 			     new_dentry->d_name.name,
 			     new_dentry->d_name.len, 0, index);
-	if (ret) {
-		btrfs_abort_transaction(trans, ret);
+	if (ret)
 		goto out_fail;
-	}
 
 	if (old_inode->i_nlink == 1)
 		BTRFS_I(old_inode)->dir_index = index;
-- 
2.16.4

