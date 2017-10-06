Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:47582 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdJFHLE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 03:11:04 -0400
Received: by mail-qk0-f171.google.com with SMTP id m189so12964877qke.4
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Oct 2017 00:11:04 -0700 (PDT)
MIME-Version: 1.0
From: Nick Gilmour <nickeforos@gmail.com>
Date: Fri, 6 Oct 2017 09:10:23 +0200
Message-ID: <CAH-drozmzhkB+M5r2XUYp-v80XBMGqZUMc23x=T7vORKCrOFhA@mail.gmail.com>
Subject: "No space left on device"
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm getting an error "No space left on device" on a VM in VirtualBox.
It started as I was trying to convert the .vdi to .img. I wanted to
shrink the size of the disk first and I followed the steps from here:
https://superuser.com/questions/529149/how-to-compact-virtualboxs-vdi-file-size#529183

and then I got the error:
$ dd if=/dev/zero of=/tmp/bigemptyfile bs=4096k
dd: error writing '/tmp/bigemptyfile': No space left on device
94174+0 records in
94173+0 records out
394990190592 bytes (395 GB, 368 GiB) copied, 685.984 s, 576 MB/s
$ rm /tmp/bigemptyfile

After I rebooted I got only a terminal prompt, no desktop environment,
and I couldn't start it with startx (not even bash completion doesn't
work).

I have tried with balancing following the steps from here:
https://unix.stackexchange.com/questions/174446/btrfs-error-error-during-balancing-no-space-left-on-device

but I keep getting:
"Done, had to relocate 0 out of XX chunks"
regardless of the increase of the dusage parameter.


Debug information (Copy & Paste was not possible, some text is missing...):

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
Data, single: total=462.23GiB, used=462.23GiB
System, DUP: total=8.00MiB, used=80.00KiB
GlobalReserve, single: total=512.00 MiB, used=160.00KiB

dmesg > dmesg.log
dmesg: write failed: No space left on device
dmesg: write error


Any ideas how can I fix this?
Thanks.

Regards,
Nick
