Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbaA0RlO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 12:41:14 -0500
Date: Mon, 27 Jan 2014 18:41:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Gerhard Heift <gerhard@heift.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv2 4/6] btrfs: new ioctl TREE_SEARCH_V2
Message-ID: <20140127174113.GC6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
 <1390829312-814-5-git-send-email-Gerhard@Heift.Name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390829312-814-5-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 27, 2014 at 02:28:30PM +0100, Gerhard Heift wrote:
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2032,6 +2032,52 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
>  	return ret;
>  }
>  
> +static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
> +					   void __user *argp)
> +{
> +	struct btrfs_ioctl_search_args_v2 *args;
> +	struct inode *inode;
> +	int ret;
> +	char *buf;
> +	size_t buf_size;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* copy search header and buffer size */
> +	args = memdup_user(argp, sizeof(*args));
> +	if (IS_ERR(args))
> +		return PTR_ERR(args);
> +
> +	buf_size = args->buf_size;
> +
> +	if (buf_size < sizeof(struct btrfs_ioctl_search_header)) {
> +		kfree(args);
> +		return -ENOMEM;

ENOMEM does not seem correct here, it's not a memory allocation failure
but rather an underflow of the buffer size, possibly EINVAL or EOVERFLOW
as the other checks return.

> +	}
> +
> +	/* limit memory */
> +	if (buf_size > PAGE_SIZE * 32)
> +		buf_size = PAGE_SIZE * 32;
> +
> +	buf = memdup_user(argp->buf, buf_size);

Memory allocations are not that easy, getting a contiguous 32 * 4k = 128k
buffer may often fail. And the point of the V2 ioctl was to avoid
allocating the buffer, and do copy_to_user directly.

Also, you remove this code in the next patch, I don't think this level
of patch granularity is necessary.

> +	if (IS_ERR(buf)) {
> +		kfree(args);
> +		return PTR_ERR(buf);
> +	}
> +
> +	inode = file_inode(file);
> +	ret = search_ioctl(inode, &args->key, buf_size, buf);
> +	if (ret == 0 && (
> +		copy_to_user(argp, args, sizeof(*args)) ||
> +		copy_to_user(argp->buf, buf, buf_size)
> +		))
> +		ret = -EFAULT;
> +	kfree(buf);
> +	kfree(args);
> +	return ret;
> +}
