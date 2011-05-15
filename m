From: Wayne Scott <wsc9tt@gmail.com>
Subject: Re: crash in btrfsck, btrfs-debug-tree, etc
Date: Sun, 15 May 2011 23:03:17 +0000 (UTC)
Message-ID: <loom.20110516T005955-307@post.gmane.org>
References: <4BD89481.1060201@acm.org> <4BDF4013.7090000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> on 04/28/2010 01:03 PM Vladimir G. Ivanovic said the following:
> > I overwrote some part of the first 195641856 bytes of a 1TB (nominal)
> > btrfs volume (I CTRL-C'd out
> > before dd finished.) OK, OK, you may stop laughing now. Surely something
> > similar has happened to
> > you. No? Then it will, someday.
> >
> > Now, onto my problems. My first thought was to btrfsck the unmount
> > volume, but btrfsck crashes:
> >
> >     # btrfsck /dev/sdc1
> >     btrfsck: disk-io.c:723: open_ctree_fd: Assertion
> > `!(!chunk_root->node)' failed.
> >     Aborted (core dumped)

I have the same fsck error and mount just says "wrong fs type...".

But as far as I know, I never corrupted the drive...

This is Ubuntu Natty.

Just thought I would share that.

-Wayne



