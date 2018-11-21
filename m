Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9EAC43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 15:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49CC6214DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 15:32:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49CC6214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbeKVCHH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 21:07:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731011AbeKVCHG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 21:07:06 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC949308214B;
        Wed, 21 Nov 2018 15:32:08 +0000 (UTC)
Received: from ming.t460p (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E1D35F7D9;
        Wed, 21 Nov 2018 15:31:40 +0000 (UTC)
Date:   Wed, 21 Nov 2018 23:31:36 +0800
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
Subject: Re: [PATCH V11 03/19] block: introduce bio_for_each_bvec()
Message-ID: <20181121153135.GB19111@ming.t460p>
References: <20181121032327.8434-1-ming.lei@redhat.com>
 <20181121032327.8434-4-ming.lei@redhat.com>
 <20181121133244.GB1640@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121133244.GB1640@lst.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 21 Nov 2018 15:32:09 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 02:32:44PM +0100, Christoph Hellwig wrote:
> > +#define bio_iter_mp_iovec(bio, iter)				\
> > +	segment_iter_bvec((bio)->bi_io_vec, (iter))
> 
> Besides the mp naming we'd like to get rid off there also is just
> a single user of this macro, please just expand it there.

OK.

> 
> > +#define segment_iter_bvec(bvec, iter)				\
> > +((struct bio_vec) {							\
> > +	.bv_page	= segment_iter_page((bvec), (iter)),	\
> > +	.bv_len		= segment_iter_len((bvec), (iter)),	\
> > +	.bv_offset	= segment_iter_offset((bvec), (iter)),	\
> > +})
> 
> And for this one please keep the segment vs bvec versions of these
> macros close together in the file please, right now it follow the
> bvec_iter_bvec variant closely.

OK.

> 
> > +static inline void __bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
> > +				      unsigned bytes, unsigned max_seg_len)
> >  {
> >  	iter->bi_sector += bytes >> 9;
> >  
> >  	if (bio_no_advance_iter(bio))
> >  		iter->bi_size -= bytes;
> >  	else
> > -		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
> > +		__bvec_iter_advance(bio->bi_io_vec, iter, bytes, max_seg_len);
> >  		/* TODO: It is reasonable to complete bio with error here. */
> >  }
> >  
> > +static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
> > +				    unsigned bytes)
> > +{
> > +	__bio_advance_iter(bio, iter, bytes, PAGE_SIZE);
> > +}
> 
> Btw, I think the remaining users of bio_advance_iter() in bio.h
> should probably switch to using __bio_advance_iter to make them a little
> more clear to read.

Good point.

> 
> > +/* returns one real segment(multi-page bvec) each time */
> 
> space before the brace, please.

OK.

> 
> > +#define BVEC_MAX_LEN  ((unsigned int)-1)
> 
> >  	while (bytes) {
> > +		unsigned segment_len = segment_iter_len(bv, *iter);
> >  
> > -		iter->bi_bvec_done += len;
> > +		if (max_seg_len < BVEC_MAX_LEN)
> > +			segment_len = min_t(unsigned, segment_len,
> > +					    max_seg_len -
> > +					    bvec_iter_offset(bv, *iter));
> > +
> > +		segment_len = min(bytes, segment_len);
> 
> Please stick to passing the magic zero here as can often generate more
> efficient code.

But zero may decrease the code readability. Actually the passed
'max_seg_len' is just a constant, and complier should have generated
same efficient code for any constant, either 0 or other.

> 
> Talking about efficent code - I wonder how much code size we'd save
> by moving this function out of line..

That is good point, see the following diff:

[mingl@hp kernel]$ diff -u inline.size non_inline.size
--- inline.size	2018-11-21 23:24:52.305312076 +0800
+++ non_inline.size	2018-11-21 23:24:59.908393010 +0800
@@ -1,2 +1,2 @@
    text	   data	    bss	    dec	    hex	filename
-13429213	6893922	4292692	24615827	1779b93	vmlinux.inline
+13429153	6893346	4292692	24615191	1779917	vmlinux.non_inline

vmlinux(non_inline) is built by just moving/exporting __bvec_iter_advance()
into block/bio.c.

The difference is about 276bytes.

> 
> But while looking over this I wonder why we even need the max_seg_len
> here.  The only thing __bvec_iter_advance does it to move bi_bvec_done
> and bi_idx forward, with corresponding decrements of bi_size.  As far
> as I can tell the only thing that max_seg_len does is that we need
> to more iterations of the while loop to archive the same thing.
> 
> And actual bvec used by the caller will be obtained using
> bvec_iter_bvec or segment_iter_bvec depending on if they want multi-page
> or single-page variants.

Right, we let __bvec_iter_advance() serve for both multi-page and single-page
case, then we have to tell it via one way or another, now we use the constant
of 'max_seg_len'.

Or you suggest to implement two versions of __bvec_iter_advance()?

Thanks,
Ming
