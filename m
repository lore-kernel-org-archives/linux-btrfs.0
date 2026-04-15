Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E126F3D5237
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776263902; cv=none; b=eQtwjXVfv2sqZZP75AE3Gf4wP5Ma3rcv4UWw6jan+ZN7jACuFX8TYM92FwpQD6sIyZjx+Jxq+vjRECQW/OYM2cZHowUgMXz/Yle/dET8Eu+x4PETjsXaefThKGQv/28CKp4xocvG5mT+j+HkFXY8aIm9YrEIEvIzkK3vaGqxR8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776263902; c=relaxed/simple;
	bh=NbeRrBNiXQhjDoA+jAZcnOm7Zj722zVeSCRhsF2JxGI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fyf6SwA4o6tB8ggxdZoe+lKHnO4FpotF2OfJRonHPs6wIPl73fCwOo7fLjNq2tvY/Qjpr6F8mXEQZfYMw1LktJVwTK/dVd/mtwSegcZs+xJAkHCXik8HRiYKSct35sV4cpD9X9MtOdTlrIJ5xPRh3lxzkvGMp+rs+dJpsyp1xD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLckUX3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLckUX3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22791C19424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776263901;
	bh=NbeRrBNiXQhjDoA+jAZcnOm7Zj722zVeSCRhsF2JxGI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LLckUX3wcnbUkS6cRTNDT+XWmbtQMPhtdRcsLgnDhf470dcw1TWF8SqGzgBCbnQzz
	 hepSAYyehlxtpw/URwGSsOPM3gs+TBoSMx53b1/1GkiME9wR9ag/qLOMYQ/E2ErjFF
	 07NwM0DIOBRCSSx5VBxpNx1rPdId5Dloi0QS1qWuJxQPBuRKF1cfuD8+r8IA6vf3Wm
	 5IVDF6ULZaVXUwuPkvw4UTS10CvPjB1hsWIpMWoHI6qJlxd5WzoE9ytVBjULXrpqMp
	 mwXLer7IcR+0SHS0gkWKTK5rGBH9f+e209EvSvdzMqzCRk1SMPuFuHnF3dS00R2iwV
	 Ejtnyi0cPXFnw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] btrfs: reduce size of struct btrfs_free_space_ctl
Date: Wed, 15 Apr 2026 15:38:09 +0100
Message-ID: <7a07424af114440a79349830ff42e26269c0e8ff.1776263553.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1776263553.git.fdmanana@suse.com>
References: <cover.1776263553.git.fdmanana@suse.com>
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

