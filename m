Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:38304 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaIBSbE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 14:31:04 -0400
Received: by mail-oi0-f49.google.com with SMTP id g201so4711590oib.22
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 11:31:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5CE63712-2C3E-4BF3-B971-C6F17AE10E3D@colorremedies.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>
	<20140812011401.568c16e6@natsu>
	<AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com>
	<CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com>
	<9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com>
	<CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com>
	<08770CD2-AA55-4BC1-B92C-E7D3360399F8@colorremedies.com>
	<CADw2B2NJQYn_xkrAebmdu_c-7z7yFNZ1aDFS=jYmQcHfco2d+g@mail.gmail.com>
	<5CE63712-2C3E-4BF3-B971-C6F17AE10E3D@colorremedies.com>
Date: Tue, 2 Sep 2014 11:31:02 -0700
Message-ID: <CADw2B2N4T_XWOWt++8wGhXk5WJmKgQGqhbt=m2JbQCO_ekfhxA@mail.gmail.com>
Subject: Re: Large files, nodatacow and fragmentation
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I thought I'd follow-up and give everyone an update, in case anyone
had further interest.

I've rebuilt the RAID10 volume in question with a Samsung 840 Pro for
bcache front device.

It's 5x600GB SAS 15k RPM drives RAID10, with the 512MB SSD bcache.

2014-09-02 11:23:16
root@eanna i /var/lib/libvirt/images # lsblk
NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda         8:0    0 558.9G  0 disk
└─bcache3 254:3    0 558.9G  0 disk /var/lib/btrfs/data
sdb         8:16   0 558.9G  0 disk
└─bcache2 254:2    0 558.9G  0 disk
sdc         8:32   0 558.9G  0 disk
└─bcache1 254:1    0 558.9G  0 disk
sdd         8:48   0 558.9G  0 disk
└─bcache0 254:0    0 558.9G  0 disk
sde         8:64   0 558.9G  0 disk
└─bcache4 254:4    0 558.9G  0 disk
sdf         8:80   0   1.8T  0 disk
└─sdf1      8:81   0   1.8T  0 part
sdg         8:96   0   477G  0 disk /var/lib/btrfs/system
sdh         8:112  0   477G  0 disk
sdi         8:128  0   477G  0 disk
├─bcache0 254:0    0 558.9G  0 disk
├─bcache1 254:1    0 558.9G  0 disk
├─bcache2 254:2    0 558.9G  0 disk
├─bcache3 254:3    0 558.9G  0 disk /var/lib/btrfs/data
└─bcache4 254:4    0 558.9G  0 disk
sr0        11:0    1  1024M  0 rom

I further split the system and data drives of the VM Win7 guest. It's
very interesting to see the huge level of fragmentation I'm seeing,
even with the help of ordered writes offered by bcache - in other
words while bcache seems to be offering me stability and better
behavior to the guest, the underlying the filesystem is still seeing a
level of fragmentation that has me scratching my head.

That being said, I don't know what would be normal fragmentation of a
VM Win7 guest system drive, so could be I'm just operating in my zone
of ignorance again.

2014-09-01 14:41:19
root@eanna i /var/lib/libvirt/images # filefrag atlas-*
atlas-data.qcow2: 7 extents found
atlas-system.qcow2: 154 extents found
2014-09-01 18:12:27
root@eanna i /var/lib/libvirt/images # filefrag atlas-*
atlas-data.qcow2: 564 extents found
atlas-system.qcow2: 28171 extents found
2014-09-02 08:22:00
root@eanna i /var/lib/libvirt/images # filefrag atlas-*
atlas-data.qcow2: 564 extents found
atlas-system.qcow2: 35281 extents found
2014-09-02 08:44:43
root@eanna i /var/lib/libvirt/images # filefrag atlas-*
atlas-data.qcow2: 564 extents found
atlas-system.qcow2: 37203 extents found
2014-09-02 10:14:32
root@eanna i /var/lib/libvirt/images # filefrag atlas-*
atlas-data.qcow2: 564 extents found
atlas-system.qcow2: 40903 extents found

On Thu, Aug 14, 2014 at 6:05 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Aug 14, 2014, at 5:16 PM, G. Richard Bellamy <rbellamy@pteradigm.com> wrote:
>
>> On Thu, Aug 14, 2014 at 11:40 AM, Chris Murphy <lists@colorremedies.com> wrote:
>>> and there may be a fit for bcache here because you actually would get these random writes committed to stable media much faster in that case, and a lot of work has been done to make this more reliable than battery backed write caches on hardware raid.
>>
>> umph... heard of bcache, but never looked at it or considered it as an
>> option in this scenario. After reading the doco and some of the design
>> documents, it's looking like bcache and md/mdadm or LVM could do the
>> trick.
>
> They are all separate things. I haven't worked with the LVM caching (which uses dm-cache as the backend, similar to how it uses md code on the backend for all of its RAID level support), there could be some advantages there if you have to use LVM anyway, but the design goal of bcache sounds more suited for your workload. And it's got
>
>
>>
>> The gotchas state clearly that btrfs on top of bcache is not recommended.
>
> Yeah I'm not sure if the suggested changes from 3.12 btrfs + bcache problems went through. Eventually they should work together. But I'd use bcache with XFS or ext4 when not in the mood for bleeding something.
>
>>
>> However, can bcache be put 'in front' of a btrfs raid10 volume?
>
> More correctly you will mkfs.btrfs on the bcache devices, which are logical devices made from one or more backing devices, and a cache device.
>
>
> # make-bcache -w 2k -b 512k -C /dev/sdc -B /dev/sd[defg]
> # lsblk
> sdc               8:32   0    8G  0 disk
> ├─bcache0       252:0    0    8G  0 disk
> ├─bcache1       252:1    0    8G  0 disk
> ├─bcache2       252:2    0    8G  0 disk
> └─bcache3       252:3    0    8G  0 disk
> sdd               8:48   0    8G  0 disk
> └─bcache0       252:0    0    8G  0 disk
> sde               8:64   0    8G  0 disk
> └─bcache1       252:1    0    8G  0 disk
> sdf               8:80   0    8G  0 disk
> └─bcache2       252:2    0    8G  0 disk
> sdg               8:96   0    8G  0 disk
> └─bcache3       252:3    0    8G  0 disk
> # mkfs.btrfs -draid10 -mraid10 /dev/bcache[0123]
> # mount /dev/bcache0 /mnt
> # btrfs fi df /mnt
> Data, RAID10: total=2.00GiB, used=27.91MiB
> System, RAID10: total=64.00MiB, used=16.00KiB
> Metadata, RAID10: total=256.00MiB, used=160.00KiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
> [* Yes I cheated and did a balance first so the df output looks cleaner.]
>
>
>> I
>> think not, since btrfs volumes are not presented as individual block
>> devices, instead you've got several block devices (e.g. /dev/sda and
>> /dev/sdb are in a btrfs raid1, and can be seen individually by the
>> OS)... however I wish it could, since bcache "...turns random writes
>> into sequential writes", which solve entirely the problem which
>> prompts the nocow option in btrfs.
>
> Yeah but you've got something perturbing this in the VM guest, and probably also libvirt caching isn't ideal for that workload either. Now it may be safe, but at the expense of being chatty. I'm not yet convinced you avoid this problem with XFS, in which case you're in a better position to safely use bcache.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
