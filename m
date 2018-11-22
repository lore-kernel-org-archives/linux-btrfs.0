Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9210C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 01:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D82420645
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 01:17:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D82420645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388792AbeKVLy0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 06:54:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38064 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732495AbeKVLy0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 06:54:26 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BEAE7792B7;
        Thu, 22 Nov 2018 01:17:30 +0000 (UTC)
Received: from ming.t460p (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8687A600D6;
        Thu, 22 Nov 2018 01:17:10 +0000 (UTC)
Date:   Thu, 22 Nov 2018 09:17:06 +0800
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
Message-ID: <20181122011705.GC20814@ming.t460p>
References: <20181121032327.8434-1-ming.lei@redhat.com>
 <20181121032327.8434-4-ming.lei@redhat.com>
 <20181121133244.GB1640@lst.de>
 <20181121153135.GB19111@ming.t460p>
 <20181121161025.GB4977@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121161025.GB4977@lst.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 22 Nov 2018 01:17:31 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 05:10:25PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 21, 2018 at 11:31:36PM +0800, Ming Lei wrote:
> > > But while looking over this I wonder why we even need the max_seg_len
> > > here.  The only thing __bvec_iter_advance does it to move bi_bvec_done
> > > and bi_idx forward, with corresponding decrements of bi_size.  As far
> > > as I can tell the only thing that max_seg_len does is that we need
> > > to more iterations of the while loop to archive the same thing.
> > > 
> > > And actual bvec used by the caller will be obtained using
> > > bvec_iter_bvec or segment_iter_bvec depending on if they want multi-page
> > > or single-page variants.
> > 
> > Right, we let __bvec_iter_advance() serve for both multi-page and single-page
> > case, then we have to tell it via one way or another, now we use the constant
> > of 'max_seg_len'.
> > 
> > Or you suggest to implement two versions of __bvec_iter_advance()?
> 
> No - I think we can always use the code without any segment in
> bvec_iter_advance.  Because bvec_iter_advance only operates on the
> iteractor, the generation of an actual single-page or multi-page
> bvec is left to the caller using the bvec_iter_bvec or segment_iter_bvec
> helpers.  The only difference is how many bytes you can move the
> iterator forward in a single loop iteration - so if you pass in
> PAGE_SIZE as the max_seg_len you just will have to loop more often
> for a large enough bytes, but not actually do anything different.

Yeah, I see that.

The difference is made by bio_iter_iovec()/bio_iter_mp_iovec() in
__bio_for_each_segment()/__bio_for_each_bvec().


Thanks,
Ming
