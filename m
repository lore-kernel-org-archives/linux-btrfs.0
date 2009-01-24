From: ashford@whisperpc.com
Subject: [PATCH] btrfs_progs/mkfs.c more input data verification cleanup
Date: Fri, 23 Jan 2009 19:39:32 -0800 (PST)
Message-ID: <62563.75.80.183.92.1232768372.squirrel@www.whisperpc.com>
References: <1232745288-4307-1-git-send-email-cascardo@holoscopio.com>
    <1232745288-4307-2-git-send-email-cascardo@holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232745288-4307-2-git-send-email-cascardo@holoscopio.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yet another patch for mkfs input data verification.

# diff -u mkfs.c- mkfs.c
--- mkfs.c-     2009-01-23 19:26:33.000000000 -0800
+++ mkfs.c      2009-01-23 19:33:07.000000000 -0800
@@ -406,13 +406,23 @@
                exit(1);
        }

-       if (leafsize < sectorsize || (leafsize & (sectorsize - 1))) {
-               fprintf(stderr, "Illegal leafsize %u\n", leafsize);
+       if (leafsize < sectorsize) {
+               printf("Leafsize %u smaller than sectorsize %u - corrected\n",
+                       leafsize, (u32)getpagesize());
+               leafsize = sectorsize;
+       } else if ((leafsize & (sectorsize - 1))) {
+               fprintf(stderr, "Leafsize %u not a multiple of sectorsize %u\n",
+                       leafsize, sectorsize);
                exit(1);
        }

-       if (nodesize < sectorsize || (nodesize & (sectorsize - 1))) {
-               fprintf(stderr, "Illegal nodesize %u\n", nodesize);
+       if (nodesize < sectorsize) {
+               printf("Nodesize %u smaller than sectorsize %u - corrected\n",
+                       nodesize, (u32)getpagesize());
+               nodesize = sectorsize;
+       } else if ((nodesize & (sectorsize - 1))) {
+               fprintf(stderr, "Nodesize %u not a multiple of sectorsize %u\n",
+                       nodesize, sectorsize);
                exit(1);
        }

