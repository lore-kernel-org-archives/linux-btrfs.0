Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46367 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964848Ab2HVRTf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 13:19:35 -0400
Received: by wgbdr13 with SMTP id dr13so1064434wgb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Aug 2012 10:19:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANDob0J40BuLhJ2g0Et+-Gq0Nu6V=QkgLfTPGRT5rQUQpBRQaA@mail.gmail.com>
References: <CANDob0+VQ0UJJaDS89CGK5YNXys40SWgWMgeTjeZoca4teVEUw@mail.gmail.com>
 <CANDob0+XEHbYmp2PF-UW1EXRP6YbKw3Fn00th8u9A2R7XdCrJg@mail.gmail.com>
 <20120821160019.GN17430@twin.jikos.cz> <CANDob0LpwsWP=jcyMkxZor0_6AnFeHY6zt-Sp6V0HH+Pd2SH=w@mail.gmail.com>
 <20120822143705.GR17430@twin.jikos.cz> <CANDob0J40BuLhJ2g0Et+-Gq0Nu6V=QkgLfTPGRT5rQUQpBRQaA@mail.gmail.com>
From: Not Zippy <notzippy@gmail.com>
Date: Wed, 22 Aug 2012 10:19:13 -0700
Message-ID: <CANDob0+b2nPF7eRQ6wuQ0SwyuO2NDvfUM_R1-bbVRZ1FiHX0pQ@mail.gmail.com>
Subject: Re: Computer crash, btrfs partition errors
To: dave@jikos.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

The full output of the btrfs-debug-tree is 190MB compressed, did you
want it still ?

As far as the conditions, I was running a repo sync which I had
CTRL-Z, I then got distracted and mistakenly started the sync again
(not sure if you are familiar with repo command, it spawns git
processes to checkout project). The crash did not occur immediately
but it was probably within 2 minutes of me starting this second repo
sync. The lock up was bad enough that BUSIER did not reboot the PC, I
had to power down.

After the patch to btrfsck, I got this error:

# ./work/builds/btrfs-progs/btrfsck --repair /dev/sda2
enabling repair mode
checking extents
leaf parent key incorrect 46329503744
bad block 46329503744
owner ref check failed [46329503744 4096]
repair deleting extent record: key 46329503744 168 4096
adding new tree backref on start 46329503744 len 4096 parent 256 root 256
repaired damaged extent references
*** glibc detected *** ./work/builds/btrfs-progs/btrfsck: corrupted
double-linked list: 0x000000001202b220 ***
======= Backtrace: =========
/lib64/libc.so.6(+0x77896)[0x7f0008c59896]
/lib64/libc.so.6(+0x77cfb)[0x7f0008c59cfb]
/lib64/libc.so.6(+0x784a8)[0x7f0008c5a4a8]
/lib64/libc.so.6(cfree+0x6c)[0x7f0008c5d84c]
./work/builds/btrfs-progs/btrfsck[0x415db8]
./work/builds/btrfs-progs/btrfsck[0x415e15]
./work/builds/btrfs-progs/btrfsck[0x40aa9e]
./work/builds/btrfs-progs/btrfsck[0x4046c7]
/lib64/libc.so.6(__libc_start_main+0xed)[0x7f0008c0636d]
./work/builds/btrfs-progs/btrfsck[0x4017f9]
======= Memory map: ========
00400000-00427000 r-xp 00000000 00:22 1375631
  /mnt/DevSystem/Work/builds/btrfs-progs/btrfsck
00626000-00627000 r--p 00026000 00:22 1375631
  /mnt/DevSystem/Work/builds/btrfs-progs/btrfsck
00627000-00628000 rw-p 00027000 00:22 1375631
  /mnt/DevSystem/Work/builds/btrfs-progs/btrfsck
01f27000-2576c000 rw-p 00000000 00:00 0                                  [heap]
7f0004000000-7f0004021000 rw-p 00000000 00:00 0
7f0004021000-7f0008000000 ---p 00000000 00:00 0
7f00089cb000-7f00089e0000 r-xp 00000000 08:22 298053
  /lib64/libgcc_s.so.1
7f00089e0000-7f0008be0000 ---p 00015000 08:22 298053
  /lib64/libgcc_s.so.1
7f0008be0000-7f0008be1000 r--p 00015000 08:22 298053
  /lib64/libgcc_s.so.1
7f0008be1000-7f0008be2000 rw-p 00016000 08:22 298053
  /lib64/libgcc_s.so.1
7f0008be2000-7f0008d64000 r-xp 00000000 08:22 2883622
  /lib64/libc-2.14.1.so
7f0008d64000-7f0008f64000 ---p 00182000 08:22 2883622
  /lib64/libc-2.14.1.so
7f0008f64000-7f0008f68000 r--p 00182000 08:22 2883622
  /lib64/libc-2.14.1.so
7f0008f68000-7f0008f69000 rw-p 00186000 08:22 2883622
  /lib64/libc-2.14.1.so
7f0008f69000-7f0008f6e000 rw-p 00000000 00:00 0
7f0008f6e000-7f0008fef000 r-xp 00000000 08:22 2883678
  /lib64/libm-2.14.1.so
7f0008fef000-7f00091ee000 ---p 00081000 08:22 2883678
  /lib64/libm-2.14.1.so
7f00091ee000-7f00091ef000 r--p 00080000 08:22 2883678
  /lib64/libm-2.14.1.so
7f00091ef000-7f00091f0000 rw-p 00081000 08:22 2883678
  /lib64/libm-2.14.1.so
7f00091f0000-7f00091f4000 r-xp 00000000 08:22 394806
  /lib64/libuuid.so.1.3.0
7f00091f4000-7f00093f3000 ---p 00004000 08:22 394806
  /lib64/libuuid.so.1.3.0
7f00093f3000-7f00093f4000 r--p 00003000 08:22 394806
  /lib64/libuuid.so.1.3.0
7f00093f4000-7f00093f5000 rw-p 00004000 08:22 394806
  /lib64/libuuid.so.1.3.0
7f00093f5000-7f0009415000 r-xp 00000000 08:22 2883603
  /lib64/ld-2.14.1.so
7f00095d1000-7f00095d4000 rw-p 00000000 00:00 0
7f0009612000-7f0009615000 rw-p 00000000 00:00 0
7f0009615000-7f0009616000 r--p 00020000 08:22 2883603
  /lib64/ld-2.14.1.so
7f0009616000-7f0009617000 rw-p 00021000 08:22 2883603
  /lib64/ld-2.14.1.so
7f0009617000-7f0009618000 rw-p 00000000 00:00 0
7fff70f01000-7fff70f23000 rw-p 00000000 00:00 0                          [stack]
7fff70fff000-7fff71000000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0
  [vsyscall]
Aborted
