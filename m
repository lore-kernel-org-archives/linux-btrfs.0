Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18331 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbcFQBrI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:47:08 -0400
Subject: [PATCH 09/20] xfs/122: fix test output to reflect latest xfsprogs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:46:58 -0700
Message-ID: <146612801892.25024.8323572138026562066.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we're getting rid of the rmapxbt, don't test for it.
Add back the log inode structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 46d1dd4..ebc4421 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -75,11 +75,11 @@ sizeof(struct xfs_extent_data) = 24
 sizeof(struct xfs_extent_data_info) = 32
 sizeof(struct xfs_fs_eofblocks) = 128
 sizeof(struct xfs_icreate_log) = 28
+sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
-sizeof(struct xfs_rmap_key) = 4
+sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
-sizeof(struct xfs_rmapx_key) = 20
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
 sizeof(xfs_agi_t) = 336

