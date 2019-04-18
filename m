Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26C2C10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 11:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3874214DA
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 11:22:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="H3COmsMF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388703AbfDRLWv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 07:22:51 -0400
Received: from proxy22674.mail.163.com ([113.108.226.74]:53410 "EHLO
        proxy22674.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbfDRLWv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 07:22:51 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Apr 2019 07:22:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=+p4hmUoOzGvSUCMj7E
        a2jxUQ9gNsUw3Zf6GnGrJzpMo=; b=H3COmsMFfiseARRoMbHogsUI/gipWm+XFi
        W2Z17n0vQtpVl6ucsVQpU7td22FKYGXaCrE4In0ieqGTQAG6ov+OJo1GI5TztlTq
        v+9OmFAA8FLlVVuDn+0EQvO9f+w5mP+wsDMzq6diB91NOOJJjG2JJg3s48cFic+f
        yMrQDZXzc=
Received: from bp.localdomain (unknown [218.106.182.174])
        by smtp3 (Coremail) with SMTP id DdGowAA3PyMxWrhc30UvAA--.663S3;
        Thu, 18 Apr 2019 19:06:27 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [V2] btrfs: drop inode reference count on error path
Date:   Thu, 18 Apr 2019 19:06:16 +0800
Message-Id: <1555585576-31045-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: DdGowAA3PyMxWrhc30UvAA--.663S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr17uw17KF17Cr48Gr4kWFg_yoW5Xr17pF
        yfCwn5K395XryDurs2qF4jvr4Fq3Wvgw4UJrs09ws5ta1UAwsaqryYvr10ya43trWkCrWj
        qr4Ykw4UGFsrCw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UseOXUUUUU=
X-Originating-IP: [218.106.182.174]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiQBOaclSIaHS-VAAAsQ
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The reference count of inode is incremented by ihold. It should be
dropped if not used. However, the reference count is not dropped if
error occurs during updating the inode or deleting orphan items. This
patch fixes the bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
V2: move ihold just before device_initialize to make code clearer
---
 fs/btrfs/inode.c | 54 +++++++++++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 82fdda8..d6630df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6579,7 +6579,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 index;
 	int err;
-	int drop_inode = 0;
+	int log_mode;
 
 	/* do not allow sys_link's with other subvols of the same device */
 	if (root->root_key.objectid != BTRFS_I(inode)->root->root_key.objectid)
@@ -6616,41 +6616,37 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	err = btrfs_add_nondir(trans, BTRFS_I(dir), dentry, BTRFS_I(inode),
 			1, index);
 
-	if (err) {
-		drop_inode = 1;
-	} else {
-		struct dentry *parent = dentry->d_parent;
-		int ret;
+	if (err)
+		goto err_link;
 
-		err = btrfs_update_inode(trans, root, inode);
+	err = btrfs_update_inode(trans, root, inode);
+	if (err)
+		goto err_link;
+	if (inode->i_nlink == 1) {
+		/*
+		 * If new hard link count is 1, it's a file created
+		 * with open(2) O_TMPFILE flag.
+		 */
+		err = btrfs_orphan_del(trans, BTRFS_I(inode));
 		if (err)
-			goto fail;
-		if (inode->i_nlink == 1) {
-			/*
-			 * If new hard link count is 1, it's a file created
-			 * with open(2) O_TMPFILE flag.
-			 */
-			err = btrfs_orphan_del(trans, BTRFS_I(inode));
-			if (err)
-				goto fail;
-		}
-		BTRFS_I(inode)->last_link_trans = trans->transid;
-		d_instantiate(dentry, inode);
-		ret = btrfs_log_new_name(trans, BTRFS_I(inode), NULL, parent,
-					 true, NULL);
-		if (ret == BTRFS_NEED_TRANS_COMMIT) {
-			err = btrfs_commit_transaction(trans);
-			trans = NULL;
-		}
+			goto err_link;
+	}
+	BTRFS_I(inode)->last_link_trans = trans->transid;
+	ihold(inode);
+	d_instantiate(dentry, inode);
+	log_mode = btrfs_log_new_name(trans, BTRFS_I(inode), NULL,
+			dentry->d_parent, true, NULL);
+	if (log_mode == BTRFS_NEED_TRANS_COMMIT) {
+		err = btrfs_commit_transaction(trans);
+		trans = NULL;
 	}
 
+err_link:
+	if (err)
+		inode_dec_link_count(inode);
 fail:
 	if (trans)
 		btrfs_end_transaction(trans);
-	if (drop_inode) {
-		inode_dec_link_count(inode);
-		iput(inode);
-	}
 	btrfs_btree_balance_dirty(fs_info);
 	return err;
 }
-- 
2.7.4


