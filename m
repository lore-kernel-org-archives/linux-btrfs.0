From: Chris Mason <chris.mason@oracle.com>
Subject: Re: abysmal performance
Date: Tue, 03 May 2011 07:36:47 -0400
Message-ID: <1304422493-sup-6212@think>
References: <1304088305-sup-3784@localhost> <1304089239-sup-5110@think> <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com> <20110430235539.6205.qmail@stuge.se> <ipolll$2h0$1@dough.gmane.org> <1304420831-sup-4737@think> <4DBFE75C.2000104@birkenwald.de>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bernhard Schmidt <berni@birkenwald.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DBFE75C.2000104@birkenwald.de>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Bernhard Schmidt's message of 2011-05-03 07:30:36 -0400:
> Am 03.05.2011 13:08, schrieb Chris Mason:
> 
> >> defragging btrfs does not seem to work for me. I have run the filefrag
> >> command over the whole fs and (manually) tried to defrag a few heavily
> >> fragmented files, but I don't get it to work (it still has the same
> >> number of extends and they are horrently uncorrelated)
> >>
> >> root@schleppi:~# filefrag
> >> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1
> >> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1: 72 extents found
> >> root@schleppi:~# btrfs filesystem defrag
> >> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1
> >> root@schleppi:~# filefrag
> >> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1
> >> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1: 72 extents found
> >>
> >> I'm using Ubuntu Natty (2.6.38.4) and tried both btrfs-tools from Natty
> >> (201006xx) and from Debian experimental (git from 20101101). Both show
> >> the same symptoms. I don't think fragmentation is bad on this box (due
> >> to having an SSD), but my system at home is getting dog slow and I'd
> >> like to try that when I come home end of the week.
> > 
> > Do you have compression on?
> 
> Yes. lzo to be exact.
> 
> > The file the defrag ioctl works is that it schedules things for defrag
> > but doesn't force out the IO immediately unless you use -f.
> > 
> > So, to test the result of the defrag, you need to either wait a bit or
> > run sync.
> 
> Did so, no change. See my reply to cwillu for the data.
> 
> I usually mount my / without any compression option and did "mount -o
> remount,compress=lzo /" before. I cannot reboot at the moment and I did
> not find any option to disable compression again. There does not seem to
> be a "nocompress" or "compress=[none|off]" option. Is this correct?

Using compression is not a problem, but in order to reduce the maximum
amount of ram we need to uncompress an extent, we enforce a max size on
the extent.  So you'll tend to have more extents, but they should be
close together on disk.

Could you please do a filefrag -v on the file?  Lets see how bad it
really is.

-chris
