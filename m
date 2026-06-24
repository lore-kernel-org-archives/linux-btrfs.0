Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D19145B11
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782273767; cv=none; b=mJ2cEeDa3UlVhT2wtVX3/Zr6quS8BZJAJYwT/q+5J73aeKR76HshPe+S+rsC1D34Y8DU8VQKKpFWF7gRt8PQXunSd1dxc8bnPqvlNGXBKxlnDSGDX4bAxmSL35uEea6rw/sfmn/vRFCGVMNJX84Ycdm3fKbBcMXw81ZRfuELnWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782273767; c=relaxed/simple;
	bh=dWsqay2E1rmfKGzGczygemnsugvwoza9Ncuw6q2cvlk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PqJ8lbjhEyCx3nmjHVM76mVCB9Qg6Vs4zkRAZLf5gUtzg6Ca5BRD8YuOi7KHSwC35vky5nnICTIKhNa36m5MN3MIJz+f4x4Rn9sjl2JtxckLMFdgCyR/USdoSExYBM0YmMERnknaQ8KaiHvChnOqRg0EZBeBuJKuJGoXnVg+95Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dIHdcdsB; arc=none smtp.client-ip=74.125.227.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dIHdcdsB"
Received: by mail-pj2-f2.google.com with SMTP id d9443c01a7336-2c6cfc305a9so214945ad.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 21:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782273765; x=1782878565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sP6J92ABPuLtz45k7NNDaxD2yaWwV81HNCZ5XDXp91E=;
        b=dIHdcdsBAwVH/uKxN1ztawZT4lUdU3yMrq4iDmuE4Q1Y3OBpLp5dspKGXnpo7qIrA3
         fSAhRDXRyig3O7d1iPjfI1cUvBslFqzShC94iwY/nadDQBLIry77zkvLGnOmq65a/0Y8
         xBaIsOk4kDbfPu68Ib3LrKGys0jppms1bZJ4EpeBF0OemdsY6M5Prma024Ixkay92+Fh
         jIKTtxFaHdw/7fUNIYk1VJGl+ZS93JnvBzF2IdYYaqjKy5pRZyUN4HucNhkDeJ0ErOaQ
         c+jZdCROv6sXIXYqyoSoYSa++GaqfudDj9PMP1NTUi/Xgj1difjckqhZEZ/wTLwKcLAy
         zLkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782273765; x=1782878565;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sP6J92ABPuLtz45k7NNDaxD2yaWwV81HNCZ5XDXp91E=;
        b=eekfLXG2CfG7tQSZKGlO9mcmhk0rb6RudKjIs2IpKlHu/9BMbIZNzhLNcgHGyWIOR0
         yZMNZpZKSYO6pZfHDYvUZbd/L27dyVHKRNEsWe5bRDvPQZSvwDIK2MBXUD5vJDoawIIh
         ivxfNWSOa7od+fdxg6UHIo6OyYUDXFkwj6ZWO5ugj+/O8mkURlBUb6Ddz28MDLcn/DC4
         bSxdnAURbflZzXcqIQqALMYelkJ4yxyZnpLW76jUzUOXVkWNEXcR3uSScC21PSZZU9Bp
         Zc04XY/vyB2cBSGhE06KL2uVXZkdidXh+7yYCs97HaF74OK5OcX8lzEg1dEYZZri81RL
         srGA==
X-Gm-Message-State: AOJu0Yx+/IqfVmITQ+8jTYAGTZOWchztCItEdhaEtk9fHFbzvqUH62nE
	EvCkzvDBi9+jlYQj9T2t8njZPcfEFyhne0lNtt4YuBfJ2k6E6dVR8Q3H4VtrhViW3Smg/A==
X-Gm-Gg: AfdE7ckvPIWhLTSNATmAR1SZjgQD1j9T2RlNNZkMYWybN0vSzbUKNY02DZKbXWeyCi1
	Y7mMKnjtxpLrSMNWBTTB95PVDxsanoms6Pap1o17j5firc8zMvqsuZydohBYxFtGBnSPHpHyJpJ
	EQnnYyMe4CT/ibZNoOtiT4nTul+9u0dfRiyxsCFhrHJk3YwUORa3EEwQIT99Sin62U2T8QsubBa
	9MHr+oczdIUrYD39vbiUxHH8M/ydeRmSaanjmiDYs9p8v2+SOScuHrXHHPGVoZWT8Yke1Fl5SRY
	FeDgvPsF94MWXn/GbwEzxenbG+/pGVGlcMtJkoWcQcVUE1kLU5jQ+aROXxpQATAcWcuh4fvANeQ
	YIEhZF3HP8qO/vrtopwQ7nabrEmc1zgmxJeS+Rt3GRFEoCwtCXir6C8MntFeXhfE6gWjkV8Xx7f
	/6pQG0VQvOn4+aIWWCtMoRGHuCit84P9RD//5pC96X
X-Received: by 2002:a17:902:f651:b0:2c0:c965:6656 with SMTP id d9443c01a7336-2c7bf1d6ab6mr38984715ad.6.1782273765222;
        Tue, 23 Jun 2026 21:02:45 -0700 (PDT)
Received: from SaltyKitkat ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7439f8cfbsm119448665ad.45.2026.06.23.21.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 21:02:44 -0700 (PDT)
From: Sun YangKai <sunk67188@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Boris Burkov <boris@bur.io>,
	Sun YangKai <sunk67188@gmail.com>
Subject: [PATCH] btrfs: change block group reclaim_mark to bool
Date: Wed, 24 Jun 2026 12:02:27 +0800
Message-ID: <20260624040232.30420-1-sunk67188@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The reclaim_mark field in struct btrfs_block_group was a u64 that was
incremented when marking block groups for reclaim during sweeping, but
the actual counter value was never used - only the zero/non-zero state
mattered for determining if a block group needed reclaim.

Convert it to a bool to properly reflect its usage and reduce memory
footprint by 8 bytes. Update assignments to use true/false instead of
increment and zero.

Signed-off-by: Sun YangKai <sunk67188@gmail.com>
---
 fs/btrfs/block-group.c | 2 +-
 fs/btrfs/block-group.h | 7 ++++++-
 fs/btrfs/space-info.c  | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 9e937407d12a9..5829c806c4d48 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3923,7 +3923,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 		old_val += num_bytes;
 		cache->used = old_val;
 		cache->reserved -= num_bytes;
-		cache->reclaim_mark = 0;
+		cache->reclaim_mark = false;
 		space_info->bytes_reserved -= num_bytes;
 		space_info->bytes_used += num_bytes;
 		space_info->disk_used += num_bytes * factor;
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 790c2d467af57..942befdf75df7 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -263,6 +263,12 @@ struct btrfs_block_group {
 
 	enum btrfs_block_group_size_class size_class:8;
 
+	/*
+	 * Mark this blockgroup is not used for allocation
+	 * between two reclaim sweeps.
+	 */
+	bool reclaim_mark;
+
 	/*
 	 * Number of extents in this block group used for swap files.
 	 * All accesses protected by the spinlock 'lock'.
@@ -281,7 +287,6 @@ struct btrfs_block_group {
 	struct list_head active_bg_list;
 	struct work_struct zone_finish_work;
 	struct extent_buffer *last_eb;
-	u64 reclaim_mark;
 };
 
 static inline u64 btrfs_block_group_end(const struct btrfs_block_group *block_group)
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index e6641597b321e..39a28e1bec8ad 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -2156,7 +2156,7 @@ static bool do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
 			will_reclaim = true;
 			reclaim = true;
 		}
-		bg->reclaim_mark++;
+		bg->reclaim_mark = true;
 		spin_unlock(&bg->lock);
 		if (reclaim)
 			btrfs_mark_bg_to_reclaim(bg);
-- 
2.54.0

