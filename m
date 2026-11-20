Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795138885;
	b=Dng4nlFvFsMnyHSBbS0gVxfchNiWAA1DMh+WlF/f7DsjHEyEUuxVjkqsoWXt71E/Zz8Z
	 UXBphKD91NagMbdwtwnO1b2I764MiMQMgG5bh9qCWMnt22FefLql96vl8wED3Lv2z7JEx
	 teI/k7X7DSBljQu4tWN3IeAU+GK/SXHpJDHo/hY34jwU+rfvsEAezyG/QODA7+FQo+T6E
	 nT9fh5JtxznzEdxRAD9vYlQho/C5p3TAskAwWOotSuTCe46zZ2wp9S1b8xsYs+GzW52cT
	 QW2odWszqwtScFep0TzODsTpxZ6ziTivgCsm4qc/3W6jAbS6VqXO94nHEzscaoe8asQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795138885;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-HM-Tid:X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=b2xE6G3mXL+EJORGKJgWlx7eKwCa4WLanKQrk5DtnZ4=;
	b=13Q7ooE4cG0vMtT4c26nZaxoGuSSJxl7TaErcWu4ZaX/dPf3OEb+N3Dum2Z3vVHXsGBE
	 MiPPVjfac2y0EoXOGl6Q7Z9dx6w1THOMEGyVftECBhUwPHaOnT2vtJghwM4g8Mqm6kqbd
	 j0oJxNDoQItM3hZQAKfd3fzYgKPJxNQCyykYgACWsASZw0LRU5EBzN8IatLJwGRxx9TXm
	 4N6owUdeQ/o6f5ezmNUEbH2z9h5uUTLL69+9mPaXxT0zaHas71jLEkZLpSNdVepA5o1L5
	 DuFrkVTccRwRzvjhZlhGCdbFYy9cykdx5Vk82IxDEwDCyKz5Kn2O/BlvkIfAQHYsWqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=tju.edu.cn;
	spf=pass smtp.mailfrom=tju.edu.cn;
	dkim=pass header.d=tju.edu.cn header.i=@tju.edu.cn header.a=rsa-sha256 header.s=default header.b=eJd+flul;
	arc=none smtp.remote-ip=45.254.49.197
Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59832606A320
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 01:41:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59832606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=tju.edu.cn header.i=@tju.edu.cn header.a=rsa-sha256 header.s=default header.b=eJd+flul
Received: from localhost (gyproxy-mailtls3-entmail-gy2-virt38.gy.ntes [IPV6:2409:8d28:9:c3c:113b:eb3f:6e6b:44aa])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5557d63ba;
	Fri, 20 Nov 2026 09:41:17 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Filipe Manana <fdmanana@kernel.org>,
	linux-btrfs@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>
Subject: [PATCH v2] btrfs: report writeback errors on initial COW allocation failure
Date: Fri, 20 Nov 2026 01:40:59 +0000
Message-Id: <20261120014059.1476966-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261119151750.4178311-1-guolingxing@tju.edu.cn>
References: <20261119151750.4178311-1-guolingxing@tju.edu.cn>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1f69d76c003a2kunm8ce2fc461c8423
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTU8YVktOGk5DGBhPTUxMQ1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBQkEYSBhBSkpIGUEeGUgdQU0eTRlBT08aGl
	lXWRYaDxIVHRRZQVlPS0hVSktISkxDSlVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=eJd+flulSrmipv9mCPUATbEQ4qn1st74e5o/23gck+RfoRt3NcXctLceHmjqMRBRpnW2a66qwsQrw7Gmp34hfkr5T2fEtdwB9zGv5gsU5AR7+4hdgbU6ZkNip99kqBkGLu5HpYd/K8cpgNl9Aqn0oPADeHFtjUqorCqEKtwagq8=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=b2xE6G3mXL+EJORGKJgWlx7eKwCa4WLanKQrk5DtnZ4=;
	h=date:mime-version:subject:message-id:from;

When compressed writeback falls back to uncompressed I/O,
cow_file_range() can fail to allocate the first data extent
before any ordered extent is created.

In this case cow_one_range() returns the allocation error
without recording it in the mapping. Since no ordered extent
was created, the ordered extent cleanup cannot report the
failure either.

The remaining range is then cleaned up, clearing delalloc
and ending folio writeback without recording an error.
The error eventually reaches submit_uncompressed_range(),
which only logs it.

As a result, fsync() can return success even though the data
was never written to disk.

This was reproduced by injecting -ENOSPC into
btrfs_reserve_extent() on a zstd-compressed filesystem.
A 1 MiB buffered write was split into eight 128 KiB ranges,
all failing their initial COW allocation. fsync() returned 0,
and the entire 1 MiB read back as zeros after dropping caches.
The same test without fault injection preserved the data.

Record the error in the mapping unconditionally when
cow_file_range() takes its error path, before cleaning up the
remaining ranges. Remove the existing conditional error
reporting from the cleanup of previously allocated ordered
extents.

With the fix, fsync() reports ENOSPC under the same fault
injection.

Suggested-by: Filipe Manana <fdmanana@kernel.org>
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---

Changes since v1:
- Report the error unconditionally in cow_file_range()'s common
  error path, as suggested by Filipe.
- Remove the existing conditional mapping_set_error() call from
  the ordered extent cleanup.

 fs/btrfs/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index abaa334714566..214d6f9446adf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1455,6 +1455,8 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	return ret;
 
 out_unlock:
+	mapping_set_error(inode->vfs_inode.i_mapping, ret);
+
 	/*
 	 * Now, we have three regions to clean up:
 	 *
@@ -1477,9 +1479,6 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 		clear_bits = EXTENT_LOCKED | EXTENT_DELALLOC;
 		page_ops = PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_END_WRITEBACK;
 
-		if (!locked_folio)
-			mapping_set_error(inode->vfs_inode.i_mapping, ret);
-
 		btrfs_cleanup_ordered_extents(inode, orig_start, start - orig_start);
 		extent_clear_unlock_delalloc(inode, orig_start, start - 1,
 					     locked_folio, NULL, clear_bits, page_ops);
-- 
2.34.1

