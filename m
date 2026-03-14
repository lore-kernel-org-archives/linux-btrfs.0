Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D08A273D76
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 12:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773491878; cv=none; b=cR4Cn6BcZgAV79mOtktgwUrbkdkESK7EMj7UKsgZzAMhMs04I8TlmcRFHPUzjFwiq8DIIcOzhlNH2gVbjAz1JEvWdb98gKGU9bjyhj92InilbJpi4XfbMJN5j4/tu7WJixTdljUwYXWR2yKVr3JDCgojEzLgWp+/RUAPXHJtJ1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773491878; c=relaxed/simple;
	bh=z5AD4JniElssw7dAZ3Z2sfNgq0aQO8sOOb3qGgHe3LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHFJdKhGaRB6cOR0fBqCR3gniQBYB3jNllo0h+9fSNuX3OYEzJ6Pz0T7Z4hg1QK2KXdIIOTUoHXeBWlZn7D2/hMPNS+q213CUclLLd0PGfAy+shOEhOM19zkJ/XJCk04AdHlOaN9ae86mmVa2GwraWkSkhq4bm+YVjU+ktCNpYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XR3DcV50; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XR3DcV50"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ad4d639db3so15170815ad.0
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 05:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773491875; x=1774096675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ch0eaxVQ4/ts2cf46sQ450Wifko7pmpNDC0czkFsQbk=;
        b=XR3DcV50O2XxLiQpqzCAMkbgY8hoGrNVcoru0cycEVQuzkUynVoJFkIWyRjP/71eil
         oO0nB6b1Glb4h+ZZ4Yn2BV7jx3kqjTzA1eRR8+y83tuP8Q34bhnXA6ujG8eGte+AOnXg
         l2laMb3cnQUvDXJfWEFuBA8LXRdxOF/HnIAjoZyoUGNj0FUl5lFRm2nkDh2PYDvknJI0
         g0w3RJoCPEhkaWaq5HqQSt29CgeuO3Xe7SyXoXgLgkFBVrYCLYh+YeXWjuAP5qy0KXT0
         5SUIjzuqEdXSKPuP70Nk0MsNk48oKZhZM8aTO8SRjx7JW7nDTUnYtBhKllOdjbhsKnDN
         MWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773491875; x=1774096675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ch0eaxVQ4/ts2cf46sQ450Wifko7pmpNDC0czkFsQbk=;
        b=gIy7kzoleI5AxIJCmNtVCvFF4dC+dMyfVktOvTCnnLUzp0eIr18XJabJUmK+NOvrL7
         vOP5pgcTu0Jj0ljE0EuJfvhGZnyD0zmo1dAtiVP8oQkqNkY1yILoRlIqU75Qwa84H9s6
         HLsDV66+1e71Idwc/sNmtDiWRXRj2mdCeVAFAj+brm+jpo+dobPzjABqE+zvUKGgSoTk
         zydbfwbAEtH6nFIitXmB3B3P00LI6Ty7ia8V6B/9USYMz7CDV3zFlX6Gj4NtxmTAVg8Y
         DPQuJcMA86KG5sw5t7bYDdu100SDI0PQx+JpZJkVcP2V7JxlshFBJIjCrwss+vkNw5tW
         Tzgw==
X-Gm-Message-State: AOJu0YwnIZg0K6nIvrFgYHVS0Kj5q8mI0GFDGQnxVdchR8EGh16oAN6N
	tzzMXx6IPI6MCbtEbAcF+F2ZFEoDsQCqyxA/wR21bH7ElHXJ9Om+Jt5azCIt5NT8
X-Gm-Gg: ATEYQzxGi5wboamLDW4ot+5yN5V9RvXTDdNKx7z3+5uq7KAss1uaGbLrhSWHV7eNn8S
	A+uxuHGb2H4yqHaVHxtZxwQHeKahRUBiMlWbmGO1HepemL5T671qsYQMHOJr6UOuCDkY3LKV97v
	HsKUyLVv8UJVRouxl6KlSPvkJANdYlZw/XxWpf7px2UWXzEz12Y4Qi4stYLFWgbjBADSBGAk5wt
	L0zmgr+1RiOsLfEt7+P1zaQcdOtH+Qf44q/3sw0NNXNxp8p83pPtFVTGDQPrdW3Q4zZUvri7ph2
	6A6zZLGKVR9BFKPdIl98kOSbW4di1RF5b89Oy8gYUGM8TuSmOV9FlMYB2gVQEd24UfNQMSVVZOP
	1XYRs6YDoJIdA8DpI2V50By2S+7jVKRaptyNRoW7OEeu2sD7O7sHqnJblsSuxso3omAhfycwFHE
	k+nqug37FzJDJ993beKEH3qw4t6MWIVQfJkzRzBzoi1AmoJoCS7rP63V9xKmwR8nLbjtdFdqE=
X-Received: by 2002:a17:903:20ce:b0:2ae:6031:bc59 with SMTP id d9443c01a7336-2aecaa1504emr50150105ad.30.1773491874677;
        Sat, 14 Mar 2026 05:37:54 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.183.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56e0b8sm63561935ad.16.2026.03.14.05.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 05:37:54 -0700 (PDT)
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
Subject: [PATCH v2 1/3] btrfs: balance: fix null-ptr-deref in chunk_usage_filter
Date: Sat, 14 Mar 2026 20:37:39 +0800
Message-ID: <20260314123741.1439792-2-gality369@gmail.com>
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
Running btrfs balance with a usage filter (-dusage=N) can trigger a
null-ptr-deref when metadata corruption causes a chunk to have no
corresponding block group in the in-memory cache:

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

The bug is reproducible on next-20260312 with our dynamic metadata
fuzzing tool, which corrupts btrfs metadata at runtime.

[CAUSE]
Two separate data structures are involved:

1. The on-disk chunk tree, which records every chunk (logical address
   space region) and is iterated by __btrfs_balance().
2. The in-memory block group cache (fs_info->block_group_cache_tree),
   which is built at mount time by btrfs_read_block_groups() and holds
   a struct btrfs_block_group for each chunk. This cache is what the
   usage filter queries.

On a well-formed filesystem, these two are kept in 1:1 correspondence.
However, btrfs_read_block_groups() builds the cache from block group
items in the extent tree, not directly from the chunk tree. A corrupted
image can therefore contain a chunk item in the chunk tree whose
corresponding block group item is absent from the extent tree; that
chunk's block group is then never inserted into the in-memory cache.

When balance iterates the chunk tree and reaches such an orphaned chunk,
should_balance_chunk() calls chunk_usage_filter(), which queries the block
group cache:

  cache = btrfs_lookup_block_group(fs_info, chunk_offset);
  chunk_used = cache->used;   /* cache may be NULL */

btrfs_lookup_block_group() returns NULL silently when no cached entry
covers chunk_offset. chunk_usage_filter() does not check the return value,
so the immediately following dereference of cache->used triggers the crash.

[FIX]
Add a NULL check after btrfs_lookup_block_group() in chunk_usage_filter().
When the lookup fails, emit a btrfs_err() message identifying the
affected bytenr and return -EUCLEAN to indicate filesystem corruption.

Since the filter function now has an error return path, change its
return type from bool to int (negative = error, 0 = do not balance,
positive = balance). Update should_balance_chunk() accordingly (bool ->
int, with the same convention) and add error propagation for the usage
filter path. Finally, handle the new negative return in __btrfs_balance()
by jumping to the existing error path, which aborts the balance
operation and reports the error to userspace.

After the fix, the same corruption is correctly detected and reported
by the filter, and the null-ptr-deref is no longer triggered.

Fixes: 5ce5b3c0916b ("Btrfs: usage filter")
Cc: stable@vger.kernel.org
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/volumes.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2bec544d8ba3..7c21ac249383 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3863,14 +3863,20 @@ static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_of
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
@@ -3986,8 +3992,8 @@ static bool chunk_soft_convert_filter(u64 chunk_type, struct btrfs_balance_args
 	return false;
 }
 
-static bool should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *chunk,
-				 u64 chunk_offset)
+static int should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *chunk,
+				u64 chunk_offset)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
@@ -4014,9 +4020,13 @@ static bool should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk
 	}
 
 	/* usage filter */
-	if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE) &&
-	    chunk_usage_filter(fs_info, chunk_offset, bargs)) {
-		return false;
+	if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE) {
+		int filter_ret = chunk_usage_filter(fs_info, chunk_offset, bargs);
+
+		if (filter_ret < 0)
+			return filter_ret;
+		if (filter_ret)
+			return false;
 	} else if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
 	    chunk_usage_range_filter(fs_info, chunk_offset, bargs)) {
 		return false;
@@ -4172,6 +4182,10 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
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

