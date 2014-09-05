Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35054 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaIEQIN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Sep 2014 12:08:13 -0400
Date: Fri, 5 Sep 2014 09:08:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Nikolai Grigoriev <ngrigoriev@gmail.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: ext4 vs btrfs performance on SSD array
Message-ID: <20140905160808.GA7967@infradead.org>
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
 <20140902000822.GA20473@dastard>
 <20140902012222.GA21405@infradead.org>
 <20140903100158.34916d34@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140903100158.34916d34@notabene.brown>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 03, 2014 at 10:01:58AM +1000, NeilBrown wrote:
> Do we still need maximums at all?

I don't think we do.  At least on any system I work with I have to
increase them to get good performance without any adverse effect on
throttling.

> So can we just remove the limit on max_sectors and the RAID5 stripe cache
> size?  I'm certainly keen to remove the later and just use a mempool if the
> limit isn't needed.
> I have seen reports that a very large raid5 stripe cache size can cause
> a reduction in performance.  I don't know why but I suspect it is a bug that
> should be found and fixed.
> 
> Do we need max_sectors ??

I'll send a patch to remove it and watch for the fireworks..
