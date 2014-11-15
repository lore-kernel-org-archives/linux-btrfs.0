Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:63737 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbaKOB1O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 20:27:14 -0500
Received: by mail-oi0-f50.google.com with SMTP id a141so4629890oig.23
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Nov 2014 17:27:13 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 15 Nov 2014 01:27:13 +0000
Message-ID: <CALOYprUMGsFEEUeYfd7Zs8_ZLM7_scApBCF=br42iq6suhA03w@mail.gmail.com>
Subject: btrfs-progs: ARGV0_BUF_SIZE causes problems with tests
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

I found a bit of a weird corner-case today. [1] It seems that, due to
the use of a 64-byte constant (ARGV0_BUF_SIZE) in utils.c, some tests
fail with a "buffer overflow detected" error if the progs are built in
a location with a sufficiently long path.

For example: clone the btrfs-progs repo into
/tmp/btrfs/abcdefghijklmnopqrstuvwxyz12345678901234 and run 'make
CFLAGS="-O2" all test', you should get a similar error to [2]. Now
move the cloned repo to
/tmp/btrfs/abcdefghijklmnopqrstuvwxyz1234567890123, run 'make clean'
on it, then re-run 'make CFLAGS="-O2" all test', and you should have a
successful build+test.

Trilby on the Arch Linux forums identified the root of the problem
(see [1]) and proposed a fix [3] which certainly fixes the problem for
me.

I first encountered the problem while building the progs in a much
more sane path (~/builds/btrfs-progs-git/btrfs-progs-unstable/), so
there are certainly real-world possibilities of this bug cropping up.
The /tmp paths are purely for ease of reproducing the bug.

I'm hoping that Trilby's patch is safe enough to merge as is, or an
alternative fix can be thought up.

Cheers,


WorMzy

[1] https://bbs.archlinux.org/viewtopic.php?id=189861
[2]
*** buffer overflow detected ***:
/tmp/btrfs/abcdefghijklmnopqrstuvwxyz12345678901234/btrfs-convert
terminated
======= Backtrace: =========
/usr/lib/libc.so.6(+0x734c7)[0x2af352e694c7]
/usr/lib/libc.so.6(__fortify_fail+0x37)[0x2af352eee9a7]
/usr/lib/libc.so.6(+0xf6b10)[0x2af352eecb10]
/usr/lib/libc.so.6(+0xf6049)[0x2af352eec049]
/usr/lib/libc.so.6(_IO_default_xsputn+0x81)[0x2af352e6c6d1]
/usr/lib/libc.so.6(_IO_vfprintf+0x39fd)[0x2af352e3e39d]
/usr/lib/libc.so.6(__vsprintf_chk+0x88)[0x2af352eec0d8]
/usr/lib/libc.so.6(__sprintf_chk+0x85)[0x2af352eec035]
/tmp/btrfs/abcdefghijklmnopqrstuvwxyz12345678901234/btrfs-convert[0x402d3f]
/usr/lib/libc.so.6(__libc_start_main+0xf0)[0x2af352e16040]
/tmp/btrfs/abcdefghijklmnopqrstuvwxyz12345678901234/btrfs-convert[0x403aa8]
======= Memory map: ========
00400000-0043b000 r-xp 00000000 00:42 991606
  /tmp/btrfs/abcdefghijklmnopqrstuvwxyz12345678901234/btrfs-convert
0063b000-0063c000 rw-p 0003b000 00:42 991606
  /tmp/btrfs/abcdefghijklmnopqrstuvwxyz12345678901234/btrfs-convert
022f9000-0231a000 rw-p 00000000 00:00 0                                  [heap]
2af351c0d000-2af351c2e000 r-xp 00000000 00:10 2485292
  /usr/lib/ld-2.20.so
2af351c2e000-2af351c2f000 rw-p 00000000 00:00 0
2af351c59000-2af351c5f000 rw-p 00000000 00:00 0
2af351e2e000-2af351e2f000 r--p 00021000 00:10 2485292
  /usr/lib/ld-2.20.so
2af351e2f000-2af351e30000 rw-p 00022000 00:10 2485292
  /usr/lib/ld-2.20.so
2af351e30000-2af351e31000 rw-p 00000000 00:00 0
2af351e31000-2af351e35000 r-xp 00000000 00:10 2676364
  /usr/lib/libuuid.so.1.3.0
2af351e35000-2af352034000 ---p 00004000 00:10 2676364
  /usr/lib/libuuid.so.1.3.0
2af352034000-2af352035000 r--p 00003000 00:10 2676364
  /usr/lib/libuuid.so.1.3.0
2af352035000-2af352036000 rw-p 00004000 00:10 2676364
  /usr/lib/libuuid.so.1.3.0
2af352036000-2af352071000 r-xp 00000000 00:10 2676361
  /usr/lib/libblkid.so.1.1.0
2af352071000-2af352271000 ---p 0003b000 00:10 2676361
  /usr/lib/libblkid.so.1.1.0
2af352271000-2af352274000 r--p 0003b000 00:10 2676361
  /usr/lib/libblkid.so.1.1.0
2af352274000-2af352275000 rw-p 0003e000 00:10 2676361
  /usr/lib/libblkid.so.1.1.0
2af352275000-2af352276000 rw-p 00000000 00:00 0
2af352276000-2af352372000 r-xp 00000000 00:10 2485246
  /usr/lib/libm-2.20.so
2af352372000-2af352572000 ---p 000fc000 00:10 2485246
  /usr/lib/libm-2.20.so
2af352572000-2af352573000 r--p 000fc000 00:10 2485246
  /usr/lib/libm-2.20.so
2af352573000-2af352574000 rw-p 000fd000 00:10 2485246
  /usr/lib/libm-2.20.so
2af352574000-2af352589000 r-xp 00000000 00:10 2122026
  /usr/lib/libz.so.1.2.8
2af352589000-2af352788000 ---p 00015000 00:10 2122026
  /usr/lib/libz.so.1.2.8
2af352788000-2af352789000 r--p 00014000 00:10 2122026
  /usr/lib/libz.so.1.2.8
2af352789000-2af35278a000 rw-p 00015000 00:10 2122026
  /usr/lib/libz.so.1.2.8
2af35278a000-2af3527ab000 r-xp 00000000 00:10 2553785
  /usr/lib/liblzo2.so.2.0.0
2af3527ab000-2af3529aa000 ---p 00021000 00:10 2553785
  /usr/lib/liblzo2.so.2.0.0
2af3529aa000-2af3529ab000 r--p 00020000 00:10 2553785
  /usr/lib/liblzo2.so.2.0.0
2af3529ab000-2af3529ac000 rw-p 00021000 00:10 2553785
  /usr/lib/liblzo2.so.2.0.0
2af3529ac000-2af3529f0000 r-xp 00000000 00:10 2538515
  /usr/lib/libext2fs.so.2.4
2af3529f0000-2af352bef000 ---p 00044000 00:10 2538515
  /usr/lib/libext2fs.so.2.4
2af352bef000-2af352bf0000 r--p 00043000 00:10 2538515
  /usr/lib/libext2fs.so.2.4
2af352bf0000-2af352bf2000 rw-p 00044000 00:10 2538515
  /usr/lib/libext2fs.so.2.4
2af352bf2000-2af352bf5000 r-xp 00000000 00:10 2538512
  /usr/lib/libcom_err.so.2.1
2af352bf5000-2af352df4000 ---p 00003000 00:10 2538512
  /usr/lib/libcom_err.so.2.1
2af352df4000-2af352df5000 r--p 00002000 00:10 2538512
  /usr/lib/libcom_err.so.2.1
2af352df5000-2af352df6000 rw-p 00003000 00:10 2538512
  /usr/lib/libcom_err.so.2.1
2af352df6000-2af352f8f000 r-xp 00000000 00:10 2485291
  /usr/lib/libc-2.20.so
2af352f8f000-2af35318f000 ---p 00199000 00:10 2485291
  /usr/lib/libc-2.20.so
2af35318f000-2af353193000 r--p 00199000 00:10 2485291
  /usr/lib/libc-2.20.so
2af353193000-2af353195000 rw-p 0019d000 00:10 2485291
  /usr/lib/libc-2.20.so
2af353195000-2af353199000 rw-p 00000000 00:00 0
2af353199000-2af3531b0000 r-xp 00000000 00:10 2485308
  /usr/lib/libpthread-2.20.so
2af3531b0000-2af3533af000 ---p 00017000 00:10 2485308
  /usr/lib/libpthread-2.20.so
2af3533af000-2af3533b0000 r--p 00016000 00:10 2485308
  /usr/lib/libpthread-2.20.so
2af3533b0000-2af3533b1000 rw-p 00017000 00:10 2485308
  /usr/lib/libpthread-2.20.so
2af3533b1000-2af3533b5000 rw-p 00000000 00:00 0
2af3533b5000-2af3533cb000 r-xp 00000000 00:10 2704057
  /usr/lib/libgcc_s.so.1
2af3533cb000-2af3535ca000 ---p 00016000 00:10 2704057
  /usr/lib/libgcc_s.so.1
2af3535ca000-2af3535cb000 rw-p 00015000 00:10 2704057
  /usr/lib/libgcc_s.so.1
7fff14eba000-7fff14edc000 rw-p 00000000 00:00 0                          [stack]
7fff14fd7000-7fff14fd9000 r--p 00000000 00:00 0                          [vvar]
7fff14fd9000-7fff14fdb000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
  [vsyscall]
tests/convert-tests.sh: line 17: 30421 Aborted                 (core
dumped) $here/btrfs-convert $here/test.img >>
convert-tests-results.txt 2>&1
btrfs-convert failed
Makefile:144: recipe for target 'test' failed
make: *** [test] Error 1

[3]
--- utils.c 2014-11-14 18:41:22.060881599 -0500
+++ utils-new.c 2014-11-14 18:42:21.867224267 -0500
@@ -66,7 +66,7 @@

 void set_argv0(char **argv)
 {
- sprintf(argv0_buf, "%s", argv[0]);
+ snprintf(argv0_buf, ARGV0_BUF_SIZE, "%s", argv[0]);
 }

 int check_argc_exact(int nargs, int expected)
