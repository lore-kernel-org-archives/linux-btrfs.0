Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35478 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbbIHTnf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 15:43:35 -0400
Received: by wicge5 with SMTP id ge5so129508832wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2015 12:43:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150908193405.GN23944@carfax.org.uk>
References: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
 <20150908193405.GN23944@carfax.org.uk>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Tue, 8 Sep 2015 21:43:14 +0200
Message-ID: <CAA85sZu9xJOHMr0rs7hvzvBZwBWN7RvCb3bt4dYM7_6D2qyh7Q@mail.gmail.com>
Subject: Re: [btrfs tools] ability to fail a device...
To: Hugo Mills <hugo@carfax.org.uk>, Ian Kumlien <ian.kumlien@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 September 2015 at 21:34, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Sep 08, 2015 at 09:18:05PM +0200, Ian Kumlien wrote:
>> Hi,
>>
>> Currently i have a raid1 configuration on two disks where one of them
>> is failing.
>>
>> But since:
>> btrfs fi df /mnt/disk/
>> Data, RAID1: total=858.00GiB, used=638.16GiB
>> Data, single: total=1.00GiB, used=256.00KiB
>> System, RAID1: total=32.00MiB, used=132.00KiB
>> Metadata, RAID1: total=4.00GiB, used=1.21GiB
>> GlobalReserve, single: total=412.00MiB, used=0.00B
>>
>> There should be no problem in failing one disk... Or so i thought!
>>
>> btrfs dev delete /dev/sdb2 /mnt/disk/
>> ERROR: error removing the device '/dev/sdb2' - unable to go below two
>> devices on raid1
>
>    dev delete is more like a reshaping operation in mdadm: it tries to
> remove a device safely whilst retaining all of the redundancy
> guarantees. You can't go down to one device with RAID-1 and still keep
> the redundancy.
>
>    dev delete is really for managed device removal under non-failure
> conditions, not for error recovery.
>
>> And i can't issue rebalance either since it will tell me about errors
>> until the failing disk dies.
>>
>> Whats even more interesting is that i can't mount just the working
>> disk - ie if the other disk
>> *has* failed and is inaccessible... though, i haven't tried physically
>> removing it...
>
>    Physically removing it is the way to go (or disabling it using echo
> offline >/sys/block/sda/device/state). Once you've done that, you can
> mount the degraded FS with -odegraded, then either add a new device
> and balance to restore the RAID-1, or balance with
> -{d,m}convert=single to drop the redundancy to single.

This did not work...

[ 1742.368079] BTRFS info (device sda2): The free space cache file
(280385028096) is invalid. skip it
[ 1789.052403] BTRFS: open /dev/sdb2 failed
[ 1789.064629] BTRFS info (device sda2): allowing degraded mounts
[ 1789.064632] BTRFS info (device sda2): disk space caching is enabled
[ 1789.092286] BTRFS: bdev /dev/sdb2 errs: wr 2036894, rd 2031380,
flush 705, corrupt 0, gen 0
[ 1792.625275] BTRFS: too many missing devices, writeable mount is not allowed
[ 1792.644407] BTRFS: open_ctree failed

>> mdam has fail and remove, I assume for this reason - perhaps it's
>> something that should be added?
>
>    I think there should be a btrfs dev drop, which is the fail-like
> operation: tell the FS that a device is useless, and should be dropped
> from the array, so the FS doesn't keep trying to write to it. That's
> not implemented yet, though.

Damn it =)

>    Hugo.
>
> --
> Hugo Mills             | Alert status mauve ocelot: Slight chance of
> hugo@... carfax.org.uk | brimstone. Be prepared to make a nice cup of tea.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |
