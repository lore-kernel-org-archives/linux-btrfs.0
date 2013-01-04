Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab3ADMvB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jan 2013 07:51:01 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id EC222A398E
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jan 2013 13:51:00 +0100 (CET)
Date: Fri, 4 Jan 2013 13:50:59 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: [bug] csum mismatches and failed xfstests with 3.8-rc1
Message-ID: <20130104125059.GE20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've noticed a few csum mismatch messages, and a few failed xfstests:

- 3.8.0-rc1
- defautl mkfs options
- MOUNT_OPTIONS -- -o space_cache,noatime,inode_cache
- test device:    40G
- scratch device: 10G

091:
--- 091.out     2011-11-01 10:31:12.000000000 +0100
+++ 091.out.bad 2013-01-03 21:07:29.000000000 +0100
@@ -1,7 +1,45 @@
 QA output created by 091
 fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
+fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+mapped writes DISABLED
+truncating to largest ever: 0x12a00
+truncating to largest ever: 0x75400
+doread: read: Input/output error
+LOG DUMP (35 total operations):
+1(  1 mod 256): SKIPPED (no operation)
+2(  2 mod 256): WRITE    0x62600 thru 0x6bdff  (0x9800 bytes) HOLE
+3(  3 mod 256): FALLOC   0x2e0f2 thru 0x3134a  (0x3258 bytes) INTERIOR
+4(  4 mod 256): TRUNCATE DOWN  from 0x6be00 to 0x12a00
+5(  5 mod 256): READ     0x0 thru 0xdfff       (0xe000 bytes)
+6(  6 mod 256): FALLOC   0x7048 thru 0x9f54    (0x2f0c bytes) INTERIOR
+7(  7 mod 256): WRITE    0x5ea00 thru 0x6e7ff  (0xfe00 bytes) HOLE
+8(  8 mod 256): READ     0x16000 thru 0x17fff  (0x2000 bytes)
+9(  9 mod 256): FALLOC   0x4957f thru 0x5298e  (0x940f bytes) INTERIOR
+10( 10 mod 256): SKIPPED (no operation)
+11( 11 mod 256): WRITE    0x10a00 thru 0x173ff (0x6a00 bytes)
+12( 12 mod 256): WRITE    0x53800 thru 0x5a7ff (0x7000 bytes)
+13( 13 mod 256): WRITE    0x5ae00 thru 0x5afff (0x200 bytes)
+14( 14 mod 256): READ     0x5d000 thru 0x66fff (0xa000 bytes)
+15( 15 mod 256): SKIPPED (no operation)
+16( 16 mod 256): READ     0x21000 thru 0x2bfff (0xb000 bytes)
+17( 17 mod 256): SKIPPED (no operation)
+18( 18 mod 256): READ     0x47000 thru 0x4ffff (0x9000 bytes)
+19( 19 mod 256): WRITE    0x17600 thru 0x25bff (0xe600 bytes)
+20( 20 mod 256): READ     0x3f000 thru 0x48fff (0xa000 bytes)
+21( 21 mod 256): FALLOC   0xea89 thru 0x19800  (0xad77 bytes) INTERIOR
+22( 22 mod 256): FALLOC   0x569aa thru 0x586ea (0x1d40 bytes) INTERIOR
+23( 23 mod 256): WRITE    0x35c00 thru 0x453ff (0xf800 bytes)
+24( 24 mod 256): SKIPPED (no operation)
+25( 25 mod 256): SKIPPED (no operation)
+26( 26 mod 256): READ     0x21000 thru 0x26fff (0x6000 bytes)
+27( 27 mod 256): READ     0x5e000 thru 0x61fff (0x4000 bytes)
+28( 28 mod 256): WRITE    0x6f600 thru 0x6f7ff (0x200 bytes) HOLE
+29( 29 mod 256): READ     0x13000 thru 0x19fff (0x7000 bytes)
+30( 30 mod 256): TRUNCATE UP   from 0x6f800 to 0x75400
+31( 31 mod 256): READ     0x4000 thru 0xafff   (0x7000 bytes)
+32( 32 mod 256): SKIPPED (no operation)
+33( 33 mod 256): FALLOC   0x31d49 thru 0x3c520 (0xa7d7 bytes) INTERIOR
+34( 34 mod 256): FALLOC   0x2bbb3 thru 0x37ad8 (0xbf25 bytes) INTERIOR
+35( 35 mod 256): READ     0x68000 thru 0x73fff (0xc000 bytes)
+Correct content saved for comparison
+(maybe hexdump "/mnt/a1/junk" vs "/mnt/a1/junk.fsxgood")

I'm not quite sure if the messages match the test (best guess, neighbouring
tests were fine):

[102885.667444] btrfs csum failed ino 638 off 425984 csum 1842675109 private 2279232751
[102885.676804] btrfs csum failed ino 638 off 430080 csum 1842675109 private 1192041375
[102885.686094] btrfs csum failed ino 638 off 434176 csum 2297282744 private 1619428542
[102885.686103] btrfs csum failed ino 638 off 438272 csum 3709984297 private 2868627320
[102885.686112] btrfs csum failed ino 638 off 442368 csum 1504116677 private 1239355148
[102885.686121] btrfs csum failed ino 638 off 446464 csum 1957839041 private 3848200057
[102885.686129] btrfs csum failed ino 638 off 450560 csum 3836729483 private 2867416946


113:
- it hung last evening and is still in that state, no disk or cpu activity,
  there were only the tests running
- no process is in D state, no btrfs kernel thread is active
- the only interesting process is

  PID TTY      STAT   TIME COMMAND
15585 pts/0    Sl+    0:01 /root/xfstests/ltp/aio-stress -t 20 -s 10  -O -S -I	\
	1000 /mnt/a1/aiostress.15188.4 /mnt/a1/aiostress.15188.4.20		\
	/mnt/a1/aiostress.15188.4.19 /mnt/a1/aiostress.15188.4.18		\
[<ffffffff810af447>] futex_wait_queue_me+0xc7/0x100
[<ffffffff810affa1>] futex_wait+0x191/0x280
[<ffffffff810b1cb6>] do_futex+0xd6/0xbd0
[<ffffffff810b282b>] sys_futex+0x7b/0x180
[<ffffffff8195fe99>] system_call_fastpath+0x16/0x1b

there are also csum mismatch messages:

[103208.085544] btrfs csum failed ino 2998 off 2883584 csum 3942040493 private 2566472073
[103208.366484] btrfs csum failed ino 2990 off 2949120 csum 2166904896 private 2566472073

# btrfs inspect ino 2998 /mnt/a1
/mnt/a1/aiostress.15188.4.6

# btrfs inspect ino 2990 /mnt/a1
/mnt/a1/aiostress.15188.4.14

# lsof|grep aiostress|wc -l
342

but neither aiostress.<pid>.4.6 nor 4.14 are open

--

Previously, the same machine went through the tests with following options:

MKFS_OPTIONS  -- /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime /dev/sda9 /mnt/a2

MKFS_OPTIONS  -- -m single -d single /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime /dev/sda9 /mnt/a2

MKFS_OPTIONS  -- -m single -d single --mixed /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime /dev/sda9 /mnt/a2

MKFS_OPTIONS  -- -m dup -d dup --mixed /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime /dev/sda9 /mnt/a2

MKFS_OPTIONS  -- /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime /dev/sda9 /mnt/a2

MKFS_OPTIONS  -- /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime /dev/sda9 /mnt/a2

MKFS_OPTIONS  -- /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime,inode_cache /dev/sda9 /mnt/a2

MKFS_OPTIONS  -- -m single -d single /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime,inode_cache /dev/sda9 /mnt/a2

MKFS_OPTIONS  -- -m single -d single --mixed /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime,inode_cache /dev/sda9 /mnt/a2

MKFS_OPTIONS  -- -m dup -d dup --mixed /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime,inode_cache /dev/sda9 /mnt/a2

MKFS_OPTIONS  -- /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime,inode_cache /dev/sda9 /mnt/a2

The failed one has previously passed once, and it does not seem that it's
caused only by the inode_cache option.

--

Other information:
# btrfs fi df /mnt/a1
Data: total=4.01GiB, used=247.80MiB
System, RAID1: total=8.00MiB, used=4.00KiB
System: total=4.00MiB, used=0.00
Metadata, RAID1: total=1.00GiB, used=3.61MiB
Metadata: total=8.00MiB, used=0.00

# btrfs fi df /mnt/a2
Data: total=8.00MiB, used=292.00KiB
System, DUP: total=8.00MiB, used=4.00KiB
System: total=4.00MiB, used=0.00
Metadata, DUP: total=1.00GiB, used=24.00KiB
Metadata: total=8.00MiB, used=0.00


david
