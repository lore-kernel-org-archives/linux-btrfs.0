Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B4C331A63
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 10:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773310963; cv=none; b=BOl3o7mVUyFrrhXgHQpOo38YizpqpNUc/q6tkZXDgvJjm2bImYXwRxho1tVQfKU4ysGxcdrNnPOL2KzxwFAIQhg5VS7JrjTHXc2iZXttMZcjx1hmEZoGgIgTJzgY7Kk5w4k5oY+yAUvaEmq0QRH1bwyrJwiPkL60+MNm3xDcsHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773310963; c=relaxed/simple;
	bh=UQ8eTy3O54/yQDmZQ53filNsXiiPrqRjxEEESeSEOsU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C4CK+CjfbVZQxNsCAQQ1aGbKx2IuLDmyWW260Ybv1YFCTjw10zAhLDZalimsgPUNzO1+YubpcjTVPs1FiJN9h3at8pZu9fbTvY4a3P46fmEdjrmAsAGVMPxX6HqG2GZzEmGJ+GycMOgJKxQxBjdTAPboTRB6eLzi/EZo85C9278=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QT0n3ZmA; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QT0n3ZmA"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ae4988e039so13520855ad.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 03:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773310961; x=1773915761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qJUHIhc2weYpVFeAG0o1aQbqOU671Mp2foYGXrmt/ak=;
        b=QT0n3ZmAZcT+ovwZyvEmGBL5ftbwIkm9oYx2AAXImc/F01O4hqqhlm+OaG5ywWmrOr
         vx1JoO/6AniXKXL9N35QW2S8N3CDPaDLpou+ce62dRCCOeC56dWF1FVcSqIw9BIll9mB
         OgliTpTcedjvm1WgT1IFlzlQCXMubqsrLHfOYKQtyDuRWExnBJ0wT3iDvfGTGbbvDtjm
         bA8FuwUmV8yVCZdVjoOiCPnuWw81zgE+qGShFDNfC84JG3F0HDFOr2Jm2xmBbGJeq5AF
         1PD/gJOIn9pe2783sgoAaFcmlqUTU00KwooVBKCWhUHxURAo4VajYVUPPM9nBMsmwo6k
         KRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773310961; x=1773915761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJUHIhc2weYpVFeAG0o1aQbqOU671Mp2foYGXrmt/ak=;
        b=tG/HuCySsH6h8FfaOpWWBu/kUScAYtfCr4t+rXwL91i9y0NkQ2SEaSZAS+wPgIiErp
         n0JWvY7JACuSEc4zmxOpdtV63N7zYQoGCRwPYQxm5+YbgHj3WJ8YuraBFE2GuQD21Z65
         cNnwh7YDPq8ZzmLA2wXMBU5qns5UazNotfwK6AxWn0ZQ50/mgPqYMUnUKBArdd+XTYB5
         17Im+SYVP3V9mT+75tGhchwrcQD1pDA3tlZ2VVsu2UYsMSpw1bYrLh9xoew0rNHBTkKJ
         2ni9hy2k/BXKld9VaMbQvsRtaEb+++P2QZKdItKuiOhJ5cRAw3SigAX2iBa8Kmn7iKx3
         OP2g==
X-Gm-Message-State: AOJu0YxDPo/sHsNbruZTanmQOzumjjH33XyLJ84eByonu7W1hRwc/DWs
	2nISFiBa+ykvgmVfgmrn9tXC4/WD/xesMhlD1qAwLpIefiRnclBvsa/j
X-Gm-Gg: ATEYQzxDEpjjcobfPTc+UZ3HWqktB5M9jDTrSEpeyf7wrVPJHC16OBm1HuyTOCXiPA7
	WGIb5TBOb0uMwqEu06Tm7IgjWDbJ1k9+Kaq25m5Gw9bxNUr3xOwYutotLu75LXFxfuzRiQN7gZW
	IAyQ71QpiAhn6+WJLw7zD3i5zj02H09DHxDcnE7O9FJqKvPg/deYorCpVCYz4tMtcVHEXGDJ2ph
	2u6rm8B9Lm2DvDep4pZ1NH8+09V5scU5OIgh+ltEHf390uYDtHR+Hpu6J+xoAsXTcgXSV9m2jVZ
	/0Z6dz/wHJggn6Z5xZSZcQuhmwplUGMLJ/O7/7/UoMM9KL7C56fBUwVeXk8If8Tez2TQehVGsL0
	xBTx3I3so0yktmKNok2RFiiHPvYmlz0gVq3CRq3FV9tSlHZcAyE81umzmbJW5bt6HhAJsVVNfV8
	9LA/qrKMXvByN4f3hDYK8Xk7Vw5f7tr12G7Mu54hAMHToNQ4Mv/7TDPpum97EHUaf+FSMpheM=
X-Received: by 2002:a17:903:37c4:b0:2ae:7f85:33d1 with SMTP id d9443c01a7336-2aeba2e60d8mr28067915ad.0.1773310961125;
        Thu, 12 Mar 2026 03:22:41 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.183.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae260ea3sm52828275ad.39.2026.03.12.03.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 03:22:40 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: reject root with mismatched level between root_item and node header
Date: Thu, 12 Mar 2026 18:22:29 +0800
Message-ID: <20260312102229.220570-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A KASAN null-ptr-deref is triggered when running balance on a filesystem
with a corrupted root item:

  KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
  CPU: 1 UID: 0 PID: 347 ... Tainted: G OE  6.18.0+ #17 PREEMPT(voluntary)
  Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
  Hardware name: QEMU Ubuntu 24.04 BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  RIP: 0010:get_eb_folio_index fs/btrfs/extent_io.h:180 [inline]
  RIP: 0010:btrfs_get_64+0x91/0x590 fs/btrfs/accessors.c:117
  Code: 400400f3 f3f36548 8b056324 31054889
  Call Trace:
   btrfs_key_blockptr fs/btrfs/accessors.h:368 [inline]
   btrfs_node_blockptr fs/btrfs/accessors.h:380 [inline]
   handle_indirect_tree_backref fs/btrfs/backref.c:3324 [inline]
   btrfs_backref_add_tree_node+0x7a5/0x26a0 fs/btrfs/backref.c:3538
   build_backref_tree+0x11c/0xb00 fs/btrfs/relocation.c:437
   relocate_tree_blocks+0x583/0x1a30 fs/btrfs/relocation.c:2649
   relocate_block_group+0x521/0xf60 fs/btrfs/relocation.c:3584
   btrfs_relocate_block_group+0x4d8/0xde0 fs/btrfs/relocation.c:3984
   btrfs_relocate_chunk+0x133/0x620 fs/btrfs/volumes.c:3451
   __btrfs_balance fs/btrfs/volumes.c:4227 [inline]
   btrfs_balance+0x1e8b/0x42b0 fs/btrfs/volumes.c:4604
   btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
   btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
   ...
  RIP: 0033:0x7bbaa73a75ad
  Code: ffc3662e 0f1f8400 00000000 90f30f1e fa4889f8

The bug is reproducible on 7.0.0-rc2-next-20260311 with our dynamic
metadata fuzzing tool that corrupts btrfs metadata at runtime.

[CAUSE]
The corruption consists of a single corrupted field in a root tree leaf:
the btrfs_root_item for the affected tree has its .level field set to 1,
while the actual root block on disk has header.level = 0. The root block
itself is completely intact; only the field value stored inside the root
tree leaf is wrong. The existing tree-checker validation in
check_root_item() accepts this because it only verifies that
root_item.level < BTRFS_MAX_LEVEL, and does not cross-check the value
against the root block's own header.

The inconsistency becomes dangerous when balance calls
relocate_tree_blocks() to move a level-0 block belonging to that tree.
relocate_tree_blocks() has two sequential phases that together set the
trap:

Phase 1 -- get_tree_block_key(): reads the root block to retrieve its first
key before building the backref tree. The check level passed to
read_tree_block() here comes from the EXTENT_ITEM in the extent tree, which
correctly records level 0. The disk I/O completes,
btrfs_validate_extent_buffer() sees found_level(0) == check->level(0), and
marks the extent_buffer EXTENT_BUFFER_UPTODATE.

Phase 2 -- build_backref_tree() calls handle_indirect_tree_backref(), which
calls btrfs_get_fs_root() to open the affected tree. Inside
read_tree_root_path(), level is set from btrfs_root_level(&root->root_item),
yielding the corrupted value 1. read_tree_block() is then called with
check.level = 1 for the same bytenr. Because EXTENT_BUFFER_UPTODATE is
already set from Phase 1, read_extent_buffer_pages_nowait() returns
immediately via the cache fast path, skipping
btrfs_validate_extent_buffer() entirely. read_tree_root_path() has no
cross-check between btrfs_header_level(root->node) and the level read from
root_item, so it silently builds a btrfs_root with root_item.level = 1 and
commit_root whose btrfs_header_level() is 0 and installs it in the
fs_roots radix tree.

Back in handle_indirect_tree_backref(), btrfs_root_level(&root->root_item)
returns 1, which does not equal cur->level(0), so the tree-root early-exit
is skipped and path->lowest_level is set to 1.
btrfs_search_slot_get_root() starts at commit_root (level 0), records it in
p->nodes[0], and returns immediately because it is already a leaf --
p->nodes[1] is never assigned and retains its kzalloc-zeroed NULL value.
eb = path->nodes[1] = NULL is then passed directly to
btrfs_node_blockptr(), which calls btrfs_get_64() and then
get_eb_folio_index(), where eb->folio_shift is dereferenced through the
NULL pointer, causing the crash.

Note that the subsequent for() loop in handle_indirect_tree_backref()
already checks for a NULL path->nodes[level] correctly; the initial
blockptr comparison just above it was never given the same guard.

[FIX]
Catch the inconsistency in read_tree_root_path(), right after read_tree_block()
returns root->node and the generation and owner checks have passed. At that
point level = btrfs_root_level(&root->root_item) is already known, so
comparing it against btrfs_header_level(root->node) costs nothing. If they
differ, emit a btrfs_crit() message and return -EUCLEAN to prevent the
inconsistent btrfs_root object from being installed in the radix-tree cache
and reaching any caller. read_tree_root_path() is the only place that sees
both root_item.level and the actual root node simultaneously, making it the
correct and minimal location for this cross-block consistency check.
Returning -EUCLEAN is consistent with the existing owner-mismatch check
directly above and with the general btrfs policy of converting detectable
corruption into -EUCLEAN rather than crashing later.

After the fix, btrfs detects the level mismatch at root load time and
fails with -EUCLEAN instead of crashing later in
handle_indirect_tree_backref().

Cc: stable@vger.kernel.org
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/btrfs/disk-io.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 900e462d8ea1..06a8689cbf62 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1067,6 +1067,26 @@ static struct btrfs_root *read_tree_root_path(struct btrfs_root *tree_root,
 		ret = -EUCLEAN;
 		goto fail;
 	}
+	/*
+	 * Verify that the root node's on-disk level matches root_item.level.
+	 * These can diverge when the root item in the root tree was corrupted
+	 * (e.g. a bit flip changing level) while the actual tree block is
+	 * already cached in memory at its real level. In that case
+	 * read_tree_block() returns the cached buffer without re-running
+	 * btrfs_validate_extent_buffer(), silently bypassing the level check.
+	 * The mismatch would later cause a null-ptr-deref in backref walking
+	 * (handle_indirect_tree_backref) when the commit root's real height is
+	 * lower than what root_item.level claims.
+	 */
+	if (unlikely(btrfs_header_level(root->node) != level)) {
+		btrfs_crit(fs_info,
+           "root=%llu block=%llu, root item level mismatch: "
+           "root_item.level=%d block.level=%u",
+           btrfs_root_id(root), root->node->start,
+           level, btrfs_header_level(root->node));
+		ret = -EUCLEAN;
+		goto fail;
+	}
 	root->commit_root = btrfs_root_node(root);
 	return root;
 fail:
-- 
2.43.0

