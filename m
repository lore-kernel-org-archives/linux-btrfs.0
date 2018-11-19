Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9689CC43610
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 673B720823
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:00:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 673B720823
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbeKSTXu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 14:23:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbeKSTXu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 14:23:50 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5008A30832D0;
        Mon, 19 Nov 2018 09:00:50 +0000 (UTC)
Received: from ming.t460p (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7722A5C223;
        Mon, 19 Nov 2018 09:00:26 +0000 (UTC)
Date:   Mon, 19 Nov 2018 17:00:22 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V10 14/19] block: enable multipage bvecs
Message-ID: <20181119090021.GL16736@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-15-ming.lei@redhat.com>
 <20181116135308.GK3165@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116135308.GK3165@lst.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 19 Nov 2018 09:00:50 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 16, 2018 at 02:53:08PM +0100, Christoph Hellwig wrote:
> > -
> > -		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
> > -			bv->bv_len += len;
> > -			bio->bi_iter.bi_size += len;
> > -			return true;
> > -		}
> > +		struct request_queue *q = NULL;
> > +
> > +		if (page == bv->bv_page && off == (bv->bv_offset + bv->bv_len)
> > +				&& (off + len) <= PAGE_SIZE)
> 
> How could the page struct be the same, but the range beyond PAGE_SIZE
> (at least with the existing callers)?
> 
> Also no need for the inner btraces, and the && always goes on the
> first line.

OK.

> 
> > +		if (bio->bi_disk)
> > +			q = bio->bi_disk->queue;
> > +
> > +		/* disable multi-page bvec too if cluster isn't enabled */
> > +		if (!q || !blk_queue_cluster(q) ||
> > +		    ((page_to_phys(bv->bv_page) + bv->bv_offset + bv->bv_len) !=
> > +		     (page_to_phys(page) + off)))
> > +			return false;
> > + merge:
> > +		bv->bv_len += len;
> > +		bio->bi_iter.bi_size += len;
> > +		return true;
> 
> Ok, this is scary, as it will give differen results depending on when
> bi_disk is assigned.

It is just merge or not, both can be handled well now.

> But then again we shouldn't really do the cluster
> check here, but rather when splitting the bio for the actual low-level
> driver.

Yeah, I thought of this way too, but it may cause tons of bio split for
no-clustering, and there are quite a few scsi devices which require
to disable clustering.

[linux]$ git grep -n DISABLE_CLUSTERING ./drivers/scsi/ | wc -l
     28

Or we may introduce bio_split_to_single_page_bvec() to allocate &
convert to single-page bvec table for non-clustering, will try this
approach in next version.

> 
> (and eventually we should kill this clustering setting off in favor
> of our normal segment limits).

Yeah, it has been in my post-multi-page todo list already, :-)

thanks,
Ming
