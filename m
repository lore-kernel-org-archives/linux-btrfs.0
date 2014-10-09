Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo102.cox.net ([68.230.241.214]:36858 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbaJIMeF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Oct 2014 08:34:05 -0400
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo102.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20141009123404.KCWV24978.eastrmfepo102.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>; Thu, 9 Oct 2014 08:34:04 -0400
Date: Thu, 9 Oct 2014 05:34:02 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What is the vision for btrfs fs repair?
Message-ID: <20141009053402.7dc286f0@ws>
In-Reply-To: <107Y1p00G0wm9Bl0107vjZ>
References: <54358C77.2070808@redhat.com>
	<54367193.6000202@gmail.com>
	<pan$3113d$a3bae425$2c8363e3$ea9c68d9@cox.net>
	<107Y1p00G0wm9Bl0107vjZ>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 09 Oct 2014 08:07:51 -0400
Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> On 2014-10-09 07:53, Duncan wrote:
> > Austin S Hemmelgarn posted on Thu, 09 Oct 2014 07:29:23 -0400 as
> > excerpted:
> >
> >> Also, you should be running btrfs scrub regularly to correct
> >> bit-rot and force remapping of blocks with read errors.  While
> >> BTRFS technically handles both transparently on reads, it only
> >> corrects thing on disk when you do a scrub.
> >
> > AFAIK that isn't quite correct.  Currently, the number of copies is
> > limited to two, meaning if one of the two is bad, there's a 50%
> > chance of btrfs reading the good one on first try.
> >
> > If btrfs reads the good copy, it simply uses it.  If btrfs reads
> > the bad one, it checks the other one and assuming it's good,
> > replaces the bad one with the good one both for the read (which
> > otherwise errors out), and by overwriting the bad one.
> >
> > But here's the rub.  The chances of detecting that bad block are
> > relatively low in most cases.  First, the system must try reading
> > it for some reason, but even then, chances are 50% it'll pick the
> > good one and won't even notice the bad one.
> >
> > Thus, while btrfs may randomly bump into a bad block and rewrite it
> > with the good copy, scrub is the only way to systematically detect
> > and (if there's a good copy) fix these checksum errors.  It's not
> > that btrfs doesn't do it if it finds them, it's that the chances of
> > finding them are relatively low, unless you do a scrub, which
> > systematically checks the entire filesystem (well, other than files
> > marked nocsum, or nocow, which implies nocsum, or files written
> > when mounted with nodatacow or nodatasum).
> >
> > At least that's the way it /should/ work.  I guess it's possible
> > that btrfs isn't doing those routine "bump-into-it-and-fix-it"
> > fixes yet, but if so, that's the first /I/ remember reading of it.
> 
> I'm not 100% certain, but I believe it doesn't actually fix things on 
> disk when it detects an error during a read, I know it doesn't it the
> fs is mounted ro (even if the media is writable), because I did some 
> testing to see how 'read-only' mounting a btrfs filesystem really is.

Definitely it won't with a read-only mount.  But then scrub shouldn't
be able to write to a read-only mount either.  The only way a read-only
mount should be writable is if it's mounted (bind-mounted or
btrfs-subvolume-mounted) read-write elsewhere, and the write occurs to
that mount, not the read-only mounted location.

There's even debate about replaying the journal or doing orphan-delete
on read-only mounts (at least on-media, the change could, and arguably
should, occur in RAM and be cached, marking the cache "dirty" at the
same time so it's appropriately flushed if/when the filesystem goes
writable), with some arguing read-only means just that, don't
write /anything/ to it until it's read-write mounted.

But writable-mounted, detected checksum errors (with a good copy
available) should be rewritten as far as I know.  If not, I'd call it
a bug.  The problem is in the detection, not in the rewriting.  Scrub's
the only way to reliably detect these errors since it's the only thing
that systematically checks /everything/.

> Also, that's a much better description of how multiple copies work
> than I could probably have ever given.

Thanks.  =:^)

-- 
Duncan - No HTML messages please, as they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
