Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCD3327C09
	for <linux-btrfs@vger.kernel.org>; Fri,  8 May 2026 13:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778247748; cv=none; b=cDoFMJS3fXqPFSj4hZYNE9aXfmvHAr+DyzyOPIWL3cAMf05XeM1ZfWOzSIbXVOQdBE43s5qc+0z+G7/X3CcDs3CUgSKk3I10imopqPQO12U+au/BQQxUsBkUSaFxCoDmvMSg7tWoumb34qzj+c5UR8pEmJqwGaHEn3XmmwarQc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778247748; c=relaxed/simple;
	bh=eKFKAAt1MYiFEYkBClOwfkBJ1TMcQnFDrhuGdmOYnME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y+H/TDFvBhPzPm/HBTmIR/F+jRef4fZeAd7BlAbIKfMD9Qb46+Lc/oIVet1T5I0FJ6SkMdBPrE7DZeROIg1sIvw71r3/GzYdESZTwmXHBcZY8p0hryglO6+ZWFpKGMt9MRbesOGWcsb/KOyDEt+dDWqhj4jkYqA9j7C8aCqmJS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=LWVEac+L; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="LWVEac+L"
From: robbieko <robbieko@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1778247744; bh=eKFKAAt1MYiFEYkBClOwfkBJ1TMcQnFDrhuGdmOYnME=;
	h=From:To:Cc:Subject:Date;
	b=LWVEac+LA2al04m1oebIszm1KVRSMQDoqepQmnP9H8f4oSrzubYsCPr1llSZ/iUrg
	 84r74qfEVN7OlGRVy3lrsyMofT/+o88Sj8ZzBFqIBDzs2roasEJCTv2eMJW9IsAk0p
	 oHNbq4n87Yl2LhDeUAq5jsUuyJPCDAVntR++i3DY=
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2] btrfs: mark file extent range dirty after converting prealloc extents
Date: Fri,  8 May 2026 21:42:11 +0800
Message-ID: <20260508134215.1716255-1-robbieko@synology.com>
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

If the preallocated extent was created beyond i_size with fallocate
keep-size, and the inode is evicted and loaded again before the write,
the inode's file_extent_tree is initialized only up to i_size.

The out-of-i_size prealloc extent is therefore not tracked there.

After a write into that extent extends i_size, btrfs_mark_extent_written()
updates the file extent item, but the corresponding range is not marked
dirty in the inode's file_extent_tree. 

This can leave disk_i_size stale when the filesystem does not use the
no-holes feature, so after remount the file size can go back to the old
value.

The following reproducer triggers the problem:

  mkfs.btrfs -f -O ^no-holes $DEV
  mount $DEV $MNT
  touch $MNT/file
  fallocate -n -l 2M $MNT/file
  umount $MNT
  mount $DEV $MNT
  dd if=/dev/zero of=$MNT/file bs=1M count=1 conv=notrunc
  ls -l $MNT/file
  umount $MNT
  mount $DEV $MNT
  ls -l $MNT/file
  umount $MNT

Running the reproducer gives the following result:

-rw------- 1 root root 1048576 May  8 21:20 /mnt/file
-rw------- 1 root root 0 May  8 21:20 /mnt/file

Fix this by marking the written range dirty in file_extent_tree after
successfully converting the prealloc extent to a regular extent.

Fixes: 9ddc959e802b ("btrfs: use the file extent tree infrastructure")

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
