Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:45902 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3FXPZu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 11:25:50 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 599B89A0422
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 09:25:50 -0600 (MDT)
Date: Mon, 24 Jun 2013 11:25:47 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?Q?Ond=C5=99ej?= Kunc <kunc88@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs lockup during defrag and removing device
Message-ID: <20130624152547.GH4288@localhost.localdomain>
References: <CAOEw3RbTrQkogo44sxdo62+Y8yJd_Bp_QTPQWW7-FVcv4TrJ6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAOEw3RbTrQkogo44sxdo62+Y8yJd_Bp_QTPQWW7-FVcv4TrJ6w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 24, 2013 at 12:25:07PM +0200, Ondřej Kunc wrote:
> Hi developers,
> 
> I have been playing with btrfs on our test server. I have streessed it
> much ... and I can say ... it's troughput and features are very nice
> and usable, but I experienced one problem during testing, btrfs
> triggered lockup of 3 of 8 CPU cores of testing server.
> 
> What I was doing ?
> 
> Simultaneously:
> - copying 130GB file on one subvolume to another file and measuring speed by pv
> - removing one device (/dev/md3) from btrfs
> - running btrfs defrag on whole  fs (via xargs)
> - rsyncing files from another server to subvolume
> - untaring the first 130GB tar to one subdirectory
> 
> Our server is HP-DL380, 12*146GB SAS HDD, 72GB RAM, Intel Xeon 5620
> Running uptodate debian wheezy with kernel and btrfs-tools from testing
> 3.9-1-amd64 #1 SMP Debian 3.9.6-1 x86_64 GNU/Linux
> # btrfs version
> Btrfs Btrfs v0.19
> 
> btrfs was created on top on 3 software RAID6 devices, every one built
> from 4 SAS drive
> 
> About one hour after this(see dmesg) server became inaccessible, so I
> had to restart it by power cycle.
> 
> After reboot there was problem with free space cache, but it was fixed
> automatically. I have one suspection, I have tried next this:
> 
> btrfs balance start /btrfs
> and then btrfs resize 4:max /btrfs (device was previosly smaller)
> 
> it failed with dmesg output: btrfs: dev
> add/delete/balance/replace/resize operation in progress.
> 
> So it is possible, that it is mutualy exclusive and should not be
> permitted in the other way, to start balance or defrag when device is
> being removed, is this true ?
> 
> Thank you all for your good work!
> 
> Ondrej Kunc
> 
> dmesg output: http://pastebin.com/Ndxypkxa
> 

So it seems like you hit some bug higher up that just made the system devolve
into this chain of panics.  I think you are probably hitting this

https://bugzilla.kernel.org/show_bug.cgi?id=59451

which the strato guys are working on.  If you take the "btrfs defrag" step out
of that test do you still have the same problem?  If yes then it may be
something new and could you file a new bugzilla if thats the case?  If it
doesn't reproduce with taking out the defrag step then just attach yourself to
that bugzilla with a "me too" so you can test whatever patch we come up with.
Thanks,

Josef
