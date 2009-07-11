From: ashford@whisperpc.com
Subject: Re: Soft lockup by using 256K sizes
Date: Fri, 10 Jul 2009 18:11:34 -0700 (PDT)
Message-ID: <56419.75.80.183.92.1247274694.squirrel@www.whisperpc.com>
References: <901705186@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: oli1417@hallo.ms
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <901705186@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

Oliver,

> I just tried btrfs with a big blocksize (-n,-l,-s) of 256K. Creating the fs
> worked Ok. I had to put all three -n,-l,-s options to 256K, otherwise
> mkfs.btrfs complained. But mounting results in a soft lockup (reproducible).
> It's not the latest btrfs version however. The details are shown below.

The problem is that the block size is being set to a value that's larger than
the memory page size.  This is not supported.  I sent in some validation
patches for the MKFS command in January, but they may not have been tested &
integrated yet.

Good luck.

Peter Ashford



Patch #1

# diff -u mkfs.c- mkfs.c
--- mkfs.c-     2009-01-20 11:37:39.000000000 -0800
+++ mkfs.c      2009-01-22 10:13:49.000000000 -0800
@@ -391,14 +391,22 @@
                }
        }
        sectorsize = max(sectorsize, (u32)getpagesize());
+       if ((sectorsize & (sectorsize - 1))) {
+               fprintf(stderr, "Sector size %u must be a power of 2\n",
+                       sectorsize);
+               exit(1);
+       }
+
        if (leafsize < sectorsize || (leafsize & (sectorsize - 1))) {
                fprintf(stderr, "Illegal leafsize %u\n", leafsize);
                exit(1);
        }
+
        if (nodesize < sectorsize || (nodesize & (sectorsize - 1))) {
                fprintf(stderr, "Illegal nodesize %u\n", nodesize);
                exit(1);
        }
+
        ac = ac - optind;
        if (ac == 0)
                print_usage();
#

==========================================================================
Patch #2

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

==========================================================================
Patch #3

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

