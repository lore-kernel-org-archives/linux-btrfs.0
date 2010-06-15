From: Kyungmin Park <kmpark@infradead.org>
Subject: BTRFS is broken with discard request?
Date: Wed, 16 Jun 2010 08:17:49 +0900
Message-ID: <AANLkTim8Ipx56Dn2P7_HHBHLWj27_t4sizY4L2De6N_R@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, linux-mmc@vger.kernel.org,
	chris.mason@oracle.com, Adrian Hunter <adrian.hunter@nokia.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Deal all,

Now I got test the btrfs with discard option on MMC (implemented
discard request).
but I can't test the iozone benchmark test program with I/O error.

Of course I disabled the discard option. it works well. and discard
handling is tested with VFAT well.
So I think BTRFS discard request seems to broken.

Test kernel is commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jun 11 19:14:04 2010 -0700

    Linux 2.6.35-rc3

scenarios are below.

Any clues?

Thank you,
Kyungmin Park

# mkfs.btrfs /dev/mmcblk0p1 -L mmc

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label mmc on /dev/mmcblk0p1
        nodesize 4096 leafsize 4096 sectorsize 4096 size 7.40GB
Btrfs Btrfs v0.19

# mount -t btrfs -o ssd,discard /dev/mmcblk0p1 /mnt/mmc
[39310.465000] device label mmc devid 1 transid 7 /dev/mmcblk0p1
[39310.470000] btrfs: use ssd allocation scheme

# iozone -A -s 10m -U /mnt/mmc -f /mnt/mmc/test -e
        Iozone: Performance Test of File I/O
                Version $Revision: 3.326 $
                Compiled for 32 bit mode.
                Build: linux-arm

        Contributors:William Norcott, Don Capps, Isom Crawford, Kirby Collins
                     Al Slater, Scott Rhine, Mike Wisner, Ken Goss
                     Steve Landherr, Brad Smith, Mark Kelly, Dr. Alain CYR,
                     Randy Dunlap, Mark Montague, Dan Million, Gavin Brebner,
                     Jean-Marc Zucconi, Jeff Blomberg, Benny Halevy,
                     Erik Habbinga, Kris Strecker, Walter Wong, Joshua Root.

        Run began: Thu Jan  1 10:55:35 1970

        Auto Mode 2. This option is obsolete. Use -az -i0 -i1
        File size set to 10240 KB
        Include fsync in write timing
        Command line used: iozone -A -s 10m -U /mnt/mmc -f /mnt/mmc/test -e
        Output is in Kbytes/sec
        Time Resolution = 0.000001 seconds.
        Processor cache size set to 1024 Kbytes.

        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.

              KB  reclen   write rewrite    read    reread

           10240       4
[39337.095000] device label mmc devid 1 transid 12 /dev/mmcblk0p1
[39337.100000] btree_readpage_end_io_hook: 4 callbacks suppressed
[39337.105000] btrfs bad tree block start 0 29421568
[39337.110000] btrfs bad tree block start 0 29421568
[39337.115000] btrfs bad tree block start 0 29425664
[39337.120000] btrfs bad tree block start 0 29425664
[39337.125000] btrfs bad tree block start 0 29372416
[39337.130000] btrfs bad tree block start 0 29372416
[39337.135000] btrfs bad tree block start 0 29376512
[39337.140000] btrfs bad tree block start 0 29376512
[39337.145000] Btrfs detected SSD devices, enabling SSD mode
[39337.150000] btrfs bad tree block start 0 29380608
[39337.155000] btrfs bad tree block start 0 29380608
[39338.880000] device label mmc devid 1 transid 17 /dev/mmcblk0p1
[39338.895000] Btrfs detected SSD devices, enabling SSD mode
    7494    8721
[39340.830000] device label mmc devid 1 transid 21 /dev/mmcblk0p1
[39340.845000] Btrfs detected SSD devices, enabling SSD mode

Error reading block 0 40200000
read: Input/output error
#
