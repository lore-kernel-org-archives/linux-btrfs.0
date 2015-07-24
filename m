Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38690 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbbGXQgr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 12:36:47 -0400
Received: by iggf3 with SMTP id f3so21004140igg.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 09:36:46 -0700 (PDT)
Message-ID: <55B2699D.6010400@kernel.dk>
Date: Fri, 24 Jul 2015 10:36:45 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: add a bi_error field to struct bio
References: <1437398977-8492-1-git-send-email-hch@lst.de> <1437398977-8492-2-git-send-email-hch@lst.de> <55AFE643.5000704@kernel.dk> <55B01252.90004@kernel.dk> <20150724104946.GA25145@lst.de>
In-Reply-To: <20150724104946.GA25145@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/24/2015 04:49 AM, Christoph Hellwig wrote:
> On Wed, Jul 22, 2015 at 03:59:46PM -0600, Jens Axboe wrote:
>> One possible solution would be to shrink bi_flags to an unsigned int, no
>> problems fitting that in. Then we could stuff bi_error in that (new) hole,
>> and we would end up having the same size again.
>
> As long as we use set/test/clear_bt on bi_flags that won't work unfortunately.

Right, I don't think we need to do that though. If you look at the flags 
usage, it's all over the map. Some use test/set_bit, some set it just by 
OR'ing the mask. There's no reason we can't make this work without 
relying on set/test_bit, and then shrink it to an unsigned int.

-- 
Jens Axboe

