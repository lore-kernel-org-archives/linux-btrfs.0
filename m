Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F71C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 15:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF0521582
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 15:49:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CF0521582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731491AbeKVCYJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 21:24:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbeKVCYI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 21:24:08 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CFDBCC0BF2A2;
        Wed, 21 Nov 2018 15:49:09 +0000 (UTC)
Received: from ming.t460p (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 67EC360BF6;
        Wed, 21 Nov 2018 15:48:18 +0000 (UTC)
Date:   Wed, 21 Nov 2018 23:48:13 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V11 15/19] block: enable multipage bvecs
Message-ID: <20181121154812.GD19111@ming.t460p>
References: <20181121032327.8434-1-ming.lei@redhat.com>
 <20181121032327.8434-16-ming.lei@redhat.com>
 <20181121145502.GA3241@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121145502.GA3241@lst.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 21 Nov 2018 15:49:10 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 03:55:02PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 21, 2018 at 11:23:23AM +0800, Ming Lei wrote:
> >  	if (bio->bi_vcnt > 0) {
> > -		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
> > +		struct bio_vec bv;
> > +		struct bio_vec *seg = &bio->bi_io_vec[bio->bi_vcnt - 1];
> >  
> > -		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
> > -			bv->bv_len += len;
> > +		bvec_last_segment(seg, &bv);
> > +
> > +		if (page == bv.bv_page && off == bv.bv_offset + bv.bv_len) {
> 
> I think this we can simplify the try to merge into bio case a bit,
> and also document it better with something like this:
> 
> diff --git a/block/bio.c b/block/bio.c
> index 854676edc438..cc913281a723 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -822,54 +822,40 @@ EXPORT_SYMBOL(bio_add_pc_page);
>   * @page: page to add
>   * @len: length of the data to add
>   * @off: offset of the data in @page
> + * @same_page: if %true only merge if the new data is in the same physical
> + *		page as the last segment of the bio.
>   *
> - * Try to add the data at @page + @off to the last page of @bio.  This is a
> + * Try to add the data at @page + @off to the last bvec of @bio.  This is a
>   * a useful optimisation for file systems with a block size smaller than the
>   * page size.
>   *
>   * Return %true on success or %false on failure.
>   */
>  bool __bio_try_merge_page(struct bio *bio, struct page *page,
> -		unsigned int len, unsigned int off)
> +		unsigned int len, unsigned int off, bool same_page)
>  {
>  	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>  		return false;
>  
>  	if (bio->bi_vcnt > 0) {
> -		struct bio_vec bv;
> -		struct bio_vec *seg = &bio->bi_io_vec[bio->bi_vcnt - 1];
> -
> -		bvec_last_segment(seg, &bv);
> -
> -		if (page == bv.bv_page && off == bv.bv_offset + bv.bv_len) {
> -			seg->bv_len += len;
> -			bio->bi_iter.bi_size += len;
> -			return true;
> -		}
> +		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
> +		phys_addr_t vec_addr = page_to_phys(bv->bv_page);
> +		phys_addr_t page_addr = page_to_phys(page);
> +
> +		if (vec_addr + bv->bv_offset + bv->bv_len != page_addr + off)
> +			return false;
> +		if (same_page &&
> +		    (vec_addr & PAGE_SIZE) != (page_addr & PAGE_SIZE))
> +			return false;

I guess the correct check should be:

		end_addr = vec_addr + bv->bv_offset + bv->bv_len;
		if (same_page &&
		    (end_addr & PAGE_MASK) != (page_addr & PAGE_MASK))
			return false;

And this approach is good, will take it in V12.

Thanks,
Ming
