Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751233AbdBHSao (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 13:30:44 -0500
Date: Wed, 8 Feb 2017 19:30:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: takafumi-sslab <takafumi.kubota1012@sslab.ics.keio.ac.jp>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add another missing end_page_writeback on
 submit_extent_page failure
Message-ID: <20170208183013.GC16928@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170130200858.GA10490@localhost.localdomain>
 <83e8f70a-e8e2-2800-00e1-807401188e4d@sslab.ics.keio.ac.jp>
 <20170201161932.GA19291@localhost.localdomain>
 <b8fa6a68-72a8-b745-b71c-c25d89a7a911@sslab.ics.keio.ac.jp>
 <20170206033527.GA23573@localhost.localdomain>
 <fe79b315-196c-b981-5151-9c8cc1901632@sslab.ics.keio.ac.jp>
 <20170206162654.GA15505@localhost.localdomain>
 <20170206163407.GB15505@localhost.localdomain>
 <588a59ec-d535-50a0-b6a6-948f1771b1d6@sslab.ics.keio.ac.jp>
 <20170207201450.GA19766@dhcp-adc-twvpn-3-vpnpool-10-154-98-84.vpn.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170207201450.GA19766@dhcp-adc-twvpn-3-vpnpool-10-154-98-84.vpn.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 07, 2017 at 12:14:51PM -0800, Liu Bo wrote:
> > +				end_page_writeback(page);
> > +		}
> > 
> >  		cur = cur + iosize;
> >  		pg_offset += iosize;
> > @@ -3767,7 +3770,8 @@ static noinline_for_stack int write_one_eb(struct
> > extent_buffer *eb,
> >  		epd->bio_flags = bio_flags;
> >  		if (ret) {
> >  			set_btree_ioerr(p);
> > -			end_page_writeback(p);
> > +			if (PageWriteback(p))
> > +				end_page_writeback(p);
> >  			if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
> >  				end_extent_buffer_writeback(eb);
> >  			ret = -EIO;
> > 
> > ---
> > 
> 
> Looks good, could you please make a comment for the if statement in your
> commit log so that others could know why we put it?

Thank you both. Please resend v2 so I can add it to 4.11 queue.
> 
> Since you've got a reproducer, baking it into a fstests case is also
> welcome.

AFAICS the reproducer needs a kernel patch so the memory allocation
fails reliably, this is not suitable for fstests. We don't have an easy
way to inject allocation failures easily, but some reduced steps to
reprroduce could be added to the changelog.
