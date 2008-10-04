From: Daniel Phillips <phillips@phunq.net>
Subject: Re: packing structures and numbers
Date: Fri, 3 Oct 2008 17:43:46 -0700
Message-ID: <200810031743.46998.phillips@phunq.net>
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
> > ...Are we sure that attribute ((packed)) works the same on all
> > arches?
> 
> As long as you use types with strictly defined size, yes.

Just to be a language lawyer about that... int does not have a
strictly defined size, yet we define uint32_t as a typedef of int
on 32 bit arches do we not?

Regards,

Daniel
