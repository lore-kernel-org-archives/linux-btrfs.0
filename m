From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Memory leak?
Date: Fri, 08 Jul 2011 12:17:54 -0400
Message-ID: <1310141768-sup-424@shiny>
References: <20110703190913.GA4474@yahoo.fr> <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com> <20110706081111.GA6931@yahoo.fr> <20110708124429.GB4284@yahoo.fr> <1310137241-sup-8158@shiny> <20110708154123.GA17886@yahoo.fr> <20110708161103.GD4284@yahoo.fr>
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110708161103.GD4284@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Stephane Chazelas's message of 2011-07-08 12:11:03 -0400:
> 2011-07-08 16:41:23 +0100, Stephane Chazelas:
> > 2011-07-08 11:06:08 -0400, Chris Mason:
> > [...]
> > > So the invalidate opcode in btrfs-fixup-0 is the big problem.  We're
> > > either failing to write because we weren't able to allocate memory (and
> > > not dealing with it properly) or there is a bigger problem.
> > > 
> > > Does the btrfs-fixup-0 oops come before or after the ooms?
> > 
> > Hi Chris, thanks for looking into this.
> > 
> > It comes long before. Hours before there's any problem. So it
> > seems unrelated.
> 
> Though every time I had the issue, there had been such an
> "invalid opcode" before. But also, I only had both the "invalid
> opcode" and memory issue when doing that rsync onto external
> hard drive.
> 
> > > Please send along any oops output during the run.  Only the first
> > > (earliest) oops matters.
> > 
> > There's always only  one in between two reboots. I've sent two
> > already, but here they  are:
> [...]
> 
> I dug up the traces for before I switched to debian (thinking
> getting a newer kernel would improve matters) in case it helps:
> 
> And:
> 
> Jun  5 00:58:10  BUG: Bad page state in process rsync  pfn:1bfdf
> Jun  5 00:58:10  page:ffffea000061f8c8 count:0 mapcount:0 mapping:          (null) index:0x2300
> Jun  5 00:58:10  page flags: 0x100000000000010(dirty)
> Jun  5 00:58:10  Pid: 1584, comm: rsync Tainted: G      D  C  2.6.38-7-server #35-Ubuntu
> Jun  5 00:58:10  Call Trace:

Ok, this one is really interesting.  Did you get this after another oops
or was it after a reboot?

How easily can you recompile your kernel with more debugging flags?
That should help narrow it down.  I'm looking for CONFIG_SLAB_DEBUG (or
slub) and CONFIG_DEBUG_PAGEALLOC

-chris
