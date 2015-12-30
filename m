Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50926 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751795AbbL3I6Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 03:58:24 -0500
Subject: Re: Feedback on inline dedup patches
To: Marcel Ritter <ritter.marcel@gmail.com>
References: <CADurGxzoCAk7EFVGiRD+8cc1LMYTFiFBLd02ZcPFtjn=MhBuwQ@mail.gmail.com>
 <568397F5.7070706@cn.fujitsu.com>
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56839C9F.2090401@cn.fujitsu.com>
Date: Wed, 30 Dec 2015 16:58:07 +0800
MIME-Version: 1.0
In-Reply-To: <568397F5.7070706@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Qu Wenruo wrote on 2015/12/30 16:38 +0800:
> Hi Marcel
>
> Thanks a lot for the feedback.
>
> Marcel Ritter wrote on 2015/12/30 09:15 +0100:
>> Hi Qu Wenrou,
>>
>> I just wanted to give some feedback on yesterdays dedup patches:
>>
>> I just applied them to a 4.4-rc7 kernel and did some (very basic)
>> testing:
>>
>> Test1: in-memory
>>
>> Didn't crash on my 350 GB test files. Copying those files again,
>> but "btrfs fi df" didn't show much space savings (maybe that's not
>> the tool to check anyway?).
> Two reasons, one is the the default limit for 4096 hashes.
>
> The other one is a bug for not deduping if a transaction is just committed.
> We already have fix for it internally, but we are busy fixing/testing
> on-disk backend.
> But that's not a big problem as it will only skipped the first several hit.
>
>> Looking further I found the (default) limit of 4096 hashes (is it really
>> hashes? with 16k blocks that'd cover a dataset of only 64 MB?).
>
> Yes, that's the default value.
>
> Allowing even embedded device to have a try on btrfs dedup.
> Default value shouldn't be super big to make the system OOM, so I just
> chose the small 4096 default value.
>
>> I think I'll start a new test run, with a much higher number of hashes,
>> but I'd like to know the memory requirements involved - is there
>> a formula for calculating those memory needs?
>
> The formula is very easy:
> Memory usage = btrfs_dedup_hash_size * limit.
>
> Currently, btrfs_dedup_hahs_size for SHA-256 is 112 bytes.
>
>>
>> Test2: ondisk
>>
>> Created filesystem with "-O dedup", did a btrfs dedup enable -s ondisk"
>> and started copying the same date (s. above). Just a few seconds
>> later I got a kernel crash :-(
>> I'll try to get a kernel dump - maybe this helps to track down the
>> problem.
>
> We're aware of the bug, and are trying our best to fix it.
> But the bug seems quite wired and it may take some time to fix.

OK....

I'm just confused with "btrfs_item_offset_nr" and "btrfs_item_ptr_offset".

And that's the root cause of the problem for on-disk backend.

What a SUUUUUUUUUUUUPER STUUUUUUUUUUUUUPID bug!!!

So the fix will be much sooner than I'd expected.

Thanks,
Qu

>
> So on-disk is not recommended, unless you want to help fixing the bug.
>
> Thanks,
> Qu
>
>>
>>
>>     Marcel
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


