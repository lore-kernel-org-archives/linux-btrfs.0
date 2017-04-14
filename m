Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:36003 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752152AbdDNTvW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Apr 2017 15:51:22 -0400
Received: by mail-pg0-f48.google.com with SMTP id g2so46868157pge.3
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 12:51:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRbkt=o6doBd0ZG0XZfrhP4pBQsPCp573LiZU2RSZvuVQ@mail.gmail.com>
References: <CAPktuGu9HqL=0VS+apM9r6CSRbxBcZzX5=HmF1K_51wYHyRbiw@mail.gmail.com>
 <CAJCQCtRbkt=o6doBd0ZG0XZfrhP4pBQsPCp573LiZU2RSZvuVQ@mail.gmail.com>
From: Alexandru Guzu <alexguzu@gmail.com>
Date: Fri, 14 Apr 2017 15:51:20 -0400
Message-ID: <CAPktuGsM6=yA8bjv-a5zWKdxm9jb7roUTNA+Mw-D0jJ_HRauDw@mail.gmail.com>
Subject: Re: Remounting read-write after error is not allowed
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the reply.

I mounted it ro:
    $ sudo btrfs fi show /mnt
    Segmentation fault (core dumped)

dmesg says:
...
kernel BUG at /build/linux-wXdoVv/linux-4.4.0/fs/btrfs/ctree.c:5205!
...
RIP: 0010:[<ffffffffc0371b98>]  [<ffffffffc0371b98>]
btrfs_search_forward+0x268/0x350 [btrfs]
...
Call Trace:
    [<ffffffffc03cabb2>] search_ioctl+0xf2/0x1c0 [btrfs]
    [<ffffffff811afc4c>] ? zone_statistics+0x7c/0xa0
    [<ffffffffc03cacf2>] btrfs_ioctl_tree_search+0x72/0xc0 [btrfs]
    [<ffffffffc03ce1b5>] btrfs_ioctl+0x455/0x28b0 [btrfs]
    [<ffffffff8120274b>] ? mem_cgroup_try_charge+0x6b/0x1e0
    [<ffffffff811c1a5d>] ? handle_mm_fault+0xcad/0x1820
    [<ffffffff81222caf>] do_vfs_ioctl+0x29f/0x490
    [<ffffffff8106b544>] ? __do_page_fault+0x1b4/0x400
    [<ffffffff81222f19>] SyS_ioctl+0x79/0x90
    [<ffffffff8183c672>] entry_SYSCALL_64_fastpath+0x16/0x71
...

full dmesg output is at:
pastebin.com/bhsEJiJN

$ sudo btrfs fi df /mnt
Data, single: total=236.01GiB, used=230.35GiB
System, DUP: total=8.00MiB, used=48.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=1.00GiB, used=349.11MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=128.00MiB, used=0.00B

I downloaded and compiled the current btrfs v4.10.1-9-gbd0ab27.

sudo ./btrfs check /dev/sdh2
    Checking filesystem on /dev/sdh2
    UUID: 227fbb6c-ae72-4b81-8e65-942a0ddc6ef7
    checking extents
    checking free space cache
    checking fs roots
    checking csums
    checking root refs
    found 247628603392 bytes used, no error found
    total csum bytes: 241513756
    total tree bytes: 366084096
    total fs tree bytes: 90259456
    total extent tree bytes: 10010624
    btree space waste bytes: 35406538
    file data blocks allocated: 23837459185664
     referenced 252963553280

and with lowmem mode (again no errors found):
./btrfs check /dev/sdh2 --mode=lowmem
    Checking filesystem on /dev/sdh2
    UUID: 227fbb6c-ae72-4b81-8e65-942a0ddc6ef7
    checking extents
    checking free space cache
    checking fs roots
    checking csums
    checking root refs
    found 247738298368 bytes used, no error found
    total csum bytes: 241513756
    total tree bytes: 366084096
    total fs tree bytes: 90259456
    total extent tree bytes: 10010624
    btree space waste bytes: 35406538
    file data blocks allocated: 23837459185664
     referenced 252963553280

maybe there is some hint in that segmentation fault?
Also, I compiled from
git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git but I
did not get version 4.10.1 instead of 4.10.2

Regards,

On Fri, Apr 14, 2017 at 1:17 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Can you ro mount it and:
>
> btrfs fi show /mnt
> btrfs fi df /mnt
>
> And then next update the btrfs-progs to something newer like 4.9.2 or
> 4.10.2 and then do another 'btrfs check' without repair. And then
> separately do it again with --mode=lowmem and post both sets of
> results?
>
>
> Chris Murphy
