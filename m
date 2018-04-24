Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:58208 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756138AbeDXFq4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 01:46:56 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 938B349F19D1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 13:46:50 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: do not merge tree block refs have different root_id
Date: Tue, 24 Apr 2018 13:52:33 +0800
Message-ID: <20180424055233.6420-3-suy.fnst@cn.fujitsu.com>
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

Lowmem check calls find_parent_nodes frequently to decide whether.
check an extent buffer or not. These bug influences bytes accounting.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 backref.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/backref.c b/backref.c
index 51553c702187..daadb6299c79 100644
--- a/backref.c
+++ b/backref.c
@@ -507,6 +507,8 @@ static void __merge_refs(struct pref_state *prefstate, int mode)
 			} else {
 				if (ref1->parent != ref2->parent)
 					continue;
+				if (ref1->parent == 0)
+					continue;
 			}
 
 			eie = ref1->inode_list;
-- 
2.17.0



