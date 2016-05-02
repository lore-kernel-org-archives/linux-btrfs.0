Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbcEBIRB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 May 2016 04:17:01 -0400
Date: Mon, 2 May 2016 10:16:44 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?B?R/xuZ/Zy?= Erseymen <gelurine@gmail.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix divide error upon chunk's stripe_len
Message-ID: <20160502081644.GF29353@suse.cz>
Reply-To: dsterba@suse.cz
References: <1461718411-809-1-git-send-email-bo.li.liu@oracle.com>
 <877ffgp7g2.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <877ffgp7g2.fsf@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 29, 2016 at 09:59:25PM +0300, Güngör Erseymen wrote:
> > --- a/fs/btrfs/volumes.h
> > +++ b/fs/btrfs/volumes.h
> > @@ -347,7 +347,7 @@ struct map_lookup {
> >  	u64 type;
> >  	int io_align;
> >  	int io_width;
> > -	int stripe_len;
> > +	u64 stripe_len;
> >  	int sector_size;
> >  	int num_stripes;
> >  	int sub_stripes;
> > -- 
> > 2.5.0
> 
> Type change of map->stripe_len to u64 cause build error "undefined
> reference to __udivdi3" on 32bit systems. Using explicit 64 bit division
> fixes it and would be better to combine into this commit for
> continuity.

Done, thanks for the report.

JFYI, the branches pushed to kernel.org get automated build tests so I
get the email reports from kbuild eventually.
