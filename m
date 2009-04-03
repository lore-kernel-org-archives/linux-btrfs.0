From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: btrfs for enterprise raid arrays
Date: Fri, 3 Apr 2009 06:27:39 -0700
Message-ID: <20090403132739.GU2661@linux.intel.com>
References: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com> <49D5F679.6060702@redhat.com> <1238759880.3494.5.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Erwin van Londen <erwin.vanlonden@hds.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>,
	James Bottomley <JBottomley@Novell.com>,
	Tom Coughlan <coughlan@redhat.com>
To: David Woodhouse <david.woodhouse@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1238759880.3494.5.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 03, 2009 at 12:58:00PM +0100, David Woodhouse wrote:
> On Fri, 2009-04-03 at 12:43 +0100, Ric Wheeler wrote:
> > > New firmware/microcode versions are able to reclaim that space if it
> > > sees a certain number of consecutive zero's and will reclaim that 
> > > space to the volume pool. Are there any thoughts on writing a 
> > > low-priority tread that zeros out those "non-used" blocks?
> > 
> > Patches have been floating around to support this - see the recent 
> > patches around "DISCARD" on linux-ide and lkml.  It would be great to 
> > get access to a box that implemented the T10 proposed UNMAP commands 
> > that we could test against. 
> 
> We've already made btrfs support TRIM, and Matthew has patches which
> hook it up for ATA/IDE devices. Adding SCSI support shouldn't be hard
> once the dust settles on the spec.

It seems like the dust has settled ... I just need to check that
my code still conforms to the spec.  Understandably, I've been focused
on TRIM ;-)

> I don't think I've seen anybody talking about deliberately writing
> zeroes instead of just issuing a discard command though. That doesn't
> seem like a massively cunning plan.

Yeah, WRITE SAME with the discard bit.  A bit of a crappy way to go, to
be sure.  I'm not exactly sure how we're supposed to be deciding whether
to issue an UNMAP or WRITE SAME command.  Perhaps if I read the spec
properly it'll tell me.

I just had a quick chat with someone from another storage vendor who
don't yet implement UNMAP -- if you do a WRITE SAME with all zeroes,
their device will notice that and unmap the LBAs in question.

Something for the plane on Sunday anyway.
