Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69540C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 14:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3526221479
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 14:34:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3526221479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731056AbeKVBJZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 20:09:25 -0500
Received: from verein.lst.de ([213.95.11.211]:51729 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729658AbeKVBJZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 20:09:25 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 1B88068C1D; Wed, 21 Nov 2018 15:34:44 +0100 (CET)
Date:   Wed, 21 Nov 2018 15:34:44 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
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
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V11 17/19] block: document usage of bio iterator helpers
Message-ID: <20181121143443.GC2594@lst.de>
References: <20181121032327.8434-1-ming.lei@redhat.com> <20181121032327.8434-18-ming.lei@redhat.com> <1f93e845-09e8-2c6c-3643-654b8c490597@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f93e845-09e8-2c6c-3643-654b8c490597@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 09:45:25AM +0200, Nikolay Borisov wrote:
> > +	bio_for_each_segment_all()
> > +	bio_first_bvec_all()
> > +	bio_first_page_all()
> > +	bio_last_bvec_all()
> > +
> > +* The following helpers iterate over single-page bvecs. The passed 'struct
> > +bio_vec' will contain a single-page IO vector during the iteration
> > +
> > +	bio_for_each_segment()
> > +	bio_for_each_segment_all()
> > +
> > +* The following helpers iterate over single-page bvecs. The passed 'struct
> > +bio_vec' will contain a single-page IO vector during the iteration
> > +
> > +	bio_for_each_bvec()
> 
> Just put this helper right below the above 2, no need to repeat the
> explanation. Also I'd suggest introducing another catch-all sentence
> "All other helpers are assumed to iterate multipage bio vecs" and
> perhaps give an example with 1-2 helpers.

Well, I think the second explanation is wrong - bio_for_each_bvec
iterates over the whole bvecs, not just single page.
