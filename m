Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED0A349AF5
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 09:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780307500; cv=none; b=Z52N3Zv9ll5fcbBrT1v5lBiP2zva6fKOZD5gwu7BhyNAcNqCrt9SvoBwpVJ1ojHC4DSZg51YeJyGYQ4zTRLDy1ldmgur/x00uuzyn8OPNrIc72QKvK1Oxy6zGHPPqEA3gHv8P3IDNH0+iV4qpfxbELu+3tMN8FmCZ6f7A6Bev40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780307500; c=relaxed/simple;
	bh=JmFZUTu+9jkbT2Ns770g0Rlz4dohbmm9/SxxEUZkkmI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=d/W0zDyO3Ko1uCodS7kb5FNsfKM7CAUgTprbrRsGsubv+yUFcJD2ZTVNXv1syZtnkBBOeiDqUp088nqqHqOXEttMDP4RvoAMtNOel/Oc20+R5nhnrd26EEvYIhAlkpcnD9x+/x/Xsy6898biX5FK1CXUztjvuioxvR3WGo9T7nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NPTF/SS/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NPTF/SS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DA91F00893
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 09:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780307490;
	bh=3Mzl8TAJqgYHjHOUAMR8h6itPtwqzUA5I+8YqLxwtyQ=;
	h=From:To:Subject:Date;
	b=NPTF/SS/Lk3jDSAZzpcHnEhtv4MGR6ZglIuKaT/thyV71fmLzbOSj5gcHKp+0GNpQ
	 HU69+ugifoE35xfx7lfBCBomUuuuwDc6C5R+PpigZ+U/AG80utowitqZZBxcMwuji7
	 8tlV00s7lHCTXb1lbVa0LciAJfgv5OOdZO1MwwzDAJlznuPwRVQunmkiK4N08BiWfE
	 /kJY+XfVV8LErXjiBVA1nY7CDG9t++2CKbm6Zb23oTRMYvNEsQTZSrmb9ytyvUymup
	 rIjgrquDP/m7wM8eq3Z5CZc8Lq5aoRej1h9utcWmgMBxhg3XyqNpkgbL8ywDEaRj4k
	 1LFD6vS6tnfcA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use mapping shared locking for reading super block
Date: Mon,  1 Jun 2026 10:51:26 +0100
Message-ID: <6085d60d77ea781ccb71be379b2e93825c489b4b.1780306581.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no need to exclusively lock the mapping, shared locking is enough
to protect from a concurrent set block size operation (BLKBSZSET ioctl).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 4 ++--
 fs/btrfs/zoned.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 66c44aa678c0..f409f870a6bc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1369,9 +1369,9 @@ struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
 				      (bytenr + BTRFS_SUPER_INFO_SIZE) >> PAGE_SHIFT);
 	}
 
-	filemap_invalidate_lock(mapping);
+	filemap_invalidate_lock_shared(mapping);
 	page = read_cache_page_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NOFS);
-	filemap_invalidate_unlock(mapping);
+	filemap_invalidate_unlock_shared(mapping);
 	if (IS_ERR(page))
 		return ERR_CAST(page);
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index ec15a57c46fa..0f87701e38e3 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -131,10 +131,10 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
 						BTRFS_SUPER_INFO_SIZE;
 
-			filemap_invalidate_lock(mapping);
+			filemap_invalidate_lock_shared(mapping);
 			page[i] = read_cache_page_gfp(mapping,
 					bytenr >> PAGE_SHIFT, GFP_NOFS);
-			filemap_invalidate_unlock(mapping);
+			filemap_invalidate_unlock_shared(mapping);
 			if (IS_ERR(page[i])) {
 				if (i == 1)
 					btrfs_release_disk_super(super[0]);
-- 
2.47.2

