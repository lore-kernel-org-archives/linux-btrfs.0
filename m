Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3722 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754844AbbBJK0s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:26:48 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQ2Jr000868
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:02 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH 6/9] btrfs: qgroup: fix limit args override whole limit struct
Date: Tue, 10 Feb 2015 18:23:20 +0800
Message-ID: <1423563803-8996-9-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_limit_group use arg limit to override the old qgroup_limit of
corresponding qgroup. However, we should override part of old qgroup_limit
according to the bit which has been set in arg limit.

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 953befd..34717ed 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1185,11 +1185,16 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 	}
 
 	spin_lock(&fs_info->qgroup_lock);
-	qgroup->lim_flags = limit->flags;
-	qgroup->max_rfer = limit->max_rfer;
-	qgroup->max_excl = limit->max_excl;
-	qgroup->rsv_rfer = limit->rsv_rfer;
-	qgroup->rsv_excl = limit->rsv_excl;
+	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
+		qgroup->max_rfer = limit->max_rfer;
+	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
+		qgroup->max_excl = limit->max_excl;
+	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_RFER)
+		qgroup->rsv_rfer = limit->rsv_rfer;
+	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_EXCL)
+		qgroup->rsv_excl = limit->rsv_excl;
+	qgroup->lim_flags |= limit->flags;
+
 	spin_unlock(&fs_info->qgroup_lock);
 
 	ret = update_qgroup_limit_item(trans, quota_root, qgroup);
-- 
1.8.4.2

