From: Daniel Phillips <phillips@phunq.net>
Subject: Re: packing structures and numbers
Date: Fri, 3 Oct 2008 17:22:51 -0700
Message-ID: <200810031722.52063.phillips@phunq.net>
References: <48E6053A.8010100@redhat.com> <1223036573.6836.19.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Avi Kivity <avi@redhat.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1223036573.6836.19.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 03 October 2008 05:22, Chris Mason wrote:
> On Fri, 2008-10-03 at 14:42 +0300, Avi Kivity wrote:
> > I've been reading btrfs's on-disk format, and two things caught my eye
> > 
> > - attribute((packed)) structures everywhere, often with misaligned 
> > fields.  This conserves space, but can be harmful to in-memory 
> > performance on some archs.
> 
> packed is important to make sure that a given field takes exactly the
> same amount of space everywhere, regardless of compiler optimization or
> arch.

Amen.  Are we sure that attribute ((packed)) works the same on all
arches?

And what about bitfields, does GCC pack them to the same size on all
arches in this case or take the easy way out as permitted by the
standard?

Regards,

Daniel
