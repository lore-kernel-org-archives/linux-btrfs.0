Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24217 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754801AbbBJK0r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:26:47 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQ1ef000865
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:01 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 5/9] btrfs: qgroup: update limit info in function btrfs_run_qgroups().
Date: Tue, 10 Feb 2015 18:23:19 +0800
Message-ID: <1423563803-8996-8-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we commit_transaction(), qgroups in btree should be updated.
But, limit info is not considered currently. It will cause a problem
when a qgroup of a snapshot inherit the limit info from srcqgroup,
then there is an inconsistency.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a7ffebb..953befd 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2154,6 +2154,10 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		if (ret)
 			fs_info->qgroup_flags |=
 					BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		ret = update_qgroup_limit_item(trans, quota_root, qgroup);
+		if (ret)
+			fs_info->qgroup_flags |=
+					BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 		spin_lock(&fs_info->qgroup_lock);
 	}
 	if (fs_info->quota_enabled)
-- 
1.8.4.2

