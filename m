Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965162Ab3HHOTa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 10:19:30 -0400
Date: Thu, 8 Aug 2013 16:19:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs: allocate prelim_ref with a slab allocater
Message-ID: <20130808141928.GW5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1375938259-5015-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375938259-5015-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 01:04:19PM +0800, Wang Shilong wrote:
> struct __prelim_ref is allocated and freed frequently when
> walking backref tree, using slab allocater can not only
> speed up allocating but also detect memory leaks.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/backref.c | 30 +++++++++++++++++++++++++-----
>  fs/btrfs/backref.h |  2 ++
>  fs/btrfs/super.c   |  8 ++++++++
>  3 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index f7781e6..916e4f1 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -119,6 +119,26 @@ struct __prelim_ref {
>  	u64 wanted_disk_byte;
>  };
>  
> +static struct kmem_cache *prelim_ref_cache;
> +
> +int __init btrfs_prelim_ref_init(void)
> +{
> +	prelim_ref_cache = kmem_cache_create("btrfs_prelim_ref",
> +					sizeof(struct __prelim_ref),

Would be nice to give it a name that matches the slab cache,
btrfs_prelim_ref.

david
