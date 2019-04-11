Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2763FC10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 13:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC3B92077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 13:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfDKNZw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 09:25:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:47684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbfDKNZv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 09:25:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 674E0AEB7;
        Thu, 11 Apr 2019 13:25:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AC7FCDA862; Thu, 11 Apr 2019 15:26:54 +0200 (CEST)
Date:   Thu, 11 Apr 2019 15:26:53 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V3] block: don't use for-inside-for in
 bio_for_each_segment_all
Message-ID: <20190411132652.GP29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Christoph Hellwig <hch@lst.de>
References: <20190408110238.30478-1-ming.lei@redhat.com>
 <b55becef-d644-6f6d-428b-e25216016218@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b55becef-d644-6f6d-428b-e25216016218@kernel.dk>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 08, 2019 at 08:19:59AM -0600, Jens Axboe wrote:
> On 4/8/19 5:02 AM, Ming Lei wrote:
> > Commit 6dc4f100c175 ("block: allow bio_for_each_segment_all() to
> > iterate over multi-page bvec") changes bio_for_each_segment_all()
> > to use for-inside-for.
> > 
> > This way breaks all bio_for_each_segment_all() call with error out
> > branch via 'break', since now 'break' can only break from the inner
> > loop.
> > 
> > Fixes this issue by implementing bio_for_each_segment_all() via
> > single 'for' loop, and now the logic is very similar with normal
> > bvec iterator.
> 
> Applied, thanks Ming.

What's the merge target please? This affects btrfs testing so I wonder
if we should start adding workarounds or just wait for the next rc.
Thanks.
