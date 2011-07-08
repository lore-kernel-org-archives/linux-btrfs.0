From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Memory leak?
Date: Fri, 08 Jul 2011 12:15:08 -0400
Message-ID: <1310141349-sup-9515@shiny>
References: <20110703190913.GA4474@yahoo.fr> <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com> <20110706081111.GA6931@yahoo.fr> <20110708124429.GB4284@yahoo.fr> <1310137241-sup-8158@shiny> <20110708154123.GA17886@yahoo.fr>
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110708154123.GA17886@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Stephane Chazelas's message of 2011-07-08 11:41:23 -0400:
> 2011-07-08 11:06:08 -0400, Chris Mason:
> [...]
> > So the invalidate opcode in btrfs-fixup-0 is the big problem.  We're
> > either failing to write because we weren't able to allocate memory (and
> > not dealing with it properly) or there is a bigger problem.
> > 
> > Does the btrfs-fixup-0 oops come before or after the ooms?
> 
> Hi Chris, thanks for looking into this.
> 
> It comes long before. Hours before there's any problem. So it
> seems unrelated.

It could be the cause of the problem.  We're calling BUG() with the page
locked, which means that page will never ever be freed, and since this
worker thread is gone, it could be messing up various parts of the
reclaim code.

But, this worker thread isn't supposed to get called very often...it's
really catching a corner of a corner of a strange race.  So we do need
to get a better understanding of why and how often.

You described this workload as rsync, is there anything else running?

I'd definitely try without -o compress_force.

-chris
