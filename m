Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF97C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 09:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8527220811
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 09:40:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="BfT8hxPo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfC1Jkz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 05:40:55 -0400
Received: from mail.synology.com ([211.23.38.101]:49897 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbfC1Jkz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 05:40:55 -0400
Received: from localhost.localdomain (unknown [10.17.32.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 2D07D188206A3;
        Thu, 28 Mar 2019 17:40:52 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1553766052; bh=cSrxZ+qOWjJKfddkJCl2d9+V0AlMe9v0oa4LvwmF+kY=;
        h=From:To:Cc:Subject:Date;
        b=BfT8hxPonTVY3lNNJ+EGLsL1XHQ/wUbM3vM3cExEjxTU+1cu7E6fh1uOhf3mK9LwV
         6PD1goHZnbDyTymdFBjupsiX6kkm0BCdmb4tQKFc38Bv4EC4RxYxctGAgTkJL/U8vl
         cft3UiuPtGl3Fr0n/Ve9Pa2qSHCOaHkkYgEYR/v0=
From:   robbieko <robbieko@synology.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: send, improve clone range
Date:   Thu, 28 Mar 2019 17:40:36 +0800
Message-Id: <1553766036-20689-1-git-send-email-robbieko@synology.com>
X-Mailer: git-send-email 1.9.1
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

Improve clone_range two use scenarios.

1. Remove the limit of clone inode size
We can do partial clone range, so there is no need to limit
the inode size.

2. In the scenarios of rewrite or clone_range, data_offset
rarely matches exactly, so the chance of a clone is missed.

e.g.
    1. Write a 1M file
        dd if=/dev/zero of=1M bs=1M count=1

    2. Clone 1M file
       cp --reflink 1M clone

    3. Rewrite 4k on the clone file
       dd if=/dev/zero of=clone bs=4k count=1 conv=notrunc

    The disk layout is as follows:
    item 16 key (257 EXTENT_DATA 0) itemoff 15353 itemsize 53
	extent data disk byte 1103101952 nr 1048576
	extent data offset 0 nr 1048576 ram 1048576
	extent compression(none)
    ...
    item 22 key (258 EXTENT_DATA 0) itemoff 14959 itemsize 53
	extent data disk byte 1104150528 nr 4096
	extent data offset 0 nr 4096 ram 4096
	extent compression(none)
    item 23 key (258 EXTENT_DATA 4096) itemoff 14906 itemsize 53
	extent data disk byte 1103101952 nr 1048576
	extent data offset 4096 nr 1044480 ram 1048576
	extent compression(none)

When send, inode 258 file offset 4096~1048576 (item 23) has a
chance to clone_range, but because data_offset does not match
inode 257 (item 16), it causes missed clone and can only transfer
actual data.

Improve the problem by judging whether the current data_offset
has overlap with the file extent item, and if so, adjusting
offset and extent_len so that we can clone correctly.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 7ea2d6b..7766b12 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1240,9 +1240,6 @@ static int __iterate_backrefs(u64 ino, u64 offset, u64 root, void *ctx_)
 	if (ret < 0)
 		return ret;
 
-	if (offset + bctx->data_offset + bctx->extent_len > i_size)
-		return 0;
-
 	/*
 	 * Make sure we don't consider clones from send_root that are
 	 * behind the current inode/offset.
@@ -5148,6 +5145,7 @@ static int clone_range(struct send_ctx *sctx,
 		u8 type;
 		u64 ext_len;
 		u64 clone_len;
+		u64 clone_data_offset;
 
 		if (slot >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(clone_root->root, path);
@@ -5201,10 +5199,24 @@ static int clone_range(struct send_ctx *sctx,
 		if (key.offset >= clone_root->offset + len)
 			break;
 
+		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte) {
+			clone_root->offset = key.offset;
+			clone_data_offset = btrfs_file_extent_offset(leaf, ei);
+			if (clone_data_offset < data_offset &&
+				clone_data_offset + ext_len > data_offset) {
+				u64 extent_offset;
+
+				extent_offset = data_offset - clone_data_offset;
+				ext_len -= extent_offset;
+				clone_data_offset += extent_offset;
+				clone_root->offset += extent_offset;
+			}
+		}
+
 		clone_len = min_t(u64, ext_len, len);
 
 		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte &&
-		    btrfs_file_extent_offset(leaf, ei) == data_offset)
+		    clone_data_offset == data_offset)
 			ret = send_clone(sctx, offset, clone_len, clone_root);
 		else
 			ret = send_extent_data(sctx, offset, clone_len);
-- 
1.9.1

