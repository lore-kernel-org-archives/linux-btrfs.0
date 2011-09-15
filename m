From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH V2] btrfs: trivial fix, a potential memory leak in btrfs_parse_early_options()
Date: Thu, 15 Sep 2011 20:07:28 +0200
Message-ID: <20110915180727.GH22205@twin.jikos.cz>
References: <4E6EF2CD.3070302@oracle.com> <4E703E4D.3040101@cn.fujitsu.com> <4E704589.5020903@oracle.com> <20110915120549.GF22205@twin.jikos.cz> <4E721348.5020504@oracle.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
	dave@jikos.cz
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E721348.5020504@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2011 at 11:01:28PM +0800, Jeff Liu wrote:
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

> 
> ---
>  fs/btrfs/super.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 15634d4..16f31e1 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -406,7 +406,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>  		u64 *subvol_rootid, struct btrfs_fs_devices **fs_devices)
>  {
>  	substring_t args[MAX_OPT_ARGS];
> -	char *opts, *orig, *p;
> +	char *device_name, *opts, *orig, *p;
>  	int error = 0;
>  	int intarg;
>  
> @@ -457,8 +457,14 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
>  			}
>  			break;
>  		case Opt_device:
> -			error = btrfs_scan_one_device(match_strdup(&args[0]),
> +			device_name = match_strdup(&args[0]);
> +			if (!device_name) {
> +				error = -ENOMEM;
> +				goto out_free_opts;
> +			}
> +			error = btrfs_scan_one_device(device_name,
>  					flags, holder, fs_devices);
> +			kfree(device_name);
>  			if (error)
>  				goto out_free_opts;
>  			break;
> -- 
> 1.7.4.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
