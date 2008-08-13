From: Morey Roof <moreyroof@gmail.com>
Subject: Re: New feature Idea
Date: Wed, 13 Aug 2008 14:10:52 -0600
Message-ID: <1218658252.5907.11.camel@sdevel.nmt.edu>
References: <48A320A0.80609@gmail.com>  <87y730znw2.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain
To: btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87y730znw2.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-08-13 at 22:00 +0200, Andi Kleen wrote:
> Morey Roof <moreyroof@gmail.com> writes:
> 
> > I have been thinking about a new feature to start work on that I am
> > interested in and I was hoping people could give me some feedback and
> > ideas of how to tackle it.  Anyways, I want to create a data
> > deduplication system that can work in two different modes.  One mode
> > is that when the system is idle or not beyond a set load point a
> > background process would scan the volume for duplicate blocks.  The
> > other mode would be used for systems that are nearline or backup
> > systems that don't really care about the performance and it would do
> > the deduplication during block allocation.
> 
> Seems like a special case of compression? Perhaps compression would help
> more?
> 
> > One of the ways I was thinking of to find the duplicate blocks would
> > be to use the checksums as a quick compare.  If the checksums match
> > then do a complete compare before adjusting the nodes on the files.
> > However, I believe that I will need to create a tree based on the
> > checksum values.
> 
> If you really want to do deduplication: It might be advantageous to do 
> this on larger units.
> 
> If you assume that data is usually shared between similar files (which
> is a reasonable assumption) and do the deduplication on whole files
> you can also use the size as an index and avoid checksumming all files
> with a unique size.  I wrote a user level duplicated file checker some
> time ago that used this trick successfully.
> 
> -Andi

I would like to use the tree in a similar fashion as the way snapshots
are handled.  Also, I want to catch blocks that exist in different
files.

Say, you have several Virtual Machine Disk files on the volume.  Those
virtual machine disk files may not be the same in terms of files but if
the are virtual machines that are both running the same operating system
then some of the blocks/extents are going to be the same and I want to
be able to dedup them.

-Morey

