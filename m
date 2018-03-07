Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48369 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbeCGIFW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 03:05:22 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 29C52AF77
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Mar 2018 08:05:21 +0000 (UTC)
Subject: Re: [PATCH 2/8] btrfs-progs: qgroups: fix misleading index check
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-3-jeffm@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f0f11e32-c9d3-c1b7-54de-33729af067f6@suse.com>
Date: Wed, 7 Mar 2018 10:05:20 +0200
MIME-Version: 1.0
In-Reply-To: <20180302184704.22399-3-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.03.2018 20:46, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> In print_single_qgroup_table we check the loop index against
> BTRFS_QGROUP_CHILD, but what we really mean is "last column."  Since
> we have an enum value to indicate the last value, use that instead
> of assuming that BTRFS_QGROUP_CHILD is always last.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  qgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/qgroup.c b/qgroup.c
> index 11659e83..67bc0738 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -267,7 +267,7 @@ static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
>  			continue;
>  		print_qgroup_column(qgroup, i);
>  
> -		if (i != BTRFS_QGROUP_CHILD)
> +		if (i != BTRFS_QGROUP_ALL - 1)
>  			printf(" ");
>  	}
>  	printf("\n");
> 
