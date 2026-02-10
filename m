Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78910327C12
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2026 11:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770724674; cv=none; b=koQ0P0u//7BQMNHPQQLSzkCC2/hOR2rGdi9zjZa99Jt1Z4opPsxKWhiXr8o6fRZn4iuirYISufGTEw4qe8aEMByDgVt8Wo18+FLpa8CrreSvNtkEaVupYveetbsAvmWSWCtmfik6xqfKoO+g68KndIwbvpQutqnTn84PvV2/sYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770724674; c=relaxed/simple;
	bh=Tg+CPJeA529GIZKa7HHmQRrjHlk3Fwf6iiIifaGIr/E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qdo6cyXwzSSiWeCZ/yrDApDuN2pMkrd/8OXN5F6AuRz+of5svDj+J5nxxeVlc3QyBqxjUzAhFK1FZ+BMBXDNvi4rEURtYxbD1q4l9bGWtQ1xqkCp+ILJNwVAg9fe7oPdf8iNL8P7odOhT5o4AXZGSj6rrMJFbpoyYqDx7WGiy20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SXFJEkFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXFJEkFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD387C16AAE
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2026 11:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770724674;
	bh=Tg+CPJeA529GIZKa7HHmQRrjHlk3Fwf6iiIifaGIr/E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SXFJEkFeba+aahWZE5rai0pVW0CWpcIZX28YO4GhOptsKr6PGzyrP6Uk8d+DYEYBd
	 ziClB7jOoPIRvRYoIwdcf9LERoRelKKScomYz+14/2lNldI+xYoUdU3t/izab53fXy
	 b3nc9+Du14+aEoKAVuqNAUwVFNrZWGjausXBkHs5esgb1OkjQjSzcIDDLxdAJW1+/Z
	 mVjSSTzgUW2LtJQrvJERhDPLWKksaSxj4BHMtayK9hZnDLcKWahgX7PbE2ZN/KHkPs
	 Mcr8CrSFeTOLZhHVL+V2q3YOBYePeZdfc+GJF/tY5ImD7J+4j7dJVntkCboObvApIV
	 uiOj6tiuOce7A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: remove bogus root search condition in load_extent_tree_free()
Date: Tue, 10 Feb 2026 11:57:48 +0000
Message-ID: <9888f679a8d71485979a97b634d8096cdad5dc5b.1770724034.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1770724034.git.fdmanana@suse.com>
References: <cover.1770724034.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There's no need to pass the maximum between the block group's start offset
and BTRFS_SUPER_INFO_OFFSET (64K) since we can't have any block groups
allocated in the first megabyte, as that's reserved space. Furthermore,
even if we could, the correct thing to do was to pass the block group's
start offset anyway - and that's precisely what we do for block groups
hat happen to contain a superblock mirror (the range for the super block
is never marked as free and it's marked as dirty in the
fs_info->excluded_extents io tree).

So simplify this and get rid of that maximum expression.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 764caaf1d8b2..17a18f17538d 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -728,7 +728,7 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 	u64 total_found = 0;
-	u64 last = 0;
+	u64 last = block_group->start;
 	u32 nritems;
 	int ret;
 	bool wakeup = true;
@@ -737,7 +737,6 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 	if (!path)
 		return -ENOMEM;
 
-	last = max_t(u64, block_group->start, BTRFS_SUPER_INFO_OFFSET);
 	extent_root = btrfs_extent_root(fs_info, last);
 
 #ifdef CONFIG_BTRFS_DEBUG
-- 
2.47.2

