Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A4BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 16:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E91B2217D9
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 16:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550509113;
	bh=tYoBjZ88Er6kjw7d8Zy9+mgR8Lhr6r0h7dMWYr3k4nM=;
	h=From:To:Subject:Date:List-ID:From;
	b=soivSuXYiWpNgkHEu9hicclb5tFeO/VF27NOsHqcJ2wRud0WqckaOpeiE7ALS3zBP
	 kphLb4TQEA59K08wboZXpFV1iX7h7uJdYdB7vJ6BqsizfN4Tu7j+Hgfd9evmOAIr0G
	 r6cOr/GJ+TrYtVz7MBc6/CLRm/qpblRfJ+HXen+w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390667AbfBRQ6b (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 11:58:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733096AbfBRQ6a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 11:58:30 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6187F217D9
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 16:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550509109;
        bh=tYoBjZ88Er6kjw7d8Zy9+mgR8Lhr6r0h7dMWYr3k4nM=;
        h=From:To:Subject:Date:From;
        b=nlZ6XfkP1lfkpidRWwxBiHSWmPvMqAP4Y5sY+rkufRo+ZoBbHZf41Sb8Jevgnfmmx
         q13IT7AjtwXp6LOa2powO0GDKiMElcHjM6zoaIh+3peuI0QTVPcn5QINEKHJ5uu8Cn
         yEXfQYNRfYJkqr6020v2s7U43Xc/sEfMBZQsy2v4=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: report and handle error on unexpected first key on extent buffer
Date:   Mon, 18 Feb 2019 16:58:26 +0000
Message-Id: <20190218165826.23549-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When there is a kind of corruption in an extent buffer such that its first
key does not match the key at the respective parent slot, one of two things
happens:

1) When assertions are enabled, we effectively hit a BUG_ON() which
   requires rebooting the machine later. This also does not tell any
   information about which extent buffer is affected, from which root,
   the expected and found keys, etc.

2) When assertions are disabled, we just ignore the mismatch and assume
   everything is ok, which can potentially lead to all sorts of unexpected
   problems later after a tree search (in the worst case, could lead to
   further silent corruption).

So improve this by always checking if the first key of an extent buffer is
what it's supposed to be, when doing a key search at key_search(), and
report and return an appropriate error. The overhead is just comparing one
key, which is minimal and is anyway just done in a special case where we
skip the more expensive binary search (the binary search in the parent
node returned 0, exact key match).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5b9f602fb9e2..a0bd0278208d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2529,35 +2529,31 @@ setup_nodes_for_search(struct btrfs_trans_handle *trans,
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
+	struct btrfs_key found_key;
+
 	if (*prev_cmp != 0) {
 		*prev_cmp = btrfs_bin_search(b, key, level, slot);
 		return *prev_cmp;
 	}
 
-	key_search_validate(b, key, level);
+	if (level == 0)
+		btrfs_item_key_to_cpu(b, &found_key, 0);
+	else
+		btrfs_node_key_to_cpu(b, &found_key, 0);
+
+	if (btrfs_comp_cpu_keys(&found_key, key) != 0) {
+		btrfs_crit(b->fs_info,
+"unexpected first key for extent buffer: bytenr=%llu level=%d root=%llu expected key=(%llu %u %llu) found key=(%llu %u %llu)",
+			   btrfs_header_bytenr(b), level, btrfs_header_owner(b),
+			   key->objectid, key->type, key->offset,
+			   found_key.objectid, found_key.type,
+			   found_key.offset);
+		return -EUCLEAN;
+	}
+
 	*slot = 0;
 
 	return 0;
-- 
2.11.0

