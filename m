Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2789B27B4FA
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 12:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773491884; cv=none; b=mGiwW71gd8udQL+1Lo1/6+vkqgZ/36cI/WulfmxckpKpLpSAfNAGgGXoCucw4/vyFcgY040Lt1NCZTo8QNHD/Knyx61p1pOuHE6SP7DqSiCq4n2VFuCZQC/hub6r938D/WvC1GrfUh2yZsGEDYC9C4YOXhRU0NddO5bL4/vTneg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773491884; c=relaxed/simple;
	bh=TRKl+q0Zn4TfohZfg56MGKZFT66Ys4Q73PpKsm0gc5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcR51xkP10rB+fGUJbW1KRo7YNObDL/eOsk4+IOPiZTo7YHzFMS3NEgbpsghCp1Ss6Qq0U11j/+ZFxrjx0Ba/3gSl6igDz+ArX/RB37rAwKTj53Vhp79vSgcFBObbgew1oyCVMVytWv4LQ6sabyU0SCG8LK0Ws9StU8/Bgx8Q6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HkuCMLu4; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkuCMLu4"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ad4d639db3so15170975ad.0
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 05:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773491882; x=1774096682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jZpZGRHbhNYi4Yj4ueDS5CDpIlSRqZLNbqutOeOrqM=;
        b=HkuCMLu4W9vJqlsB49AdKBRWxq4uTDzIvKeO4s3mv4MfEB7+iWVe7H1jmSQyY8Wkus
         5cqv+xUbvytflgmA5QxgjHOp/Mw668dk0OWP8mY94ZuOTRNGKywHPfTqOTg4rCxJP0Kn
         2Jcf/dpHjvJI0wKdnw7bVgnhYYH0wrDolXQ+PAlGZI02TojMIdo7oO+FmPSOaz9qHivZ
         9XrMrL7gldEplyMBKDY9+QCQsZgqQ8FBj0kezrNMu0lJmJEDU0GFf1MHAIrevHEjDZA+
         Hb68KQYpMca45/9z/yCc9zUN1pKre9YGzCjperZqRZ81CFnWXpVG3aWFpMfaD3K99H/o
         Zxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773491882; x=1774096682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2jZpZGRHbhNYi4Yj4ueDS5CDpIlSRqZLNbqutOeOrqM=;
        b=OE/MJ7kX727tv5+zB93kaZxFnIWhXEcRC53FRXJrdJYv2CjXxfOf40I8jj8PC832ro
         ZqZF0+WxJ25Hg2kzXMfZY7blXPIDxJYkOkvqaF8xbL6zmGB2dVpW4dwZnGIb/tbWqwDO
         Kis8h56AuyNc+LJrVZiQInOMaiC2pVPSv/Jl6yThgFZbbk1uinoj51/Qt+zip3KSVyXN
         MlOaGeG+UZUutQ/mUWr4pVYpD4pltuPRKgOIpot3xpGJSryMmqOYbDlcK6gr2rOtOE7a
         yIn/+DUTptF9nlCVk+RLvq+QK618ff2bIcxRHNjZhGTXV9ggzEtKcu6cUNxV6BB4H9dn
         HPbw==
X-Gm-Message-State: AOJu0YylFhGktFQ9vpK8iOBNYNaOnSzd0OkdKwiLj0c07+uNfS2vk+Vt
	xwdPHuG4gAwft7wC8Ie/ln5mY1rE/6Q2kyzCM+CwR3wpAWB50BvnYyHqT9VidCt3
X-Gm-Gg: ATEYQzy+ROJ9ulBxt99/493z8FD1oJNMubz0RS3NVYfNlJN0Yt+Sl9vzmOsJBlHG2Zb
	nqFA7zefSCOoS5ywji+OOJPOBB38fj41fAcdTb6/UfeLdY62VGpby7KulZ3a1zN5ZFXxLHONP+g
	qyQ9SapNUc5BA+lR9T2jHi9ji3kXmBpSmgsvcXI8oHiiFqp3yqu1NOCrpb38Cer5W5cEs1BmkeK
	b0LwZbzuMKJDafyG6Q4xhiqTYr3TFxYDSxe41bq1onuZFzg1uDFRKlyI+lo0XvrFU6tbVJiW7Ll
	D9OWtd3iM7f5hr9KL9XkEud8woOkHdnHd0J8BR/dqlTQSawhR/BTpMmy6+F79IPi8TcVMAfYKQ5
	AoJP0lWAMs6qnL2h04eq587gP35CrMpZ/B5hisDvno+beFRmx/srmEyydereLsLbmPhbty5f5zh
	j9lfbMHbVkhwSO4fY6tJTiEUf6k8/Nyj6RDWXbe2ydWHqGKzKYZtT5PagJ+BK7BSG16Z/oCXY=
X-Received: by 2002:a17:902:ea0f:b0:2ae:54b2:27d1 with SMTP id d9443c01a7336-2aecaaaa8d1mr72132375ad.44.1773491882447;
        Sat, 14 Mar 2026 05:38:02 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.183.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56e0b8sm63561935ad.16.2026.03.14.05.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 05:38:01 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	idryomov@gmail.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v2 3/3] btrfs: fix check_chunk_block_group_mappings() to actually iterate all chunks
Date: Sat, 14 Mar 2026 20:37:41 +0800
Message-ID: <20260314123741.1439792-4-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260314123741.1439792-1-gality369@gmail.com>
References: <20260314123741.1439792-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted image with a chunk present in the chunk tree but whose
corresponding block group item is missing from the extent tree can be
mounted successfully, even though check_chunk_block_group_mappings()
is supposed to catch exactly this corruption at mount time.  Once
mounted, running btrfs balance with a usage filter (-dusage=N or
-dusage=min..max) triggers a null-ptr-deref:

  KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
    RIP: 0010:chunk_usage_filter fs/btrfs/volumes.c:3874 [inline]
    RIP: 0010:should_balance_chunk fs/btrfs/volumes.c:4018 [inline]
    RIP: 0010:__btrfs_balance fs/btrfs/volumes.c:4172 [inline]
    RIP: 0010:btrfs_balance+0x2024/0x42b0 fs/btrfs/volumes.c:4604

The crash occurs because __btrfs_balance() iterates the on-disk chunk
tree, finds the orphaned chunk, calls chunk_usage_filter() (or
chunk_usage_range_filter()), which queries the in-memory block group
cache via btrfs_lookup_block_group().  Since no block group was ever
inserted for this chunk, the lookup returns NULL, and the subsequent
dereference of cache->used crashes.

[CAUSE]
check_chunk_block_group_mappings() uses btrfs_find_chunk_map() to
iterate the in-memory chunk map (fs_info->mapping_tree):

  map = btrfs_find_chunk_map(fs_info, start, 1);

With @start = 0 and @length = 1, btrfs_find_chunk_map() looks for a
chunk map that *contains* the logical address 0. If no chunk contains
logical address 0, btrfs_find_chunk_map(fs_info, 0, 1) returns NULL
immediately and the loop breaks after the very first iteration,
having checked zero chunks. The entire verification function is therefore
a no-op, and the corrupted image passes the mount-time check undetected.

[FIX]
Replace the btrfs_find_chunk_map() based loop with a direct in-order
walk of fs_info->mapping_tree using rb_first_cached() + rb_next(),
protected by mapping_tree_lock. This guarantees that every chunk map
in the tree is visited regardless of the logical addresses involved.
Since the mapping_tree itself is accessed under read_lock, no refcount
manipulation of each map entry is needed inside the loop, so the
btrfs_free_chunk_map() calls on the map are also removed.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/block-group.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 5322ef2ae015..25bd0d058be6 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2319,29 +2319,22 @@ static struct btrfs_block_group *btrfs_create_block_group_cache(
  */
 static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 {
-	u64 start = 0;
+	struct rb_node *node;
 	int ret = 0;
 
-	while (1) {
+	read_lock(&fs_info->mapping_tree_lock);
+	for (node = rb_first_cached(&fs_info->mapping_tree); node;
+	     node = rb_next(node)) {
 		struct btrfs_chunk_map *map;
 		struct btrfs_block_group *bg;
 
-		/*
-		 * btrfs_find_chunk_map() will return the first chunk map
-		 * intersecting the range, so setting @length to 1 is enough to
-		 * get the first chunk.
-		 */
-		map = btrfs_find_chunk_map(fs_info, start, 1);
-		if (!map)
-			break;
-
+		map = rb_entry(node, struct btrfs_chunk_map, rb_node);
 		bg = btrfs_lookup_block_group(fs_info, map->start);
 		if (unlikely(!bg)) {
 			btrfs_err(fs_info,
 	"chunk start=%llu len=%llu doesn't have corresponding block group",
 				     map->start, map->chunk_len);
 			ret = -EUCLEAN;
-			btrfs_free_chunk_map(map);
 			break;
 		}
 		if (unlikely(bg->start != map->start || bg->length != map->chunk_len ||
@@ -2354,14 +2347,12 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 				bg->start, bg->length,
 				bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK);
 			ret = -EUCLEAN;
-			btrfs_free_chunk_map(map);
 			btrfs_put_block_group(bg);
 			break;
 		}
-		start = map->start + map->chunk_len;
-		btrfs_free_chunk_map(map);
 		btrfs_put_block_group(bg);
 	}
+	read_unlock(&fs_info->mapping_tree_lock);
 	return ret;
 }
 
-- 
2.43.0

