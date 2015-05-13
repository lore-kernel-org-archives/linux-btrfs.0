Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:44068 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516AbbEMK7h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 06:59:37 -0400
Message-ID: <55532EA4.2080907@skagestad.org>
Date: Wed, 13 May 2015 12:59:48 +0200
From: =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>
MIME-Version: 1.0
To: David Alcorn <nroclaed@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Failed RAID0=> RAID1 Conversion
References: <CALq5X_g0jOkeS-R0ah0zyV8tQ8AH38skV_os2_JOo3hYNQ+H9A@mail.gmail.com>
In-Reply-To: <CALq5X_g0jOkeS-R0ah0zyV8tQ8AH38skV_os2_JOo3hYNQ+H9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13. mai 2015 12:47, David Alcorn wrote:
> I run Debian Jessie with a kernel upgrade to 4.0.0 from the Debian
> experimental repository.  My BTRFS-Tools remain at 3.17.-1  I wanted
> to convert a RAID0 array on /dev/sdb3 and /dev sdc3  from RAID0  to
> RAID1 so I ran the commands:
>
> 	mount /dev/sdb3 /mnt
> 	btrfs device add -f /dev/sdc3 /mnt
> 	btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt
>
> All appeared well with output similar to "395 of 395 chunks converted"
> but I think nothing happened.  The array contains a subvolume @export
> with size (per "du -sh @export") of  442G.  The pertinent output from
> "btrfs filesystem show" reports:
>
> 	Label: none  uuid: 647eb0f8-7732-40bc-a4a4-0d1b31a8ae16	
> 		Total devices 2 FS bytes used 443.05GiB
> 		devid    1 size 1.36TiB used 223.03GiB path /dev/sdb3
> 		devid    2 size 1.36TiB used 223.03GiB path /dev/sdc3
>
> My array remains RAID0 if I understand the above output correctly.
> This output persist through a reboot and no data was lost.  Where did
> I err?

For info about raid levels, use "btrfs filesystem df <mount point>"
It should give you something like this:
Data, RAID1: total=12.97GiB, used=12.28GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=1.00GiB, used=334.53MiB
GlobalReserve, single: total=112.00MiB, used=0.00B

--
Torbjørn
