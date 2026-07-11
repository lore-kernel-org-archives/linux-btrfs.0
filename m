Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E762E285C
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 05:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783747194; cv=none; b=E2cvF8VWbvBd4H7ouBkR7VX8Don0Jy4iC027vlOv8a9qk4VbuJrkYOeL+SpRGonzrYyR/fzVbdGDk2ZWsFGb10DkeKQ2RvF/kJimzpXrLNqMEsCKvWiSUFElSJEHEgjKI5tiN864jdsY6WENr8oOrgQTaa4xseiAo6Un1k6ZTRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783747194; c=relaxed/simple;
	bh=a46Atrthc8HEX5mTZuFqLO2Ej6eW/5axhYra0yrZynE=;
	h=References:To:Message-Id:Mime-Version:From:Subject:Cc:Date:
	 In-Reply-To:Content-Type; b=Yr0kXS8O7QlPBxYPcexSULgEDTdZA4oV4djagVdZSGRacjmHHuek1Etbwpe8V27nLhK0M3AGKSsvAeblHm1T55fYklr7tusjADxBfMAWgi7vmoWPXOwIoCS1EpiPDYmKGPMNi2PDfQEHn/VikwSXAV892QOAl6PyBlIk/BGtzo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=jta7qBF5; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="jta7qBF5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783747180;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JOJ7LTI1WI05vHbWT2mZOkuAVar9yB772D57HVYB3hA=;
 b=jta7qBF58aIfa1NWkXBCz16ZtfUYyh/U3caVJlvK92bowXwEgr6Yv+kDX+dRADq/xkv0sR
 W4X1NNcLfU4p/KwRAHedLXuKo8SKZZCIR40M6o7GAPzpoSNjALQp0MFTooZahPt06U/ZRd
 +fTuH1f08LnrW0ReRAZjyqNfw+fwUBm1rYxchG3DsYCWkw8J0qDdeSCfgU4ke8i8Ww376s
 9Fdpz+iRtVj/Pg+UrTP1s1tRzqkFhILEiZjp7TEZ1AvZmm2LI3jO8kEyN7n6cFbIEfcEYi
 RuJYoSrZ1nkIxBMA6H89/z0tbePHNqrsUtcDQV7tiyI0EMsOpPdbnNdIjbao8w==
X-Lms-Return-Path: <lba+26a51d26a+923fb2+vger.kernel.org+zhudongjiang@fnnas.com>
References: <20260711051909.1313584-1-zhudongjiang@fnnas.com>
Content-Transfer-Encoding: 7bit
To: <linux-btrfs@vger.kernel.org>
Message-Id: <20260711051909.1313584-2-zhudongjiang@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Subject: [PATCH 1/3] btrfs: avoid NULL pointer dereference when block group tree root is missing
Cc: <dsterba@suse.com>
Date: Sat, 11 Jul 2026 13:19:07 +0800
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260711051909.1313584-1-zhudongjiang@fnnas.com>
Received: from pdzhu.teiron-inc.cn ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 13:19:37 +0800
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8

[BUG]
For a filesystem using the block group tree feature, corrupting the block
group tree root and mounting with rescue=ibadroots triggers the following
NULL pointer dereference:

  BTRFS warning (device loop0 state E): checksum verify failed on logical 30654464 mirror 1 wanted 0x0f55b851 found 0xd7efdde7 level 0
  BTRFS warning (device loop0 state E): checksum verify failed on logical 30654464 mirror 2 wanted 0x0f55b851 found 0xd7efdde7 level 0
  BUG: kernel NULL pointer dereference, address: 0000000000000100
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP NOPTI
  RIP: 0010:btrfs_update_global_block_rsv+0x9d/0x1c0 [btrfs]
  Call Trace:
   fill_dummy_bgs+0xd4/0x120 [btrfs]
   open_ctree+0xc6e/0x1ca0 [btrfs]
   btrfs_get_tree+0x50d/0xa40 [btrfs]

[CAUSE]
With rescue=ibadroots, btrfs_read_roots() ignores a failure to read the
block group tree root and leaves fs_info->block_group_root NULL.

btrfs_read_block_groups() then falls back to fill_dummy_bgs(), which
initializes the global block reserve.  btrfs_update_global_block_rsv()
checks only the BLOCK_GROUP_TREE feature bit before dereferencing
fs_info->block_group_root.

[FIX]
Check that the block group tree root was successfully loaded before
accounting it in the global block reserve.  This does not affect regular
mounts, which fail earlier if the root cannot be loaded.

Also update the comment in btrfs_read_block_groups() to cover both the
extent tree root and the block group tree root being missing.

Fixes: 8dbfc14fc736 ("btrfs: account block group tree when calculating global reserve size")
Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
---
 fs/btrfs/block-group.c | 7 ++++---
 fs/btrfs/block-rsv.c   | 3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index fe5de4928f6f..9d551372f37f 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2673,9 +2673,10 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	u64 cache_gen;
 
 	/*
-	 * Either no extent root (with ibadroots rescue option) or we have
-	 * unsupported RO options. The fs can never be mounted read-write, so no
-	 * need to waste time searching block group items.
+	 * Either the extent tree root or the block group tree root is missing
+	 * (with the ibadroots rescue option), or we have unsupported RO options.
+	 * The fs can never be mounted read-write, so no need to waste time
+	 * searching block group items.
 	 *
 	 * This also allows new extent tree related changes to be RO compat,
 	 * no need for a full incompat flag.
diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index 9efb3016ef11..647a065356f4 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -347,7 +347,8 @@ void btrfs_update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	}
 	read_unlock(&fs_info->global_root_lock);
 
-	if (btrfs_fs_compat_ro(fs_info, BLOCK_GROUP_TREE)) {
+	if (btrfs_fs_compat_ro(fs_info, BLOCK_GROUP_TREE) &&
+	    fs_info->block_group_root) {
 		num_bytes += btrfs_root_used(&fs_info->block_group_root->root_item);
 		min_items++;
 	}
-- 
2.39.5
