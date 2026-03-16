Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7DE333745
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677662; cv=none; b=F/kQf2d2VTC0zY9WfH3bzm7GzVDVwrsNyZkFHcWGaL/f3Ol5lzDtGrcCJ0sclsAiEenwhnrXuaeHvfhHF6zd+3OqULGaFtN9gmx6jjOhVMJQADZZSARFBqIjb8+Nr1246NrN3fb1sshspCk/hsPBSdOaYw8WllNWYNj40OhpsC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677662; c=relaxed/simple;
	bh=GC7OcRwQpmH+IqHj3vyhicsfFJ+8K+2y2aljsZOP0Yc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeHnTfv213ubMUNQSVB3x1w/5fVfMaxFlFNQ/s186cX2PI6ghAFpqlSuPrATfQprwQnyCFlN4sqXCKbs+pCHPhP/4AQ00tyFJUqJGXP2cCYMe96MPSKSnezDze20KWQYUo8uP8fIl9aLtE8FvEhEx1YNtoHDfb5klpJQSG54gdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cpT68qhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpT68qhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1131C19421
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677662;
	bh=GC7OcRwQpmH+IqHj3vyhicsfFJ+8K+2y2aljsZOP0Yc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cpT68qhBFjzjnp5aZOFegq7WWQCGkNFrmSE7n4r22yBHDSEtuUhj72jNF6Ehaa6zo
	 X/JMpGc23DLWvb0FAPsF2gntmQXDmAlzBx11hlQAx6EvbbhwntD5CbVqA/LlACve+f
	 tLfKPfew5XV+G76hHypsMiW/7aRh1GQKvrbCi2wPC7iMyd1oQQNrk8MerOXg44QkvA
	 fDQy4E82Mt1t3OLC/PUlEO+O30wTOS2Bc7m0U+v2pFghA09gC7dhCutiu4AD3CFFjY
	 zvVHDYFhYUjxwixc2J7CrAw5c/JfPCkrSkbGcIbYw1K+wPD4gM7qDZUU4L7AWGoB5a
	 bAJjHDD7yHuCw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/11] btrfs: make add_extent_changeset() only return errors or success
Date: Mon, 16 Mar 2026 16:14:07 +0000
Message-ID: <02445b0a42cdedd284e1c87cfe2f4e4d8ae9aff8.1773676775.git.fdmanana@suse.com>
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

Currently add_extent_changeset() always returns the return value from its
call to ulist_add(), which can return an error, 0 or 1. There are no
callers that care about the difference between 0 and 1 and all except one
of them, check for negative values and ignore other values, but there is
another caller (btrfs_clear_extent_bit_changeset()) that must set its
'ret' variable to 0 after calling add_extent_changeset(), so that it
does not return an unexpected value of 1 to its caller.

So change add_extent_changeset() to only return errors or 0, avoiding
that caller (and any future callers) from having to deal with a return
value of 1.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 93dca9199249..5972fe28716e 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -187,6 +187,8 @@ static int add_extent_changeset(struct extent_state *state, u32 bits,
 				 struct extent_changeset *changeset,
 				 int set)
 {
+	int ret;
+
 	if (!changeset)
 		return 0;
 	if (set && (state->state & bits) == bits)
@@ -195,7 +197,10 @@ static int add_extent_changeset(struct extent_state *state, u32 bits,
 		return 0;
 	changeset->bytes_changed += state->end - state->start + 1;
 
-	return ulist_add(&changeset->range_changed, state->start, state->end, GFP_ATOMIC);
+	ret = ulist_add(&changeset->range_changed, state->start, state->end, GFP_ATOMIC);
+	if (ret < 0)
+		return ret;
+	return 0;
 }
 
 static inline struct extent_state *next_state(struct extent_state *state)
@@ -745,7 +750,6 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 						     "add_extent_changeset", ret);
 				goto out;
 			}
-			ret = 0;
 
 			if (tree->owner == IO_TREE_INODE_IO)
 				btrfs_clear_delalloc_extent(tree->inode, state, bits);
-- 
2.47.2

