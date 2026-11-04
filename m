Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787812;
	b=dNUEu6EOBGbxqBwt4HuY2lumt55lj/JFkJVL6GwQ4KiMcdwg8AFAo6daPCvsI7ER3d6R
	 j7HXhP3fevZfa0PkTkV43xXSnRxr3xNCBoJ2o/E04bywtM42A9eG0HtCkkNsd5llGKKa2
	 NMujOdgypv/9JmPLdd2yRtxIgKYtBCdJKraXRFcbP568S13YD/cw0gDuGkhZuhKfyGstg
	 4+OuJwQu1sXtjLVbQynWmjcag/S7dBHMJUBBmQlqoN4nPvBDgzDlIxQMpkHFa/6klh+fU
	 nzfciAimBKyudh1TFhyVjw9SMAz21f5ZvJk8YC5aCPxLxj/IYkGJfrJEpHq04oyN+1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787812;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m3d/wzGNwOwiGd7h6SwYhY1GxTniyAmLrkyjp/DieEQ=;
	b=2LTNiJNgrnQWsOdKM1kjTnNfq2q7rybEzJdC4+TnSSGA2ISz4N4+0wJE10bpKbgX0vJL
	 Rr4HJaTGRpoymvFmdAoZsSbILV5s6It/d4gRtzaGCswqfSoRhBqEjCzeIHqxsYZuHCQkH
	 90QX5BfZo9+RqL/7AIX3Zax4UDCpWYenu+IpCbbR+FcsXOddiiFXAt+18HsjIidKETPPz
	 o0atIAIxcrRzt3MZQIOQK8reESTQtYRii4Ex3ZeHd4uF6fvtTgRiVw1rHdDVm9dBgkEf6
	 16FjQy4XSwWLtmi2JYLY3wCCSATOesRJf6z76jps4w8nXipUJhpQynwViRmJkIfLwsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=Rw6J6PVY;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CAA606A33A
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 10:23:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98CAA606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=Rw6J6PVY
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3550c917fd3so730234eec.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 02:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793787811; x=1794392611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m3d/wzGNwOwiGd7h6SwYhY1GxTniyAmLrkyjp/DieEQ=;
        b=Rw6J6PVY5JuXf3efAuBwBkmOqE0fmQT6ehKVaHVqWMSFdzWr3DEFzWO6B/0eRMq08u
         ONefvo1rdhn7rgB995tA3v7K+u/xhWlegbSUAw2Gu4gEQh5+mu95QpX8EndSqFHSyagB
         I8liLFX5toT/OAMZGtwBx44EytCBpHrGkKFYd9PrUBnBddNrUt6nnlymi1akZ/XaFuUm
         o46JgYh/cpcE0isJGA0kdD0qoC2CtlECn2+4q53WBkC8T9QJoaT0W/ZPdpkRtZYouNJv
         Hmg/cjIfslmaOowC76NHERWGt85a7PTcSNE6nVvOeKDQJYb6Db2RCMZsQ7X4ApIptDCM
         rlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793787811; x=1794392611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m3d/wzGNwOwiGd7h6SwYhY1GxTniyAmLrkyjp/DieEQ=;
        b=AYzNclzeTxXFR0eYjIHL5c50JP8PnH4nswVk0upjRbDGEfHNdqSGVvhKWpvJbeDDVj
         3qaRulGl5szWDOsLIb1bAKclBBNui5OH99mHyf+xYxCSoNu/G+z4VurQHjiTqTAOEmHC
         SKELysCx9RIPObWNveuziLC+dRoW2T43jtTs+S6FU4iBRu0DAByHG6hdprBFbCOKz38j
         UoPG0pEteOJB5IoP47rCE7r+TPco3pWtozorze+cUwtZR2v3xMezP8Jm6EEZcmZ7L6uP
         pfCo46/qEl73SEb4LXfa0ZolQRG2qAyyLOnSMZa5LJoZo03vKUGUR2cEfH14ypIAjEYP
         sf0Q==
X-Forwarded-Encrypted: i=1; AKwUvBzJLzIH4FbdsocTN10hGDqvBWmaxIy27JgPpqsAtch5jItgxM/Ux7eym9aIxQxFpBX2ju4aebSP0Phn5Q==@vger.kernel.org
X-Gm-Message-State: APuU4Z86zXVVmsVMrCHT6Vjk/mx7H0pJ1DnPW7msZRjF39Rm9MLCk48X
	FHNufzG5khSpEinvxgKJfyUfrPXB9+fzRUXt0D4CoUA+gsvJ1FVrJvoiZznZCj7sSg==
X-Gm-Gg: AYBFou35P+20OE5KOfBNMnlXCksUTXrPWXArHvEiXl+I1L6PQGx0wDkwUSefhLAm9WX
	2xlgZ8RxGmYLV6ik0GgFE8cJtVBcyQRnVtbBSYhfeeHzLB8GiNm3XFiXGNgSw4+g2ZOD253JSc1
	hw4lHL03s5KdZBBbc05kYxroz+ol8mCtvYuH+MK1klh//oHeGmKirWCqaSGufV5S5zddaXyGvP5
	/HJ1t0Up30LhWb9g9uYn1zGAYX6kz27FbPyYuZ3O/5dpD8T0KxcR1Z3ZK8LYhTiDDZahst+HtEM
	Jd000ezHg6ED6FdFX/XhN+hPoxv6++4hxhn9ITxfw+CaB7GeNgRAI70VcMihHkFNHRmN5dnDVPi
	C9bhabo63doVKZlvJAx739VZu46Fk7ZX4FWE5UWNvOgLlxPpuzW0L3QYeA7Fx+5QVEq8efN3kg7
	Sk5wn9MB+8AmtsPfrXCykvPCIuLKNvDf5p/yVY8hNg9LsWPzofgWVbUZImYod/+9PGYGgmr3tb/
	W9LlyyWgmKX3XdProGswhot5Y8To5sqgT4ltZ+ScUFG+qyhYbPcgFyOf4QFVU2ok134jPPNXYhO
	jzqlCF9QQCkiqu1aHbq3qRbauebHN/kI1xc7rf6LVA==
X-Received: by 2002:a05:693c:88c8:20b0:369:f2d6:4108 with SMTP id 5a478bee46e88-36a42401233mr23215503eec.10.1793787810538;
        Wed, 04 Nov 2026 02:23:30 -0800 (PST)
Received: from localhost.localdomain ([2600:8800:1e00:25f0:ff01:97fc:f9e5:d7e1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a6160sm5749086eec.9.2026.11.04.02.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 02:23:29 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: dsterba@suse.com
Cc: wqu@suse.com,
	boris@bur.io,
	josef@toxicpanda.com,
	fdmanana@suse.com,
	mason@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>,
	stable@vger.kernel.org
Subject: [PATCH 1/5] btrfs: skip tree blocks in btrfs_get_extent_owner_root()
Date: Wed,  4 Nov 2026 03:23:19 -0700
Message-ID: <20261104102323.4090290-2-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104102323.4090290-1-smish149@asu.edu>
References: <20261104102323.4090290-1-smish149@asu.edu>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
With simple quotas enabled on a filesystem without the skinny-metadata
feature, deleting a subvolume triggers the following warning:

 ------------[ cut here ]------------
 WARNING: fs/btrfs/extent-tree.c:393 at
   btrfs_get_extent_inline_ref_type+0x1b9/0x2d0, CPU#1: btrfs-cleaner/84
 RIP: 0010:btrfs_get_extent_inline_ref_type (fs/btrfs/extent-tree.c:393)
 Call Trace:
  <TASK>
  btrfs_get_extent_owner_root (fs/btrfs/extent-tree.c:3128)
  btrfs_lookup_extent_info (fs/btrfs/extent-tree.c:187)
  walk_down_proc (fs/btrfs/extent-tree.c:5647)
  walk_down_tree (fs/btrfs/extent-tree.c:6170)
  btrfs_drop_snapshot (fs/btrfs/extent-tree.c:6392)
  btrfs_clean_one_deleted_snapshot (fs/btrfs/transaction.c:2728)
  cleaner_kthread (fs/btrfs/disk-io.c:1553)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:158)
  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
  </TASK>
 ---[ end trace 0000000000000000 ]---
 BTRFS error (device vda): eb 30720000 iref 0x3ee6 invalid extent
   inline ref type 0

Writing to a snapshot (update_ref_for_cow()) or a metadata balance
(relocate_block_group()) trigger the same warning.

[CAUSE]
Without skinny-metadata, the extent item of a tree block is an
EXTENT_ITEM with the TREE_BLOCK flag, and a btrfs_tree_block_info sits
between the btrfs_extent_item and the first inline ref:

	item 3 key (30441472 EXTENT_ITEM 16384) itemoff 16079 itemsize 51
		refs 1 gen 5 flags TREE_BLOCK
		tree block key (256 INODE_ITEM 0) level 0
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		(176 0x5) tree block backref root FS_TREE

But btrfs_get_extent_owner_root() always takes the first inline ref
right after the btrfs_extent_item:

	ptr = (unsigned long)(ei + 1);

So for such a tree block it reads the lowest byte of the first key
objectid as the inline ref type. For the key above that byte is 0, and
btrfs_get_extent_inline_ref_type() warns. If the byte happens to be
BTRFS_EXTENT_OWNER_REF_KEY (172), the key bytes are returned as the
owner root.

The filesystem is valid. It can be reproduced with:

  mkfs.btrfs -f -O ^skinny-metadata $dev
  mount $dev $mnt
  btrfs quota enable --simple $mnt
  btrfs subvolume create $mnt/sv
  btrfs subvolume delete $mnt/sv
  btrfs subvolume sync $mnt

[FIX]
Owner refs are only added to data extents, never to tree blocks, so
return 0 for an extent item with the TREE_BLOCK flag before looking at
its inline refs. This covers both the EXTENT_ITEM and the METADATA_ITEM
layouts, and gives the same result as on a skinny-metadata filesystem,
where the first inline ref of a tree block is never an owner ref.

Fixes: 8d2990914073 ("btrfs: add helper for inline owner ref lookup")
Cc: stable@vger.kernel.org # 6.7+
Signed-off-by: Siddharth Mishra <smish149@asu.edu>
---
 fs/btrfs/extent-tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9b0a5c6b9..3ab4f2696 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3117,6 +3117,9 @@ u64 btrfs_get_extent_owner_root(struct btrfs_fs_info *fs_info,
 		return 0;
 
 	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
+	if (btrfs_extent_flags(leaf, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK)
+		return 0;
+
 	ptr = (unsigned long)(ei + 1);
 	end = (unsigned long)ei + btrfs_item_size(leaf, slot);
 
-- 
2.54.0

