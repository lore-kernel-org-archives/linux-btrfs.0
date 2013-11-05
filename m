Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47766 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3KEAzf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 19:55:35 -0500
Received: by mail-pb0-f51.google.com with SMTP id xa7so1970077pbc.24
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 16:55:34 -0800 (PST)
Date: Mon, 4 Nov 2013 16:55:32 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, hch@infradead.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/9] block: Make generic_make_request handle
 arbitrary sized bios
Message-ID: <20131105005532.GC27733@kmo>
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
 <1383608187-27368-5-git-send-email-kmo@daterainc.com>
 <52783444.8070309@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52783444.8070309@cs.wisc.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 04, 2013 at 03:56:52PM -0800, Mike Christie wrote:
> On 11/04/2013 03:36 PM, Kent Overstreet wrote:
> > @@ -1822,6 +1820,14 @@ void generic_make_request(struct bio *bio)
> >  		 */
> >  		blk_queue_bounce(q, &bio);
> >  
> > +		if (!blk_queue_largebios(q))
> > +			split = blk_bio_segment_split(q, bio, q->bio_split);
> 
> 
> Is it assumed bios coming down this path are created using bio_add_page?
> If not, does blk_bio_segment_split need a queue_max_sectors or
> queue_max_hw_sectors check? I only saw a segment count check below.

Shoot, you're absolutely right - thanks, I'll have this fixed in the next
version.
