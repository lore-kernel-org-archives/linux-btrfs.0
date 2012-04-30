From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: btrfs: fix race in reada
Date: Mon, 30 Apr 2012 15:41:40 +0300
Message-ID: <20120430124140.GB30417@mwanda>
References: <20120430111128.GA22734@elgon.mountain>
 <4F9E7631.7080203@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F9E7631.7080203@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2012 at 01:23:29PM +0200, Arne Jansen wrote:
> On 30.04.2012 13:11, Dan Carpenter wrote:
> > Hello Arne Jansen,
> > 
> > The patch 8c9c2bf7a3c4: "btrfs: fix race in reada" from Feb 25, 2012, 
> > leads to the following warning:
> > fs/btrfs/reada.c:308 reada_find_zone()
> > 	 warn: 'zone' was already freed.
> 
> Who emits this warning? It's bogus.
> 
> > 
> > @@ -307,13 +302,15 @@ again:
> >         ret = radix_tree_insert(&dev->reada_zones,
> >                                 (unsigned long)(zone->end >> PAGE_CACHE_SHIFT),
> >                                 zone);
> > -       spin_unlock(&fs_info->reada_lock);
> >  
> > -       if (ret) {
> > +       if (ret == -EEXIST) {
> >                 kfree(zone);
> >                 ^^^^^^^^^^^
> > Freed here.
> > 
> > -               looped = 1;
> > -               goto again;
> > +               ret = radix_tree_gang_lookup(&dev->reada_zones, (void **)&zone,
> >                                                                           ^^^^
> > Use after free inside radix_tree_gang_lookup() function.
> 
> It's not used by radix_tree_gang_lookup, the second parameter is
> a pointer to the return value.

Ah.  We can only write one item, because we pass max_items = 1.

Nevermind.  The code in reada.c is fine.  Sorry for the noise.

regards,
dan carpenter

