Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.201]:65216 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab3HBU6p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Aug 2013 16:58:45 -0400
Received: from mailout-us.gmx.com ([172.19.198.47]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0Lkglc-1UVCCX0Kg8-00aRSb for
 <linux-btrfs@vger.kernel.org>; Fri, 02 Aug 2013 22:58:45 +0200
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Fri, 02 Aug 2013 16:58:42 -0400
From: "Mike Audia" <mikey_a@gmx.com>
Message-ID: <20130802205842.157580@gmx.com>
MIME-Version: 1.0
Subject: Re: Is the checkpoint interval adjustable?
To: dsterba@suse.cz, "Zach Brown" <zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> From: David Sterba
> There were a few requests to tune the interval. This finally made me to
> finish the patch and will send it in a second.

Thank you, David and to others who kindly replied to my post.  I will try your patch rather than modifying the code

> > >  Are there any unforeseen and effects of doing this?  Thank you for
> > > the consideration.
> >
> > I don't *think* that there should be. One way of looking at it is that
> > both 30 and 300 seconds are an *eternity* for cpu, memory, and storage.
> > Any trouble that you could get in to in 300 seconds some other machine
> > could trivially get in to in 30 with beefier hardware.
>
> That's a good point and lowers my worries a bit, though it would be
> interesting to see in what way a beefy machine blows with 300 seconds
> set.

I have my system booting to a BTRFS root partition.  Let's say I'm using a value of 300 for my checkpoint interval.  Does this mean that if I do a TON of filesystem writes (say I update my system which pulls down a bunch of system file updates for example), and I copy over several gigs of data from a backup, all _between_ checkpoints and for some reason, my system freezes forcing me to ungracefully restart... is EVERYTHING since the last checkpoint is lost?  Upon a reboot, will BTRFS just mount up to the last good checkpoiint automatically or will I have a broken system and need to add the `-o recovery` option while I mount it manualy from a chroot?

Another naive question: if I shutdown the system between checkpoints, systemd should umount my partitions.  Does the syncing of cached data occur after the graceful umount?
