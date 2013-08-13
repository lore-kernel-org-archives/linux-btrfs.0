Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36351 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034Ab3HMPhW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 11:37:22 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 79E927C069F
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 09:37:21 -0600 (MDT)
Date: Tue, 13 Aug 2013 11:37:19 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: dima <dolenin@parallels.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-ino-cache is running on each reboot
Message-ID: <20130813153719.GH2150@localhost.localdomain>
References: <52098BDB.5010400@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <52098BDB.5010400@parallels.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 13, 2013 at 10:28:59AM +0900, dima wrote:
> Hello all,
> 
> About a week or so ago I noticed that [btrfs-ino-cache] process was
> appearing in the 'top' on each reboot and disk is spinning like crazy for
> about five minutes or so. Quite so often this caused X failing to start
> because all I/O was busy with caching.
> Even after letting it to calm down and seeing [btrfs-ino-cache] disappearing
> from the process list, on next reboot it starts all over again.
> 
> Here is the fstab entry that I have
> 
> UUID=430dca92-9541-4201-0f62-373e30beadac / btrfs subvol=root_subvolume,defaults,noatime,noacl,compress=lzo,inode_cache,space_cache,autodefrag
> 0 0
> 
> inode_cache was always enabled since the FS was created about a year or so
> ago, and actually I have never had any problems with it up until recently.
> 
> Removing inode_cache option from fstab solves the problem, but I am not sure
> if it is the right choice.
> I can observe the problem at least in the vanilla kernel 3.10.4 ~ 6 (did not
> try older versions)
> 
> What could be the reason for such behavior and how to avoid it?
> 

That's odd.  Can you apply patches and build kernels so I can try and narrow
down what is happening?  Thanks,

Josef
