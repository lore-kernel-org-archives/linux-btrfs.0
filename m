From: Jan Engelhardt <jengelh@medozas.de>
Subject: (patch) Mention minimum size on devices that are considered too
 small
Date: Tue, 13 Jan 2009 13:57:14 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901131356320.21439@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


parent 6fc10e9fe39410ed606506584e3a07fd21dc1e6b (v0.17)
commit 2d8f3f201d0236ca76dcac3526f0355aec1f8cff
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 13 13:57:17 2009 +0100

Mention minimum size on devices that are considered too small

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 utils.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/utils.c b/utils.c
index 694a92f..177c89a 100644
--- a/utils.c
+++ b/utils.c
@@ -531,7 +531,8 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret)
 	zero_end = 1;
 
 	if (block_count < 256 * 1024 * 1024) {
-		fprintf(stderr, "device %s is too small\n", file);
+		fprintf(stderr, "device %s is too small "
+		        "(must be at least 256 MB)\n", file);
 		exit(1);
 	}
 	ret = zero_dev_start(fd);
-- 
# Created with git-export-patch
