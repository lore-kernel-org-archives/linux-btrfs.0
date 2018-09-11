Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:51677 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726798AbeIKQ2I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 12:28:08 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9E11D4B6ADFF
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 19:29:11 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH v2 2/4] btrfs: don't BUG_ON() in btrfs_link_subvol()
Date: Tue, 11 Sep 2018 19:29:01 +0800
Message-ID: <20180911112903.25985-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
References: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Both of btrfs_update_inode() and btrfs_add_root_ref() may fail because
of ENOMEM. So there's no reason to panic here, we can replace BUG_ON()
with btrfs_abort_transaction() here.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1b03d07acde2..f6173d4e7ced 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -572,11 +572,17 @@ static int btrfs_link_subvol(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(BTRFS_I(dir), dir->i_size + namelen * 2);
 	ret = btrfs_update_inode(trans, root, dir);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
 
 	ret = btrfs_add_root_ref(trans, objectid, root->root_key.objectid,
 				 btrfs_ino(BTRFS_I(dir)), index, name, namelen);
-	BUG_ON(ret);
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
 
 	return ret;
 }
-- 
2.18.0
