From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: CRC on disk printed correctly in CRC error message
Date: Fri, 02 Oct 2009 14:52:08 +0900
Message-ID: <4AC59508.6060309@jp.fujitsu.com>
References: <4AC59118.6030707@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AC59118.6030707@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


I've tested btrfsck in CRC error case. However CRC on disk printed
in error message is not correct (extent_buffer itsself is printed).


Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---
 disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index addebe1..190301f 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -86,7 +86,7 @@ int csum_tree_block_size(struct extent_buffer *buf, u16 csum_size,
 		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
 			printk("checksum verify failed on %llu wanted %X "
 			       "found %X\n", (unsigned long long)buf->start,
-			       *((int *)result), *((int *)buf));
+			       *((int *)result), *((int *)buf->data));
 			free(result);
 			return 1;
 		}
-- 
1.6.2.1


