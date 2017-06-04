Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:56658 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbdFDBkU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jun 2017 21:40:20 -0400
Subject: Re: [PATCH] Btrfs: skip commit transaction if we don't have enough
 pinned bytes
To: Omar Sandoval <osandov@osandov.com>, Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
References: <20170519173915.29846-1-bo.li.liu@oracle.com>
 <20170602181413.GA20531@vader.DHCP.thefacebook.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <b4533ce7-57b6-4c05-3d0e-7c16422ad915@applied-asynchrony.com>
Date: Sun, 4 Jun 2017 03:31:28 +0200
MIME-Version: 1.0
In-Reply-To: <20170602181413.GA20531@vader.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/02/17 20:14, Omar Sandoval wrote:
> On Fri, May 19, 2017 at 11:39:15AM -0600, Liu Bo wrote:
>> We commit transaction in order to reclaim space from pinned bytes because
>> it could process delayed refs, and in may_commit_transaction(), we check
>> first if pinned bytes are enough for the required space, we then check if
>> that plus bytes reserved for delayed insert are enough for the required
>> space.
>>
>> This changes the code to the above logic.
>>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>>  fs/btrfs/extent-tree.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index e390451c72e6..bded1ddd1bb6 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -4837,7 +4837,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>>  
>>  	spin_lock(&delayed_rsv->lock);
>>  	if (percpu_counter_compare(&space_info->total_bytes_pinned,
>> -				   bytes - delayed_rsv->size) >= 0) {
>> +				   bytes - delayed_rsv->size) < 0) {
>>  		spin_unlock(&delayed_rsv->lock);
>>  		return -ENOSPC;
>>  	}
> 
> I found this bug in my latest enospc investigation, too. However, the
> total_bytes_pinned counter is pretty broken. E.g., on my laptop:
> 
> $ sync; grep -H '' /sys/fs/btrfs/*/allocation/*/total_bytes_pinned
> /sys/fs/btrfs/f31cc926-37d3-442d-b50a-10c62d47badc/allocation/data/total_bytes_pinned:48693501952
> /sys/fs/btrfs/f31cc926-37d3-442d-b50a-10c62d47badc/allocation/metadata/total_bytes_pinned:-258146304
> /sys/fs/btrfs/f31cc926-37d3-442d-b50a-10c62d47badc/allocation/system/total_bytes_pinned:0
> 
> I have a patch to fix it that I haven't cleaned up yet, below. Without
> it, Bo's fix will probably cause early ENOSPCs. Dave, should we pull
> Bo's patch out of for-next? In any case, I'll get my fix sent out.
[..patch snipped..]

This made me curious since I also found the underflowed metadata counter
on my system. I tried to reproduce it after un/remount (to reset the counters)
and noticed that I could reliably cause the metadata underflow by defragging
a few large subvolumes, which apparently creates enough extent tree movement
that the counter quickly goes bananas. It took some backporting, but with your
patch applied I can defrag away and have so far not seen a single counter
underflow; all of data/metadata/system are always positive after writes and
then reliably drop to 0 after sync/commit. Nice!
Just thought you'd want to know.

Holger
