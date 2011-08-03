From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Honest timeline for btrfsck
Date: Wed, 03 Aug 2011 16:53:26 -0400
Message-ID: <1312404713-sup-6548@shiny>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Erik Jensen <eriksjunk@rkjnsn.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Erik Jensen's message of 2011-08-03 02:57:24 -0400:
> The lack of any information on when btrfsck might be ready is a real
> headache to those deciding what to do with a corrupted file system.
> 
> I am currently sitting on a btrfs array of 10 disks that has been
> reporting "parent transid verify failed" since last November. While
> the data on the drive is by no means irreplaceable, it would take a
> fair amount of effort. At the time I was told that a btrfsck would
> almost certainly be released by the end of the year. In January, it
> was "finally almost ready", and toward the end of May it was going to
> be released in "a couple of days
> (hopefully)".
> 
> Had I known back in November 9 months would go by with no such tool, I
> would have certainly wiped the array and started over, as it was
> certainly not worth the wait. So here I am, several assurances of
> imminent release later, still wondering whether it would be better to
> wait or cut my losses.
> 
> I understand that everyone is working hard, and I deeply appreciate
> the effort being put into this filesystem. I'm not looking for an
> exact date, just a rough order of magnitude on which to base
> decisions.

This part is definitely my fault.  I've gone through a bunch of
variations on bigger and smaller tools, and had to juggle the kernel
maintenance as well.

Aside from making sure the kernel code is stable, btrfsck is all I'm
working on right now.  I do expect a release in the next two weeks that
can recover your data (and many others).

Thanks,
Chris
