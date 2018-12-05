Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AAFC04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 248212084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:56:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 248212084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbeLEN4w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 08:56:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:40976 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727142AbeLEN4v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 08:56:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9F24AAC52
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 13:56:48 +0000 (UTC)
Subject: Re: [PATCH 06/10] btrfs: dax write support
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
 <20181205122835.19290-7-rgoldwyn@suse.de>
From:   Johannes Thumshirn <jthumshirn@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=jthumshirn@suse.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <e63df643-adf7-5cd0-e3dc-8b1ceade7f96@suse.de>
Date:   Wed, 5 Dec 2018 14:56:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181205122835.19290-7-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 05/12/2018 13:28, Goldwyn Rodrigues wrote:
[...]

> +static int copy_extent_page(struct extent_map *em, void *daddr, u64 pos)
> +{
> +        struct dax_device *dax_dev;

^ space instead of tabs?

> +	void *saddr;
> +	sector_t start;
> +	size_t len;
> +
> +	if (em->block_start == EXTENT_MAP_HOLE) {
> +		memset(daddr, 0, PAGE_SIZE);
> +	} else {
> +		dax_dev = fs_dax_get_by_bdev(em->bdev);
> +		start = (get_start_sect(em->bdev) << 9) + (em->block_start + (pos - em->start));
> +		len = dax_direct_access(dax_dev, PHYS_PFN(start), 1, &saddr, NULL);
> +		memcpy(daddr, saddr, PAGE_SIZE);
> +	}
> +	free_extent_map(em);
> +
> +	return 0;
> +}
> +
> +

copy_extent_page() always returns 0, why not make it void?
Plus a nit: double newline.

> +ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
> +{
> +	ssize_t ret, done = 0, count = iov_iter_count(from);
> +        struct inode *inode = file_inode(iocb->ki_filp);
^ again spaces vs tabs.

> +	u64 pos = iocb->ki_pos;
> +	u64 start = round_down(pos, PAGE_SIZE);
> +	u64 end = round_up(pos + count, PAGE_SIZE);
> +	struct extent_state *cached_state = NULL;
> +	struct extent_changeset *data_reserved = NULL;
> +	struct extent_map *first = NULL, *last = NULL;
> +
> +	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, start, end - start);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Grab a reference of the first extent to copy data */
> +	if (start < pos) {
> +		first = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, end - start, 0);
> +		if (IS_ERR(first)) {
> +			ret = PTR_ERR(first);
> +			goto out2;
> +		}
> +	}

You're using 'end - start' at least twice here, maybe you could move
'len' out of the loop and use it for btrfs_delalloc_reserve_space() and
btrfs_get_extent() as well.

> +
> +	/* Grab a reference of the last extent to copy data */
> +	if (pos + count < end) {
> +		last = btrfs_get_extent(BTRFS_I(inode), NULL, 0, end - PAGE_SIZE, PAGE_SIZE, 0);
> +		if (IS_ERR(last)) {
> +			ret = PTR_ERR(last);
> +			goto out2;
> +		}
> +	}
> +
> +	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, end, &cached_state);
> +	while (done < count) {
> +		struct extent_map *em;
> +		struct dax_device *dax_dev;
> +		int offset = pos & (PAGE_SIZE - 1);
> +		u64 estart = round_down(pos, PAGE_SIZE);
> +		u64 elen = end - estart;
> +		size_t len = count - done;
> +		sector_t dstart;
> +		void *daddr;
> +		ssize_t maplen;
> +
> +		/* Read the current extent */
> +                em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, estart, elen, 0);

Space again.

> +		if (IS_ERR(em)) {
> +			ret = PTR_ERR(em);
> +			goto out;
> +		}
> +
> +		/* Get a new extent */
> +		ret = btrfs_get_extent_map_write(&em, NULL, inode, estart, elen);
> +		if (ret < 0)
> +			goto out;
> +
> +		dax_dev = fs_dax_get_by_bdev(em->bdev);
> +		/* Calculate start address start of destination extent */
> +		dstart = (get_start_sect(em->bdev) << 9) + em->block_start;
> +		maplen = dax_direct_access(dax_dev, PHYS_PFN(dstart),
> +				PHYS_PFN(em->len), &daddr, NULL);
> +
> +		/* Copy front of extent page */
> +		if (offset)
> +			ret = copy_extent_page(first, daddr, estart);
> +
> +		/* Copy end of extent page */
> +		if ((pos + len > estart + PAGE_SIZE) && (pos + len < em->start + em->len))
> +			ret = copy_extent_page(last, daddr + em->len - PAGE_SIZE, em->start + em->len - PAGE_SIZE);
> +
> +		/* Copy the data from the iter */
> +		maplen = PFN_PHYS(maplen);
> +		maplen -= offset;
> +		ret = dax_copy_from_iter(dax_dev, dstart, daddr + offset, maplen, from);
> +		if (ret < 0)
> +			goto out;
> +		pos += ret;
> +		done += ret;
> +	}
> +out:

out_unlock?

> +	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, end, &cached_state);
> +	if (done) {
> +		btrfs_update_ordered_extent(inode, start,
> +				end - start, true);
> +		iocb->ki_pos += done;
> +		if (iocb->ki_pos > i_size_read(inode))
> +			i_size_write(inode, iocb->ki_pos);
> +	}
> +
> +	btrfs_delalloc_release_extents(BTRFS_I(inode), count, false);
> +out2:

out?

> +	if (count - done > 0)
> +		btrfs_delalloc_release_space(inode, data_reserved, pos,
> +				count - done, true);
> +	extent_changeset_free(data_reserved);
> +        return done ? done : ret;
> +
> +}
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index ef6ed93f44d1..29a3b12e6660 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1964,7 +1964,9 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  	if (sync)
>  		atomic_inc(&BTRFS_I(inode)->sync_writers);
>  
> -	if (iocb->ki_flags & IOCB_DIRECT) {
> +	if (IS_DAX(inode)) {
> +		num_written = btrfs_file_dax_write(iocb, from);
> +	} else if (iocb->ki_flags & IOCB_DIRECT) {
>  		num_written = __btrfs_direct_write(iocb, from);
>  	} else {
>  		num_written = btrfs_buffered_write(iocb, from);
> 


-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
