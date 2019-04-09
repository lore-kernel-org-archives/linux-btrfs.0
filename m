Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30C9C282DA
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 15:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E5BF20830
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 15:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfDIPfe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 11:35:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:52716 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726515AbfDIPfe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Apr 2019 11:35:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1C7ABACC1;
        Tue,  9 Apr 2019 15:35:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2679FDA88B; Tue,  9 Apr 2019 17:36:40 +0200 (CEST)
Date:   Tue, 9 Apr 2019 17:36:39 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH] block: don't use for-inside-for in
 bio_for_each_segment_all
Message-ID: <20190409153639.GL29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
References: <20190406215428.3131-1-ming.lei@redhat.com>
 <20190407065205.GA8799@lst.de>
 <f0c82caf-24f3-dba7-0bf0-85dd0e056e73@suse.de>
 <20190408141203.GT22763@bombadil.infradead.org>
 <20190409094839.GA6827@lst.de>
 <20190409113841.GZ22763@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409113841.GZ22763@bombadil.infradead.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 09, 2019 at 04:38:41AM -0700, Matthew Wilcox wrote:
> > +++ b/fs/btrfs/inode.c
> > @@ -7919,7 +7918,7 @@ static void btrfs_retry_endio(struct bio *bio)
> >  	struct bio_vec *bvec;
> >  	int uptodate;
> >  	int ret;
> > -	int i;
> > +	int i = 0;
> >  	struct bvec_iter_all iter_all;
> >  
> >  	if (bio->bi_status)
> > @@ -7934,7 +7933,7 @@ static void btrfs_retry_endio(struct bio *bio)
> >  	failure_tree = &BTRFS_I(inode)->io_failure_tree;
> >  
> >  	ASSERT(!bio_flagged(bio, BIO_CLONED));
> > -	bio_for_each_segment_all(bvec, bio, i, iter_all) {
> > +	bio_for_each_segment_all(bvec, bio, iter_all) {
> >  		ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
> >  					     bvec->bv_offset, done->start,
> >  					     bvec->bv_len);
> > @@ -7946,6 +7945,7 @@ static void btrfs_retry_endio(struct bio *bio)
> >  					 bvec->bv_offset);
> >  		else
> >  			uptodate = 0;
> > +		i++;
> >  	}
> 
> I'd be tempted to instead:
> 
> @@ -7935,7 +7935,7 @@ static void btrfs_retry_endio(struct bio *bio)
>  
>         ASSERT(!bio_flagged(bio, BIO_CLONED));
>         bio_for_each_segment_all(bvec, bio, i, iter_all) {
> -               ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
> +               ret = __readpage_endio_check(inode, io_bio, i++, bvec->bv_page,
>                                              bvec->bv_offset, done->start,
>                                              bvec->bv_len);
>                 if (!ret)
> 
> (i is used nowhere else in this loop, and it's a mercifully short loop with
> no breaks or continues).

I'd rather keep the separate statement than having parameters with
sideefects.
