From: David Sterba <dave@jikos.cz>
Subject: Re: [patch 01/65] btrfs: Add btrfs_panic()
Date: Mon, 10 Oct 2011 18:35:56 +0200
Message-ID: <20111010163556.GI17912@twin.jikos.cz>
References: <20111004032230.458853274@suse.com> <20111004032300.032619517@suse.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: BtrFS List <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111004032300.032619517@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 03, 2011 at 11:22:31PM -0400, Jeff Mahoney wrote:
>  static match_table_t tokens = {
> @@ -195,6 +228,7 @@ static match_table_t tokens = {
>  	{Opt_subvolrootid, "subvolrootid=%d"},
>  	{Opt_defrag, "autodefrag"},
>  	{Opt_inode_cache, "inode_cache"},
> +	{Opt_fatal_errors, "fatal_errors=%s"},
>  	{Opt_err, NULL},
>  };
>  
> @@ -381,6 +415,18 @@ int btrfs_parse_options(struct btrfs_roo
>  			printk(KERN_INFO "btrfs: enabling auto defrag");
>  			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
>  			break;
> +		case Opt_fatal_errors:
> +			if (strcmp(args[0].from, "panic") == 0)
> +				btrfs_set_opt(info->mount_opt,
> +					      PANIC_ON_FATAL_ERROR);
> +			else if (strcmp(args[0].from, "bug") == 0)
> +				btrfs_clear_opt(info->mount_opt,
> +					      PANIC_ON_FATAL_ERROR);
> +			else {
> +				ret = -EINVAL;
> +				goto out;
> +			}

I suggest adding a KERN_INFO message when this option is enabled

> +			break;
>  		case Opt_err:
>  			printk(KERN_INFO "btrfs: unrecognized mount option "
>  			       "'%s'\n", p);


david
