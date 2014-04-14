Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49019 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750770AbaDNCnT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 22:43:19 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v2] btrfs: Change the expanding write sequence to fix snapshot related bug.
Date: Mon, 14 Apr 2014 10:44:08 +0800
Message-ID: <1397443448-20367-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
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
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Chris Mason <clm@fb.com>
---
changelog:
v2:
  Use 'pos + count' instead of 'pos + iov->iov_len' to deal with
multi-seg iov.
---
 fs/btrfs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 036f506c..e7e78fa 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1727,6 +1727,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	loff_t *ppos = &iocb->ki_pos;
 	u64 start_pos;
+	u64 end_pos;
 	ssize_t num_written = 0;
 	ssize_t err = 0;
 	size_t count, ocount;
@@ -1781,7 +1782,9 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 
 	start_pos = round_down(pos, root->sectorsize);
 	if (start_pos > i_size_read(inode)) {
-		err = btrfs_cont_expand(inode, i_size_read(inode), start_pos);
+		/* Expand hole size to cover write data, preventing empty gap */
+		end_pos = round_up(pos + count, root->sectorsize);
+		err = btrfs_cont_expand(inode, i_size_read(inode), end_pos);
 		if (err) {
 			mutex_unlock(&inode->i_mutex);
 			goto out;
-- 
1.9.2

