Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaIBBW0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Sep 2014 21:22:26 -0400
Date: Mon, 1 Sep 2014 18:22:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Nikolai Grigoriev <ngrigoriev@gmail.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: ext4 vs btrfs performance on SSD array
Message-ID: <20140902012222.GA21405@infradead.org>
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
 <20140902000822.GA20473@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140902000822.GA20473@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 02, 2014 at 10:08:22AM +1000, Dave Chinner wrote:
> Pretty obvious difference: avgrq-sz. btrfs is doing 512k IOs, ext4
> and XFS are doing is doing 128k IOs because that's the default block
> device readahead size.  'blockdev --setra 1024 /dev/sdd' before
> mounting the filesystem will probably fix it.

Btw, it's really getting time to make Linux storage fs work out the
box.  There's way to many things that are stupid by default and we
require everyone to fix up manually:

 - the ridiculously low max_sectors default
 - the very small max readahead size
 - replacing cfq with deadline (or noop)
 - the too small RAID5 stripe cache size

and probably a few I forgot about.  It's time to make things perform
well out of the box..
