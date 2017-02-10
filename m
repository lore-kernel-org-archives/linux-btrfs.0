Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:22147 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752168AbdBJS7A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 13:59:00 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v1AFLecJ028750
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Feb 2017 15:21:40 GMT
Date: Fri, 10 Feb 2017 07:19:06 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove unused ulist members
Message-ID: <20170210151906.GA30334@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170209154743.11186-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170209154743.11186-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 09, 2017 at 04:47:43PM +0100, David Sterba wrote:
> Commit "btrfs: ulist: Add ulist_del() function" (d4b804045924d7f8)
> removed some debugging code but left the structure defintions.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ulist.h | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
> index a01a2c45825f..007b22fff3f9 100644
> --- a/fs/btrfs/ulist.h
> +++ b/fs/btrfs/ulist.h
> @@ -19,9 +19,6 @@
>   *
>   */
>  struct ulist_iterator {
> -#ifdef CONFIG_BTRFS_DEBUG
> -	int i;
> -#endif
>  	struct list_head *cur_list;  /* hint to start search */
>  };
>  
> @@ -32,10 +29,6 @@ struct ulist_node {
>  	u64 val;		/* value to store */
>  	u64 aux;		/* auxiliary value saved along with the val */
>  
> -#ifdef CONFIG_BTRFS_DEBUG
> -	int seqnum;		/* sequence number this node is added */
> -#endif
> -
>  	struct list_head list;  /* used to link node */
>  	struct rb_node rb_node;	/* used to speed up search */
>  };
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
