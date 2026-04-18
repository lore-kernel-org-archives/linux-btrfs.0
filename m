Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F10396577
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776523110; cv=none; b=rBl7orZDLg5tNeJWEPSwXp4uMf0Ruf/IltyaelOBw6zKLEzuYd9/Ny5+W7/17Bk4Ol7FUWvF29s1WfXY5M7DYayIwZ2gMNhECd847mc0PlXa3ej3/cjl5hyo7oCR7XfFXDwOxsmwW7zLRDytUOUBERmShSS/4FEcbdjXxAEIRv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776523110; c=relaxed/simple;
	bh=/8TVsJSi13dF5kAwMlx23LiWEj4oczYz3ZMAe5mQAU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJGYKfI36GmsbKJBCWwvc06+YmywPnCaJ0qogWqGXF1TpsqD3dus9/pBwIQVAIwxiLOL6rqsWRI1DrbAJdC6N+XSjwN6eGsvRMtiLYgyIs/wmQ7K/ZriP+mZW4Pxh0+31fytgp8vsLqCoRxn2P9upnq9Svzd+r0PR/HYe175IQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fuevE+RL; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fuevE+RL"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43fe608cb92so972247f8f.2
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 07:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776523107; x=1777127907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q4Ro7hgVQu12yjxOCPabNh2Oo9KzFKlGIJIlFbADXw0=;
        b=fuevE+RL1beM5EkCoyVyJe7EkyGuaEP5orXiSZrW6At9V36DnlDWHUz9rUGr2ibs6S
         IIDU2bwJBFybOwCu0vdUgT/Otdup0BHXaISuubrjbLZhc0LFfepGhxA5avCbLFKHvuew
         7yYl/w606yDO3OxVPkmgLnKpjlYmmif5SE/dlAOMTlQ/BgyqWkPNqWgFvYFhNxB8AAxc
         ZRhOGsW30rJMHxpAkocKTqqUQ2Vv1vF2zSZTIufBtGeRDYJzymRAaM02o7Y3zf4oFk6m
         UfWh/Cqiu5IgtDNax0GnEcaDYRD0NlLcZ7nF0fZpPqIrZQgpI0GN3blV0ubrLQkBFRLN
         jLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776523107; x=1777127907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q4Ro7hgVQu12yjxOCPabNh2Oo9KzFKlGIJIlFbADXw0=;
        b=mOSClg4wXu1NmXTguaC5bztmxwCn9HKm6SLFtQKVL0aXUFmLinXZcq19nEaWzOE9Cp
         MzxBbBM5/b9vkKp+jVYMQKuIEbdNed2lPWcn7lLWGFAnl2Hi06N0oD7D54Q6VLVqCP9G
         iJOvd3/UiAIXwiroNoODhbTwqmtwJv9Hui2q2gBMRQVDFgggqa0jg/p9MbGzY1a3UW4s
         qK9rX+47vSkkms6Sho5daOowwOUtg50ROG4wlSpzAh8k6uygOi3y5IjbHDaRthwGYU8a
         HRnV/UHmu44gs8YVH7iXa4e2fLjjn8Md+O0F246s3dsF+K4ff8unWkw9xr0IcFqHDKHb
         b2Zw==
X-Gm-Message-State: AOJu0YxkbEqr9TgHalTVKMYEqA/yb8evCUrLt+ggzWJGy5juKuzHWBgJ
	owP6M6MoA3G/a5VemJhvNfe9PZQqCsW9mQ6wTImMHHy/eCKGTMwrcF+PgFLl+3P4
X-Gm-Gg: AeBDiesnQAMFWAvzy4X+TBY6fxajiWX9FUzlGMptM3kv7Wxm+1FxxnrrhksrnK4RaBf
	GvVuEdPbpN6BCT6EdySuYl/uSoeXXGEkrxG7cC40rAinKWhTqJEYo+BjAKmtzaoshTSGrx4g8hX
	eg+a9JzvjzvWqIvyqiu+wSH53pZ6+7p+T13qDXBsXmuBbEwIu6uMJdq0Zp0wisQMy32sh4Zt1Cl
	Krr/GsCORliKui+qY6PvHLx8nC3JC8f+avHCzktihx0QJgde+cuSoVI5ahofyCtTeCZNBFlpw53
	gdzJNLVac6JXIEDSVBfelj3mZDANp74ukSwDs8NIZkn+6oNi029RKAlli+/OExT5PBc9E2h1e3Q
	DnAOUWPfsB9uRWPZmigJjhIPivhfbbwjsNMgcMSq1D1xD+dmxbQVDalLS0S/NvhRSWNhrwNQzqi
	t29fV6CXJBm9fb44py6mQyE+ZfekICaxMrnkm20XUsU1OYdVUxk+8FFX6JKFwp+83M1vUnXNkFe
	x9Rk6QzT2ALBBzvCUgLfN7BWIyip2UyUecYc3g=
X-Received: by 2002:a05:6000:2f8a:b0:43d:9bb5:bda5 with SMTP id ffacd0b85a97d-43fe3e0ae25mr10338578f8f.40.1776523106815;
        Sat, 18 Apr 2026 07:38:26 -0700 (PDT)
Received: from len.tail8322.ts.net (sgyl-44-b2-v4wan-166595-cust701.vm6.cable.virginm.net. [77.97.226.190])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a397sm14509303f8f.23.2026.04.18.07.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 07:38:26 -0700 (PDT)
From: Paul Richards <paul.richards@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	Paul Richards <paul.richards@gmail.com>
Subject: [PATCH 1/3] btrfs: refactor btrfs_fallocate() ahead of supporting more modes
Date: Sat, 18 Apr 2026 15:38:06 +0100
Message-ID: <20260418143808.199603-2-paul.richards@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418143808.199603-1-paul.richards@gmail.com>
References: <20260418143808.199603-1-paul.richards@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor btrfs_fallocate() to switch and dispatch based on
the mode argument, splitting most of the modes into separate
functions. Only the "allocate range" and "zero range" functions
remain coupled.

Signed-off-by: Paul Richards <paul.richards@gmail.com>
---
 fs/btrfs/file.c | 63 +++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a4cb9d3cfc4e..0b5cc3cec675 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2668,8 +2668,6 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 	bool truncated_block = false;
 	bool updated_inode = false;
 
-	btrfs_inode_lock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
-
 	ret = btrfs_wait_ordered_range(BTRFS_I(inode), offset, len);
 	if (ret)
 		goto out_only_mutex;
@@ -2712,7 +2710,6 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 		truncated_block = true;
 		ret = btrfs_truncate_block(BTRFS_I(inode), offset, orig_start, orig_end);
 		if (ret) {
-			btrfs_inode_unlock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
 			return ret;
 		}
 	}
@@ -2809,7 +2806,6 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 				ret = ret2;
 		}
 	}
-	btrfs_inode_unlock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
 	return ret;
 }
 
@@ -2933,6 +2929,8 @@ static int btrfs_zero_range(struct inode *inode,
 	u64 bytes_to_reserve = 0;
 	bool space_reserved = false;
 
+	ASSERT((mode & FALLOC_FL_MODE_MASK) == FALLOC_FL_ZERO_RANGE);
+
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, alloc_start,
 			      alloc_end - alloc_start);
 	if (IS_ERR(em)) {
@@ -3092,7 +3090,7 @@ static int btrfs_zero_range(struct inode *inode,
 	return ret;
 }
 
-static long btrfs_fallocate(struct file *file, int mode,
+static long btrfs_allocate_or_zero_range(struct file *file, int mode,
 			    loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
@@ -3115,27 +3113,12 @@ static long btrfs_fallocate(struct file *file, int mode,
 	int blocksize = BTRFS_I(inode)->root->fs_info->sectorsize;
 	int ret;
 
-	if (btrfs_is_shutdown(inode_to_fs_info(inode)))
-		return -EIO;
-
-	/* Do not allow fallocate in ZONED mode */
-	if (btrfs_is_zoned(inode_to_fs_info(inode)))
-		return -EOPNOTSUPP;
+	ASSERT((mode & FALLOC_FL_MODE_MASK) == FALLOC_FL_ALLOCATE_RANGE || (mode & FALLOC_FL_MODE_MASK) == FALLOC_FL_ZERO_RANGE);
 
 	alloc_start = round_down(offset, blocksize);
 	alloc_end = round_up(offset + len, blocksize);
 	cur_offset = alloc_start;
 
-	/* Make sure we aren't being give some crap mode */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_ZERO_RANGE))
-		return -EOPNOTSUPP;
-
-	if (mode & FALLOC_FL_PUNCH_HOLE)
-		return btrfs_punch_hole(file, offset, len);
-
-	btrfs_inode_lock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
-
 	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size) {
 		ret = inode_newsize_ok(inode, offset + len);
 		if (ret)
@@ -3185,7 +3168,6 @@ static long btrfs_fallocate(struct file *file, int mode,
 
 	if (mode & FALLOC_FL_ZERO_RANGE) {
 		ret = btrfs_zero_range(inode, offset, len, mode);
-		btrfs_inode_unlock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
 		return ret;
 	}
 
@@ -3282,11 +3264,46 @@ static long btrfs_fallocate(struct file *file, int mode,
 	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
 			    &cached_state);
 out:
-	btrfs_inode_unlock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
 	extent_changeset_free(data_reserved);
 	return ret;
 }
 
+static long btrfs_fallocate(struct file *file, int mode,
+			    loff_t offset, loff_t len)
+{
+	struct inode *inode = file_inode(file);
+	int ret;
+
+	if (btrfs_is_shutdown(inode_to_fs_info(inode)))
+		return -EIO;
+
+	/* Do not allow fallocate in ZONED mode */
+	if (btrfs_is_zoned(inode_to_fs_info(inode)))
+		return -EOPNOTSUPP;
+
+	/* Check for options we do not support. */
+	if (mode & ~(FALLOC_FL_MODE_MASK | FALLOC_FL_KEEP_SIZE))
+		return -EOPNOTSUPP;
+
+	btrfs_inode_lock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
+
+	/* Only one mode bit may be set. */
+	switch (mode & FALLOC_FL_MODE_MASK) {
+	case FALLOC_FL_ALLOCATE_RANGE:
+	case FALLOC_FL_ZERO_RANGE:
+		ret = btrfs_allocate_or_zero_range(file, mode, offset, len);
+		break;
+	case FALLOC_FL_PUNCH_HOLE:
+		ret = btrfs_punch_hole(file, offset, len);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	btrfs_inode_unlock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
+	return ret;
+}
+
 /*
  * Helper for btrfs_find_delalloc_in_range(). Find a subrange in a given range
  * that has unflushed and/or flushing delalloc. There might be other adjacent
-- 
2.53.0

