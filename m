Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F641383C9E
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278696; cv=none; b=jUr82mlgrOdb0+RwJEAuVx3qwEEue1yEsTeEd4c6Xq7atmudr/DsF1IO9stqIgmpB2CISmNzH33lIHeOVXlb9JC/QkeHnkMhnNq4dfFNmPN+ZX18zhtOaWexg2neTcMMbAASs8Z1ElLNaI3co0TAD60SOF2tLgAYFFRML8Ftc5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278696; c=relaxed/simple;
	bh=qsCOeAdxL3qF9+F1/hYGoi4VGhfV1dfl6VtggCOEeQI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1ejF6ZU7043USoJhK3Ug6uD+K+fXCVE6qpsxdMTqRoNaxtr3VevoezERLtlfe7cCXkAADXWS1F9xHATSuzwTbL7BLubpoosDllhX/Xfu7YZAzlh8paFsX8pjhCpZzkMjG8Y0xxj1EemEdlBuSxIidC0H25OcGjZkblbXHmDaR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZ0B5QL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZ0B5QL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7C8C2BCB5
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776278696;
	bh=qsCOeAdxL3qF9+F1/hYGoi4VGhfV1dfl6VtggCOEeQI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TZ0B5QL0fp3jVvhXEdz+WDkF3MCl8duyWsdhFk0rO2Jr0PlcUhkxJnkcL8APyhp6t
	 /XCXk75DMr8d0xkiaa5/35D9wFeBCPHiNIJPdOFPjLa6WVsBmDQwqNnXK53pvE/Q5b
	 OEqsoczPQ748w5HHj1Vhx0nfJUe5dKLF89pC4bopQBQD+yfG2pBH7XeJgBqKJM1j+Y
	 NJ3rJrqCLQdpNPrbRgpUUCCnbhPSvYbC/z4DTFBTeSjP2BU8VYGMwZkYlGzueiKvst
	 h2dvQw+nmr9kNmCYO7G+FjAQaNYUWxabsVeBUoMLZLEm9OdcipEWP4f62kbV9SSRaT
	 yv7fDkLgvv3AA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 01/10] btrfs: use a kmem_cache for block groups
Date: Wed, 15 Apr 2026 19:44:39 +0100
Message-ID: <ccd87d11a25c4fc5c4a52869fd57994a96029307.1776278490.git.fdmanana@suse.com>
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

We are currently allocating block groups using the generic slabs, and
given that the size of btrfs_block_group structure is 672 bytes (on a
release kernel), we end up using the kmalloc-1024 slab and therefore
waste quite some memory since on a 4K page system we can only fit 4
block groups per page. The block groups are also allocated and
delallocated with some frequency, specially if we have auto reclaim
enabled.

So use a kmem_cache for block groups, this way on a 4K page system we
can fit 6 block groups per page instead of 4.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c | 23 ++++++++++++++++++++---
 fs/btrfs/block-group.h |  3 +++
 fs/btrfs/super.c       |  3 +++
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index e6f5a17a13e3..a87f147aefa5 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -22,6 +22,23 @@
 #include "accessors.h"
 #include "extent-tree.h"
 
+static struct kmem_cache *block_group_cache;
+
+int __init btrfs_init_block_group(void)
+{
+	block_group_cache = kmem_cache_create("btrfs_block_group",
+					      sizeof(struct btrfs_block_group),
+					      0, 0, NULL);
+	if (!block_group_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void __cold btrfs_exit_block_group(void)
+{
+	kmem_cache_destroy(block_group_cache);
+}
+
 #ifdef CONFIG_BTRFS_DEBUG
 int btrfs_should_fragment_free_space(const struct btrfs_block_group *block_group)
 {
@@ -182,7 +199,7 @@ void btrfs_put_block_group(struct btrfs_block_group *cache)
 
 		kfree(cache->free_space_ctl);
 		btrfs_free_chunk_map(cache->physical_map);
-		kfree(cache);
+		kmem_cache_free(block_group_cache, cache);
 	}
 }
 
@@ -2371,13 +2388,13 @@ static struct btrfs_block_group *btrfs_create_block_group(
 {
 	struct btrfs_block_group *cache;
 
-	cache = kzalloc_obj(*cache, GFP_NOFS);
+	cache = kmem_cache_zalloc(block_group_cache, GFP_NOFS);
 	if (!cache)
 		return NULL;
 
 	cache->free_space_ctl = kzalloc_obj(*cache->free_space_ctl, GFP_NOFS);
 	if (!cache->free_space_ctl) {
-		kfree(cache);
+		kmem_cache_free(block_group_cache, cache);
 		return NULL;
 	}
 
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 0504cb357992..b414f4268d2d 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -320,6 +320,9 @@ static inline u64 btrfs_block_group_available_space(const struct btrfs_block_gro
 int btrfs_should_fragment_free_space(const struct btrfs_block_group *block_group);
 #endif
 
+int __init btrfs_init_block_group(void);
+void __cold btrfs_exit_block_group(void);
+
 struct btrfs_block_group *btrfs_lookup_first_block_group(
 		struct btrfs_fs_info *info, u64 bytenr);
 struct btrfs_block_group *btrfs_lookup_block_group(
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b26aa9169e83..b5346f26ed87 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2604,6 +2604,9 @@ static const struct init_sequence mod_init_seq[] = {
 	}, {
 		.init_func = btrfs_init_compress,
 		.exit_func = btrfs_exit_compress,
+	}, {
+		.init_func = btrfs_init_block_group,
+		.exit_func = btrfs_exit_block_group,
 	}, {
 		.init_func = btrfs_init_cachep,
 		.exit_func = btrfs_destroy_cachep,
-- 
2.47.2

