Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903E47261C
	for <linux-btrfs@vger.kernel.org>; Fri,  8 May 2026 03:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778211185; cv=none; b=eukV7+LUcuqqbaPBuRNPDOrbkhwxILsxOh6pPLuSwBYpexJccSVdvpG312Alh50eiOIRK+1OQdcTxPYMVqffZFyWkJbTWcN0gq1Lz0Gfk6pf/ZRP4lKPayigrqhTQZgYwCAZyEf5lYUO9QKboIpoqyk8LcveTXstV2Mek06xbGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778211185; c=relaxed/simple;
	bh=WhqbiucwdoTP99weLlvJ66E+qa8mvFIV1VNJ2p4jE+A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jMQJFO9ianjV0xwFIbTm+nv9f5NFzUC5YrDMPTCPQMKNsRvSD019CvoEBrNvO8o6Dqv/uOGVJqspB/qSXDn4fa7CP4yQnlkmrEBmq/VOLt3KEVdvdu/+2XuqAdOMmbkbEGbu+uL5N1oFYpijWWIkuVK6s+Zaka2s031TTEgTWzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=BqbDvKeA; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="BqbDvKeA"
From: robbieko <robbieko@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1778211177; bh=WhqbiucwdoTP99weLlvJ66E+qa8mvFIV1VNJ2p4jE+A=;
	h=From:To:Cc:Subject:Date;
	b=BqbDvKeAWmRzFhwLS3uny3UAbS9YzNDEWDDbEn0YPLl8k+g+rpcvg/ZYIMvZCCv4a
	 ZKn6pYfkwDRe7DbQPQg31TQV336dXGtpqNWzEiB56mJRfk7UhOY1wiBB6j4Rw59Gbg
	 JMUQLjbaoTjeM/LRTF6d3MiFJcRdNDjV5LwWCufo=
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH] btrfs: mark file extent range dirty after converting prealloc extents
Date: Fri,  8 May 2026 11:32:22 +0800
Message-ID: <20260508033247.1400532-1-robbieko@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
Content-Type: text/plain

From: Robbie Ko <robbieko@synology.com>

When writing into a preallocated extent, ordered extent completion calls
btrfs_mark_extent_written() to convert the file extent item from
BTRFS_FILE_EXTENT_PREALLOC to BTRFS_FILE_EXTENT_REG.
If the preallocated extent was created beyond i_size, for example with
fallocate keep-size, and the inode is evicted and loaded again before the
write, the inode's file_extent_tree is initialized only up to i_size. The
out-of-i_size prealloc extent is therefore not tracked there.
After a write into that extent extends i_size, btrfs_mark_extent_written()
updates the file extent item, but the corresponding range is not marked dirty
in the inode's file_extent_tree. This can leave disk_i_size stale when the
filesystem does not use the no-holes feature, so after remount the file size
can go back to the old value.
Fix this by marking the written range dirty in file_extent_tree after
successfully converting the prealloc extent to a regular extent.
A reproducer is:
  mkfs.btrfs -f -O ^no-holes $DEV
  mount $DEV $MNT
  touch $MNT/file
  fallocate -n -l 2M $MNT/file
  umount $MNT
  mount $DEV $MNT
  dd if=/dev/zero of=$MNT/file bs=1M count=1 conv=fsync
  stat -c %s $MNT/file
  umount $MNT
  mount $DEV $MNT
  stat -c %s $MNT/file
  umount $MNT
Before the fix the first stat reports 1048576, while the second one can
report 0.
Fixes: 41a2ee75aab0 ("btrfs: introduce per-inode file extent tree")

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/file.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cf1cb5c4db75..8c171ed07008 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -633,7 +633,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 							 trans->transid);
 			btrfs_set_file_extent_num_bytes(leaf, fi,
 							end - other_start);
-			return 0;
+			goto mark_dirty;
 		}
 	}
 
@@ -661,7 +661,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 							other_end - start);
 			btrfs_set_file_extent_offset(leaf, fi,
 						     start - orig_offset);
-			return 0;
+			goto mark_dirty;
 		}
 	}
 
@@ -788,7 +788,12 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	return 0;
+mark_dirty:
+	ret = btrfs_inode_set_file_extent_range(inode, start, end - start);
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
+
+	return ret;
 }
 
 /*
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
