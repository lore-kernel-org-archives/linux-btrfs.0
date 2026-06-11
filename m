Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB212C3757;
	Thu, 11 Jun 2026 13:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781184622; cv=none; b=A/1lSTw44mjL05WOTUEmXWYRNHXkVUYHvV2SCLvLBjarqQ3fi1ajK7nzk5aNT8/VLxt2rJV4uRLcBJwnXOyMniQMm0+0zHLW2R2hc4o0H5hICK6TgY+hqkUgspeN7nxoAIVFln/wtKlybCLEw0ooftuJ74XLZYIwSZwsb2dijl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781184622; c=relaxed/simple;
	bh=piJtE2ahdVYa+ggULfzDB8d/kV1sx/QZAzOpPP90Gkc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lVmx4LcFtFKXu1A8xPBsdyp2Zt/GDT61S0RXyklZzv/UeF182nhTVCa/1M2bsr6vdrFhwLsAhBAhUB2SBoXjf5kF7yId+8lheeMbYE76H0liDNE4EezeN8eBulIG/OSlj4DwGQmWm8NEflEH1LZrT1DPuk21II/H2A4snYVQFiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=IU9WaWHI; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="IU9WaWHI"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 420485744;
	Thu, 11 Jun 2026 21:25:03 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: clm@fb.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org
Cc: naohiro.aota@wdc.com,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	runyu.xiao@seu.edu.cn,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: zoned: protect sb_write_pointer() reads with invalidate lock
Date: Thu, 11 Jun 2026 21:24:50 +0800
Message-Id: <20260611132450.971236-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9eb6db8f8703a1kunm4232c44d1660e1
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZHUhJVk9PSkJDS0IaQ0MfSlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=IU9WaWHI4YTlvVhpHFkqGyFJ9U1KIWnreKJLh0Myrkamq8J7gR720fAuAmVY7feesrnjwVn07hksuIythqXyDLamVpRgIFKzQRkJuwCFoGZpHvYSoBbwnDRf+MtDvdp5X3PdczAwuX2jRPb3bJIlnCYVhwxIKStvMxd+svwvOfk=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=MYYVWZGuWUy72thSlvgrKpQW5sePp3HufvzonBWY/1U=;
	h=date:mime-version:subject:message-id:from;

When both zoned superblock log zones are full, sb_write_pointer() reads
the last superblock page from each zone with read_cache_page_gfp() to
compare generations. Those reads go through bdev->bd_mapping without
filemap_invalidate_lock(), even though the same zoned discovery flow
later reaches btrfs_read_disk_super(), whose final read already takes
filemap_invalidate_lock(mapping).

A running system can reach this while mounting or scanning a zoned
filesystem whose superblock log has both zones full. In that state,
sb_write_pointer() performs two unprotected page-cache reads before
btrfs_read_disk_super() does its later protected final read.

This leaves the early discovery reads outside the same synchronization
domain used by set_blocksize() when it changes the block-device mapping
geometry. As a result, read_cache_page_gfp() can race a concurrent
block-size/layout update on the same mapping and see inconsistent
geometry across folio allocation and mapping state.

This issue was found by our static analysis tool while scanning
read_cache_page_gfp(bdev->bd_mapping, ...) sites for missing
filemap_invalidate_lock() coverage, and then manually audited on Linux
v6.18.21. The same synchronization requirement is already enforced for
the final read in btrfs_read_disk_super().

A focused QEMU KCSAN test then raced the zoned superblock discovery
path against a set_blocksize-style mapping update on the same
bdev->bd_mapping. It reported a race between
blkbszset_update_mapping() and read_cache_page_gfp(), with the read
side reaching:

  sb_write_pointer()
  sb_log_location()
  btrfs_sb_log_location_bdev()
  btrfs_read_disk_super()

Add filemap_invalidate_lock()/unlock() around the two
read_cache_page_gfp() calls in sb_write_pointer() so the zoned
superblock discovery path uses the same invalidate-lock contract as the
final read in btrfs_read_disk_super().

Fixes: 12659251ca5d ("btrfs: implement log-structured superblock for ZONED mode")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 fs/btrfs/zoned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index e14a4234954b..edc797a43fb5 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -130,8 +130,10 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
 						BTRFS_SUPER_INFO_SIZE;
 
+			filemap_invalidate_lock(mapping);
 			page[i] = read_cache_page_gfp(mapping,
 					bytenr >> PAGE_SHIFT, GFP_NOFS);
+			filemap_invalidate_unlock(mapping);
 			if (IS_ERR(page[i])) {
 				if (i == 1)
 					btrfs_release_disk_super(super[0]);
-- 
2.34.1
