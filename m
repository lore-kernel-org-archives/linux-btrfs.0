Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:46162 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbcDCVYT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Apr 2016 17:24:19 -0400
Received: from localhost
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 4 Apr 2016 07:24:16 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 0FCDE2CE8054
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Apr 2016 07:24:14 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u33LNsCN65274030
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Apr 2016 07:24:13 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u33LNTWs023145
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Apr 2016 07:23:29 +1000
Received: from localhost.in.ibm.com ([9.78.198.28])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id u33LNSrH022956
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Apr 2016 07:23:29 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: __btrfs_buffered_write: Pass valid file offset when releasing delalloc space
Date: Mon,  4 Apr 2016 02:53:06 +0530
Message-Id: <1459718586-17569-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The delalloc reserved space is calculated in terms of number of bytes
used by an integral number of blocks. This is done by rounding down the
value of 'pos' to the nearest multiple of sectorsize.

The file offset value held by 'pos' variable may not be aligned to
sectorsize and hence when passing it as an argument to
btrfs_delalloc_release_space(), we may end up releasing larger delalloc
space than we originally had reserved.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 15a09cb..5d9f9f7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1696,7 +1696,9 @@ again:
 			btrfs_end_write_no_snapshoting(root);
 			btrfs_delalloc_release_metadata(inode, release_bytes);
 		} else {
-			btrfs_delalloc_release_space(inode, pos, release_bytes);
+			btrfs_delalloc_release_space(inode,
+						round_down(pos, root->sectorsize),
+						release_bytes);
 		}
 	}
 
-- 
2.1.0

