Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37813 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932263AbdIFP04 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 11:26:56 -0400
Date: Wed, 6 Sep 2017 17:25:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 6/7] Btrfs: make some volumes.c functions static
Message-ID: <20170906152527.GV31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1503470354.git.osandov@fb.com>
 <cc1060b3024f9731796e5d57fc272a0862661efb.1503470354.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cc1060b3024f9731796e5d57fc272a0862661efb.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 22, 2017 at 11:46:04PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> These aren't used outside of volumes.c.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/volumes.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9b7a8e6257ee..9f2ed74a2c81 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -594,7 +594,7 @@ static void pending_bios_fn(struct btrfs_work *work)
>  }
>  
>  
> -void btrfs_free_stale_device(struct btrfs_device *cur_dev)
> +static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  {
>  	struct btrfs_fs_devices *fs_devs;
>  	struct btrfs_device *dev;
> @@ -1110,14 +1110,15 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  	return ret;
>  }
>  
> -void btrfs_release_disk_super(struct page *page)
> +static void btrfs_release_disk_super(struct page *page)
>  {
>  	kunmap(page);
>  	put_page(page);
>  }
>  
> -int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
> -		struct page **page, struct btrfs_super_block **disk_super)
> +static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
> +				 struct page **page,
> +				 struct btrfs_super_block **disk_super)
>  {
>  	void *p;
>  	pgoff_t index;
> @@ -1860,8 +1861,9 @@ static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info,
>  	return 0;
>  }
>  
> -struct btrfs_device *btrfs_find_next_active_device(struct btrfs_fs_devices *fs_devs,
> -					struct btrfs_device *device)
> +static struct btrfs_device *
> +btrfs_find_next_active_device(struct btrfs_fs_devices *fs_devs,
> +			      struct btrfs_device *device)

Please do not switch from the preferred declaration style where the type
is on the same line as the function name. In case it's too long, put
that on the next line.  As this one is trivial, I'll fix that at commit
time, but please keep that in mind in the future.
