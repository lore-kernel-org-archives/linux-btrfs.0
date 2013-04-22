Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31767 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3DVJ2W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 05:28:22 -0400
Message-ID: <51750326.9080905@oracle.com>
Date: Mon, 22 Apr 2013 17:30:14 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alexander Block <ablock84@googlemail.com>
Subject: Re: [PATCH 1/2] btrfs-progs: set generation_v2 any time we write
 a new root
In-Reply-To: <5174C426.3030204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <5174C426.3030204@redhat.com>



  yeah we should set the v2 parameter at all the place where
  we call btrfs_set_root_generation. Sorry it slipped my mind.
  Thanks for the fix.

Thanks, Anand


On 04/22/2013 01:01 PM, Eric Sandeen wrote:
> With this integration branch commit in place:
>
> 2bd1169 btrfs-progs: root_item generation_v2 is out of sync after btrfsck
>
> I started seeing generation mismatch messages from the kernel
> at mount time, after a fresh mkfs(!):
>
>    btrfs: mismatching generation and generation_v2 found in root item...
>
> This is because the code which emits the warning does not do so if
> there is a mismatch but generation_v2 is 0; the above commit began
> setting generation_v2 to something non-zero, so the warning was emitted.
>
> The reason there is a mismatch at all is because mkfs.btrfs calls
> create_data_reloc_tree(), which copies a root, and then calls
> btrfs_set_root_generation(), bumping the original copied generation.
> But nothing updated generation_v2 to match on the way to disk.
>
> Fix this by updating generation_v2 in btrfs_insert_root(),
> as is done in the kernel.
>
> This is safe because it's a new root created by userspace, so
> the btrfs_root_item is guaranteed to be big enough to contain
> generation_v2.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> Another example of why we need to get userspace in sync with kernelspace...
>
> diff --git a/root-tree.c b/root-tree.c
> index 4454147..1823918 100644
> --- a/root-tree.c
> +++ b/root-tree.c
> @@ -105,6 +105,11 @@ int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
>   		      *item)
>   {
>   	int ret;
> +
> +	/*
> +	 * Make sure generation v1 and v2 match. See update_root for details.
> +	 */
> +	btrfs_set_root_generation_v2(item, btrfs_root_generation(item));
>   	ret = btrfs_insert_item(trans, root, key, item, sizeof(*item));
>   	return ret;
>   }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
