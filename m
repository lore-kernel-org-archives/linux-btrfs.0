From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] Fix typo: s/Coult/Could/
Date: Fri, 23 Jan 2009 19:14:47 -0200
Message-ID: <1232745288-4307-1-git-send-email-cascardo@holoscopio.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index e49c220..9e0cfe8 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -530,7 +530,7 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
 
 	fp = open(filename, flags, 0600);
 	if (fp < 0) {
-		fprintf (stderr, "Coult not open %s\n", filename);
+		fprintf (stderr, "Could not open %s\n", filename);
 		return NULL;
 	}
 	root = open_ctree_fd(fp, filename, sb_bytenr, writes);
-- 
1.6.0.6

