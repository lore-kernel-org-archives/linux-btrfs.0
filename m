Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683B51F4168
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 00:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399436; cv=none; b=eZqXatQ3f2Srx6cqUpu81n1Ds6D6aMCESB7lDg+uCCHfQb+cXyxdPy80hw3+3C3olstWwdLWRMPV/67SqqVWBPUDzDC7hpZkLnX7gycF5OCRe1klJBJg6vd2CkQ7wj5y9LIY+iNFwLsl0OffTMi7GSYejYiNg18KtFuGGfFrhkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399436; c=relaxed/simple;
	bh=Nd0atCCstaJ2Fwk9EQFaGAl7hAjSKTfwkXCd4sAxmjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1doq9n+AYnGaOn4Rn/oJZ1P74DbWF9tvpYyUf6Bl2O1jtJiUxXjViaeNMtJZstb8t8yO07sDnsRGZcbjMAEpOQCE1sQfSXber7cACCNSMjr6edhYpH8Y9htFQVw36nZCiidx3D+SuEyOb/5+u5M2AXvwAPWjBfGRw0Z2t+9+4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ja/75nDU; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ja/75nDU"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b0603ee486so13310745ad.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 17:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774399435; x=1775004235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTSd+cTo/0b497i3cXRpwad9mDPRGXICrLQ2yK5ereM=;
        b=ja/75nDUAZ8RNoAKD+mpQPfUtmkqwOwoUyNIV6bjCKpRoYoBQZlYR++w+LsYUXpzQI
         vEdDse2AqqK+2OKRu+PkqdTnBZ2eKr+p+PvVmiDxkH6sLwTvMMZWEXvHoGFiO2FLUuik
         Xr8Duz1OL41FE1GDnVQHpfjjYVbP7Qys0kB9sYTRIo84/PTA2Rrh+zffh9NDf2AMvbo2
         sm9ZUj4kik/AxydwGRAdqK3tYrm/tuZ8C1DCZbIp9MFhFzwdv6CwrcUt+1wytM1fHBtN
         pVR9pagKvYP9LYS6r6mBKYqh83Gl59Ui3WlQpPgW39p5NpdibYQWL063URos4f2uk/PN
         b4qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774399435; x=1775004235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LTSd+cTo/0b497i3cXRpwad9mDPRGXICrLQ2yK5ereM=;
        b=ieBhxrOH7cckbFyzw5QrHuH65RbEwbfKwJgM58BjXvLjMCsDzwuHrOh/XyHoNQPxjh
         XStnRBFN8yXyizmnUvU+tAYyH/HS8FtI6+L/Lfz04B3V8miJe7D1g7OivinZmZYraRt/
         jVE+Dt7WuxGuH9ALbx5UN+FSJKpqKBpcWgPt18+dJjWV2wiBBPZhku9fWDH4Qdaz2152
         Q9h/EaDrNo1Fh/W03m+HqvT6wYllV+1hJ3FiywbsJJCSjj/FTCPrJTKZ42E/abmVHDAs
         1kgDmJ5yLcva4K+ckRrzNzKN76aCQpNWH2wHbpFVPd8Dxn7zhoe5Hu43nYC2NO8PzTok
         PzbA==
X-Gm-Message-State: AOJu0Yy9WOjhME+O2HIpNOeF2xmMDXA5ql3u9pFEa887FGUZqY27p1sk
	LR7zNG2ya8DAgKD4jnfjh1FCGkp6LZv7Jw6pvO+3aDzhldhges5/TKTkm5qrsCAwkhdczw==
X-Gm-Gg: ATEYQzxiKcTJeV3maDToKKHyWt/akrl6hZwq+eIoUXjMGiNMg+1IrENGO/3WVMXiJ31
	uuszr/TJRxAS+8RsA7vuXbCZCLUJtqawye0UyRpssPyvg4xag0l5Zmv5UCHS7Dlbs6wrcx5u8QT
	MmpYIumxPokh1nXZ31tmts7EhSzBPQ+2YOFj39qAqKkCaUSrQCIhQ75Ptblu9601zeTkg5VbyCA
	drY7hM3BE4g/wQLrrQNZaT/ba619ALQMAdhJfOjVJRqlWdcx8PhEXdlb79vlfxA4LP38mwRn08g
	mNeJcXl5pAliD5PQxo2tiZcWVhlVpXUp7OdTiZ+4CueJgkWpjdTtNpz9pOo8RArZ0FVMmq9AZYu
	bkR6ynmaqBerBIekhaIH0g6pT4OwoUo/xL1kG1XFB9fXFWtp1bnjltSsu754H9vofbWs6Kl0cMc
	UZ1h4X0wfnlYxS47ufnuCyM+0MtdK6kOU98S+blfqeHOf7tzby89Dj34Uk9V7qbo1bfJx2j8AHz
	/9C10Q+2A==
X-Received: by 2002:a17:903:22d2:b0:2b0:4f82:74ce with SMTP id d9443c01a7336-2b0b0b2f889mr15838615ad.46.1774399434637;
        Tue, 24 Mar 2026 17:43:54 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836554acsm207457015ad.51.2026.03.24.17.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 17:43:53 -0700 (PDT)
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
Subject: [PATCH v3 1/4] btrfs: balance: fix null-ptr-deref in chunk_usage_filter
Date: Wed, 25 Mar 2026 08:43:36 +0800
Message-ID: <20260325004339.2323838-2-gality369@gmail.com>
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

The bug is reproducible on next-20260312.

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

Since chunk_usage_filter() now has an error path, change its return type
from bool to int: negative errno on error, 0 if the chunk passes the
usage filter, and 1 if it should be skipped. Update
should_balance_chunk() accordingly to propagate negative errors from the
usage filter path while still returning 0 for chunks that should not be
balanced and 1 for chunks that should be balanced. Finally, handle the
new negative return in __btrfs_balance() by jumping to the existing
error path, which aborts the balance operation and reports the error to
userspace.

After the fix, the same corruption is correctly detected and reported
by the filter, and the null-ptr-deref is no longer triggered.

Fixes: 5ce5b3c0916b ("Btrfs: usage filter")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/volumes.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2bec544d8ba3..1eca5fa6bdaa 100644
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
@@ -3881,7 +3887,7 @@ static bool chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
 		user_thresh = mult_perc(cache->length, bargs->usage);
 
 	if (chunk_used < user_thresh)
-		ret = false;
+		ret = 0;
 
 	btrfs_put_block_group(cache);
 	return ret;
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
+		int ret2 = chunk_usage_filter(fs_info, chunk_offset, bargs);
+
+		if (ret2 < 0)
+			return ret2;
+		if (ret2)
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

