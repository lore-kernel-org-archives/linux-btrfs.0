Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE93C433B4
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 May 2021 20:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F13E61165
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 May 2021 20:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhEJUSG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 May 2021 16:18:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:47446 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhEJUSG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 May 2021 16:18:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 73D86B118;
        Mon, 10 May 2021 20:17:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 88A4CDB228; Mon, 10 May 2021 22:14:31 +0200 (CEST)
Date:   Mon, 10 May 2021 22:14:31 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] btrfs: remove the dead branch in
 btrfs_io_needs_validation()
Message-ID: <20210510201431.GC7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210503020856.93333-1-wqu@suse.com>
 <20210503020856.93333-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503020856.93333-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, May 03, 2021 at 10:08:53AM +0800, Qu Wenruo wrote:
>  	/*
> -	 * We need to validate each sector individually if the failed I/O was
> -	 * for multiple sectors.
> -	 *
> -	 * There are a few possible bios that can end up here:
> -	 * 1. A buffered read bio, which is not cloned.
> -	 * 2. A direct I/O read bio, which is cloned.
> -	 * 3. A (buffered or direct) repair bio, which is not cloned.
> -	 *
> -	 * For cloned bios (case 2), we can get the size from
> -	 * btrfs_io_bio->iter; for non-cloned bios (cases 1 and 3), we can get
> -	 * it from the bvecs.
> +	 * We're ensured we won't get cloned bio in end_bio_extent_readpage(),
> +	 * thus we can get the length from the bvecs.
>  	 */
> -	if (bio_flagged(bio, BIO_CLONED)) {
> -		if (btrfs_io_bio(bio)->iter.bi_size > blocksize)
> +	bio_for_each_bvec_all(bvec, bio, i) {
> +		len += bvec->bv_len;
> +		if (len > blocksize)
>  			return true;

I've looked if the bio cloning is used at all so we could potentially
get rid of all the BIO_CLONED assertions. There are still two cases:

* btrfs_submit_direct calling btrfs_bio_clone_partial
* btrfs_map_bio calling btrfs_bio_clone

So in this case I'd rather add an assertion before
bio_for_each_bvec_all, as this fits the usecase "this never happens".
The original assertions were added everywhere once the bio iteration
behaviour changed without much notice, so we need to be cautious.

Applied with the following fixup

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2616,6 +2616,7 @@ static bool btrfs_io_needs_validation(struct inode *inode, struct bio *bio)
         * We're ensured we won't get cloned bio in end_bio_extent_readpage(),
         * thus we can get the length from the bvecs.
         */
+       ASSERT(!bio_flagged(bio, BIO_CLONED));
        bio_for_each_bvec_all(bvec, bio, i) {
                len += bvec->bv_len;
                if (len > blocksize)
---
