From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v5 8/8] btrfs: new ioctls to do logical->inode and inode->path resolving
Date: Thu, 21 Jul 2011 13:14:16 -0700
Message-ID: <m2d3h34civ.fsf@firstfloor.org>
References: <cover.1311244592.git.list.btrfs@jan-o-sch.net>
	<d1e9e9c9695a1291d624ad86abb8648f7d04a848.1311244592.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d1e9e9c9695a1291d624ad86abb8648f7d04a848.1311244592.git.list.btrfs@jan-o-sch.net>
	(Jan Schmidt's message of "Thu, 21 Jul 2011 13:19:48 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt <list.btrfs@jan-o-sch.net> writes:
> +
> +static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
> +					void __user *arg)
> +{
> +	int ret = 0;
> +	int size;
> +	u64 extent_offset;
> +	struct btrfs_ioctl_logical_ino_args *loi;
> +	struct btrfs_data_container *inodes = NULL;
> +	struct btrfs_path *path = NULL;
> +	struct btrfs_key key;

This really needs to be root-only for obvious reasons.
The same for the ino_path function

> +
> +	loi = memdup_user(arg, sizeof(*loi));
> +	if (IS_ERR(loi)) {
> +		ret = PTR_ERR(loi);
> +		loi = NULL;
> +		goto out;
> +	}
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	size = min(loi->size, 4096);

This is likely a root hole. loi->size is signed! Consider the case
of a negative value being passed in.

Same for the earlier function.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
