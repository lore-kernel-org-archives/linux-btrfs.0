Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47970 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750916AbaHOBF7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 21:05:59 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:64041 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XI5xu-002OqW-Vs
	for linux-btrfs@vger.kernel.org; Thu, 14 Aug 2014 19:05:59 -0600
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Large files, nodatacow and fragmentation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CADw2B2NJQYn_xkrAebmdu_c-7z7yFNZ1aDFS=jYmQcHfco2d+g@mail.gmail.com>
Date: Thu, 14 Aug 2014 19:05:58 -0600
Message-Id: <5CE63712-2C3E-4BF3-B971-C6F17AE10E3D@colorremedies.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com> <20140812011401.568c16e6@natsu> <AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com> <CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com> <9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com> <CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com> <08770CD2-AA55-4BC1-B92C-E7D3360399F8@colorremedies.com> <CADw2B2NJQYn_xkrAebmdu_c-7z7yFNZ1aDFS=jYmQcHfco2d+g@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 14, 2014, at 5:16 PM, G. Richard Bellamy <rbellamy@pteradigm.com> wrote:

> On Thu, Aug 14, 2014 at 11:40 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> and there may be a fit for bcache here because you actually would get these random writes committed to stable media much faster in that case, and a lot of work has been done to make this more reliable than battery backed write caches on hardware raid.
> 
> umph... heard of bcache, but never looked at it or considered it as an
> option in this scenario. After reading the doco and some of the design
> documents, it's looking like bcache and md/mdadm or LVM could do the
> trick.

They are all separate things. I haven't worked with the LVM caching (which uses dm-cache as the backend, similar to how it uses md code on the backend for all of its RAID level support), there could be some advantages there if you have to use LVM anyway, but the design goal of bcache sounds more suited for your workload. And it's got


> 
> The gotchas state clearly that btrfs on top of bcache is not recommended.

Yeah I'm not sure if the suggested changes from 3.12 btrfs + bcache problems went through. Eventually they should work together. But I'd use bcache with XFS or ext4 when not in the mood for bleeding something.

> 
> However, can bcache be put 'in front' of a btrfs raid10 volume?

More correctly you will mkfs.btrfs on the bcache devices, which are logical devices made from one or more backing devices, and a cache device.


# make-bcache -w 2k -b 512k -C /dev/sdc -B /dev/sd[defg]
# lsblk
sdc               8:32   0    8G  0 disk 
├─bcache0       252:0    0    8G  0 disk 
├─bcache1       252:1    0    8G  0 disk 
├─bcache2       252:2    0    8G  0 disk 
└─bcache3       252:3    0    8G  0 disk 
sdd               8:48   0    8G  0 disk 
└─bcache0       252:0    0    8G  0 disk 
sde               8:64   0    8G  0 disk 
└─bcache1       252:1    0    8G  0 disk 
sdf               8:80   0    8G  0 disk 
└─bcache2       252:2    0    8G  0 disk 
sdg               8:96   0    8G  0 disk 
└─bcache3       252:3    0    8G  0 disk 
# mkfs.btrfs -draid10 -mraid10 /dev/bcache[0123]
# mount /dev/bcache0 /mnt
# btrfs fi df /mnt
Data, RAID10: total=2.00GiB, used=27.91MiB
System, RAID10: total=64.00MiB, used=16.00KiB
Metadata, RAID10: total=256.00MiB, used=160.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B
[* Yes I cheated and did a balance first so the df output looks cleaner.]


> I
> think not, since btrfs volumes are not presented as individual block
> devices, instead you've got several block devices (e.g. /dev/sda and
> /dev/sdb are in a btrfs raid1, and can be seen individually by the
> OS)... however I wish it could, since bcache "...turns random writes
> into sequential writes", which solve entirely the problem which
> prompts the nocow option in btrfs.

Yeah but you've got something perturbing this in the VM guest, and probably also libvirt caching isn't ideal for that workload either. Now it may be safe, but at the expense of being chatty. I'm not yet convinced you avoid this problem with XFS, in which case you're in a better position to safely use bcache.


Chris Murphy