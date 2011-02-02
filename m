From: Alexey Charkov <alchark@gmail.com>
Subject: [PATCH] btrfs: Drop __exit attribute on btrfs_exit_compress
Date: Thu, 3 Feb 2011 00:15:35 +0300
Message-ID: <20110202211535.GA13028@alchark-u3s>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As this function is called in some error paths while not
removing the module, the __exit attribute prevents the kernel
image from linking when btrfs is compiled in statically.

Signed-off-by: Alexey Charkov <alchark@gmail.com>

---
I am not completely sure whether this has already been reported,
but googling around did not show any traces.

Best regards,
Alexey

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index f745287..db36b5e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -900,7 +900,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 	return ret;
 }
 
-void __exit btrfs_exit_compress(void)
+void btrfs_exit_compress(void)
 {
 	free_workspaces();
 }
