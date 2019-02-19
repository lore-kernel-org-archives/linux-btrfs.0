Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD68EC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 09:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB1B921738
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 09:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfBSJbO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 04:31:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:43680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725763AbfBSJbO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 04:31:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DF8FCAF49
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2019 09:31:10 +0000 (UTC)
Subject: Re: [PATCH] btrfs: factor our read/write stage off csum_tree_block()
 into its callers
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20190219090202.9715-1-jthumshirn@suse.de>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <da7e4116-7933-956f-44b5-dae0c3f6bcd5@suse.com>
Date:   Tue, 19 Feb 2019 11:31:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190219090202.9715-1-jthumshirn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 19.02.19 г. 11:02 ч., Johannes Thumshirn wrote:
> Currently csum_tree_block() does two things, first it as it's name
> suggests it calculates the checksum for a tree-block. But it also writes
> this checksum to disk or reads an extent_buffer from disk and compares the
> checksum with the calculated checksum, depending on the verify argument.
> 
> Furthermore one of the two callers passes in '1' for the verify argument,
> the other one passes in '0'.
> 
> For clarity and less layering violations, factor out the second stage in
> csum_tree_block()'s callers.
> 
> Suggested-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>, albeit see my remarks
below.

> ---
>  fs/btrfs/disk-io.c | 51 +++++++++++++++++++++++++++------------------------
>  1 file changed, 27 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5216e7b3f9ad..5330123b0fe3 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -263,12 +263,9 @@ void btrfs_csum_final(u32 crc, u8 *result)
>   * compute the csum for a btree block, and either verify it or write it
>   * into the csum field of the block.
>   */
> -static int csum_tree_block(struct btrfs_fs_info *fs_info,
> -			   struct extent_buffer *buf,
> -			   int verify)
> +static int csum_tree_block(struct extent_buffer *buf,
> +			   u8 *result)
>  {
> -	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
> -	char result[BTRFS_CSUM_SIZE];
>  	unsigned long len;
>  	unsigned long cur_len;
>  	unsigned long offset = BTRFS_CSUM_SIZE;
> @@ -300,23 +297,6 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
>  
>  	btrfs_csum_final(crc, result);
>  
> -	if (verify) {
> -		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
> -			u32 val;
> -			u32 found = 0;
> -			memcpy(&found, result, csum_size);
> -
> -			read_extent_buffer(buf, &val, 0, csum_size);
> -			btrfs_warn_rl(fs_info,
> -				"%s checksum verify failed on %llu wanted %X found %X level %d",
> -				fs_info->sb->s_id, buf->start,
> -				val, found, btrfs_header_level(buf));
> -			return -EUCLEAN;
> -		}
> -	} else {
> -		write_extent_buffer(buf, result, 0, csum_size);
> -	}
> -
>  	return 0;
>  }
>  
> @@ -533,6 +513,8 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>  {
>  	u64 start = page_offset(page);
>  	u64 found_start;
> +	u8 result[BTRFS_CSUM_SIZE];
> +	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
>  	struct extent_buffer *eb;
>  
>  	eb = (struct extent_buffer *)page->private;
> @@ -552,7 +534,11 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>  	ASSERT(memcmp_extent_buffer(eb, fs_info->fs_devices->metadata_uuid,
>  			btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
>  
> -	return csum_tree_block(fs_info, eb, 0);
> +	if (WARN_ON(csum_tree_block(eb, result)))
> +		return -EUCLEAN;

I meant to discuss this with you yesterday but  the WARN_ON here could
trigger only if map_private_extent_buffer fails. And that could be only
due to two things:

1. If we want to map more than the buffer's length

2. If the item spans two pages.

Initially I wondered whether WARN_ON is really appropriate but the more
I think about it the more I'm inclined to say yes. However, I wonder if
EUCLEAN is the correct error code and shouldn't it be, perhaps, -EINVAL
 (as returned from map_private_extent_buffer), that fits both with the
return code in case of invalid mapping length as well as item spanning
multiple pages. What are your thoughts?

> +
> +	write_extent_buffer(eb, result, 0, csum_size);
> +	return 0;
>  }
>  
>  static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
> @@ -595,7 +581,9 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  	struct extent_buffer *eb;
>  	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
>  	struct btrfs_fs_info *fs_info = root->fs_info;
> +	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
>  	int ret = 0;
> +	char result[BTRFS_CSUM_SIZE];
>  	int reads_done;
>  
>  	if (!page->private)
> @@ -642,10 +630,25 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb),
>  				       eb, found_level);
>  
> -	ret = csum_tree_block(fs_info, eb, 1);
> +	ret = csum_tree_block(eb, result);
>  	if (ret)
>  		goto err;
>  
> +	if (memcmp_extent_buffer(eb, result, 0, csum_size)) {
> +		u32 val;
> +		u32 found = 0;
> +
> +		memcpy(&found, result, csum_size);
> +
> +		read_extent_buffer(eb, &val, 0, csum_size);
> +		btrfs_warn_rl(fs_info,
> +			      "%s checksum verify failed on %llu wanted %x found %x level %d",
> +			      fs_info->sb->s_id, eb->start,
> +			      val, found, btrfs_header_level(eb));
> +		ret = -EUCLEAN;
> +		goto err;
> +	}
> +
>  	/*
>  	 * If this is a leaf block and it is corrupt, set the corrupt bit so
>  	 * that we don't try and read the other copies of this block, just
> 
