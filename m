From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v0 17/18] btrfs: add qgroup ioctls
Date: Thu, 06 Oct 2011 13:40:35 -0700
Message-ID: <m2pqi93lbw.fsf@firstfloor.org>
References: <cover.1317915010.git.sensille@gmx.net>
	<0344fa710f60981488cd3b6583a88c81d507acfd.1317915011.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <0344fa710f60981488cd3b6583a88c81d507acfd.1317915011.git.sensille@gmx.net>
	(Arne Jansen's message of "Thu, 6 Oct 2011 17:54:27 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Arne Jansen <sensille@gmx.net> writes:
> +
> +	if (copy_to_user(arg, sa, sizeof(*sa)))
> +		ret = -EFAULT;
> +
> +	if (trans) {
> +		err = btrfs_commit_transaction(trans, root);
> +		if (err && !ret)
> +			ret = err;
> +	}

It would seem safer to put the copy to user outside the transaction.
A cto can in principle cause new writes (e.g. if it causes COW), so 
you may end up with nested transactions. Even if that works somehow
(not sure) it seems to be a thing better avoided.

> +
> +	sa = memdup_user(arg, sizeof(*sa));
> +	if (IS_ERR(sa))
> +		return PTR_ERR(sa);
> +
> +	trans = btrfs_join_transaction(root);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out;
> +	}

This code seems to be duplicated a lot. Can it be consolidated?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
