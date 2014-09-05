Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbaIEQlZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Sep 2014 12:41:25 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: NeilBrown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>,
        Nikolai Grigoriev <ngrigoriev@gmail.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: ext4 vs btrfs performance on SSD array
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
	<20140902000822.GA20473@dastard>
	<20140902012222.GA21405@infradead.org>
	<20140903100158.34916d34@notabene.brown>
	<20140905160808.GA7967@infradead.org>
Date: Fri, 05 Sep 2014 12:40:49 -0400
In-Reply-To: <20140905160808.GA7967@infradead.org> (Christoph Hellwig's
	message of "Fri, 5 Sep 2014 09:08:08 -0700")
Message-ID: <x497g1ivx4e.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Sep 03, 2014 at 10:01:58AM +1000, NeilBrown wrote:
>> Do we still need maximums at all?
>
> I don't think we do.  At least on any system I work with I have to
> increase them to get good performance without any adverse effect on
> throttling.
>
>> So can we just remove the limit on max_sectors and the RAID5 stripe cache
>> size?  I'm certainly keen to remove the later and just use a mempool if the
>> limit isn't needed.
>> I have seen reports that a very large raid5 stripe cache size can cause
>> a reduction in performance.  I don't know why but I suspect it is a bug that
>> should be found and fixed.
>> 
>> Do we need max_sectors ??

I'm assuming we're talking about max_sectors_kb in
/sys/block/sdX/queue/.

> I'll send a patch to remove it and watch for the fireworks..

:) I've seen SSDs that actually degrade in performance if I/O sizes
exceed their internal page size (using artificial benchmarks; I never
confirmed that with actual workloads).  Bumping the default might not be
bad, but getting rid of the tunable would be a step backwards, in my
opinion.

Are you going to bump up BIO_MAX_PAGES while you're at it?

Cheers,
Jeff
