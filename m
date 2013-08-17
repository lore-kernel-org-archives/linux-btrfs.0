Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35628 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab3HQL7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 07:59:04 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id BC47D9A04F8
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 05:59:03 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
References: <CAG-2HqVFdRjnK1LHnLDPm8frw1MtG2k44N=n4hhdv9kpdf4VoQ@mail.gmail. com>
 <pan$926b0$b4061d31$38c7ab48$19af94f0@cox.net>
In-Reply-To: <pan$926b0$b4061d31$38c7ab48$19af94f0@cox.net>
Message-ID: <20130817115901.17880.38963@localhost.localdomain>
Subject: Re: Question: btrfs-progs releases?
Date: Sat, 17 Aug 2013 07:59:01 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Duncan (2013-08-17 01:02:45)
> Tom Gundersen posted on Sat, 17 Aug 2013 11:19:19 +0800 as excerpted:
> 
> > I package btrfs-progs for Arch Linux, and I'm wondering about its
> > current status.
> > 
> > I have seen repeated talk of making regular releases, but so far we
> > haven't had a proper release since v19 four years ago.
> > 
> > Are we to take from this that btrfs-progs is not suitable for
> > distribution yet, and if so, would we be better off not shipping it at
> > all? Or are there other reasons releases are not made?
> > 
> > I get frequent requests for shipping new git snapshots, but I'd rather
> > not ship something that upstream does not deem ready for release.

The problem with the progs release is I keep finding more things I want
to add.  My local git tree has about a dozen commits that I feel are
important enough for v1.0.  I just have to cut it, the distros and
others are completely correct in asking for an official release.

In terms of the quality of the commits, I only put things into the
master branch of the git tree that I have fully confidence in.

> 
> Most of the following can be found on the btrfs wiki, at:
> 
> https://btrfs.wiki.kernel.org/
> 
> Well, both btrfs kernel code and btrfs-progs remain officially under 
> heavy development, and bugs continue to be fixed with every release, so 
> people who do choose to run it are *STRONGLY* encouraged both to keep 
> their backups current (even more so than one would do with a stable 
> filesystem), and to run at LEAST latest stable kernel if not the rcs, as 
> well as to read the wiki and keep up with this list so they know what's 
> going on with the filesystem they've chosen to test.
> 
> (FWIW, here, I run linus kernel git, but normally try to switch over 
> about rc2 or 3, sticking to the previous version until then.)

> 
> Most distros who make btrfs available are packaging btrfs-progs git 
> snapshots, because the same general theme applies to btrfs-progs -- bugs 
> are REGULARLY being fixed, and if you're running old code, you really ARE 
> taking unnecessary risks (in addition to any bug reports not being as 
> helpful because you're running stale code).
> 
> That said, btrfs used as a traditional filesystem is the most mature and 
> has been more or less stable (for an experimental filesystem) for some 
> time now, with btrfs raid0/1/10 modes newer but now reasonably stable as 
> well. (I'm running btrfs raid1 mode here, but with backups both to a 
> second btrfs instance and to reiserfs, my former filesystem of choice, 
> which has proven VERY stable and reliable for me, but isn't a good match 
> for SSDs.)
> 
> But the new (kernel 3.10) btrfs raid5/6 code isn't usable except for pure 
> testing ATM, as the code writes the raid checksums but does not yet know 
> how to use them in case of device failure (someone in another thread just 
> reported it segfaulting on device removal), so it works in all-OK mode 
> only.  Personally, I wouldn't put my data on that (even with backups) at 
> least for another couple kernels, and probably until about this time next 
> year.

This isn't entirely true, the raid5/6 code does use the checksums for
rebuild in the kernel and it can handle devices going away (I'm looking
into the report on the list).

The missing part of the raid5/6 code is keeping parity in sync after a
crash.  Any blocks in flight during a crash may or may not have parity
matching the blocks, and they need to be re-written when the box comes
up for the parity to be useful.  The data/metadata itself is protected
by the COW system, its just the parity that needs extra work.

-chris

