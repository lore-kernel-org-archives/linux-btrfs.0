Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46090 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752958AbeC0Rqb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 13:46:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2FA64AE03
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 17:46:30 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: lift errors from add_extent_changeset to the callers
Date: Tue, 27 Mar 2018 19:44:03 +0200
Message-Id: <20180327174403.3339-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The missing error handling in add_extent_changeset was hidden, so make
it at least visible in the callers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f27bad003f8e..f141d0fd7a65 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -119,23 +119,22 @@ struct extent_page_data {
 	unsigned int sync_io:1;
 };
 
-static void add_extent_changeset(struct extent_state *state, unsigned bits,
+static int add_extent_changeset(struct extent_state *state, unsigned bits,
 				 struct extent_changeset *changeset,
 				 int set)
 {
 	int ret;
 
 	if (!changeset)
-		return;
+		return 0;
 	if (set && (state->state & bits) == bits)
-		return;
+		return 0;
 	if (!set && (state->state & bits) == 0)
-		return;
+		return 0;
 	changeset->bytes_changed += state->end - state->start + 1;
 	ret = ulist_add(&changeset->range_changed, state->start, state->end,
 			GFP_ATOMIC);
-	/* ENOMEM */
-	BUG_ON(ret < 0);
+	return ret;
 }
 
 static void flush_write_bio(struct extent_page_data *epd);
@@ -527,6 +526,7 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 {
 	struct extent_state *next;
 	unsigned bits_to_clear = *bits & ~EXTENT_CTLBITS;
+	int ret;
 
 	if ((bits_to_clear & EXTENT_DIRTY) && (state->state & EXTENT_DIRTY)) {
 		u64 range = state->end - state->start + 1;
@@ -534,7 +534,8 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 		tree->dirty_bytes -= range;
 	}
 	clear_state_cb(tree, state, bits);
-	add_extent_changeset(state, bits_to_clear, changeset, 0);
+	ret = add_extent_changeset(state, bits_to_clear, changeset, 0);
+	BUG_ON(ret);
 	state->state &= ~bits_to_clear;
 	if (wake)
 		wake_up(&state->wq);
@@ -805,13 +806,15 @@ static void set_state_bits(struct extent_io_tree *tree,
 			   unsigned *bits, struct extent_changeset *changeset)
 {
 	unsigned bits_to_set = *bits & ~EXTENT_CTLBITS;
+	int ret;
 
 	set_state_cb(tree, state, bits);
 	if ((bits_to_set & EXTENT_DIRTY) && !(state->state & EXTENT_DIRTY)) {
 		u64 range = state->end - state->start + 1;
 		tree->dirty_bytes += range;
 	}
-	add_extent_changeset(state, bits_to_set, changeset, 1);
+	ret = add_extent_changeset(state, bits_to_set, changeset, 1);
+	BUG_ON(ret);
 	state->state |= bits_to_set;
 }
 
-- 
2.16.2

