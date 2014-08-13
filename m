Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50081 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbaHMPgI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 11:36:08 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by gateway1.nyi.internal (Postfix) with ESMTP id 07DFA352A1
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 11:36:07 -0400 (EDT)
Message-Id: <1407944166.3763056.152323965.0FFD88B6@webmail.messagingengine.com>
From: Rasmus Abrahamsen <me@rasmusa.net>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
In-Reply-To: <20140813145155.GA20611@merlins.org>
References: <53EAF935.4040605@rasmusa.net> <20140813145155.GA20611@merlins.org>
Subject: Re: delete missing /dev/sdd which is now added as /dev/sdd1
Date: Wed, 13 Aug 2014 17:36:06 +0200
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

/mnt is the mount point. I now did the following

dd if=/dev/zero of=/dev/sdd

Finally, btrfs does not recognize the partition as part of my raid
anymore, but what's worse is that it now tells me that two missing
devices is a no go, so I cannot mount it as anything but read-only. All
the data is there, /dev/sdd1 was never used and /dev/sdd was the
originally missing one. Mounting as read-only prevents you from adding
devices.

I guess I have to start over... At least the old pool is still readable.
Sucks that I have to rebuild it though. I guess there is no way to keep
my snapshots without having them fill their full size.

On Wed, Aug 13, 2014, at 04:51 PM, Marc MERLIN wrote:
> On Wed, Aug 13, 2014 at 07:35:49AM +0200, Rasmus Abrahamsen wrote:
> > I added the /dev/sdd1 to my raid and deleted the missing. Now the
> > /dev/sdd does not show up anymore and I have a /dev/sdd1. But I still
> > have the **** Some devices missing and the command btrfs delete missing
> > /mnt does not actually do anything. I tried btrfs delete /dev/sdd /mnt
> > but it said that /dev/sdd was busy.
> 
> Have you tried
> btrfs device delete missing /mnt/mountpoint ?
>  
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" -
> A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet
>                                       cooking
> Home page: http://marc.merlins.org/  
