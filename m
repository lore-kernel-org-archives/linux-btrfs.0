Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37502 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab3EGLRO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 07:17:14 -0400
Message-ID: <5188E3EF.3000807@cn.fujitsu.com>
Date: Tue, 07 May 2013 19:22:23 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Russell Coker <russell@coker.com.au>
Subject: [PATCH] Btrfs: fix compile warnings in i386 machine
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

See the warnings below:

   [CC]     btrfs-list.o
btrfs-list.c: In function 'filter_by_parent':
btrfs-list.c:1183:34: warning: cast to pointer from integer of different size
[-Wint-to-pointer-cast]
     [CC]     cmds-subvolume.o
cmds-subvolume.c: In function 'cmd_subvol_show':
cmds-subvolume.c:917:5: warning: cast from pointer to integer of different size
[-Wpointer-to-int-cast]
     [CC]     cmds-restore.o
cmds-restore.c: In function 'decompress_lzo':
cmds-restore.c:116:10: warning: passing argument 4 of 'lzo1x_decompress_safe'
from incompatible pointer type [enabled by default]
In file included from cmds-restore.c:31:0:
/usr/include/lzo/lzo1x.h:77:1: note: expected 'lzo_uint *' but argument is of
type 'size_t *'

Reported-by: Russell Coker <russell@coker.com.au>
Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 btrfs-list.c     |    2 +-
 cmds-restore.c   |    3 ++-
 cmds-subvolume.c |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index a748d5e..e4fc994 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1180,7 +1180,7 @@ static int filter_full_path(struct root_info *ri, u64 data)
 
 static int filter_by_parent(struct root_info *ri, u64 data)
 {
-	return !uuid_compare(ri->puuid, (u8 *)data);
+	return !uuid_compare(ri->puuid, (u8 *)(unsigned long)data);
 }
 
 static btrfs_list_filter_func all_filter_funcs[] = {
diff --git a/cmds-restore.c b/cmds-restore.c
index c75e187..3098f8d 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -113,7 +113,8 @@ static int decompress_lzo(unsigned char *inbuf, char *outbuf, u64 compress_len,
 
 		new_len = lzo1x_worst_compress(PAGE_CACHE_SIZE);
 		ret = lzo1x_decompress_safe((const unsigned char *)inbuf, in_len,
-					    (unsigned char *)outbuf, &new_len, NULL);
+					    (unsigned char *)outbuf,
+					    (void *)&new_len, NULL);
 		if (ret != LZO_E_OK) {
 			fprintf(stderr, "failed to inflate: %d\n", ret);
 			return -1;
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 74e2130..1bc7867 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -914,7 +914,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	printf("\tSnapshot(s):\n");
 	filter_set = btrfs_list_alloc_filter_set();
 	btrfs_list_setup_filter(&filter_set, BTRFS_LIST_FILTER_BY_PARENT,
-				(u64)get_ri.uuid);
+				(u64)(unsigned long)get_ri.uuid);
 	btrfs_list_setup_print_column(BTRFS_LIST_PATH);
 	btrfs_list_subvols_print(fd, filter_set, NULL, BTRFS_LIST_LAYOUT_RAW,
 			1, raw_prefix);
-- 
1.7.7.6






