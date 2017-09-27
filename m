Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:65348 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750854AbdI0HY6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 03:24:58 -0400
Subject: Re: [PATCH 2/5] btrfs-progs: check: call repair_root_items() before
 any repair
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
 <20170927063440.25961-3-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6a213a79-82c3-ce8f-ff8a-46eb535db872@gmx.com>
Date: Wed, 27 Sep 2017 15:24:48 +0800
MIME-Version: 1.0
In-Reply-To: <20170927063440.25961-3-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月27日 14:34, Su Yue wrote:
> The Annotation of repair_root_items():
> "This must be run before any other repair code - not doing it so,
> makes other repair code delete or modify backrefs in the extent tree
> for example, which will result in an inconsistent fs after repairing
> the root items."
> 
> However, the rule was broken by commit
> "6896ab801d47419fa06d886bae4bf31d0287ced1" which intends to fix

Wrong commit.

commit 6896ab801d47419fa06d886bae4bf31d0287ced1
Author: Qu Wenruo <quwenruo.btrfs@gmx.com>
Date:   Mon Sep 11 15:36:12 2017 +0900

     btrfs-progs: docs: mkfs: Add extra condition for rootdir option

This commit has no way affect btrfs check.

Please use first 12 characters and one line summary to describe the commit.
And of course, use correct commit.

Thanks,
Qu


> failure of test-fsck/013.
> The correct way is to skip calling repair_root_item() when
> init_extent_tree is nonzero.
> 
> Now put repair_root_items() before do_check_chunks_and_extents() and
> not call repair_root_items() if do init_extent_tree.
> Then test-fsck/013 works well.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>   cmds-check.c | 43 +++++++++++++++++++++++--------------------
>   1 file changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 93b47194..3e2f9faa 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -14644,32 +14644,35 @@ int cmd_check(int argc, char **argv)
>   		goto close_out;
>   	}
>   
> +	if (!init_extent_tree) {
> +		ret = repair_root_items(info);
> +		err |= !!ret;
> +		if (ret < 0) {
> +			error("failed to repair root items: %s",
> +			      strerror(-ret));
> +			goto close_out;
> +		}
> +		if (repair) {
> +			fprintf(stderr, "Fixed %d roots.\n", ret);
> +			ret = 0;
> +		} else if (ret > 0) {
> +			fprintf(stderr,
> +				"Found %d roots with an outdated root item.\n",
> +				ret);
> +			fprintf(stderr,
> +				"Please run a filesystem check with the option --repair to fix them.\n");
> +			ret = 1;
> +			err |= !!ret;
> +			goto close_out;
> +		}
> +	}
> +
>   	ret = do_check_chunks_and_extents(info);
>   	err |= !!ret;
>   	if (ret)
>   		error(
>   		"errors found in extent allocation tree or chunk allocation");
>   
> -	ret = repair_root_items(info);
> -	err |= !!ret;
> -	if (ret < 0) {
> -		error("failed to repair root items: %s", strerror(-ret));
> -		goto close_out;
> -	}
> -	if (repair) {
> -		fprintf(stderr, "Fixed %d roots.\n", ret);
> -		ret = 0;
> -	} else if (ret > 0) {
> -		fprintf(stderr,
> -		       "Found %d roots with an outdated root item.\n",
> -		       ret);
> -		fprintf(stderr,
> -			"Please run a filesystem check with the option --repair to fix them.\n");
> -		ret = 1;
> -		err |= !!ret;
> -		goto close_out;
> -	}
> -
>   	if (!ctx.progress_enabled) {
>   		if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
>   			fprintf(stderr, "checking free space tree\n");
> 
