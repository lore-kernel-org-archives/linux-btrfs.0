Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:34382 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbbH0QX3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 12:23:29 -0400
Received: by vkm66 with SMTP id 66so11696692vkm.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 09:23:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGAq4WGf475k4oN6+MHrOfnKNdeLsHQE1WfKQAkwPxOH3=9-cw@mail.gmail.com>
References: <CAGAq4WGf475k4oN6+MHrOfnKNdeLsHQE1WfKQAkwPxOH3=9-cw@mail.gmail.com>
Date: Thu, 27 Aug 2015 10:23:29 -0600
Message-ID: <CAJCQCtTxrBXxi3UQVXqPbXeRQobsvdZq9rsnyVioKQ0nNCZNsw@mail.gmail.com>
Subject: Re: Meta data full on a Readynas
From: Chris Murphy <lists@colorremedies.com>
To: Mike Aubury <mike@aubit.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 27, 2015 at 4:02 AM, Mike Aubury <mike@aubit.com> wrote:
> Hi,
> Wondering if anyone can help me.
> I've got a readynas which uses btrfs - and the meta data is full.
>
> root@ReadyNAS:~# uname -a
> Linux ReadyNAS 3.0.101.RN_ARM.4 #1 Mon Jun 29 19:02:35 PDT 2015 armv7l GNU/Linux
> root@ReadyNAS:~#   btrfs --version
> Btrfs v3.17.3
> root@ReadyNAS:~#   btrfs fi show
> Label: '0e36d290:data'  uuid: e75a9856-d9e5-4d02-92e6-a217056c69b7
>         Total devices 3 FS bytes used 5.88TiB
>         devid    1 size 2.71TiB used 2.71TiB path /dev/md127
>         devid    2 size 1.82TiB used 1.82TiB path /dev/md126
>         devid    3 size 1.82TiB used 1.82TiB path /dev/md125
>
> Btrfs v3.17.3
> root@ReadyNAS:~#   btrfs fi df /data
> Data, single: total=6.33TiB, used=5.87TiB
> System, RAID1: total=32.00MiB, used=768.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=9.00GiB, used=8.98GiB
> Metadata, DUP: total=3.00GiB, used=2.12GiB
>
>
> At some point (I dont know if its btrfs, or some Readynas process) -
> the filesystem goes readyonly.
> This seems to scupper most attempts at fixing things.
>
> I've tried all sorts,I've tried deleting off files - but - when the
> machine reboots they re-appear, various different "btrfs balance" type
> commands - they seem to exit because of lack of free space - eg
>
> # btrfs  balance start /data -dlimit=3 -v
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x20): balancing, limit=3
> ERROR: error during balancing '/data' - No space left on device
> There may be more info in syslog - try dmesg | tail
> # dmesg | tail
> BTRFS error (device md125) in __btrfs_free_extent:5648: errno=-28 No space left
> BTRFS info (device md125): forced readonly
> BTRFS debug (device md125): run_one_delayed_ref returned -28
> BTRFS error (device md125) in btrfs_run_delayed_refs:2688: errno=-28
> No space left
> BTRFS error (device md125) in __btrfs_free_extent:5648: errno=-28 No space left
> BTRFS debug (device md125): run_one_delayed_ref returned -28
> BTRFS error (device md125) in btrfs_run_delayed_refs:2688: errno=-28
> No space left
> BTRFS error (device md125) in __btrfs_free_extent:5648: errno=-28 No space left
> BTRFS debug (device md125): run_one_delayed_ref returned -28
> BTRFS error (device md125) in btrfs_run_delayed_refs:2688: errno=-28
> No space left
>
>
>
> Nothing seems to fix it, every time I reboot - I get the same 8.98GB
> used out of 9GB
>
> I tried the readynas forum - the advice seemed to be wipe the device
> and start again...
>
>
> Any suggestion before I just wipe the /data and start again ?

First umount then remount, because it needs to be rw first. If you
can't get it to mount rw, then it's stuck.

Next, connect a USB stick that's already erased (wipefs -a on each
partition and whole block device), then add the whole block device.
Ideally it's small, around 2-8GB, you can partition it if it's a large
USB stick.

btrfs dev add /dev/<usbstick> /data
btrfs balance start /data
btrfs dev delete /dev/<usbstick> /data

You could use filters, such as -dusage=0 or -dusage=15 to make it go a
bit faster. Realize that some fs metadata will end up on the USB
stick, so don't remove it until the dev delete completes and fi show
lists that it's not part of the volume anymore.

-- 
Chris Murphy
