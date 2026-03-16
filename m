Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEC3334C0D
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677665; cv=none; b=WPHCxR1uvKUeawvDCnhBXbXxd0weYjazHaeZTZSlh4c8RpVDLZcw8A7FxE9zDXRSQhDIP/wuAX5JuCijaTWv48kmEzeaGStK+/65D4ZrCz+Pp/zIBu3FcC635U8wAGEi87ggGvQ19CY/oR6oovyb2/BdXeuBgrHVSSjbScrci0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677665; c=relaxed/simple;
	bh=cvbDFJO/EZ/7VAJn51+TrHq3XSLm42305FlpbCRPUT8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkGwT/HpdCEEw8sdQNwveOJP6JzdTieX1bhnzU1WDxsT7ujZgAa7xOjAc+JKxomC2foq183stURY/AmX9vzVyAhnrIET230hvr6wkKsi89oWY9PVVvdSHALYGafrTmKALoJyC9QX/WU1zAe2TD6qSn5LgevcjbeOhftdo6rkTbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=noCUSNo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="noCUSNo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F31C19421
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677664;
	bh=cvbDFJO/EZ/7VAJn51+TrHq3XSLm42305FlpbCRPUT8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=noCUSNo5srISFtWEZNRsU6XBmMG/NZXI8Na1As7nE+IDVo6skxS1u9Xr2upf9BS0X
	 R0PDjD2vhHGFx/HNB0qZqK3r64hIVw4OuKtGpo3f+EWrJTnFgdbhydhs2bzrsMvGpB
	 rYuAemxrrQ8QHKmIs/32Sxh3UxKYCfKqjvF+6P/zu+hBc/qFeydkkyRt9bI/c6x9hr
	 iKwf/CsNLbUo/FJIH+hEft4K/OJZ+6726mN7zQYFVkQDTrD/gBgNKR0Y6yUy+4+g03
	 FUIDSsTzMaTu7BFE4+e9ojHeN21j0NN4IhoC8HtuBZNWlOw3PyLzsv/mzaDLJA25te
	 zWgyne5T7oBvA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/11] btrfs: remove wake parameter from clear_state_bit()
Date: Mon, 16 Mar 2026 16:14:10 +0000
Message-ID: <96fe9129f85ed910d38bd02b0e046e23db4a4cd6.1773676775.git.fdmanana@suse.com>
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

There's no need to pass the 'wake' parameter, we can determine if we have
to wake up waiters by checking if EXTENT_LOCK_BITS is set in the bits to
clear. So simplify things and remove the parameter.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index a99e67585d64..5ffb99c258e9 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -550,14 +550,14 @@ static inline struct extent_state *next_search_state(struct extent_state *state,
 
 /*
  * Utility function to clear some bits in an extent state struct.  It will
- * optionally wake up anyone waiting on this state (wake == 1).
+ * optionally wake up anyone waiting on this state.
  *
  * If no bits are set on the state struct after clearing things, the
  * struct is freed and removed from the tree
  */
 static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 					    struct extent_state *state,
-					    u32 bits, int wake, u64 end,
+					    u32 bits, u64 end,
 					    struct extent_changeset *changeset)
 {
 	struct extent_state *next;
@@ -571,7 +571,7 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 	if (unlikely(ret))
 		extent_io_tree_panic(tree, state, "add_extent_changeset", ret);
 	state->state &= ~bits_to_clear;
-	if (wake)
+	if (bits & EXTENT_LOCK_BITS)
 		wake_up(&state->wq);
 	if (state->state == 0) {
 		next = next_search_state(state, end);
@@ -708,8 +708,7 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 			goto out;
 		}
 		if (state->end <= end) {
-			state = clear_state_bit(tree, state, bits, wake, end,
-						changeset);
+			state = clear_state_bit(tree, state, bits, end, changeset);
 			goto next;
 		}
 		if (need_resched())
@@ -777,13 +776,13 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 		if (wake)
 			wake_up(&state->wq);
 
-		clear_state_bit(tree, prealloc, bits, wake, end, changeset);
+		clear_state_bit(tree, prealloc, bits, end, changeset);
 
 		prealloc = NULL;
 		goto out;
 	}
 
-	state = clear_state_bit(tree, state, bits, wake, end, changeset);
+	state = clear_state_bit(tree, state, bits, end, changeset);
 next:
 	if (last_end >= end)
 		goto out;
@@ -1422,7 +1421,7 @@ int btrfs_convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	if (state->start == start && state->end <= end) {
 		set_state_bits(tree, state, bits, NULL);
 		cache_state(state, cached_state);
-		state = clear_state_bit(tree, state, clear_bits, 0, end, NULL);
+		state = clear_state_bit(tree, state, clear_bits, end, NULL);
 		if (last_end >= end)
 			goto out;
 		start = last_end + 1;
@@ -1461,7 +1460,7 @@ int btrfs_convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		if (state->end <= end) {
 			set_state_bits(tree, state, bits, NULL);
 			cache_state(state, cached_state);
-			state = clear_state_bit(tree, state, clear_bits, 0, end, NULL);
+			state = clear_state_bit(tree, state, clear_bits, end, NULL);
 			if (last_end >= end)
 				goto out;
 			start = last_end + 1;
@@ -1546,7 +1545,7 @@ int btrfs_convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 		set_state_bits(tree, prealloc, bits, NULL);
 		cache_state(prealloc, cached_state);
-		clear_state_bit(tree, prealloc, clear_bits, 0, end, NULL);
+		clear_state_bit(tree, prealloc, clear_bits, end, NULL);
 		prealloc = NULL;
 		goto out;
 	}
-- 
2.47.2

