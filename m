Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400CE2D1F64
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776263899; cv=none; b=cj9kJkS70enUD5Usu/TIsqaH43E/yki0d/QqeYPojody4gaiQz1jKUVQpt0wVmLw4Pt4uUfX9X6iFeiCld9bxPjUC3eu5u+tuu2P7nFjWSUVuvLdNIi/2E2icAp3x7NWZdIxUXL/NktSguKd8AzYt9vSYtpH6kKPUj1GiABq71Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776263899; c=relaxed/simple;
	bh=LI2WgNECA2wJe8VV2Jt92Ci3DpmC3wx8Qk5rXFcy/b0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJTD7ODbJ776s24RufyJY5DKX1JzSo1OEb/Q5Bf3TNYPNK6LEJrAyEEoWqXFQR/FLt6yVD9MV4oJheok6N9lxXzY4/yjGk9fZuXCuo5KEg8qztGduufldvlam4Ncu7hRMBARi7/+kjF0DXlGJ1xydd3Bv8YTwfY0mp5vjf5BKf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vp1ow+It; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vp1ow+It"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607B7C19424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776263898;
	bh=LI2WgNECA2wJe8VV2Jt92Ci3DpmC3wx8Qk5rXFcy/b0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Vp1ow+Itil/TkrZkj5Ocmqr72u0Pcip6KE4Dv5tpUBvQB7Wc4muSaug9XyI7qdB4j
	 oeXQXxgSKBZ2waR7afBm5yWW9a7mBcE38xm1ZRzmfpYKdK8lWr16OFxsvU38keaR54
	 5U42jPdWDQO6Z2G4FtVovFfCA1VgPYdxjlMAD+NaLEhZy3BdNpVufiFiPoQlig/xys
	 r1qnmWbBvpqdyxZIsFs7OgOcIzzaAgb8jMo6ygS3K9PCU7egowvAJnZvfaggHIPw2X
	 O0LgPlebZi4P/JJZzrLwaeQsRcCgaQ5tT1r2O2CMg+mwN+YvG1tFwK3tFu/dT3C0/z
	 ClGey0r4piLpg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9] btrfs: use a kmem_cache for free space control structures
Date: Wed, 15 Apr 2026 15:38:06 +0100
Message-ID: <0fee5573ad690c4d0881eada69ea1bb3f437c8c4.1776263553.git.fdmanana@suse.com>
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

We are currently allocating the free space control structures for block
groups using the generic slabs, and given that the size of the
btrfs_free_space_ctl structure is 152 bytes (on a release kernel), we end
up using the kmalloc-192 slab and therefore waste quite some memory since
on a 4K page system we can only fit 21 free space control structures per
page. These structures are allocated and delallocated everytime we create
and remove block groups.

So use a kmem_cache for free space control structures, this way on a 4K
page system we can fit 26 structures instead of 21.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a87f147aefa5..06c4d8777385 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -23,6 +23,7 @@
 #include "extent-tree.h"
 
 static struct kmem_cache *block_group_cache;
+static struct kmem_cache *free_space_ctl_cache;
 
 int __init btrfs_init_block_group(void)
 {
@@ -31,12 +32,22 @@ int __init btrfs_init_block_group(void)
 					      0, 0, NULL);
 	if (!block_group_cache)
 		return -ENOMEM;
+
+	free_space_ctl_cache = kmem_cache_create("btrfs_free_space_ctl",
+						 sizeof(struct btrfs_free_space_ctl),
+						 0, 0, NULL);
+	if (!free_space_ctl_cache) {
+		kmem_cache_destroy(block_group_cache);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
 void __cold btrfs_exit_block_group(void)
 {
 	kmem_cache_destroy(block_group_cache);
+	kmem_cache_destroy(free_space_ctl_cache);
 }
 
 #ifdef CONFIG_BTRFS_DEBUG
@@ -197,7 +208,7 @@ void btrfs_put_block_group(struct btrfs_block_group *cache)
 			btrfs_discard_cancel_work(&cache->fs_info->discard_ctl,
 						  cache);
 
-		kfree(cache->free_space_ctl);
+		kmem_cache_free(free_space_ctl_cache, cache->free_space_ctl);
 		btrfs_free_chunk_map(cache->physical_map);
 		kmem_cache_free(block_group_cache, cache);
 	}
@@ -2392,7 +2403,7 @@ static struct btrfs_block_group *btrfs_create_block_group(
 	if (!cache)
 		return NULL;
 
-	cache->free_space_ctl = kzalloc_obj(*cache->free_space_ctl, GFP_NOFS);
+	cache->free_space_ctl = kmem_cache_zalloc(free_space_ctl_cache, GFP_NOFS);
 	if (!cache->free_space_ctl) {
 		kmem_cache_free(block_group_cache, cache);
 		return NULL;
-- 
2.47.2

