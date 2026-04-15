Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760153845DA
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278704; cv=none; b=sU+Ki/sHjuR5AwtE/v19yze/eUDUj4CDapAOkjtaPCGzjDQgvHnGGZ+8iRxFMiKdhpiV2i+FjWZ8J/03zyjloGoIbBAkg0AoeTgovFDTMjYAbjplLHw7Ptft2VvzW+gafcrBkxdtbDbdd2kB9y8mqBNuqzz8KcLjVkxpZQ9AxaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278704; c=relaxed/simple;
	bh=SW9i1qQBNEdQUug5t74IqjCgLUPp/erMC404r0BIhIA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKmhXlp5UrGaJRU1ypvskmFb8Q3LQxiIl2SBY1IqUdaWgvtxXuyPk9/Rb29LIpKzMI9pIH5Q2rqjjItTAZe6iDB3GwXmQWyAKnP44LurVhk+9dsbzzyhx1g7mJd4cskRZTlYdHeuIKuDmGhO2t9kWUU32Fnp5rFZ7xZhsuao1KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kY0Qr7bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kY0Qr7bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3A6C2BCB5
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776278704;
	bh=SW9i1qQBNEdQUug5t74IqjCgLUPp/erMC404r0BIhIA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kY0Qr7bR+n1x+AixcYMV+mj0eF6HlLJtVvaQ9TTpTjoAzl20se35dPjpV4x134EsB
	 4H9p3td9tLmXngjbeoCJnU8olV/lBgmhl0hQE0EZI79UmACQ86IFB8+aZ2qu3NXFRx
	 s0bsNz2FVvqfkc53/Ynj4FZaBlyGjSxRmIZaw1BUZm5+abOhKBfLcIYUdEG24O3NOW
	 cGQGtfARV72VVw3o2B+eVasoH6m5s5YMA72RHTSCFdqJsh6QC2NKP7g6p7xTtuqfzj
	 b6HwNSYHPDRQstXsG5tme6Nl5CLuzWmStA7LO/aadB3uMmp+LGbsYUZtzsnFbhm1qn
	 okQ4evO1Pyzvw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 10/10] btrfs: remove unnecessary ctl argument from write_cache_extent_entries()
Date: Wed, 15 Apr 2026 19:44:48 +0100
Message-ID: <ccbe658c3f8cec23321d9e2918965285aa05c157.1776278490.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1776278490.git.fdmanana@suse.com>
References: <cover.1776278490.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There is no need to pass the free space control structure as an argument
because we can grab it from the given block group.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 76d4b7eea746..47d00fa6001f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1068,12 +1068,12 @@ int load_free_space_cache(struct btrfs_block_group *block_group)
 
 static noinline_for_stack
 int write_cache_extent_entries(struct btrfs_io_ctl *io_ctl,
-			      struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_block_group *block_group,
 			      int *entries, int *bitmaps,
 			      struct list_head *bitmap_list)
 {
 	int ret;
+	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	struct btrfs_free_cluster *cluster = NULL;
 	struct btrfs_free_cluster *cluster_locked = NULL;
 	struct rb_node *node = rb_first(&ctl->free_space_offset);
@@ -1416,8 +1416,7 @@ static int __btrfs_write_out_cache(struct inode *inode,
 	mutex_lock(&ctl->cache_writeout_mutex);
 	/* Write out the extent entries in the free space cache */
 	spin_lock(&ctl->tree_lock);
-	ret = write_cache_extent_entries(io_ctl, ctl,
-					 block_group, &entries, &bitmaps,
+	ret = write_cache_extent_entries(io_ctl, block_group, &entries, &bitmaps,
 					 &bitmap_list);
 	if (ret)
 		goto out_nospc_locked;
-- 
2.47.2

