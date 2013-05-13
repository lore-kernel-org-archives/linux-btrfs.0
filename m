Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab3EMPzN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 11:55:13 -0400
Date: Mon, 13 May 2013 17:55:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add dedup register
Message-ID: <20130513155510.GP16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1367425659-10803-1-git-send-email-bo.li.liu@oracle.com>
 <1367425659-10803-4-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1367425659-10803-4-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 02, 2013 at 12:27:39AM +0800, Liu Bo wrote:
> +static int cmd_dedup(int argc, char **argv)
> +{
> +	int 	fd, res, e;
> +	char	*path;
> +
> +	if (check_argc_exact(argc, 2))
> +		usage(cmd_dedup_usage);
> +
> +	path = argv[1];
> +
> +	fd = open_file_or_dir(path);
> +	if (fd < 0) {
> +		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> +		return 12;

Please do not introduce the strange return values in new code.

> +	}
> +
> +	printf("register dedup on '%s'\n", path);
> +	res = ioctl(fd, BTRFS_IOC_DEDUP_REGISTER);
> +	e = errno;
> +	close(fd);
> +	if( res < 0 ){
> +		fprintf(stderr, "ERROR: unable to register dedup '%s' - %s\n", 
> +			path, strerror(e));
> +		return 32;

dtto

> +	}
> +
> +	return 0;
> +}
> +
>  const struct cmd_group filesystem_cmd_group = {
>  	filesystem_cmd_group_usage, NULL, {
>  		{ "df", cmd_df, cmd_df_usage, NULL, 0 },
> @@ -524,6 +559,7 @@ const struct cmd_group filesystem_cmd_group = {
>  		{ "balance", cmd_balance, NULL, &balance_cmd_group, 1 },
>  		{ "resize", cmd_resize, cmd_resize_usage, NULL, 0 },
>  		{ "label", cmd_label, cmd_label_usage, NULL, 0 },
> +		{ "dedup-register", cmd_dedup, cmd_dedup_usage, NULL, 0 },

By this you effectively capture the 'dedup*' namespace by a single
command. I thinkg dedup is a bigger beast and should use subcommands
rather than bunch of 1st level subcommands, ie. something like balance
or scrub.

If you don't want to spend time on polishing the UI of progs right now,
fine, just add the commands as you like, this can be fixed later. With a
warning.

>  		{ 0, 0, 0, 0, 0 },
>  	}
>  };
> diff --git a/ioctl.h b/ioctl.h
> index e841913..1bea98a 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -528,6 +528,7 @@ struct btrfs_ioctl_clone_range_args {
>  				      struct btrfs_ioctl_get_dev_stats)
>  #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
>  				    struct btrfs_ioctl_dev_replace_args)
> +#define BTRFS_IOC_DEDUP_REGISTER	 _IO(BTRFS_IOCTL_MAGIC, 54)

The interface to dedup should be imho similar to what's established with
scrub/balance and so should be the ioctls.

(Same as before, if you're focused on the actual dedup implementation,
add a comment that it's not finalized.)


david
