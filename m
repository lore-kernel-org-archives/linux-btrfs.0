Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58133254BD
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773776830; cv=none; b=ertF6n1Egv+IDYBakMcRcbw7AnlwIdr9pzlSXBo8WNtQk9ZR2yCKpEyHsmNeoD6BtjNzIeRAYGWufrJjvk6wu//ou7CvbgJrwFKJ0DJ5JMe13x0D7/J2sd2Mph+3BT59X87LCNyG45h+wylQyCxl72Hy2/80UvPvoop3ONZ4VG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773776830; c=relaxed/simple;
	bh=hp3GhMCjNJxOj5Jx0PHxX9cac11syk0lxk3e2eIDw9g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgBs+4XvtL08hq3Pcdww8El2v5LOEOPJGEb3DwXS/CkH/U3rNbMQPp0OZhrhsH8vfL6im3JbgNsSCC9AVljTshrzBA5PgHscigOgcacgdmgN1A4MgAltsiKsFkvOPucUJnqqwx9kGkl3NIxIbA0Nyu3555pRU+x1B/oJdsvhOAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KCJfSUea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KCJfSUea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E958C2BC9E
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 19:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773776830;
	bh=hp3GhMCjNJxOj5Jx0PHxX9cac11syk0lxk3e2eIDw9g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KCJfSUeaUMVESRcX/Ji0n0m+N+rxmTOUuUMv3RaBfqnjPTic07uQ9e3583cSfO00W
	 M5+qFXp3CF29WeXzEyZqenAr+GzKauuc2YweLCUG7ApIMP86fve8HHIDjPUCNEm65m
	 HZJR9FIlrI2gmRHucWvg5mPi43JcZMP3BXp8+dCKaEJVjI85jFCI4AZl+yUSwEDVpc
	 9unX5UBu2N7p4XjQgxI10wzNcgJr7wIokHCZ1pRZi3c6dVzuAqBCo0oBQorxTr5kLp
	 A7VPF2ZDa+YdGcAjgh20vCVio4HB5a/EbNpwxD9pIch7JQo26mldu8EP8w7WQt0dyp
	 ZblSanS7/w7BQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs: removed unused qgroup functions for pertrans reservation and freeing
Date: Tue, 17 Mar 2026 19:47:00 +0000
Message-ID: <f0c0642868d1f968e675511d566caf9a7efbddc6.1773776355.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1773776354.git.fdmanana@suse.com>
References: <cover.1773776354.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

They have no more users since commit a6496849671a ("btrfs: fix start
transaction qgroup rsv double free"), so remove them.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.h | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index a979fd59a4da..419f3c4120ce 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -397,14 +397,7 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 				enum btrfs_qgroup_rsv_type type, bool enforce,
 				bool noflush);
-/* Reserve metadata space for pertrans and prealloc type */
-static inline int btrfs_qgroup_reserve_meta_pertrans(struct btrfs_root *root,
-				int num_bytes, bool enforce)
-{
-	return __btrfs_qgroup_reserve_meta(root, num_bytes,
-					   BTRFS_QGROUP_RSV_META_PERTRANS,
-					   enforce, false);
-}
+
 static inline int btrfs_qgroup_reserve_meta_prealloc(struct btrfs_root *root,
 						     int num_bytes, bool enforce,
 						     bool noflush)
@@ -417,14 +410,6 @@ static inline int btrfs_qgroup_reserve_meta_prealloc(struct btrfs_root *root,
 void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
 			     enum btrfs_qgroup_rsv_type type);
 
-/* Free per-transaction meta reservation for error handling */
-static inline void btrfs_qgroup_free_meta_pertrans(struct btrfs_root *root,
-						   int num_bytes)
-{
-	__btrfs_qgroup_free_meta(root, num_bytes,
-			BTRFS_QGROUP_RSV_META_PERTRANS);
-}
-
 /* Pre-allocated meta reservation can be freed at need */
 static inline void btrfs_qgroup_free_meta_prealloc(struct btrfs_root *root,
 						   int num_bytes)
-- 
2.47.2

