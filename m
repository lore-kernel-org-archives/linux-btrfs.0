Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3AGRDx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 12:03:53 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 6CAE4A51B7
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Jan 2013 18:03:52 +0100 (CET)
Date: Mon, 7 Jan 2013 18:03:51 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [bug] csum mismatches and failed xfstests with 3.8-rc1 and rc2
Message-ID: <20130107170351.GM20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130104125059.GE20089@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130104125059.GE20089@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

with top commit 5f243b9b46a22e5790dbbc36f574c2417af49a41 (something post
-rc2) I see more checksum errors

$ dmesg|grep csum|wc -l
100

and they appeared in a period of like last 30 minutes.  previous test rounds were
clean, and I can see that the same test sequenece run 3 time in a row with the
same mount parameters without a mkfs between runs. Test messages seem to be
related to no-space conditions.

MKFS_OPTIONS  -- /dev/sda9
MOUNT_OPTIONS -- -o space_cache,noatime /dev/sda9 /mnt/a2

091 41s ...     [17:18:32] [17:18:33] [failed, exit status 1] - output mismatch (see 091.out.bad)
--- 091.out     2011-11-01 10:31:12.000000000 +0100
+++ 091.out.bad 2013-01-07 17:18:33.000000000 +0100
@@ -1,7 +1,6 @@
 QA output created by 091
 fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
-fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
+./091: line 46: 11355 Segmentation fault      $here/ltp/fsx $args $TEST_DIR/junk >> $seq.full 2>&1
+fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
+mapped writes DISABLED
+truncating to largest ever: 0x12a00


133 220s ...    [17:28:51] [17:31:13] - output mismatch (see 133.out.bad)
--- 133.out     2011-02-11 11:42:31.000000000 +0100
+++ 133.out.bad 2013-01-07 17:31:13.000000000 +0100
@@ -2,4 +2,5 @@
 Buffered writer, buffered reader
 Direct writer, buffered reader
 Buffered writer, direct reader
+pread64: Input/output error
 Direct writer, direct reader


240 1s ...      [17:40:51] [17:40:51] [failed, exit status 11] - output mismatch (see 240.out.bad)
--- 240.out     2011-08-10 17:17:23.000000000 +0200
+++ 240.out.bad 2013-01-07 17:40:51.000000000 +0100
@@ -1,2 +1,4 @@
 QA output created by 240
 Silence is golden.
+AIO write offset 33280 expected 4096 got -5
+short read() at offset 29184


247 41s ...     [17:42:16] [17:42:36] [failed, exit status 1] - output mismatch (see 247.out.bad)
--- 247.out     2011-08-10 17:17:23.000000000 +0200
+++ 247.out.bad 2013-01-07 17:42:36.000000000 +0100
@@ -1,2 +1,2 @@
 QA output created by 247
-Silence is golden.
+Bus error


263 237s ...    [17:45:00] [17:45:01] [failed, exit status 1] - output mismatch (see 263.out.bad)
--- 263.out     2011-11-01 10:31:12.000000000 +0100
+++ 263.out.bad 2013-01-07 17:45:01.000000000 +0100
@@ -1,3 +1,100 @@
 QA output created by 263
 fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
-fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
+fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
+truncating to largest ever: 0x12a00
+truncating to largest ever: 0x75400
+dowrite: write: Input/output error
+LOG DUMP (91 total operations):
+1(  1 mod 256): SKIPPED (no operation)
+2(  2 mod 256): MAPWRITE 0x62600 thru 0x626e8  (0xe9 bytes)
+3(  3 mod 256): FALLOC   0x2e0f2 thru 0x2f438  (0x1346 bytes) INTERIOR
+4(  4 mod 256): TRUNCATE DOWN  from 0x626e9 to 0x12a00
+5(  5 mod 256): MAPREAD  0x0 thru 0x90e        (0x90f bytes)
+6(  6 mod 256): FALLOC   0x7048 thru 0x80ca    (0x1082 bytes) INTERIOR
+7(  7 mod 256): WRITE    0x5ea00 thru 0x5f3ff  (0xa00 bytes) HOLE
+8(  8 mod 256): SKIPPED (no operation)
+9(  9 mod 256): FALLOC   0x4957f thru 0x4af1f  (0x19a0 bytes) INTERIOR
+10( 10 mod 256): SKIPPED (no operation)
+11( 11 mod 256): WRITE    0x10a00 thru 0x127ff (0x1e00 bytes)
+12( 12 mod 256): MAPWRITE 0x53800 thru 0x54384 (0xb85 bytes)
+13( 13 mod 256): MAPWRITE 0x5ae00 thru 0x5c8a9 (0x1aaa bytes)
+14( 14 mod 256): READ     0x4a000 thru 0x4afff (0x1000 bytes)
+15( 15 mod 256): SKIPPED (no operation)
+16( 16 mod 256): MAPREAD  0x36000 thru 0x36acf (0xad0 bytes)
+17( 17 mod 256): SKIPPED (no operation)
+18( 18 mod 256): READ     0x12000 thru 0x12fff (0x1000 bytes)
+19( 19 mod 256): MAPWRITE 0x17600 thru 0x17b42 (0x543 bytes)
+20( 20 mod 256): READ     0x29000 thru 0x29fff (0x1000 bytes)
+21( 21 mod 256): FALLOC   0xea89 thru 0x1023e  (0x17b5 bytes) INTERIOR
+22( 22 mod 256): FALLOC   0x569aa thru 0x5847f (0x1ad5 bytes) INTERIOR
+23( 23 mod 256): WRITE    0x35c00 thru 0x369ff (0xe00 bytes)
+24( 24 mod 256): SKIPPED (no operation)
+25( 25 mod 256): SKIPPED (no operation)
+26( 26 mod 256): MAPREAD  0x32000 thru 0x32188 (0x189 bytes)
+27( 27 mod 256): MAPREAD  0x3f000 thru 0x40e43 (0x1e44 bytes)
+28( 28 mod 256): WRITE    0x6f600 thru 0x705ff (0x1000 bytes) HOLE
+29( 29 mod 256): MAPREAD  0x5b000 thru 0x5c99e (0x199f bytes)
+30( 30 mod 256): TRUNCATE UP   from 0x70600 to 0x75400
+31( 31 mod 256): MAPREAD  0x4000 thru 0x54d5   (0x14d6 bytes)
+32( 32 mod 256): SKIPPED (no operation)
+33( 33 mod 256): FALLOC   0x31d49 thru 0x32872 (0xb29 bytes) INTERIOR
+34( 34 mod 256): FALLOC   0x2bbb3 thru 0x2bca7 (0xf4 bytes) INTERIOR
+35( 35 mod 256): MAPREAD  0x68000 thru 0x68d8e (0xd8f bytes)
+36( 36 mod 256): FALLOC   0x2a075 thru 0x2aed7 (0xe62 bytes) INTERIOR
+37( 37 mod 256): MAPWRITE 0x24800 thru 0x25d8f (0x1590 bytes)
+38( 38 mod 256): SKIPPED (no operation)
+39( 39 mod 256): FALLOC   0x25e59 thru 0x26a93 (0xc3a bytes) INTERIOR
+40( 40 mod 256): WRITE    0x1a600 thru 0x1afff (0xa00 bytes)
+41( 41 mod 256): SKIPPED (no operation)
+42( 42 mod 256): MAPREAD  0x72000 thru 0x729ce (0x9cf bytes)
+43( 43 mod 256): MAPREAD  0x4f000 thru 0x4fe79 (0xe7a bytes)
+44( 44 mod 256): FALLOC   0x114aa thru 0x12d40 (0x1896 bytes) INTERIOR
+45( 45 mod 256): READ     0x1f000 thru 0x1ffff (0x1000 bytes)
+46( 46 mod 256): MAPWRITE 0x54600 thru 0x55272 (0xc73 bytes)
+47( 47 mod 256): WRITE    0xb600 thru 0xbfff   (0xa00 bytes)
+48( 48 mod 256): SKIPPED (no operation)
+49( 49 mod 256): WRITE    0x78600 thru 0x787ff (0x200 bytes) HOLE
+50( 50 mod 256): READ     0x24000 thru 0x24fff (0x1000 bytes)
+51( 51 mod 256): WRITE    0x17a00 thru 0x18bff (0x1200 bytes)
+52( 52 mod 256): MAPREAD  0x19000 thru 0x19093 (0x94 bytes)
+53( 53 mod 256): SKIPPED (no operation)
+54( 54 mod 256): WRITE    0x1a600 thru 0x1b3ff (0xe00 bytes)
+55( 55 mod 256): SKIPPED (no operation)
+56( 56 mod 256): READ     0x2e000 thru 0x2efff (0x1000 bytes)
+57( 57 mod 256): FALLOC   0x6f9e9 thru 0x7172c (0x1d43 bytes) INTERIOR
+58( 58 mod 256): SKIPPED (no operation)
+59( 59 mod 256): SKIPPED (no operation)
+60( 60 mod 256): FALLOC   0x38a61 thru 0x3a6d2 (0x1c71 bytes) INTERIOR
+61( 61 mod 256): SKIPPED (no operation)
+62( 62 mod 256): SKIPPED (no operation)
+63( 63 mod 256): WRITE    0x10800 thru 0x11dff (0x1600 bytes)
+64( 64 mod 256): WRITE    0x65000 thru 0x655ff (0x600 bytes)
+65( 65 mod 256): TRUNCATE DOWN from 0x78800 to 0xb200
+66( 66 mod 256): SKIPPED (no operation)
+67( 67 mod 256): MAPWRITE 0x72200 thru 0x73d0d (0x1b0e bytes)
+68( 68 mod 256): MAPWRITE 0x21200 thru 0x21f14 (0xd15 bytes)
+69( 69 mod 256): SKIPPED (no operation)
+70( 70 mod 256): SKIPPED (no operation)
+71( 71 mod 256): MAPWRITE 0x6c000 thru 0x6db45 (0x1b46 bytes)
+72( 72 mod 256): READ     0x3d000 thru 0x3dfff (0x1000 bytes)
+73( 73 mod 256): READ     0x34000 thru 0x34fff (0x1000 bytes)
+74( 74 mod 256): MAPREAD  0x20000 thru 0x218f5 (0x18f6 bytes)
+75( 75 mod 256): MAPREAD  0x29000 thru 0x2a1a6 (0x11a7 bytes)
+76( 76 mod 256): READ     0x62000 thru 0x62fff (0x1000 bytes)
+77( 77 mod 256): SKIPPED (no operation)
+78( 78 mod 256): MAPWRITE 0x2be00 thru 0x2c035 (0x236 bytes)
+79( 79 mod 256): TRUNCATE DOWN from 0x73d0e to 0x14e00
+80( 80 mod 256): MAPWRITE 0x33800 thru 0x355a6 (0x1da7 bytes)
+81( 81 mod 256): SKIPPED (no operation)
+82( 82 mod 256): MAPREAD  0x2000 thru 0x3e54   (0x1e55 bytes)
+83( 83 mod 256): MAPREAD  0x5000 thru 0x6c7f   (0x1c80 bytes)
+84( 84 mod 256): MAPREAD  0x8000 thru 0x9845   (0x1846 bytes)
+85( 85 mod 256): SKIPPED (no operation)
+86( 86 mod 256): FALLOC   0x3eb18 thru 0x3fd14 (0x11fc bytes) INTERIOR
+87( 87 mod 256): SKIPPED (no operation)
+88( 88 mod 256): WRITE    0x21600 thru 0x21fff (0xa00 bytes)
+89( 89 mod 256): WRITE    0x10200 thru 0x105ff (0x400 bytes)
+90( 90 mod 256): WRITE    0x2be00 thru 0x2c5ff (0x800 bytes)
+91( 91 mod 256): WRITE    0x2b200 thru 0x2c3ff (0x1200 bytes)
+Correct content saved for comparison
+(maybe hexdump "/mnt/a1/junk" vs "/mnt/a1/junk.fsxgood")


david
