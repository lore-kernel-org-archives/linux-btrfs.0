Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59018 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753606AbdERPlL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 11:41:11 -0400
Subject: Re: btrfs metadata reclaim behavior/performance characteristics
To: bo.li.liu@oracle.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, jeffm@suse.com
References: <dc9f3787-767b-6710-9694-9eb02aa07728@suse.com>
 <20170518144532.GA28854@lim.localdomain>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a9c76afa-a18a-36e2-b3e8-a66bce9a0c3f@suse.com>
Date: Thu, 18 May 2017 18:41:08 +0300
MIME-Version: 1.0
In-Reply-To: <20170518144532.GA28854@lim.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18.05.2017 17:45, Liu Bo wrote:
> On Thu, May 18, 2017 at 11:40:05AM +0300, Nikolay Borisov wrote:

<ommitted for brevity>

> 
> Just some random thoughts here.
> 
> Hmm, not sure if this matters, but fstests now doesn't set --mixed even if the
> disk size is as small as 256mb.  So are you testing a mixed btrfs or not?

You are right that fstest only sets mixed mode in case the filesystem is
less than or equal to 100mb. IN this case the fs is 256mb which means
mixed mode _is not_ set.

> 
> So now we've observed there're too many 'commit transaction' happening, I think it's because via commiting transaction it doesn't reclaim enough metadata space, esp. looks like space->bytes_may_use is not reduced somehow.

You've given me the idea to basically compare the state of the various
space_info counters after each transaction commit. Before and after the
ticketed work. Also what makes you believe it's the commit transaction
itself not freeing enough memory and not some of the other, "cheaper"
flush states?

> 
> The metadata space_info->bytes_may_use may come from:
> 1) 1K file with buffered IO ends up living in btree leaf, so it will contribute to the number,
> 2) if it's mixed btrfs, then 1k file with direct IO ends up with creating a 4k extent in mixed block group.
> 3) while writing 1k files, metadata is reserved to make it run, and when to release depends on writeback (in the buffered IO case) or endio (in the direct IO case)
> 
> When running several commit transaction concurrently, if one has entered TRANS_STATE_COMMIT_START state, others just wait there, have you observed that if each commit transaction actually writes superblock in the end?

Haven't gone that far, will have to instrument the code to confirm this.
What exactly should writing the superblock reveal?

> 
> Thanks,
> 
> -liubo
> 
>>

<omitted for brevity>
