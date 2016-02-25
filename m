Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:40399 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbcBYSID (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 13:08:03 -0500
Subject: Re: btrfs raid1 filesystem on sdcard corrupted
To: Hegner Robert <rhegner@hsr.ch>, linux-btrfs@vger.kernel.org
References: <nandur$4li$1@ger.gmane.org> <56CF3D78.90705@hsr.ch>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <56CF4301.9090601@bouton.name>
Date: Thu, 25 Feb 2016 19:08:01 +0100
MIME-Version: 1.0
In-Reply-To: <56CF3D78.90705@hsr.ch>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 25/02/2016 18:44, Hegner Robert a écrit :
> Am 25.02.2016 um 18:34 schrieb Hegner Robert:
>> Hi all!
>>
>> I'm working on a embedded system (ARM) running from a SDcard.

>From experience, most SD cards are not to be trusted. They are not
designed for storing an operating system and application data but for
storing pictures and videos written on a VFAT...

>> Recently I
>> switched to a btrfs-raid1 configuration, hoping to make my system more
>> resistant against power failures and flash-memory specific problems.

Note that there's no gain against power failures with RAID1.

>>
>> However today one of my devices wouldn't mount my root filesystem as rw
>> anymore.
>>
>> The main reason I'm asking in this mailing list is not that I want to
>> restory data. But I'd like to understand what happened and, even more
>> importantly, find out what I have to do so that something like this will
>> never happen again.
>>
>> Here is some info about my system:
>>
>> root@ObserverOne:~# uname -a
>> Linux ObserverOne 3.16.0-4-armmp #1 SMP Debian 3.16.7-ckt11-1+deb8u6
>> (2015-11-09) armv7l GNU/Linux

This is a very old kernel considering BTRFS code is moving fast. But in
this instance this is not your problem.

>>
>> root@ObserverOne:~# btrfs --version
>> Btrfs v3.17
>>
>> root@ObserverOne:~# btrfs fi show
>> Label: none  uuid: eef07fbf-77cb-427a-b118-bf5295f25b66
>>          Total devices 2 FS bytes used 816.80MiB
>>          devid    1 size 3.45GiB used 3.02GiB path /dev/mmcblk0p2
>>          devid    2 size 3.45GiB used 3.02GiB path /dev/mmcblk0p3

You use RAID1 on the same device: it could protect you against localized
errors but "localized" is difficult to define on a device which could
remap it's address space in various locations : nothing will prevent a
flash failure to affect both of your partitions. In this case RAID1 is
useless.
In fact using RAID1 on two partitions of the same physical device will
probably end up causing corruption earlier than without it: you are
writing twice as much to the same device, generating bad blocks twice as
fast.

> [...]

> [   12.021717] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
> [   12.027695] sunxi-mmc 1c0f000.mmc: data error, sending stop command
> [   12.035780] mmcblk0: timed out sending r/w cmd command, card status
> 0x900
> [   12.042640] end_request: I/O error, dev mmcblk0, sector 12386304
> [   12.048680] end_request: I/O error, dev mmcblk0, sector 12386312
> [   12.054708] end_request: I/O error, dev mmcblk0, sector 12386320
> [   12.060725] end_request: I/O error, dev mmcblk0, sector 12386328
> [   12.066744] BTRFS: bdev /dev/mmcblk0p3 errs: wr 1, rd 0, flush 0,
> corrupt 0, gen 0

Error on first partition.

> [   12.074324] end_request: I/O error, dev mmcblk0, sector 12386336
> [   12.080339] end_request: I/O error, dev mmcblk0, sector 12386344
> [   12.086353] end_request: I/O error, dev mmcblk0, sector 12386352
> [   12.092378] end_request: I/O error, dev mmcblk0, sector 12386360
> [   12.098393] BTRFS: bdev /dev/mmcblk0p3 errs: wr 2, rd 0, flush 0,
> corrupt 0, gen 0
> [   12.688370] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
> [   12.694342] sunxi-mmc 1c0f000.mmc: data error, sending stop command
> [   12.702553] mmcblk0: timed out sending r/w cmd command, card status
> 0x900
> [   12.709448] end_request: I/O error, dev mmcblk0, sector 2019328
> [   12.715393] end_request: I/O error, dev mmcblk0, sector 2019336
> [   12.721333] BTRFS: bdev /dev/mmcblk0p2 errs: wr 1, rd 0, flush 0,
> corrupt 0, gen 0

Error on second partition.
So both are unreliable : RAID1 can't help, game over.

Lionel
