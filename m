Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39449 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbbLSJLd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Dec 2015 04:11:33 -0500
Subject: [PATCH 05/11] xfs/129: require loop
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Sat, 19 Dec 2015 01:11:25 -0800
Message-ID: <20151219091125.15320.31598.stgit@birch.djwong.org>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Missed a _require_loop for xfs/129.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/129 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/129 b/tests/xfs/129
index 6fb9bac..c8c47a2 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -46,6 +46,7 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _supported_fs xfs
+_require_loop
 _require_scratch_reflink
 
 rm -f "$seqres.full"

