Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:32876 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbcAUXNx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 18:13:53 -0500
Received: by mail-io0-f174.google.com with SMTP id q21so71108898iod.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 15:13:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A15B6F.9070300@gmail.com>
References: <56A13176.2050502@gmail.com>
	<CAJCQCtS3roJ84TNROAOwpyEFh_D85RcajAAOFkE5iURoKqVt4Q@mail.gmail.com>
	<56A15B6F.9070300@gmail.com>
Date: Thu, 21 Jan 2016 16:13:52 -0700
Message-ID: <CAJCQCtRSQTegThx+7P6tDTMDxx136XyuFXaZ5fC+90ASVV6Pow@mail.gmail.com>
Subject: Re: "Some devices missing" only while not mounted
From: Chris Murphy <lists@colorremedies.com>
To: Konstantin Svist <fry.kun@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 3:27 PM, Konstantin Svist <fry.kun@gmail.com> wrote:
> On 01/21/2016 01:25 PM, Chris Murphy wrote:
>> On Thu, Jan 21, 2016 at 12:28 PM, Konstantin Svist <fry.kun@gmail.com> wrote:
>>
>>> 1 of the drives failed (/dev/sdb; command timeouts, link reset
>>> messages), causing a kernel panic by btrfs getting really confused.
>>> After reboot, I got "parent transid verify failed" while trying to mount.
>> For each drive:
>> # smartctl -l scterc /dev/sdX
>> # cat /sys/block/sdX/device/timeout
>>
>> The first value must be less than the second. Note that the first
>> value is in deciseconds, and the second value is in seconds. If scterc
>> is not supported or disabled, then its equivalent value is only
>> determined by knowing how the firmware does ECC and the max time it
>> will try to do recovery on reads, but this can be 120+ seconds.
>>
>> Chances are there's a misconfiguration in this setup that's allowing
>> bad sectors to cause the drive to do error recovery, and the SCSI
>> command timer is being reached before the drive can report a read
>> error, and this results in the link resets and an accumulation of bad
>> sectors. It often eventually leads to data loss.
>
> The bad drive had been replaced already, but here's the info anyway if
> you care:
>
> # smartctl -l scterc /dev/sda
> ...
> SCT Error Recovery Control command not supported

OK so these drive models aren't really well suited for any kind of
raid. If your use case can tolerate sometimes very high recovery
times, you can change the SCSI command timer to something like 160.
This is not a persistent setting.





>
> (same for the other 3)
>
> # grep . /sys/block/sd?/device/timeout
> /sys/block/sda/device/timeout:30
> /sys/block/sdb/device/timeout:30
> /sys/block/sdc/device/timeout:30
> /sys/block/sdd/device/timeout:30

Yep that's the kernel default. so change that to 160 for each drive.

Another work around, is you can do a full balance every so often, like
once every 3 to 6 months (it's a guess, there's no way to know for
sure how often to do it). That will read and write everything,
therefore hopefully the problem of bad sectors is just avoided (they
get remapped before they get too bad).




> The file system is fine and mounts without complaining, even without
> "degraded" option, since the replace/rebalance/etc.

OK...

So you can mount without -o degraded, and there are no errors. But if
you do 'btrfs fi show -d' there is still a 'some missing devices'
message?

I don't have an explanation for that. Sounds like a bug.


>
>>> "fi show" on mounted /dev/sda2 looks normal; on unmounted /dev/sda2
>>> shows "Total devices 5" and "Some devices missing"
>> This is a confusing interpretation because it has nothing to do with
>> mounted vs unmounted. I'm looking at your attachment, and it only
>> shows "some devices missing" when you use the -d flag. It doesn't
>> matter whether the fs is mounted or not, -d always produces "some
>> devices missing" and without -d it doesn't. And I don't have an
>> explanation for that.
>
> You're correct, "show -d" always produces "some devices missing". I was
> trying to point out that it's not consistent with "show /dev/sda2"
> (which flips based on whether FS is mounted) and with "show /mnt" (which
> doesn't say "some devices missing").


OK.




>
>
>> I suggest you unmount the file system and do 'btrfs check' without
>> --repair and report the results, lets see if it tells us which devices
>> it thinks are missing still.
>
> # btrfs check -p /dev/sda2
> Checking filesystem on /dev/sda2
> UUID: 48f0e952-a176-481e-a184-6ee51acf54b1
> checking extents [O]
> checking free space cache [.]
> checking fs roots [o]
> checking csums
> checking root refs
> found 1422602007193 bytes used err is 0
> total csum bytes: 1385765984
> total tree bytes: 3352772608
> total fs tree bytes: 1720664064
> total extent tree bytes: 184418304
> btree space waste bytes: 371686097
> file data blocks allocated: 1757495775232
>  referenced 1465791070208
>
>

OK so the file system mounts OK. And btrfs check comes up clean. So
the file system is OK except that 'btfs fi show -d' shows a missing
device, which is probably related to why 'btrfs dev scan' and 'btrfs
dev ready' are failing on this phantom missing device, and thus why
the boot fails.

The boot fails because the volume UUID instance doesn't seem to get
generated (or generated in a timely manner) such that systemd will
mount it based on the kernel parameter root=UUID=

So in the meantime you could change that root=UUID= to root=/dev/sdXY
for one of the devices. That's a hack workaround. It doesn't explain
why the filesystem still thinks there's a missing device.


-- 
Chris Murphy
