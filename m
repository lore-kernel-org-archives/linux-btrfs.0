Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42293 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaHDMuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 08:50:32 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix compressed write corruption on enospc
Date: Mon, 04 Aug 2014 14:50:29 +0200
Message-ID: <234528786.A5cAeyBFJU@merkaba>
In-Reply-To: <1537782.AGn1dfcASJ@merkaba>
References: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com> <1537782.AGn1dfcASJ@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 25. Juli 2014, 11:54:37 schrieb Martin Steigerwald:
> Am Donnerstag, 24. Juli 2014, 22:48:05 schrieben Sie:
> > When failing to allocate space for the whole compressed extent, we'll
> > fallback to uncompressed IO, but we've forgotten to redirty the pages
> > which belong to this compressed extent, and these 'clean' pages will
> > simply skip 'submit' part and go to endio directly, at last we got data
> > corruption as we write nothing.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > 
> >  fs/btrfs/inode.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 3668048..8ea7610 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > 
> > @@ -709,6 +709,18 @@ retry:
> >  				unlock_extent(io_tree, async_extent->start,
> >  				
> >  					      async_extent->start +
> >  					      async_extent->ram_size - 1);
> > 
> > +
> > +				/*
> > +				 * we need to redirty the pages if we decide to
> > +				 * fallback to uncompressed IO, otherwise we
> > +				 * will not submit these pages down to lower
> > +				 * layers.
> > +				 */
> > +				extent_range_redirty_for_io(inode,
> > +						async_extent->start,
> > +						async_extent->start +
> > +						async_extent->ram_size - 1);
> > +
> > 
> >  				goto retry;
> >  			
> >  			}
> >  			goto out_free;
> 
> I am testing this currently. So far no lockup. Lets see. Still has not
> filled the the block device with trees completely after I balanced them:
> 
> Label: 'home'  uuid: […]
>         Total devices 2 FS bytes used 125.57GiB
>         devid    1 size 160.00GiB used 153.00GiB path /dev/dm-0
>         devid    2 size 160.00GiB used 153.00GiB path /dev/mapper/sata-home
> 
> I believe the lockups happen more easily if the trees occupy all of disk
> space. Well I will do some compiling of some KDE components which may let
> BTRFS fill all space again.
> 
> This patch will mean it when it can´t make enough free space in the
> (fragmented) tree it will write uncompressed?
> 
> This would mean that one would have a defragment trees regularily to allow
> for writes to happen compressed at all times.
> 
> Well… of course still better than lockup or corruption.

So lookups so far anymore.

Tested with 3.16-rc5, 3.16-rc7, now running 3-16 final.

/home BTRFS only got today filled completely tree-wise:

merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 127.35GiB
        devid    1 size 160.00GiB used 160.00GiB path /dev/mapper/msata-home
        devid    2 size 160.00GiB used 160.00GiB path /dev/dm-3

But I had KDE and kernel compile running full throttle at that time and still 
good.

Tested-By: Martin Steigerwald <martin@lichtvoll.de>


I think this should go to stable. Thanks, Liu.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
