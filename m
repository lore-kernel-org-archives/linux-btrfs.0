Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34872 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbbG1Odq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 10:33:46 -0400
Received: by igr7 with SMTP id 7so119015985igr.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 07:33:46 -0700 (PDT)
Message-ID: <55B792C9.2000605@kernel.dk>
Date: Tue, 28 Jul 2015 08:33:45 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: add a bi_error field to struct bio
References: <1437398977-8492-1-git-send-email-hch@lst.de> <1437398977-8492-2-git-send-email-hch@lst.de> <55AFE643.5000704@kernel.dk> <55B01252.90004@kernel.dk> <20150724104946.GA25145@lst.de> <55B2699D.6010400@kernel.dk> <20150728111249.GA19647@lst.de>
In-Reply-To: <20150728111249.GA19647@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/28/2015 05:12 AM, Christoph Hellwig wrote:
> On Fri, Jul 24, 2015 at 10:36:45AM -0600, Jens Axboe wrote:
>> Right, I don't think we need to do that though. If you look at the flags
>> usage, it's all over the map. Some use test/set_bit, some set it just by
>> OR'ing the mask. There's no reason we can't make this work without relying
>> on set/test_bit, and then shrink it to an unsigned int.
>
> Yes, the current mess doesn't look kosher.  The bvec pool bits don't
> really make it better.
>
> But do we really need the cmpxchg hack? Seems like most flags aren't
> exposed to concurrency at all, althugh this would need a careful audit.

I actually don't think that we do need it at all. With the uptodate bit 
gone, we really should not have any concurrency issues on it at all. 
CHAIN and REFFED need serialization, but that is already done previous 
to this change.

-- 
Jens Axboe

