Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7FC334C39
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677666; cv=none; b=BLCcCYjXcqpXbEEM8qmuWbxKY/4L3i/xCnW/gR5+bHy4uKXv3PEz0O0yRegVt44GH9tPYJFicfFhsMhj5NO1gTHKioymsfUP6FzkpIivMCHc8ou+A4Hw0wskFxWLVrChdBvNDOkX56Tl/JYgh4f5wxlfatUKOmW+arT5i9QebV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677666; c=relaxed/simple;
	bh=hlxSSj216h6OJ9vxrS652BOB1aOpNWndk1ZKMwVxal0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaPMy1UcPX95T1A23aO2UugHjnvvRR0W6Cpj/6yG3uHu996uTE9duQbywKc16vhWyNGtMoyQsl/KwrXRZ6XRJDSfX2jQ/0X4AJ/lgrs5uBvwTC8OAzwKqK3Ry4wb7KKUyfUtzzQmjTabnV49mBNezQ+6IfbJX/v7mAL6mbn1Mhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBFpiNug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBFpiNug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D54AC19421
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677665;
	bh=hlxSSj216h6OJ9vxrS652BOB1aOpNWndk1ZKMwVxal0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gBFpiNugGeLdofuo/ILA5A2u4jYkLMyVJ9maKJYvX9qu/JMwr0zqYCyclN6T8cW3e
	 Va37Q0TR7N64fZy0RLN5+mE44Eu+j9F1S4KBSaTq11k/6AJgRbaYRoVNKm4fxegt69
	 05NEYYuCPbF+eLgoGfyNmzmt0qnGRBgAworknhk0wE8wcax55JcSELDusCumU+H2m0
	 Lm1vX1xpyJQROz2xYJ6re3Wdn4pL7dr2483qeQGWUoU3ZZAdYu9nRvoaGmoRjVC5xO
	 lweDzGcrUEh9vdoOYff/COWTaNDaiRBYW+rLo/V7c9Uk7UQz29TEyL/LcpaZiFHz2A
	 bhY44OKHOOzGw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/11] btrfs: avoid unnecessary wake ups on io trees when there are no waiters
Date: Mon, 16 Mar 2026 16:14:11 +0000
Message-ID: <d001deb68dd2b5635be02c2490ff6f39a3b4d8af.1773676775.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1773676775.git.fdmanana@suse.com>
References: <cover.1773676775.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Whenever clearing the extent lock bits of an extent state record, we
unconditionally call wake_up() on the state's waitqueue. Most of the
time there are no waiters on the queue so we are just wasting time calling
wake_up(), since that requires locking and unlocking the queue's spinlock,
disable and re-enable interrupts, function calls, and other minor overhead
while we are holding a critical section delimited by the extent io tree's
spinlock.

So call wake_up() only if there are waiters on an extent state's wait
queue.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 5ffb99c258e9..0d9437e72bd4 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -536,6 +536,24 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 	return 0;
 }
 
+static inline void state_wake_up(struct extent_io_tree *tree,
+				 struct extent_state *state, u32 bits)
+{
+	lockdep_assert_held(&tree->lock);
+
+	if (!(bits & EXTENT_LOCK_BITS))
+		return;
+
+	/*
+	 * No memory barriers because the tree's lock is held while:
+	 *
+	 * 1) Adding waiters to the queue.
+	 * 2) Waking up waiters.
+	 * 3) Removing waiters from queue.
+	 */
+	cond_wake_up_nomb(&state->wq);
+}
+
 /*
  * Use this during tree iteration to avoid doing next node searches when it's
  * not needed (the current record ends at or after the target range's end).
@@ -571,8 +589,7 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 	if (unlikely(ret))
 		extent_io_tree_panic(tree, state, "add_extent_changeset", ret);
 	state->state &= ~bits_to_clear;
-	if (bits & EXTENT_LOCK_BITS)
-		wake_up(&state->wq);
+	state_wake_up(tree, state, bits);
 	if (state->state == 0) {
 		next = next_search_state(state, end);
 		if (extent_state_in_tree(state)) {
@@ -618,7 +635,6 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 	u64 last_end;
 	int ret = 0;
 	bool clear;
-	bool wake;
 	const bool delete = (bits & EXTENT_CLEAR_ALL_BITS);
 	gfp_t mask;
 
@@ -632,7 +648,6 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 	if (bits & EXTENT_DELALLOC)
 		bits |= EXTENT_NORESERVE;
 
-	wake = (bits & EXTENT_LOCK_BITS);
 	clear = (bits & (EXTENT_LOCK_BITS | EXTENT_BOUNDARY));
 again:
 	if (!prealloc) {
@@ -758,8 +773,7 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 			state->start = end + 1;
 			state->end = orig_end;
 
-			if (wake)
-				wake_up(&state->wq);
+			state_wake_up(tree, state, bits);
 			goto out;
 		}
 
@@ -773,8 +787,7 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 			goto out;
 		}
 
-		if (wake)
-			wake_up(&state->wq);
+		state_wake_up(tree, state, bits);
 
 		clear_state_bit(tree, prealloc, bits, end, changeset);
 
-- 
2.47.2

