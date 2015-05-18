Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:61359 "EHLO
	mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbbERRYi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 13:24:38 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2 linux-next] btrfs: use swap() in __merge_refs
Date: Mon, 18 May 2015 19:24:12 +0200
Message-Id: <1431969853-14700-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use kernel.h macro definition.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/backref.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 9de772e..01abe4c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -530,7 +530,6 @@ static void __merge_refs(struct list_head *head, int mode)
 		for (pos2 = pos1->next, n2 = pos2->next; pos2 != head;
 		     pos2 = n2, n2 = pos2->next) {
 			struct __prelim_ref *ref2;
-			struct __prelim_ref *xchg;
 			struct extent_inode_elem *eie;
 
 			ref2 = list_entry(pos2, struct __prelim_ref, list);
@@ -538,11 +537,8 @@ static void __merge_refs(struct list_head *head, int mode)
 			if (mode == 1) {
 				if (!ref_for_same_block(ref1, ref2))
 					continue;
-				if (!ref1->parent && ref2->parent) {
-					xchg = ref1;
-					ref1 = ref2;
-					ref2 = xchg;
-				}
+				if (!ref1->parent && ref2->parent)
+					swap(ref1, ref2);
 			} else {
 				if (ref1->parent != ref2->parent)
 					continue;
-- 
2.4.0

