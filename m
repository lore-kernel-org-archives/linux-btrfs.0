Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41255 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdDSEXs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 00:23:48 -0400
Subject: Re: [PATCH v4 1/7] btrfs: use blkdev_issue_flush to flush the device
 cache
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170406032253.14631-1-anand.jain@oracle.com>
 <20170406032253.14631-2-anand.jain@oracle.com>
 <20170418135428.GT4781@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <4fed6e0c-1876-2cd2-0711-906cafbdef2f@oracle.com>
Date: Wed, 19 Apr 2017 12:29:09 +0800
MIME-Version: 1.0
In-Reply-To: <20170418135428.GT4781@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/18/2017 09:54 PM, David Sterba wrote:
> On Thu, Apr 06, 2017 at 11:22:47AM +0800, Anand Jain wrote:
>> As of now we do alloc an empty bio and then use the flag REQ_PREFLUSH
>> to flush the device cache, instead we can use blkdev_issue_flush()
>> for this puspose.
>
> This would change the scheduling characteristics. Right now, the caller
> thread submits all bios from one thread, lets block layer do it's work,
> and then in the same thread wait for each of the submitted bios.

> In your code, the btrfs thread prepares tasks for each bio, shifts the
> work to the global workqueue (schedule_work) and then it's same as
> before.

> I'm concerned about using the global queue. As the bio submission jobs
> could get blocked by some other unrelated task queued there, the
> guarantees depend on the forward progress of the tasks scheduled
> (plus block layer processing).

> In the current behaviour, the guarantees stand on the block layer only.
>
> We could introduce yet another work queue and submit the bios there,
> with possible fine tuning of the flags, like priority or emergency etc.
> But that sounds like unnecessary work as we can simply keep the code
> as-is and get the same end result.

  I had to schedule the flush to request flush for all the devices in
  parallel. For the obvious reason that flush may take a lot of time
  for the devices which aren't missing. blkdev_issue_flush() uses
  submit_bio_wait() which makes sense for the non-volume-based-FS.
  And there isn't something like blkdev_issue_flush_no_wait(). Also
  now I see that there isn't the btrfsic part in the patch.
  To fix this I think pre-alloc-ed bio for the flush is a good idea
  (as you suggested earlier). Further as the commit thread doesn't
  overlap, and barrier device happens only at the commit so there
  won't be concurrent demand for the pre-alloc-ed bio.
  Also pre-alloc-ed bio can be alloc-ed only when barrier is enabled
  as a mem optimization. Will send a RFC code for the comments with
  these changes.

> Regarding other patches, some of them are independent so I'll see what
> can be merged now regardless of the above comments.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
