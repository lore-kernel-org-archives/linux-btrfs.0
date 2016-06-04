Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56178 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbcFDKhZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jun 2016 06:37:25 -0400
Subject: Re: [PATCH v10 00/21] Btrfs dedupe framework
To: Josef Bacik <jbacik@fb.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <601bf2e3-a1c3-97aa-38ee-39ff3f6d8545@fb.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ab769045-8bf9-14c5-47e2-afa9570735f7@gmx.com>
Date: Sat, 4 Jun 2016 18:37:12 +0800
MIME-Version: 1.0
In-Reply-To: <601bf2e3-a1c3-97aa-38ee-39ff3f6d8545@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/2016 11:20 PM, Josef Bacik wrote:
> On 04/01/2016 02:34 AM, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux.git wang_dedupe_20160401
>>
>> In this patchset, we're proud to bring a completely new storage backend:
>> Khala backend.
>>
>> With Khala backend, all dedupe hash will be restored in the Khala,
>> shared with every Kalai protoss, with unlimited storage and almost zero
>> search latency.
>> A perfect backend for any Kalai protoss. "My life for Aiur!"
>>
>> Unfortunately, such backend is not available for human.
>>
>>
>> OK, except the super-fancy and date-related backend, the patchset is
>> still a serious patchset.
>> In this patchset, we mostly addressed the on-disk format change
>> comment from
>> Chris:
>> 1) Reduced dedupe hash item and bytenr item.
>>    Now dedupe hash item structure size is reduced from 41 bytes
>>    (9 bytes hash_item + 32 bytes hash)
>>    to 29 bytes (5 bytes hash_item + 24 bytes hash)
>>    Without the last patch, it's even less with only 24 bytes
>>    (24 bytes hash only).
>>    And dedupe bytenr item structure size is reduced from 32 bytes (full
>>    hash) to 0.
>>
>> 2) Hide dedupe ioctls into CONFIG_BTRFS_DEBUG
>>    Advised by David, to make btrfs dedupe as an experimental feature for
>>    advanced user.
>>    This is used to allow this patchset to be merged while still allow us
>>    to change ioctl in the further.
>>
>> 3) Add back missing bug fix patches
>>    I just missed 2 bug fix patches in previous iteration.
>>    Adding them back.
>>
>> Now patch 1~11 provide the full backward-compatible in-memory backend.
>> And patch 12~14 provide per-file dedupe flag feature.
>> Patch 15~20 provide on-disk dedupe backend with persist dedupe state for
>> in-memory backend.
>> The last patch is just preparation for possible dedupe-compress co-work.
>>
>
> You can add
>
> Reviewed-by: Josef Bacik <jbacik@fb.com>
>
> to everything I didn't comment on (and not the ENOSPC one either, but I
> commented on that one last time).

Thanks for the review.

All your comment will be addressed in next version, except ones I commented.

>
> But just because I've reviewed it doesn't mean it's ready to go in.
> Before we are going to take this I want to see the following

Right, I won't rush to merge it, and I'm pretty sure you would like to 
review the incoming ENOSPC fix further, as the root fix would be a 
little complicated and affects a lot of common routines.

>
> 1) fsck support for dedupe that verifies the hashes with what is on disk

Nice advice, if hash pool is screwed up, the whole fs will be screwed up.

But that's for on-disk backend, and unfortunately, on-disk backend will 
be excluded in next version.

On-disk backend will only be re-introduced after in-memory backend only 
patchset.

> so any xfstests we write are sure to catch problems.


> 2) xfstests.  They need to do the following things for both in memory
> and ondisk
>     a) targeted verification.  So write one pattern, write the same
>        pattern to a different file and use fiemap to verify they are the
>        same.
Already in previous xfstests patchset.

But need a little modification, as we may merge in-mem and on-disk 
backend in different kernel merge windows, so test cases may be split 
for different backends.

I'll update xfstest with V11 patchset, to do in-mem only checks.

>     b) modify fsstress to have an option to always write the same
>        pattern and then run a stress test while balancing.

We already had such test cases, and even with current fsstress, its 
pattern is already good enough to trigger some bug in our test cases.

But it's still a good idea to make fsstress to reproduce dedupe bugs 
more preciously.

Thanks,
Qu
>
> Once the issues I've hilighted in the other patches are resolved and the
> above xfstests things are merged and the fsck patches are
> reviewed/accepted then we can move forward with including dedup.  Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
