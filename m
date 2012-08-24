Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:47201 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab2HXQ5l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 12:57:41 -0400
Date: Fri, 24 Aug 2012 18:57:34 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add options to change size in logical to
 inode transition
Message-ID: <20120824165734.GD17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1345712189-6455-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1345712189-6455-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 23, 2012 at 04:56:28PM +0800, Liu Bo wrote:
> Add an option 's' to set size in logical to inode transition, then we are able
> to read all the refs to the logical address.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  cmds-inspect.c |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/cmds-inspect.c b/cmds-inspect.c
> index 2f0228f..be5e588 100644
> --- a/cmds-inspect.c
> +++ b/cmds-inspect.c
> @@ -115,7 +115,7 @@ static int cmd_inode_resolve(int argc, char **argv)
>  }
>  
>  static const char * const cmd_logical_resolve_usage[] = {
> -	"btrfs inspect-internal logical-resolve [-Pv] <logical> <path>",
> +	"btrfs inspect-internal logical-resolve [-Pv] [-s size] <logical> <path>",

Calling it 'size' si very ambiguous and I needed to go through the code
to see where and how the size is actually used. Something like 'bufsize'
would be more understandable for a regular user.

>  	"Get file system paths for the given logical address",
>  	NULL

and the option should be documented here, saying that if the list is
incomplete, user can increase it and the maximum value (when we agree on
it)

>  };
> @@ -130,12 +130,13 @@ static int cmd_logical_resolve(int argc, char **argv)
>  	int bytes_left;
>  	struct btrfs_ioctl_logical_ino_args loi;
>  	struct btrfs_data_container *inodes;
> +	u64 size = 4096;
>  	char full_path[4096];
>  	char *path_ptr;
>  
>  	optind = 1;
>  	while (1) {
> -		int c = getopt(argc, argv, "Pv");
> +		int c = getopt(argc, argv, "Pvs:");
>  		if (c < 0)
>  			break;
>  
> @@ -146,6 +147,9 @@ static int cmd_logical_resolve(int argc, char **argv)
>  		case 'v':
>  			verbose = 1;
>  			break;
> +		case 's':
> +			size = atoll(optarg);
> +			break;
>  		default:
>  			usage(cmd_logical_resolve_usage);
>  		}
> @@ -154,12 +158,13 @@ static int cmd_logical_resolve(int argc, char **argv)
>  	if (check_argc_exact(argc - optind, 2))
>  		usage(cmd_logical_resolve_usage);
>  
> -	inodes = malloc(4096);
> +	size = max(size, 4096);
> +	inodes = malloc(size);

Do we need the sanity checks here as well? Actually, if we avoid the
kernel buffer allocation, then user can supply a buffer of any size here
and we can drop the upper limit. This would be a bit more future proof,
when people will generate not thousands but milions of snapshots :)

>  	if (!inodes)
>  		return 1;
>  
>  	loi.logical = atoll(argv[optind]);
> -	loi.size = 4096;
> +	loi.size = size;
>  	loi.inodes = (u64)inodes;
>  
>  	fd = open_file_or_dir(argv[optind+1]);
> @@ -176,8 +181,9 @@ static int cmd_logical_resolve(int argc, char **argv)
>  	}
>  
>  	if (verbose)
> -		printf("ioctl ret=%d, bytes_left=%lu, bytes_missing=%lu, "
> -			"cnt=%d, missed=%d\n", ret,
> +		printf("ioctl ret=%d, total_size=%llu, bytes_left=%lu, "
> +			"bytes_missing=%lu, cnt=%d, missed=%d\n",
> +			ret, size,
>  			(unsigned long)inodes->bytes_left,
>  			(unsigned long)inodes->bytes_missing,
>  			inodes->elem_cnt, inodes->elem_missed);
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
