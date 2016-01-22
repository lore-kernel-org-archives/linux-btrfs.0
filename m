Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from c.mail.sonic.net ([64.142.111.80]:58398 "EHLO c.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbcAVCoY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 21:44:24 -0500
Subject: Re: "Some devices missing" only while not mounted
To: Chris Murphy <lists@colorremedies.com>
References: <56A13176.2050502@gmail.com>
 <CAJCQCtS3roJ84TNROAOwpyEFh_D85RcajAAOFkE5iURoKqVt4Q@mail.gmail.com>
 <56A15B6F.9070300@gmail.com>
 <CAJCQCtRSQTegThx+7P6tDTMDxx136XyuFXaZ5fC+90ASVV6Pow@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Konstantin Svist <fry.kun@gmail.com>
Message-ID: <56A19785.6090702@gmail.com>
Date: Thu, 21 Jan 2016 18:44:21 -0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRSQTegThx+7P6tDTMDxx136XyuFXaZ5fC+90ASVV6Pow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/21/2016 03:13 PM, Chris Murphy wrote:

>> The file system is fine and mounts without complaining, even without
>> "degraded" option, since the replace/rebalance/etc.
> OK...
>
> So you can mount without -o degraded, and there are no errors. But if
> you do 'btrfs fi show -d' there is still a 'some missing devices'
> message?
>
> I don't have an explanation for that. Sounds like a bug.

Yeah... question is, what to do about it?


>>> I suggest you unmount the file system and do 'btrfs check' without
>>> --repair and report the results, lets see if it tells us which devices
>>> it thinks are missing still.
>> # btrfs check -p /dev/sda2
>> Checking filesystem on /dev/sda2
>> UUID: 48f0e952-a176-481e-a184-6ee51acf54b1
>> checking extents [O]
>> checking free space cache [.]
>> checking fs roots [o]
>> checking csums
>> checking root refs
>> found 1422602007193 bytes used err is 0
>> total csum bytes: 1385765984
>> total tree bytes: 3352772608
>> total fs tree bytes: 1720664064
>> total extent tree bytes: 184418304
>> btree space waste bytes: 371686097
>> file data blocks allocated: 1757495775232
>>  referenced 1465791070208
>>
>>
> OK so the file system mounts OK. And btrfs check comes up clean. So
> the file system is OK except that 'btfs fi show -d' shows a missing
> device, which is probably related to why 'btrfs dev scan' and 'btrfs
> dev ready' are failing on this phantom missing device, and thus why
> the boot fails.

Exactly

> The boot fails because the volume UUID instance doesn't seem to get
> generated (or generated in a timely manner) such that systemd will
> mount it based on the kernel parameter root=UUID=
>
> So in the meantime you could change that root=UUID= to root=/dev/sdXY
> for one of the devices. That's a hack workaround. It doesn't explain
> why the filesystem still thinks there's a missing device.

Actually, that's what I had before (root=/dev/sda2) and it wasn't
working, either. systemd seems to create a target/service on the fly and
wait for device specified by root= (whether it's specified by UUID or by
/dev/sdX). Specifically, in /usr/lib/udev/rules.d/64-btrfs.rules there's
a line IMPORT{builtin}="btrfs ready $devnode" -- this is what systemd is
waiting for.
Since this "service/target/etc." has infinite timeout and non-error
return never comes up, system can't boot :(

Wish the FS could be "edited" to remove the phantom device to make it work..


