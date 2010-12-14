From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/5] add metadata_incore ioctl in vfs
Date: Mon, 13 Dec 2010 16:40:36 -0800
Message-ID: <20101213164036.020be83d.akpm@linux-foundation.org>
References: <1292224930.2323.450.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292224930.2323.450.camel@sli10-conroe>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 13 Dec 2010 15:22:10 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> Add an ioctl to dump filesystem's metadata in memory in vfs. Userspace collects
> such info and uses it to do metadata readahead.
> Filesystem can hook to super_operations.metadata_incore to get metadata in
> specific approach. Next patch will give an example how to implement
> .metadata_incore in btrfs.
> 

Please cc Michael Kerrisk <mtk.manpages@gmail.com> and
linux-api@vger.kernel.org.  I'm sure that assistance writing the
manpage would be appreciated.

>
> ...
>
>  /*
> + * Copy info about metadata in memory to userspace
> + * Returns:
> + * > 0, number of metadata_incore_ent entries copied to userspace
> + * = 0, no more metadata
> + * < 0, error
> + */
> +static int ioctl_metadata_incore(struct file *filp, void __user *argp)
> +{
> +	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +	struct metadata_incore_args args;
> +	struct metadata_incore_ent ent;
> +	loff_t offset, last_offset = 0;
> +	ssize_t size, last_size = 0;
> +	__u64 __user vec_addr;
> +	int entries = 0;
> +
> +	if (!sb->s_op->metadata_incore)
> +		return -EOPNOTSUPP;

EOPNOTSUPP is a networking errno - it doesn't seem appropriate for an
fs ioctl.

> +	if (copy_from_user(&args, (struct metadata_incore_args __user *)argp,

Unneeded typecast.

> +			sizeof(args)))
> +		return -EFAULT;
> +
> +	/* Check the start address: needs to be page-aligned.. */

Why?  The comment should tell me this.

> +	if (args.offset & ~PAGE_CACHE_MASK)
> +		return -EINVAL;
> +
> +	if ((args.vec_size % sizeof(struct metadata_incore_ent)) != 0)
> +		return -EINVAL;
> +
> +	if (!access_ok(VERIFY_WRITE, args.vec_addr, args.vec_size))

Seems unneccessary - copy_to_user() checks this.

> +		return -EFAULT;
> +
> +	offset = args.offset;
> +
> +	ent.unused = 0;
> +	vec_addr = args.vec_addr;
> +
> +	while (vec_addr < args.vec_addr + args.vec_size) {
> +		if (signal_pending(current))
> +			return -EINTR;
> +		cond_resched();
> +
> +		if (sb->s_op->metadata_incore(sb, &offset, &size) < 0)
> +			break;
> +		/* A merge or offset == 0 */
> +		if (offset == last_offset + last_size) {
> +			last_size += size;
> +			offset = offset + size;
> +			continue;
> +		}
> +		ent.offset = last_offset;
> +		ent.size = last_size;
> +		if (copy_to_user((void *)(long)vec_addr, &ent, sizeof(ent)))
> +			return -EFAULT;
> +		vec_addr += sizeof(ent);
> +		entries++;
> +
> +		last_offset = offset;
> +		last_size = size;
> +		ent.unused = 0;
> +		offset = offset + size;
> +	}
> +
> +	if (last_size > 0 && vec_addr < args.vec_addr + args.vec_size) {
> +		ent.offset = last_offset;
> +		ent.size = last_size;
> +		if (copy_to_user((void *)(long)vec_addr, &ent, sizeof(ent)))
> +			return -EFAULT;
> +		entries++;
> +	}
> +
> +	return entries;
> +}
> +
> +/*
>   * When you add any new common ioctls to the switches above and below
>   * please update compat_sys_ioctl() too.
>   *
>
> ...
>

