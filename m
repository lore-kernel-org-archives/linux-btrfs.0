Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:47874 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbeHJMCX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 08:02:23 -0400
Date: Fri, 10 Aug 2018 11:33:18 +0200
From: Tomasz Pala <gotar@polanet.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes
 with quota
Message-ID: <20180810093317.GA558@polanet.pl>
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
 <20180810071748.GA5473@polanet.pl>
 <33914565-224f-71b6-f319-7c66e3a69d4d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <33914565-224f-71b6-f319-7c66e3a69d4d@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 15:55:46 +0800, Qu Wenruo wrote:

>> The first thing about virtually every mechanism should be
>> discoverability and reliability. I expect my quota not to change without
>> my interaction. Never. How did you cope with this?
>> If not - how are you going to explain such weird behaviour to users?
> 
> Read the manual first.
> Not every feature is suitable for every use case.

I, the sysadm, must RTFM.
My users won't comprehend this and moreover - they won't even care.

> IIRC lvm thin is pretty much the same for the same case.

LVM doesn't pretend to be user-oriented, it is the system scope.
LVM didn't name it's thin provisioning "quotas".

> For 4 disk with 1T free space each, if you're using RAID5 for data, then
> you can write 3T data.
> But if you're also using RAID10 for metadata, and you're using default
> inline, we can use small files to fill the free space, resulting 2T
> available space.
> 
> So in this case how would you calculate the free space? 3T or 2T or
> anything between them?

The answear is pretty simple: 3T. Rationale:
- this is the space I do can put in a single data stream,
- people are aware that there is metadata overhead with any object;
  after all, metadata are also data,
- while filling the fs with small files the free space available would
  self-adjust after every single file put, so after uploading 1T of such
  files the df should report 1.5T free. There would be nothing weird(er
  that now) that 1T of data has actually eaten 1.5T of storage.

No crystal ball calculations, just KISS; since one _can_ put 3T file
(non sparse, uncompressible, bulk written) on a filesystem, the free space is 3T.

> Only yourself know what the heck you're going to use the that 4 disks
> with 1T free space each.
> Btrfs can't look into your head and know what you're thinking.

It shouldn't. I expect raw data - there is 3TB of unallocated space for
current data profile.

> That's the design from the very beginning of btrfs, yelling at me makes
> no sense at all.

Sorry if you receive me "yelling" - I honestly must put in on my
non-native english. I just want to clarify some terminology and
perspective expectations. They are irrevelant to the underlying
technical solutions, but the literal *description* of the solution
you provide should match user expectations of that terminology.

> I have tried to explain what btrfs quota does and it doesn't, if it
> doesn't fit you use case, that's all.
> (Whether you have ever tried to understand is another problem)

I am (more than before) aware what btrfs quotas are not.

So, my only expectation (except for worldwide peace and other
unrealistic ones) would be to stop using "quotas", "subvolume quotas"
and "qgroups" interchangeably in btrfs context, as IMvHO these are not
plain, well-known "quotas".

-- 
Tomasz Pala <gotar@pld-linux.org>
