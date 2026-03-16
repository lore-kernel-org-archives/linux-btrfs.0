Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EC3332EB1
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677668; cv=none; b=Z8PywjJ4HJsfU/yg4BOrjDBUxnRB7HIDZIMHmtXjRiZyaZzcuop+IfljaFxk8cGkPst5RSMPaRfD75ARG6FEbngVFznzejWzOHG+PtVP8ezSWLJEpTcgXNTL804Q142lnDcCyRlsQKbzRRYvuvH+f94GpxAOCWgyPg9FU9zLGAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677668; c=relaxed/simple;
	bh=zgyMwuxMnjoSq1M2pDPyNCNxQAiuVS6Jj44OxrdBGbg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jafAn/B517/EcOEp46keFf9Z1PK6BZ9uZiE+yM8G7P27EY+DcZ47swLwp2zxg+GD2dzp8hSARf4jtHx8kfp3S/8MXLOjjQnjRhNZKxTrevr3MbCHKIOOY0O6GqQAb/hfr7ohGTBvPflz2H1PRVQMGIwIng8oB0a05DaE1SrHENk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQvvkwJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQvvkwJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B895C2BC9E
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677667;
	bh=zgyMwuxMnjoSq1M2pDPyNCNxQAiuVS6Jj44OxrdBGbg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WQvvkwJ/VI7yFhpnZIiukdsIvBa/C541fzHsvwzSAoJC6CmQqiU6Fcid9oZ9xX386
	 bkvljWHq1zAJfzeskiK9mqFr97ZLlRTKCbvwn7l4iwky4fxuYOD1QZU17Jtr6MoOy4
	 AWxJXS2nJWzjBaLtH+5PHTH7qaG7vzEA17EMP8XU8fNSHPk9YwXRLNajdpRhbwdzqw
	 eHQ8ZqTZMSWGU8PJtm+t/kxUd/n/t5rQkhti8VPHzaUeHKTbK7bMhA0WZqy0MagnWt
	 rGZGr0pnwE/RItjiXT58jEQz5aXagi0/dpumKWHW6DZ2WMf+xsalYcoeoRiX1yCS2N
	 9lJ41yws1PTXg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/11] btrfs: panic instead of warn when splitting extent state not in the tree
Date: Mon, 16 Mar 2026 16:14:13 +0000
Message-ID: <80720dfbe2a3084fe8f25e44d2d931ed26d0d2ed.1773676775.git.fdmanana@suse.com>
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

We are not expected ever to split an extent state record that is not in
the rbtree, as every record we pass to split_state() was found by
iterating the rbtree, so if that ever happens it means we are not holding
the extent io tree's spinlock or we have some memory corruption.

Instead of simply warning in case the extent state record passed to
split_state() is not in the rbtree, panic as this is a serious problem.
Also tag as unlikely the case where the record is not in the rbtree.

This also makes a tiny reduction the btrfs module's text size.

Before:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  2000080	 174328	  15592	2190000	 216ab0	fs/btrfs/btrfs.ko

After:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  2000064	 174328	  15592	2189984	 216aa0	fs/btrfs/btrfs.ko

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 29fcd08b9ca9..72ddd8d2e7a3 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -591,14 +591,13 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 	state->state &= ~bits_to_clear;
 	state_wake_up(tree, state, bits);
 	if (state->state == 0) {
+		if (unlikely(!extent_state_in_tree(state)))
+			extent_io_tree_panic(tree, state, "extent_state_in_tree", -EUCLEAN);
+
 		next = next_search_state(state, end);
-		if (extent_state_in_tree(state)) {
-			rb_erase(&state->rb_node, &tree->state);
-			RB_CLEAR_NODE(&state->rb_node);
-			btrfs_free_extent_state(state);
-		} else {
-			WARN_ON(1);
-		}
+		rb_erase(&state->rb_node, &tree->state);
+		RB_CLEAR_NODE(&state->rb_node);
+		btrfs_free_extent_state(state);
 	} else {
 		merge_state(tree, state);
 		next = next_search_state(state, end);
-- 
2.47.2

