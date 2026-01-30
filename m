Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7CC3502AC
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Jan 2026 17:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769793303; cv=none; b=gMsma7TDAUC1JnkH9gBLjg9dIamcRP6QRdsOqwNIdDf2Gpp8Qnr8f4tuoK/ELEzvXTaPHVmy6NCMBX5+SDSXj7nPBGCqkfHmfi1i2zvFP2Z1mOwOlvRqsdkj0ndO3xGqmxOIipK9GlC2t/VK8GzGGCc3xhOR4SS4Fsy2w/q76EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769793303; c=relaxed/simple;
	bh=1oBVXBZa/eCpa/43d95zNa6dwXqvoPAjnbpnFpZ1odM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pQVy7GJhMemFTbqRPsFQMaomjkHqLt+7oOObSH65V3dlmuv5OjnLtQ3PK3o5/qZ3jNXoBeNx7rL9/TtcoUAWKveGKbP2nYVfXK9TO1q6VSC7nNjwiYKRflo0fXmNxjT3MV/dldOU1aQ7m3CZG890KYgeWtVmVM2eioyk/Pj+tdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TylqoIfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TylqoIfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69798C4CEF7
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Jan 2026 17:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769793302;
	bh=1oBVXBZa/eCpa/43d95zNa6dwXqvoPAjnbpnFpZ1odM=;
	h=From:To:Subject:Date:From;
	b=TylqoIfmz6CmYRK99ZinRN5kvX9Ttc1HPEUE3pMlZGN+UhL0mFf1r7vUcwqp4TS03
	 cdMpkTVCcO6CjQVEqfU2iiuJCNEiq4NZLaGktje6PsEORwwxo8mpqBo+Sxg2/tkaXt
	 ws+LB082PbQqCUJpKTBzNWb4tzARWjky5J3S0pgrXRXWUAoWCpA3+xQqpeRT1g+XeG
	 7aPdFX6KKT6ngh8khsY5jmwwGTu0CJZfMvcviU6PxIvq8Gg3vEcB4k8LakkblMqlyS
	 S/SiUKJt9lSZgv/l9xwXpYLfb+SvenB+Hc3o3LXsmkCW8Cyx9IUjmdWTGrlBwhk1tZ
	 8z58NecQWLTBA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: raid56: fix memory leak of btrfs_raid_bio::stripe_uptodate_bitmap
Date: Fri, 30 Jan 2026 17:14:59 +0000
Message-ID: <140aedc1e1af2866bb838d29b742c2015d55d91e.1769793280.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We allocate the bitmap but we never free it in free_raid_bio_pointers().
Fix this by adding a bitmap_free() call against the stripe_uptodate_bitmap
of a raid bio.

Fixes: 1810350b04ef ("btrfs: raid56: move sector_ptr::uptodate into a dedicated bitmap")
Reported-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/linux-btrfs/20260126045315.GA31641@lst.de/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/raid56.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index f38d8305e46d..baadaaa189c0 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -150,6 +150,7 @@ static void scrub_rbio_work_locked(struct work_struct *work);
 static void free_raid_bio_pointers(struct btrfs_raid_bio *rbio)
 {
 	bitmap_free(rbio->error_bitmap);
+	bitmap_free(rbio->stripe_uptodate_bitmap);
 	kfree(rbio->stripe_pages);
 	kfree(rbio->bio_paddrs);
 	kfree(rbio->stripe_paddrs);
-- 
2.47.2

