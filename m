Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B48383C81
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278698; cv=none; b=fM240u2AF51mp03q2MSokg0z8CfWf1JCz0LJCPbIa4C/B3LAoqGas6ToV36NC2oHARTpmtPebArVMrXkgTAIUPSyGV0W3ti1HcKlfr0MUPpuo/LFigLdxpGRe1Q3CZw1TlL+V50RF0lmIt/f9Y/xEMiZx3GPNn8N9WktYpfqaN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278698; c=relaxed/simple;
	bh=LI2WgNECA2wJe8VV2Jt92Ci3DpmC3wx8Qk5rXFcy/b0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjRewuFW50t4xP5F3zd5+DvG9ZEoIfH12UUAy+eoDEMuvq8H4QYDnyyUirlPwLRk1efNG4J9v0w9Bo0wxMLOqOafHA7qqmonpeaTzrRteB22mNah1tY028X7rqCqWALjNbbDgBp15b1gPN/1txe6t9bfVlhAVd224c1xNBvgNls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4alzZdg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4alzZdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A57C19424
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776278698;
	bh=LI2WgNECA2wJe8VV2Jt92Ci3DpmC3wx8Qk5rXFcy/b0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=P4alzZdgfKmB7xsn4+n2AaPAzI/hSCfYEhMzMbDhQQnwU1uCIE+nm5AovDdOcPxHl
	 k+j/MaryrS246XHrA9AooP18wFGn22+qbNI94KTB3wVPvP+SYl3LOnygkJb/2ephhW
	 d1DApu6ftySwjLJcMcLylsx53rxsvrkDy53FCLjhX39XkaRRMFAXJz+pg1U8SXmCbu
	 BFRqtxo+ebmdR4+6uVkUF7vgLOe352qWy16W2+UcR8vyZ1jun25enCYIiDp/OFkDWr
	 EXlDJit7Qi2cmVa53u3l3fCQ2wicp6Hw5UVJNbQ+x6a4d+6Rm/vag5eOLC5S5bpUWx
	 UctXbSwRHLaUQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 03/10] btrfs: use a kmem_cache for free space control structures
Date: Wed, 15 Apr 2026 19:44:41 +0100
Message-ID: <0fee5573ad690c4d0881eada69ea1bb3f437c8c4.1776278490.git.fdmanana@suse.com>
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

