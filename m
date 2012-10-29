Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46040 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab2J2Rtt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 13:49:49 -0400
Date: Mon, 29 Oct 2012 10:42:47 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Need help mounting laptop corrupted root btrfs. Kernel BUG at
 fs/btrfs/volumes.c:3707
Message-ID: <20121029174247.GA7796@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121029154713.GF8019@merlins.org>
 <B19885DE-6AED-4B8B-B1CA-891878B43C8C@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

Thanks for the reply and hints.

On Sun, Oct 28, 2012 at 11:05:42PM -0600, Chris Murphy wrote:
> > I also have hourly, daily, weekly
> > btrfs subvolume snapshots, but I can't use those currently since I can't
> > mount the base filesystem.
> 
> It might be worth unmounting it. Then only remounting a snapshot well
> before the problem started, yet still current enough to be useful: use
> '-o subvol=' instead of trying to mount from the top. Each subvolume
> is a root directory, so it might be possible to find one that will
> mount directly.
 
So, I had thought about going back to an old snapshot, but the problem
is that my snapshots have pseudo random names based on cron times when
they're taken.
Because I couldn't mount the root so I couldn't find the snapshot names.
Is there a way to get a list of snapshots from a btrfs FS without
mounting it?

> > I'm a bit surprised that no one seems to be replying on btrfs crashes,
> > that's a bit worrisome. I'm willing to risk my data somewhat, but if finding
> > a problem doesn't help fixing the code, I'm not sure if I'm helping anymore
> > :-/
> 
> Lurking, I've learned this means you either didn't provide enough
> information for anyone to go on, or the problem is known. I suspect
> the former. Kernel 3.5.0 or 3.6.2 doesn't say where it came from, what

Fair enough. At the time I thought it didn't really matter how the bug
happened, and more that btrfs shouldn't crash my kernel when there is
some minor problem with the filesystem.
In my case, I'm convinced it was simply a problem that all the writes
did not make it to disk before the device disconnected for some unknown
reason (not related to btrfs).

> distribution, or what version of btrfs is included in that distros

debian unstable although it didn't seem relevant since it's the kernel
in initrd that can't mount the filesystem. Userland seems to be btrfs
0.19 as per the output I posted.

> kernel. And I'm not seeing that you're using a debug kernel, which
> will actually produce useful error messages.

Thanks for pointing that out. I'll admit that I'm not sure what kernel
build options I'm supposed to add to help. I asked about that in the
past, but never heard back.
What do you recommend I add in .config?

> And it's over a weekend for another thing.

Well, it was thursday when I posted :)

Now, I get the general point that I have no paid support, and I'm not
even sure there is any official support for kernel.org from yesterday or
last week (just a few vendor kernels).
At the same time, if brave testers are risking their data to help test
the filesystem, it's also good if they feel re-assured that they'll get
help or that if their data is gone, whatever bug they found was useful
to someone.

Now, there is a good ending to this story, thanks to you no less, I'll
post in another message not to burry it down there.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
