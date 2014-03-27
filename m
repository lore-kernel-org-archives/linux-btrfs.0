Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49453 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752098AbaC0CwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 22:52:04 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2R2px81008047
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 10:51:59 +0800
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: Change the expanding write sequence to fix snapshot
 related bug.
Date: Thu, 27 Mar 2014 02:51:58 +0000
Message-ID: <1395888786-11736-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When testing fsstress with snapshot making background, some snapshot
following problem.

Snapshot 270:
inode 323: size 0

Snapshot 271:
inode 323: size 349145
|-------Hole---|---------Empty gap-------|-------Hole-----|
0	    122880			172032	      349145

Snapshot 272:
inode 323: size 349145
|-------Hole---|------------Data---------|-------Hole-----|
0	    122880			172032	      349145

The fsstress operation on inode 323 is the following:
write: 		offset 	126832 	len 43124
truncate: 	size 	349145

Since the write with offset is consist of 2 operations:
1. punch hole
2. write data
Hole punching is faster than data write, so hole punching in write
and truncate is done first and then buffered write, so the snapshot 271 got
empty gap, which will not pass btrfsck.

To fix the bug, this patch will change the write sequence which will
first punch a hole covering the write end if a hole is needed.

Reported-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b2143b8..f53f592 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1718,6 +1718,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	loff_t *ppos = &iocb->ki_pos;
 	u64 start_pos;
+	u64 end_pos;
 	ssize_t num_written = 0;
 	ssize_t err = 0;
 	size_t count, ocount;
@@ -1772,7 +1773,9 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 
 	start_pos = round_down(pos, root->sectorsize);
 	if (start_pos > i_size_read(inode)) {
-		err = btrfs_cont_expand(inode, i_size_read(inode), start_pos);
+		/* Expand hole size to cover write data, preventing empty gap */
+		end_pos = round_up(pos + iov->iov_len, root->sectorsize);
+		err = btrfs_cont_expand(inode, i_size_read(inode), end_pos);
 		if (err) {
 			mutex_unlock(&inode->i_mutex);
 			goto out;
-- 
1.9.1
