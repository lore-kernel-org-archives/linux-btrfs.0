Return-Path: <SRS0=jJu9=25=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6787C282DD
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jan 2020 13:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96A2C206F0
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jan 2020 13:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgAHNDQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 08:03:16 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:38338 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726144AbgAHNDQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Jan 2020 08:03:16 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A6D2FF6E7B2383C863CD;
        Wed,  8 Jan 2020 21:03:13 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 8 Jan 2020
 21:03:05 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>
CC:     <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] btrfs: remove set but not used variable 'root_objectid'
Date:   Wed, 8 Jan 2020 20:58:35 +0800
Message-ID: <20200108125835.45768-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

fs/btrfs/inode.c: In function btrfs_rename:
fs/btrfs/inode.c:9196:6: warning: variable root_objectid set but not used [-Wunused-but-set-variable]

commit f8b3030e0807 ("btrfs: rework arguments of btrfs_unlink_subvol")
left behind this unused variable.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/btrfs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 493c0fe..990f509 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9204,7 +9204,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct inode *new_inode = d_inode(new_dentry);
 	struct inode *old_inode = d_inode(old_dentry);
 	u64 index = 0;
-	u64 root_objectid;
 	int ret;
 	u64 old_ino = btrfs_ino(BTRFS_I(old_inode));
 	bool log_pinned = false;
@@ -9331,7 +9330,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		new_inode->i_ctime = current_time(new_inode);
 		if (unlikely(btrfs_ino(BTRFS_I(new_inode)) ==
 			     BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
-			root_objectid = BTRFS_I(new_inode)->location.objectid;
 			ret = btrfs_unlink_subvol(trans, new_dir, new_dentry);
 			BUG_ON(new_inode->i_nlink == 0);
 		} else {
-- 
2.7.4


