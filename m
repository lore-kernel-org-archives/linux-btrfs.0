From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Memory leak?
Date: Mon, 11 Jul 2011 11:00:19 -0400
Message-ID: <1310396262-sup-7882@shiny>
References: <20110703190913.GA4474@yahoo.fr> <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com> <20110706081111.GA6931@yahoo.fr> <20110708124429.GB4284@yahoo.fr> <1310137241-sup-8158@shiny> <20110709170959.GC4294@yahoo.fr> <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com> <20110709203649.GE4294@yahoo.fr> <1310301809-sup-9903@shiny> <20110710183728.GB4277@yahoo.fr> <20110711090121.GA2537@yahoo.fr>
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110711090121.GA2537@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Stephane Chazelas's message of 2011-07-11 05:01:21 -0400:
> 2011-07-10 19:37:28 +0100, Stephane Chazelas:
> > 2011-07-10 08:44:34 -0400, Chris Mason:
> > [...]
> > > Great, we're on the right track.  Does it trigger with mount -o compress
> > > instead of mount -o compress_force?
> > [...]
> > 
> > It does trigger. I get that same "invalid opcode".
> > 
> > BTW, I tried with CONFIG_SLUB and slub_debug and no more useful
> > information than with SLAB_DEBUG.
> > 
> > I'm trying now without dmcrypt. Then I won't have much bandwidth
> > for testing.
> [...]
> 
> Same without dmcrypt. So to sum up, BUG() reached in btrfs-fixup
> thread when doing an 

This is some fantastic debugging, thank you.  I know you tested with
slab debugging turned on, did you have CONFIG_DEBUG_PAGEALLOC on as
well?

It's probably something to do with a specific file, but pulling that
file out without extra printks is going to be tricky.  I'll see if I can
reproduce it here.

-chris
