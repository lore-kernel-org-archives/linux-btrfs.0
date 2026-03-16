Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B8B34E768
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 13:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773668812; cv=none; b=fGA6vHAya06S0EmrCWJ0R5nRQux8PrnKRLA35jV+vFARt6SRuozeZYH5ltVIUnSQos9Y9uUgbWcbIrdem3KTXQ741hrDi/qkp9Yko1bpYNtIRUx9sNprmKeCmoBJoMXwlABEEaDvX5xhoReDROTL+QW+RWl2EFKSTeXummyqSyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773668812; c=relaxed/simple;
	bh=breDB+00djj9jhqac1wBzBjoA2b5kvIH5MdmzZDEYws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UBYX5Ed8i2TEGvwO3IUk9HIFDXio467kpEEoq3tdOkRYiMofkElXQad59dVlIJ6RNahWorzOyih+NzNVerK+ozn2C/JY987xWm9zX7fHaYpXmYBJ+0/T+PPUELcqu1WmOEpApGzAAboHMdGGZTU/Zx0kRbTf4LZhkSdHc9AVcJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iWciS++s; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iWciS++s"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b048527825so10502235ad.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 06:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773668810; x=1774273610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8sFGbjk8Rr0qu9K/p0VmFfHdyoMlcL5YQ+B7+8Owpfw=;
        b=iWciS++s8DKcrC/tTnIb6FymswINft1+owJ4HYvZZZC4a3imZ3DE7AFbbQSwiMzQoO
         pWHbIFJBOU8PV13NFlU3nF1KlAX+2Maqi+FZp+MSkQWW94g3BGtVY2ho4larq5WnC8DT
         jRf3gEh9USOEkvM9h5O4s97OOCGqcLfy5LMfrvef6Wjt0wQOlQq2gtnu71Q+bwOktbvs
         R6VHpzebEqh4E/slk+2G19HzYixr45Y9nR8Fm22wKx/OxB08xOP2YX341hgnEAJcYbYd
         9sNcmJ4PLXUJYKakqJ0+E2FqOUm67kHH/KAEL534d091lE3g+jxtq0AQtVxhhsSjDSQL
         SdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773668810; x=1774273610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8sFGbjk8Rr0qu9K/p0VmFfHdyoMlcL5YQ+B7+8Owpfw=;
        b=X3R5J9w2lvSjo+ma3euvwPfwWF/RNfMpNHlBROdrKOWltvrXu5EU4V6FsXBOisDNxE
         4KZ2FIwkh4KaZ93sygibHKzSjTyw+Jy/8RKQz3puCP7KA7L0/ZPjeZhMwVSHw0Ln8njK
         I5CQVLJgfs5aXhQNoBJiSp6hg6CCzq7wmi61+X/xjtnuIcdOjaO0/FMydEHiKrag7+MQ
         SeOmxjbpIDgYhO6OBmPS0dLa+GRZmqcPxwRmsL//hsQ6v0cteKPMgiGyvM3EaMGTckhJ
         4+F6nTVO0jzAdVU7WlwtYwHQVerACSHUTpb0GzmsszNrk0cw+NDw2jHSeHUp+ew4PWVw
         GeiQ==
X-Gm-Message-State: AOJu0YzOReudY3sY3zMOuJ2l83NLEKluK0H+CWAbnqCRrSDDYD+El/hN
	1A7FYrPNyVz+N5KFQ6dxVvxrxHhjOtG8jhkspFmcS6BeJC97T2rITXUu
X-Gm-Gg: ATEYQzy1otA2oefrkV6YKxHcpu5HRnfKhCugdwzpHUJVkEVnSoWqwvS+q08eL+1cScM
	6TO0dPON8eKTytMp5LpJdymb6ThqY55I9LXlxUQkZpJXoIScRBnGG7R8eso0hEiasuW+NFpvzqf
	pyQUAmE7+cQkJtPoT3PJ1ZlQtCbduPKsJ0+9UeGgX4zgDGUa3jiY8cpp+KFeRqOqGtBXyNkAKcO
	UEBD0O/C1CCUF/wGlBlKyQjHOHRFuyYoNCmxRv4YiEDHLmXOqYYapjtcWcEvS+WUeLksPZsQ9HR
	m0dZ0MskkGa2qg/HH4lIy/NiqJ2IYLuGjUZjJ26XcU49uca5m0kZMRmFasSVPkHQDqIY2MjkX7O
	kw0GuQEzFHKmEtrx8NtZWsz+UvETg0Se8FChgnyAzdWkJcHbUCT6VjnGUGxLW0nggGL1ic0DFea
	MiUlEEUx4jQOQFPLfzbMzoEdpd7odRq+3Z3LvY93nXlYkd7y7grE24/1cFGFBrS5O1pFTfLXk=
X-Received: by 2002:a17:903:19cf:b0:2b0:4eeb:f800 with SMTP id d9443c01a7336-2b04eebfb1bmr59113245ad.33.1773668809726;
        Mon, 16 Mar 2026 06:46:49 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.183.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b05b4ca68csm25859945ad.79.2026.03.16.06.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 06:46:49 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: balance: fix null-ptr-deref in btrfs_may_alloc_data_chunk
Date: Mon, 16 Mar 2026 21:46:40 +0800
Message-ID: <20260316134640.2605237-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
Running btrfs balance can trigger a null-ptr-deref before relocating a
data chunk when metadata corruption leaves a chunk in the chunk tree
without a corresponding block group in the in-memory cache:

  KASAN: null-ptr-deref in range [0x0000000000000088-0x000000000000008f]
  RIP: 0010:btrfs_may_alloc_data_chunk+0x40/0x1c0 fs/btrfs/volumes.c:3601
  Call Trace:
    __btrfs_balance fs/btrfs/volumes.c:4217 [inline]
    btrfs_balance+0x2516/0x42b0 fs/btrfs/volumes.c:4604
    btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
    btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
    ...

[CAUSE]
__btrfs_balance() iterates the on-disk chunk tree and passes the chunk
logical bytenr to btrfs_may_alloc_data_chunk() before relocating a data
chunk. That helper then queries the in-memory block group cache:

  cache = btrfs_lookup_block_group(fs_info, chunk_offset);
  chunk_type = cache->flags;   /* cache may be NULL */

On a corrupt image can contain a chunk item whose matching block group
item is missing, so no block group is ever inserted into the cache. In
that case btrfs_lookup_block_group() returns NULL.

The code only guards this with ASSERT(cache), which becomes a no-op when
CONFIG_BTRFS_ASSERT is disabled. The subsequent dereference of
cache->flags therefore crashes the kernel.

[FIX]
Add a NULL check after btrfs_lookup_block_group() in
btrfs_may_alloc_data_chunk(). If the lookup fails, emit a btrfs_err()
message identifying the affected bytenr and return -EUCLEAN to report
filesystem corruption instead of dereferencing NULL.

The caller already treats negative returns from
btrfs_may_alloc_data_chunk() as fatal errors, so balance aborts cleanly
and reports the corruption to userspace.

Fixes: a6f93c71d412 ("Btrfs: avoid losing data raid profile when deleting a device")
Cc: stable@vger.kernel.org
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4958e074d420..4657b826b48b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3597,7 +3597,12 @@ static int btrfs_may_alloc_data_chunk(struct btrfs_fs_info *fs_info,
 	u64 bytes_used;
 	u64 chunk_type;
 
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
-	ASSERT(cache);
+	if (!cache) {
+		btrfs_err(fs_info,
+			  "balance: chunk at bytenr %llu has no corresponding block group",
+			  chunk_offset);
+		return -EUCLEAN;
+	}
 	chunk_type = cache->flags;
 	btrfs_put_block_group(cache);
 
-- 
2.43.0
