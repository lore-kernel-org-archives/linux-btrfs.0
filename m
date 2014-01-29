Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47112 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaA2VGQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 16:06:16 -0500
Received: by mail-wg0-f50.google.com with SMTP id l18so4723477wgh.5
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 13:06:15 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, clm@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: use btrfs_crc32c everywhere instead of libcrc32c
Date: Wed, 29 Jan 2014 21:06:04 +0000
Message-Id: <1391029564-24160-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After the commit titled "Btrfs: fix btrfs boot when compiled as built-in",
LIBCRC32C requirement was removed from btrfs' Kconfig. This made it not
possible to build a kernel with btrfs enabled (either as module or built-in)
if libcrc32c is not enabled as well. So just replace all uses of libcrc32c
with the equivalent function in btrfs hash.h - btrfs_crc32c.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/check-integrity.c |    4 ++--
 fs/btrfs/disk-io.c         |    4 ++--
 fs/btrfs/send.c            |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 160fb50..39bfd56 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -92,11 +92,11 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/mutex.h>
-#include <linux/crc32c.h>
 #include <linux/genhd.h>
 #include <linux/blkdev.h>
 #include "ctree.h"
 #include "disk-io.h"
+#include "hash.h"
 #include "transaction.h"
 #include "extent_io.h"
 #include "volumes.h"
@@ -1823,7 +1823,7 @@ static int btrfsic_test_for_metadata(struct btrfsic_state *state,
 		size_t sublen = i ? PAGE_CACHE_SIZE :
 				    (PAGE_CACHE_SIZE - BTRFS_CSUM_SIZE);
 
-		crc = crc32c(crc, data, sublen);
+		crc = btrfs_crc32c(crc, data, sublen);
 	}
 	btrfs_csum_final(crc, csum);
 	if (memcmp(csum, h->csum, state->csum_size))
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7619147..3903bd3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -26,7 +26,6 @@
 #include <linux/workqueue.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
-#include <linux/crc32c.h>
 #include <linux/slab.h>
 #include <linux/migrate.h>
 #include <linux/ratelimit.h>
@@ -35,6 +34,7 @@
 #include <asm/unaligned.h>
 #include "ctree.h"
 #include "disk-io.h"
+#include "hash.h"
 #include "transaction.h"
 #include "btrfs_inode.h"
 #include "volumes.h"
@@ -244,7 +244,7 @@ out:
 
 u32 btrfs_csum_data(char *data, u32 seed, size_t len)
 {
-	return crc32c(seed, data, len);
+	return btrfs_crc32c(seed, data, len);
 }
 
 void btrfs_csum_final(u32 crc, char *result)
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 04c07ed..31b76d0 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -24,12 +24,12 @@
 #include <linux/xattr.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/radix-tree.h>
-#include <linux/crc32c.h>
 #include <linux/vmalloc.h>
 #include <linux/string.h>
 
 #include "send.h"
 #include "backref.h"
+#include "hash.h"
 #include "locking.h"
 #include "disk-io.h"
 #include "btrfs_inode.h"
@@ -620,7 +620,7 @@ static int send_cmd(struct send_ctx *sctx)
 	hdr->len = cpu_to_le32(sctx->send_size - sizeof(*hdr));
 	hdr->crc = 0;
 
-	crc = crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
+	crc = btrfs_crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
 	hdr->crc = cpu_to_le32(crc);
 
 	ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
-- 
1.7.9.5

