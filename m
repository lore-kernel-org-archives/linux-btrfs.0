Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbaA0SLg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 13:11:36 -0500
Date: Mon, 27 Jan 2014 19:11:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Gerhard Heift <gerhard@heift.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv2 5/6] btrfs: search_ioctl: direct copy to userspace
Message-ID: <20140127181134.GD6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
 <1390829312-814-6-git-send-email-Gerhard@Heift.Name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390829312-814-6-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 27, 2014 at 02:28:31PM +0100, Gerhard Heift wrote:
> By copying each found item seperatly to userspace, we only need a small buffer
> in the kernel. This allows to run a large search inside of a single call.
> 
> Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
> ---
>  fs/btrfs/ioctl.c | 107 ++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 71 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index c44fcdd..38403e6 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1905,20 +1908,47 @@ static noinline int copy_to_sk(struct btrfs_root *root,
>  		sh.transid = found_transid;
>  
>  		/* copy search result header */
> -		memcpy(buf + *sk_offset, &sh, sizeof(sh));
> +		if (copy_to_user(buf + *sk_offset, &sh, sizeof(sh))) {
> +			ret = -EFAULT;
> +			goto err;
> +		}
> +
>  		*sk_offset += sizeof(sh);
>  
>  		if (item_len) {
> -			char *p = buf + *sk_offset;
> +			/* resize internal buffer if needed */
> +			if (content_buffer_size < item_len) {
> +				kfree(content_buffer);
> +
> +				content_buffer_size =
> +					ALIGN(item_len, PAGE_SIZE);
> +
> +				content_buffer = kmalloc_track_caller(
> +					content_buffer_size, GFP_KERNEL);

So that's another allocation. I see it's due to read_extent_buffer()
that wants a kernel memory, and the buffer size is again up to the item
size, potentially spanning multiple pages.

> +				if (!content_buffer) {
> +					content_buffer_size = 0;
> +					ret = -ENOMEM;
> +					goto err;
> +				}
> +			}
> +
>  			/* copy the item */
> -			read_extent_buffer(leaf, p,
> +			read_extent_buffer(leaf, content_buffer,
>  					   item_off, item_len);

My suggestion is to introduce read_extent_buffer_user that does
copy_to_user instead of the memcpy. It is code duplication, but we can
clean it in a separate patch.

> +
> +			if (copy_to_user(buf + *sk_offset,
> +					 content_buffer, item_len)) {
> +				ret = -EFAULT;
> +				goto err;
> +			}
> +
>  			*sk_offset += item_len;
>  		}
>  		(*num_found)++;
>  
>  		if (ret) /* -EOVERFLOW from above */
> -			goto overflow;
> +			goto err;
>  
>  		if (*num_found >= sk->nr_items)
>  			break;
> @@ -1936,14 +1966,25 @@ advance_key:
>  		key->objectid++;
>  	} else
>  		ret = 1;
> -overflow:
> +err:
> +	/*
> +	    0: all items from this leaf copied, continue with next
> +	    1: more items can be copied, but buffer is too small or all items
> +	       were found. Either way, it will stops the loop which iterates to
> +	       the next leaf
> +	    -EOVERFLOW: item was to large for buffer
> +	    -ENOMEM: could not allocate memory for a temporary extent buffer
> +	    -EFAULT: could not copy extent buffer back to userspace
> +	*/

Please use the kernel style for comments.

> +	kfree(content_buffer);
> +
>  	return ret;
>  }
>  
> @@ -2011,34 +2053,39 @@ err:
>  static noinline int btrfs_ioctl_tree_search(struct file *file,
>  					   void __user *argp)
>  {
> -	 struct btrfs_ioctl_search_args *args;
> -	 struct inode *inode;
> -	 int ret;
> +	struct btrfs_ioctl_search_args __user *usarg;
> +	struct btrfs_ioctl_search_key *sk;
> +	struct inode *inode;
> +	int ret;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> -	args = memdup_user(argp, sizeof(*args));
> -	if (IS_ERR(args))
> -		return PTR_ERR(args);
> +	usarg = (struct btrfs_ioctl_search_args __user *)argp;
> +
> +	sk = memdup_user(&usarg->key, sizeof(*sk));

Search key is 13x u64 = 104 bytes, you can use a local variable. This is
usually possible in ioctl functions, the stack is not deep at this
moment and will usually not grow too much. Removing the allocation makes
it a bit more resilient against ENOMEM conditions.

> +	if (IS_ERR(sk))
> +		return PTR_ERR(sk);
>  
>  	inode = file_inode(file);
> -	ret = search_ioctl(inode, &args->key, sizeof(args->buf), args->buf);
> +	ret = search_ioctl(inode, sk, sizeof(usarg->buf), usarg->buf);

Ok, v1 ioctl uses the same code in the end.

> +	/* the origin ioctl does handle too large results by returning an item
> +	* with a len of 0 */
>  	if (ret == -EOVERFLOW)
>  		ret = 0;
> -	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
> +	if (ret == 0 && copy_to_user(argp, sk, sizeof(*sk)))
>  		ret = -EFAULT;
> -	kfree(args);
> +	kfree(sk);
>  	return ret;
>  }
