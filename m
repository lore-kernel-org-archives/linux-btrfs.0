From: Theodore Tso <tytso@mit.edu>
Subject: Re: Btrfs v0.16 released
Date: Fri, 8 Aug 2008 21:43:48 -0400
Message-ID: <20080809014348.GC9967@mit.edu>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com> <20080808215625.GC9038@one.firstfloor.org> <20080809011905.GB9967@mit.edu> <20080809012322.GF9038@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080809012322.GF9038@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 09, 2008 at 03:23:22AM +0200, Andi Kleen wrote:
> > In theory, if the elevator was smart enough, it could actually help
> > read seekiness; there are two copies of the metadata, and it shouldn't
> 
> That assumes the elevator actually knows what is nearby? I thought
> that wasn't that easy with modern disks with multiple spindles
> and invisible remapping, not even talking about RAID
> arrays looking like disks.

RAID is the big problem, yeah.  In general, though, we are already
making an assumption in the elevator code and in filesystem code that
block numbers which are numerically closer together are "close" from
the perspective of disks.  There has been talk about trying to make
filesystems smarter about allocating blocks by giving them visibility
to the RAID parameters; in theory the elevator algorithm could also be
made smarter as well using the same information.  I'm really not sure
if the complexity is worth it, though....

						- Ted
