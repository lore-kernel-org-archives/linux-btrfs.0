Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49163 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933415AbeFUQmh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 12:42:37 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F2564ACF0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2018 16:42:35 +0000 (UTC)
Date: Thu, 21 Jun 2018 18:39:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Get rid of the confusing
 btrfs_file_extent_inline_len()
Message-ID: <20180621163945.GS24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180606074149.5020-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180606074149.5020-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 06, 2018 at 03:41:49PM +0800, Qu Wenruo wrote:
> We used to call btrfs_file_extent_inline_len() to get the uncompressed
> data size of an inlined extent.
> 
> However this function is hiding evil, for compressed extent, it has no
> choice but to directly read out ram_bytes from btrfs_file_extent_item.
> While for uncompressed extent, it uses item size to calculate the real
> data size, and ignoring ram_bytes at all.
> 
> In fact, for corrupted ram_bytes, due to above behavior kernel
> btrfs_print_leaf() can't even print correct ram_bytes to expose the bug.
> 
> Since we have tree-checker to verify all EXTENT_DATA, such mismatch can
> be detected pretty easily, thus we can trust ram_bytes without the evil
> btrfs_file_extent_inline_len().

That's the critical point, the tree checker does a good job here so the
code can be simplifed.

The 'ram_bytes' is meant as an estimate how much data the compressed
extents have and I find it a bit less clear to see it used instead of
btrfs_file_extent_inline_len.

As an example:

>  	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
>  		size_t size;
> -		size = btrfs_file_extent_inline_len(leaf, slot, fi);
> +		size = btrfs_file_extent_ram_bytes(leaf, fi);

type is inline and btrfs_file_extent_inline_len looks better, but if the
'ram_bytes' is documented to store the inline size, it would save one
extra helper that would be an alias. Like:

static inline u32 btrfs_file_extent_inline_len(...) {
	return btrfs_file_extent_ram_bytes(...);
}

But maybe it's not worth. I'll apply the patch as is, we can rename it
later if it'd bother us.

Reviewed-by: David Sterba <dsterba@suse.com>
