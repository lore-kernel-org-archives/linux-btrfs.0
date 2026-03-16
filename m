Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0669303A32
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677661; cv=none; b=BduFJoidJJrq4iVen9bWpim5j4bsZHgDaqMsS0X7supkxDGHK3FefSbgK/Tw52rkMkE0cTsbl5Q+pyzxcthVwgwyJm+GeLChpq4nGZdU7rn5UOumdAy/iNpJTYDpzC9/tj+SEjReS6OiEqIw1SBE1Z8Inrl5L975HXS1LwQQ+sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677661; c=relaxed/simple;
	bh=VosC4Cq5vmQm1KJIZtCAaY9V9po4gVy5qsrZaHHNJRs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr8PExQCKhSEO6EKKqHJi+7npzPkGKnHN7PE0j8jwrGGeUCbNlMBRSrlnvrUvKQWdBRO88zY6TmfyoSfZu8L4Tsfh3FNkt8yznzdqKJDlwcslRIGImGxdBPjnk0LVjZ38kcDfZmgPYFmsLlf1PVJnFnWcSMgUIzQKyL1rP62ySk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGmciNXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGmciNXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF84C19421
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 16:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773677661;
	bh=VosC4Cq5vmQm1KJIZtCAaY9V9po4gVy5qsrZaHHNJRs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eGmciNXx8JEmZzNBY395+MTPBxylMyyUMWrb1kHNSMZGetfoz/FAyHYmduIpVWf13
	 qVhSr8EkpcUmXJXM4HJr8SQXGp71RTFUMB3/2a93UGTHecbnl0YvvA4ucf6hzzGBqB
	 suZjhUi5d6JEENndjvoLi4DfSntWED+hKZ9MUIwUY1VRWxE5MuaHNNA+YyngE+/rHZ
	 FgB8K7pXVuLr6k08L/B6/VunytH87aZ0Vvy0dzfV3f75I8KvHG7kkG5TWuB9ZbyJzy
	 rE1nmU7rMcOsW3cUbYFLcvxZ14Ts1RRT8u1QtyCli9xITRL89U2LZdjatY0dUPUBpA
	 fJu4Ly6WiSqGw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/11] btrfs: tag as unlikely branches that call extent_io_tree_panic()
Date: Mon, 16 Mar 2026 16:14:06 +0000
Message-ID: <5dcbfac4fdd15ca6693668ca01c93b5d1121705f.1773676775.git.fdmanana@suse.com>
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

It's unexpected to ever call extent_io_tree_panic() so surround with
'unlikely' every if statement condition that leads to it, making it
explicit to a reader and to hint the compiler to potentially generate
better code.

On x86_64, using gcc 14.2.0-19 from Debian, this resulted in a slightly
decrease of the btrfs module's text size.

Before:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  1999832	 174320	  15592	2189744	 2169b0	fs/btrfs/btrfs.ko

After:

  $ size fs/btrfs/btrfs.ko
     text	   data	    bss	    dec	    hex	filename
  1999768	 174320	  15592	2189680	 216970	fs/btrfs/btrfs.ko

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-io-tree.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 68e48b493950..93dca9199249 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -696,7 +696,7 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 			goto search_again;
 		ret = split_state(tree, state, prealloc, start);
 		prealloc = NULL;
-		if (ret) {
+		if (unlikely(ret)) {
 			extent_io_tree_panic(tree, state, "split", ret);
 			goto out;
 		}
@@ -762,7 +762,7 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
 		if (!prealloc)
 			goto search_again;
 		ret = split_state(tree, state, prealloc, end + 1);
-		if (ret) {
+		if (unlikely(ret)) {
 			extent_io_tree_panic(tree, state, "split", ret);
 			prealloc = NULL;
 			goto out;
@@ -1203,7 +1203,7 @@ static int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		if (!prealloc)
 			goto search_again;
 		ret = split_state(tree, state, prealloc, start);
-		if (ret)
+		if (unlikely(ret))
 			extent_io_tree_panic(tree, state, "split", ret);
 
 		prealloc = NULL;
@@ -1293,7 +1293,7 @@ static int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		if (!prealloc)
 			goto search_again;
 		ret = split_state(tree, state, prealloc, end + 1);
-		if (ret) {
+		if (unlikely(ret)) {
 			extent_io_tree_panic(tree, state, "split", ret);
 			prealloc = NULL;
 			goto out;
@@ -1448,7 +1448,7 @@ int btrfs_convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		}
 		ret = split_state(tree, state, prealloc, start);
 		prealloc = NULL;
-		if (ret) {
+		if (unlikely(ret)) {
 			extent_io_tree_panic(tree, state, "split", ret);
 			goto out;
 		}
@@ -1532,7 +1532,7 @@ int btrfs_convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		}
 
 		ret = split_state(tree, state, prealloc, end + 1);
-		if (ret) {
+		if (unlikely(ret)) {
 			extent_io_tree_panic(tree, state, "split", ret);
 			prealloc = NULL;
 			goto out;
-- 
2.47.2

