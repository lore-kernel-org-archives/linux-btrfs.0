From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Don't prevent removal of devices that break raid reqs
Date: Thu, 10 Nov 2011 21:21:00 -0500
Message-ID: <20111111022100.GD4435@shiny>
References: <orvcqrpycf.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <orvcqrpycf.fsf@livre.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 10, 2011 at 05:32:48PM -0200, Alexandre Oliva wrote:
> Instead of preventing the removal of devices that would render existing
> raid10 or raid1 impossible, warn but go ahead with it; the rebalancing
> code is smart enough to use different block group types.
> 
> Should the refusal remain, so that we'd only proceed with a
> newly-introduced --force option or so?

Hmm, going to three devices on raid10 doesn't turn it into
raid1.  It turns it into a degraded raid10.

We'll need a --force or some kind.  There are definitely cases users
have wanted to do this but it is rarely a good idea ;)

-chris

> 
> Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
> ---
>  fs/btrfs/volumes.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 4d5b29f..507afca 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1281,18 +1281,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  
>  	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) &&
>  	    root->fs_info->fs_devices->num_devices <= 4) {
> -		printk(KERN_ERR "btrfs: unable to go below four devices "
> -		       "on raid10\n");
> -		ret = -EINVAL;
> -		goto out;
> +		printk(KERN_ERR "btrfs: going below four devices "
> +		       "will turn raid10 into raid1\n");
>  	}
>  
>  	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
>  	    root->fs_info->fs_devices->num_devices <= 2) {
> -		printk(KERN_ERR "btrfs: unable to go below two "
> -		       "devices on raid1\n");
> -		ret = -EINVAL;
> -		goto out;
> +		printk(KERN_ERR "btrfs: going below two devices "
> +		       "will lose raid1 redundancy\n");
>  	}
>  
>  	if (strcmp(device_path, "missing") == 0) {
> -- 
> 1.7.4.4
> 
> 
> -- 
> Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
> You must be the change you wish to see in the world. -- Gandhi
> Be Free! -- http://FSFLA.org/   FSF Latin America board member
> Free Software Evangelist      Red Hat Brazil Compiler Engineer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
