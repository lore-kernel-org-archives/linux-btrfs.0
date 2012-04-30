From: Arne Jansen <sensille@gmx.net>
Subject: Re: btrfs: fix race in reada
Date: Mon, 30 Apr 2012 13:23:29 +0200
Message-ID: <4F9E7631.7080203@gmx.net>
References: <20120430111128.GA22734@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120430111128.GA22734@elgon.mountain>
List-ID: <linux-btrfs.vger.kernel.org>

On 30.04.2012 13:11, Dan Carpenter wrote:
> Hello Arne Jansen,
> 
> The patch 8c9c2bf7a3c4: "btrfs: fix race in reada" from Feb 25, 2012, 
> leads to the following warning:
> fs/btrfs/reada.c:308 reada_find_zone()
> 	 warn: 'zone' was already freed.

Who emits this warning? It's bogus.

> 
> @@ -307,13 +302,15 @@ again:
>         ret = radix_tree_insert(&dev->reada_zones,
>                                 (unsigned long)(zone->end >> PAGE_CACHE_SHIFT),
>                                 zone);
> -       spin_unlock(&fs_info->reada_lock);
>  
> -       if (ret) {
> +       if (ret == -EEXIST) {
>                 kfree(zone);
>                 ^^^^^^^^^^^
> Freed here.
> 
> -               looped = 1;
> -               goto again;
> +               ret = radix_tree_gang_lookup(&dev->reada_zones, (void **)&zone,
>                                                                           ^^^^
> Use after free inside radix_tree_gang_lookup() function.

It's not used by radix_tree_gang_lookup, the second parameter is
a pointer to the return value.

Thanks,
Arne

> 
> +                                            logical >> PAGE_CACHE_SHIFT, 1);
> +               if (ret == 1)
> +                       kref_get(&zone->refcnt);
>         }
> +       spin_unlock(&fs_info->reada_lock);
>  
>         return zone;
>  }
> 
> regards,
> dan carpenter
> 

