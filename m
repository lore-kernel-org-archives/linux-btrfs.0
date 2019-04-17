Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55842C282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 02:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 210BE21773
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 02:24:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LhJHzyyY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbfDQCYQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 22:24:16 -0400
Received: from m50-135.163.com ([123.125.50.135]:34420 "EHLO m50-135.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbfDQCYQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 22:24:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=jf9JCgMee4wUA0t3fQ
        g9zMVLthCu5mPOPOUXyNIR8Nk=; b=LhJHzyyYMwZbFrpKhKpPfBT5Ux09HgURM1
        lR2GTxadgkWytkWyutCXYzrEZkGMaN9WMovrVp1HdpQbzAR+17Te98FbmF1sEJjB
        NMfqlrC+SGx/T/d9a2g58YigDDzdWWWOZDKcSFkXOWnB30w17lRs6QIWchqAoBBb
        c9Of4Yx1g=
Received: from bp.localdomain (unknown [218.106.182.174])
        by smtp5 (Coremail) with SMTP id D9GowACnqwwojrZcVrYOAQ--.137S3;
        Wed, 17 Apr 2019 10:23:39 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: btrfs: drop inode reference count on error path
Date:   Wed, 17 Apr 2019 10:23:30 +0800
Message-Id: <1555467810-27859-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: D9GowACnqwwojrZcVrYOAQ--.137S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7ury7Ww1kXF4fKFykJr48Xrb_yoW8tFWUpF
        yfCwn3K395XryDurs2qF4jvr4Fqa4vgw48XrsFvws5tF47Arn7tryFvr18Kay7trWkCryj
        qr4Ykw4UWF47Cr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UDsqZUUUUU=
X-Originating-IP: [218.106.182.174]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiNgeZclWBeIWWqQAAsM
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
 fs/btrfs/inode.c | 45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 82fdda8..400c914 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6580,6 +6580,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	u64 index;
 	int err;
 	int drop_inode = 0;
+	int ret;
 
 	/* do not allow sys_link's with other subvols of the same device */
 	if (root->root_key.objectid != BTRFS_I(inode)->root->root_key.objectid)
@@ -6616,32 +6617,30 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	err = btrfs_add_nondir(trans, BTRFS_I(dir), dentry, BTRFS_I(inode),
 			1, index);
 
-	if (err) {
-		drop_inode = 1;
-	} else {
-		struct dentry *parent = dentry->d_parent;
-		int ret;
+	drop_inode = 1;
+	if (err)
+		goto fail;
 
-		err = btrfs_update_inode(trans, root, inode);
+	err = btrfs_update_inode(trans, root, inode);
+	if (err)
+		goto fail;
+	if (inode->i_nlink == 1) {
+		/*
+		 * If new hard link count is 1, it's a file created
+		 * with open(2) O_TMPFILE flag.
+		 */
+		err = btrfs_orphan_del(trans, BTRFS_I(inode));
 		if (err)
 			goto fail;
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
+	}
+	BTRFS_I(inode)->last_link_trans = trans->transid;
+	d_instantiate(dentry, inode);
+	drop_inode = 0;
+	ret = btrfs_log_new_name(trans, BTRFS_I(inode), NULL, dentry->d_parent,
+			true, NULL);
+	if (ret == BTRFS_NEED_TRANS_COMMIT) {
+		err = btrfs_commit_transaction(trans);
+		trans = NULL;
 	}
 
 fail:
-- 
2.7.4


