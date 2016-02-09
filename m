Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23469 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861AbcBIBNM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Feb 2016 20:13:12 -0500
Subject: [PATCH 12/23] xfs/122: support refcount/rmap data structures
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Mon, 08 Feb 2016 17:13:03 -0800
Message-ID: <20160209011303.23099.40721.stgit@birch.djwong.org>
In-Reply-To: <20160209011145.23099.95354.stgit@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Include the refcount and rmap structures in the golden output.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122     |    3 +++
 tests/xfs/122.out |    4 ++++
 tests/xfs/group   |    2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/122 b/tests/xfs/122
index e6697a2..758cb50 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -90,6 +90,9 @@ xfs_da3_icnode_hdr
 xfs_dir3_icfree_hdr
 xfs_dir3_icleaf_hdr
 xfs_name
+xfs_owner_info
+xfs_refcount_irec
+xfs_rmap_irec
 xfs_alloctype_t
 xfs_buf_cancel_t
 xfs_bmbt_rec_32_t
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 8ba121e..c590166 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -75,6 +75,10 @@ sizeof(struct xfs_extent_data) = 24
 sizeof(struct xfs_extent_data_info) = 32
 sizeof(struct xfs_fs_eofblocks) = 128
 sizeof(struct xfs_icreate_log) = 28
+sizeof(struct xfs_refcount_key) = 4
+sizeof(struct xfs_refcount_rec) = 12
+sizeof(struct xfs_rmap_key) = 20
+sizeof(struct xfs_rmap_rec) = 24
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
 sizeof(xfs_agi_t) = 336
diff --git a/tests/xfs/group b/tests/xfs/group
index f0c1c2b..abf1d33 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -119,7 +119,7 @@
 119 log v2log auto freeze dangerous
 120 fuzzers
 121 log auto quick
-122 other auto quick
+122 other auto quick clone
 123 fuzzers
 124 fuzzers
 125 fuzzers

