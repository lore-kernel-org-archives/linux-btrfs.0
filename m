From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix regression in re-setting a large xattr
Date: Fri, 14 Oct 2011 09:04:28 +0900
Message-ID: <4E977C8C.9000809@jp.fujitsu.com>
References: <1318525894-14548-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1318525894-14548-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/10/14 2:11), Josef Bacik wrote:
> Recently I changed the xattr stuff to unconditionally set the xattr first in
> case the xattr didn't exist yet.  This has introduced a regression when setting
> an xattr that already exists with a large value.  If we find the key we are
> looking for split_leaf will assume that we're extending that item.  The problem
> is the size we pass down to btrfs_search_slot includes the size of the item
> already, so if we have the largest xattr we can possibly have plus the size of
> the xattr item plus the xattr item that btrfs_search_slot we'd overflow the
> leaf.  Thankfully this is not what we're doing, but split_leaf doesn't know this
> so it just returns EOVERFLOW.  So in the xattr code we need to check and see if
> we got back EOVERFLOW and treat it like EEXIST since that's really what
> happened.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/xattr.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
> index 69565e5..5bd7877 100644
> --- a/fs/btrfs/xattr.c
> +++ b/fs/btrfs/xattr.c
> @@ -127,7 +127,18 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
>  again:
>  	ret = btrfs_insert_xattr_item(trans, root, path, btrfs_ino(inode),
>  				      name, name_len, value, size);
> -	if (ret == -EEXIST) {
> +	/*
> +	 * If we're setting an xattr to a new value but the new value is say
> +	 * exactly BTRFS_MAX_XATTR_SIZE, we could end up with EOVERFLOW getting
> +	 * back from split_leaf.  This is because it thinks we'll be extending
> +	 * the existing item size, but we're asking for enough space to add the
> +	 * item itself.  So if we get EOVERFLOW just set ret to EEXIST and let
> +	 * the rest of the function figure it out.
> +	 */
> +	if (ret == -EOVERFLOW)
> +		ret = -EEXIST;
> +
> +	if (ret == -EEXIST || ret == -EOVERFLOW) {

Why tested again EOVERFLOW?

Thanks,
Tsutomu

>  		if (flags & XATTR_CREATE)
>  			goto out;
>  		/*

