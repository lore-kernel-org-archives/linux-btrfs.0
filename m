Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22094 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbbJWCPD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 22:15:03 -0400
Subject: Re: [PATCH] Btrfs: igrab inode in writepage
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <1445540709-26995-1-git-send-email-jbacik@fb.com>
From: Liu Bo <bo.li.liu@oracle.com>
Message-ID: <5629981E.4040207@oracle.com>
Date: Fri, 23 Oct 2015 10:14:54 +0800
MIME-Version: 1.0
In-Reply-To: <1445540709-26995-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/23/2015 03:05 AM, Josef Bacik wrote:
> We hit this panic on a few of our boxes this week where we have an
> ordered_extent with an NULL inode.  We do an igrab() of the inode in writepages,
> but weren't doing it in writepage which can be called directly from the VM on
> dirty pages.  If the inode has been unlinked then we could have I_FREEING set
> which means igrab() would return NULL and we get this panic.  Fix this by trying
> to igrab in btrfs_writepage, and if it returns NULL then just redirty the page
> and return AOP_WRITEPAGE_ACTIVATE; so the VM knows it wasn't successful.  Thanks,
>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

thanks,

-Liubo

> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>   fs/btrfs/inode.c | 17 +++++++++++++++--
>   1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a0fa725..4d1fdc2 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8438,15 +8438,28 @@ int btrfs_readpage(struct file *file, struct page *page)
>   static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
>   {
>   	struct extent_io_tree *tree;
> -
> +	struct inode *inode = page->mapping->host;
> +	int ret;
>
>   	if (current->flags & PF_MEMALLOC) {
>   		redirty_page_for_writepage(wbc, page);
>   		unlock_page(page);
>   		return 0;
>   	}
> +
> +	/*
> +	 * If we are under memory pressure we will call this directly from the
> +	 * VM, we need to make sure we have the inode referenced for the ordered
> +	 * extent.  If not just return like we didn't do anything.
> +	 */
> +	if (!igrab(inode)) {
> +		redirty_page_for_writepage(wbc, page);
> +		return AOP_WRITEPAGE_ACTIVATE;
> +	}
>   	tree = &BTRFS_I(page->mapping->host)->io_tree;
> -	return extent_write_full_page(tree, page, btrfs_get_extent, wbc);
> +	ret = extent_write_full_page(tree, page, btrfs_get_extent, wbc);
> +	btrfs_add_delayed_iput(inode);
> +	return ret;
>   }
>
>   static int btrfs_writepages(struct address_space *mapping,
>

