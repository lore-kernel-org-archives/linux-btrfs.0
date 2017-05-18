Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39620 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdERJ0Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 05:26:16 -0400
Subject: Re: [PATCH 1/2] block: Introduce blkdev_issue_flush_no_wait()
To: Christoph Hellwig <hch@infradead.org>
References: <20170516093914.16035-1-anand.jain@oracle.com>
 <20170516093914.16035-2-anand.jain@oracle.com>
 <20170516115605.GA18649@infradead.org>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d97acfdb-3ab1-5722-f341-a8feba1a72ef@oracle.com>
Date: Thu, 18 May 2017 17:31:32 +0800
MIME-Version: 1.0
In-Reply-To: <20170516115605.GA18649@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/16/2017 07:56 PM, Christoph Hellwig wrote:
> On Tue, May 16, 2017 at 05:39:13PM +0800, Anand Jain wrote:
>> blkdev_issue_flush() is a blocking function and returns only after
>> the flush bio is completed, so a module handling more than one
>> device can't issue flush for all the devices unless it uses worker
>> thread.
>>
>> This patch adds a new function blkdev_issue_flush_no_wait(), which
>> uses submit_bio() instead of submit_bio_wait(), and accepts the
>> completion function and data from the caller.
>
> Just open code the damn thing,

  Ok. Thanks for the comments.

> and drop the various superflous checks
> while you're at it.

  You mean at btrfs: write_dev_flush()
    OR
  block: blkdev_issue_flush() ?
  Where I find
         q = bdev_get_queue(bdev);
         if (!q)
                 return -ENXIO
  isn't needed as anyway generic_make_request_checks() will
  check that down below.
  Not too sure about the other two checks though.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
