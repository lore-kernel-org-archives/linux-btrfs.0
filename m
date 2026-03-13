Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E109E336897
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 14:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773410783; cv=none; b=BhjRfVpzLs98gauIbUCMXqocbaduHi7KUqfyuPm5kVKv1TGcZ74oWeWcJfEuY0aBsXTd4sNKxjjwUQi4y390zpHokMgC6H1FSP952FYhQ4v+oPxSa46gM/x0jfdqCeHOs3CWVtJpMNw2Yvor4Tf2AdydJ8kI8/eo8+To4L3JtFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773410783; c=relaxed/simple;
	bh=G3+5bV44dV1KCNfRAJUUSfOIUDUmv7WII/KPfYaRNIY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K/Uvh2fhuJZRIKCEsbAWFesMho+3sh4xlkgI3WxK5REEql+8kSoOnLuXYQBQmMOMP7QsDGUOFgoNSsBiyB+CD3kWT8cozKErnpyFTN6qW8uDwU543PuOWt7X/5VWuwquxPLpjdjmN0dzzxtBmcMmSVQ4uwRKfHmUARNqTKFkp9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fDHu2Ng3; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fDHu2Ng3"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8297310ce0aso1271002b3a.2
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 07:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773410780; x=1774015580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MLrbadGwzh8yV5zIT0g0uTD08kDUye73ezr5ZVOPuyM=;
        b=fDHu2Ng36nJeQOweELQwWWjs+Ft1V8IZrzHukBJxC7VCxOG0T56pbiAIyHL+UJ41OO
         wYO2bjbYzGJzqidBQn8EcUJZIkmI6H1dHryQjztotlBvV6F15snqNlPgEkAFBOgloPhg
         pMDvVwytu2TK63rNCDxLUVixEHix5wj1tkZh5rGbgoQlvyfVq3c+8yzRSYz+Iamdp3xO
         NLKf/qEBoYF0PMy/SCAvN8k0RyTqTgEJkNzoJtmZenB7oP26ne0pRzPgPQ0q3FptqK/G
         nhGjeCzdTVRmMcBuACooONln1vqd0o4nWf+r9R8jIG/2mo0ykr6Yj/9TdKEEoruX3ogL
         39lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773410780; x=1774015580;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLrbadGwzh8yV5zIT0g0uTD08kDUye73ezr5ZVOPuyM=;
        b=Mj0cLMlBBJbnvLVT2x2Uemn30z15PzLN38bYZdm/Ncs+inDnbelOtTKWyjMAE56BmY
         2cLB/mjuLepNj4fEeM5v3WOIryqXutWlQndLVUoV5P5lSolR8vti/NJvgF0vB3aEJlGS
         axAcW0jPBRnA3Xl6txh/93fI2BmqfchBJ0TPcLDhwsZduEjk9ZmG+e2Rn3z1i7qH1nJD
         svu1A/F1g0Yh+/kqfWApGrKyvO+OnTttwIFQrlXUxJmMDAJxXYin/YfohqKto39xGKz3
         JPvqATD8Qbi0pI4fF1IJWCSFjHlmI7uE1Pd5E4oGp/oGNtDKpgCSuJTFcaTM5keCENOF
         krzQ==
X-Gm-Message-State: AOJu0YwGL57KpVpjvNs1fPMJzvth/bAax67q83BKTX2jIYJJfTOzXdj3
	XS73It+DZNg8FLl90cRm7ioBpGy6t9iie+sdSxCDWLGRmn8p9SHvYKw+
X-Gm-Gg: ATEYQzzFItgUhKZpCghvaIdR1UjT1IfHbDBoYFBVnKfzH5vFXiFmmodHWVWQjaAqLGw
	3bwZxh7OxDNCwdWwAhB40qISG1+qCl4M6gckE12KOCuZxwV8W1693Lym3V5j8GHpuNR5T2wWaWj
	FTWDvNRCdtgiVSsh522QPjzU+myMOz38iUQFoOq5Qk+JjjBcGcmL6IiDaqSaxBfhelOCDjtCnoF
	mfzUlH8mbrJftVKUu45UIKuA+PHtD44cYaD9bAS8Exxjh41mL595gnSsCfhkgnZbFmaLraQka7Q
	0sIPw7DGlevW1d25fZ+TLRSaKOHdHM/xgJYGHgFk3HicNS/N/DrJIjmKniVO/rRTRVXFqwwPesD
	QLlm031DzExH/8GH3ZN3rYRTWkGpS2mQf0OiUa+fX8WjYWQnZg0NxGoH33y3ouxXqTAOYo7/j/Y
	DjqyrJ6MC/HHdW5nd2Ii3Km7YIMOGqwcPiNMVc/GlgLVvEAS3F8BtxRU8i2THq26UrYn5y1xY=
X-Received: by 2002:a05:6a20:d80c:b0:398:a128:d463 with SMTP id adf61e73a8af0-398ecd38abfmr2830687637.35.1773410779877;
        Fri, 13 Mar 2026 07:06:19 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.183.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73eb996257sm2007054a12.9.2026.03.13.07.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 07:06:18 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	idryomov@gmail.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: balance: fix null-ptr-deref in usage filters
Date: Fri, 13 Mar 2026 22:06:08 +0800
Message-ID: <20260313140608.1110971-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
Running btrfs balance with a usage filter (-dusage=N or -dusage=min..max)
on a corrupted image triggers a null-ptr-deref crash.

In chunk_usage_filter():
  KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
  RIP: 0010:chunk_usage_filter fs/btrfs/volumes.c:3874 [inline]
  RIP: 0010:should_balance_chunk fs/btrfs/volumes.c:4018 [inline]
  RIP: 0010:__btrfs_balance fs/btrfs/volumes.c:4172 [inline]
  RIP: 0010:btrfs_balance+0x2024/0x42b0 fs/btrfs/volumes.c:4604
  ...
  Call Trace:
    btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
    btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
    vfs_ioctl fs/ioctl.c:51 [inline]
    ...

In chunk_usage_range_filter():
  KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
  RIP: 0010:chunk_usage_range_filter fs/btrfs/volumes.c:3845 [inline]
  RIP: 0010:should_balance_chunk fs/btrfs/volumes.c:4031 [inline]
  RIP: 0010:__btrfs_balance fs/btrfs/volumes.c:4182 [inline]
  RIP: 0010:btrfs_balance+0x249e/0x4320 fs/btrfs/volumes.c:4618
  ...
  Call Trace:
    btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
    btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
    vfs_ioctl fs/ioctl.c:51 [inline]
    ...

The two bugs are independently triggerable:
- chunk_usage_filter() is reached via BTRFS_BALANCE_ARGS_USAGE, set when
  the user passes a single threshold (-dusage=N).
- chunk_usage_range_filter() is reached via BTRFS_BALANCE_ARGS_USAGE_RANGE,
  set when the user passes a range (-dusage=min..max).

These two flags are mutually exclusive; either path can crash on its own
without the other being involved.

These two bugs are reproducible on next-20260312 with our dynamic
metadata fuzzing tool that corrupts btrfs metadata at runtime.

[CAUSE]
There are two separate data structures involved:

1. The on-disk chunk tree, which records every chunk (logical address
   space region) and is iterated by __btrfs_balance().
2. The in-memory block group cache (fs_info->block_group_cache_tree),
   which is built at mount time by btrfs_read_block_groups() and holds
   a struct btrfs_block_group for each chunk. This cache is what the 
   usage filters query.

On a well-formed filesystem these two are kept in 1:1 correspondence.
However, btrfs_read_block_groups() builds the cache from block group
items in the extent tree, not directly from the chunk tree.  A corrupted
image can therefore present a chunk item in the chunk tree whose
corresponding block group item is absent from the extent tree; that
chunk's block group is then never inserted into the in-memory cache.

When balance iterates the chunk tree and reaches such an orphaned chunk,
should_balance_chunk() calls chunk_usage_filter() or
chunk_usage_range_filter(), both of which query the block group cache:

  cache = btrfs_lookup_block_group(fs_info, chunk_offset);
  chunk_used = cache->used;   /* cache may be NULL */

btrfs_lookup_block_group() returns NULL silently when no cached entry
covers chunk_offset. Neither filter checks the return value, so the
immediately following dereference of cache->used triggers the crash.

[FIX]
Add a NULL check after btrfs_lookup_block_group() in both
chunk_usage_filter() and chunk_usage_range_filter(). When the lookup
fails, emit a btrfs_err() message identifying the offending bytenr and
return -EUCLEAN to indicate filesystem corruption.

Since both filter functions now have an error return path, change their
return type from bool to int (negative = error, 0 = do not balance,
positive = balance). Update should_balance_chunk() accordingly (bool ->
int, same convention) and add error propagation for both usage filter
branches. Finally, handle the new negative return in __btrfs_balance()
by jumping to the existing error path, which aborts the balance
operation and reports the error to userspace.

After the fix, the same corruption is correctly detected and reported
by the filters, and the null-ptr-deref is no longer triggered.

Fixes: 5ce5b3c0916b ("Btrfs: usage filter")
Fixes: bc3094673f22 ("btrfs: extend balance filter usage to take minimum and maximum")
Cc: stable@vger.kernel.org # v3.3+
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
I was not sure whether these two bugs should be fixed in a single patch
or split into two. They share the same root cause, are very close to
each other in the code, and both depend on the same change to
should_balance_chunk(), so I kept them in one patch for now. If splitting
them would be preferred, I can respin this patch accordingly.
---
 fs/btrfs/volumes.c | 48 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2bec544d8ba3..3aa44967c1dd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3832,8 +3832,8 @@ static bool chunk_profiles_filter(u64 chunk_type, struct btrfs_balance_args *bar
 	return true;
 }
 
-static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
-				     struct btrfs_balance_args *bargs)
+static int chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
+				    struct btrfs_balance_args *bargs)
 {
 	struct btrfs_block_group *cache;
 	u64 chunk_used;
@@ -3842,6 +3842,12 @@ static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_of
 	bool ret = true;
 
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
+	if (!cache) {
+		btrfs_err(fs_info,
+			  "balance: chunk at bytenr %llu has no corresponding block group",
+			  chunk_offset);
+		return -EUCLEAN;
+	}
 	chunk_used = cache->used;
 
 	if (bargs->usage_min == 0)
@@ -3863,14 +3869,20 @@ static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_of
 	return ret;
 }
 
-static bool chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
-			       struct btrfs_balance_args *bargs)
+static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
+			      struct btrfs_balance_args *bargs)
 {
 	struct btrfs_block_group *cache;
 	u64 chunk_used, user_thresh;
 	bool ret = true;
 
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
+	if (!cache) {
+		btrfs_err(fs_info,
+			  "balance: chunk at bytenr %llu has no corresponding block group",
+			  chunk_offset);
+		return -EUCLEAN;
+	}
 	chunk_used = cache->used;
 
 	if (bargs->usage_min == 0)
@@ -3986,8 +3998,8 @@ static bool chunk_soft_convert_filter(u64 chunk_type, struct btrfs_balance_args
 	return false;
 }
 
-static bool should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *chunk,
-				 u64 chunk_offset)
+static int should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *chunk,
+				u64 chunk_offset)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
@@ -4014,12 +4026,20 @@ static bool should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk
 	}
 
 	/* usage filter */
-	if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE) &&
-	    chunk_usage_filter(fs_info, chunk_offset, bargs)) {
-		return false;
-	} else if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
-	    chunk_usage_range_filter(fs_info, chunk_offset, bargs)) {
-		return false;
+	if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE) {
+		int filter_ret = chunk_usage_filter(fs_info, chunk_offset, bargs);
+
+		if (filter_ret < 0)
+			return filter_ret;
+		if (filter_ret)
+			return 0;
+	} else if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) {
+		int filter_ret = chunk_usage_range_filter(fs_info, chunk_offset, bargs);
+
+		if (filter_ret < 0)
+			return filter_ret;
+		if (filter_ret)
+			return 0;
 	}
 
 	/* devid filter */
@@ -4172,6 +4192,10 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		ret = should_balance_chunk(leaf, chunk, found_key.offset);
 
 		btrfs_release_path(path);
+		if (ret < 0) {
+			mutex_unlock(&fs_info->reclaim_bgs_lock);
+			goto error;
+		}
 		if (!ret) {
 			mutex_unlock(&fs_info->reclaim_bgs_lock);
 			goto loop;
-- 
2.43.0

