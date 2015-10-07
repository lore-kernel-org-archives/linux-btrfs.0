Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:15982 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752397AbbJGA6p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Oct 2015 20:58:45 -0400
Subject: Re: [PATCH v2 1/2] btrfs: Add support to do stack item key operation
To: <linux-btrfs@vger.kernel.org>
References: <1444093136-9913-1-git-send-email-quwenruo@cn.fujitsu.com>
CC: <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56146E1A.30103@cn.fujitsu.com>
Date: Wed, 7 Oct 2015 08:58:02 +0800
MIME-Version: 1.0
In-Reply-To: <1444093136-9913-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Qu Wenruo wrote on 2015/10/06 08:58 +0800:
> Normal btrfs_item_key_to_cpu() will need extent buffer to do it, and
> there is not stack version to handle in memory leaf.
>
> Add btrfs_stack_item_key_to_cpu() function for such operation, which
> will provide the basis for later qgroup fix.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2:
>    Change the char* parameter to struct btrfs_header *, as a leaf always
>    starts with a header.
> ---
>   fs/btrfs/ctree.h | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 938efe3..4864dfe 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2683,6 +2683,17 @@ static inline void btrfs_item_key(struct extent_buffer *eb,
>   	read_eb_member(eb, item, struct btrfs_item, key, disk_key);
>   }
>
> +static inline void btrfs_stack_item_key(struct btrfs_header *stack_leaf,
> +					struct btrfs_disk_key *disk_key,
> +					int nr)
> +{
> +	unsigned long item_offset = btrfs_item_nr_offset(nr);
> +	struct btrfs_item *item;
> +
> +	item = (struct btrfs_item *)(stack_leaf + item_offset);
Please ignore this version, as I changed the type of stack_leaf but 
didn't force convert it to (char *).

I'll update it soon.

Thanks,
Qu
> +	memcpy(disk_key, &item->key, sizeof(*disk_key));
> +}
> +
>   static inline void btrfs_set_item_key(struct extent_buffer *eb,
>   			       struct btrfs_disk_key *disk_key, int nr)
>   {
> @@ -2785,6 +2796,15 @@ static inline void btrfs_item_key_to_cpu(struct extent_buffer *eb,
>   	btrfs_disk_key_to_cpu(key, &disk_key);
>   }
>
> +static inline void btrfs_stack_item_key_to_cpu(struct btrfs_header *stack_leaf,
> +					       struct btrfs_key *key,
> +					       int nr)
> +{
> +	struct btrfs_disk_key disk_key;
> +	btrfs_stack_item_key(stack_leaf, &disk_key, nr);
> +	btrfs_disk_key_to_cpu(key, &disk_key);
> +}
> +
>   static inline void btrfs_dir_item_key_to_cpu(struct extent_buffer *eb,
>   				      struct btrfs_dir_item *item,
>   				      struct btrfs_key *key)
>
