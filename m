Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9581C3AE707
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770133167; cv=none; b=oZf5AjfQHd28W/Ppf343s+AlkhHn0BDwfd7YS3H/U/95m4TwbUvMy4tMPEVXOAbwJi8aeKthClKRGtnJwAah34jnfk3qFtmerG5DRJxg4LT5mIAltUy6hoZecV+4cxbnFhiPxBwJYccwPzvkUmj/X2xPx3ZxnD4Ku2lQvgdp31g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770133167; c=relaxed/simple;
	bh=i6uld8aMtEeHdhvJeXmZHNouGw+3BUY3f6RdSMJprDw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxhYOIdS0XzTLNACL+K3ZSyOxP0lsegSbST9IWFhYmKIkJhTxph8nC6onnawkFqKviuwskigAUsS/7F9h2BtbUTD0qSxuQMyxB4u1fsEAcCc+Kg+GWuHDddJ61j1/7w9+PeqxCIu+a7/ui2xQ0HfpIVVZtVvNE5dTjZkd3GMvS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/CJ8xWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/CJ8xWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7FAC116D0
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 15:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770133167;
	bh=i6uld8aMtEeHdhvJeXmZHNouGw+3BUY3f6RdSMJprDw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=O/CJ8xWZFvZ7MPunNKDngPM72YAd8hzGxEfONIS8Hg7t3b6BVndA7iPhMGD+ETsQp
	 veto+Wgd6x0aiOtUfLOlLKdYOfjNN6MUJtxHvLJYyZjJ2cf3IcNC2/3QvKqM/BhILb
	 xIfFqPHm911/LUEuYwTHzIrrvTacKbfolM0BfReNhWN95Jcr1R4gG/MZXed2QF/hlk
	 5XJY024DJUyi0LZIOsYX1SwTlENDxmP+ZXw8KIpQmyoK2kp3hKSIQXk5rHIyThfNiD
	 R29sOqY2ksZ/FJ7U5pVhxVZoYLGmnjuFeTAvLqellyfCAs5zUUD7s6AChOFO1An0eR
	 DHug6OWKqBuAg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: move min sys chunk array size check to validate_sys_chunk_array()
Date: Tue,  3 Feb 2026 15:39:21 +0000
Message-ID: <58243101e848ea2e2c325420e76cce71b7789057.1770133086.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1770133086.git.fdmanana@suse.com>
References: <cover.1770133086.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We check the minimum size of the sys chunk array in btrfs_validate_super()
but we have a better place for that, the helper validate_sys_chunk_array()
which we use for every other sys chunk array check. So move it there, also
converting the return error from -EINVAL to -EUCLEAN, which is a better
fit and also consistent with the other checks.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 540ec255b7a4..069f8017d425 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2288,6 +2288,15 @@ static int validate_sys_chunk_array(const struct btrfs_fs_info *fs_info,
 		return -EUCLEAN;
 	}
 
+	/* It must hold at least one key and one chunk. */
+	if (unlikely(sys_array_size < sizeof(struct btrfs_disk_key) +
+		     sizeof(struct btrfs_chunk))) {
+		btrfs_err(fs_info, "system chunk array too small %u < %zu",
+			  sys_array_size,
+			  sizeof(struct btrfs_disk_key) + sizeof(struct btrfs_chunk));
+		return -EUCLEAN;
+	}
+
 	while (cur < sys_array_size) {
 		struct btrfs_disk_key *disk_key;
 		struct btrfs_chunk *chunk;
@@ -2530,19 +2539,6 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 
 	ret = validate_sys_chunk_array(fs_info, sb);
 
-	/*
-	 * Obvious sys_chunk_array corruptions, it must hold at least one key
-	 * and one chunk
-	 */
-	if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
-			+ sizeof(struct btrfs_chunk)) {
-		btrfs_err(fs_info, "system chunk array too small %u < %zu",
-			  btrfs_super_sys_array_size(sb),
-			  sizeof(struct btrfs_disk_key)
-			  + sizeof(struct btrfs_chunk));
-		ret = -EINVAL;
-	}
-
 	/*
 	 * The generation is a global counter, we'll trust it more than the others
 	 * but it's still possible that it's the one that's wrong.
-- 
2.47.2

