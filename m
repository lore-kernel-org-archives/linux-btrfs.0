Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6786 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751209AbcHABjf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jul 2016 21:39:35 -0400
Subject: Re: Btrfs send to send out metadata and data separately
To: <g.btrfs@cobb.uk.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <07e7aea4-ebc7-1c47-34fb-daaae42ab245@gmx.com>
 <579CF6D5.7030300@cobb.uk.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9430d8d6-8ffb-cf75-720e-e904743fbcdd@cn.fujitsu.com>
Date: Mon, 1 Aug 2016 09:39:06 +0800
MIME-Version: 1.0
In-Reply-To: <579CF6D5.7030300@cobb.uk.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/31/2016 02:49 AM, g.btrfs@cobb.uk.net wrote:
> On 29/07/16 13:40, Qu Wenruo wrote:
>> Cons:
>> 1) Not full fs clone detection
>>    Such clone detection is only inside the send snapshot.
>>
>>    For case that one extent is referred only once in the send snapshot,
>>    but also referred by source subvolume, then in the received
>>    subvolume, it will be a new extent, but not a clone.
>>
>>    Only extent that is referred twice by send snapshot, that extent
>>    will be shared.
>>
>>    (Although much better than disabling the whole clone detection)
>
> Qu,
>
> Does that mean that the following, extremely common, use of send would
> be impacted?
>
> Create many snapshots of a large and fairly busy sub-volume (say,
> hourly) with few changes between each one. Send all the snapshots as
> incremental sends to a second (backup) disk either as soon as they are
> created, or maybe in bunches later.
>
> With this change, would each of the snapshots require separate space
> usage on the backup disk, with duplicates of unchanged files?  If so,
> that would completely destroy the concept of keeping frequent snapshots
> on a backup disk (and force us to keep the snapshots on the original
> disk, causing **many** more problems with backref walks on the data disk).

This new behavior won't impact this use case.

As kernel send part will compare tree blocks to send out the difference 
only.

So incremental sends is not impacted at all.



The impacted behavior is, reflink from old snapshot.
One example is:

1) There is a readonly snapshot A
    Already sent and recovered

2) A new snapshot B, is snapshotted from A
    With the new modification:
      Reflink one extent(X) which lies in A

In that case, if we send out snapshot B, based on A,
then the extent X will be sent out as a new extent, not a reflink.
Since it's only used once inside the snapshot B.

While the original send will detect such reflink, and won't send out the 
whole extent.


But if snapshot B has the following modification compare to A:

   1) Reflink one extent(X) which originally lies in A, to inode Z

   2) Reflink one extent(X) which originally lies in A, to inode W

Then although extent X will still be sent out as a new extent, Z and W 
will share the extent, as it's referred twice inside the snapshot B.


I assume the most common impact will be, reflinking the whole file from 
original subvolume.
In that case, the whole file will be sent out as new data.

While for reflinking inside the subvolume, the clone detection is 
faster, and I consider that's more common though.

It's a trade which leans to heavily deduped files(both in-band or 
out-of-band) or heavily snapshotted subvolume layout, as it completely 
avoids the time consuming backref walk.

Personally I consider it worthy though.

Thanks,
Qu
>
> (Does the answer change if we do non-incremental sends?)
>
> I moved to this approach after the problems I had running balance on my
> (very busy, and also large) data disk because of the number of snapshots
> I was keeping on it.  My data disk has about 4TB in use, and I have just
> bought a 10TB backup disk but I would need about 50 more of them if the
> hourly snapshots were no longer sharing space! If that is the case, the
> cure seems much worse than the disease.
>
> Apologies if I have misunderstood the proposal.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


