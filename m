Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A95308F32
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 07:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775718789; cv=none; b=AfiCpEgLwlhkewCBBZZbQihydv1Wd0R855OsJK8SMBSVinE1nmI1QPyWf8Dt7WKbGB73g6cXyMqymqk9LIUT+A58lV0tyHsZ0dbhq9fjoXRwbLvXVtZA69xZaE5XFw/PY9jNXnd+E8ixWlKwJhcT5/nN4Rd+tAp4F8KotpIfgys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775718789; c=relaxed/simple;
	bh=tCY2NL0a47vwJ48E9rpCbQejivqclb8282Hnnik6XJY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=poRUYr+Fde5fmledT+9ZOlRSNUbvMDR8C8PzI/3ymyXeshuR1BhHCYGwxi6+qcjiPwbzF4JkGoSm9/DVdVUx/F8VcVJ7IVrtCI5uT7iBYYpVxWLlAqJJhGmKXuJbUJPWTwAIoQLzSNWPo+tndEUKYmerBVVGSP8N4nBnzT+6CFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k8PoKViU; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8PoKViU"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b0ba3bfe16so3610805ad.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 00:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775718788; x=1776323588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LWGv5jK+f51l3Eh/574QqS1q1a1W0Zbtt98PBScNgX0=;
        b=k8PoKViUsqnqlRkKixOskfk0BZTLVgm5gQ1XSM//Hs+HifL+67wivagr9seFeH9yFC
         Y65+/490mFAzWBeM6a2CWATeeTQewFZ2Ys19l/ZvSGEmopr2GbjfrGRS0mSNwZtJnj4G
         NBrU6CjRMdC71uBnD2dwG85TPWPLsJO8Wyf5acqe8arqmLlYndg98Bx1asd5qbxU5brQ
         F57g0lb10EsoVGUw8foaTdzo/aLC9ER4Qo4bcMxrP9yMKZrRDrcaM1XSgkYOnDSs9v9w
         PSjtER3uLzm1Rdrrc/UdEtgGFmVOUsvhJXIq4vx21zLH/RiUnyWUbc2cUmIZHLwe8x8Q
         GlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775718788; x=1776323588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWGv5jK+f51l3Eh/574QqS1q1a1W0Zbtt98PBScNgX0=;
        b=WDOTYmFzKJbErG/kjQPN13pWlwBb1TZB90ygi/QuddZariJ220wkIz0VmTsnjtWCiM
         6saq7tkd78gY3nHyNFrPdjgKKFYTnVorXxWHCt2hw7z9s0EmULoqQgMIVYrRCMa/pk0s
         R/c+gTKTj9auxGhpSj+/SahYHNhNtLLRnwf/JWngFizUrMME6OO2sqQPgE1KWzlNjgcC
         nb9JadJUnGckeTjNSiAEmHJf5dQeBvfgAWJv+0B0oPxkT1o+rv9SS1b///TnlxEdf60c
         JE0VIzaSaoYpBbp36dSpeDHWLgNHIXuqIk/7+Ilr5k5GoWMFoJTKNIuqJz8PMBi6NpAM
         TO4g==
X-Gm-Message-State: AOJu0Ywe5Tblpgs4Bzw1Z6uU1UDwJ6N2VQumaYTQrc6IhfO89DKxeGsh
	iyvbvG6MfALPDwbV3MW3LeCqWCBULZoLh2em3BcYr+jPV9R8ZIkP6yhK
X-Gm-Gg: AeBDieuBu1FavGUUk24bpFsG1/rR7IsDuLigCHvLrASrckAjJW7lMhbg/9+qKS9VY73
	YTSYUOgE30ti0reXbIDqHB78sdCn3ziRR3J2ytHMjMyXodLNv06TbA7I/NCh0jBq2eEDnl7gg8c
	XUKbb7rKA4KXMEA6ZJ3yPoUMek7r7wK/j7XsL7FyiyVL4lix0BYwcjxEzMgkxHkrh+Be03AdGgR
	GSrVDFO0pk25dG0ojkIsUwvxaCygiRSgtBY16WGS2e6XTnj+HSyzZDPKPvfaUvCb2zydYK8EvdU
	5q38GxfYne7kbgZovRTjoMKWoLDe9mXg+d2GFCGWuYSKordyCiXyT9ulOkM7MJ2oTnPWUIB9fF5
	mFA81Qc7cXsSbmOBWdm2myK3W4sACu2VPjppLoHgpp8An+wN80EBM3rGfB+ckjIJ9NBEsKVVFYi
	qur5/kAs0UklHHD1DGx8NIK6EzNME0Pbj52UtryKTeIK7ZaZZeb0aVc0+I3/6l68NrvGUaxA==
X-Received: by 2002:a17:903:13c8:b0:2b2:4a25:5308 with SMTP id d9443c01a7336-2b2c729f2bbmr21516695ad.6.1775718787851;
        Thu, 09 Apr 2026 00:13:07 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27475bc2asm238584255ad.19.2026.04.09.00.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 00:13:07 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	zheng.yan@oracle.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] btrfs: treat empty left leaf as corruption in push_leaf_left()
Date: Thu,  9 Apr 2026 15:12:55 +0800
Message-ID: <20260409071255.3358044-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted tree can leave a non-root leaf with 0 items linked from its
parent. When btrfs_del_items() later tries to rebalance a right leaf into
that left sibling, push_leaf_left() passes the empty leaf down and we hit:

kernel BUG at fs/btrfs/ctree.c:3388!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:__push_leaf_left+0x11f8/0x1610 fs/btrfs/ctree.c:3388
Code: ff48c1ea 03803c02 000f85bd 00000048
Call Trace:
 push_leaf_left+0x3b3/0x540 fs/btrfs/ctree.c:3511
 btrfs_del_items+0x74d/0xf10 fs/btrfs/ctree.c:4541
 btrfs_del_csums+0x44d/0xa50 fs/btrfs/file-item.c:969
 do_free_extent_accounting fs/btrfs/extent-tree.c:2984 [inline]
 __btrfs_free_extent.isra.0+0xded/0x41d0 fs/btrfs/extent-tree.c:3372
 run_delayed_data_ref fs/btrfs/extent-tree.c:1599 [inline]
 run_one_delayed_ref fs/btrfs/extent-tree.c:1779 [inline]
 btrfs_run_delayed_refs_for_head fs/btrfs/extent-tree.c:1972 [inline]
 __btrfs_run_delayed_refs+0x86e/0x39a0 fs/btrfs/extent-tree.c:2047
 btrfs_run_delayed_refs+0x181/0x420 fs/btrfs/extent-tree.c:2159
 btrfs_commit_transaction+0xc9b/0x3d90 fs/btrfs/transaction.c:2211
 btrfs_sync_fs+0xf0/0x630 fs/btrfs/super.c:1057
 sync_fs_one_sb fs/sync.c:84 [inline]
 sync_fs_one_sb+0xf4/0x140 fs/sync.c:80
 __iterate_supers+0x1be/0x290 fs/super.c:923
 iterate_supers+0x24/0x40 fs/super.c:938
 ksys_sync+0xb4/0x160 fs/sync.c:104
 __do_sys_sync+0x13/0x20 fs/sync.c:113
 ...

[CAUSE]
push_leaf_left() only checks how much free space the left sibling has.
An empty leaf has maximum free space, so it passes that test. The sibling
key validation also skips empty leaves because there are no keys to
compare, allowing the empty leaf to reach __push_leaf_left().

[FIX]
Detect an empty left sibling leaf in push_leaf_left() and treat it as tree
corruption. Abort the transaction with -EUCLEAN before modifying either
leaf, which avoids the BUG_ON() and matches how other unexpected btree
states are handled in btrfs.

Fixes: 87b29b208c6c ("Btrfs: properly check free space for tree balancing")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/ctree.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 561658aca018..625aa2ab4c5b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3486,6 +3486,15 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 		return PTR_ERR(left);
 
 	btrfs_tree_lock_nested(left, BTRFS_NESTING_LEFT);
+	/* An empty non-root leaf means the tree is corrupted. */
+	if (unlikely(btrfs_header_nritems(left) == 0)) {
+		btrfs_crit(left->fs_info,
+			   "empty left leaf at bytenr %llu while pushing from right leaf %llu",
+			   left->start, right->start);
+		ret = -EUCLEAN;
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
 
 	free_space = btrfs_leaf_free_space(left);
 	if (free_space < data_size) {
-- 
2.43.0
