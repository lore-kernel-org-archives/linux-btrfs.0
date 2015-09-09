Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34810 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbIIHHc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 03:07:32 -0400
Received: by wicfx3 with SMTP id fx3so144993092wic.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Sep 2015 00:07:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55EF8CFB.3050103@oracle.com>
References: <CAA85sZv5V_YGnHaYfDKJ8L9=Nmg0XNRoxK9NLZER_jKZ7TUdnA@mail.gmail.com>
 <20150908193405.GN23944@carfax.org.uk> <55EF8CFB.3050103@oracle.com>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Wed, 9 Sep 2015 09:07:12 +0200
Message-ID: <CAA85sZvff=Bbeak3=eRHL86x6g_uWuxv2s8+Lykjfjy4MeDBbQ@mail.gmail.com>
Subject: Re: [btrfs tools] ability to fail a device...
To: Anand Jain <anand.jain@oracle.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9 September 2015 at 03:35, Anand Jain <anand.jain@oracle.com> wrote:
> On 09/09/2015 03:34 AM, Hugo Mills wrote:
>>
>> On Tue, Sep 08, 2015 at 09:18:05PM +0200, Ian Kumlien wrote:
>>>
>>> Hi,
>>>
>>> Currently i have a raid1 configuration on two disks where one of them
>>> is failing.
>>>
>>> But since:
>>> btrfs fi df /mnt/disk/
>>> Data, RAID1: total=858.00GiB, used=638.16GiB
>>> Data, single: total=1.00GiB, used=256.00KiB
>>> System, RAID1: total=32.00MiB, used=132.00KiB
>>> Metadata, RAID1: total=4.00GiB, used=1.21GiB
>>> GlobalReserve, single: total=412.00MiB, used=0.00B
>>>
>>> There should be no problem in failing one disk... Or so i thought!
>>>
>>> btrfs dev delete /dev/sdb2 /mnt/disk/
>>> ERROR: error removing the device '/dev/sdb2' - unable to go below two
>>> devices on raid1
>>
>>
>>     dev delete is more like a reshaping operation in mdadm: it tries to
>> remove a device safely whilst retaining all of the redundancy
>> guarantees. You can't go down to one device with RAID-1 and still keep
>> the redundancy.
>>
>>     dev delete is really for managed device removal under non-failure
>> conditions, not for error recovery.
>>
>>> And i can't issue rebalance either since it will tell me about errors
>>> until the failing disk dies.
>>>
>>> Whats even more interesting is that i can't mount just the working
>>> disk - ie if the other disk
>>> *has* failed and is inaccessible... though, i haven't tried physically
>>> removing it...
>>
>>
>>     Physically removing it is the way to go (or disabling it using echo
>> offline >/sys/block/sda/device/state). Once you've done that, you can
>> mount the degraded FS with -odegraded, then either add a new device
>> and balance to restore the RAID-1, or balance with
>> -{d,m}convert=single to drop the redundancy to single.
>
>
>  its like you _must_ add a disk in this context otherwise the volume will
> render unmountable in the next mount cycle. the below mentioned patch has
> more details.

Which would mean that if the disk dies, you have a unusable disk.
(and in my case adding a disk might not help since it would try to
read from the broken
one until it completely fails again)

>>> mdam has fail and remove, I assume for this reason - perhaps it's
>>> something that should be added?
>>
>>
>>     I think there should be a btrfs dev drop, which is the fail-like
>> operation: tell the FS that a device is useless, and should be dropped
>> from the array, so the FS doesn't keep trying to write to it. That's
>> not implemented yet, though.
>
>
>
>  There is a patch set to handle this..
>     'Btrfs: introduce function to handle device offline'

I'll have a look

> Thanks, Anand
>
>>     Hugo.
>>
>
