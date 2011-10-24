From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: how stable are snapshots at the block level?
Date: Mon, 24 Oct 2011 15:08:30 +0000 (UTC)
Message-ID: <slrnjaavrd.ml8.stephane.chazelas@spam.is.invalid>
References: <CAKvOHKABup6D2pwbiZpCfxoHt7Obv6sHAZqcPp=ce9ZcJ8-vuw@mail.gmail.com>
 <000101cc918d$3ffb45b0$bff1d110$@nedharvey.com>
 <CAKvOHKCjxxKTahivOuRBPBB89JBrTwndQ6cCEuFaPbJr8PYtpA@mail.gmail.com>
 <000001cc9255$2b34fc70$819ef550$@nedharvey.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-10-24, 09:59(-04), Edward Ned Harvey:
[...]
> If you are reading the raw device underneath btrfs, you are
> not getting the benefit of the filesystem checksumming.  If
> you encounter an undetected read/write error, it will silently
> pass.  Your data will be corrupted, you'll never know about it
> until you see the side-effects (whatever they may be).
[...]

I don't follow you here. If you're cloning a device holding a
btrfs FS, you'll clone the checksums as well. If there were
errors, they will be detected on the cloned FS as well?

> There is never a situation where block level copies have any
> advantage over something like btrfs send.  Except perhaps
> forensics or espionage.  But in terms of fast efficient
> reliable backups, btrfs send has every advantage and no
> disadvantage compared to block level copy.

$ btrfs send
ERROR: unknown command 'send'
Usage:
[...]

(from 2011-10-12 integration branch). Am I missing something?

> There are many situations where btrfs send has an advantage
> over both block level and file level copies.  It instantly
> knows all the relevant disk blocks to send, it preserves every
> property, it's agnostic about filesystem size or layout on
> either sending or receiving end, you have the option to create
> different configurations on each side, including compression
> etc.  And so on.
[...]

That sounds like "zfs send", I didn't know btrfs had it yet.

My understanding was that to clone/backup a btrfs FS, you could
only clone the block devices or use the "device add" + "device
del" trick with some extra copy-on-write (LVM, nbd) layer.

-- 
Stephane

