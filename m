Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5800340DFBD
	for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2026 02:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777603407; cv=none; b=MapdfURTZjNQb5VwFc/tHu9gwAOY6Q8TZRhS+vqbZ2279IDrmuf+LtmP+KVXbul9ac3ywzWCR8YAn6zdBRyof4U+moyItm66eVUsPFdwiHXErrGMqzkiZcYnlTIXFAuoaSfVKW9R/54CrcD7EDB+MTFEZ5ERWACvUFb2MzDIP5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777603407; c=relaxed/simple;
	bh=mqr1XLb0BKLVJJhG7aFEUZmuo2tFZM3CGepv9di/v7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=inGfN06AHrr5shzesbNMNMmW5w1YDBdS/yik4IYkjZNpZGGmFZeM4p582EgqBBvnUIzKWUTFfh32mWF62MD8+mp2mUcI6kv931VgIDdKNbkCK2c+iSRSFCqj920su1NR4NW6ZqO6F0TU3fdOZzpeHFQFkXjJHmu+1cwZvO+lDns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=Wk2VN0jw; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="Wk2VN0jw"
From: robbieko <robbieko@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1777603397; bh=mqr1XLb0BKLVJJhG7aFEUZmuo2tFZM3CGepv9di/v7s=;
	h=From:To:Cc:Subject:Date;
	b=Wk2VN0jw970DtjZf00aTFUzTSdau7z0ubKYFfqmbhmd5KJr0riH1vFAYEAOZQQKkL
	 LCGgj+JlR+wiPJ4j9aMUa1sWM4n1lPO9/TVGwO/oRYf4PFnCr7UM3BUONvMSeHeG3B
	 T/R4OOeGAl/40izNCFz6f9lmOc874tcS6UoVyc2Y=
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH] btrfs: fix incorrect i_size after remount caused by KEEP_SIZE prealloc gap
Date: Fri,  1 May 2026 10:41:56 +0800
Message-ID: <20260501024310.193220-1-robbieko@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
Content-Type: text/plain

From: Robbie Ko <robbieko@synology.com>

When fallocate() with FALLOC_FL_KEEP_SIZE preallocates an extent past the
current i_size, the file_extent_tree of the inode is updated to cover
that range. However, on the next mount, btrfs_read_locked_inode() only
re-populates file_extent_tree with [0, round_up(i_size, sectorsize)),
losing the marks that belonged to the KEEP_SIZE prealloc extent beyond
i_size.

Later, when a non-KEEP_SIZE fallocate() extends i_size into / past that
old prealloc extent, the reservation loop in btrfs_fallocate() skips
already-prealloc segments and does not call into the path that marks the
file_extent_tree, so a gap remains inside the file_extent_tree across
[old_aligned_i_size, start_of_new_alloc). Then __btrfs_prealloc_file_range()
calls btrfs_inode_safe_disk_i_size_write(), which uses
find_contiguous_extent_bit() starting at offset 0 to derive disk_i_size.
The walk stops at the gap, so disk_i_size ends up smaller than i_size and
gets persisted. After the next mount, the file shows the wrong (smaller)
size.

The following reproducer triggers the problem:

  $ cat test.sh
  MNT=/mnt/test
  DEV=/dev/loop1

  mkdir -p $MNT
  mkfs.btrfs -f -O ^no-holes $DEV
  mount $DEV $MNT

  touch $MNT/file1
  # KEEP_SIZE prealloc beyond i_size (i_size stays 0)
  fallocate -n -o 1604991 -l 865536 $MNT/file1
  umount $MNT
  mount $DEV $MNT

  # non-KEEP_SIZE fallocate that overlaps the previous prealloc tail
  # and extends past it
  fallocate -o 2381098 -l 624426 $MNT/file1
  ls -l $MNT/file1
  umount $MNT
  mount $DEV $MNT
  ls -l $MNT/file1
  umount $MNT

Running the reproducer gives the following result:

  $ ./test.sh
  (...)
  -rw-r--r-- 1 root root 3005524 ... /mnt/test/file1
  -rw-r--r-- 1 root root 2379776 ... /mnt/test/file1

The size before the second mount is correct (3005524), but after the
remount it drops to 2379776, which is round_down(2381098, 4096), i.e.
the start of the gap inside file_extent_tree aligned down to sectorsize.

Fix this in __btrfs_prealloc_file_range() by marking the entire range
[round_down(old_i_size, sectorsize), round_up(new_i_size, sectorsize))
in file_extent_tree before updating i_size and calling
btrfs_inode_safe_disk_i_size_write(). This ensures the contiguous bit
search starting from 0 is not truncated by a stale gap left behind by a
previous KEEP_SIZE prealloc that was not restored on inode load.

The fix has no effect when the NO_HOLES feature is enabled because
btrfs_inode_safe_disk_i_size_write() and btrfs_inode_set_file_extent_range()
both take the fast path that directly tracks disk_i_size without consulting
file_extent_tree.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/inode.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 906d5c21ebc4..c39a0ce24224 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9299,10 +9299,38 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    (actual_len > inode->i_size) &&
 		    (cur_offset > inode->i_size)) {
+			u64 range_start, range_end;
+
 			if (cur_offset > actual_len)
 				i_size = actual_len;
 			else
 				i_size = cur_offset;
+
+			/*
+			 * Make sure the file_extent_tree covers the entire
+			 * range [old_i_size, new_i_size) before we update
+			 * disk_i_size. Without this, a previous KEEP_SIZE
+			 * prealloc that extended past i_size (and was lost
+			 * across umount/mount because file_extent_tree is
+			 * only populated up to round_up(i_size) on inode
+			 * load) can leave a gap inside this range. That gap
+			 * would cause btrfs_inode_safe_disk_i_size_write()
+			 * (via find_contiguous_extent_bit() starting at 0)
+			 * to truncate disk_i_size to the start of the gap,
+			 * making the persisted size smaller than i_size.
+			 */
+			range_start = round_down(inode->i_size,
+						 fs_info->sectorsize);
+			range_end = round_up(i_size, fs_info->sectorsize);
+			ret = btrfs_inode_set_file_extent_range(BTRFS_I(inode),
+					range_start, range_end - range_start);
+			if (ret) {
+				btrfs_abort_transaction(trans, ret);
+				if (own_trans)
+					btrfs_end_transaction(trans);
+				break;
+			}
+
 			i_size_write(inode, i_size);
 			btrfs_inode_safe_disk_i_size_write(BTRFS_I(inode), 0);
 		}
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
