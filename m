Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53108 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3CVMH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 08:07:58 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 284987C040A
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 06:07:58 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Alexandre Oliva <oliva@gnu.org>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <orzjxw9f75.fsf@livre.home>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <orhak8fm0u.fsf@livre.home>
 <20130318225245.25964.22219@localhost.localdomain>
 <orzjy0dkz9.fsf@livre.home>
 <20130319120940.29898.80124@localhost.localdomain>
 <ora9pzdwdw.fsf@livre.home> <or1ubaesrx.fsf@livre.home>
 <ord2utb4xx.fsf@livre.home>
 <20130321180614.30044.29961@localhost.localdomain>
 <20130321230621.30044.80640@localhost.localdomain>
 <orzjxw9f75.fsf@livre.home>
Message-ID: <20130322120754.27874.14389@localhost.localdomain>
Subject: Re: corruption of active mmapped files in btrfs snapshots
Date: Fri, 22 Mar 2013 08:07:54 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Alexandre Oliva (2013-03-22 01:27:42)
> On Mar 21, 2013, Chris Mason <chris.mason@fusionio.com> wrote:
> 
> > Quoting Chris Mason (2013-03-21 14:06:14)
> >> With mmap the kernel can pick any given time to start writing out dirty
> >> pages.  The idea is that if the application makes more changes the page
> >> becomes dirty again and the kernel writes it again.
> 
> That's the theory.  But what if there's some race between the time the
> page is frozen for compressing and the time it's marked as clean, or
> it's marked as clean after it's further modified, or a subsequent write
> to the same page ends up overridden by the background compression of the
> old contents of the page?  These are all possibilities that come to mind
> without knowing much about btrfs inner workings.

Definitely, there is a lot of room for racing.  Are you using
compression in btrfs or just in leveldb?

> 
> >> So the question is, can you trigger this without snapshots being done
> >> at all?
> 
> I haven't tried, but I now have a program that hit the error condition
> while taking snapshots in background with small time perturbations to
> increase the likelihood of hitting a race condition at the exact time.
> It uses leveldb's infrastructure for the mmapping, but it shouldn't be
> too hard to adapt it so that it doesn't.
> 
> > So my test program creates an 8GB file in chunks of 1MB each.
> 
> That's probably too large a chunk to write at a time.  The bug is
> exercised with writes slightly smaller than a single page (although
> straddling across two consecutive pages).
> 
> This half-baked test program (hereby provided under the terms of the GNU
> GPLv3+) creates a btrfs subvolume and two files in it: one in which I/O
> will be performed with write()s, another that will get the same data
> appended with leveldb's mmap-based output interface.  Random block
> sizes, as well as milli and microsecond timing perturbations, are read
> from /dev/urandom, and the rest of the output buffer is filled with
> (char)1.
> 
> The test that actually failed (on the first try!, after some other
> variations that didn't fail) didn't have any of the #ifdef options
> enabled (i.e., no -D* flags during compilation), but it triggered the
> exact failure observed with ceph: zeros at the end of a page where there
> should have been nonzero data, followed by nonzero data on the following
> page!  That was within snapshots, not in the main subvol, but hopefully
> it's the same problem, just a bit harder to trigger.

I'd like to take snapshots out of the picture for a minute.  We need
some way to synchronize the leveldb with snapshotting because the
snapshot is basically the same thing as a crash from a db point of view.

Corrupting the main database file is a much different (and bigger)
problem.

-chris

