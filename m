From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [patch 35/35] btrfs: disallow unequal data/metadata blocksize
 for mixed block groups
Date: Thu, 22 Mar 2012 17:02:24 +0100
Message-ID: <4F6B4D10.3090709@giantdisaster.de>
References: <20120322011104.212214639@suse.com> <20120322011137.923792033@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs List <linux-btrfs@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120322011137.923792033@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 3/22/2012 2:11 AM, Jeff Mahoney wrote:
> With support for bigger metadata blocks, we must avoid mounting a
> filesystem with different block size for mixed block groups, this causes
> corruption (found by xfstests/083).
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/disk-io.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 38c2ee1..55272b0 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2302,6 +2302,14 @@ int open_ctree(struct super_block *sb,
>  		goto fail_sb_buffer;
>  	}
>  
> +	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
> +			(leafsize != nodesize && sectorsize != nodesize)) {

Dave, Shouldn't this be like this (you want all three sizes to be equal
in mixed mode, don't you?):
	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
			(leafsize != nodesize || sectorsize != nodesize)) {


> +		printk(KERN_WARNING "btrfs: unequal leaf/node/sector sizes "
> +				"are not allowed for mixed block groups on %s\n",
> +				sb->s_id);
> +		goto fail_sb_buffer;
> +	}
> +
>  	mutex_lock(&fs_info->chunk_mutex);
>  	ret = btrfs_read_sys_array(tree_root);
>  	mutex_unlock(&fs_info->chunk_mutex);
