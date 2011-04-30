From: John Wyzer <john.wyzer@gmx.de>
Subject: Re: abysmal performance
Date: Sun, 01 May 2011 00:33:20 +0200
Message-ID: <1304202606-sup-1414@localhost>
References: <1304088305-sup-3784@localhost> <1304089239-sup-5110@think> <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com> <1304195921-sup-9266@localhost> <BANLkTims8NH-2V_ytOSfVWkAGtEDmGdT7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTims8NH-2V_ytOSfVWkAGtEDmGdT7A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mitch Harder's message of Sun May 01 00:16:53 +0200 2011:
> > Hmm.
> > Tried it and it gives me about 500000 lines of
> >
> > FIBMAP: Invalid argument
> >
> > and then:
> >
> > large_file: 1 extent found
> >
> > Is that the way it is supposed to work?
> > Just asking because this was part of a vmware disk image. Both the virtual
> > machine and the rest of the host system are almost unusable once the VM ist
> > started (even more unusable than without vmware :-D )
> 
> No.  It sounds like the filefrag command is getting confused in the
> virtual environment.

Misunderstanding :-) I tried filefrag _on_ a vmware disk image, not  inside a
virtual machine.
The whole btrfs story here is on a real machine.
