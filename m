Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35357 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbcEaHmk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 03:42:40 -0400
Received: by mail-io0-f176.google.com with SMTP id p64so84483837ioi.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 May 2016 00:42:39 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAMbyGOMdgMKK=ttSR0NujhdbnitMwU+4+ebH6z5YW4U=zxnxtQ@mail.gmail.com>
References: <CAMbyGOMdgMKK=ttSR0NujhdbnitMwU+4+ebH6z5YW4U=zxnxtQ@mail.gmail.com>
Date: Tue, 31 May 2016 08:42:39 +0100
Message-ID: <CAL3q7H6PYmevJ03QXa_hWcj-Yjfhj3hyqdZRXPOL+numT-jGSA@mail.gmail.com>
Subject: Re: Runaway SLAB usage by 'bio' during 'device replace'
From: Filipe Manana <fdmanana@gmail.com>
To: Chris Johnson <hittingsmoke@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 30, 2016 at 7:48 PM, Chris Johnson <hittingsmoke@gmail.com> wrote:
> I have a RAID6 array that had a failed HDD. The drive failed
> completely and has been removed from the system. I'm running a 'device
> replace' operation with a new disk. The array is ~20TB so this will
> take a few days.
>
> Yesterday the system crashed hard with OOM errors about 24 hours into
> the replace. Rebooting after the crash and remounting the array
> automatically resumed the replace where it left off.
>
> Today I kept a close eye on it and have watched the memory usage creep
> up slowly.
>
> htop says this is user process memory (green bar) but shows no user
> processes using this much memory
>
> free says this is almost entirely cached/buffered memory that is
> taking up the space.
>
> slabtop reveals that there is a highly unusual amount of SLAB going to
> 'bio' which has to do with block allocation apparently. slabtop output
> is attached.
>
> 'sync && echo 3 > /proc/sys/vm/drop_caches' clears the high usage
> (~4GB) from dentry but 'bio' does not release any (11GB) memory and
> continues to grow slowly.

Probably you are experiencing a leak that was recently fixed and, at
the moment, available only in the 4.7-rc1 kernel:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=4673272f43ae790ab9ec04e38a7542f82bb8f020

>
> This is running the Rockstor distro based on CentOS. The system has 16GB of RAM.
>
> Kernel: 4.4.5-1.el7.elrepo.x86_64
> btrfs-progs: 4.4.1
>
> Kernel messages aren't showing anything of note during the replace
> until it starts throwing out OOM errors.
>
> I would like to collect enough information for a useful bug report
> here, but I also can't babysit this rebuild during the work week and
> reboot it once a day for OOM crashes. Should I cancel the replace
> operation and use 'dev delete missing' instead? Will using 'delete
> missing' cause any problem if it's done after a partially completed
> and canceled replace?



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
