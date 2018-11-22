Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688BDC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 10:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 345AB20685
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 10:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 345AB20685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405250AbeKVVUn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 16:20:43 -0500
Received: from verein.lst.de ([213.95.11.211]:57557 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732079AbeKVVUn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 16:20:43 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id B1BDE68BC7; Thu, 22 Nov 2018 11:41:50 +0100 (CET)
Date:   Thu, 22 Nov 2018 11:41:50 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
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
        linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V11 14/19] block: handle non-cluster bio out of
 blk_bio_segment_split
Message-ID: <20181122104150.GA29808@lst.de>
References: <20181121032327.8434-1-ming.lei@redhat.com> <20181121032327.8434-15-ming.lei@redhat.com> <20181121143355.GB2594@lst.de> <20181121153726.GC19111@ming.t460p> <20181121174621.GA6961@lst.de> <20181122093259.GA27007@ming.t460p> <20181122100427.GA28871@lst.de> <20181122103208.GD27273@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122103208.GD27273@ming.t460p>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 06:32:09PM +0800, Ming Lei wrote:
> On Thu, Nov 22, 2018 at 11:04:28AM +0100, Christoph Hellwig wrote:
> > On Thu, Nov 22, 2018 at 05:33:00PM +0800, Ming Lei wrote:
> > > However, using virt boundary limit on non-cluster seems over-kill,
> > > because the bio will be over-split(each small bvec may be split as one bio)
> > > if it includes lots of small segment.
> > 
> > The combination of the virt boundary of PAGE_SIZE - 1 and a
> > max_segment_size of PAGE_SIZE will only split if the to me merged
> > segment is in a different page than the previous one, which is exactly
> > what we need here.  Multiple small bvec inside the same page (e.g.
> > 512 byte buffer_heads) will still be merged.
> > 
> > > What we want to do is just to avoid to merge bvecs to segment, which
> > > should have been done by NO_SG_MERGE simply. However, after multi-page
> > > is enabled, two adjacent bvecs won't be merged any more, I just forget
> > > to remove the bvec merge code in V11.
> > > 
> > > So seems we can simply avoid to use virt boundary limit for non-cluster
> > > after multipage bvec is enabled?
> > 
> > No, we can't just remove it.  As explained in the patch there is one very
> > visible difference of setting the flag amd that is no segment will span a
> > page boundary, and at least the iSCSI code seems to rely on that.
> 
> IMO, we should use queue_segment_boundary() to enhance the rule during splitting
> segment after multi-page bvec is enabled.
> 
> Seems we miss the segment boundary limit in bvec_split_segs().

Yes, that looks like the right fix!
