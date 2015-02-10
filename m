Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24217 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754801AbbBJK0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:26:45 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAPx5Z000848
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:25:59 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/9] btrfs: qgroup: inherit limit info from srcgroup in creating snapshot.
Date: Tue, 10 Feb 2015 18:23:16 +0800
Message-ID: <1423563803-8996-5-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, when we snapshot a subvol, snapshot will not copy the limits
from srcqgroup.

This patch make the qgroup in snapshot inherit the limit info when create
a snapshot.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 97159a8..b2cee33 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2302,6 +2302,14 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		dstgroup->excl_cmpr = level_size;
 		srcgroup->excl = level_size;
 		srcgroup->excl_cmpr = level_size;
+
+		/* inherit the limit info */
+		dstgroup->lim_flags = srcgroup->lim_flags;
+		dstgroup->max_rfer = srcgroup->max_rfer;
+		dstgroup->max_excl = srcgroup->max_excl;
+		dstgroup->rsv_rfer = srcgroup->rsv_rfer;
+		dstgroup->rsv_excl = srcgroup->rsv_excl;
+
 		qgroup_dirty(fs_info, dstgroup);
 		qgroup_dirty(fs_info, srcgroup);
 	}
-- 
1.8.4.2

