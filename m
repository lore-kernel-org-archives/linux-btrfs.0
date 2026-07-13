Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D73A3CCFC0
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 08:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932647; cv=none; b=g1C+Jmtr8NdvUH4esb5vFvCZEFlGOhsshPgpNGFSj+rqFTNgOUFLfPd4zpQ/Lc6kfVAijFYoyteSi5kWaxshBzkaGmdCBVw4gzCFLbD/5DqU3YuYh+9RgYrcxpwFBKs0Nkl+XBqpVtY5i/+FGJyyS9BXyo1rElK0kSzXFRUQNyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932647; c=relaxed/simple;
	bh=aBK9ivLbr0IK9xPtDjsYfoEAdR0C5h5pbwyH2f1mKAQ=;
	h=Cc:From:Subject:Message-Id:References:In-Reply-To:Content-Type:To:
	 Date:Mime-Version; b=DDjXMuXa8Ii+pzwIVlaG8dmS0Oh68MnR/pLhzFO81SRFKmcrtFkZXfP3i4w6QD+hJyityn7TtThzwfoFLLc3fp1QUdvqaaF2MZqqp34IPpi8FNFX5h8AnIk8Sl24U9O6k1NeBKDlvhthcJL/8elpotS+rsy9RkxHF4OOBbuZgzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=o0X5getm; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="o0X5getm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783932638;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ap7HHhC+pOmheypECM3xVRuyypI6U8dNN4+7TmJAgz0=;
 b=o0X5getmGK2AA8FFkHf2qGsBLLEZ3wdY2c2JW+LmkrFFSxSGzuJe77ZT6Gu5PRNPtJFRIE
 NSyIggifSu+/GlSSHrnMKUUJFnhJuStix36pCueKhaoz7qFRYxdJwPLRSlT3Gn94aHyVXQ
 UkJcTUT35FtulazgQmQfPXjbV+LC7KztTy5I8jXuN+nNVtXApSYqONj9IKB+7DqNlKHEU9
 X/NQ5NowNbvCjhkAI3DzyCtctbsLdRZ64djHCyI0LvHin0eYtLRP/NTfX7PCArL4HW9GTM
 MoqHFj2XWDmmiE6QmyhdvZPQ6+GGaCpZJ35CK0G4zWif4H2U8/s41hrIDSInNg==
Content-Transfer-Encoding: 7bit
Received: from pdzhu.teiron-inc.cn ([183.34.174.151]) by smtp.feishu.cn with ESMTPS; Mon, 13 Jul 2026 16:50:35 +0800
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
Cc: <dsterba@suse.com>, <wqu@suse.com>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Subject: [PATCH v2 2/3] btrfs: skip global block reserve accounting for rescue mounts
Message-Id: <20260713085010.1123273-3-zhudongjiang@fnnas.com>
References: <20260713085010.1123273-1-zhudongjiang@fnnas.com>
In-Reply-To: <20260713085010.1123273-1-zhudongjiang@fnnas.com>
X-Lms-Return-Path: <lba+26a54a6dc+2fed8d+vger.kernel.org+zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
Date: Mon, 13 Jul 2026 16:50:09 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5

[BUG]
Mounting with rescue=ibadroots after corrupting the block group tree
root triggers a NULL pointer dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000100
  RIP: 0010:btrfs_update_global_block_rsv+0x9d/0x1c0 [btrfs]
  Call Trace:
   fill_dummy_bgs+0xd4/0x120 [btrfs]
   open_ctree+0xc6e/0x1ca0 [btrfs]
   btrfs_get_tree+0x50d/0xa40 [btrfs]

The same crash occurs with a corrupted raid stripe tree root, via
btrfs_read_block_groups() instead of fill_dummy_bgs().

[CAUSE]
With rescue=ibadroots, btrfs_read_roots() allows the mount to continue
when either root cannot be read, leaving the corresponding root pointer
NULL while its on-disk feature bit remains set.

btrfs_update_global_block_rsv() then dereferences the missing root based
on the feature bit alone.

[FIX]
Rescue mounts are fully read-only and cannot start transactions, so the
global reserve is never consumed. Under btrfs_is_full_ro(), mark the
reserve as full and return before performing the accounting.

Fixes: 8dbfc14fc736 ("btrfs: account block group tree when calculating global reserve size")
Fixes: 515020900d44 ("btrfs: read raid stripe tree from disk")
Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
---
 fs/btrfs/block-rsv.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index 9efb3016ef11..c68a8f4b7d19 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -322,10 +322,25 @@ void btrfs_block_rsv_add_bytes(struct btrfs_block_rsv *block_rsv,
 void btrfs_update_global_block_rsv(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
-	struct btrfs_space_info *sinfo = block_rsv->space_info;
+	struct btrfs_space_info *sinfo;
 	struct btrfs_root *root, *tmp;
-	u64 num_bytes = btrfs_root_used(&fs_info->tree_root->root_item);
 	unsigned int min_items = 1;
+	u64 num_bytes;
+
+	/*
+	 * A full read-only mount (rescue options) cannot start transactions,
+	 * so the global reserve is never consumed. Mark it as full and skip
+	 * the accounting.
+	 */
+	if (btrfs_is_full_ro(fs_info)) {
+		spin_lock(&block_rsv->lock);
+		block_rsv->full = true;
+		spin_unlock(&block_rsv->lock);
+		return;
+	}
+
+	sinfo = block_rsv->space_info;
+	num_bytes = btrfs_root_used(&fs_info->tree_root->root_item);
 
 	/*
 	 * The global block rsv is based on the size of the extent tree, the
-- 
2.39.5
