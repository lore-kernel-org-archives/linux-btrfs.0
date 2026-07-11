Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F1B4086A
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 05:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783747190; cv=none; b=TDgsurgvX2r+V2kMiOHe9MeQT6MQNo6OKRp2/BBhlch/5fa96dSB0Hclw7W8rhNr6tfDzMHaKzWPsLlmIu8S5QKfV9uZdzONNZLX2qfHI8udDYK0QfMgiCCn2SzZWa7+jhsaFj3GgCoB7RlTTfTBJzPmVGl6q8oOiGDk0Q82xe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783747190; c=relaxed/simple;
	bh=TKtCw8CUBHA7Mxnst6Y7PAByDFgbbD/fCc5ISzMkw24=;
	h=Content-Type:Subject:Date:References:To:Cc:Mime-Version:
	 In-Reply-To:From:Message-Id; b=C52w7fnfbHwblZrVFLWYw2wFSvZ+oJSJhukaAPccNMhaJKenXh4bGxTxx2fotXwZZue86lHt6Zr2dVf8Pr6NvvArwXDeJ5DfxQDcYwQfYReKt1j7+UEZ5KlMMiNM2CNBBa/i4WYxH1ep4J4YvZ/8fDONx8HJWAoJZ18vRepQ0mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=0tTOQuJx; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="0tTOQuJx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783747182;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=bOM7KCX7007KsVYXLXCTImIaDuDeP372UurnpHiWcZk=;
 b=0tTOQuJxB2NDEY5fJreMvo89ZQFqTuNuj0LwiViWHpmr+WCBC9yEMwzj3Ewb7JwTAvE4MI
 MXYGNwxYP16orsa+gIg9RuxEIFpolSJ1ms2/eNH3GY2usAwrEiBHBzhP6u71WgvjJKlGHp
 rqAGr6OkFdhQXme6vXqTKO8eC0YhXWG2Ho6dHMXhgczpEjCnhKPKfmP0Iu4Um3fFzpZ6Pj
 qISnL+hIfOaSL5lekQ88IA1t3gEMar9B5eRtjdyucNsrtu13sZBwX7hk2H0MPHCGirLl/U
 yt6wsXyB8KiuQdfsUadC4MGjYjZRriNIF0vdBy/MoKzoOVioCSpAPu9itORXYQ==
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 2/3] btrfs: avoid NULL pointer dereference when raid stripe tree root is missing
Date: Sat, 11 Jul 2026 13:19:08 +0800
References: <20260711051909.1313584-1-zhudongjiang@fnnas.com>
To: <linux-btrfs@vger.kernel.org>
Cc: <dsterba@suse.com>
Received: from pdzhu.teiron-inc.cn ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 13:19:39 +0800
X-Lms-Return-Path: <lba+26a51d26c+0609e9+vger.kernel.org+zhudongjiang@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260711051909.1313584-1-zhudongjiang@fnnas.com>
X-Mailer: git-send-email 2.39.5
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Message-Id: <20260711051909.1313584-3-zhudongjiang@fnnas.com>

[BUG]
For a filesystem using the raid stripe tree feature, corrupting the raid
stripe tree root and mounting with rescue=ibadroots triggers the following
NULL pointer dereference:

  BTRFS warning (device loop1 state E): checksum verify failed on logical 30523392 mirror 1 wanted 0x74eeb205 found 0x9fa5ae1b level 0
  BTRFS warning (device loop1 state E): checksum verify failed on logical 30523392 mirror 2 wanted 0x74eeb205 found 0x9fa5ae1b level 0
  BUG: kernel NULL pointer dereference, address: 0000000000000100
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP NOPTI
  RIP: 0010:btrfs_update_global_block_rsv+0xb5/0x1c0 [btrfs]
  Call Trace:
   btrfs_read_block_groups+0x7d1/0xa10 [btrfs]
   open_ctree+0xc6e/0x1ca0 [btrfs]
   btrfs_get_tree+0x50d/0xa40 [btrfs]

[CAUSE]
With rescue=ibadroots, btrfs_read_roots() ignores a failure to read the
raid stripe tree root and leaves fs_info->stripe_root NULL.

After reading the block groups, btrfs_read_block_groups() initializes the
global block reserve.  btrfs_update_global_block_rsv() checks only the
RAID_STRIPE_TREE feature bit before dereferencing fs_info->stripe_root.

[FIX]
Check that the raid stripe tree root was successfully loaded before
accounting it in the global block reserve.  A missing root cannot
contribute to the reserve calculation, so skip both its size and minimum
item count.

This does not affect regular mounts, which fail earlier if the root cannot
be loaded.

Fixes: 515020900d44 ("btrfs: read raid stripe tree from disk")
Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
---
 fs/btrfs/block-rsv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index 647a065356f4..114342ef500c 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -353,7 +353,8 @@ void btrfs_update_global_block_rsv(struct btrfs_fs_info *fs_info)
 		min_items++;
 	}
 
-	if (btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE)) {
+	if (btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE) &&
+	    fs_info->stripe_root) {
 		num_bytes += btrfs_root_used(&fs_info->stripe_root->root_item);
 		min_items++;
 	}
-- 
2.39.5
