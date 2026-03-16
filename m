Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EAC33262A
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677660; cv=none; b=dhzXu9JvHJG/k0FY1NJAtzYIc3vQ+hTJhvIyzWBdO0WexATtwiJ8QWGq7kPfpPBarbC73iN+aU22Yxr+v8r4VogvPOMzwTMLdqHsQ5yyTzcMNM8M/GPJQ94EG5zYYsxDEOsqV9ZLaU0RjRvL21dUUYbQoCQ1yPbkGKM0WUkMM8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677660; c=relaxed/simple;
	bh=ZqdSR7M5Jd8LuPl1xkKKW8IGLZHQDJxuwlwR8YTjEkg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiyWq0efSIImwWwe2Wn8CRxBSXUjOiScqGV5scps4Ga4OMBi3aQxmKeprIaN27hYAUpPm3ARjAfyRUx5zLja+gKbr5vsyGN1Yh3sxr5EIDdw3Yfac6IGPfFuaQNMG+8RxtTFyvn2wgfS3JC4Bxhur3Jp7Shha616n0nTJkj2/CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrVzlfgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrVzlfgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19789C19421
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677659;
	bh=ZqdSR7M5Jd8LuPl1xkKKW8IGLZHQDJxuwlwR8YTjEkg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qrVzlfgN1ZFzhCRbgact7cQnWPZTkvTfCMHBlpBxQgNK2So49aJk7qgJTYsRT1K7b
	 oXjy+tOxRmkhv87ENxzFFHjoMOPCw9BAuvYSN56bZUbWf6hDtIo3Wb1Ytg3AuSxLMD
	 Tz7w6xlRmKyEWp8zLBOxFWCdyg9QUXs4/XUstuJhNSAKcgcgyS9qSCWP2E5DhoCurw
	 E2Sxhtb4W5VwE2e5rBoOOM4e/lL4rTArByAIjOzp4TLm8kM1qSW5tq+i1S6i+eQUFS
	 dHZa1f5VEHWovZ6ur94gZqcEy2eIq4sO8BcNpA8bWgRMONZbFqzcrw5dCCZrI6o/AL
	 ku8+YdLutxxpA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 01/11] btrfs: optimize clearing all bits from the last extent record in an io tree
Date: Mon, 16 Mar 2026 16:14:04 +0000
Message-ID: <e36c9ab469103d3ac2db533ae34dc5a9c378265e.1773676775.git.fdmanana@suse.com>
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

When we are clearing all the bits from the last record that contains the
target range (i.e. the record starts before our target range and ends
beyond it), we are doing a lot of unnecessary work:

1) Allocating a prealloc state if we don't have one already;

2) Adjust that last record's start offset to the end of our range and
   make the prealloc state have a range going from the original start
   offset of that last record to the end offset of our target range and
   the same bits as the last record. Then we insert the prealloc extent
   in the rbtree - this is done in split_state();

3) Remove our prealloc state from the rbtree since all the bits were
   cleared - this is done in clear_state_bit().

This is only wasting time when we can simply trim the last record so
that it's start offset is adjust to the end of the target range. So
optimize for that case and avoid the prealloc state allocation, insertion
and deletion from the rbtree.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index d0dd50f7d279..4ba916cb27ac 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -724,6 +724,45 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 	 * We need to split the extent, and clear the bit on the first half.
 	 */
 	if (state->start <= end && state->end > end) {
+		const u32 bits_to_clear = bits & ~EXTENT_CTLBITS;
+
+		/*
+		 * If all bits are cleared, there's no point in allocating or
+		 * using the prealloc extent, split the state record, insert the
+		 * prealloc record and then remove it. We can just adjust the
+		 * start offset of the current state and avoid all that.
+		 */
+		if ((state->state & ~bits_to_clear) == 0) {
+			const u64 orig_end = state->end;
+
+			if (tree->owner == IO_TREE_INODE_IO)
+				btrfs_split_delalloc_extent(tree->inode, state, end + 1);
+
+			/*
+			 * Temporarily adjust the end offset to match the
+			 * removed subrange to update the changeset.
+			 */
+			state->end = end;
+
+			ret = add_extent_changeset(state, bits_to_clear, changeset, 0);
+			if (unlikely(ret < 0)) {
+				extent_io_tree_panic(tree, state,
+						     "add_extent_changeset", ret);
+				goto out;
+			}
+			ret = 0;
+
+			if (tree->owner == IO_TREE_INODE_IO)
+				btrfs_clear_delalloc_extent(tree->inode, state, bits);
+
+			state->start = end + 1;
+			state->end = orig_end;
+
+			if (wake)
+				wake_up(&state->wq);
+			goto out;
+		}
+
 		prealloc = alloc_extent_state_atomic(prealloc);
 		if (!prealloc)
 			goto search_again;
-- 
2.47.2

