Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48388 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbbFDJxv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 05:53:51 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] block: add a bi_error field to struct bio
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1433338959-24808-1-git-send-email-hch@lst.de>
	<1433338959-24808-2-git-send-email-hch@lst.de>
Date: Thu, 04 Jun 2015 05:53:43 -0400
In-Reply-To: <1433338959-24808-2-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Wed, 3 Jun 2015 15:42:39 +0200")
Message-ID: <yq1vbf3re8o.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> The first one has the drawback of only communicating a single
Christoph> possible error (-EIO), and the second one has the drawback of
Christoph> not beeing persistent when bios are queued up, and are not
Christoph> passed along from child to parent bio in the ever more
Christoph> popular chaining scenario.

Christoph> So add a new bi_error field to store an errno value directly
Christoph> in struct bio and remove the existing mechanisms to clean all
Christoph> this up.

Having the error status separate from the bio has been a major headache.
I am entirely in favor of this patch.

It was a big chunk of changes to read through but I did not spot any
obvious problems or polarity reversals. It would be nice to get the
respective fs/md/target driver folks to check their portions, though.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
