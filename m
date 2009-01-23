From: ashford@whisperpc.com
Subject: [PATCH] btrfs-progs/mkfs.c - fix sectorsize validation
Date: Fri, 23 Jan 2009 10:09:17 -0800 (PST)
Message-ID: <34501.75.80.183.92.1232734157.squirrel@www.whisperpc.com>
References: <4979CDA2.80802@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4979CDA2.80802@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

It was possible to enter sector sizes larger than a memory page.  This would
result in some "unpleasantness", including hangs and crashes.  This patch also
adds a minimum sector size of 512 bytes.


# diff -u  mkfs.c- mkfs.c
--- mkfs.c-     2009-01-22 13:39:21.000000000 -0800
+++ mkfs.c      2009-01-23 10:01:06.000000000 -0800
@@ -390,8 +390,16 @@
                                print_usage();
                }
        }
-       sectorsize = max(sectorsize, (u32)getpagesize());
+
+       if (sectorsize < 512) {
+               printf("Sectorsize %u smaller than 512 - corrected\n",
+                       sectorsize);
+               sectorsize = 512;
+       } else if (sectorsize > (u32)getpagesize()) {
+               printf("Sectorsize %u larger than pagesize %u - corrected\n",
+                       sectorsize, (u32)getpagesize());
+               sectorsize = (u32)getpagesize();
+       }
        if ((sectorsize & (sectorsize - 1))) {
                fprintf(stderr, "Sector size %u must be a power of 2\n",
                        sectorsize);

