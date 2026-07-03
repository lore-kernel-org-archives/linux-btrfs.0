Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99191A267
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 22:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783118761; cv=none; b=DVu8arX7mbVcFs9aKB1FpLZYZaX/v/O2y4iRz4+Mpzv+WseHj+1WDHbElV3bqZONfpeaAEfoivz/vb8HsNOO+QaLrY/IUz/A6Md1mc9i49NZ2RDVNIw+HSsncSItA0J9MCmQJvrOd0YD2T7g+/1gzurpYrTLs27x26I1hH3alUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783118761; c=relaxed/simple;
	bh=PSjFwIIno+ebiVWym6GDA9Tme7ZjXlcJe7QBT7YkdM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q8i7bRh8/wQEYvZRtZij1HJGHVW04g2SGOLBvcou6/6Ktey2hwvBx93J2dbFTKHKZc1jti7gHodmSsixXzS5hSj0j2wn+ZdBs/9VcfVDIV474mLff1QZcww86HO8ooD8pql40lLX6wkawxmKX6Y4XKG9VwKHgx9QDaK1torGkGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VGF4vYKX; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VGF4vYKX"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-37e0fb87b75so1115612a91.3
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2026 15:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783118760; x=1783723560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OF4WsiF3Ail0sbbjny0CNLup/vJTyjDY+iJarnPvWzk=;
        b=VGF4vYKXgqWBuxf7M9YtuIfZvZYB/SEXc1OMBDpW+ScjV2z6StX+KHl8H0l0IxS03S
         UkfHVTBImOnh1IvHAxqcrDuUFScByjYf0ymoyb/NUg5wpv2dUp6xru29hCNpzQnZX6Z1
         v6DuiNs5nOBExcUYkX54+293dV+wRNmQyeETLTqIBb0T5ZknBdePTooundTmU/uiZOR3
         yXQvFj5rBBxxyFuBIuKqwtgahC54ERX4nUfqqY7R2ehpOlqoOFGbHXgobMqdETQhn1nQ
         yQOaGExLflzVCd3SHgkr/i8v1vZS5++D4GM0h83EX3BkmcSsj3ZXdQ5T051ysXTCpJTz
         3hdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783118760; x=1783723560;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OF4WsiF3Ail0sbbjny0CNLup/vJTyjDY+iJarnPvWzk=;
        b=r+fCXrhENSchlcqyMVysoaBRdclx6OEl7yl1d6vls+vVHzRMNV9R291eKtct+2bw04
         2YI4I6ika4XJY+XPZb9AgIfZs93PX/2h+JdFBng7CM5Vv1+Lxv1TWruSNYj9BwhghkEs
         K+toPn9sPuDy0tvVpf27Vr0sA3aNbhrl+aibMYPdetRYlx2aHusMufY6/gHV+2Pc2mMz
         jrwnBBuGBGydDwpFcxHejNFe0TrV8AHOf4ivRNo1yGMXa0m1MqLuUVzn2jLfYAzViWgp
         Eb6lR3AX3ydZ9xhiPhxnD121ewDG+S7fo+6Ojesr3WDeV9iKDu2I9taqpbZDWtgJSf9v
         IQaw==
X-Gm-Message-State: AOJu0YyylOwaqJftzFe8uStXYcVum0Mm7Y9U6FN6Riaz5Ikcqc7cGfTy
	voulIROIiqorrhKBQYeYcp5h2oW9CU8xBRSgO6gz3078GLwFge4GJpvYiakI0w==
X-Gm-Gg: AfdE7ckFOvR7tch5z0XEcKSOy6jZdoTofHGMTPgcJJwOChoUl1i6nEn30U/WfeN3VM/
	1CnwQk4upv+w+DOVeNyZmIvbP3CgZhuzmjULpOJ3bnQjG46mYxQpclBUKdLF14AknTAuxtHmZ74
	fz/IQZuQH5WTfhmCAqo2I0IKUhoo1UXRbj96becX2hDMtVzCrNT0cKtfqWpDYb3FbJjgV6ODe8w
	JbRXCDAVACggX7ILEaTxl9IiWHga8E0lC1G+LyR3xwFTfXVudC7cu0BFGHeYFZi3fwubw1hKTHj
	umMLGiOHGP3WpFswM5u3bsuRq7PyeLNU0313z/ASvxMdBPsUOOswtfZEkkwhEKN9L61Y8WM3H3l
	fuIqFANVPLJmMHxYIkxzBN9tpWj5Ig7tznutfOpyyiMwUhoRNckJCGme+iX9LKDCYpKvmpzg4md
	M1XHZTvBFI8uveN+6wswNj5z2kbrdhlkfKWA6d9X2OdbUuTea1plxXX2Dt7LNPDu/kMT9KFSPHY
	fQOYwTBuQ==
X-Received: by 2002:a17:902:da2d:b0:2c9:97a7:3278 with SMTP id d9443c01a7336-2cbb9ef3df4mr8758615ad.41.1783118759764;
        Fri, 03 Jul 2026 15:45:59 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad712b12fsm14967025ad.25.2026.07.03.15.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 15:45:59 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] btrfs: compression: allocate buckets with workspace
Date: Fri,  3 Jul 2026 15:45:57 -0700
Message-ID: <20260703224557.488297-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert 3 allocations into one. Simplifies code slightly by removing
extra kfree calls.

SLUB merges same/similar sized structures for the named caches, so not
a huge size concern:

grep 2112 /proc/slabinfo
sighand_cache        593   1335   2112   15   8

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: use normal arrays
 fs/btrfs/compression.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ffb6b52863a7..c62b5148d5ac 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -651,9 +651,9 @@ struct heuristic_ws {
 	u8 *sample;
 	u32 sample_size;
 	/* Buckets store counters for each byte value */
-	struct bucket_item *bucket;
+	struct bucket_item bucket[BUCKET_SIZE];
 	/* Sorting buffer */
-	struct bucket_item *bucket_b;
+	struct bucket_item bucket_b[BUCKET_SIZE];
 	struct list_head list;
 };
 
@@ -664,8 +664,6 @@ static void free_heuristic_ws(struct list_head *ws)
 	workspace = list_entry(ws, struct heuristic_ws, list);
 
 	kvfree(workspace->sample);
-	kfree(workspace->bucket);
-	kfree(workspace->bucket_b);
 	kfree(workspace);
 }
 
@@ -681,14 +679,6 @@ static struct list_head *alloc_heuristic_ws(struct btrfs_fs_info *fs_info)
 	if (!ws->sample)
 		goto fail;
 
-	ws->bucket = kzalloc_objs(*ws->bucket, BUCKET_SIZE);
-	if (!ws->bucket)
-		goto fail;
-
-	ws->bucket_b = kzalloc_objs(*ws->bucket_b, BUCKET_SIZE);
-	if (!ws->bucket_b)
-		goto fail;
-
 	INIT_LIST_HEAD(&ws->list);
 	return &ws->list;
 fail:
-- 
2.55.0

