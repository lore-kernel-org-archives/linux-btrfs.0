Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50801 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751039AbdE1Jtk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 05:49:40 -0400
Date: Sun, 28 May 2017 11:49:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/13] block_dev: propagate bio_iov_iter_get_pages
        error in __blkdev_direct_IO
Message-ID: <20170528094938.GD14199@lst.de>
References: <20170526085620.3113-1-hch@lst.de> <20170526085620.3113-8-hch@lst.de> <b5bc89a2-a17f-7e98-a767-bfa0c90afaac@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b5bc89a2-a17f-7e98-a767-bfa0c90afaac@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 26, 2017 at 11:12:31AM +0200, Johannes Thumshirn wrote:
> On 05/26/2017 10:56 AM, Christoph Hellwig wrote:
> > Once we move the block layer to its own status code we'll still want to
> > propagate the bio_iov_iter_get_pages, so restructure __blkdev_direct_IO
> > to take ret into account when returning the errno.
> > ---
> 
> 
> -ENOSIGNOFF?

Fixed.
