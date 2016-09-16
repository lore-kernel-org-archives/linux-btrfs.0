Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46318 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752756AbcIPJCr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Sep 2016 05:02:47 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bkp2X-0002fp-Jm
        for linux-btrfs@vger.kernel.org; Fri, 16 Sep 2016 11:02:33 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Subject: Re: [PATCH] Btrfs: handle quota reserve failure properly
Date: Fri, 16 Sep 2016 09:02:22 +0000 (UTC)
Message-ID: <pan$e2095$fbe056c8$f4eac82$cda700a2@applied-asynchrony.com>
References: <1473965868-9675-1-git-send-email-jbacik@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 15 Sep 2016 14:57:48 -0400, Josef Bacik wrote:

> btrfs/022 was spitting a warning for the case that we exceed the quota.  If we
> fail to make our quota reservation we need to clean up our data space
> reservation.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 03da2f6..d72eaae 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4286,13 +4286,10 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
>  	if (ret < 0)
>  		return ret;
>  
> -	/*
> -	 * Use new btrfs_qgroup_reserve_data to reserve precious data space
> -	 *
> -	 * TODO: Find a good method to avoid reserve data space for NOCOW
> -	 * range, but don't impact performance on quota disable case.
> -	 */
> +	/* Use new btrfs_qgroup_reserve_data to reserve precious data space. */
>  	ret = btrfs_qgroup_reserve_data(inode, start, len);
> +	if (ret)
> +		btrfs_free_reserved_data_space_noquota(inode, start, len);
>  	return ret;
>  }
>  
> -- 
> 2.7.4

This came up before, though slightly different:
http://www.spinics.net/lists/linux-btrfs/msg56644.html

Which version is correct - with or without _noquota ?

-h

