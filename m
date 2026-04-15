Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4933D564D
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776263902; cv=none; b=eLPC9caFBHm4KXOGLjDZuCb3lnZKrOeoq5SpKTrLprJQnjziFRzfZv35DzfkEQ3r/r52fDPwAnWptAfLXEo9K7KKmXyPfgq78KnK9vn4wReUO2C0JSowtY0LRofl0wvKbdUQDHYIPgHH/cW9qInhVmWtNbDs1/J7B2rz3ZKQHp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776263902; c=relaxed/simple;
	bh=6pRQ7Rp7v52NaHGufz1Dr/dFt9p8jw6MHiN+10yfihU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMxWZX5wtlkmSLmIdaMVuAuGTIexzNAY1cb1RooMutVL4EvDDadKOUVTYUemynRwYKlxObNN3+H4IZ1w2fQwsZZu9YU0e1y8s8f99muxAucEOg9lDHmxHC5ASkhlOakJ/P4862T5jBZB09h5UJSH9F+rVv8kfTYLu/NFSk8ybCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6M6t+vb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6M6t+vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7A2C19424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776263902;
	bh=6pRQ7Rp7v52NaHGufz1Dr/dFt9p8jw6MHiN+10yfihU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=m6M6t+vbadDB466hlwjmBXd8BN7YXetdWpQauwsWcm+MAftrJQQTVglILpWjyx1lk
	 nj47SfxGWKGZoCinRSp9o2/7ZUrDkaEOBHZwiZQMs09DksxJdXl62JWG3Hs7is7d4I
	 OeiByBNSQIY4MR+8swtAuRsb6jD2xQHMjT3E9oWSlZE61svNqHRC+GrI4cvPni0HUs
	 UgOxJYeVkiL1H/5LJq68nNBPa7Znzg9l1Xd9eszcWvK8diE5+VxyF4EoRMSWGIc+Zo
	 5C+ehrZjg0OvesX55B43kVsyl1WAtwx8MXA5K1gOEOhPlJ+wfWeGpLzhxBbVsU4jrZ
	 mitDTKwa+iYqA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/9] btrfs: remove block group argument from copy_free_space_cache()
Date: Wed, 15 Apr 2026 15:38:10 +0100
Message-ID: <4381312eaee262b90836ab09d752612f76717218.1776263553.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1776263553.git.fdmanana@suse.com>
References: <cover.1776263553.git.fdmanana@suse.com>
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
index 9b33f68f43ec..b595ed793bda 100644
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

