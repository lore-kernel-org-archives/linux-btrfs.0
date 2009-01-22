From: ashford@whisperpc.com
Subject: [PATCH] Add validation for sector size
Date: Thu, 22 Jan 2009 10:20:02 -0800 (PST)
Message-ID: <41569.75.80.183.92.1232648402.squirrel@www.whisperpc.com>
References: <52232.75.80.183.92.1232484873.squirrel@www.whisperpc.com>
    <1232492841.16352.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232492841.16352.2.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

In mkfs.btrfs, the sector size must be a power of two for the second half of
the leafsize and nodesize checks to work, but sectorsize is never validated.


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

