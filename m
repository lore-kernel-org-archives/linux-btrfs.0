From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH v2 5/5] btrfs: remove unused variables
Date: Tue,  1 May 2012 14:41:27 +0200
Message-ID: <1335876087-12248-2-git-send-email-kario@wit.edu.pl>
References: <1335876087-12248-1-git-send-email-kario@wit.edu.pl>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1335876087-12248-1-git-send-email-kario@wit.edu.pl>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hubert Kario <kario@wit.edu.pl>

diff --git a/cmds-device.c b/cmds-device.c
index a28752f..b1e70f9 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -261,8 +261,6 @@ static int cmd_zero_dev(int argc, char **argv)
 	int arg_processed;
 	int ret = 0;
 	int n;
-	u64 device_len;
-	int mixed_mode_needed = 1; /* keep btrfs_prepare_device() quiet */
 
 	if( argc < 2 ) {
 		usage(cmd_zero_dev_usage);
@@ -278,8 +276,7 @@ static int cmd_zero_dev(int argc, char **argv)
 			continue;
 		}
 
-		n = btrfs_prepare_device(fd, file, &device_len,
-					 &mixed_mode_needed);
+		n = btrfs_prepare_device(fd, file, NULL, NULL);
 		if (n) {
 			fprintf(stderr, "Error when zeroing out %s\n", file);
 			ret |= n;
-- 
1.7.10

