From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: add a "df" ioctl for btrfs
Date: Wed, 13 Jan 2010 09:31:00 -0500
Message-ID: <20100113143100.GM14979@think>
References: <20100112202513.GA13414@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100112202513.GA13414@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 12, 2010 at 03:25:13PM -0500, Josef Bacik wrote:
> df is a very loaded question in btrfs.  This gives us a way to get the per-space
> usage information so we can tell exactly what is in use where.  This will help
> us figure out ENOSPC problems, and help users better understand where their disk
> space is going.
> 
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 9e5074c..850e0ee 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -54,6 +54,18 @@ struct btrfs_ioctl_subvol_leaf {
>  	struct btrfs_ioctl_subvol_items items[];
>  };
>  
> +struct btrfs_ioctl_space_info {
> +	u32 flags;
> +	u64 total_bytes;
> +	u64 used_bytes;
> +};

Could you please bump that u32 to a u64?

-chris
