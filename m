From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH 2/2] fix reporting of status for degraded arrays
Date: Tue, 21 Feb 2012 00:27:46 +0100
Message-ID: <1329780466-4175-1-git-send-email-kario@wit.edu.pl>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hubert Kario <kario@wit.edu.pl>
---
 scrub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scrub.c b/scrub.c
index 9dca5f6..630a1bf 100644
--- a/scrub.c
+++ b/scrub.c
@@ -1010,7 +1010,7 @@ static int scrub_fs_info(int fd, char *path,
 	if (!fi_args->num_devices)
 		return 0;
 
-	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
+	di_args = *di_ret = calloc(fi_args->num_devices, sizeof(*di_args));
 	if (!di_args)
 		return -errno;
 
-- 
1.7.9

