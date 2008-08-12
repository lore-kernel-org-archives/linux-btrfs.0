From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] NFS support for btrfs - v2
Date: Tue, 12 Aug 2008 14:51:41 -0400
Message-ID: <20080812185141.GB29426@infradead.org>
References: <200806290505.31641.balajirrao@gmail.com> <1218548806.2977.179.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218548806.2977.179.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 12, 2008 at 02:46:46PM +0100, David Woodhouse wrote:
> +static inline struct dentry *d_obtain_alias(struct inode *inode)
> +{
> +	struct dentry *d = d_alloc_anon(inode);
> +	if (!d)
> +		iput(inode);
> +	return d;
> +}
> +#endif

I'm not sure when al wants to merge with Linus, but the for-next naming
makes it sound like the tree is the .28 queue.  Also please take the
full implementation of d_obtain_alias from

	http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commitdiff;h=10cdb734be3c4175b977ba18eafbaba8e5716291

please.  Your light implementation will crash and burn when btrfs_iget
returns an error.

> +/* The size of encoded fh is the type number of the fh itself */
> +#define BTRFS_FID_NON_CONNECTABLE		5
> +#define BTRFS_FID_CONNECTABLE	 		8

That was an assumption in the very old code, but I think it's a very
bad idea.  Just give your filehandles a uniqueue type number, e.g. in
the 0x4? range so that people looking at nfs traffic using a packet
analyzer know what kind of fhs they are actually dealing with.

> +	if (IS_ERR(inode))
> +		return (void *)inode;
> +
> +	if (generation != inode->i_generation) {
> +		iput(inode);
> +		return ERR_PTR(-ESTALE);
> +	}
> +
> +	result = d_alloc_anon(inode);
> +	if (!result) {
> +		iput(inode);
> +		return ERR_PTR(-ENOMEM);
> +	}

Didn't you intend to use d_obtain_alias?

