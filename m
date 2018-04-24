Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42243 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756135AbeDXFq4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 01:46:56 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 00CCA49F19D2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 13:46:50 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: remove useless branch in __merge_refs
Date: Tue, 24 Apr 2018 13:52:32 +0800
Message-ID: <20180424055233.6420-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After call of ref_for_same_block, ref1->parent must equals to
ref2->parent, the block of exchange is never reached.

So remove the block of exchange.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 backref.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/backref.c b/backref.c
index c144dbf060f2..51553c702187 100644
--- a/backref.c
+++ b/backref.c
@@ -497,7 +497,6 @@ static void __merge_refs(struct pref_state *prefstate, int mode)
 		for (pos2 = pos1->next, n2 = pos2->next; pos2 != head;
 		     pos2 = n2, n2 = pos2->next) {
 			struct __prelim_ref *ref2;
-			struct __prelim_ref *xchg;
 			struct extent_inode_elem *eie;
 
 			ref2 = list_entry(pos2, struct __prelim_ref, list);
@@ -505,11 +504,6 @@ static void __merge_refs(struct pref_state *prefstate, int mode)
 			if (mode == 1) {
 				if (!ref_for_same_block(ref1, ref2))
 					continue;
-				if (!ref1->parent && ref2->parent) {
-					xchg = ref1;
-					ref1 = ref2;
-					ref2 = xchg;
-				}
 			} else {
 				if (ref1->parent != ref2->parent)
 					continue;
-- 
2.17.0



