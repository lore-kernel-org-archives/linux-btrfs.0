From: Chris Mason <chris.mason@oracle.com>
Subject: Re: abysmal performance
Date: Tue, 03 May 2011 07:06:41 -0400
Message-ID: <1304420743-sup-6185@think>
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

Older filefrag uses fibmap, which we don't support (we use fiemap instead).
If you update your e2fsprogs you should get a newer filefrag.

-chris
