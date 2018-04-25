Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:35655 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750995AbeDYFIU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 01:08:20 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id E103F49F19DD
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 13:08:04 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2] btrfs-progs: do not merge tree block refs have different root_id
Date: Wed, 25 Apr 2018 13:13:49 +0800
Message-ID: <20180425051349.2639-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For an extent item which contains many tree block backrefs, like
=================================================================
In 020-extent-ref-cases/keyed_block_ref.img

item 10 key (29470720 METADATA_ITEM 0) itemoff 3450 itemsize 222
                refs 23 gen 10 flags TREE_BLOCK
                tree block skinny level 0
                tree block backref root 278
                tree block backref root 277
                tree block backref root 276
                tree block backref root 275
                tree block backref root 274
                tree block backref root 273
                tree block backref root 272
                tree block backref root 271
                tree block backref root 270
                tree block backref root 269
                tree block backref root 268
                tree block backref root 267
                tree block backref root 266
                tree block backref root 265
                tree block backref root 264
                tree block backref root 263
                tree block backref root 262
                tree block backref root 261
                tree block backref root 260
                tree block backref root 259
                tree block backref root 258
                tree block backref root 257
=================================================================
In find_parent_nodes(), these refs's parents are 0, then __merge_refs
will merge refs to one ref. It causes only one root to be returned.

So, if both parents are 0, do not merge refs.

Lowmem check calls find_parent_nodes frequently to decide whether
check an extent buffer or not. The bug influences bytes accounting.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
Changelog:
v2:
  Put judgment of ref->parent above comparison.
  Add the comment.
  Fix typos.
---
 backref.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/backref.c b/backref.c
index 51553c702187..d5772ec228c3 100644
--- a/backref.c
+++ b/backref.c
@@ -505,8 +505,15 @@ static void __merge_refs(struct pref_state *prefstate, int mode)
 				if (!ref_for_same_block(ref1, ref2))
 					continue;
 			} else {
+				/*
+				 * Parent == 0 means that the ref is tree block
+				 * backref or its parent is unresolved.
+				 */
+				if (!ref1->parent || !ref2->parent)
+					continue;
 				if (ref1->parent != ref2->parent)
 					continue;
+
 			}
 
 			eie = ref1->inode_list;
-- 
2.17.0



