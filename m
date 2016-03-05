Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:36414 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbcCEWjf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 17:39:35 -0500
Received: from freie.home (home.lxoliva.fsfla.org [172.31.160.22])
	by linux-libre.fsfla.org (8.14.4/8.14.4/Debian-4.1ubuntu1) with ESMTP id u25MdSfw020924
	for <linux-btrfs@vger.kernel.org>; Sat, 5 Mar 2016 22:39:29 GMT
From: Alexandre Oliva <oliva@gnu.org>
To: linux-btrfs@vger.kernel.org
Subject: [check] set metadata extent size of tree block extents
Date: Sat, 05 Mar 2016 19:39:06 -0300
Message-ID: <orpov8pn1x.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When scanning extents, we didn't set num_bytes when visiting a tree
block extent.  On the corrupted filesystem I was trying to fix, this
caused an extent to have its size guessed as zero, so we'd compute end
as start-1, which caused us to hit insert_state's BUG_ON(end<start).

Signed-off-by: Alexandre Oliva <oliva@gnu.org>
---
 cmds-check.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 0165fba..e563354 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5208,9 +5208,10 @@ static int process_extent_item(struct btrfs_root *root,
 
 	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
 	refs = btrfs_extent_refs(eb, ei);
-	if (btrfs_extent_flags(eb, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK)
+	if (btrfs_extent_flags(eb, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		metadata = 1;
-	else
+		num_bytes = root->leafsize;
+	} else
 		metadata = 0;
 
 	add_extent_rec(extent_cache, NULL, 0, key.objectid, num_bytes,

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist|Red Hat Brasil GNU Toolchain Engineer
