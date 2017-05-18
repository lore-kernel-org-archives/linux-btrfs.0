Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19879 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdERJZ7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 05:25:59 -0400
Subject: Re: [RFC PATCH 0/2] Introduce blkdev_issue_flush_no_wait()
To: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20170516093914.16035-1-anand.jain@oracle.com>
 <1494943642.2935.1.camel@sandisk.com> <20170517171400.GI4065@suse.cz>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <557ddd47-8e78-fde5-2f71-65fcd44ea7c7@oracle.com>
Date: Thu, 18 May 2017 17:31:44 +0800
MIME-Version: 1.0
In-Reply-To: <20170517171400.GI4065@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/18/2017 01:14 AM, David Sterba wrote:
> On Tue, May 16, 2017 at 02:07:23PM +0000, Bart Van Assche wrote:
>> On Tue, 2017-05-16 at 17:39 +0800, Anand Jain wrote:
>>> BTRFS wanted a block device flush function which does not wait for
>>> its completion, so that the flush for the next device can be called
>>> in the same thread.
>>>
>>> Here is a RFC patch to provide the function
>>> 'blkdev_issue_flush_no_wait()', which is based on the current device
>>> flush function 'blkdev_issue_flush()', however it uses submit_bio()
>>> instead of submit_bio_wait().
>>>
>>> This patch is for review comments, will send out a final patch based
>>> on the comments received.
>>
>> Since the block layer can reorder requests, I think using
>> blkdev_issue_flush_no_wait() will only yield the intended result if
>> the caller waits until the requests that have to be flushed have completed.
>> Is that how you intend to use this function?
>
> Yes, this is intended. Regarding the two patches, I don't think we need
> them. A more detailed explanation below.
>
> The function blkdev_issue_flush_no_wait would be used in multi-device
> btrfs to submit the barriers in parallel.
>
> fs/btrfs/disk-io.c:barrier_all_devices
>
> pseudocode:
>
> foreach device
> 	write_dev_flush(wait=0)
> 		submit_bio(device->bio)
>
> (would newly use blkdev_issue_flush_no_wait)
>
>
> foreach device
> 	write_dev_flush(wiat=1)
> 		wait_for_completion(device->bio)
>
> The submission path of write_dev_flush mimics the structure of
> blkdev_issue_flush, so Anand supposedly wants to move that to API.
>
> I personally don't think this is necessary and am fine with opencoding
> it, btrfs would likely be the only user of the new function anyway.
> Other reason is that we want to preallocate the bio used for flushing so
> we can avoid ENOMEM when submitting disk barriers. This would not be
> possible. In summary, I think we can address all the problems inside
> btrfs without extending block layer as for now.


   Thanks David.

   Pls. Ignore this set.



Thanks, Anand
