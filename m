Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759963AbaJ3PK6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 11:10:58 -0400
Date: Thu, 30 Oct 2014 16:10:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix number of arguments check of 'btrfs fi
 df'
Message-ID: <20141030151055.GB21354@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1413877333-14507-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413877333-14507-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 21, 2014 at 03:42:13PM +0800, Qu Wenruo wrote:
> 'btrfs fi df' needs exactly one arguments as mount option,
> and due to the introduce of human readable options, some check is not
> valid now, the new optind can point to the ending NULL string.
> 
> For example, you can run 'btrfs fi df' without any argument, and it will
> error as "ERROR: can't access '%s'" which means the argument number
> check is not valid.

Thanks for catching it.

> This patch will use the old check_argc_exact() but introduce opt_num to
> record how many options is provided, ensuring there will be and only be
> one mount point provided.

> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -237,11 +237,11 @@ static int cmd_df(int argc, char **argv)
>  	struct btrfs_ioctl_space_args *sargs = NULL;
>  	int ret;
>  	int fd;
> +	int opt_num = 0;
>  	char *path;
>  	DIR *dirstream = NULL;
>  	unsigned unit_mode = UNITS_DEFAULT;
>  
> -	optind = 1;
>  	while (1) {
>  		int long_index;
>  		static const struct option long_options[] = {
> @@ -257,6 +257,7 @@ static int cmd_df(int argc, char **argv)
>  					&long_index);
>  		if (c < 0)
>  			break;
> +		opt_num++;
>  		switch (c) {
>  		case 'b':
>  			unit_mode = UNITS_RAW;
> @@ -290,7 +291,7 @@ static int cmd_df(int argc, char **argv)
>  		}
>  	}
>  
> -	if (check_argc_max(argc, optind + 1))
> +	if (check_argc_exact(argc, 2 + opt_num))

Well, a simple change to check_argc_exact(argc, optind + 1) fixes it for
me. The optind is supposed to track the argument index and you're
duplicating it with opt_num.

I'll commit it with this simplified version (and changelog updated):

--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -248,7 +248,7 @@ static int cmd_filesystem_df(int argc, char **argv)
                }
        }

-       if (check_argc_max(argc, optind + 1))
+       if (check_argc_exact(argc, optind + 1))
                usage(cmd_filesystem_df_usage);

        path = argv[optind];
