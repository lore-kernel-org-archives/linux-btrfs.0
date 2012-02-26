From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: LABEL only 1 device
Date: 26 Feb 2012 19:11:00 +0100
Message-ID: <C3b1KRsi1uB@helmut.hullen.de>
References: <20120226171419.GD18898@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120226171419.GD18898@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 26.02.12:

>>> What you need to do is, immediately after
>>> removing a device from the FS, zero the first part of the partition
>>> with dd and /dev/zero.

>>
>> Ok - I'll try again (not today ...).
>> If I remember correct in early times deleting only the first block
>> of the partition didn't reach ...

>    No, it won't -- the first superblock on btrfs is at 64k into the
> device. Most filesystems do something similar, because there's other
> things that occasionally put metadata in the first part of the
> device, so it avoids having the FS's superblock overwritten
> accidentally.

Ok - but deleting the first 100 kByte or the first 1 MByte does reach?
Last times I'd run a job which deleted all (but that's nasty for disks  
with much more than 100 GByte ...)

>>         mkfs.btrfs -L SCSI /dev/sdk1
>>
>> seemed to work.
>>
>>         mount LABEL=SCSI /mnt/btr
>>
>> worked as expected, the bundle of 3 partitions was mounted. And only
>> "/ dev/sdk1" got this label, no other partition.

>    That's because you've just destroyed part of the original
> filesystem that was on /dev/sd[klm]1 and created a new single-device
> filesystem on /dev/sdk1.

>    mkfs.btrfs creates a new filesystem. The -L option sets the label
> for the newly-created FS. It *cannot* be used to change the label of
> an existing FS. If you want to do that, use "btrfs filesystem label".

Hmmmm - I'll try ...

Thank you!

-------------------------------------

Label: 'SCSI'  uuid: 8e287956-d73f-46cb-8938-b00315c596c6
	Total devices 1 FS bytes used 92.00KB
	devid    1 size 136.73GB used 2.04GB path /dev/sdj1

Label: 'Scsi'  uuid: b59caf71-1a38-47cc-bad3-c2d87357c971
	Total devices 3 FS bytes used 9.09GB
	devid    2 size 136.73GB used 4.01GB path /dev/sdl1
	devid    3 size 68.37GB used 5.01GB path /dev/sdm1
	devid    1 size 16.96GB used 5.02GB path /dev/sdk1

Btrfs Btrfs v0.19

looks good ...


Viele Gruesse!
Helmut
