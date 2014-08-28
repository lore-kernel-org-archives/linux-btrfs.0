Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23511 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934106AbaH1C0Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 22:26:25 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s7S2QHjW012071
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 10:26:18 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: fix len of read_extent_buffer for inline extent in restore
Date: Thu, 28 Aug 2014 10:25:53 +0800
Message-ID: <1409192755-1826-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
	# mkfs.btrfs -f <dev>
	# mount -o compress-force=lzo <dev> <mnt>
	# for ((i=0;i<4000;i++)); do
	  	echo -n 'A' >> <mnt>/inline_data
	  done
	# umount <mnt>
	# valgrind --tool=memcheck --leak-check=full	\
	  btrfs restore <dev> <dest_dir>
output:
	==32118== Invalid read of size 1
	==32118==    at 0x4A0A4E4: memcpy@@GLIBC_2.14
	==32118==    by 0x43DC91: read_extent_buffer
	==32118==    by 0x421401: search_dir (cmds-restore.c:240)
	==32118==    by 0x422CBB: cmd_restore (cmds-restore.c:1317)
	==32118==    by 0x404709: main (btrfs.c:248)
	==32118==  Address 0x4c4f4ac is not stack'd, malloc'd or...

It is because when deal with inline extent, the read_extent_buffer
is now reading a len of @ram_bytes which is the len of the uncompressed
data. But actually here we want the len of the inline item.
So in the compressed situation, use the len of the inline item.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index bb72311..e94592c 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -231,13 +231,15 @@ static int copy_one_inline(int fd, struct btrfs_path *path, u64 pos)
 	unsigned long ptr;
 	int ret;
 	int len;
+	int inline_item_len;
 	int compress;
 
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
 	ptr = btrfs_file_extent_inline_start(fi);
 	len = btrfs_file_extent_inline_len(leaf, path->slots[0], fi);
-	read_extent_buffer(leaf, buf, ptr, len);
+	inline_item_len = btrfs_file_extent_inline_item_len(leaf, btrfs_item_nr(path->slots[0]));
+	read_extent_buffer(leaf, buf, ptr, inline_item_len);
 
 	compress = btrfs_file_extent_compression(leaf, fi);
 	if (compress == BTRFS_COMPRESS_NONE) {
-- 
1.8.1.4

