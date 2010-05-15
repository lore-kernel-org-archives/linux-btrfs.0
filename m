From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: help message of btrfsctl does not tell anything about deletion of
 a subvolume
Date: Sat, 15 May 2010 20:47:04 +0200
Message-ID: <4BEEEC28.7020100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The help message of the btrfsctl command does not tell anything about
the deletion of a subvolume. See patch below.

Kind regards,
Andreas

diff --git a/btrfsctl.c b/btrfsctl.c
index be6bf25..3ed6f2d 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -56,7 +56,7 @@ static void print_usage(void)
     printf("\t-A device: scans the device file for a Btrfs filesystem\n");
     printf("\t-a: scans all devices for Btrfs filesystems\n");
     printf("\t-c: forces a single FS sync\n");
-    printf("\t-D: delete snapshot\n");
+    printf("\t-D: delete snapshot or subvolume\n");
     printf("\t-m [tree id] directory: set the default mounted subvolume"
            " to the [tree id] or the directory\n");
     printf("%s\n", BTRFS_BUILD_VERSION);

