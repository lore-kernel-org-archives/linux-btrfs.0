Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35724 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933476AbcA1U2l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 15:28:41 -0500
Date: Thu, 28 Jan 2016 15:28:35 -0500
From: Dave Jones <dsj@fb.com>
To: Chris Mason <clm@fb.com>
CC: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
Subject: [v2] Re: btrfs: remove open-coded swap() in backref.c:__merge_refs
Message-ID: <20160128202834.GA31832@fb.com>
References: <20160128202556.GA31503@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160128202556.GA31503@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The kernel provides a swap() that does the same thing as this code.

Signed-off-by: Dave Jones <dsj@fb.com>

-- 
v2: Was swapping the same var. duh.

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index b90cd3776f8e..626bf6c12992 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -566,17 +566,14 @@ static void __merge_refs(struct list_head *head, int mode)
 		struct __prelim_ref *pos2 = pos1, *tmp;
 
 		list_for_each_entry_safe_continue(pos2, tmp, head, list) {
-			struct __prelim_ref *xchg, *ref1 = pos1, *ref2 = pos2;
+			struct __prelim_ref *ref1 = pos1, *ref2 = pos2;
 			struct extent_inode_elem *eie;
 
 			if (!ref_for_same_block(ref1, ref2))
 				continue;
 			if (mode == 1) {
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
