Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0238367F54
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278700; cv=none; b=n7/ZoC9HvuUwRl5wR8GEHQCIbDliNpmdf6/Np+EU2DjrJaTkjaVS4d4ivP/vCUel3jNpNoGgq4Lebhg4oK5pJ+7v0MClJYdzuU0WY7jF5LHzxU0rURS65kyV5gMwzdfppAdSiGwCqm6bUZy918gheo4TDpk+mGyqbkuUTv2JGlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278700; c=relaxed/simple;
	bh=NbeRrBNiXQhjDoA+jAZcnOm7Zj722zVeSCRhsF2JxGI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV8DHo1HVYgtbx5kwNbvY2iQrcd+fX1cPBQqnLRcvt+ySPVEdUIIPGbof+HituRPb5ejtJ5uvUCCbVED0q7kh+eGjUPPKCRbwSfkddmpAAb5r5Twy7Beof5XiiPilAsbcxMPQyk91Ga1iaa1k1FKBOrxgnPDhIavQwVYA/6JYe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=txaJCUay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="txaJCUay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AAAC19424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776278700;
	bh=NbeRrBNiXQhjDoA+jAZcnOm7Zj722zVeSCRhsF2JxGI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=txaJCUayUduu/H0vH6Nlk2cPGw/MMhTu60V4dZ/paqL+K8BXFDnjDMtOvpb08cWdP
	 l/ZSxiY3mzvzt6wllohHcLVNteTolehzdW/vr04BzSlNW6F2VE3Be+qUu+JItJjZhp
	 XOflE4LlxyWf+dat2s2KoGJ5LbYGa7Vt22jC+fDXuxTAyKxJs7lJkjhCQATNgeYT0P
	 OhqhTXda8dd3Sawt7+Is/CWCHkPoGcgtyCttUVyGS5pcd1w1HkT7vNlepoMqlK4v2Q
	 AVwOL6Ybms1Wm75tgdHiA3KlGKrLQSltLGUV1yhRgFoZMd3nFgXc9xcoMGky7QC6KD
	 8SaUbg/MzLs4A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 06/10] btrfs: reduce size of struct btrfs_free_space_ctl
Date: Wed, 15 Apr 2026 19:44:44 +0100
Message-ID: <7a07424af114440a79349830ff42e26269c0e8ff.1776278490.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1776278490.git.fdmanana@suse.com>
References: <cover.1776278490.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We have a 4 bytes hole in the structure, reorder some fields so that we
eliminate the hole and reduce the structure size from 144 bytes down to
136 bytes. This way on a 4K page system, we can fit 30 structures per
page instead of 28.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 2ee0b876723a..c5d0f3e056cc 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -74,13 +74,13 @@ enum {
 };
 
 struct btrfs_free_space_ctl {
-	spinlock_t tree_lock;
 	struct rb_root free_space_offset;
 	struct rb_root_cached free_space_bytes;
-	u64 free_space;
+	spinlock_t tree_lock;
 	int extents_thresh;
 	int free_extents;
 	int total_bitmaps;
+	u64 free_space;
 	s32 discardable_extents[BTRFS_STAT_NR_ENTRIES];
 	s64 discardable_bytes[BTRFS_STAT_NR_ENTRIES];
 	const struct btrfs_free_space_op *op;
-- 
2.47.2

