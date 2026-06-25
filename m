Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F79233BBA2
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782415225; cv=none; b=jzUtcks4nYQ2vSK5sup50eziiIJZPUBPegKIVbn0uF/Pr1R0/FFCHhNf+I6AoPFRu7gt0b2lezO3jLhqx5kQGyZXlFWG04clkQZlXdCGgxv7s2mDBbMuvXdVK2OYfbGK8Xu2v0lJTJ0ADVdmPquGz+8+rVBUcP19k376Q2FIZZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782415225; c=relaxed/simple;
	bh=J8JcdTD6Mu7fCSM7fZ8a7KHEpz3jMhdfKlU4FU1xdeU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bb5De7WKrhLeMbuF76aWaaj98A5GviD1p35mkp9zEos/L28bH0/Mf3xP2q9Ztn7BrzIQG6WjgmHKp5KJrkW2L4qVsi1kIhlVuXPcMts5hI2m0zstnhjdEyy5pAVOARyZZAuGJMRj2gVHBIIJj6+8FaIIaB9lYrCLZrP5UsNQmrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fntStHw4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fntStHw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7822C1F00A3A
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 19:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782415224;
	bh=ys6bHUjukMFEiA01YH7ccdXmBHYmFdaap4h9/RVO3l4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=fntStHw4vF/o4DvImdsFJepeJJ2uRfNFEK5bSD32f7rKs9a0W6DRNODw29YvMVrAO
	 ogJ1ET4QyqcFpATp8aE7UBUL9Pyd7Wosk4y7vKoizdVRJ9Lf0engUdP0eBPnFWpPeT
	 JfBYCPSzRcJ2RO0igLhjjaGNPh/sNIw8ac2oHcdYPjKQaGmkBFFLFYNGNHqWrbfTr6
	 WfN2SJ6tRW0VHXscS8LOl3M43qS4k4Emv4TMGcvqiuHsCioOBjZ56PSeW/Y/bvibFF
	 3JX14amFfalPUku1FG8bMizuhk6/e+NBCdXgxJtZBqK1sS608A68LdQ1CJO/kD+Atj
	 ULyrXysxB7m3w==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: defrag: use auto kfree in defrag_one_range() for folios array
Date: Thu, 25 Jun 2026 20:20:14 +0100
Message-ID: <b3c3ddd783250773e264ebc76a0984d0276bc664.1782321584.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1782321584.git.fdmanana@suse.com>
References: <cover.1782321584.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Use AUTO_KFREE() for the folios array, avoiding two kfree() calls, one of
them in a very specific error path.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/defrag.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index ad1d04d8f165..e454b59d6477 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -1169,7 +1169,7 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
 	struct defrag_target_range *entry;
 	struct defrag_target_range *tmp;
 	LIST_HEAD(target_list);
-	struct folio **folios;
+	struct folio AUTO_KFREE(*folios);
 	const u32 sectorsize = inode->root->fs_info->sectorsize;
 	u64 cur = start;
 	const unsigned int nr_pages = ((start + len - 1) >> PAGE_SHIFT) -
@@ -1196,10 +1196,8 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
 	 * range or the extent lock.
 	 */
 	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, start, len);
-	if (ret < 0) {
-		kfree(folios);
+	if (ret < 0)
 		return ret;
-	}
 
 	/* Prepare all pages */
 	for (int i = 0; cur < start + len && i < nr_pages; i++) {
@@ -1251,7 +1249,6 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
 		folio_unlock(folios[i]);
 		folio_put(folios[i]);
 	}
-	kfree(folios);
 	btrfs_delalloc_release_extents(inode, len);
 	if (last_defrag_end < start + len)
 		btrfs_delalloc_release_space(inode, data_reserved, last_defrag_end,
-- 
2.47.2

