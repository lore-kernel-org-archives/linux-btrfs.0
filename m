From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 11:33:59 -0400
Message-ID: <1224689639.6448.72.camel@think.oraclecorp.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	 <48FDD710.5050702@hp.com> <20081021190136.89b2c6af.skraw@ithnet.com>
	 <20081021171513.GA8799@infradead.org> <48FE11F9.7040700@gmail.com>
	 <20081022142759.ac33a16c.skraw@ithnet.com>
	 <1224681345.6448.4.camel@think.oraclecorp.com> <48FF2A5B.80108@redhat.com>
	 <48FF396B.1020700@redhat.com> <48FF3CB9.6070404@redhat.com>
	 <48FF3EB8.6050306@redhat.com> <48FF4082.407@redhat.com>
	 <48FF4302.5030204@redhat.com>  <48FF45EE.7010001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Avi Kivity <avi@redhat.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	Christoph Hellwig <hch@infradead.org>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF45EE.7010001@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-10-22 at 11:25 -0400, Ric Wheeler wrote:
> Avi Kivity wrote:
> > Ric Wheeler wrote:
> >>>
> >>> Well, btrfs is not about duplicating how most storage works today.  
> >>> Spare capacity has significant advantages over spare disks, such as 
> >>> being able to mix disk sizes, RAID levels, and better performance.
> >>
> >> Sure, there are advantages that go in favour of one or the other 
> >> approaches. But btrfs is also about being able to use common hardware 
> >> configurations without having to reinvent where we can avoid it (if 
> >> we have a working RAID or enough drives to do RAID5 with spares or 
> >> RAID6, we want to be able to delegate that off to something else if 
> >> we can).
> >
> > Well, if you have an existing RAID (or have lots of $$$ to buy a new 
> > one), you needn't tell Btrfs about it.  Just be sure not to enable 
> > Btrfs data redundancy, or you'll have redundant redundancy, which is 
> > expensive.
> >
> > What Btrfs enables with its multiple device capabilities is to 
> > assemble a JBOD into a filesystem-level data redundancy system, which 
> > is cheaper, more flexible (per-file data redundancy levels), and 
> > faster (no need for RMW, since you're always COWing).
>
> I think that the btrfs plan is still to push more complicated RAID 
> schemes off to MD (RAID6, etc) so this is an issue even with a JBOD.

At least v1.0 won't have raid6.  Over the longer term I hope to include
it because managing the storage once in btrfs and once in md is going to
be a bit clumsy.  It also limits the mixed mode functionality like
different stripe sizes for data vs metadata or metadata mirroring and
data raid6 that will allow us to perform well.

The goal will be to make a library of raid routines based on md that
other storage will be able to use.  I know Christoph has been interested
in this as well.

But in general, the btrfs raid code can do either spare disks or spare
capacity modes safely.  It enforces the correct number of devices in
each raid mode (as long as the admin doesn't lie to us and feed
partitions off the same device).

I'll leave the rest up to the admin.  One problem with the spare
capacity model is the general trend where drives from the same batch
that get hammered on in the same way tend to die at the same time.  Some
shops will sleep better knowing there's a hot spare and that's fine by
me.

-chris


