Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660C1477E31
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 11:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768994047; cv=none; b=TVF0tPq1EbsqR5v+gQF9U9DWtARGOYkWN9bfcsXASO3mkRyw7GjleR40zjWSMUjbbhf3vHW5I8rebHCM7U3fz6acEVkbYo9JP1csloJch43iOPjhRbFGv+aGAE2HsM5iB/NSuBDvnEe1nYZwPNL8A1ubNwPTN3QMiSW/WPH2y+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768994047; c=relaxed/simple;
	bh=q2hvkFBhP7AmKX0S92ESGr1rszSpnfNzy8O2zYP7hQo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4tHk+2gOsNWgu7eTkRMQXEbdl3ij8Vf4UjSCZtnhLZEjT9PZQFqyKVxZ36x0Abt3KZU7BaNzi+oHmWj2KumDpjHRFiRESIdI9wizmVemkJ4u6MsV/dVgycdm2VnhOFzoK9HOJThFIhiZAoD8T3lpWG7TU7XyWOIwIiWffoheP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZRX3mzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZRX3mzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82370C116D0
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 11:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768994046;
	bh=q2hvkFBhP7AmKX0S92ESGr1rszSpnfNzy8O2zYP7hQo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JZRX3mzwkEqPuuvIPM4bm16EX1E8O2blQ4mhrnfmq8abQWlpGWXVDt4H0JGyRfIl8
	 zQBhPlHzJyrfGiOIaq9BlXb1861THFIoqZPb/cctKT3tPSvmb9+IxYJKWchWbiOWSr
	 qinLNiznj1yS3dOcjJjc1fsNOTh1n18iVMD7IL8aLhCqx8ayQeyozcjkQbZeg3OvZH
	 SzoA4tZYtDwMv418KnV+oJldOTwZJcX9kMEBwrc80oyVHr0/kYeVYM3cTC7272Cc5/
	 9uRet4PVivmDIv9iVJUA/CzXU8mB7/t5Mou6YYr7d89zUJVXJiunurxx3RXaOu9GY+
	 E/y0UpfH8GYEA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/19] btrfs: remove out label in load_extent_tree_free()
Date: Wed, 21 Jan 2026 11:13:44 +0000
Message-ID: <375f8ccde170674a4524747789896de4188ec02c.1768993725.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1768993725.git.fdmanana@suse.com>
References: <cover.1768993725.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There is no point in having the label since all it does is return the
value in the 'ret' variable. Instead make every goto return directly
and remove the label.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 746b259124bf..6eddfde805ef 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -760,7 +760,7 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 next:
 	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	leaf = path->nodes[0];
 	nritems = btrfs_header_nritems(leaf);
@@ -791,7 +791,7 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 
 			ret = btrfs_next_leaf(extent_root, path);
 			if (ret < 0)
-				goto out;
+				return ret;
 			if (ret)
 				break;
 			leaf = path->nodes[0];
@@ -822,7 +822,7 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 			ret = btrfs_add_new_free_space(block_group, last,
 						       key.objectid, &space_added);
 			if (ret)
-				goto out;
+				return ret;
 			total_found += space_added;
 			if (key.type == BTRFS_METADATA_ITEM_KEY)
 				last = key.objectid +
@@ -841,9 +841,7 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 		path->slots[0]++;
 	}
 
-	ret = btrfs_add_new_free_space(block_group, last, block_group_end, NULL);
-out:
-	return ret;
+	return btrfs_add_new_free_space(block_group, last, block_group_end, NULL);
 }
 
 static inline void btrfs_free_excluded_extents(const struct btrfs_block_group *bg)
-- 
2.47.2

