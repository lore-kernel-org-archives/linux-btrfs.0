Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab3AWPVL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 10:21:11 -0500
Date: Wed, 23 Jan 2013 16:21:07 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: put csums on the right ordered extent
Message-ID: <20130123152106.GI28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358887535-7241-1-git-send-email-jbacik@fusionio.com>
 <20130123110107.GG28263@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130123110107.GG28263@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 23, 2013 at 12:01:08PM +0100, David Sterba wrote:
> Survived a few hours of Chris' test and I'm running the full xfstests
> again now.

After 4.5 hours of the same testsuite as before, this popped up in
syslog:

[53489.998888] btrfs csum failed ino 63793 off 106496 csum 2411266714 private 3462448526

the file is $TEST/junk . Running md5sum on that file produces a
different checksum error messages:

[54187.259285] btrfs csum failed ino 63793 off 344064 csum 2566472073 private 1022717503
(3 times)

I've rerun chris' script again, no errors, and rechecked if I'm running
the kernel, yes.

relevant part of testlog:

091 41s ...     [15:49:07] [15:49:08] [failed, exit status 1] - output mismatch (see 091.out.bad)
    --- 091.out 2011-11-01 10:31:12.000000000 +0100
    +++ 091.out.bad     2013-01-23 15:49:08.000000000 +0100
    @@ -1,7 +1,64 @@
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
    +dowrite: write: Input/output error
    +LOG DUMP (54 total operations):
    +1(  1 mod 256): SKIPPED (no operation)
    +2(  2 mod 256): WRITE    0x62600 thru 0x6bdff      (0x9800 bytes) HOLE
    +3(  3 mod 256): FALLOC   0x2e0f2 thru 0x3134a      (0x3258 bytes) INTERIOR
    +4(  4 mod 256): TRUNCATE DOWN      from 0x6be00 to 0x12a00
    +5(  5 mod 256): READ     0x0 thru 0xdfff   (0xe000 bytes)
    +6(  6 mod 256): FALLOC   0x7048 thru 0x9f54        (0x2f0c bytes) INTERIOR
    +7(  7 mod 256): WRITE    0x5ea00 thru 0x6e7ff      (0xfe00 bytes) HOLE
    +8(  8 mod 256): READ     0x16000 thru 0x17fff      (0x2000 bytes)
    +9(  9 mod 256): FALLOC   0x4957f thru 0x5298e      (0x940f bytes) INTERIOR
    +10( 10 mod 256): SKIPPED (no operation)
    +11( 11 mod 256): WRITE    0x10a00 thru 0x173ff     (0x6a00 bytes)
    +12( 12 mod 256): WRITE    0x53800 thru 0x5a7ff     (0x7000 bytes)
    +13( 13 mod 256): WRITE    0x5ae00 thru 0x5afff     (0x200 bytes)
    +14( 14 mod 256): READ     0x5d000 thru 0x66fff     (0xa000 bytes)
    +15( 15 mod 256): SKIPPED (no operation)
    +16( 16 mod 256): READ     0x21000 thru 0x2bfff     (0xb000 bytes)
    +17( 17 mod 256): SKIPPED (no operation)
    +18( 18 mod 256): READ     0x47000 thru 0x4ffff     (0x9000 bytes)
    +19( 19 mod 256): WRITE    0x17600 thru 0x25bff     (0xe600 bytes)
    +20( 20 mod 256): READ     0x3f000 thru 0x48fff     (0xa000 bytes)
    +21( 21 mod 256): FALLOC   0xea89 thru 0x19800      (0xad77 bytes) INTERIOR
    +22( 22 mod 256): FALLOC   0x569aa thru 0x586ea     (0x1d40 bytes) INTERIOR
    +23( 23 mod 256): WRITE    0x35c00 thru 0x453ff     (0xf800 bytes)
    +24( 24 mod 256): SKIPPED (no operation)
    +25( 25 mod 256): SKIPPED (no operation)
    +26( 26 mod 256): READ     0x21000 thru 0x26fff     (0x6000 bytes)
    +27( 27 mod 256): READ     0x5e000 thru 0x61fff     (0x4000 bytes)
    +28( 28 mod 256): WRITE    0x6f600 thru 0x6f7ff     (0x200 bytes) HOLE
    +29( 29 mod 256): READ     0x13000 thru 0x19fff     (0x7000 bytes)
    +30( 30 mod 256): TRUNCATE UP       from 0x6f800 to 0x75400
    +31( 31 mod 256): READ     0x4000 thru 0xafff       (0x7000 bytes)
    +32( 32 mod 256): SKIPPED (no operation)
    +33( 33 mod 256): FALLOC   0x31d49 thru 0x3c520     (0xa7d7 bytes) INTERIOR
    +34( 34 mod 256): FALLOC   0x2bbb3 thru 0x37ad8     (0xbf25 bytes) INTERIOR
    +35( 35 mod 256): READ     0x68000 thru 0x73fff     (0xc000 bytes)
    +36( 36 mod 256): FALLOC   0x2a075 thru 0x36518     (0xc4a3 bytes) INTERIOR
    +37( 37 mod 256): WRITE    0x24800 thru 0x275ff     (0x2e00 bytes)
    +38( 38 mod 256): READ     0x2f000 thru 0x3cfff     (0xe000 bytes)
    +39( 39 mod 256): FALLOC   0x25e59 thru 0x345eb     (0xe792 bytes) INTERIOR
    +40( 40 mod 256): WRITE    0x1a600 thru 0x225ff     (0x8000 bytes)
    +41( 41 mod 256): READ     0x11000 thru 0x13fff     (0x3000 bytes)
    +42( 42 mod 256): READ     0x72000 thru 0x73fff     (0x2000 bytes)
    +43( 43 mod 256): READ     0x4f000 thru 0x5bfff     (0xd000 bytes)
    +44( 44 mod 256): FALLOC   0x114aa thru 0x1818b     (0x6ce1 bytes) INTERIOR
    +45( 45 mod 256): READ     0x1f000 thru 0x28fff     (0xa000 bytes)
    +46( 46 mod 256): WRITE    0x54600 thru 0x609ff     (0xc400 bytes)
    +47( 47 mod 256): WRITE    0xb600 thru 0xe7ff       (0x3200 bytes)
    +48( 48 mod 256): WRITE    0x68c00 thru 0x73fff     (0xb400 bytes)
    +49( 49 mod 256): WRITE    0x78600 thru 0x79dff     (0x1800 bytes) HOLE
    +50( 50 mod 256): READ     0x49000 thru 0x4cfff     (0x4000 bytes)
    +51( 51 mod 256): WRITE    0x17a00 thru 0x223ff     (0xaa00 bytes)
    +52( 52 mod 256): READ     0x9000 thru 0xafff       (0x2000 bytes)
    +53( 53 mod 256): SKIPPED (no operation)
    +54( 54 mod 256): WRITE    0x1a600 thru 0x209ff     (0x6400 bytes)
