Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24544C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 12:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAE322077C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 12:02:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uBXJhH0D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAE322077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbeJLTfA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 15:35:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbeJLTfA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 15:35:00 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA2542077C
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539345772;
        bh=mawpfHn76NzF+02DxdWujdnmD9OexEutiUMbi4Gn5+Q=;
        h=From:To:Subject:Date:From;
        b=uBXJhH0DX4NpAwe6XOm3Nc/pto97t7FJaNPIMt03+xBJ/3SZH3Pp0B3SsKYZi0KuV
         AN3Kya2Hs8zcgUmScpre32BulPF9l9SrNgZQYPMpQQLM/xNNbS+gZ2dqUh/3Nhv+qW
         EqR9zMWvKBHiQooVqyiMQEgKThxa27M4FM9aSMhQ=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix use-after-free during inode eviction
Date:   Fri, 12 Oct 2018 13:02:48 +0100
Message-Id: <20181012120248.32262-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

At inode.c:evict_inode_truncate_pages(), when we iterate over the inode's
extent states, we access an extent state record's "state" field after we
unlocked the inode's io tree lock. This can lead to a use-after-free issue
because after we unlock the io tree that extent state record might have
been freed due to being merged into another adjacent extent state
record (a previous inflight bio for a read operation finished in the
meanwhile which unlocked a range in the io tree and cause a merge of
extent state records, as explained in the comment before the while loop
added in commit 6ca0709756710 ("Btrfs: fix hang during inode eviction due
to concurrent readahead")).

Fix this by keeping a copy of the extent state's flags in a local variable
and using it after unlocking the io tree.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201189
Fixes: b9d0b38928e2 ("btrfs: Add handler for invalidate page")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3ea5339603cf..66c6c4103d2f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5274,11 +5274,13 @@ static void evict_inode_truncate_pages(struct inode *inode)
 		struct extent_state *cached_state = NULL;
 		u64 start;
 		u64 end;
+		unsigned state_flags;
 
 		node = rb_first(&io_tree->state);
 		state = rb_entry(node, struct extent_state, rb_node);
 		start = state->start;
 		end = state->end;
+		state_flags = state->state;
 		spin_unlock(&io_tree->lock);
 
 		lock_extent_bits(io_tree, start, end, &cached_state);
@@ -5291,7 +5293,7 @@ static void evict_inode_truncate_pages(struct inode *inode)
 		 *
 		 * Note, end is the bytenr of last byte, so we need + 1 here.
 		 */
-		if (state->state & EXTENT_DELALLOC)
+		if (state_flags & EXTENT_DELALLOC)
 			btrfs_qgroup_free_data(inode, NULL, start, end - start + 1);
 
 		clear_extent_bit(io_tree, start, end,
-- 
2.11.0

