Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C3C1F4168
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 00:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399441; cv=none; b=L11wy8IORHbbzG4pJSgsFig6GyV7DHP8tLPElIrYb0eAqgIOIpxecfOiLPs4HpQcrBSd1z40D/OuCw7dPaZvyH6P3bYDJSDI4mSq1hbVLq4agClCS7xfM2gxZBdGNAKVi4jig2DKHw0LB2Wu135mQiyTtdMRLTGDsjEX8bL0PFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399441; c=relaxed/simple;
	bh=X/ADdL55Wq79O+zgdY2NaaKquYurrKe1Xz1yObkBMZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2k31s3p2SAUaUm+2fwqACJW5aAeKuF+DgQM9yV55eHC4V+n38qqYMZ+o+oas1T+iCe3dQdGkza0nq4wo3AIm1SP5U29GL0jqFy2w+KCEU4ujCvlm7zFsQ251lnBGaYHEpcQmQe2Gw2M38xcF/sHT0G5tHTzZDlYCgSf/kCA+S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pLFrufiv; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pLFrufiv"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b0b0064027so3398195ad.3
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 17:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774399439; x=1775004239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XemfYTcNf/J0nNi8IYSOThdWpd+g/3/8cxAQ3WKtoik=;
        b=pLFrufivrQgJbX6XVMALGBiMDMhkdYQTDsa58b7ZPhLwfpew+xMbUoIAMISK65PTDc
         aGH1H4XAAO5Z/inw3IEkBPinZ3tv0wK5aCjDaZwyixYRVoen8QCzoqlfRSoFynnINRAP
         dPXvkc9VF00NET57oTnA3blCX8/GcXPkXFqa6sQW/m3swB0MKPP9mEjUDWIH3uc2dsjM
         foQUzfafl3vBSQj7U1wC+bS8Euo2pt+FeSai8p03Z7o/bXsLrTMblCLzG7DNDtQ2nrfN
         r5cC6WO3EAH6lRIkPlwkp5gYZtjPdXG1yTagNjynJq3VDw2da2DfkfvvQVWY0UOMiXLF
         uLPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774399439; x=1775004239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XemfYTcNf/J0nNi8IYSOThdWpd+g/3/8cxAQ3WKtoik=;
        b=FpQvWi3l1YZ1grpktU/EDmXznjBLJbj4QsdmUrfJpCurB+5c5F7ozpC5lFPC1VV1gE
         q72+kzgJ1Lvjvyqq8zTy055TUpZo68wgIre3EuaaNvto5C5ms6y2jVHiUqUxpGSduyFc
         nXcYLmnhkN0hs94O47qeIBZmWBjq5pUX7WeEqfbSW/wFFQ/CGpE5EjoD71/b3u4NtJZp
         RU1ti3H6Lv4rCD/vAbx4ZruVNgadQddfjssUc61bhozA1npK2ixdr/G3Uu6h70Ce2Mcd
         Ga0C6w/04tZ/XWBQmsssbEpbIAJAtAKN3t3M0k3GaDqXDvrd2ZPuAVMdwBmY93KYFUs4
         LPBQ==
X-Gm-Message-State: AOJu0YzX+3qRXH/wKxNHX2KHXlKrN9R/OOHGzMAo9coJ6lZ7n5mM/eBg
	5Vl3AaU5DZNUzios9aRD1ronPCspS5+iMmr+NYRGI8xVhTfyW/Vcf5hP
X-Gm-Gg: ATEYQzyigZejqQeDhV/qR2EeszE7kc9vEdFTNIVE/jxofFqVImt7SzS3nwX0owIL5L2
	Mt0LYJGaYqz+p65KxHk/FdN+HKTg9iYfEQmzdlIrX/fnCBMm9gIjoJIhAlHV6bqu7uOTJv3mZ6f
	C7w3zKoC6zIf3lIAIH6J5B/4Kc2W6xr+BUpa4CHPnmeE0YRFL8De7/XCOfhpXTLUl1GGPteAz7Z
	554gSEt2LKpSl04N0FHNnixGRGdOXXflkRjCkVcyOUTfEPoEQMHsNo9uR7kaKM8A7UAsiv6cdjS
	Tiqaf+67z23p4iuJ22ZxeYcK7hhyuCJquB1rNQr78HXd8NsnoQnx7lRgIPu8ZoJPs4lOboGl+3T
	zV146wKpJ+cHHjXecQu9VEoyBll9FGP2lXuN8l/C7szPX8cZ4m4PZqRCTpIC0uIVInxFaTHRXm0
	EyorM9LTG10txwkbrQ2k3LsudBSwKLhhawEX16zQugS8AniuZXsWzYBN0p5XVYK01216bxEcM=
X-Received: by 2002:a17:903:1252:b0:2b0:5694:7b62 with SMTP id d9443c01a7336-2b0b0af42c3mr15993425ad.44.1774399439012;
        Tue, 24 Mar 2026 17:43:59 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836554acsm207457015ad.51.2026.03.24.17.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 17:43:58 -0700 (PDT)
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
Subject: [PATCH v3 2/4] btrfs: balance: fix null-ptr-deref in chunk_usage_range_filter
Date: Wed, 25 Mar 2026 08:43:37 +0800
Message-ID: <20260325004339.2323838-3-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325004339.2323838-1-gality369@gmail.com>
References: <20260325004339.2323838-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
Running btrfs balance with a usage range filter (-dusage=min..max) can
trigger a null-ptr-deref when metadata corruption causes a chunk to have
no corresponding block group in the in-memory cache:

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

The bug is reproducible on next-20260312.

[CAUSE]
Two separate data structures are involved:

1. The on-disk chunk tree, which records every chunk (logical address
   space region) and is iterated by __btrfs_balance().
2. The in-memory block group cache (fs_info->block_group_cache_tree),
   which is built at mount time by btrfs_read_block_groups() and holds
   a struct btrfs_block_group for each chunk. This cache is what the
   usage range filter queries.

On a well-formed filesystem, these two are kept in 1:1 correspondence.
However, btrfs_read_block_groups() builds the cache from block group
items in the extent tree, not directly from the chunk tree. A corrupted
image can therefore contain a chunk item in the chunk tree whose
corresponding block group item is absent from the extent tree; that
chunk's block group is then never inserted into the in-memory cache.

When balance iterates the chunk tree and reaches such an orphaned chunk,
should_balance_chunk() calls chunk_usage_range_filter(), which queries
the block group cache:

  cache = btrfs_lookup_block_group(fs_info, chunk_offset);
  chunk_used = cache->used;   /* cache may be NULL */

btrfs_lookup_block_group() returns NULL silently when no cached entry
covers chunk_offset. chunk_usage_range_filter() does not check the return
value, so the immediately following dereference of cache->used triggers
the crash.

[FIX]
Add a NULL check after btrfs_lookup_block_group() in
chunk_usage_range_filter(). When the lookup fails, emit a btrfs_err()
message identifying the affected bytenr and return -EUCLEAN to indicate
filesystem corruption.

Since chunk_usage_range_filter() now has an error path, change its
return type from bool to int: negative errno on error, 0 if the chunk
matches the usage range, and 1 if it should be filtered out. Update the
BTRFS_BALANCE_ARGS_USAGE_RANGE branch in should_balance_chunk() to
propagate negative errors from chunk_usage_range_filter() instead of
treating them as a normal filter result.

After the fix, the same corruption is correctly detected and reported
by the filter, and the null-ptr-deref is no longer triggered.

Fixes: bc3094673f22 ("btrfs: extend balance filter usage to take minimum and maximum")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/volumes.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1eca5fa6bdaa..65df8652d760 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3832,16 +3832,22 @@ static bool chunk_profiles_filter(u64 chunk_type, struct btrfs_balance_args *bar
 	return true;
 }
 
-static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
-				     struct btrfs_balance_args *bargs)
+static int chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
+				    struct btrfs_balance_args *bargs)
 {
 	struct btrfs_block_group *cache;
 	u64 chunk_used;
 	u64 user_thresh_min;
 	u64 user_thresh_max;
-	bool ret = true;
+	int ret = 1;
 
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
+	if (!cache) {
+		btrfs_err(fs_info,
+			  "balance: chunk at bytenr %llu has no corresponding block group",
+			  chunk_offset);
+		return -EUCLEAN;
+	}
 	chunk_used = cache->used;
 
 	if (bargs->usage_min == 0)
@@ -3857,7 +3863,7 @@ static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_of
 		user_thresh_max = mult_perc(cache->length, bargs->usage_max);
 
 	if (user_thresh_min <= chunk_used && chunk_used < user_thresh_max)
-		ret = false;
+		ret = 0;
 
 	btrfs_put_block_group(cache);
 	return ret;
@@ -4027,9 +4033,13 @@ static int should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *
 			return ret2;
 		if (ret2)
 			return false;
-	} else if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
-	    chunk_usage_range_filter(fs_info, chunk_offset, bargs)) {
-		return false;
+	} else if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) {
+		int ret2 = chunk_usage_range_filter(fs_info, chunk_offset, bargs);
+
+		if (ret2 < 0)
+			return ret2;
+		if (ret2)
+			return false;
 	}
 
 	/* devid filter */
-- 
2.43.0

