Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52468 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751312AbdDRNyc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 09:54:32 -0400
Date: Tue, 18 Apr 2017 15:54:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 1/7] btrfs: use blkdev_issue_flush to flush the device
 cache
Message-ID: <20170418135428.GT4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170406032253.14631-1-anand.jain@oracle.com>
 <20170406032253.14631-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170406032253.14631-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 06, 2017 at 11:22:47AM +0800, Anand Jain wrote:
> As of now we do alloc an empty bio and then use the flag REQ_PREFLUSH
> to flush the device cache, instead we can use blkdev_issue_flush()
> for this puspose.

This would change the scheduling characteristics. Right now, the caller
thread submits all bios from one thread, lets block layer do it's work,
and then in the same thread wait for each of the submitted bios.

In your code, the btrfs thread prepares tasks for each bio, shifts the
work to the global workqueue (schedule_work) and then it's same as
before.

I'm concerned about using the global queue. As the bio submission jobs
could get blocked by some other unrelated task queued there, the
guarantees depend on the forward progress of the tasks scheduled
(plus block layer processing).

In the current behaviour, the guarantees stand on the block layer only.

We could introduce yet another work queue and submit the bios there,
with possible fine tuning of the flags, like priority or emergency etc.
But that sounds like unnecessary work as we can simply keep the code
as-is and get the same end result.

Regarding other patches, some of them are independent so I'll see what
can be merged now regardless of the above comments.
