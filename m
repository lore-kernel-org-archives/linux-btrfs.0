Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42974 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520Ab3FEQAK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Jun 2013 12:00:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UkG88-00069A-Oa
	for linux-btrfs@vger.kernel.org; Wed, 05 Jun 2013 18:00:08 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Jun 2013 18:00:08 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Jun 2013 18:00:08 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs raid1 on 16TB goes read-only after "btrfs: block rsv returned
 -28"
Date: Wed, 05 Jun 2013 16:59:57 +0100
Message-ID: <konn9n$7hf$1@ger.gmane.org>
References: <konjl0$r06$1@ger.gmane.org> <20130605150549.GP20133@carfax.org.uk> <konler$h9p$1@ger.gmane.org> <20130605154329.GQ20133@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130605154329.GQ20133@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/06/13 16:43, Hugo Mills wrote:
> On Wed, Jun 05, 2013 at 04:28:33PM +0100, Martin wrote:
>> On 05/06/13 16:05, Hugo Mills wrote:
>>> On Wed, Jun 05, 2013 at 03:57:42PM +0100, Martin wrote:
>>>> Dear Devs,
>>>> 
>>>> I have x4 4TB HDDs formatted with:
>>>> 
>>>> mkfs.btrfs -L bu-16TB_0 -d raid1 -m raid1 /dev/sd[cdef]
>>>> 
>>>> 
>>>> /etc/fstab mounts with the options:
>>>> 
>>>> noatime,noauto,space_cache,inode_cache
>>>> 
>>>> 
>>>> All on kernel 3.8.13.
>>>> 
>>>> 
>>>> Upon using rsync to copy some heavily hardlinked backups
>>>> from ReiserFS, I've seen:
>>>> 
>>>> 
>>>> The following "block rsv returned -28" is repeated 7 times
>>>> until there is a call trace for:
>>> 
>>> This is ENOSPC. Can you post the output of "btrfs fi df 
>>> /mountpoint" and "btrfs fi show", please?
>> 
>> 
>> btrfs fi df:
>> 
>> Data, RAID1: total=2.85TB, used=2.84TB Data: total=8.00MB,
>> used=0.00 System, RAID1: total=8.00MB, used=412.00KB System:
>> total=4.00MB, used=0.00 Metadata, RAID1: total=27.00GB,
>> used=25.82GB Metadata: total=8.00MB, used=0.00
>> 
>> 
>> btrfs fi show:
>> 
>> Label: 'bu-16TB_0'  uuid: 8fd9a0a8-9109-46db-8da0-396d9c6bc8e9 
>> Total devices 4 FS bytes used 2.87TB devid    4 size 3.64TB used
>> 1.44TB path /dev/sdf devid    3 size 3.64TB used 1.44TB path
>> /dev/sde devid    1 size 3.64TB used 1.44TB path /dev/sdc devid
>> 2 size 3.64TB used 1.44TB path /dev/sdd
> 
> OK, so you've got plenty of space to allocate. There were some 
> issues in this area (block reserves and ENOSPC, and I think 
> specifically addressing the issue of ENOSPC when there's space 
> available to allocate) that were fixed between 3.8 and 3.9 (and 
> probably some between 3.9 and 3.10-rc as well), so upgrading your 
> kernel _may_ help here.
> 
> Something else that may possibly help as a sticking-plaster is to 
> write metadata more slowly, so that you don't have quite so much of
> it waiting to be written out for the next transaction. Practically,
> this may involve things like running "sync" on a loop. But it's
> definitely a horrible hack that may help if you're desperate for a
> quick fix until you can finish creating metadata so quickly and
> upgrade your kernel...
> 
> Hugo.

Thanks for that. I can give kernel 3.9.4 a try. For a giggle, I'll try
first with "nice 19" and syncs in a loop...


One confusing bit is why the "Data, RAID1: total=2.85TB" from "btrfs
fi df"?

Thanks,
Martin


