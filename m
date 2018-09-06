Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34427 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbeIFTlU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 15:41:20 -0400
Received: by mail-oi0-f42.google.com with SMTP id 13-v6so21214305ois.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2018 08:05:23 -0700 (PDT)
MIME-Version: 1.0
References: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
In-Reply-To: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
From: Stefan Loewen <stefan.loewen@gmail.com>
Date: Thu, 6 Sep 2018 17:04:41 +0200
Message-ID: <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
Subject: Re: btrfs send hung in pipe_wait
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update:
It seems like btrfs-send is not completely hung. It somewhat regularly
wakes up every hour to transfer a few bytes. I noticed this via a
periodic 'ls -l' on the snapshot file. These are the last outputs
(uniq'ed):

-rw------- 1 root root 1492797759 Sep  6 08:44 intenso_white.snapshot
-rw------- 1 root root 1493087856 Sep  6 09:44 intenso_white.snapshot
-rw------- 1 root root 1773825308 Sep  6 10:44 intenso_white.snapshot
-rw------- 1 root root 1773976853 Sep  6 11:58 intenso_white.snapshot
-rw------- 1 root root 1774122301 Sep  6 12:59 intenso_white.snapshot
-rw------- 1 root root 1774274264 Sep  6 13:58 intenso_white.snapshot
-rw------- 1 root root 1774435235 Sep  6 14:57 intenso_white.snapshot

I also monitor the /proc/3022/task/*/stack files with 'tail -f' (I
have no idea if this is useful) but there are no changes, even during
the short wakeups.
Am Do., 6. Sep. 2018 um 11:22 Uhr schrieb Stefan Löwen
<stefan.loewen@gmail.com>:
>
> Hello linux-btrfs,
>
> I'm trying to clone a subvolume with 'btrfs send' but it always hangs
> for hours.
>
> I tested this on multiple systems. All showed the same result:
> - Manjaro (btrfs-progs v4.17.1; linux v4.18.5-1-MANJARO)
> - Ubuntu 18.04 in VirtualBox (btrfs-progs v4.15.1; linux v4.15.0-33-generic)
> - ArchLinux in VirtualBox (btrfs-progs v4.17.1; linux v4.18.5-arch1-1-ARCH)
> All following logs are from the ArchLinux VM.
>
> To make sure it's not the 'btrfs receive' at fault I tried sending into
> a file using the following command:
> 'strace -o btrfs-send.strace btrfs send -vvv -f intenso_white.snapshot
> /mnt/intenso_white/@data/.snapshots/test-snapshot'
>
> The 'btrfs send' process always copies around 1.2-1.4G of data, then
> stops all disk IO and fully loads one cpu core. btrfs scrub found 0
> errors. Neither did btrfsck. 'btrfs device stats' is all 0.
>
> I would be thankful for all ideas and tips.
>
> Regards
> Stefan
>
> ---------------------------------------------
>
> The btrfs-send.strace is attached. So is the dmesg.log during the hang.
>
> Stack traces of the hung process:
> --- /proc/3022/task/3022/stack ---
> [<0>] 0xffffffffffffffff
> --- /proc/3022/task/3023/stack ---
> [<0>] pipe_wait+0x6c/0xb0
> [<0>] splice_from_pipe_next.part.3+0x24/0xa0
> [<0>] __splice_from_pipe+0x43/0x180
> [<0>] splice_from_pipe+0x5d/0x90
> [<0>] default_file_splice_write+0x15/0x20
> [<0>] __se_sys_splice+0x31b/0x770
> [<0>] do_syscall_64+0x5b/0x170
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [<0>] 0xffffffffffffffff
>
> [vagrant@archlinux mnt]$ uname -a
> Linux archlinux 4.18.5-arch1-1-ARCH #1 SMP PREEMPT Fri Aug 24 12:48:58
> UTC 2018 x86_64 GNU/Linux
>
> [vagrant@archlinux mnt]$ btrfs --version
> btrfs-progs v4.17.1
>
> [vagrant@archlinux mnt]$ sudo btrfs fi show /dev/sdb1
> Label: 'intenso_white'  uuid: 07bf61ed-7728-4151-a784-c4b840e343ed
> Total devices 1 FS bytes used 655.82GiB
> devid    1 size 911.51GiB used 703.09GiB path /dev/sdb1
>
> [vagrant@archlinux mnt]$ sudo btrfs fi df /mnt/intenso_white/
> Data, single: total=695.01GiB, used=653.69GiB
> System, DUP: total=40.00MiB, used=96.00KiB
> Metadata, DUP: total=4.00GiB, used=2.13GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
