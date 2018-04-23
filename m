Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33081 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754081AbeDWJbT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 05:31:19 -0400
Subject: Re: [PATCH 0/5] Remove delay_iput parameter when running delalloc
 work
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1524470057-21969-1-git-send-email-nborisov@suse.com>
 <b4e0bd43-ad9e-55f5-4e33-7845fdb89270@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5eb93fa2-727f-8e62-2ee4-dfb59f07888c@suse.com>
Date: Mon, 23 Apr 2018 12:31:17 +0300
MIME-Version: 1.0
In-Reply-To: <b4e0bd43-ad9e-55f5-4e33-7845fdb89270@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.04.2018 12:27, Qu Wenruo wrote:
> 
> 
> On 2018年04月23日 15:54, Nikolay Borisov wrote:
>> While trying to make sense of the lifecycle of delayed iputs it became apparent
>> that the delay_iput parameter of btrfs_start_delalloc_roots/
>> btrfs_start_delalloc_inodes is always set to 0. (Patch 1 contains historical 
>> information of why this parameter was needed and when it became obsolete). Now
>> that the code has changed sufficiently it's no longer required to have it so
>> this series gradually removes it. 
>>
>> Nikolay Borisov (5):
>>   btrfs: Remove delayed_iput parameter of btrfs_start_delalloc_roots
>>   btrfs: Remove delayed_iput parameter from btrfs_start_delalloc_inodes
>>   btrfs: Remove delay_iput parameter from __start_delalloc_inodes
>>   btrfs: Remove delayed_iput member from btrfs_delalloc_work
>>   btrfs: Unexport btrfs_alloc_delalloc_work
> 
> Solid cleanup.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> Just a little nitpick about the 3rd and 4th patch.
> It would be nicer the merge them, as in the the 3rd patch
> btrfs_alloc_delalloc_work() call still takes 0 as @delay_iput, but in
> next patch the @delay_iput just get removed.

I'm fine with that, I guess David if you deem it more reasonable you
could squash the 2 patches. I just did it for the sake of bisectability
and review purposes.

> 
> Thanks,
> Qu
> 
>>
>>  fs/btrfs/ctree.h       |  9 ++-------
>>  fs/btrfs/dev-replace.c |  2 +-
>>  fs/btrfs/extent-tree.c |  4 ++--
>>  fs/btrfs/inode.c       | 28 +++++++++-------------------
>>  fs/btrfs/ioctl.c       |  4 ++--
>>  5 files changed, 16 insertions(+), 31 deletions(-)
>>
> 
