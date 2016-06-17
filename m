Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18427 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbcFQBrd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:47:33 -0400
Subject: [PATCH 13/20] xfs/229: require 3GB of space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:47:24 -0700
Message-ID: <146612804411.25024.3885802903047011536.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test requires 3GB of space, so check for that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/229 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/229 b/tests/xfs/229
index c057677..b8fd914 100755
--- a/tests/xfs/229
+++ b/tests/xfs/229
@@ -50,6 +50,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 _supported_fs xfs
 _supported_os Linux
 _require_test
+_require_fs_space $TEST_DIR 3200000
 
 TDIR="${TEST_DIR}/t_holes"
 NFILES="10"

