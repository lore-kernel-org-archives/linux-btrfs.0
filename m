From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 3/5]add metadata_readahead ioctl in vfs
Date: Mon, 13 Dec 2010 16:46:27 -0800
Message-ID: <20101213164627.d27120c4.akpm@linux-foundation.org>
References: <1292224934.2323.452.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1292224934.2323.452.camel@sli10-conroe>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 13 Dec 2010 15:22:14 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> Add metadata readahead ioctl in vfs. Filesystem can hook to
> super_operations.metadata_readahead to handle filesystem specific task.
> Next patch will give an example how btrfs implements it.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  fs/compat_ioctl.c  |    1 +
>  fs/ioctl.c         |   21 +++++++++++++++++++++
>  include/linux/fs.h |    8 ++++++++
>  3 files changed, 30 insertions(+)
> 
> Index: linux/fs/ioctl.c
> ===================================================================
> --- linux.orig/fs/ioctl.c	2010-12-13 14:01:56.000000000 +0800
> +++ linux/fs/ioctl.c	2010-12-13 14:10:42.000000000 +0800
> @@ -605,6 +605,24 @@ static int ioctl_metadata_incore(struct
>  	return entries;
>  }
>  
> +static int ioctl_metadata_readahead(struct file *filp, void __user *argp)
> +{
> +	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +	struct metadata_readahead_args args;
> +
> +	if (!sb->s_op->metadata_readahead)
> +		return -EOPNOTSUPP;

-ENOTNETWORKING

> +	if (copy_from_user(&args, (struct metadata_readahead_args __user *)argp,

Unneeded cast.

> +			sizeof(args)))
> +		return -EFAULT;
> +
> +	if ((args.offset & ~PAGE_CACHE_MASK) || (args.size & ~PAGE_CACHE_MASK))

Why?

> +		return -EINVAL;
> +
> +	return sb->s_op->metadata_readahead(sb, args.offset, args.size);
> +}
> +

