Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:49358 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab2LRAG1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 19:06:27 -0500
Date: Mon, 17 Dec 2012 19:06:24 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Zach Brown <zab@zabbo.net>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: getdents spinning on 0x7fffffff
Message-ID: <20121218000624.GA22912@shiny>
References: <20121217230907.GI9195@lenny.home.zabbo.net>
 <20121217232840.GB20954@shiny>
 <20121217235039.GL9195@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121217235039.GL9195@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 17, 2012 at 04:50:39PM -0700, Zach Brown wrote:
> On Mon, Dec 17, 2012 at 06:28:40PM -0500, Chris Mason wrote:
> > On Mon, Dec 17, 2012 at 04:09:07PM -0700, Zach Brown wrote:
> > > 1) The fundamental fix is to re-use deleted entry positions.  Do we add
> > > another cache to index unlinked positions?  Do we add an unreliable
> > > best-effort walk of the tree looking for holes in the key space?  At the
> > > very least test index_cnt in unlink to get the basically useless
> > > index_cnt--? :)
> > 
> > The index is dense enough that we can search for free spots without too
> > much pain.  But, more below.
> 
> OK.  Want me to take a stab at it?

Sure, please do.  I'd say that we should allow a higher value on 64 bit
machines though.  I'd also cache the lowest free one if possible.

> Is there a similar use somewhere I
> should work from?
> 
> > > 2) Regardless of that, we have to deal with existing entry items with
> > > giant keys.  If for no other reason than big jerks making corrupt images
> > > and leaving them on usb keys in Josef's driveway.  Should we drop the
> > > silly INT_MAX setting for 64bit callers and return -EOVERFLOW for 32bit
> > > callers?  (That'd be gross, but not unheard of.  ext4 has grown htree
> > > behaviour that depends on compat detection: see its is_32bit_api()
> > > callers.)
> > > 
> > > I can make up some fixes but I'd love to hear strong opinions first, if
> > > anyone's got 'em :).
> > 
> > If we go past the 32 bit number we can use the hash offsets in readdir,
> > and just flag the directory as hashme-in-readdir
> 
> Hmm.  That sounds painful given either hash collisions or reconnecting
> nfs clients with previous f_pos values in use.
> 
> With a dencent entry key allocator it sounds a lot cleaner to me to just
> admit that 32bit apps can't see more dirents than their f_pos can
> represent.  It's already based on the number of entries rather than the
> bytes of entries so it'd be pretty hard to exhaust.
> 
> Am I .. not right? :)

Oh no, you're right.  But the 32 bit case is the exception and not the
rule, so I'm not against pushing them through some ugly corners to keep
64 bit happy/fast.

-chris

