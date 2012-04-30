From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: btrfs: fix race in reada
Date: Mon, 30 Apr 2012 15:36:33 +0300
Message-ID: <20120430123633.GA30417@mwanda>
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

This is a Smatch warning, but it's not turned on by default because
a lot of place do this:

	kfree(p);
	printk(KERN_DEBUG "pointer was %p", p);

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
> 

Uh...  I just glanced at it the first time through, but looking but
look carefully, we're not using freed memory, we're scribbling over
stack memory.  Eep!

   990  unsigned int
   991  radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
   992                          unsigned long first_index, unsigned int max_items)
   993  {
   994          struct radix_tree_iter iter;
   995          void **slot;
   996          unsigned int ret = 0;
   997  
   998          if (unlikely(!max_items))
   999                  return 0;
  1000  
  1001          radix_tree_for_each_slot(slot, root, &iter, first_index) {
  1002                  results[ret] = indirect_to_ptr(rcu_dereference_raw(*slot));
                        ^^^^^^^^^^^^
The bug is right here.  The first time through we write to
*(&zone + 0) which is just "zone = indirect_to_ptr();" and that's
fine.  But the second time we write to "*(&zone + 1)" which
corrupts the cache pointer from the reada_find_zone() function.

My guess is that the normal use case is to only loop through here
one time or we would have caught this in testing.  All the uses in
fs/btrfs/reada.c have same memory corruption issue.

  1003                  if (!results[ret])
  1004                          continue;
  1005                  if (++ret == max_items)
  1006                          break;
  1007          }
  1008  
  1009          return ret;
  1010  }

regards,
dan carpenter
