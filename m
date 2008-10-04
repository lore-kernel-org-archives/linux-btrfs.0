From: Daniel Phillips <phillips@phunq.net>
Subject: Re: packing structures and numbers
Date: Fri, 3 Oct 2008 17:35:41 -0700
Message-ID: <200810031735.41588.phillips@phunq.net>
References: <48E6053A.8010100@redhat.com> <200810031722.52063.phillips@phunq.net> <20081004002856.GA8449@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Avi Kivity <avi@redhat.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081004002856.GA8449@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 03 October 2008 17:28, Chris Mason wrote:
> On Fri, Oct 03, 2008 at 05:22:51PM -0700, Daniel Phillips wrote:
> > And what about bitfields, does GCC pack them to the same size on all
> > arches in this case or take the easy way out as permitted by the
> > standard?
> 
> I'm not sure, I believe a bit field on a strictly defined size will be
> packed the same everywhere. But bitfields + endian conversion are messy,
> so I avoid them.

Likewise, sigh.  On the other hand, packed + endian can't really be
avoided.

Regards,

Daniel

