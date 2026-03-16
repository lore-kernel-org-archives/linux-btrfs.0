Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F5E33468C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677663; cv=none; b=Fptbe1SALMEMfjpxiBVY27zr4zDOWDuqvoN1mRJ8wAUp0TnJfL3OamN1V2afZJcGGHNk426mDSCh1yiYw7wxKpkoCr5j1C0HFemskO3qz+0Z/NGTIJYBDj7ZXH/TXZvkK5BVm5Tjjs5zjdprl16kVQlO9C3LlhEWtXneus9N8Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677663; c=relaxed/simple;
	bh=3ucqsHv3wSI99hTWT6qp5XOjTvGbt0EEBAx5JJ1Yhm4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sh6ReVpgOHSfN6fWKWN+4NNfZQGPyhYKREHb1ncAyB6HDlMD6NDHwlYN0kiRRg8uCIzTthgxRtWQQU8/P7QfR3/Uq13CgWE+v+ah758yRsNsWX5p03gqR0T8YqfThQ4OMrHtSf9k4BZnul6GidLk8EJf70zKGHhFPKxb64Bs93w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTGXnUyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTGXnUyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73A8C19425
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677663;
	bh=3ucqsHv3wSI99hTWT6qp5XOjTvGbt0EEBAx5JJ1Yhm4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UTGXnUyxoDGkCBXVBMKGFYeS4r1iFtf9Zirkjbd7D6BjQvlf417xzC9OfKpEKp7QV
	 aH8kTruzquXbi3t5Hqv+v3Vl6/HwhPCTkWC/+14c/l5pAnvGobRqbp1KZi39h3M3Uu
	 3ugTee93DQVDXLC9v9ip0noHcMyMBJS3jkGSYqjwujfity+ejOVKzL4SZA/fSDWQ5a
	 1kDGbTQa6rzPuL1jWZgIJjrrokH4KUBsyMN4clTRpMbo2ZZJ2pkiUJEy1G74O9gpCS
	 ZtE3HzRdcTepTzSaUarsuzGawfop6iOI5R/IJ3YB54iXrxLOxcP92Ds2HqGvTeYXwm
	 n3Sgvn476QJUg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/11] btrfs: use extent_io_tree_panic() instead of BUG_ON()
Date: Mon, 16 Mar 2026 16:14:08 +0000
Message-ID: <24685790cf25bebeb74912e62a1b3191ba0d1c4a.1773676775.git.fdmanana@suse.com>
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

There's no need to call BUG_ON(), instead call extent_io_tree_panic(),
which also calls BUG(), but it prints an additional error message with
some useful information before hitting BUG().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 5972fe28716e..c2ede01f1762 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -395,7 +395,8 @@ static void set_state_bits(struct extent_io_tree *tree,
 		btrfs_set_delalloc_extent(tree->inode, state, bits);
 
 	ret = add_extent_changeset(state, bits_to_set, changeset, 1);
-	BUG_ON(ret < 0);
+	if (unlikely(ret))
+		extent_io_tree_panic(tree, state, "add_extent_changeset", ret);
 	state->state |= bits_to_set;
 }
 
@@ -567,7 +568,8 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 		btrfs_clear_delalloc_extent(tree->inode, state, bits);
 
 	ret = add_extent_changeset(state, bits_to_clear, changeset, 0);
-	BUG_ON(ret < 0);
+	if (unlikely(ret))
+		extent_io_tree_panic(tree, state, "add_extent_changeset", ret);
 	state->state &= ~bits_to_clear;
 	if (wake)
 		wake_up(&state->wq);
-- 
2.47.2

