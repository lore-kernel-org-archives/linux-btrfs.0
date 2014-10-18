Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38426 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaJRLVY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 07:21:24 -0400
Date: Sat, 18 Oct 2014 13:21:21 +0200
From: Petr Janecek <janecek@ucw.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: Poll: time to switch skinny-metadata on by default?
Message-ID: <20141018112121.GB17403@atrey.karlin.mff.cuni.cz>
References: <20141017123036.GA8052@atrey.karlin.mff.cuni.cz>
 <54415F1C.1060902@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54415F1C.1060902@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> >   so far I haven't succeeded running btrfs balance on a large
> >skinny-metadata fs -- segfault, kernel bug, reproducible.  No such
> >problems on ^skinny-metadata fs (same disks, same data).  Tried both
> >several times on 3.17.  More info in comments 10,14 in
> >https://bugzilla.kernel.org/show_bug.cgi?id=64961
> 
> I can't reproduce this, how big is your home directory, and are you
> still seeing corruptions after just rsyncing to a clean fs?  Thanks,

  as I wrote in comment 10, it has improved since year ago when I
reported it: I see no corruption at all, neither after rsync, nor after
balance crash: btrfs check doesn't find anything wrong, files look ok.
The only problem is that after adding a disk the balance segfaults on a
kernel bug and the fs gets stuck.  When I run balance again after
reboot, it makes only a very small progress and crashes again the same
way.
 
  There are some 2.5TB of data in 7.5M files on that fs.  And couple
dozen ro snapshots -- I'm testing 3.17 + revert of 9c3b306e1c9e right
now, but it takes more than day to copy the data and recreate all the
snapshots.  But a test with ^skinny-metadata showed no problems, so I
don't thing I got bitten by that bug.

  I have btrfs-image of one of previous runs after crashed balance.
It's 15GB. I can place it somewhere with fast link, are you interested?


Thanks,

Petr
