Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43126 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752104AbdK1QI5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:08:57 -0500
Date: Tue, 28 Nov 2017 17:07:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 3/3] btrfs-progs: fi defrag: extend -c to drop
 nocompress flag on files
Message-ID: <20171128160659.GV3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
 <20171128091450.21789-3-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171128091450.21789-3-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 28, 2017 at 05:14:50PM +0800, Su Yue wrote:
> Now, files which have nocompress flag also will be defraged
> with compression. However, nocompress flag is still existed
> and have to be cleared manually.
> 
> So add an option '--clear-nocompress' to extend -c to drop
> nocompress flag after defragement.

> Suggested-by: David Sterba <dsterba@suse.com>
> Suggested-by: Anand Jain <anand.jain@oracle.com>

Do you have the pointer to the discussion? The whole idea sounds
familiar and seeing my name here means I must have been involved, but I
have only vague memories.

> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
> Changelog:
> v2:	Remove change about indentation of defrag_callback().
> 
> ---
>  cmds-filesystem.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 64 insertions(+), 1 deletion(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 3931333f76c6..84242814798e 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -27,6 +27,7 @@
>  #include <mntent.h>
>  #include <linux/limits.h>
>  #include <getopt.h>
> +#include <linux/fs.h>
>  
>  #include "kerncompat.h"
>  #include "ctree.h"
> @@ -867,6 +868,8 @@ static const char * const cmd_filesystem_defrag_usage[] = {
>  	"-l len              defragment only up to len bytes",
>  	"-t size             target extent size hint (default: 32M)",
>  	"",
> +	"--compress-force    clear nocompress flag on files after defragment, only work with option -c",

This is probably --clear-nocompress .

The "force compress" semantics is up to kernel, so I think naming the
options 'clear-nocompress' is the right thing, as it's what it really
does.

> +	"",
>  	"Warning: most Linux kernels will break up the ref-links of COW data",
>  	"(e.g., files copied with 'cp --reflink', snapshots) which may cause",
>  	"considerable increase of space usage. See btrfs-filesystem(8) for",
> @@ -874,9 +877,39 @@ static const char * const cmd_filesystem_defrag_usage[] = {
>  	NULL
>  };
>  
> +static int clear_nocompress_flag(int fd)
> +{
> +	unsigned int flags;
> +	int ret = 0;
> +
> +	ret = ioctl(fd, FS_IOC_GETFLAGS, &flags);
> +	if (ret < 0) {
> +		ret = -errno;
> +		error("failed to get flags: %s", strerror(-ret));
> +		goto out;
> +	}
> +
> +	if (!(flags & FS_NOCOMP_FL)) {
> +		ret = 0;
> +		goto out;
> +	}
> +	flags &= ~FS_NOCOMP_FL;
> +	ret = ioctl(fd, FS_IOC_SETFLAGS, &flags);

This is inherently racy, but the inode flags do not change that often so
concurrent change is unlikely.

> +	if (ret < 0) {
> +		ret = -errno;
> +		error("failed to set flags: %s", strerror(-ret));
> +		goto out;
> +	}
> +
> +	ret = 0;
> +out:
> +	return ret;
> +}
> +
>  static struct btrfs_ioctl_defrag_range_args defrag_global_range;
>  static int defrag_global_verbose;
>  static int defrag_global_errors;
> +static int defrag_global_clear_nocompress;
>  static int defrag_callback(const char *fpath, const struct stat *sb,
>  		int typeflag, struct FTW *ftwbuf)
>  {
> @@ -904,6 +937,14 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
>  			err = errno;
>  			goto error;
>  		}
> +
> +		if (defrag_global_clear_nocompress) {
> +			ret = clear_nocompress_flag(fd);
> +			if (ret) {
> +				err = -ret;
> +				goto error;
> +			}
> +		}
>  	}
>  	return 0;
>  
> @@ -926,6 +967,12 @@ static int cmd_filesystem_defrag(int argc, char **argv)
>  	int compress_type = BTRFS_COMPRESS_NONE;
>  	DIR *dirstream;
>  
> +	enum { GETOPT_VAL_CLEAR_NOCOMPRESS = 257};
> +	static const struct option long_options[] = {
> +		{ "clear-nocompress", no_argument, NULL,
> +		  GETOPT_VAL_CLEAR_NOCOMPRESS},
> +		{ NULL, 0, NULL, 0}
> +	};
>  	/*
>  	 * Kernel has a different default (256K) that is supposed to be safe,
>  	 * but it does not defragment very well. The 32M will likely lead to
> @@ -937,8 +984,10 @@ static int cmd_filesystem_defrag(int argc, char **argv)
>  	defrag_global_errors = 0;
>  	defrag_global_verbose = 0;
>  	defrag_global_errors = 0;
> +	defrag_global_clear_nocompress = 0;
>  	while(1) {
> -		int c = getopt(argc, argv, "vrc::fs:l:t:");
> +		int c = getopt_long(argc, argv, "vrc::fs:l:t:", long_options,
> +				    NULL);
>  		if (c < 0)
>  			break;
>  
> @@ -972,6 +1021,9 @@ static int cmd_filesystem_defrag(int argc, char **argv)
>  		case 'r':
>  			recursive = 1;
>  			break;
> +		case GETOPT_VAL_CLEAR_NOCOMPRESS:
> +			defrag_global_clear_nocompress = 1;
> +			break;
>  		default:
>  			usage(cmd_filesystem_defrag_usage);
>  		}
> @@ -987,6 +1039,8 @@ static int cmd_filesystem_defrag(int argc, char **argv)
>  	if (compress_type) {
>  		defrag_global_range.flags |= BTRFS_DEFRAG_RANGE_COMPRESS;
>  		defrag_global_range.compress_type = compress_type;
> +	} else if (defrag_global_clear_nocompress) {
> +		warning("Option --clear-nocompress only works for -c");
>  	}
>  	if (flush)
>  		defrag_global_range.flags |= BTRFS_DEFRAG_RANGE_START_IO;
> @@ -1071,6 +1125,15 @@ static int cmd_filesystem_defrag(int argc, char **argv)
>  				      strerror(defrag_err));
>  				goto next;
>  			}
> +
> +			if (defrag_global_clear_nocompress)
> +				ret = clear_nocompress_flag(fd);
> +			if (ret) {
> +				error(
> +				"failed to drop nocompress flag on %s: %s",
> +				argv[i], strerror(-ret));
> +				goto next;
> +			}
>  		}
>  next:
>  		if (ret)
> -- 
> 2.15.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
