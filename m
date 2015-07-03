Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f42.google.com ([209.85.216.42]:45505 "EHLO
	mail-vn0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbbGCSET (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 14:04:19 -0400
Received: by vnbg7 with SMTP id g7so16831909vnb.12
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2015 11:04:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG+QAKUuwVSr8wibFi3zdwu1gR72YEjXEV1JFK126juWzDFvDg@mail.gmail.com>
References: <CAG+QAKX1eSmarBn+YXq5dkZ0zTWsSDM6cfwTtDg-43-nTRSXWQ@mail.gmail.com>
	<CAC=t97Dy57JMBZ-exzCytMMUUhrV_zh7W9L+fQR_G_LOqfhWhA@mail.gmail.com>
	<CAG+QAKWZ-jTGkK7btiHziDf9LhW31QUSFbJ9DpLy1xqmk7vUCQ@mail.gmail.com>
	<CAG+QAKW1ZH_6AN3CSmXxiQr9xmR_ha=erfruSHxvKYKH6w3WiA@mail.gmail.com>
	<CAG+QAKUuwVSr8wibFi3zdwu1gR72YEjXEV1JFK126juWzDFvDg@mail.gmail.com>
Date: Fri, 3 Jul 2015 12:04:18 -0600
Message-ID: <CAJCQCtQmppYhavcOcef2Nv3ZmpVYe+4b6LLSAvfAMdCD5bTvGw@mail.gmail.com>
Subject: Re: btrfs full, but not full, can't rebalance
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What kernel version are you using?

I suggest reading the whole thread but in particular this note about
CentOS 7 and Btrfs.
http://www.spinics.net/lists/linux-btrfs/msg40850.html

So kernel 3.16 isn't necessarily too old, but I know there's been a
lot of on-going balance related work that's not in that kernel and
thus won't be in the CentOS 7.1 kernel either. And then there's also
some possibility the older btrfs-progs contributes to the problem,
even though I think most of the balance code is actually in the
kernel.

While the CentOS 7.1 kernel is going to be more stable/predictable
overall (not with respect to Btrfs but everything the kernel does):
a.) Btrfs is a tech preview
b.) To unwind the problems you've having with this volume right now,
I'd really suggest a much newer kernel.

>         Total devices 2 FS bytes used 17.06GiB
>         devid    1 size 111.11GiB used 22.03GiB path /dev/sdf3
>         devid    2 size 111.11GiB used 22.03GiB path /dev/sdg3

There's tons of unallocated space for new data or metadata chunks.

> Data, RAID1: total=18.00GiB, used=16.36GiB
> System, RAID1: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=4.00GiB, used=711.34MiB
> GlobalReserve, single: total=240.00MiB, used=128.00KiB
> ERROR: error during balancing '/' - No space left on device

And there's tons of space in already created data and metadata chunks.
So something is wrong, and I really wouldn't persist on trying to make
this work with an older kernel and progs. So I suggest putting the
volume on a system with a 4.1 kernel and 4.1 progs, and running a
btrfs check without --repair and report back with the full output.

Once you get things fixed up, it seems going back to the CentOS 7.1
kernel is fine. But periodically you might have to revert to a newer
kernel for some maintenance, at least until the fix for the problem
makes it into a future CentOS kernel.


Chris Murphy
