Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:53370 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbdKMHfQ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 13 Nov 2017 02:35:16 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris@colorremedies.com
Subject: [PATCH 1/4] btrfs-progs: backref: Allow backref walk to handle direct parent ref
Date: Mon, 13 Nov 2017 15:34:50 +0800
Message-Id: <20171113073453.29198-2-wqu@suse.com>
In-Reply-To: <20171113073453.29198-1-wqu@suse.com>
References: <20171113073453.29198-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
Btrfs lowmem mode fails with the following ASSERT() on certain valid
image.
------
backref.c:466: __add_missing_keys: Assertion `ref->root_id` failed, value 0
------

[REASON]
Lowmem mode uses btrfs_find_all_roots() when walking down fs trees.

However if a tree block with only shared parent backref like below,
backref code from btrfs-progs doesn't handle it correct.
------
        item 72 key (604653731840 METADATA_ITEM 0) itemoff 13379 itemsize 60
                refs 4 gen 7198 flags TREE_BLOCK|FULL_BACKREF
                tree block skinny level 0
                shared block backref parent 604498477056
                shared block backref parent 604498460672
                shared block backref parent 604498444288
                shared block backref parent 604498411520
------

Such shared block ref is *direct* ref, which means we don't need to
solve its key, nor its rootid.

As the objective of backref walk is to find all direct parents until it
reaches tree root.
So for such direct ref, it should be pended to pref_stat->pending, other
than pending it to pref_stat->pending_missing_key.

[FIX]
For direct ref, pending it to pref_state->pending directly to solve the
problem.

Reported-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 backref.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/backref.c b/backref.c
index 8615f6b8677a..27309e07a1e9 100644
--- a/backref.c
+++ b/backref.c
@@ -206,6 +206,9 @@ static int __add_prelim_ref(struct pref_state *prefstate, u64 root_id,
 	if (key) {
 		ref->key_for_search = *key;
 		head = &prefstate->pending;
+	} else if (parent) {
+		memset(&ref->key_for_search, 0, sizeof(ref->key_for_search));
+		head = &prefstate->pending;
 	} else {
 		memset(&ref->key_for_search, 0, sizeof(ref->key_for_search));
 		head = &prefstate->pending_missing_keys;
-- 
2.15.0

