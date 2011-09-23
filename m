From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] btrfs/compression.c: quiet sparse noise
Date: Fri, 23 Sep 2011 11:28:56 -0700
Message-ID: <201109231128.56757.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: <linux-btrfs@vger.kernel.org>, <chris.mason@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Quiet the sparse warning:

warning: symbol 'btrfs_compress_op' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Mason <chris.mason@oracle.com> 

---

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8ec5d86..3e8c133 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -726,7 +726,7 @@ static int comp_num_workspace[BTRFS_COMPRESS_TYPES];
 static atomic_t comp_alloc_workspace[BTRFS_COMPRESS_TYPES];
 static wait_queue_head_t comp_workspace_wait[BTRFS_COMPRESS_TYPES];
 
-struct btrfs_compress_op *btrfs_compress_op[] = {
+static struct btrfs_compress_op *btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
 };
