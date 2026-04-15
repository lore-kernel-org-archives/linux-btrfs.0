Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1563382F10
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278702; cv=none; b=ZmEkrk6d0dRlEgNVkEoYqIhdi5m+X2qGACIFp6aILkWNR9H2Q2UcllKwRY6J1Y9JfJLUBrtC4Ho7hYTLt5zohbZOjaWfsVmGZ0z5wEA4cNrfGkT6lY2JII5exPaHqBjYlYzp0PClOJUj0gnrlya0EOD8Tf4UJbFDktkv9LSD0UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278702; c=relaxed/simple;
	bh=EYP9fStzQfpOaplpbLl3HZf+7vL6ieWNB7W6wsVEx6Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/4yxGLbNwYTiWfm62SM9yruzzRZjOJIJ798ttxFl6JCBZ4KQA2AlfL4Ntouq2NgwoITFTxl0Ar6PvN7bI5HOstGMn30PtlObw4Sn9pDUb5yOWHSZmnvKSp2Jm/4BwotQ9bzOtjZ2j1M1FgknqdMfRkjzRyYr4FVuTX1TYjhM88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MVjXtlVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVjXtlVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE9BC2BCB4
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776278702;
	bh=EYP9fStzQfpOaplpbLl3HZf+7vL6ieWNB7W6wsVEx6Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MVjXtlVcYMAEEPhVb7ez6f5Xv6MtKwko+UKKzTLM/RNvxC3ZvYkGGVOShJc5bNp/f
	 JzJaNfh577Jmi3zapSHyK7atIZUAZkV+HU+HmGofZyogOiNRakHVfW0TGo7f0hL4Si
	 uPkGt9oUDW7Q7w61gpnnqO50F+J11DPTHobfY1jzdJCfVzSk1349x+Z9nDef2yyvwo
	 ZsIsIJzRGvgjadz/VubOOKXkiy55OXz4qIMdn1WMT6a1xUDcg06bKyJdPgxviuPehF
	 6vkV0unx7zL/UKsAK3/TrjXs8bcXV2jAAo9W836Zg9HfGtm4JnNFJR5R/zxtcZYy/c
	 NkwTmlDiArWGg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 08/10] btrfs: remove block group argument from copy_free_space_cache()
Date: Wed, 15 Apr 2026 19:44:46 +0100
Message-ID: <3108a39f433c65ff36d3915a1b32bbd9b457f250.1776278490.git.fdmanana@suse.com>
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

It's not necessary since we can get the block group from the given
free space control structure.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0d8bc55449b0..5ede85cf6c69 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -897,8 +897,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	goto out;
 }
 
-static int copy_free_space_cache(struct btrfs_block_group *block_group,
-				 struct btrfs_free_space_ctl *ctl)
+static int copy_free_space_cache(struct btrfs_free_space_ctl *ctl)
 {
 	struct btrfs_free_space *info;
 	struct rb_node *n;
@@ -913,7 +912,7 @@ static int copy_free_space_cache(struct btrfs_block_group *block_group,
 			unlink_free_space(ctl, info, true);
 			spin_unlock(&ctl->tree_lock);
 			kmem_cache_free(btrfs_free_space_cachep, info);
-			ret = btrfs_add_free_space(block_group, offset, bytes);
+			ret = btrfs_add_free_space(ctl->block_group, offset, bytes);
 			spin_lock(&ctl->tree_lock);
 		} else {
 			u64 offset = info->offset;
@@ -923,7 +922,7 @@ static int copy_free_space_cache(struct btrfs_block_group *block_group,
 			if (ret == 0) {
 				bitmap_clear_bits(ctl, info, offset, bytes, true);
 				spin_unlock(&ctl->tree_lock);
-				ret = btrfs_add_free_space(block_group, offset,
+				ret = btrfs_add_free_space(ctl->block_group, offset,
 							   bytes);
 				spin_lock(&ctl->tree_lock);
 			} else {
@@ -1026,7 +1025,7 @@ int load_free_space_cache(struct btrfs_block_group *block_group)
 
 	if (matched) {
 		spin_lock(&tmp_ctl.tree_lock);
-		ret = copy_free_space_cache(block_group, &tmp_ctl);
+		ret = copy_free_space_cache(&tmp_ctl);
 		spin_unlock(&tmp_ctl.tree_lock);
 		/*
 		 * ret == 1 means we successfully loaded the free space cache,
-- 
2.47.2

