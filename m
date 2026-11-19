Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104270;
	b=z0YizsBDlsMO4YShIrARjagm5FSvtpUv2HQnL3vTVqvNbkz9Dvvwi83eH63j6knUzFO1
	 ENz0dqw4qkLkdCOzVoyavMqQsL/tJ6gcNawlF3l5CfX9qGMycs5TzJD6nhBdtSoOuWHMA
	 e9fnSaEjlzhM3BwlymJwzwBjKiMVKMbguXjaQKFYeH0cAYfuZVF8lFTuB4OIuE39jmlqc
	 s7QMZTSx6D+eogd0/NZZbW18/oew+6Bq5f2B0nriHGtZ8olVahKxd5OxYUz7cuLRtdSup
	 OwTad1BpiEI0Wvy88/eCwy/FEdW+4jdmpuAVtRNa+EEheGeW4WjYPWs1zKKd48zKsaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104270;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hVVuVv+C2qbW1abga5nl1nCEmTApyceWszF4BhGzX/U=;
	b=aTheRdg4QwBdLaPgOKHIxjobVo37ZFUBZ130HNzw8zhPR5ZyVQ2JTvbKLYX2QS7LdHqW
	 8JPLXafQfT/cAIuk/V4zZljKdaiRcpSmset6buh8yxwDethsLxCDjxPEr9XAy4qjqpmo5
	 kw1KheRKkXBy1lrGsyYFhtn0Wq1CvHo/tjEtVMSq/8OYQ1UhCSocNOCvoCp+7b4vDnPjW
	 eycwtVbyKFmkrjSxneQB5RFZlW2hQekrbFj3qd1DnYT4XKgbR0+XmC0WtR1TOntvnHeqt
	 NiZnHAwspcJRlfNs4UeEiTb+gUnqgxXjlcAOg4bl7E4T41CBQTCMZc0dsXdm9+pi0HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NxdTLYrU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725B7606A320
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 16:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NxdTLYrU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A5A1F000C4
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104270;
	bh=hVVuVv+C2qbW1abga5nl1nCEmTApyceWszF4BhGzX/U=;
	h=From:To:Subject:Date;
	b=NxdTLYrU12HiuHGvq80lvp07WLlEgw80Rq9hV3KA2n8cPlUqi4WUKSus303TyPtRK
	 EbzUOq4Kn+PBN57NI5UA/Djyb3RMwtqtStb9scTOOi8Y5uRTBSqgFK08ei60Sw9r6P
	 GRy8xNOYzYSg3s7ngh9O6JQZ2mwUJJwGMz9QQ1sYwnuIPyMCqsA1An+4IQMPaGzH5P
	 5wbh6sfAuH8f2NLJBfcJJBal75Hz0DWKBZ3/EXcu3CwEL0Pa4LUZca0QzA4Oi9WyvX
	 +5gqzKBrXeamkXJoCcZPHLegPN5I0Q2Enias2gXiKPQkwzMVkEux0jvV9zZCli2DrC
	 Dtcv9QhVbmCaQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: wait for async dio before dirtying folio in btrfs_cont_expand()
Date: Thu, 19 Nov 2026 16:04:26 +0000
Message-ID: <a6b31fe34ababf35e0d9577589890ad637b09e20.1795104168.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
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

Fix this by having btrfs_cont_expand() call inode_dio_wait() when the
current i_size is not sector size aligned.

Sashiko reported this for fallocate and truncate and not for other places
like reflinking because in those other places we either wait for any
ordered extents in progress before calling btrfs_cont_expand() (or
btrfs_truncate_block()) or we have already called inode_dio_wait() before,
like during reflink when we call generic_remap_file_range_prep().

Link: https://sashiko.dev/#/bug/linux-05440703-4fc3-41f8-a693-9ffe4d9f4426
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4b29b82eb180..54cb6aa371eb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5243,6 +5243,23 @@ int btrfs_cont_expand(struct btrfs_inode *inode, loff_t oldsize, loff_t size)
 	u64 hole_size;
 	int ret = 0;
 
+	/*
+	 * Before zeroing the tail of the block, wait for any async direct IO
+	 * writes in progress to complete, otherwise if they complete after we
+	 * dirty the folio, they will trigger a warning when trying to
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
+	if (!IS_ALIGNED(oldsize, fs_info->sectorsize))
+		inode_dio_wait(&inode->vfs_inode);
+
 	/*
 	 * If our size started in the middle of a block we need to zero out the
 	 * rest of the block before we expand the i_size, otherwise we could
-- 
2.53.0

