Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C036C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 01:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A5E2081C
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 01:30:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51A5E2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbeK2MeD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 07:34:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46546 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbeK2MeD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 07:34:03 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40E1C3DDB6;
        Thu, 29 Nov 2018 01:30:27 +0000 (UTC)
Received: from ming.t460p (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D9D9661522;
        Thu, 29 Nov 2018 01:30:04 +0000 (UTC)
Date:   Thu, 29 Nov 2018 09:30:00 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
        "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH V12 00/20] block: support multi-page bvec
Message-ID: <20181129012959.GC23249@ming.t460p>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <7096bc4e-0617-29d0-a90d-ae7caf09a16d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7096bc4e-0617-29d0-a90d-ae7caf09a16d@kernel.dk>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 29 Nov 2018 01:30:27 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 06:44:00AM -0700, Jens Axboe wrote:
> On 11/25/18 7:17 PM, Ming Lei wrote:
> > Hi,
> > 
> > This patchset brings multi-page bvec into block layer:
> > 
> > 1) what is multi-page bvec?
> > 
> > Multipage bvecs means that one 'struct bio_bvec' can hold multiple pages
> > which are physically contiguous instead of one single page used in linux
> > kernel for long time.
> > 
> > 2) why is multi-page bvec introduced?
> > 
> > Kent proposed the idea[1] first. 
> > 
> > As system's RAM becomes much bigger than before, and huge page, transparent
> > huge page and memory compaction are widely used, it is a bit easy now
> > to see physically contiguous pages from fs in I/O. On the other hand, from
> > block layer's view, it isn't necessary to store intermediate pages into bvec,
> > and it is enough to just store the physicallly contiguous 'segment' in each
> > io vector.
> > 
> > Also huge pages are being brought to filesystem and swap [2][6], we can
> > do IO on a hugepage each time[3], which requires that one bio can transfer
> > at least one huge page one time. Turns out it isn't flexiable to change
> > BIO_MAX_PAGES simply[3][5]. Multipage bvec can fit in this case very well.
> > As we saw, if CONFIG_THP_SWAP is enabled, BIO_MAX_PAGES can be configured
> > as much bigger, such as 512, which requires at least two 4K pages for holding
> > the bvec table.
> 
> I'm pretty happy with this patchset at this point, looks like it just
> needs a respin to address the last comments. My only concern is whether

I will address the last comment from Omar on patch of '[PATCH V12 01/20] btrfs:
remove various bio_offset arguments', we may use the approach in V11 simply.

> it's a good idea to target this for 4.21, or if we should wait until
> 4.22. 4.21 has a fairly substantial amount of changes in terms of block
> already, it's not the best timing for something of this magnitude too.

Yeah, I understand.

> 
> I'm going back and forth on those one a bit. Any concerns with
> pushing this to 4.22?

My only one concern is about the warning of "blk_cloned_rq_check_limits:
over max segments limit" on dm multipath, and seems Ewan and Mike is waiting
for this fix.

thanks,
Ming
