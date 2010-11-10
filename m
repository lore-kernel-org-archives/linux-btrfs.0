From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: labelling
Date: 10 Nov 2010 12:44:00 +0100
Message-ID: <B$bHXtjT1uB@helmut.hullen.de>
References: <20101110111811.GA15973@vlad.carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101110111811.GA15973@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 10.11.10:

>>         findfs LABEL=MM2
>>
>> shows "/dev/sdd2" (the first partition)
>>
>>         file -s /dev/sdd2
>>         file -s /dev/sdc3
>>
>> shows "LABEL=MM2" for both partitions (that's not good).

>    No, this is both good and correct. You've got a single filesystem
> spanning multiple block devices. The *filesystem* possesses the
> label, and with btrfs you can mount the filesystem using *any* of the
> block devices that compose it, so both block devices should indeed
> show the FS label, which is what's happening here.

>> Unmounting "/srv/MM" and
>>
>>         mount LABEL=MM2 /srv/MM
>>
>> doesn't work now, it tries to mount /dev/sdd2 and mourns.
>>
>>         mount /dev/sdd2 /srv/MM
>>
>> shows the same error message,

>    What's the error message? What do you get in your kernel logs when
> you do this? This should work, so there's something wrong, but it's
> (probably) not to do with disk labels.

I'll tell tomorrow; the system is just copying more than 1 TByte ...

>> ----------------------------
>>
>> By the way:
>>
>> "df" shows about 3.4 TByte usable space (2 TByte and 1.5 TByte), but
>>
>>         btrfs filesystem df /srv/MM
>>
>> tells
>>
>>         Data: total=2.70TB, used=1.64TB
>>
>> I'm missing about 0.7 TByte!

>    In "btrfs filesystem df", the "total" field is the space that has
> been allocated to block groups. As more space is needed on the
> filesystem, the "total" field will increase to use up the additional
> raw storage

Ok - and many thanks! I'll see tomorrow ...

Viele Gruesse!
Helmut
