From: Chris Mason <chris.mason@oracle.com>
Subject: Re: abysmal performance
Date: Tue, 03 May 2011 07:08:54 -0400
Message-ID: <1304420831-sup-4737@think>
References: <1304088305-sup-3784@localhost> <1304089239-sup-5110@think> <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com> <20110430235539.6205.qmail@stuge.se> <ipolll$2h0$1@dough.gmane.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bernhard Schmidt <berni@birkenwald.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <ipolll$2h0$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Bernhard Schmidt's message of 2011-05-03 06:33:25 -0400:
> Peter Stuge <peter@stuge.se> wrote:
> 
> Hey,
> 
> defragging btrfs does not seem to work for me. I have run the filefrag
> command over the whole fs and (manually) tried to defrag a few heavily
> fragmented files, but I don't get it to work (it still has the same
> number of extends and they are horrently uncorrelated)
> 
> root@schleppi:~# filefrag
> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1
> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1: 72 extents found
> root@schleppi:~# btrfs filesystem defrag
> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1
> root@schleppi:~# filefrag
> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1
> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1: 72 extents found
> 
> I'm using Ubuntu Natty (2.6.38.4) and tried both btrfs-tools from Natty
> (201006xx) and from Debian experimental (git from 20101101). Both show
> the same symptoms. I don't think fragmentation is bad on this box (due
> to having an SSD), but my system at home is getting dog slow and I'd
> like to try that when I come home end of the week.

Do you have compression on?

The file the defrag ioctl works is that it schedules things for defrag
but doesn't force out the IO immediately unless you use -f.

So, to test the result of the defrag, you need to either wait a bit or
run sync.

-chris
