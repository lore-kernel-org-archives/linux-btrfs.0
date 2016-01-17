Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36469 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbcAQTyt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 14:54:49 -0500
Received: by mail-qk0-f172.google.com with SMTP id b66so11873734qkf.3
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Jan 2016 11:54:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADrfcdae8Z7towaXpuA=dtq-GP-hMxJZp69UP5TayH20_ZMvBw@mail.gmail.com>
References: <CADrfcdae8Z7towaXpuA=dtq-GP-hMxJZp69UP5TayH20_ZMvBw@mail.gmail.com>
From: bbrendon@gmail.com
Date: Sun, 17 Jan 2016 11:54:09 -0800
Message-ID: <CADrfcdYnCkbdHs9EmmvC3WoRPm_O3WnZRiCwcqKM2X3tFv8V-Q@mail.gmail.com>
Subject: Re: kernel crash when balancing raid56 after low on space
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was able to get this issue resolved.

I think the key to realize is that when mounting with skip_balance,
that doesn't actually disable/cancel the balance. You still have to
run the 'btrfs balance cancel FS' command. Once I did this, I was able
to mount the FS without the crashing. For some reason a balance resume
was casing the crashes.

I then did a balance dusage=5, and then a full balance. The full
balance has been running for a day so I'm guessing it'll finish
successfully in a few more days.

On Thu, Jan 14, 2016 at 11:03 PM,  <bbrendon@gmail.com> wrote:
> Looking for a bit of help getting this FS balanced. I'm getting a
> kernel crash and readonly file system error:
> [ 9357.096562] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
>
> dmesg output. http://pastebin.com/c9xKvpZ0
>
> This problem began because of performance issues. Basically the FS
> appeared to be hung. (I think because it got to about 100GB free) I
> added a drive and started a rebalance which somehow also hung. I then
> aborted the whole thing, upgraded from 4.3 to 4.4 and after a long
> wait the FS mounted. I deleted more snaps and now when I start a
> balance, the FS goes read-only.
>
> Thanks for any help you can provide! -Brendon
>
> # uname -a
> Linux humvee 4.4.0 #1 SMP Thu Jan 14 15:54:03 PST 2016 x86_64 GNU/Linux
>
> #  btrfs --version
> btrfs-progs v4.3
> #
>
> # btrfs fi show
> Label: 'tank0'  uuid: d25217dd-91f1-4add-8c07-66eacff9fb28
>         Total devices 6 FS bytes used 6.22TiB
>         devid    1 size 3.64TiB used 3.52TiB path /dev/sdc
>         devid    2 size 3.64TiB used 3.52TiB path /dev/sdd
>         devid    3 size 3.64TiB used 3.52TiB path /dev/sde
>         devid    4 size 3.64TiB used 3.52TiB path /dev/sdf
>         devid    5 size 3.64TiB used 3.52TiB path /dev/sdg
>         devid    6 size 3.64TiB used 1.00GiB path /dev/sdh
>
> btrfs-progs v4.3
> #
> #  btrfs fi df /tank0
> Data, RAID6: total=10.55TiB, used=6.21TiB
> System, RAID6: total=96.00MiB, used=880.00KiB
> Metadata, RAID6: total=19.59GiB, used=10.34GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> #
