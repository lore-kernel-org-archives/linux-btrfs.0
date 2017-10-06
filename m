Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:52957 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbdJFKZ6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 06:25:58 -0400
Received: by mail-qt0-f194.google.com with SMTP id o52so30478279qtc.9
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Oct 2017 03:25:58 -0700 (PDT)
MIME-Version: 1.0
From: Nick Gilmour <nickeforos@gmail.com>
Date: Fri, 6 Oct 2017 12:25:17 +0200
Message-ID: <CAH-drow6AB9vu84DJGB90bbvE7DZnJ+eZOvJmxu9w1rHA5CrNA@mail.gmail.com>
Subject: "BTRFS error (device vda1): couldn't get super buffer head for bytenr x"
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have converted .vdi disk (BTRFS) into a .img disk, resized it from
500GB to 150GB and then copied into a ZFS Volume. I've imported the VM
into VMM and it started normally but an upgrade failed. I've rebooted
and  got only a blue screen something like a BSOD on Windows. I've
changed into a terminal and now this error appears constantly:

 "BTRFS error (device vda1): couldn't get super buffer head for bytenr x"

I can stop it shortly with Ctrl-C and enter a command. With startx I
can see my desktop in blue  color with some icons in it and nothing
more.


uname -a
Linux VM-Ubuntu 4.4.0-83-generic

btrfs --version
btrfs-progs v4.4

btrfs fi show
Label: none uuid: x
           Total devices 1 FS bytes used 473.68GiB
            devid 1 size 492.00 GiB used 492.00GiB path /dev/sda1

Label: 'extra' uuid: y
           Total devices 1 FS bytes used 112.00KiB
            devid 1 size 100.00 GiB used 2.02GiB path /dev/sdb1

btrfs fi df /home
Data, single: total=106.40GiB, used=96.42GiB
System, DUP: total=8.00MiB, used=48.00KiB
Metadata, DUP: total=14.88GiB, used=11.18GiB
GlobalReserve, single: total=512.00 MiB, used=0.00B

dmesg > dmesg.log
compiz: segfault at ... error 4 in libnux-graphics-4.0.so...


Any ideas?

Regards,
Nick
