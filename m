Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:4663 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933016AbeGCHwf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 03:52:35 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 67EDA4B44480
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2018 15:52:30 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: lowmem: fix false alerts of referencer count mismatch for blocks relocated
Date: Tue, 3 Jul 2018 15:58:50 +0800
Message-ID: <20180703075851.8346-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs lowmem check reports such false alerts:
=========
ERROR: extent[1419709677568, 1703936] referencer count mismatch (root: 2192, owner: 327635, offset: 0) wanted: 9, have: 13
=========

While in extent tree, the extent has:
=========
        item 98 key (1419709677568 EXTENT_ITEM 1703936) itemoff 10745 itemsize 92
                refs 35 gen 16921 flags DATA
                extent data backref root 2192 objectid 327635 offset 0 count 9
                shared data backref parent 1232784752640 count 4
                shared data backref parent 1232784736256 count 13
                shared data backref parent 1232784719872 count 9
=========

The extent data 327635 starts in this leaf without BTRFS_HEADER_FLAG_RELOC:
=========
leaf 1471521390592 items 146 free space 3671 generation 18581 owner 2192
leaf 1471521390592 flags 0x1(WRITTEN) backref revision 1
...
 item 137 key (327635 EXTENT_DATA 0) itemoff 7745 itemsize 53
                generation 15770 type 1 (regular)
                extent data disk byte 1419709677568 nr 1703936
                extent data offset 0 nr 131072 ram 1703936
                extent compression 0 (none)
        item 138 key (327635 EXTENT_DATA 131072) itemoff 7692 itemsize 53
                generation 15770 type 1 (regular)
                extent data disk byte 1419709677568 nr 1703936
                extent data offset 131072 nr 131072 ram 1703936
                extent compression 0 (none)
...(Exactly 9 items here)
=========

The next leaf is flaged as relocated, so extent data backrefs are
shared not keyed:
=========
leaf 1232784752640 items 159 free space 2503 generation 16924 owner 2192
leaf 1232784752640 flags 0x3(WRITTEN|RELOC) backref revision 1
fs uuid 0f43f49d-6e63-4b1b-bc8c-c54da409872d
chunk uuid e558e6f7-4f08-4292-91fb-9a775fdd530b
        item 0 key (327635 EXTENT_DATA 1179648) itemoff 16230 itemsize 53
                generation 15770 type 1 (regular)
                extent data disk byte 1419709677568 nr 1703936
                extent data offset 1179648 nr 131072 ram 1703936
                extent compression 0 (none)
        item 1 key (327635 EXTENT_DATA 1310720) itemoff 16177 itemsize 53
                generation 15770 type 1 (regular)
                extent data disk byte 1419709677568 nr 1703936
                extent data offset 1310720 nr 131072 ram 1703936
                extent compression 0 (none)
        item 2 key (327635 EXTENT_DATA 1441792) itemoff 16124 itemsize 53
                generation 15770 type 1 (regular)
                extent data disk byte 1419709677568 nr 1703936
                extent data offset 1441792 nr 131072 ram 1703936
                extent compression 0 (none)
        item 3 key (327635 EXTENT_DATA 1572864) itemoff 16071 itemsize 53
=======

Lowmem mode starts to count extent data backrefs in first leaf, those
backrefs are keyed as wanted.
It calls btrfs_next_item to skip to next leaf.
However, the next leaf was relocated, extent data items in this leaf
should have shared backrefs shouldn't be counted.

So let lowmem mode do not count data backrefs if leaf is flaged with
BTRFS_HEADER_FLAG_RELOC.

Reported-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 66da45319053..d1d06f84bc75 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -3604,6 +3604,18 @@ static int check_extent_data_backref(struct btrfs_fs_info *fs_info,
 		if (slot >= btrfs_header_nritems(leaf) ||
 		    btrfs_header_owner(leaf) != root_id)
 			goto next;
+		/*
+		 * For tree blocks have been relocated, data backref are
+		 * shared instead of keyed. Do not account it.
+		 */
+		if (btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_RELOC)) {
+			/*
+			 * skip the leaf to speed up.
+			 */
+			slot = btrfs_header_nritems(leaf);
+			goto next;
+		}
+
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid != objectid ||
 		    key.type != BTRFS_EXTENT_DATA_KEY)
-- 
2.17.1



