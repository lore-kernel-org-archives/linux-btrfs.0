From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:806
Date: Thu, 02 Dec 2010 11:19:56 -0500
Message-ID: <1291306746-sup-1916@think>
References: <201012011411.02352.johannes.hirte@fem.tu-ilmenau.de>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <201012011411.02352.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Johannes Hirte's message of 2010-12-01 08:11:01 -0500:
> On one of my machines with btrfs I got this bug:
> 
> entry offset 29085974528, bytes 4096, bitmap no
> entry offset 29162995712, bytes 20480, bitmap yes
> entry offset 29171744768, bytes 4096, bitmap no
> block group has cluster?: no
> 0 blocks of free space at or bigger than bytes is
> block group 29834084352 has 1073741824 bytes, 1072648192 used 0 pinned 0 reserved

Well, you've had an ENOSPC explosion.

> 
> The "block group" messages where way more, too much for the dmesg log buffer.
> Kernel is a 2.6.37-rc3+ without the latest btrfs-fixes. The bug occurred when
> compiling openoffice.org. After the bug a 'df -h' showed:
> 
> df -h:
> Filesystem            Size  Used Avail Use% Mounted on
> rootfs                 21G   17G  770M  96% /
> /dev/root              21G   17G  770M  96% /
> rc-svcdir             1.0M  108K  916K  11% /lib/rc/init.d
> udev                   10M  116K  9.9M   2% /dev
> shm                  1013M     0 1013M   0% /dev/shm
> /dev/sda2              66G   46G   20G  71% /home
> /dev/sdb1              75G   56G   19G  75% /mnt/windows

Which of these filesystems were you compiling on?

-chris
