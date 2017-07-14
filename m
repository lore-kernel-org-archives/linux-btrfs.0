Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23846 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750917AbdGNHpe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 03:45:34 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id D6A5A46B5249
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 15:45:30 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs-progs: check: verify name in dir_item for original mode
Date: Fri, 14 Jul 2017 15:47:44 +0800
Message-ID: <20170714074746.28177-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In original mode, we don't check if the name in dir_item matches the
hash in key.offset.

In the following case, original mode will report nothing wrong while
lowmem mode will detect the name and hash mismatch.

------
item 72 key (79177 DIR_ITEM 54846528) itemoff 12380 itemsize 88
        location key (4222342 INODE_ITEM 0) type FILE
        transid 170929 data_len 0 name_len 14
        name: deprecated.sxt
        location key (13590433 INODE_ITEM 0) type FILE
        transid 796448 data_len 0 name_len 14
        name: deprecated.txt
------
In above case, hash of "deprecated.txt" matches with 54846528,
while hash of "deprecated.sxt" should be 2008317993.

Reported-by: Filippe LeMarchand <gasinvein@gmail.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 23adc032..55afefbc 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1527,6 +1527,14 @@ static int process_dir_item(struct extent_buffer *eb,
 
 		read_extent_buffer(eb, namebuf, (unsigned long)(di + 1), len);
 
+		if (key->type == BTRFS_DIR_ITEM_KEY &&
+		    key->offset != btrfs_name_hash(namebuf, len)) {
+			rec->errors |= I_ERR_ODD_DIR_ITEM;
+			error("DIR_ITEM[%llu %llu] name %s namelen %u filetype %u mismatch with its hash, wanted %llu have %llu",
+			key->objectid, key->offset, namebuf, len, filetype,
+			key->offset, btrfs_name_hash(namebuf, len));
+		}
+
 		if (location.type == BTRFS_INODE_ITEM_KEY) {
 			add_inode_backref(inode_cache, location.objectid,
 					  key->objectid, key->offset, namebuf,
-- 
2.13.2



