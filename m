Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:20484 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752950AbdCFWSb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 17:18:31 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v26KPh4S010659
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 6 Mar 2017 20:25:44 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v2] Btrfs: fix unexpected file hole after disk errors
Date: Mon,  6 Mar 2017 12:23:30 -0800
Message-Id: <1488831810-26684-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1488330280-22678-1-git-send-email-bo.li.liu@oracle.com>
References: <1488330280-22678-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs creates hole extents to cover any unwritten section right before
doing buffer writes after commit 3ac0d7b96a26 ("btrfs: Change the expanding
write sequence to fix snapshot related bug.").

However, that takes the start position of the buffered write to compare
against the current EOF, hole extents would be created only if (EOF <
start).

If the EOF is at the middle of the buffered write, no hole extents will be
created and a file hole without a hole extent is left in this file.

This bug was revealed by generic/019 in fstests.  'fsstress' in this test
may create the above situation and the test then fails all requests
including writes, so the buffer write which is supposed to cover the
hole (without the hole extent) couldn't make it on disk.  Running fsck
against such btrfs ends up with detecting file extent holes.

Things could be more serious, some stale data would be exposed to
userspace if files with this kind of hole are truncated to a position of
the hole, because the on-disk inode size is beyond the last extent in the
file.

This fixes the bug by comparing the end position against the EOF.

Cc: David Sterba <dsterba@suse.cz>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: update comments to be precise.

 fs/btrfs/file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 520cb72..dcf0286 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1865,11 +1865,13 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	pos = iocb->ki_pos;
 	count = iov_iter_count(from);
 	start_pos = round_down(pos, fs_info->sectorsize);
+	end_pos = round_up(pos + count, fs_info->sectorsize);
 	oldsize = i_size_read(inode);
-	if (start_pos > oldsize) {
-		/* Expand hole size to cover write data, preventing empty gap */
-		end_pos = round_up(pos + count,
-				   fs_info->sectorsize);
+	if (end_pos > oldsize) {
+		/*
+		 * Expand hole size to cover write data in order to prevent an
+		 * empty gap in case of a write failure.
+		 */
 		err = btrfs_cont_expand(inode, oldsize, end_pos);
 		if (err) {
 			inode_unlock(inode);
-- 
2.5.5

