From: David Woodhouse <david.woodhouse@intel.com>
Subject: Re: btrfs for enterprise raid arrays
Date: Fri, 03 Apr 2009 12:58:00 +0100
Message-ID: <1238759880.3494.5.camel@macbook.infradead.org>
References: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com>
	 <49D5F679.6060702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Erwin van Londen <erwin.vanlonden@hds.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>,
	James Bottomley <JBottomley@Novell.com>,
	"willy@linux.intel.com" <willy@linux.intel.com>,
	Tom Coughlan <coughlan@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49D5F679.6060702@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-04-03 at 12:43 +0100, Ric Wheeler wrote:
> > New firmware/microcode versions are able to reclaim that space if it
> > sees a certain number of consecutive zero's and will reclaim that 
> > space to the volume pool. Are there any thoughts on writing a 
> > low-priority tread that zeros out those "non-used" blocks?
> 
> Patches have been floating around to support this - see the recent 
> patches around "DISCARD" on linux-ide and lkml.  It would be great to 
> get access to a box that implemented the T10 proposed UNMAP commands 
> that we could test against. 

We've already made btrfs support TRIM, and Matthew has patches which
hook it up for ATA/IDE devices. Adding SCSI support shouldn't be hard
once the dust settles on the spec.

I don't think I've seen anybody talking about deliberately writing
zeroes instead of just issuing a discard command though. That doesn't
seem like a massively cunning plan.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

