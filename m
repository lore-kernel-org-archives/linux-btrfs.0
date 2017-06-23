Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754019AbdFWQv2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 12:51:28 -0400
Date: Fri, 23 Jun 2017 17:59:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        davej@codemonkey.org.uk
Subject: Re: [PATCH] btrfs: fix integer overflow in calc_reclaim_items_nr
Message-ID: <20170623155927.GA2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170623143240.1245989-1-clm@fb.com>
 <b033955e-c0ff-20da-0e98-f68a5eb767c8@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <b033955e-c0ff-20da-0e98-f68a5eb767c8@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 23, 2017 at 05:29:56PM +0200, Holger Hoffstätte wrote:
> On 06/23/17 16:32, Chris Mason wrote:
> [..]
> > -static inline int calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
> > +static inline u64 calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
> >  					u64 to_reclaim)
> >  {
> >  	u64 bytes;
> > -	int nr;
> > +	u64 nr;
> >  
> >  	bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
> >  	nr = (int)div64_u64(to_reclaim, bytes);
>         ^^^^^^^^^^
> 
> Isn't this a bit odd? I can't even tell whether it matters, just randomly
> noticed it because I genuinely dislike type casts..

I think the typecast shold be dropped, now that nr is u64.
