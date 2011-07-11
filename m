From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Mon, 11 Jul 2011 16:35:56 +0100
Message-ID: <chaz20110711153556.GC23450@seebyte.com>
References: <20110706081111.GA6931@yahoo.fr> <20110708124429.GB4284@yahoo.fr> <1310137241-sup-8158@shiny> <20110709170959.GC4294@yahoo.fr> <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com> <20110709203649.GE4294@yahoo.fr> <1310301809-sup-9903@shiny> <20110710183728.GB4277@yahoo.fr> <20110711090121.GA2537@yahoo.fr> <1310396262-sup-7882@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310396262-sup-7882@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-11 11:00:19 -0400, Chris Mason:
> Excerpts from Stephane Chazelas's message of 2011-07-11 05:01:21 -0400:
> > 2011-07-10 19:37:28 +0100, Stephane Chazelas:
> > > 2011-07-10 08:44:34 -0400, Chris Mason:
> > > [...]
> > > > Great, we're on the right track.  Does it trigger with mount -o compress
> > > > instead of mount -o compress_force?
> > > [...]
> > > 
> > > It does trigger. I get that same "invalid opcode".
> > > 
> > > BTW, I tried with CONFIG_SLUB and slub_debug and no more useful
> > > information than with SLAB_DEBUG.
> > > 
> > > I'm trying now without dmcrypt. Then I won't have much bandwidth
> > > for testing.
> > [...]
> > 
> > Same without dmcrypt. So to sum up, BUG() reached in btrfs-fixup
> > thread when doing an 
[...]
> > - CONFIG_SLAB_DEBUG, CONFIG_DEBUG_PAGEALLOC,
> >   CONFIG_DEBUG_SLAB_LEAK, slub_debug don't tell us anything
> >   useful (there's more info in /proc/slabinfo when
> >   CONFIG_SLAB_DEBUG is on, see below)
[...]
> This is some fantastic debugging, thank you.  I know you tested with
> slab debugging turned on, did you have CONFIG_DEBUG_PAGEALLOC on as
> well?

Yes when using SLAB, not when using SLUB.

> It's probably something to do with a specific file, but pulling that
> file out without extra printks is going to be tricky.  I'll see if I can
> reproduce it here.
[...]

For one occurrence, I know what file was being transfered at the
time of the crash (looking at ctimes on the dest FS, see one of
my earlier emails). And after just checking on the latest BUG(),
it's a different one.

Also, when I resume the rsync (so it doesn't transfer the
already transfered files), it does BUG() again.

regards,
Stephane
