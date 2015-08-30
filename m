Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59942 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbbH3OrV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Aug 2015 10:47:21 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 31 Aug 2015 00:47:19 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chandan@mykolab.com
Subject: [PATCH] generic/224: Increase filesystem instance size to 1.5 GiB
Date: Sun, 30 Aug 2015 20:16:21 +0530
Message-Id: <1440945981-323-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For small filesystem instances (i.e. size <= 1 GiB), mkfs.btrfs fails when
"data block size" does not match with the "metadata block size" specified on
the mkfs.btrfs command line. This commit increases the size of filesystem
instance created so that the test can be executed on subpagesize-blocksize
Btrfs instances which have different values for data and metadata blocksizes.

Increasing the filesystem size had a negligible impact on the runtime of the
test as indicated by the following table:

|------------+--------------+----------------|
| Filesystem | 1GiB FS size | 1.5GiB FS size |
|------------+--------------+----------------|
| Btrfs      | 21secs       | 24secs         |
| Ext4       | 12secs       | 15secs         |
| Xfs        | 10secs       | 11secs         |
|------------+--------------+----------------|

Timing information reported in the above table were the worst-case times
observed when running the test on a spinning disk.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/generic/224 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/generic/224 b/tests/generic/224
index 391d877..8fae187 100755
--- a/tests/generic/224
+++ b/tests/generic/224
@@ -53,8 +53,9 @@ _supported_os Linux
 
 _require_scratch
 
-# make a 1GB filesystem
-_scratch_mkfs_sized `expr 1024 \* 1024 \* 1024` > $seqres.full 2>&1
+# make a 1.5GB filesystem
+FS_SIZE=$(echo "1.5 $((1024 * 1024 * 1024))" | awk '{printf "%d", $1 * $2}')
+_scratch_mkfs_sized $FS_SIZE > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 # set the reserved block pool to almost empty for XFS
-- 
2.1.0

