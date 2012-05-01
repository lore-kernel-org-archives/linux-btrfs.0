From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH v2 2/5] handle null pointers in btrfs_prepare_device
Date: Tue,  1 May 2012 14:40:30 +0200
Message-ID: <1335876033-12201-2-git-send-email-kario@wit.edu.pl>
References: <1335876033-12201-1-git-send-email-kario@wit.edu.pl>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335876033-12201-1-git-send-email-kario@wit.edu.pl>
List-ID: <linux-btrfs.vger.kernel.org>

When calling the function from `btrfs device zero-super` we don't need
the additional information returned and don't want the "SMALL VOLUME"
warning printed.

Signed-off-by: Hubert Kario <kario@wit.edu.pl>

diff --git a/utils.c b/utils.c
index ee7fa1b..6773be0 100644
--- a/utils.c
+++ b/utils.c
@@ -557,7 +557,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	}
 	zero_end = 1;
 
-	if (block_count < 1024 * 1024 * 1024 && !(*mixed)) {
+	if (mixed && block_count < 1024 * 1024 * 1024 && !(*mixed)) {
 		printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
 		*mixed = 1;
 	}
@@ -588,7 +588,9 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 			exit(1);
 		}
 	}
-	*block_count_ret = block_count;
+
+	if (block_count_ret)
+		*block_count_ret = block_count;
 	return 0;
 }
 
-- 
1.7.10

