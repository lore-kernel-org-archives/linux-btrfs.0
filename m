Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbbGUITL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 04:19:11 -0400
Message-ID: <55AE007C.9030807@suse.de>
Date: Tue, 21 Jul 2015 10:19:08 +0200
From: Hannes Reinecke <hare@suse.de>
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] block: add a bi_error field to struct bio
References: <1437398977-8492-1-git-send-email-hch@lst.de> <1437398977-8492-2-git-send-email-hch@lst.de>
In-Reply-To: <1437398977-8492-2-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/2015 03:29 PM, Christoph Hellwig wrote:
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
Very good improvement.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
