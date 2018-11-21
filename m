Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C823FC43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 00:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C87520671
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 00:59:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C87520671
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbeKULbj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 06:31:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbeKULbi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 06:31:38 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8642981DEC;
        Wed, 21 Nov 2018 00:59:36 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C1396A51B;
        Wed, 21 Nov 2018 00:59:09 +0000 (UTC)
Date:   Wed, 21 Nov 2018 08:59:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>,
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
Subject: Re: [PATCH V10 09/19] block: introduce bio_bvecs()
Message-ID: <20181121005902.GA31748@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-10-ming.lei@redhat.com>
 <20181116134541.GH3165@lst.de>
 <002fe56b-25e4-573e-c09b-bb12c3e8d25a@grimberg.me>
 <20181120161651.GB2629@lst.de>
 <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53526aae-fb9b-ee38-0a01-e5899e2d4e4d@grimberg.me>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 21 Nov 2018 00:59:37 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 20, 2018 at 12:11:35PM -0800, Sagi Grimberg wrote:
> 
> > > > The only user in your final tree seems to be the loop driver, and
> > > > even that one only uses the helper for read/write bios.
> > > > 
> > > > I think something like this would be much simpler in the end:
> > > 
> > > The recently submitted nvme-tcp host driver should also be a user
> > > of this. Does it make sense to keep it as a helper then?
> > 
> > I did take a brief look at the code, and I really don't understand
> > why the heck it even deals with bios to start with.  Like all the
> > other nvme transports it is a blk-mq driver and should iterate
> > over segments in a request and more or less ignore bios.  Something
> > is horribly wrong in the design.
> 
> Can you explain a little more? I'm more than happy to change that but
> I'm not completely clear how...
> 
> Before we begin a data transfer, we need to set our own iterator that
> will advance with the progression of the data transfer. We also need to
> keep in mind that all the data transfer (both send and recv) are
> completely non blocking (and zero-copy when we send).
> 
> That means that every data movement needs to be able to suspend
> and resume asynchronously. i.e. we cannot use the following pattern:
> rq_for_each_segment(bvec, rq, rq_iter) {
> 	iov_iter_bvec(&iov_iter, WRITE, &bvec, 1, bvec.bv_len);
> 	send(sock, iov_iter);
> }

Not sure I understand the 'blocking' problem in this case.

We can build a bvec table from this req, and send them all
in send(), can this way avoid your blocking issue? You may see this
example in branch 'rq->bio != rq->biotail' of lo_rw_aio().

If this way is what you need, I think you are right, even we may
introduce the following helpers:

	rq_for_each_bvec()
	rq_bvecs()

So looks nvme-tcp host driver might be the 2nd driver which benefits
from multi-page bvec directly.

The multi-page bvec V11 has passed my tests and addressed almost
all the comments during review on V10. I removed bio_vecs() in V11,
but it won't be big deal, we can introduce them anytime when there
is the requirement.

Thanks,
Ming
