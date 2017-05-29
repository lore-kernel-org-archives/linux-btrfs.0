Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32772 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751068AbdE2PXo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 11:23:44 -0400
Date: Mon, 29 May 2017 17:22:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Introduce btrfs_check_namelen to avoid
 reading beyond boundary
Message-ID: <20170529152243.GL14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170525020908.25830-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170525020908.25830-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 10:09:06AM +0800, Su Yue wrote:
> When reading out name from inode_ref, dir_item, it's possible that
> corrupted name_len lead to read beyond boundary.
> 
> Since there are already patches for btrfs-progs, this is for btrfs.
> 
> Introduce function btrfs_check_namelen, it should be called before reading
> name from extent_buffer.
> The function compares arg @namelen with boundary then returns 'proper'
> namelen.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Such validation is useful, but I'm concerned about the proposed
implementation and usage pattern.

> +/*
> + * Returns >0: the value @namelen after cut according item boundary
> + * Returns  0: on error
> + */
> +u16 btrfs_check_namelen(struct extent_buffer *leaf, int slot,
> +			unsigned long start, u32 namelen)

This function does not match its name, it does not check, but somehow
sanitizes the input length read from the leaf. From a "check" I'd expect
some good/bad result, so it could be used in an if statement.

> +{
> +	u32 end;
> +	u64 ret = namelen;
> +
> +	end = btrfs_leaf_data(leaf) + btrfs_item_end_nr(leaf, slot);
> +
> +	if (start > end)
> +		return 0;
> +	if (start + namelen > end) {
> +		ret = end - start;
> +		if (ret > U16_MAX)

Where does this limit come from?

> +			ret = 0;
> +	}
> +	return ret;

ret is u64, function returns u16.

> +}
