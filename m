Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:33605 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3IJREV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 13:04:21 -0400
Received: by mail-la0-f48.google.com with SMTP id er20so6457604lab.35
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Sep 2013 10:04:20 -0700 (PDT)
MIME-Version: 1.0
Reply-To: d.j.oriley@gmail.com
Date: Tue, 10 Sep 2013 18:04:20 +0100
Message-ID: <CAGt=4JxkC0Y0wue6iHHVMhRc7ZNPK0EMBoxfddqpFmi4Z94Aig@mail.gmail.com>
Subject: btrfs-error
From: "David O'Riley" <d.j.oriley@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have been using ubuntu-gnome 13.04 for a couple of week with no
issue. After a power failure my system fails to boot, error in rootfs.

If I boot from a live CD and try to mount /dev/sda6 the system crashed.

I have also tried btrfsck /dev/sda6 which gives the below error,

root@eeePC:/# btrfsck /dev/sda6
checking extents
checking fs roots
checking root refs
*** Error in `btrfsck': double free or corruption (!prev): 0x09bd1a00 ***
======= Backtrace: =========
/lib/i386-linux-gnu/libc.so.6(+0x767e2)[0xb762d7e2]
/lib/i386-linux-gnu/libc.so.6(+0x77530)[0xb762e530]
btrfsck[0x8054c83]
btrfsck[0x80499b3]
/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0xb75d0935]
btrfsck[0x8049ac5]
======= Memory map: ========
08048000-08074000 r-xp 00000000 08:11 766828     /sbin/btrfsck
08074000-08075000 r--p 0002b000 08:11 766828     /sbin/btrfsck
08075000-08076000 rw-p 0002c000 08:11 766828     /sbin/btrfsck
09bc0000-2914e000 rw-p 00000000 00:00 0          [heap]
b7585000-b75a0000 r-xp 00000000 08:11 256588
/lib/i386-linux-gnu/libgcc_s.so.1
b75a0000-b75a1000 r--p 0001a000 08:11 256588
/lib/i386-linux-gnu/libgcc_s.so.1
b75a1000-b75a2000 rw-p 0001b000 08:11 256588
/lib/i386-linux-gnu/libgcc_s.so.1
b75b5000-b75b7000 rw-p 00000000 00:00 0
b75b7000-b7764000 r-xp 00000000 08:11 256574
/lib/i386-linux-gnu/libc-2.17.so
b7764000-b7766000 r--p 001ad000 08:11 256574
/lib/i386-linux-gnu/libc-2.17.so
b7766000-b7767000 rw-p 001af000 08:11 256574
/lib/i386-linux-gnu/libc-2.17.so
b7767000-b776a000 rw-p 00000000 00:00 0
b776a000-b776e000 r-xp 00000000 08:11 256653
/lib/i386-linux-gnu/libuuid.so.1.3.0
b776e000-b776f000 r--p 00003000 08:11 256653
/lib/i386-linux-gnu/libuuid.so.1.3.0
b776f000-b7770000 rw-p 00004000 08:11 256653
/lib/i386-linux-gnu/libuuid.so.1.3.0
b7782000-b7785000 rw-p 00000000 00:00 0
b7785000-b7786000 r-xp 00000000 00:00 0          [vdso]
b7786000-b77a6000 r-xp 00000000 08:11 256563     /lib/i386-linux-gnu/ld-2.17.so
b77a6000-b77a7000 r--p 0001f000 08:11 256563     /lib/i386-linux-gnu/ld-2.17.so
b77a7000-b77a8000 rw-p 00020000 08:11 256563     /lib/i386-linux-gnu/ld-2.17.so
bfbb6000-bfbd7000 rw-p 00000000 00:00 0          [stack]
Aborted (core dumped)

Is there anything you would advise to try next?

Dave.
