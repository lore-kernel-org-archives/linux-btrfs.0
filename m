Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35638 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbbGCFps (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 01:45:48 -0400
Received: by obbop1 with SMTP id op1so63401357obb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2015 22:45:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG+QAKX1eSmarBn+YXq5dkZ0zTWsSDM6cfwTtDg-43-nTRSXWQ@mail.gmail.com>
References: <CAG+QAKX1eSmarBn+YXq5dkZ0zTWsSDM6cfwTtDg-43-nTRSXWQ@mail.gmail.com>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Fri, 3 Jul 2015 00:45:28 -0500
Message-ID: <CAC=t97Dy57JMBZ-exzCytMMUUhrV_zh7W9L+fQR_G_LOqfhWhA@mail.gmail.com>
Subject: Re: btrfs full, but not full, can't rebalance
To: Rich Rauenzahn <rrauenza@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Have you seen this article?

I think the interesting part for you is the "balance cannot run
because the filesystem is full" heading.

http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html

On Fri, Jul 3, 2015 at 12:32 AM, Rich Rauenzahn <rrauenza@gmail.com> wrote:
> Running on CentOS7 ... / got full, I removed the files, but it still
> thinks it is full.  I've tried following the FAQ, even adding a
> loopback device during the rebalance.
>
> # btrfs fi show /
> Label: 'centos7'  uuid: 35f0ce3f-0902-47a3-8ad8-86179d1f3e3a
>         Total devices 2 FS bytes used 24.27GiB
>         devid    1 size 111.11GiB used 111.05GiB path /dev/sdf3
>         devid    2 size 111.11GiB used 111.05GiB path /dev/sdg3
>
> # btrfs fi df /
> Data, RAID1: total=107.02GiB, used=22.12GiB
> System, RAID1: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=4.05GiB, used=2.15GiB
> GlobalReserve, single: total=512.00MiB, used=0.00
>
> # btrfs balance start -v -dusage=1 /
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=1
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
>
> # btrfs balance start -m /
> ERROR: error during balancing '/' - No space left on device
> There may be more info in syslog - try dmesg | tail
>
> What can I do?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
