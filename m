Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:15159 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761513Ab3BNSFk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 13:05:40 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Rebalancing RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130214085925.GD28997@carfax.org.uk>
Date: Thu, 14 Feb 2013 11:05:39 -0700
Cc: Fredrik Tolf <fredrik@dolda2000.com>, linux-btrfs@vger.kernel.org
Message-Id: <19ABBC76-F774-4225-87A4-73A4D546F53F@colorremedies.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com> <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com> <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com> <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com> <17E4F30E-2945-44FE-A87F-0F475DFD794F@colorremedies.com> <alpine.DEB.2.02.1302140830310.8810@shack.dolda2000.com> <2D5AAB44-9DA8-460D-9141-3544DE6C45D7@colorremedies.com> <20130214085925.GD28997@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 14, 2013, at 1:59 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> 
>> Data, RAID1: total=2.66TB, used=2.66TB
> 
>   This is the amount of actual useful data (i.e. what you see with du
> or ls -l). Double this (because it's RAID-1) to get the number of
> bytes or raw storage used.

Right, the decoder ring. Effectively no outsiders will understand this. It contradicts the behavior of conventional df with btrfs volumes. And it becomes untenable with per subvolume profiles.


>> Total devices 2 FS bytes used 1.64TB
>> devid    1 size 2.73TB used 1.64TB path /dev/sdi1
>> devid    2 size 2.73TB used 2.67TB path /dev/sde1
> 
>   This is the amount of raw disk space allocated. The total of used
> here should add up to twice the "total" values above (for
> Data+Metadata+System).

I'm mostly complaining about the first line. If 2.67TB of writes to sde1 are successful enough to be stated as "used" on that device, then FS bytes used should be at least 2.67TB.

> 
>> So I can't tell if it's ~1.64TB copied or 2.6TB.
> 
>   Looks like /dev/sdi1 isn't actually being written to -- it should
> be the same allocation as /dev/sde1.

Yeah he's getting a lot of these, and I don't know what it is:

> Feb 14 08:32:30 nerv kernel: [180511.760850] lost page write due to I/O error on /dev/sdd1

It's not tied to btrfs or libata so I don't think it's the drive itself reporting the write error. I think maybe the kernel has become confused as a result of the original ICRC ABRT, and the subsequent change from sdd to sdi. 

Chris Murphy