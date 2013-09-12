Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab3ILPmk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 11:42:40 -0400
Date: Thu, 12 Sep 2013 17:42:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2 resend] btrfs-progs: v4, move out print in cmd_df to
 another function
Message-ID: <20130912154237.GC6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377851756-4009-1-git-send-email-anand.jain@oracle.com>
 <1378460273-20647-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1378460273-20647-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 06, 2013 at 05:37:52PM +0800, Anand Jain wrote:
> +static char *group_type_str(u64 flag)
>  {
> -	struct btrfs_ioctl_space_args *sargs, *sargs_orig;
> -	u64 count = 0, i;
> -	int ret;
> -	int fd;
> -	int e;
> -	char *path;
> -	DIR  *dirstream = NULL;
> -
> -	if (check_argc_exact(argc, 2))
> -		usage(cmd_df_usage);
> -
> -	path = argv[1];
> +	switch (flag & BTRFS_BLOCK_GROUP_TYPE_MASK) {
> +	case BTRFS_BLOCK_GROUP_DATA:
> +		return "data";
> +	case BTRFS_BLOCK_GROUP_SYSTEM:
> +		return "system";
> +	case BTRFS_BLOCK_GROUP_METADATA:
> +		return "metadata";
> +	case BTRFS_BLOCK_GROUP_DATA|BTRFS_BLOCK_GROUP_METADATA:
> +		return "mixed";

I think the profile names should stay unchanged, ie Data, System etc,
and Data+Metadata instead of mixed. We can change the output format
later, but for this preparatory patch I'd stick with what it is.

> +	default:
> +		return "unknown";
> +	}
> +}
>  
> -	fd = open_file_or_dir(path, &dirstream);
> -	if (fd < 0) {
> -		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> -		return 12;
> +static char *group_profile_str(u64 flag)
> +{
> +	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
> +	case 0:
> +		return "single";

The 'single' profile was not explicitly mentioned before, I tend to
think that it's better to be consistent with the rest and add it as you
do in this patch.

Sample output:

$ ./btrfs fi df /mnt/enospc/mnt
data, single: total=5.92GiB, used=4.41GiB
system, DUP: total=8.00MiB, used=4.00KiB
system, single: total=4.00MiB, used=0.00
metadata, DUP: total=1.02GiB, used=828.10MiB
metadata, single: total=8.00MiB, used=0.00

looks imho ok.
