Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41675 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750779AbdJDSYt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Oct 2017 14:24:49 -0400
Date: Wed, 4 Oct 2017 20:23:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, Goffredo Baroncelli <kreijack@libero.it>,
        linux-btrfs@vger.kernel.org, Jean-Denis Girard <jd.girard@sysnux.pf>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH] btrfs: avoid overflow when sector_t is 32 bit
Message-ID: <20171004182305.GG3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171003173110.14789-1-kreijack@libero.it>
 <20171004142228.GB3521@twin.jikos.cz>
 <20171004171350.GA4902@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171004171350.GA4902@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 04, 2017 at 11:13:51AM -0600, Liu Bo wrote:
> On Wed, Oct 04, 2017 at 04:22:28PM +0200, David Sterba wrote:
> > On Tue, Oct 03, 2017 at 07:31:10PM +0200, Goffredo Baroncelli wrote:
> > > From: Goffredo Baroncelli <kreijack@inwind.it>
> > > 
> > > Jean-Denis Girard noticed commit c821e7f3 "pass bytes to
> > > btrfs_bio_alloc" (https://patchwork.kernel.org/patch/9763081/) introduces a
> > > regression on 32 bit machines.
> > > When CONFIG_LBDAF is _not_ defined (CONFIG_LBDAF == Support for large
> > > (2TB+) block devices and files) sector_t is 32 bit on 32bit machines.
> > > 
> > > In the function submit_extent_page, 'sector' (which is sector_t type) is
> > > multiplied by 512 to convert it from sectors to bytes, leading to an
> > > overflow when the disk is bigger than 4GB (!).
> > 
> > That's not good. There are some known typedefs that hide the 32bit/64bit
> > differences but the LBDAF and sector_t is new to me. Thanks for the
> > report and fix, I'll get it to linus/master tree in the next batch so it
> > can go to stable tree.
> > 
> > I've seen sector_t used in places where it is not necessary so I'll try
> > to minimize the usage and more surprises from the << 9 shifts.
> > 
> > Reviewed-by: David Sterba <dsterba@suse.com>
> > Fixes: c821e7f3 ("btrfs: pass bytes to btrfs_bio_alloc")
> > CC: stable@vger.kernel.org # 4.13+
> 
> However, this sector_t is passed from its callers, e.g.
> 
> __do_readpage()
> {
> 	sector_t sector;
> 	...
> 	sector = em->block_start >> 9;
> 	...
> }
> 
> if sector_t is 32bit, the above %sector could also lose high bits.
> Some cleanups are needed to use u64 directly.

I have the sector_t cleanups ready, will post them tomorrow.

> Even with this patch, I suspect that there might be errors from block
> layer as sector_t is used everywhere in block layer.

Yeah, we'd have to audit all interface calls where the parameters are
sector_t, I've addressed only those in btrfs code.

> For a btrfs FS that is created and used on 64bit system, it'll be
> causing trouble anyway if letting it mount 32bit system, lets refuse
> the mount firstly.

As long as the sector_t is 64bit on 32bit system, we can let the mount
proceed. For 32bit sector_t on 32bit system we could refuse to mount in
case one of the devices is larger than 2TB (provided that we don't lose
the bits from the conversion similar to what this patch does).

This would need check on the device add and replace side, but otherwise
I think we should try to keep the systems working even in the limited
environments.
