Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17033 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3IMKoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 06:44:07 -0400
MIME-Version: 1.0
Message-ID: <8bcb44f3-2cae-45a6-92d7-0d22ff3437dd@default>
Date: Fri, 13 Sep 2013 03:44:02 -0700 (PDT)
From: Anand Jain <anand.jain@oracle.com>
To: <dsterba@suse.cz>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2 resend] btrfs-progs: v4, move out print in cmd_df to
 another function
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



 all of them were considered, v5 sent out.

Thanks, Anand

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
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
