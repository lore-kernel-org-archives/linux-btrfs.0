Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22235 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380AbbBKUJD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 15:09:03 -0500
Received: from pps.filterd (m0004347 [127.0.0.1])
	by m0004347.ppops.net (8.14.5/8.14.5) with SMTP id t1BK78gb008247
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2015 12:09:02 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0004347.ppops.net with ESMTP id 1sgdt080ax-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2015 12:09:02 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] Btrfs: only adjust outstanding_extents when we do a short write
Date: Wed, 11 Feb 2015 15:08:57 -0500
Message-ID: <1423685339-8278-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have this weird dance where we always inc outstanding_extents when we do a
O_DIRECT write, even if we allocate the entire range.  To get around this we
also drop the metadata space if we successfully write.  This is an unnecessary
dance, we only need to jack up outstanding_extents if we don't satisfy the
entire range request in get_blocks_direct, otherwise we are good using our
original reservation.  So drop the unconditional inc and the drop of the
metadata space that we have for the unconditional inc.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8a036ed..e78a2fd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7137,6 +7137,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	u64 start = iblock << inode->i_blkbits;
 	u64 lockstart, lockend;
 	u64 len = bh_result->b_size;
+	u64 orig_len = len;
 	int unlock_bits = EXTENT_LOCKED;
 	int ret = 0;
 
@@ -7272,9 +7273,11 @@ unlock:
 		if (start + len > i_size_read(inode))
 			i_size_write(inode, start + len);
 
-		spin_lock(&BTRFS_I(inode)->lock);
-		BTRFS_I(inode)->outstanding_extents++;
-		spin_unlock(&BTRFS_I(inode)->lock);
+		if (len < orig_len) {
+			spin_lock(&BTRFS_I(inode)->lock);
+			BTRFS_I(inode)->outstanding_extents++;
+			spin_unlock(&BTRFS_I(inode)->lock);
+		}
 
 		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 				     lockstart + len - 1, EXTENT_DELALLOC, NULL,
@@ -8056,8 +8059,6 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode,
 						     count - (size_t)ret);
-		else
-			btrfs_delalloc_release_metadata(inode, 0);
 	}
 out:
 	if (wakeup)
-- 
1.8.3.1

