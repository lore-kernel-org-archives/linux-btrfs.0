Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795101501;
	b=mHdfUss1xF6C6ppfRrFZtgtd0WVHMWpiVan5q7Ke829MvDmtwtUelVcV24zw5QPsTSDi
	 Rbd27Z9sfh2h40/VzzJPUQuH+r6unCzzjDUs0tlFlP1MtclcWBG28z1f+xQdRv7XapJjY
	 g73fpgcAT5HwusIoKufWp/smE0TT1ZP0D1ePP8h69h4V1rjm4iFG2JeaAnpKvV3WVy0dN
	 +0cGB4ixHqEsZlRIVbkx0MYU+8snF17UvGdLoGemIy3e6tIB/NwqXESmRb8IrfVe6lwHH
	 uXn7SYx64cKSlCVFi0ahjgtHNgE/nt5Ue8TW7wVIoWQmxDAr42yN+L0YB00q4MDWNyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101501;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=lm5+MQwdQ+26TNjbLIpGaj3ZJcbnckVOe0iE1oSQld8=;
	b=VKB/aawrNtg3MCE/AJiO+FzTSr1pWQMsYnqARThCSfaoHkeEI85TP6U61Glfp+zWVYln
	 CrGoAy0q8KNcp/gfXzymydq2+dwzga4uDhaBAhw0MiVklHsHET1A0QWsjB0e1IgO5DsBr
	 YH1eMwoDWGaiVpW1C58llz+27tBQWVDszIP6TK2YvcUCVK3d1NdwyuLtSDr5CjjLDOQU4
	 XbbEBRYHrnIDjCxhgwPjW9/M31Cg38mTg5i6qi1jcet7GjzVQPB9mfSZMYiZax6ujUXw7
	 3mOB5W+Kt1EnwnFL3uRU3PoBAG6ocq8C+k/evazvNqnYfdRkRzi3sVf59MpOr4jQUvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=tju.edu.cn;
	spf=pass smtp.mailfrom=tju.edu.cn;
	dkim=pass header.d=tju.edu.cn header.i=@tju.edu.cn header.a=rsa-sha256 header.s=default header.b=MkQpMvBB;
	arc=none smtp.remote-ip=45.254.49.197
Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15536606A320
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 15:18:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15536606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=tju.edu.cn header.i=@tju.edu.cn header.a=rsa-sha256 header.s=default header.b=MkQpMvBB
Received: from localhost (gyproxy-mailtls4-entmail-gy2-virt39.gy.ntes [IPV6:2409:8d28:2e:f2a:113b:eb3f:6e6b:44aa])
	by smtp.qiye.163.com (Hmail) with ESMTP id 554cf9bff;
	Thu, 19 Nov 2026 23:18:07 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	linux-btrfs@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>
Subject: [PATCH] btrfs: report writeback errors on initial COW allocation failure
Date: Thu, 19 Nov 2026 15:17:50 +0000
Message-Id: <20261119151750.4178311-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
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
X-HM-Tid: 0aa1f462efa803a2kunmb221c9421b05f5
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaHR9OVh4fH0tDQxkYQkwZSlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSR5BHUkaQUpKSBlBHhlIHUFNHk0ZQU9PGh
	pZV1kWGg8SFR0UWUFZT0tIVUpLSEpMQ0pVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=MkQpMvBBtWQjIvVuQ6qEWTVnX2Za8LQoYbQhksqWdc0ss71SJbdghBGPBGZUHns6+zE1KyH6wpOEwkQDX0gkofLhRI3OlwgGoObvLfOBDVC0xJRjE0ogZdKd3tE+ZF66chXWOD51mAFTjOUS5k3nc8nx/OYh26SFDSOqyJCT+r8=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=lm5+MQwdQ+26TNjbLIpGaj3ZJcbnckVOe0iE1oSQld8=;
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

Record the error before ending writeback when the first COW
allocation fails and no ordered extent exists to report it.
With the fix, fsync() reports ENOSPC under the same fault
injection.

Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/btrfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index abaa334714566..3329a104a9072 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1455,6 +1455,14 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	return ret;
 
 out_unlock:
+	/*
+	 * If the initial allocation fails, no ordered extent exists to
+	 * report the error. Record it before ending writeback for the
+	 * failed range.
+	 */
+	if (start == orig_start && !cur_alloc_size)
+		mapping_set_error(inode->vfs_inode.i_mapping, ret);
+
 	/*
 	 * Now, we have three regions to clean up:
 	 *
-- 
2.34.1

