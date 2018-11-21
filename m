Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE96C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 15:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 403D121479
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 15:38:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 403D121479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731395AbeKVCMv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 21:12:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbeKVCMv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 21:12:51 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 87EDC3084297;
        Wed, 21 Nov 2018 15:37:54 +0000 (UTC)
Received: from ming.t460p (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 49A825C21E;
        Wed, 21 Nov 2018 15:37:31 +0000 (UTC)
Date:   Wed, 21 Nov 2018 23:37:27 +0800
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
Subject: Re: [PATCH V11 14/19] block: handle non-cluster bio out of
 blk_bio_segment_split
Message-ID: <20181121153726.GC19111@ming.t460p>
References: <20181121032327.8434-1-ming.lei@redhat.com>
 <20181121032327.8434-15-ming.lei@redhat.com>
 <20181121143355.GB2594@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121143355.GB2594@lst.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 21 Nov 2018 15:37:55 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 03:33:55PM +0100, Christoph Hellwig wrote:
> > +			non-cluster.o
> 
> Do we really need a new source file for these few functions?
> 
> >  	default:
> > +		if (!blk_queue_cluster(q)) {
> > +			blk_queue_non_cluster_bio(q, bio);
> > +			return;
> 
> I'd name this blk_bio_segment_split_singlepage or similar.

OK.

> 
> > +static __init int init_non_cluster_bioset(void)
> > +{
> > +	WARN_ON(bioset_init(&non_cluster_bio_set, BIO_POOL_SIZE, 0,
> > +			   BIOSET_NEED_BVECS));
> > +	WARN_ON(bioset_integrity_create(&non_cluster_bio_set, BIO_POOL_SIZE));
> > +	WARN_ON(bioset_init(&non_cluster_bio_split, BIO_POOL_SIZE, 0, 0));
> 
> Please only allocate the resources once a queue without the cluster
> flag is registered, there are only very few modern drivers that do that.

OK.

> 
> > +static void non_cluster_end_io(struct bio *bio)
> > +{
> > +	struct bio *bio_orig = bio->bi_private;
> > +
> > +	bio_orig->bi_status = bio->bi_status;
> > +	bio_endio(bio_orig);
> > +	bio_put(bio);
> > +}
> 
> Why can't we use bio_chain for the split bios?

The parent bio is multi-page bvec, we can't submit it for non-cluster.

> 
> > +	bio_for_each_segment(from, *bio_orig, iter) {
> > +		if (i++ < max_segs)
> > +			sectors += from.bv_len >> 9;
> > +		else
> > +			break;
> > +	}
> 
> The easy to read way would be:
> 
> 	bio_for_each_segment(from, *bio_orig, iter) {
> 		if (i++ == max_segs)
> 			break;
> 		sectors += from.bv_len >> 9;
> 	}

OK.

> 
> > +	if (sectors < bio_sectors(*bio_orig)) {
> > +		bio = bio_split(*bio_orig, sectors, GFP_NOIO,
> > +				&non_cluster_bio_split);
> > +		bio_chain(bio, *bio_orig);
> > +		generic_make_request(*bio_orig);
> > +		*bio_orig = bio;
> 
> I don't think this is very efficient, as this means we now
> clone the bio twice, first to split it at the sector boundary,
> and then again when converting it to single-page bio_vec.

That is exactly what bounce code does. The problem for both bounce
and non-cluster is same actually because the bvec table itself has
to be changed.

> 
> I think this could be something like this (totally untested):
> 
> diff --git a/block/non-cluster.c b/block/non-cluster.c
> index 9c2910be9404..60389f275c43 100644
> --- a/block/non-cluster.c
> +++ b/block/non-cluster.c
> @@ -13,58 +13,59 @@
>  
>  #include "blk.h"
>  
> -static struct bio_set non_cluster_bio_set, non_cluster_bio_split;
> +static struct bio_set non_cluster_bio_set;
>  
>  static __init int init_non_cluster_bioset(void)
>  {
>  	WARN_ON(bioset_init(&non_cluster_bio_set, BIO_POOL_SIZE, 0,
>  			   BIOSET_NEED_BVECS));
>  	WARN_ON(bioset_integrity_create(&non_cluster_bio_set, BIO_POOL_SIZE));
> -	WARN_ON(bioset_init(&non_cluster_bio_split, BIO_POOL_SIZE, 0, 0));
>  
>  	return 0;
>  }
>  __initcall(init_non_cluster_bioset);
>  
> -static void non_cluster_end_io(struct bio *bio)
> -{
> -	struct bio *bio_orig = bio->bi_private;
> -
> -	bio_orig->bi_status = bio->bi_status;
> -	bio_endio(bio_orig);
> -	bio_put(bio);
> -}
> -
>  void blk_queue_non_cluster_bio(struct request_queue *q, struct bio **bio_orig)
>  {
> -	struct bio *bio;
>  	struct bvec_iter iter;
> -	struct bio_vec from;
> -	unsigned i = 0;
> -	unsigned sectors = 0;
> -	unsigned short max_segs = min_t(unsigned short, BIO_MAX_PAGES,
> -					queue_max_segments(q));
> +	struct bio *bio;
> +	struct bio_vec bv;
> +	unsigned short max_segs, segs = 0;
> +
> +	bio = bio_alloc_bioset(GFP_NOIO, bio_segments(*bio_orig),
> +			&non_cluster_bio_set);

bio_segments(*bio_orig) may be > 256, so bio_alloc_bioset() may fail.

Thanks,
Ming
