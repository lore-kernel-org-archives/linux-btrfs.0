Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:59763 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932210AbaCQBGY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 21:06:24 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to handle a RAID5 arrawy with a failing drive? 
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140317005145.GZ16946@merlins.org>
Date: Sun, 16 Mar 2014 19:06:23 -0600
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <99A46301-9C0E-43F0-8415-E23B86FDB5E2@colorremedies.com>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20140316222026.GU16946@merlins.org>
 <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com>
 <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com>
 <20140316231729.GA29149@merlins.org>
 <85AE52FE-5191-49AF-98A9-380F224A5DA1@colorremedies.com>
 <20140317005145.GZ16946@merlins.org>


On Mar 16, 2014, at 6:51 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
> 
> polgara:/mnt/btrfs_backupcopy# btrfs device delete /dev/mapper/crypt_sde1 `pwd`
> ERROR: error removing the device '/dev/mapper/crypt_sde1' - Invalid argument

You didn't specify a mount point, is the reason for that error. But also, since you're already effectively degraded with 1 disk you can't remove a 2nd without causing array collapse. You have to add a new device first *and* you have to "rebuild" with balance. Then presumably we can remove the device. But I'm stuck adding so I can't test anything else.

> 
> So from here, it sounds like I can try:
> 1) unmount the filesystem
> 2) hope that remounting it without that device will work
> 3) btrfs device add to recreate the missing drive.
> 
> Before I do #1 and get myself in a worse state than I am (working
> filesystem), does that sound correct?
> 
> (again, the data is irrelevant, I have a btrfs receive on it that has
> been running for hours and that I'd have to restart, but that's it).

Well at this point I'd leave it alone because at least for me, device add hangs that command and all other subsequent btrfs user space commands. So for all I know (untested) the whole volume will block on this device add and is effectively useless.

Chris Murphy