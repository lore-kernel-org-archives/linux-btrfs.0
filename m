Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5814F332EA2
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677664; cv=none; b=CjhB+Mf+NEwPGrmYhp1xPM6l6yGgY3nb5PmksuNxMwtwpbShnY+7HWO38CX1XE+v/oExt11Odssv6V3azCSk3cE0NW95LT7AVJOZ1WquA/YHia3li8YtbZSOypaurDS8N9DcHZ5Y2lrt+WipOQTXd1ioj2o+rwPqGIbDxsTAKgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677664; c=relaxed/simple;
	bh=J+RoL+gdYVvHEhpC/3gZFBX5PjczCUAWaVBPdvZyS1E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q67qL2voF7X0JPEyucHpCVtqbm1p7Wtnxpnoh6SwYShcLiJ8wxgc0Vlf9DaipReTTbE/PPY/EgshB4FejOpruhG+V3wDGgx3vMpafZ08kfa1FSgLSmgfmniAxjO8xfW7RgUhealIVHBMj/32urg058i1yi/XF0//KsutwGROrHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sJ9hSbpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sJ9hSbpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF51C19425
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677664;
	bh=J+RoL+gdYVvHEhpC/3gZFBX5PjczCUAWaVBPdvZyS1E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sJ9hSbpEuXdALTXAZ7qHgjzf5DhE2Qt+2Q0oXBCyw9XjxqnXjg9aE49fPKtYnXQZp
	 PvQCptQis59kzr+OWJVg8eBOpw5XwKLq/ez/T2USe1HaBgnLKjy7l3fRN0nrtW+gNv
	 pHN81D9ufZRtk4zHqMnOhTcjk7K38O2Ta+tyIT/0cb2/BSkDODKq3rrW2NVs2faQwu
	 6vHcUNV0/g4KzgjzSCiCb/MYbWmLRJq79hEjZGyBou+KjFkULWQfSefkBPK+USy8Fb
	 2BBvkq+/1m2+eoZDkA8Q/rPEInOnF7fNzX0MYSa+P1+Tb6kDqiiFxrPOyiqMzblowS
	 QHI3wFr94R0Hw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/11] btrfs: change last argument of add_extent_changeset() to boolean
Date: Mon, 16 Mar 2026 16:14:09 +0000
Message-ID: <899f6217567e23acb67724520b915d09dfda1750.1773676775.git.fdmanana@suse.com>
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

The argument is used as a boolean but it's defined as an integer.
Switch it to a boolean for better readability.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index c2ede01f1762..a99e67585d64 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -185,7 +185,7 @@ void btrfs_free_extent_state(struct extent_state *state)
 
 static int add_extent_changeset(struct extent_state *state, u32 bits,
 				 struct extent_changeset *changeset,
-				 int set)
+				 bool set)
 {
 	int ret;
 
@@ -394,7 +394,7 @@ static void set_state_bits(struct extent_io_tree *tree,
 	if (tree->owner == IO_TREE_INODE_IO)
 		btrfs_set_delalloc_extent(tree->inode, state, bits);
 
-	ret = add_extent_changeset(state, bits_to_set, changeset, 1);
+	ret = add_extent_changeset(state, bits_to_set, changeset, true);
 	if (unlikely(ret))
 		extent_io_tree_panic(tree, state, "add_extent_changeset", ret);
 	state->state |= bits_to_set;
@@ -567,7 +567,7 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 	if (tree->owner == IO_TREE_INODE_IO)
 		btrfs_clear_delalloc_extent(tree->inode, state, bits);
 
-	ret = add_extent_changeset(state, bits_to_clear, changeset, 0);
+	ret = add_extent_changeset(state, bits_to_clear, changeset, false);
 	if (unlikely(ret))
 		extent_io_tree_panic(tree, state, "add_extent_changeset", ret);
 	state->state &= ~bits_to_clear;
@@ -746,7 +746,7 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 			 */
 			state->end = end;
 
-			ret = add_extent_changeset(state, bits_to_clear, changeset, 0);
+			ret = add_extent_changeset(state, bits_to_clear, changeset, false);
 			if (unlikely(ret < 0)) {
 				extent_io_tree_panic(tree, state,
 						     "add_extent_changeset", ret);
-- 
2.47.2

