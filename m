Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33833 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751060AbdBJA4T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Feb 2017 19:56:19 -0500
Subject: Re: [PATCH] btrfs: remove unused ulist members
To: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20170209154743.11186-1-dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a8c7eb63-4850-a4cc-03a5-5631306ce1c6@cn.fujitsu.com>
Date: Fri, 10 Feb 2017 08:56:01 +0800
MIME-Version: 1.0
In-Reply-To: <20170209154743.11186-1-dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/09/2017 11:47 PM, David Sterba wrote:
> Commit "btrfs: ulist: Add ulist_del() function" (d4b804045924d7f8)
> removed some debugging code but left the structure defintions.
>
> Signed-off-by: David Sterba <dsterba@suse.com>

Thanks for deleting that, I forgot to remove the member in structure.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
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
>


