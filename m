Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27258 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755105AbbBJK1r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:47 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAR18m000962
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:27:01 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/7] btrfs: qgroup: Apply type to btrfs_qgroup_inherit().
Date: Tue, 10 Feb 2015 18:24:17 +0800
Message-ID: <1423563862-9151-7-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now, we have a type in each qgroup, then when we do a inherit(),
we need to consider the type of qgroup to decide account metadata
or not.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2fa8497..0129dae 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2382,10 +2382,20 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		dstgroup->type = srcgroup->type;
 		dstgroup->rfer = srcgroup->rfer;
 		dstgroup->rfer_cmpr = srcgroup->rfer_cmpr;
-		dstgroup->excl = level_size;
-		dstgroup->excl_cmpr = level_size;
-		srcgroup->excl = level_size;
-		srcgroup->excl_cmpr = level_size;
+		if (dstgroup->type & BTRFS_QGROUP_TYPE_METADATA) {
+			dstgroup->excl = level_size;
+			dstgroup->excl_cmpr = level_size;
+		} else {
+			dstgroup->excl = 0;
+			dstgroup->excl_cmpr = 0;
+		}
+		if (srcgroup->type & BTRFS_QGROUP_TYPE_METADATA) {
+			srcgroup->excl = level_size;
+			srcgroup->excl_cmpr = level_size;
+		} else {
+			srcgroup->excl = 0;
+			srcgroup->excl_cmpr = 0;
+		}
 
 		/* inherit the limit info */
 		dstgroup->lim_flags = srcgroup->lim_flags;
-- 
1.8.4.2

