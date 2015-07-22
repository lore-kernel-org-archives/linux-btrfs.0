Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbbGVFBM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 01:01:12 -0400
Date: Wed, 22 Jul 2015 15:00:47 +1000
From: NeilBrown <neilb@suse.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: add a bi_error field to struct bio
Message-ID: <20150722150047.5c5d59df@noble>
In-Reply-To: <1437398977-8492-2-git-send-email-hch@lst.de>
References: <1437398977-8492-1-git-send-email-hch@lst.de>
	<1437398977-8492-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 20 Jul 2015 15:29:37 +0200 Christoph Hellwig <hch@lst.de> wrote:

> Currently we have two different ways to signal an I/O error on a BIO:
> 
>  (1) by clearing the BIO_UPTODATE flag
>  (2) by returning a Linux errno value to the bi_end_io callback
> 
> The first one has the drawback of only communicating a single possible
> error (-EIO), and the second one has the drawback of not beeing persistent
> when bios are queued up, and are not passed along from child to parent
> bio in the ever more popular chaining scenario.  Having both mechanisms
> available has the additional drawback of utterly confusing driver authors
> and introducing bugs where various I/O submitters only deal with one of
> them, and the others have to add boilerplate code to deal with both kinds
> of error returns.
> 
> So add a new bi_error field to store an errno value directly in struct
> bio and remove the existing mechanisms to clean all this up.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: NeilBrown <neilb@suse.com> (umem and md/raid).

i.e. these files.
>  drivers/block/umem.c                |  4 +--
>  drivers/md/faulty.c                 |  4 +--
>  drivers/md/linear.c                 |  2 +-
>  drivers/md/md.c                     | 18 +++++------
>  drivers/md/multipath.c              | 12 +++----
>  drivers/md/raid0.c                  |  2 +-
>  drivers/md/raid1.c                  | 53 ++++++++++++++++---------------
>  drivers/md/raid10.c                 | 55 +++++++++++++++-----------------
>  drivers/md/raid5.c                  | 52 +++++++++++++++----------------


Thanks,
NeilBrown
