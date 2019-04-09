Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9ABC282DA
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 11:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB4E920857
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 11:38:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ObAAT8SS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfDILiq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:38:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58046 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbfDILip (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Apr 2019 07:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Meh4al5aFt82Z3ezghYD3996IugezgBOZu9ESekqR4E=; b=ObAAT8SSpTtrdXeyH0SQNwElA
        Jztd0acL4D2dKvQNP42nFdoJ/7q88N9xQCE27h4WtW3DoiBtqtPDXIpJTLsfQIllId+LBniib2D/R
        dzKbwt4KBuxYKC8uTHSByzz/Laj+8ei82+KgCher6v0bSByDpoMpPaWUR7fsWbyaH2ZeK8YA1BCrx
        QI1OyTkTX/MxJLEblkVMkRMURFR+xwljiZWcpQPWo3UXMT1XrgHHMDarpNW/L8VZ7z7eQ7jLPOvSp
        9Js4iclSf+UQN+Z507nQM8aaEAZ1j9ToWcy0Uw7UuGgqXOVc7UkG4cpg3AgVRGYe2hEOaFkphZCy/
        /ppvUPFgA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hDp5N-0003l6-Ow; Tue, 09 Apr 2019 11:38:41 +0000
Date:   Tue, 9 Apr 2019 04:38:41 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH] block: don't use for-inside-for in
 bio_for_each_segment_all
Message-ID: <20190409113841.GZ22763@bombadil.infradead.org>
References: <20190406215428.3131-1-ming.lei@redhat.com>
 <20190407065205.GA8799@lst.de>
 <f0c82caf-24f3-dba7-0bf0-85dd0e056e73@suse.de>
 <20190408141203.GT22763@bombadil.infradead.org>
 <20190409094839.GA6827@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409094839.GA6827@lst.de>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 09, 2019 at 11:48:39AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 08, 2019 at 07:12:04AM -0700, Matthew Wilcox wrote:
> > On Mon, Apr 08, 2019 at 08:07:55AM +0200, Hannes Reinecke wrote:
> > > Oh yes, please do.
> > > The macros are fast becoming unparseable :-)
> > 
> > I think something that would help is removing the mandatory 'i' parameter
> > to this iterator.  Most of the users don't use it, and the ones that do
> > can implement it themselves.  eg:
> 
> Yeah, I quickly hacked this up during a meeting yesterday and we have
> exactly two users of the iterator.  Patch against the for-linus tree

three in the below patch ...

> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 64def336f053..aa793fef52eb 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -429,14 +429,16 @@ static void do_btree_node_write(struct btree *b)
>  		       bset_sector_offset(&b->keys, i));
>  
>  	if (!bch_bio_alloc_pages(b->bio, __GFP_NOWARN|GFP_NOWAIT)) {
> -		int j;
> +		int j = 0;
>  		struct bio_vec *bv;
>  		void *base = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
>  		struct bvec_iter_all iter_all;
>  
> -		bio_for_each_segment_all(bv, b->bio, j, iter_all)
> +		bio_for_each_segment_all(bv, b->bio, iter_all) {
>  			memcpy(page_address(bv->bv_page),
>  			       base + j * PAGE_SIZE, PAGE_SIZE);
> +			j++;
> +		}

I think this one works better to replace 'base' with 'addr':

@@ -429,14 +429,14 @@ static void do_btree_node_write(struct btree *b)
                       bset_sector_offset(&b->keys, i));
 
        if (!bch_bio_alloc_pages(b->bio, __GFP_NOWARN|GFP_NOWAIT)) {
-               int j;
                struct bio_vec *bv;
-               void *base = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
+               void *addr = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
                struct bvec_iter_all iter_all;
 
-               bio_for_each_segment_all(bv, b->bio, j, iter_all)
-                       memcpy(page_address(bv->bv_page),
-                              base + j * PAGE_SIZE, PAGE_SIZE);
+               bio_for_each_segment_all(bv, b->bio, iter_all) {
+                       memcpy(page_address(bv->bv_page), addr, PAGE_SIZE);
+                       addr += PAGE_SIZE;
+               }
 
                bch_submit_bbio(b->bio, b->c, &k.key, 0);
 
> +++ b/drivers/md/raid1.c
> @@ -2110,7 +2110,7 @@ static void process_checks(struct r1bio *r1_bio)
>  		}
>  	r1_bio->read_disk = primary;
>  	for (i = 0; i < conf->raid_disks * 2; i++) {
> -		int j;
> +		int j = 0;
>  		struct bio *pbio = r1_bio->bios[primary];
>  		struct bio *sbio = r1_bio->bios[i];
>  		blk_status_t status = sbio->bi_status;
> @@ -2125,8 +2125,8 @@ static void process_checks(struct r1bio *r1_bio)
>  		/* Now we can 'fixup' the error value */
>  		sbio->bi_status = 0;
>  
> -		bio_for_each_segment_all(bi, sbio, j, iter_all)
> -			page_len[j] = bi->bv_len;
> +		bio_for_each_segment_all(bi, sbio, iter_all)
> +			page_len[j++] = bi->bv_len;

Yes.

> +++ b/fs/btrfs/inode.c
> @@ -7919,7 +7918,7 @@ static void btrfs_retry_endio(struct bio *bio)
>  	struct bio_vec *bvec;
>  	int uptodate;
>  	int ret;
> -	int i;
> +	int i = 0;
>  	struct bvec_iter_all iter_all;
>  
>  	if (bio->bi_status)
> @@ -7934,7 +7933,7 @@ static void btrfs_retry_endio(struct bio *bio)
>  	failure_tree = &BTRFS_I(inode)->io_failure_tree;
>  
>  	ASSERT(!bio_flagged(bio, BIO_CLONED));
> -	bio_for_each_segment_all(bvec, bio, i, iter_all) {
> +	bio_for_each_segment_all(bvec, bio, iter_all) {
>  		ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
>  					     bvec->bv_offset, done->start,
>  					     bvec->bv_len);
> @@ -7946,6 +7945,7 @@ static void btrfs_retry_endio(struct bio *bio)
>  					 bvec->bv_offset);
>  		else
>  			uptodate = 0;
> +		i++;
>  	}

I'd be tempted to instead:

@@ -7935,7 +7935,7 @@ static void btrfs_retry_endio(struct bio *bio)
 
        ASSERT(!bio_flagged(bio, BIO_CLONED));
        bio_for_each_segment_all(bvec, bio, i, iter_all) {
-               ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
+               ret = __readpage_endio_check(inode, io_bio, i++, bvec->bv_page,
                                             bvec->bv_offset, done->start,
                                             bvec->bv_len);
                if (!ret)

(i is used nowhere else in this loop, and it's a mercifully short loop with
no breaks or continues).

Thanks for turning this musing into a patch.
