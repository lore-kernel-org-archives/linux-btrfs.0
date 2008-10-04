From: Chris Mason <chris.mason@oracle.com>
Subject: Re: packing structures and numbers
Date: Fri, 3 Oct 2008 20:28:56 -0400
Message-ID: <20081004002856.GA8449@think.oraclecorp.com>
References: <48E6053A.8010100@redhat.com> <1223036573.6836.19.camel@think.oraclecorp.com> <200810031722.52063.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Avi Kivity <avi@redhat.com>, linux-btrfs@vger.kernel.org
To: Daniel Phillips <phillips@phunq.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200810031722.52063.phillips@phunq.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 03, 2008 at 05:22:51PM -0700, Daniel Phillips wrote:
> On Friday 03 October 2008 05:22, Chris Mason wrote:
> > On Fri, 2008-10-03 at 14:42 +0300, Avi Kivity wrote:
> > > I've been reading btrfs's on-disk format, and two things caught my eye
> > > 
> > > - attribute((packed)) structures everywhere, often with misaligned 
> > > fields.  This conserves space, but can be harmful to in-memory 
> > > performance on some archs.
> > 
> > packed is important to make sure that a given field takes exactly the
> > same amount of space everywhere, regardless of compiler optimization or
> > arch.
> 
> Amen.  Are we sure that attribute ((packed)) works the same on all
> arches?

As long as you use types with strictly defined size, yes.

> 
> And what about bitfields, does GCC pack them to the same size on all
> arches in this case or take the easy way out as permitted by the
> standard?

I'm not sure, I believe a bit field on a strictly defined size will be
packed the same everywhere. But bitfields + endian conversion are messy,
so I avoid them.

-chris
