From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs-map-logical: usage update
Date: Mon, 14 Mar 2011 13:16:30 +0100
Message-ID: <1300104990-13124-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The option to give the number of bytes to read is -b, not -s. Updated
usage accordingly.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 btrfs-map-logical.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index aa4b5b5..f4695aa 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -90,7 +90,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-l Logical extent to map\n");
 	fprintf(stderr, "\t-c Copy of the extent to read (usually 1 or 2)\n");
 	fprintf(stderr, "\t-o Output file to hold the extent\n");
-	fprintf(stderr, "\t-s Number of bytes to read\n");
+	fprintf(stderr, "\t-b Number of bytes to read\n");
 	exit(1);
 }
 
-- 
1.7.3.4

