From: Chris Mason <chris.mason@oracle.com>
Subject: Re: abysmal performance
Date: Tue, 03 May 2011 07:05:07 -0400
Message-ID: <1304420518-sup-3459@think>
References: <1304088305-sup-3784@localhost> <1304089239-sup-5110@think> <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com> <1304195921-sup-9266@localhost> <BANLkTims8NH-2V_ytOSfVWkAGtEDmGdT7A@mail.gmail.com> <1304202606-sup-1414@localhost>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: John Wyzer <john.wyzer@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1304202606-sup-1414@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from John Wyzer's message of 2011-04-30 18:33:20 -0400:
> Excerpts from Mitch Harder's message of Sun May 01 00:16:53 +0200 2011:
> > > Hmm.
> > > Tried it and it gives me about 500000 lines of
> > >
> > > FIBMAP: Invalid argument
> > >
> > > and then:
> > >
> > > large_file: 1 extent found
> > >
> > > Is that the way it is supposed to work?
> > > Just asking because this was part of a vmware disk image. Both the virtual
> > > machine and the rest of the host system are almost unusable once the VM ist
> > > started (even more unusable than without vmware :-D )
> > 
> > No.  It sounds like the filefrag command is getting confused in the
> > virtual environment.
> 
> Misunderstanding :-) I tried filefrag _on_ a vmware disk image, not  inside a
> virtual machine.
> The whole btrfs story here is on a real machine.

The most important files to defrag are going to be your internal firefox
files (I think in .mozilla), your sup database (in .sup) and your vmware
images.  I would definitely suggest that you try to narrow down if
vmware is making the machine seem much slower after the defrag is done.

It might make sense to run the nocow ioctl on your vmware images, they
are probably triggering lots of seeks.

You'll notice the machine is much slower after a reboot, this is because
we have to do a lot of IO to recache the extent allocation tree.  If you
pull from the btrfs-unstable tree, you can use mount -o space_cache,
which cuts down on the reading after a reboot dramatically.

If none of this works, we'll look at the files that you're fsyncing.
That seems to be the bulk of your latencies.

-chris
