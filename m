Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35335 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934510AbeF2Ldk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 07:33:40 -0400
Received: by mail-io0-f182.google.com with SMTP id q4-v6so8158235iob.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 04:33:40 -0700 (PDT)
Subject: Re: btrfs suddenly think's it's raid6
To: marble <marble@hamburg.ccc.de>, linux-btrfs@vger.kernel.org
References: <80f0c6f7-ede1-e522-551c-ec2446bb79ea@hamburg.ccc.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <35eb7f4b-0af1-66c6-a31e-ed7b5c00f384@gmail.com>
Date: Fri, 29 Jun 2018 07:33:37 -0400
MIME-Version: 1.0
In-Reply-To: <80f0c6f7-ede1-e522-551c-ec2446bb79ea@hamburg.ccc.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-06-29 07:04, marble wrote:
> Hello,
> I have an external HDD. The HDD contains no partition.
> I use the whole HDD as a LUKS container. Inside that LUKS is a btrfs.
> It's used to store some media files.
> The HDD was hooked up to a Raspberry Pi running up-to-date Arch Linux
> to play music from the drive.
> 
> After disconnecting the drive from the Pi and connecting it to my laptop
> again, I couldn't mount it anymore. If I read the dmesg right, it now
> thinks that it's part of a raid6.
> 
> btrfs check --repair also didn't help.
> 
> ```
> marble@archlinux ~ % uname -a
> Linux archlinux 4.17.2-1-ARCH #1 SMP PREEMPT Sat Jun 16 11:08:59 UTC
> 2018 x86_64 GNU/Linux
> 
> marble@archlinux ~ % btrfs --version
> btrfs-progs v4.16.1
> 
> marble@archlinux ~ % sudo cryptsetup open /dev/sda black
> [sudo] password for marble:
> Enter passphrase for /dev/sda:
> 
> marble@archlinux ~ % mkdir /tmp/black
> marble@archlinux ~ % sudo mount /dev/mapper/black /tmp/black
> mount: /tmp/black: can't read superblock on /dev/mapper/black.
> 
> marble@archlinux ~ % sudo btrfs fi show
> Label: 'black'  uuid: 9fea91c7-7b0b-4ef9-a83b-e24ccf2586b5
>          Total devices 1 FS bytes used 143.38GiB
>          devid    1 size 465.76GiB used 172.02GiB path /dev/mapper/black
> 
> marble@archlinux ~ % sudo btrfs check --repair /dev/mapper/black
> enabling repair mode
> Checking filesystem on /dev/mapper/black
> UUID: 9fea91c7-7b0b-4ef9-a83b-e24ccf2586b5
> Fixed 0 roots.
> checking extents
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found 1A9EFC07 wanted 204A6979
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> bytenr mismatch, want=1082114048, have=9385453728028469028
> owner ref check failed [1082114048 16384]
> repair deleting extent record: key [1082114048,168,16384]
> adding new tree backref on start 1082114048 len 16384 parent 0 root 5
> Repaired extent references for 1082114048
> ref mismatch on [59038556160 4096] extent item 1, found 0
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found 1A9EFC07 wanted 204A6979
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> bytenr mismatch, want=1082114048, have=9385453728028469028
> incorrect local backref count on 59038556160 root 5 owner 334393 offset
> 0 found 0 wanted 1 back 0x56348aee5de0
> backref disk bytenr does not match extent record, bytenr=59038556160,
> ref bytenr=0
> backpointer mismatch on [59038556160 4096]
> owner ref check failed [59038556160 4096]
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> checksum verify failed on 1082114048 found 1A9EFC07 wanted 204A6979
> checksum verify failed on 1082114048 found D7CA51C8 wanted E6334CB3
> bytenr mismatch, want=1082114048, have=9385453728028469028
> failed to repair damaged filesystem, aborting
> 
> marble@archlinux ~ % dmesg > /tmp/dmesg.log
> ```
> 
> Any clues?

It's not thinking it's a raid6 array.  All the messages before this one:

Btrfs loaded, crc32c=crc32c-intel

Are completely unrelated to BTRFS (because anything before that message 
happened before any BTRFS code ran).  The raid6 messages are actually 
from the startup code for the kernel's generic parity RAID implementation.

These:

BTRFS error (device dm-1): bad tree block start 9385453728028469028 
1082114048
BTRFS error (device dm-1): bad tree block start 2365503423870651471 
1082114048

Are the relevant error messages.  Unfortunately, I don't really know 
what's wrong in this case though.  Hopefully one of the developers will 
have some further insight.
