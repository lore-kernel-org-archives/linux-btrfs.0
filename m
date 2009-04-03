From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: btrfs for enterprise raid arrays
Date: Fri, 03 Apr 2009 08:48:14 -0500
Message-ID: <1238766494.3359.2.camel@mulgrave.int.hansenpartnership.com>
References: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com>
	 <49D5F679.6060702@redhat.com>
	 <1238759880.3494.5.camel@macbook.infradead.org>
	 <20090403132739.GU2661@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: David Woodhouse <david.woodhouse@intel.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Erwin van Londen <erwin.vanlonden@hds.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>,
	Tom Coughlan <coughlan@redhat.com>
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090403132739.GU2661@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-04-03 at 06:27 -0700, Matthew Wilcox wrote:
> On Fri, Apr 03, 2009 at 12:58:00PM +0100, David Woodhouse wrote:
> > On Fri, 2009-04-03 at 12:43 +0100, Ric Wheeler wrote:
> > > > New firmware/microcode versions are able to reclaim that space if it
> > > > sees a certain number of consecutive zero's and will reclaim that 
> > > > space to the volume pool. Are there any thoughts on writing a 
> > > > low-priority tread that zeros out those "non-used" blocks?
> > > 
> > > Patches have been floating around to support this - see the recent 
> > > patches around "DISCARD" on linux-ide and lkml.  It would be great to 
> > > get access to a box that implemented the T10 proposed UNMAP commands 
> > > that we could test against. 
> > 
> > We've already made btrfs support TRIM, and Matthew has patches which
> > hook it up for ATA/IDE devices. Adding SCSI support shouldn't be hard
> > once the dust settles on the spec.
> 
> It seems like the dust has settled ... I just need to check that
> my code still conforms to the spec.  Understandably, I've been focused
> on TRIM ;-)
> 
> > I don't think I've seen anybody talking about deliberately writing
> > zeroes instead of just issuing a discard command though. That doesn't
> > seem like a massively cunning plan.
> 
> Yeah, WRITE SAME with the discard bit.  A bit of a crappy way to go, to
> be sure.  I'm not exactly sure how we're supposed to be deciding whether
> to issue an UNMAP or WRITE SAME command.  Perhaps if I read the spec
> properly it'll tell me.

Actually, the point about WRITE SAME is that it's a far smaller patch to
the standards (just a couple of bits).  Plus it gets around the problem
of what does the array return when an unmapped block is requested (which
occupies pages in the UNMAP proposal), so from that point of view it
seems very logical.

> I just had a quick chat with someone from another storage vendor who
> don't yet implement UNMAP -- if you do a WRITE SAME with all zeroes,
> their device will notice that and unmap the LBAs in question.

I actually already looked at using WRITE SAME in sd.c ... it turns out
to be surprisingly little work ... the thing you'll like about it is
that there are no extents to worry about and if you plan on writing all
zeros, you can keep a static zeroed data buffer around for the
purpose ...

James


