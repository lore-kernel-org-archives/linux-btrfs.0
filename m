Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35413 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbcFQBrM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:47:12 -0400
Subject: [PATCH 10/20] xfs/122: list the new log redo items
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:47:05 -0700
Message-ID: <146612802514.25024.7488322050997745494.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

List the new log redo items.  These should have stable sizes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122.out |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index ebc4421..c4ed725 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -60,7 +60,11 @@ sizeof(struct xfs_attr3_leaf_hdr) = 80
 sizeof(struct xfs_attr3_leafblock) = 88
 sizeof(struct xfs_attr3_rmt_hdr) = 56
 sizeof(struct xfs_btree_block) = 72
+sizeof(struct xfs_bud_log_format) = 48
+sizeof(struct xfs_bui_log_format) = 48
 sizeof(struct xfs_clone_args) = 32
+sizeof(struct xfs_cud_log_format) = 32
+sizeof(struct xfs_cui_log_format) = 32
 sizeof(struct xfs_da3_blkinfo) = 56
 sizeof(struct xfs_da3_intnode) = 64
 sizeof(struct xfs_da3_node_hdr) = 64
@@ -76,10 +80,14 @@ sizeof(struct xfs_extent_data_info) = 32
 sizeof(struct xfs_fs_eofblocks) = 128
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_log_dinode) = 176
+sizeof(struct xfs_map_extent) = 32
+sizeof(struct xfs_phys_extent) = 16
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
 sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
+sizeof(struct xfs_rud_log_format) = 48
+sizeof(struct xfs_rui_log_format) = 48
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
 sizeof(xfs_agi_t) = 336

