Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dub0-omc4-s5.dub0.hotmail.com ([157.55.2.80]:40962 "EHLO
	dub0-omc4-s5.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405Ab3IZNrK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 09:47:10 -0400
Message-ID: <DUB116-W515338D8267F1A703A1452A6280@phx.gbl>
From: miaou sami <miaousami@hotmail.com>
To: Hugo Mills <hugo@carfax.org.uk>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [raidX vs single/dup]
Date: Thu, 26 Sep 2013 13:40:57 +0000
In-Reply-To: <20130926123233.GA2865@carfax.org.uk>
References: <DUB116-W69F1EBEC6C7619457E5D82A6280@phx.gbl>,<20130926123233.GA2865@carfax.org.uk>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you, it is quite clear now.


I guess that on multi device, raid0 vs single would be a matter of performance vs ease of low level hardware data recovery.


The wiki https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices says:
"When you have drives with differing sizes and want to use the full capacity of each drive, you have to use the single profile for the data blocks."
Let's assume the following configuration: 1x10GB disk and 2x5GB disks
--> Does it mean I cannot use the full capacity AND have a duplication of my data in the configuration above? (full capacity would be 10GB here)
--> If I try to setup either -d raid1 or -d dup on that configuration, what will I get?
--> Is there any behavior difference between raid1 / dup in that case?
--> Can raid1 ensure that data are always duplicated on different devices AND take advantage of all available space?


Regards,
Sam


----------------------------------------
> Date: Thu, 26 Sep 2013 13:32:33 +0100
> From: hugo@carfax.org.uk
> To: miaousami@hotmail.com
> CC: linux-btrfs@vger.kernel.org
> Subject: Re: [raidX vs single/dup]
>
> On Thu, Sep 26, 2013 at 12:22:49PM +0000, miaou sami wrote:
>> Hi btrfs guys,
>>
>> could someone explain to me the differences in mkfs.btrfs:
>>
>> - between -d raid0 and -d single
>
> In RAID0, data is striped across all the devices, so the first 64k
> of a file will go on device 1, the next 64k will go on device 2, and
> so on. With single, files are allocated linearly on one device.
>
> (This is assuming smallish files, a filesystem with lots of space.
> Even with single, files can still end up being scattered around over
> multiple devices -- but with RAID0, even non-fragmented files are
> striped)
>
>> - between -m raid1 and -m dup
>
> In both cases, there are two copies of each metadata block. With
> RAID1, it *requires* the two copies to live on different devices. With
> DUP, it allows the two copies to live on the same device (e.g. if
> there's only one device).
>
>> - between -m raid0 and -m single
>
> As for -draid0 and -dsingle, but for metadata instead of data.
>
>> My understanding is that raidX should be used in case of multi
>> devices and single/dup should be used in case of single device to
>> allow duplication, but it is not 100% clear to me...
>
>> As btrfs raid concepts are quite different from traditionnal raid,
>> shouldn't we use the words "stripped" and "mirrored" instead of
>> raid0/raid1? or even "single" and "duplicated"?
>> Then there would be no difference between single/raid0 and
>> duplicated/raid1...
>
> But there _are_ differences between them, as explained above. :)
>
> I posted a patch a while ago to change the names to something more
> logical and expressive, but it didn't get merged.
>
> Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
> PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
> --- Stick them with the pointy end. --- 		 	   		  