From: Edward Ned Harvey <kernel@nedharvey.com>
Subject: RE: how stable are snapshots at the block level?
Date: Mon, 24 Oct 2011 09:59:32 -0400
Message-ID: <000001cc9255$2b34fc70$819ef550$@nedharvey.com>
References: <CAKvOHKABup6D2pwbiZpCfxoHt7Obv6sHAZqcPp=ce9ZcJ8-vuw@mail.gmail.com>	<000101cc918d$3ffb45b0$bff1d110$@nedharvey.com> <CAKvOHKCjxxKTahivOuRBPBB89JBrTwndQ6cCEuFaPbJr8PYtpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: "'Mathijs Kwik'" <mathijs@bluescreen303.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKvOHKCjxxKTahivOuRBPBB89JBrTwndQ6cCEuFaPbJr8PYtpA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> From: Mathijs Kwik [mailto:mathijs@bluescreen303.nl]
> Sent: Sunday, October 23, 2011 11:20 AM
> 
> > Also if you're rsyncing the block level device, you're running underneath
> btrfs and losing any checksumming benefit that btrfs was giving you, so
> you're possibly introducing risk for silent data corruption.  (Or more
> accurately, failing to allow btrfs to detect/correct it.)
> 
> Not sure... I'm sure that's the case for in-use subvolumes, but
> shouldn't snapshots (and their metadata/checksums) just be safe?

Nope.  The whole point of checksumming is like this:  All devices are imperfect.  They have built-in error detection and correction.  Whenever an error occurs (which is often) the drive tries to silently correct it (reread) without telling the OS.  But the checksumming in hardware is rather weak.  Sometimes you'll get corrupt data that passes the hardware test and reaches the OS without any clue that it's wrong.  I find that a typical small business fileserver (10 sata disks) hits these approx once a year.

Filesystem checksumming is much stronger (lower probability to silently allow an error).  Like randomly selecting a single molecule twice consecutively amongst all the molecules in the solar system.  Like much less likely to occur than the end of the human race, etc.  So when the silent errors occur, filesystem checksumming definitely detects it, and if possible, corrects it.   

If you are reading the raw device underneath btrfs, you are not getting the benefit of the filesystem checksumming.  If you encounter an undetected read/write error, it will silently pass.  Your data will be corrupted, you'll never know about it until you see the side-effects (whatever they may be).

While people with computers have accepted this level of unreliability for years (fat32, ntfs, ext3/4, etc) people are now beginning to recognize the importance on a greater scale.  Once corrupted, always corrupted.  People want to keep their data indefinitely.  


> Thanks for your advice,
> Like I said, for me, right now, sticking to tried-and-tested
> file-based rsync is just ok. But I hope to get some insights into
> other possibilities. btrfs send sounds cool, but I sure hope this is
> not the only solution, as I described a few scenarios where
> block-level copies have advantages.

There is never a situation where block level copies have any advantage over something like btrfs send.  Except perhaps forensics or espionage.  But in terms of fast efficient reliable backups, btrfs send has every advantage and no disadvantage compared to block level copy.

There are many situations where btrfs send has an advantage over both block level and file level copies.  It instantly knows all the relevant disk blocks to send, it preserves every property, it's agnostic about filesystem size or layout on either sending or receiving end, you have the option to create different configurations on each side, including compression etc.  And so on.

