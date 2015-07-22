Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33531 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbbGVTIF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 15:08:05 -0400
Received: by igbpg9 with SMTP id pg9so96380871igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2015 12:08:05 -0700 (PDT)
Message-ID: <55AFE643.5000704@kernel.dk>
Date: Wed, 22 Jul 2015 12:51:47 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: add a bi_error field to struct bio
References: <1437398977-8492-1-git-send-email-hch@lst.de> <1437398977-8492-2-git-send-email-hch@lst.de>
In-Reply-To: <1437398977-8492-2-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/2015 07:29 AM, Christoph Hellwig wrote:
> Currently we have two different ways to signal an I/O error on a BIO:
>
>   (1) by clearing the BIO_UPTODATE flag
>   (2) by returning a Linux errno value to the bi_end_io callback
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

I think this is a good change, the only part I _really_ dislike is that 
this now bumps a struct bio from 2 cache lines to 3. Have you done any 
perf testing?

-- 
Jens Axboe

