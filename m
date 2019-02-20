Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E6AC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 11:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A3242086C
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 11:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550661112;
	bh=3rV+buSaEFwlQoPbHibgW/Z6q0ky6poAL82FuMeOEGA=;
	h=From:To:Subject:Date:List-ID:From;
	b=vnExMEP+EDDPtLLp4jgD7EdBI8HZdqHqZP8fmy57eAlUeRgcSFJIa+72doOkoW06i
	 CXbw76JQCHUxY0DNJrw4H9PpJh+2D3go4rY3qBusvsKy+1mHk4hgIGqaX1c0o4BxM8
	 4nIijanAz4p7rohY6bFywKXFEI/IqyqnTvojxy/4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbfBTLLu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:11:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfBTLLu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 06:11:50 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 696102086C
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2019 11:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550661109;
        bh=3rV+buSaEFwlQoPbHibgW/Z6q0ky6poAL82FuMeOEGA=;
        h=From:To:Subject:Date:From;
        b=vEAqqgudD65PRnKSPsgJQTFzVm5QCgZCNRUuwwq2DDBWm14UkATnPUIZ2OPUn65+f
         H9ucR2IxvU44RIF+pMZeI+wcQWziIVaCQCybKH0qiyhg9l3XgPs2VRNao+FsxtfVn0
         cWEFper/zWXZVwISXAa/GAEgLRxrvUymxdaf6kYo=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove assertion when searching for a key in a node/leaf
Date:   Wed, 20 Feb 2019 11:11:43 +0000
Message-Id: <20190220111143.15911-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

At ctree.c:key_search(), the assertion that verifies the first key on a
child extent buffer corresponds to the key at a specific slot in the
parent has a disadvantage: we effectively hit a BUG_ON() which requires
rebooting the machine later. It also does not tell any information about
which extent buffer is affected, from which root, the expected and found
keys, etc.

However as of commit 581c1760415c48 ("btrfs: Validate child tree block's
level and first key"), that assertion is not needed since at the time we
read an extent buffer from disk we validate that its first key matches the
key, at the respective slot, in the parent extent buffer. Therefore just
remove the assertion at key_search().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5b9f602fb9e2..e754bd019618 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2529,26 +2529,6 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void key_search_validate(struct extent_buffer *b,
-				const struct btrfs_key *key,
-				int level)
-{
-#ifdef CONFIG_BTRFS_ASSERT
-	struct btrfs_disk_key disk_key;
-
-	btrfs_cpu_key_to_disk(&disk_key, key);
-
-	if (level == 0)
-		ASSERT(!memcmp_extent_buffer(b, &disk_key,
-		    offsetof(struct btrfs_leaf, items[0].key),
-		    sizeof(disk_key)));
-	else
-		ASSERT(!memcmp_extent_buffer(b, &disk_key,
-		    offsetof(struct btrfs_node, ptrs[0].key),
-		    sizeof(disk_key)));
-#endif
-}
-
 static int key_search(struct extent_buffer *b, const struct btrfs_key *key,
 		      int level, int *prev_cmp, int *slot)
 {
@@ -2557,7 +2537,6 @@ static int key_search(struct extent_buffer *b, const struct btrfs_key *key,
 		return *prev_cmp;
 	}
 
-	key_search_validate(b, key, level);
 	*slot = 0;
 
 	return 0;
-- 
2.11.0

