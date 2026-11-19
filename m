Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795106745;
	b=n2Fg+lIFEooqqmlQhbP32MYFzz0xRznXmsqoRyODiLBqwXbSYdZ/LLfcyywjYZp2pqNP
	 ThLLIA2yEfYomxiZSpMLOB9TgKjpbtnYTOdH0omGPDP4rD5MhqytTk+FvRrVBmuGX07xP
	 K5WbTpSZXmgZG/9R9N0QSkZrygPPf4y2d2+WXLPvxpXta4zmon7eXYDqYrFDUtulHaoYy
	 nxYjKzyZr6Eg0qPs66e5Y27njDoP/dGdywned6D4X3pU0/GdTe5/+jGecyJL1AiUH/Wi3
	 zsdCeKYokCSzf3UgXh3ot9XF062OWQbCK6VHICEws8HDcwxbMwTx+1lB0WKh31ILLZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795106745;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=A5D6sbmOT1KONK0hnx/rUrECiAztRRXEItJSB3BeZXA=;
	b=wPMsfi4DIN1yoZuh15gdiLisliju0wJG83NOjpLWAd21Srq3TyFckd8lM43YfRwqLpFe
	 19HKZ1qRN3eUrCxW4KMu3rExmJ7YVrztncBmPYtRKPA5F2Ea4PexNSnt0bYDS0UxkpNck
	 i2+CmaexqMNOAuKwqM1zB1XC2UgQDsq1OtSYzykN5xCWiPI82IjNKA0+KwKRFcLunBzk0
	 DuKRsNzVRNFzFlX3se7VAuWmbLIaZIE4Qegp/dsBTWSnqkMrNWse05NMK8VIeIHVxRdcO
	 ziZ4UYOcdq/7TXu6MgwU3raoBxzC/2mXzXasGOKr1xf1NxRyfEz9v0uiwIoZNul5epA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I0u+5txU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7909A606A326
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 16:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I0u+5txU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BB41F000C8
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 16:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795106745;
	bh=A5D6sbmOT1KONK0hnx/rUrECiAztRRXEItJSB3BeZXA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=I0u+5txUqR9WckqBRaQ5ey30dHs36lHLGrbXiqU7swPdGR9AZbpbw1vkYKFweqx/V
	 0rMzT/u1QRkBYa0djY9iL8T5JG80uiPdztvUDlXv0kKF78GNghZqoWZSht9aAiH6WW
	 LZDiMCcsuYcPwSiGJysfLXaOCdNVY8oCD4PDttZ4ZtizqChSvS/yjYTXZTLI3bLViJ
	 WVeN9mH7MFp8dWWbUI1NNI1hC7Hf5wi2nm0KCuPtMLCQhB6Rq9gA1x+aVreobs7/Em
	 XY4qVLgBGvjedJwYmk6ddbW6rJbu5OjZKPjOKxBVzrWMHcYs2aPIpPNlR8PGzrlQ9A
	 9LCS27jCwfAxQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: wait for async dio before dirtying folio in btrfs_cont_expand()
Date: Thu, 19 Nov 2026 16:45:42 +0000
Message-ID: <4881e4e5790a35e6e14af30198f4c83ae063dd6a.1795106352.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a6b31fe34ababf35e0d9577589890ad637b09e20.1795104168.git.fdmanana@suse.com>
References: <a6b31fe34ababf35e0d9577589890ad637b09e20.1795104168.git.fdmanana@suse.com>
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

From: Filipe Manana <fdmanana@suse.com>

Sashiko reported that we race with async direct IO during fallocate and
truncation (to a larger i_size). For example for the truncation case:

         CPU0                            CPU1

  btrfs_setsize()
    btrfs_cont_expand()
      btrfs_truncate_block()
        __filemap_get_folio()
        btrfs_folio_set_dirty()
                                  iomap_dio_complete()
                                    kiocb_invalidate_post_direct_write()
                                      invalidate_inode_pages2_range()
                                      dio_warn_stale_pagecache()
                                        --> calls errseq_set() on the
                                            file's mapping
                                        --> triggers a warning in syslog

The warning is annoying to have in syslog/dmesg and it's something not
expected, but having errseq_set() called on the file's mapping results
in the next fsync to fails with -EIO (returned by the call to
file_check_and_advance_wb_err() made by fsync).

Fix this by having btrfs_truncate_block() call inode_dio_wait() when we
need to zero out the head or tail of a folio.

Sashiko reported this for fallocate and truncate and not for reflinking
(for example) because we have already called inode_dio_wait() before,
through the call to generic_remap_file_range_prep() from the VFS layer.

Link: https://sashiko.dev/#/bug/linux-05440703-4fc3-41f8-a693-9ffe4d9f4426
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

v2: Move the inode_dio_wait() call down the call stack to
    btrfs_truncate_block(), to avoid similar races in other places
    that call btrfs_truncate_block() without going to btrfs_cont_expand().

 fs/btrfs/inode.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4b29b82eb180..347e5e295fa7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5047,6 +5047,22 @@ int btrfs_truncate_block(struct btrfs_inode *inode, u64 offset, u64 start, u64 e
 	if (!need_truncate_head && !need_truncate_tail)
 		goto out;
 
+	/*
+	 * Before zeroing the tail or head of the block, wait for any async
+	 * direct IO writes in progress to complete, otherwise if they complete
+	 * after we dirty the folio, they will trigger a warning when trying to
+	 * invalidate the page cache and call errseq_set() on the mapping (which
+	 * makes the next fsync fail with -EIO), because the folio is dirty:
+	 *
+	 * iomap_dio_complete()
+	 *    kiocb_invalidate_post_direct_write()
+	 *       invalidate_inode_pages2_range()
+	 *       dio_warn_stale_pagecache()
+	 *          --> calls errseq_set() making next fsync fail
+	 *          --> triggers warning
+	 */
+	inode_dio_wait(&inode->vfs_inode);
+
 	block_start = round_down(offset, blocksize);
 	block_end = block_start + blocksize - 1;
 
-- 
2.53.0

