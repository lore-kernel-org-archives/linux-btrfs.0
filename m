From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG: kernel bug caught at 55% mark of portage cache
 update
Date: Fri, 19 Dec 2008 11:32:10 -0500
Message-ID: <1229704330.6695.21.camel@think.oraclecorp.com>
References: <FD060D90-0C58-4222-8A56-CDE0B47AD6DC@trustbearer.com>
	 <1229703379.6695.18.camel@think.oraclecorp.com>
	 <f0d609a70812190824o24b04d90j272476e149d6cff3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Thomas Harning <thomas.harning@trustbearer.com>,
	linux-btrfs@vger.kernel.org
To: Julian Andres Klode <jak@jak-linux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f0d609a70812190824o24b04d90j272476e149d6cff3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-12-19 at 17:24 +0100, Julian Andres Klode wrote:
> 2008/12/19 Chris Mason <chris.mason@oracle.com>:
> > On Tue, 2008-12-16 at 14:57 -0500, Thomas Harning wrote:
> >> A kernel 'BUG' was caught while I had compression enabled and was
> >> performing a 'portage' update on my gentoo installation (which had
> >> btrfs mounted for portage for some basic perf testing).  It has
> >> finished the rsync and was at the 55% mark of the portage cache
> >> update... if that helps at all.
> >>
> >> Inlined is the kernel bug output... + some extra debug info that had
> >> been spit out beforehand that i thought might be useful...
> >>
> >> didn't appear to be at that 85% freespace mark...
> >>
> >> should I attach a btrfs-image dump?
> >>
> >> /dev/mapper/vg-btrfsTest
> >>                        1.0G  309M  716M  31% /mnt/btrfsTest
> >>
> >
> > Looking at the logs, your disk really was full.  Btrfs breaks the disk
> > up into metadata and data chunks.  The allocator is much more efficient
> > when the chunks are fairly large (the default is 1GB), and for smaller
> > devices it tries to make them smaller.
> >
> > There is some tuning that needs to happen on the smaller devices to
> > better balance space between data and metadata.  In your case, the
> > metadata block groups were all full even though the data block groups
> > still had some empty space.
>
> I can reproduce this bug at the same location, simply by running
> bonnie++ on a 4GB btrfs partition. I
> already wrote this one week ago to this list (4 times), but it did not
> show up on the list.

Yes, btrfs does not deal with enospc very well.  This is next on my list
of major improvements to start on.

bonnie writes a fairly large file, as I wrote above you're running into
the chunk allocation schemes that split data and metadata.

-chris


