Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35478 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdGaUcl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 16:32:41 -0400
Received: by mail-lf0-f66.google.com with SMTP id w199so13214967lff.2
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 13:32:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$3b64a$a9b921fc$3e4651f5$627d0636@cox.net>
References: <20170501170641.GG3516@merlins.org> <20170707163834.GA6083@merlins.org>
 <20170709043417.GE6704@merlins.org> <21425367.VGcO8ck7Vu@merkaba>
 <MEXPR01MB216863F67F4553F8564CC3CD9EA80@MEXPR01MB2168.ausprd01.prod.outlook.com>
 <pan$2b9aa$a4dca8a2$fc1e4ebe$a8fffbe3@cox.net> <CAK5rZE7sj+T8-x0q=wPXeHKN4zBZGc2Jhj9NYA7ZQcV+yk2XSA@mail.gmail.com>
 <pan$12269$5fb80e78$f5b26ca4$74a3427f@cox.net> <CAK5rZE6vMujb5KEqwUZD2-ZmZ4vi2T4+J2BzTLi9qqx8GeFKgg@mail.gmail.com>
 <pan$3b64a$a9b921fc$3e4651f5$627d0636@cox.net>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Mon, 31 Jul 2017 22:32:39 +0200
Message-ID: <CAK5rZE6urkaR7B8MxA_MB_e9PfNwDHuu_APnKCBZ+EVJrDo7bw@mail.gmail.com>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more
 recent gen (33682) compared to the found root node (0)
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>> Do you have any experience/advice/comment regarding dup data on ssds?

>>> Very good question. =:^)

>> Now the init on /boot is a "19 lines" shell script, including lines for
>> keymap, hdparm, crytpsetup. And let's not forget this is possible by a
>> custom kernel and its reliable buddy syslinux.
>
> FWIW...
> And I'm using dracut for that, tho quite cut down from its default, with
> a monolithic kernel and only installing necessary dracut modules.

Just create minimal bootable /boot for running below init.
(Your initramfs/rd is a bloated and packaged version of
this anyway.) Kick the rest. Since you a have your own
kernel you are not far away from it.


#!/bin/sh
# This is actually busybox ash or hush. Cant remember now.
# You may compile/customize your busybox as well. Easy.

mount proc /proc -t proc
mount sys  /sys  -t sysfs
mount run  /run  -t tmpfs
mkdir /dev/pts /dev/shm /run/lock
mount devpts /dev/pts -t devpts &
mount shm    /dev/shm -t tmpfs &
mount -o remount,rw,noatime / &

# '&' is for backgrounding/parallel_execution.
# Use responsibly double checking its side effects
# depending on your setup.

hdparm -B 254 /dev/sda &
loadkmap < /boot/trq.bkmap

cryptsetup -T 10 luksOpen /dev/sdXX sdXX
mount /dev/mapper/sdXX /mnt/new_root -t btrfs -o noatime,compress=lzo

cd /mnt/new_root
mount --move /dev  ./dev
mount --move /proc ./proc
mount --move /sys  ./sys
mount --move /run  ./run
pivot_root . boot

exec chroot . busybox init
# Jump to your real roots init. Whatever it may be.


> But particularly after the last dracut update pulled in kmod as a
> mandatory dep as it now links against its libs, despite my monolithic
> kernel built without module support, I've been considering similar initr*
> alternatives, including hand-rolling my own initr* build scripts.
>
> Because I'm still not happy having to run an initr* at all, especially
> since there's more "magic" there than I'm particularly comfortable with
> since I like to grok the boot and thus potential recovery process better
> than I do this, and dracut was just the most convenient option at the
> time.

>> Interestingly my seach for reliability started with "dup data" and ended
>> up here. :)
> =:^)
