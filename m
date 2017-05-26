Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937314AbdEZJMr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 05:12:47 -0400
Subject: Re: [PATCH 07/13] block_dev: propagate bio_iov_iter_get_pages error
 in __blkdev_direct_IO
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
References: <20170526085620.3113-1-hch@lst.de>
 <20170526085620.3113-8-hch@lst.de>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <b5bc89a2-a17f-7e98-a767-bfa0c90afaac@suse.de>
Date: Fri, 26 May 2017 11:12:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170526085620.3113-8-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/26/2017 10:56 AM, Christoph Hellwig wrote:
> Once we move the block layer to its own status code we'll still want to
> propagate the bio_iov_iter_get_pages, so restructure __blkdev_direct_IO
> to take ret into account when returning the errno.
> ---


-ENOSIGNOFF?

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
