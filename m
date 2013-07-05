Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50259 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab3GEMco (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 08:32:44 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3BB8A7C0699
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 06:32:44 -0600 (MDT)
Date: Fri, 5 Jul 2013 08:32:41 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RESEND] Btrfs: fix wrong write offset when replacing a
 device
Message-ID: <20130705123241.GD2260@localhost.localdomain>
References: <1372947263-823-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1372947263-823-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 04, 2013 at 04:14:23PM +0200, Stefan Behrens wrote:
> Miao Xie reported the following issue:
> 
> The filesystem was corrupted after we did a device replace.
> 
> Steps to reproduce:
>  # mkfs.btrfs -f -m single -d raid10 <device0>..<device3>
>  # mount <device0> <mnt>
>  # btrfs replace start -rfB 1 <device4> <mnt>
>  # umount <mnt>
>  # btrfsck <device4>
> 
> The reason for the issue is that we changed the write offset by mistake,
> introduced by commit 625f1c8dc.
> 
> We read the data from the source device at first, and then write the
> data into the corresponding place of the new device. In order to
> implement the "-r" option, the source location is remapped using
> btrfs_map_block(). The read takes place on the mapped location, and
> the write needs to take place on the unmapped location. Currently
> the write is using the mapped location, and this commit changes it
> back by undoing the change to the write address that the aforementioned
> commit added by mistake.
> 

I'd like to see a xfstest for this please so we can make sure something like
this doesn't happen in the future.  You can use SCRATCH_DEV_POOL to have
multiple devices.  Please cc linux-btrfs when you submit it so I can review it
and hopefully get it in faster.  Thanks,

Josef
