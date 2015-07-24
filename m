Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55025 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbbGXKtt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 06:49:49 -0400
Date: Fri, 24 Jul 2015 12:49:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: add a bi_error field to struct bio
Message-ID: <20150724104946.GA25145@lst.de>
References: <1437398977-8492-1-git-send-email-hch@lst.de> <1437398977-8492-2-git-send-email-hch@lst.de> <55AFE643.5000704@kernel.dk> <55B01252.90004@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55B01252.90004@kernel.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 22, 2015 at 03:59:46PM -0600, Jens Axboe wrote:
> One possible solution would be to shrink bi_flags to an unsigned int, no 
> problems fitting that in. Then we could stuff bi_error in that (new) hole, 
> and we would end up having the same size again.

As long as we use set/test/clear_bt on bi_flags that won't work unfortunately.
