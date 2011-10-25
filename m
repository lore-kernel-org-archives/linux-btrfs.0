From: Edward Ned Harvey <kernel@nedharvey.com>
Subject: RE: how stable are snapshots at the block level?
Date: Tue, 25 Oct 2011 07:46:48 -0400
Message-ID: <000501cc930b$cae17bc0$60a47340$@nedharvey.com>
References: <CAKvOHKABup6D2pwbiZpCfxoHt7Obv6sHAZqcPp=ce9ZcJ8-vuw@mail.gmail.com> <000101cc918d$3ffb45b0$bff1d110$@nedharvey.com> <CAKvOHKCjxxKTahivOuRBPBB89JBrTwndQ6cCEuFaPbJr8PYtpA@mail.gmail.com> <000001cc9255$2b34fc70$819ef550$@nedharvey.com> <slrnjaavrd.ml8.stephane.chazelas@spam.is.invalid>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "'Stephane CHAZELAS'" <stephane_chazelas@yahoo.fr>,
	<linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <slrnjaavrd.ml8.stephane.chazelas@spam.is.invalid>
List-ID: <linux-btrfs.vger.kernel.org>

> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Stephane CHAZELAS
> 
> 2011-10-24, 09:59(-04), Edward Ned Harvey:
> [...]
> > If you are reading the raw device underneath btrfs, you are
> > not getting the benefit of the filesystem checksumming.  If
> > you encounter an undetected read/write error, it will silently
> > pass.  Your data will be corrupted, you'll never know about it
> > until you see the side-effects (whatever they may be).
> [...]
> 
> I don't follow you here. If you're cloning a device holding a
> btrfs FS, you'll clone the checksums as well. If there were
> errors, they will be detected on the cloned FS as well?

You're right and I'm right.  You will have read them, transferred them, and
written them without checking them.  So any corruption at this point is
undetected.  But later when you mount the destination FS, you would then be
checking checksums again.


> > There is never a situation where block level copies have any
> > advantage over something like btrfs send.  Except perhaps
> > forensics or espionage.  But in terms of fast efficient
> > reliable backups, btrfs send has every advantage and no
> > disadvantage compared to block level copy.
> 
> $ btrfs send
> ERROR: unknown command 'send'
> Usage:
> [...]
> 
> (from 2011-10-12 integration branch). Am I missing something?

As previously mentioned in this thread, btrfs send (or whatever it will be
called) is not available yet.

My suggestion to the OP of this thread is to use rsync for now, wait for
btrfs send, or switch to zfs.

