Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53365 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752451AbdJFRqZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:46:25 -0400
Date: Fri, 6 Oct 2017 19:44:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, nborisov@suse.com
Subject: Re: [PATCH v3 5/5] btrfs: tree-checker: Enhance output for
 check_extent_data_item
Message-ID: <20171006174441.GZ3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170929064849.15086-1-quwenruo.btrfs@gmx.com>
 <20170929064849.15086-6-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170929064849.15086-6-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 29, 2017 at 06:48:49AM +0000, Qu Wenruo wrote:
> Output the invalid member name and its bad value, along with its
> expected value range or alignment.
> 
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> ---
>  fs/btrfs/tree-checker.c | 98 +++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 70 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index c0fd192f8140..d546c723069e 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -31,12 +31,6 @@
>  #include "disk-io.h"
>  #include "compression.h"
>  
> -#define CORRUPT(reason, eb, root, slot)					\
> -	btrfs_crit(root->fs_info,					\
> -		   "corrupt %s, %s: block=%llu, root=%llu, slot=%d",	\
> -		   btrfs_header_level(eb) == 0 ? "leaf" : "node",	\
> -		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
> -
>  /*
>   * Error message should follow the format below:
>   * corrupt <type>: <identifier>, <reason>[, <bad_value>]
> @@ -79,6 +73,47 @@ static void generic_err(const struct btrfs_root *root,
>  	va_end(args);
>  }
>  
> +/*
> + * Customized reporter for extent data item, since its key objectid and
> + * offset has its own meaning.
> + */
> +__printf(4, 5)
> +static void file_extent_err(const struct btrfs_root *root,
> +			    const struct extent_buffer *eb,
> +			    int slot, const char *fmt, ...)
> +{
> +	struct btrfs_key key;
> +	struct va_format vaf;
> +	va_list args;
> +
> +	btrfs_item_key_to_cpu(eb, &key, slot);
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	btrfs_crit(root->fs_info,
> +		"corrupt %s: root=%llu block=%llu slot=%d ino=%llu file_offset=%llu, %pV",
> +		btrfs_header_level(eb) == 0 ? "leaf" : "node",
> +		root->objectid, btrfs_header_bytenr(eb), slot,
> +		key.objectid, key.offset, &vaf);
> +	va_end(args);
> +}
> +
> +/*
> + * Return 0 if the btrfs_file_extent_##name is aligned to @align
> + * Else return 1
> + */
> +#define CHECK_FI_ALIGN(root, leaf, slot, fi, name, align)		\

	CHECK_FI_ALIGNED(root, leaf, slot, fi, name, alignment)		\

and maybe CHECK_FE_ALIGNED, so the mnemonics match 'file extent'.
CHECK_FI_ALIGNED looks like it's typo of CHECK_IF_ALIGNED.

also please add macro argument protection where appropriate (ie. not the
stringified or glued identifiers)

> +({									\
> +	if (!IS_ALIGNED(btrfs_file_extent_##name(leaf, fi), align))	\
> +		file_extent_err(root, leaf, slot,			\
> +			"invalid %s for file extent, have %llu, should be aligned to %u",\
> +			#name, btrfs_file_extent_##name(leaf, fi),	\
> +			align);						\
> +	(!IS_ALIGNED(btrfs_file_extent_##name(leaf, fi), align));	\
> +})
