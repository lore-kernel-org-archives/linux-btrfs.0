Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45657 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933377AbcBYTRt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 14:17:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aZ1Q2-0006Aj-9b
	for linux-btrfs@vger.kernel.org; Thu, 25 Feb 2016 20:17:46 +0100
Received: from 152.96.212.109 ([152.96.212.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 20:17:46 +0100
Received: from rhegner by 152.96.212.109 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 20:17:46 +0100
To: linux-btrfs@vger.kernel.org
From: Hegner Robert <rhegner@hsr.ch>
Subject: Re: btrfs raid1 filesystem on sdcard corrupted
Date: Thu, 25 Feb 2016 20:18:02 +0100
Message-ID: <nank09$nad$1@ger.gmane.org>
References: <nandur$4li$1@ger.gmane.org> <56CF3D78.90705@hsr.ch>
 <56CF4301.9090601@bouton.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <56CF4301.9090601@bouton.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Lionel for your explanations!

I just noticed that a second device with the same setup (which has been 
working only some hours ago) failed as well. So two systems which were 
running with a non-raid1 and non-btrfs setup for weeks or months before, 
and which were updated to the btrfs-raid1 system only recently, both 
failed within only a couple of hours...

Tomorrow I will check if both of these devices are equipped with the 
same SDcard brand/model.

We spent quite some time to find find a solution which makes our 
embedded system more resistant against power failures and all the 
flash-memory related problems. The idea with the btrfs-raid1 came from 
(http://unix.stackexchange.com/a/186954) and it made perfect sense to me 
to use a filesystem which is designed with flash-memory in mind and to 
use raid1 to achieve some redundancy. But it looks like this was wrong 
thinking...

So, in your experience
1) Which are the SDcards we can trust in? (brand? model?)
2) What would be a better way (with or without the use of btrfs) to make 
an embedded system more robust against power failures and 
flash-memory-wearing?

I know these questions are a little bit off-topic here. But since you 
seem to have some experience with this (and because I'm quite desperate 
now that I found out that my allegedly good solution is actually worse 
than what we had before) I would really appreciate your inputs.

Robert

Am 25.02.2016 um 19:08 schrieb Lionel Bouton:
> Hi,
>
> Le 25/02/2016 18:44, Hegner Robert a écrit :
>> Am 25.02.2016 um 18:34 schrieb Hegner Robert:
>>> Hi all!
>>>
>>> I'm working on a embedded system (ARM) running from a SDcard.
>
>  From experience, most SD cards are not to be trusted. They are not
> designed for storing an operating system and application data but for
> storing pictures and videos written on a VFAT...
>
>>> Recently I
>>> switched to a btrfs-raid1 configuration, hoping to make my system more
>>> resistant against power failures and flash-memory specific problems.
>
> Note that there's no gain against power failures with RAID1.
>
>>>
>>> However today one of my devices wouldn't mount my root filesystem as rw
>>> anymore.
>>>
>>> The main reason I'm asking in this mailing list is not that I want to
>>> restory data. But I'd like to understand what happened and, even more
>>> importantly, find out what I have to do so that something like this will
>>> never happen again.
>>>
>>> Here is some info about my system:
>>>
>>> root@ObserverOne:~# uname -a
>>> Linux ObserverOne 3.16.0-4-armmp #1 SMP Debian 3.16.7-ckt11-1+deb8u6
>>> (2015-11-09) armv7l GNU/Linux
>
> This is a very old kernel considering BTRFS code is moving fast. But in
> this instance this is not your problem.
>
>>>
>>> root@ObserverOne:~# btrfs --version
>>> Btrfs v3.17
>>>
>>> root@ObserverOne:~# btrfs fi show
>>> Label: none  uuid: eef07fbf-77cb-427a-b118-bf5295f25b66
>>>           Total devices 2 FS bytes used 816.80MiB
>>>           devid    1 size 3.45GiB used 3.02GiB path /dev/mmcblk0p2
>>>           devid    2 size 3.45GiB used 3.02GiB path /dev/mmcblk0p3
>
> You use RAID1 on the same device: it could protect you against localized
> errors but "localized" is difficult to define on a device which could
> remap it's address space in various locations : nothing will prevent a
> flash failure to affect both of your partitions. In this case RAID1 is
> useless.
> In fact using RAID1 on two partitions of the same physical device will
> probably end up causing corruption earlier than without it: you are
> writing twice as much to the same device, generating bad blocks twice as
> fast.
>
>> [...]
>
>> [   12.021717] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
>> [   12.027695] sunxi-mmc 1c0f000.mmc: data error, sending stop command
>> [   12.035780] mmcblk0: timed out sending r/w cmd command, card status
>> 0x900
>> [   12.042640] end_request: I/O error, dev mmcblk0, sector 12386304
>> [   12.048680] end_request: I/O error, dev mmcblk0, sector 12386312
>> [   12.054708] end_request: I/O error, dev mmcblk0, sector 12386320
>> [   12.060725] end_request: I/O error, dev mmcblk0, sector 12386328
>> [   12.066744] BTRFS: bdev /dev/mmcblk0p3 errs: wr 1, rd 0, flush 0,
>> corrupt 0, gen 0
>
> Error on first partition.
>
>> [   12.074324] end_request: I/O error, dev mmcblk0, sector 12386336
>> [   12.080339] end_request: I/O error, dev mmcblk0, sector 12386344
>> [   12.086353] end_request: I/O error, dev mmcblk0, sector 12386352
>> [   12.092378] end_request: I/O error, dev mmcblk0, sector 12386360
>> [   12.098393] BTRFS: bdev /dev/mmcblk0p3 errs: wr 2, rd 0, flush 0,
>> corrupt 0, gen 0
>> [   12.688370] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
>> [   12.694342] sunxi-mmc 1c0f000.mmc: data error, sending stop command
>> [   12.702553] mmcblk0: timed out sending r/w cmd command, card status
>> 0x900
>> [   12.709448] end_request: I/O error, dev mmcblk0, sector 2019328
>> [   12.715393] end_request: I/O error, dev mmcblk0, sector 2019336
>> [   12.721333] BTRFS: bdev /dev/mmcblk0p2 errs: wr 1, rd 0, flush 0,
>> corrupt 0, gen 0
>
> Error on second partition.
> So both are unreliable : RAID1 can't help, game over.
>
> Lionel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


