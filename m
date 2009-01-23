From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] Add error message explaining why opening a device failed
Date: Fri, 23 Jan 2009 19:14:48 -0200
Message-ID: <1232745288-4307-2-git-send-email-cascardo@holoscopio.com>
References: <1232745288-4307-1-git-send-email-cascardo@holoscopio.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232745288-4307-1-git-send-email-cascardo@holoscopio.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 disk-io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 9e0cfe8..5986709 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -530,7 +530,8 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
 
 	fp = open(filename, flags, 0600);
 	if (fp < 0) {
-		fprintf (stderr, "Could not open %s\n", filename);
+		fprintf (stderr, "Could not open %s: %s\n", filename,
+			 strerror (errno));
 		return NULL;
 	}
 	root = open_ctree_fd(fp, filename, sb_bytenr, writes);
-- 
1.6.0.6

