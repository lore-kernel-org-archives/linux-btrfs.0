Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab3EFWCA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 18:02:00 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 8E559A4EB7
	for <linux-btrfs@vger.kernel.org>; Tue,  7 May 2013 00:01:59 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fix typecast when printing csum value
Date: Tue,  7 May 2013 00:01:51 +0200
Message-Id: <1367877711-21341-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Only the first byte of the wanted csum is printed:

checksum verify failed on 65536 found DA97CF61 wanted 6B
checksum verify failed on 65536 found DA97CF61 wanted 6BC3870D

Also add leading zeros to the format.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 disk-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index b001e35..21b410d 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -89,9 +89,9 @@ int csum_tree_block_size(struct extent_buffer *buf, u16 csum_size,
 
 	if (verify) {
 		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
-			printk("checksum verify failed on %llu found %X "
-			       "wanted %X\n", (unsigned long long)buf->start,
-			       *((int *)result), *((char *)buf->data));
+			printk("checksum verify failed on %llu found %08X "
+			       "wanted %08X\n", (unsigned long long)buf->start,
+			       *((u32 *)result), *((u32*)(char *)buf->data));
 			free(result);
 			return 1;
 		}
-- 
1.8.2

