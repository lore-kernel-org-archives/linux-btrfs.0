From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Add compability for kernels >=2.6.27-rc1
Date: Wed, 30 Jul 2008 21:56:28 +0200
Message-ID: <20080730195628.GP20055@kernel.dk>
References: <alpine.LNX.1.10.0807302100500.2294@titan.stealer.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Sven Wegener <sven.wegener@stealer.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0807302100500.2294@titan.stealer.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 30 2008, Sven Wegener wrote:
> Add a couple of #if's to follow API changes.
> 
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> ---
>  extent_io.c |   16 ++++++++++++++++
>  file.c      |    4 ++++
>  inode.c     |   12 ++++++++++--
>  3 files changed, 30 insertions(+), 2 deletions(-)
> 
> Having passed the rc1 mark the API changes should be finished.
> 
> Other #if in the source use >version instead of >=version+1, so I use them 
> too.
> 
> Patch is against the current unstable repository, but can applied with a 
> slight modification (extent_io.c) to the stable repository too.
> 
> diff -r 59ec68fb1540 extent_io.c
> --- a/extent_io.c	Wed Jul 30 10:29:12 2008 -0400
> +++ b/extent_io.c	Wed Jul 30 19:00:28 2008 +0000
> @@ -2649,9 +2649,17 @@
>  	mapping = eb->first_page->mapping;
>  	if (!mapping)
>  		return NULL;
> +#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
> +	spin_lock_irq(&mapping->tree_lock);
> +#else
>  	read_lock_irq(&mapping->tree_lock);
> +#endif
>  	p = radix_tree_lookup(&mapping->page_tree, i);
> +#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
> +	spin_unlock_irq(&mapping->tree_lock);
> +#else
>  	read_unlock_irq(&mapping->tree_lock);
> +#endif
>  	return p;
>  }

For btrfs's usage, it should be safe with a simple rcu_read_lock(), if
the return is referenced safely.

-- 
Jens Axboe

