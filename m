Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:34914 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbbJLCa7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 22:30:59 -0400
Received: by vkha6 with SMTP id a6so22161296vkh.2
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2015 19:30:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQNipL1u9YhAd9NBb+1uPvMxKid8Gc5JjyA1qabE6hZuQ@mail.gmail.com>
References: <CA+wwUFBKOxHSXOn9rcG+k5CTaKMPWGnx2a5dNo=CCfzawRLKGg@mail.gmail.com>
	<CAJCQCtQNipL1u9YhAd9NBb+1uPvMxKid8Gc5JjyA1qabE6hZuQ@mail.gmail.com>
Date: Mon, 12 Oct 2015 15:30:58 +1300
Message-ID: <CA+wwUFAyd_oqokmd=Aj+gZsCT3xWWxWnx05kpGvxSp3nDF6Ruw@mail.gmail.com>
Subject: Re: BTRFS with 8TB SMR drives
From: Warren Hughes <wsh@warrenhughes.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

more info for anyone interested:

[wsh@cloud ~]$ sudo btrfs fi df /mnt/media
Data, RAID1: total=13.64TiB, used=13.61TiB
System, RAID1: total=32.00MiB, used=2.22MiB
Metadata, RAID1: total=16.00GiB, used=15.10GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


[wsh@cloud ~]$ sudo btrfs fi sh /mnt/media
Label: none  uuid: 643c3145-8371-4011-8c34-20240e1bbaff
        Total devices 11 FS bytes used 13.63TiB
        devid    8 size 2.73TiB used 2.54TiB path /dev/sdh
        devid    9 size 2.73TiB used 2.54TiB path /dev/sdc
        devid   10 size 2.73TiB used 2.54TiB path /dev/sdf
        devid   11 size 1.82TiB used 1.63TiB path /dev/sdn
        devid   12 size 2.73TiB used 2.54TiB path /dev/sdg
        devid   14 size 2.73TiB used 2.54TiB path /dev/sda
        devid   15 size 2.73TiB used 2.54TiB path /dev/sdd
        devid   16 size 2.73TiB used 2.54TiB path /dev/sdk
        devid   17 size 2.73TiB used 2.54TiB path /dev/sdl
        devid   18 size 3.64TiB used 3.45TiB path /dev/sdm
        devid   19 size 7.28TiB used 1.93TiB path /dev/sdo

btrfs-progs v4.2.1

On 12 October 2015 at 14:43, Chris Murphy <lists@colorremedies.com> wrote:
> Is it possible to get a complete dmesg included in the thread, or if
> it's too big attach it to a bug report? I'm curious if there are any
> libata messages, as well as the specific Btrfs messages.
>
>
> ---
> Chris Murphy



-- 
Warren Hughes
+64 21 633324
IM: gtalk + msn: this email address, skype: akawsh
