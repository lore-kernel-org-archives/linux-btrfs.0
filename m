Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42931 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751283AbaF3DbG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 23:31:06 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can't mount subvolume with ro option
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53B0D220.3070608@cn.fujitsu.com>
Date: Sun, 29 Jun 2014 21:31:03 -0600
Cc: =?iso-8859-1?Q?S=E9bastien_ROHAUT?= <sebastien.rohaut@free.fr>,
        <linux-btrfs@vger.kernel.org>
Message-Id: <91D02487-0FB9-4EA5-87B0-C904EA8B6347@colorremedies.com>
References: <53ADCF0B.4010109@free.fr> <B87E6AE0-F47D-4F75-9628-E1151BB7467D@colorremedies.com> <54D8214E-1C00-43AB-A68A-D450069D878C@colorremedies.com> <53AEA0D3.8080905@free.fr> <53B0C93E.8050500@cn.fujitsu.com> <53B0D220.3070608@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 29, 2014, at 8:57 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> 
> Finally find the stable method to reproduce the problem on 3.16-rc2,
> the point is if we mount subvol,ro first, then you can't mount the hole device:
> 
> # mkfs.btrfs  -f /dev/sda6
> # mount /dev/sda6  /mnt/btrfs/
> # btrfs sub create /mnt/btrfs/subv
> Create subvolume '/mnt/btrfs/subv'
> # umount /mnt/btrfs
> # mount -o subvol=subv,ro /dev/sda6  /mnt/other/
> # LANG=C mount /dev/sda6  /mnt/btrfs/
> mount: /dev/sda6 is already mounted or /mnt/btrfs busy
>       /dev/sda6 is already mounted on /mnt/other

Similar problem: if you mount subvol,rw and then subvol,ro it succeeds, but then mount another subvol,rw it fails.


Chris Murphy