Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6385CC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3484E20871
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:18:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3484E20871
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbeKSTlT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 14:41:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbeKSTlT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 14:41:19 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 62C003DE0C;
        Mon, 19 Nov 2018 09:18:17 +0000 (UTC)
Received: from ming.t460p (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D559D600C7;
        Mon, 19 Nov 2018 09:17:51 +0000 (UTC)
Date:   Mon, 19 Nov 2018 17:17:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Omar Sandoval <osandov@osandov.com>
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
        Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V10 18/19] block: kill QUEUE_FLAG_NO_SG_MERGE
Message-ID: <20181119091746.GO16736@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-19-ming.lei@redhat.com>
 <20181116021811.GM23828@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116021811.GM23828@vader>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 19 Nov 2018 09:18:18 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 06:18:11PM -0800, Omar Sandoval wrote:
> On Thu, Nov 15, 2018 at 04:53:05PM +0800, Ming Lei wrote:
> > Since bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting"),
> > physical segment number is mainly figured out in blk_queue_split() for
> > fast path, and the flag of BIO_SEG_VALID is set there too.
> > 
> > Now only blk_recount_segments() and blk_recalc_rq_segments() use this
> > flag.
> > 
> > Basically blk_recount_segments() is bypassed in fast path given BIO_SEG_VALID
> > is set in blk_queue_split().
> > 
> > For another user of blk_recalc_rq_segments():
> > 
> > - run in partial completion branch of blk_update_request, which is an unusual case
> > 
> > - run in blk_cloned_rq_check_limits(), still not a big problem if the flag is killed
> > since dm-rq is the only user.
> > 
> > Multi-page bvec is enabled now, QUEUE_FLAG_NO_SG_MERGE doesn't make sense any more.
> 
> This commit message wasn't very clear. Is it the case that
> QUEUE_FLAG_NO_SG_MERGE is no longer set by any drivers?

OK, I will add the explanation to commit log in next version.

05f1dd53152173 (block: add queue flag for disabling SG merging) introduces this
flag for NVMe performance purpose only, so that merging to segment can
be bypassed for NVMe.

Actually this optimization was bypassed by 54efd50bfd873e2d (block: make
generic_make_request handle arbitrarily sized bios) and bdced438acd83ad83a6c
("block: setup bi_phys_segments after splitting").

Now segment computation can be very quick, given most of times one bvec
can be thought as one segment, so we can remove the flag.

thanks, 
Ming
