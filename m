Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58240 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755372AbaJMCrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 22:47:19 -0400
Message-ID: <543B3D38.7010708@cn.fujitsu.com>
Date: Mon, 13 Oct 2014 10:47:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Fix and enhance merge_extent_mapping() to insert
 best fitted extent map
References: <1410926015-26820-1-git-send-email-quwenruo@cn.fujitsu.com>	<CAL3q7H4Nqof4dhZCxDsOPyB116RGtSgLCUuDoxahEOsFHzo9UQ@mail.gmail.com>	<541B7967.4050907@cn.fujitsu.com>	<CAL3q7H64P6O1P8vGf2ry8mRJst=E1xxeMmHL0+BB63RYnjGrrg@mail.gmail.com>	<5435D695.40803@cn.fujitsu.com>	<CAL3q7H54BTVtBO8Pa1DXuC+Pk7xmndc-nCGSz2tTsQE+YGBJNA@mail.gmail.com>	<543746C8.9070601@cn.fujitsu.com> <CAL3q7H6ZaQRJV2b525bxRmq42euLpZFQF46veBjwBHMytRqrvw@mail.gmail.com>
In-Reply-To: <CAL3q7H6ZaQRJV2b525bxRmq42euLpZFQF46veBjwBHMytRqrvw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Fix and enhance merge_extent_mapping() to 
insert best fitted extent map
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年10月10日 16:08
> On Fri, Oct 10, 2014 at 3:39 AM, Qu Wenruo<quwenruo@cn.fujitsu.com>  wrote:
>> -------- Original Message --------
>> Subject: Re: [PATCH] btrfs: Fix and enhance merge_extent_mapping() to insert
>> best fitted extent map
>> From: Filipe David Manana<fdmanana@gmail.com>
>> To: Qu Wenruo<quwenruo@cn.fujitsu.com>
>> Date: 2014年10月09日 18:27
>>> On Thu, Oct 9, 2014 at 1:28 AM, Qu Wenruo<quwenruo@cn.fujitsu.com>  wrote:
>>>> -------- Original Message --------
>>>> Subject: Re: [PATCH] btrfs: Fix and enhance merge_extent_mapping() to
>>>> insert
>>>> best fitted extent map
>>>> From: Filipe David Manana<fdmanana@gmail.com>
>>>> To: Qu Wenruo<quwenruo@cn.fujitsu.com>
>>>> Date: 2014年10月08日 20:08
>>>>> On Fri, Sep 19, 2014 at 1:31 AM, Qu Wenruo<quwenruo@cn.fujitsu.com>
>>>>> wrote:
>>>>>> -------- Original Message --------
>>>>>> Subject: Re: [PATCH] btrfs: Fix and enhance merge_extent_mapping() to
>>>>>> insert
>>>>>> best fitted extent map
>>>>>> From: Filipe David Manana<fdmanana@gmail.com>
>>>>>> To: Qu Wenruo<quwenruo@cn.fujitsu.com>
>>>>>> Date: 2014年09月18日 21:16
>>>>>>> On Wed, Sep 17, 2014 at 4:53 AM, Qu Wenruo<quwenruo@cn.fujitsu.com>
>>>>>>> wrote:
>>>>>>>> The following commit enhanced the merge_extent_mapping() to reduce
>>>>>>>> fragment in extent map tree, but it can't handle case which existing
>>>>>>>> lies before map_start:
>>>>>>>> 51f39 btrfs: Use right extent length when inserting overlap extent
>>>>>>>> map.
>>>>>>>>
>>>>>>>> [BUG]
>>>>>>>> When existing extent map's start is before map_start,
>>>>>>>> the em->len will be minus, which will corrupt the extent map and fail
>>>>>>>> to
>>>>>>>> insert the new extent map.
>>>>>>>> This will happen when someone get a large extent map, but when it is
>>>>>>>> going to insert it into extent map tree, some one has already commit
>>>>>>>> some write and split the huge extent into small parts.
>>>>>>> This sounds like very deterministic to me.
>>>>>>> Any reason to not add tests to the sanity tests that exercise
>>>>>>> this/these case/cases?
>>>>>> Yes, thanks for the informing.
>>>>>> Will add the test case for it soon.
>>>>> Hi Qu,
>>>>>
>>>>> Any progress on the test?
>>>>>
>>>>> This is a very important one IMHO, not only because of the bad
>>>>> consequences of the bug (extent map corruption, leading to all sorts
>>>>> of chaos), but also because this problem was not found by the full
>>>>> xfstests suite on several developer machines.
>>>>>
>>>>> thanks
>>>> Still trying to reproduce it under xfstest framework.
>>> That's the problem, wasn't apparently reproducible (or detectable at
>>> least) by anyone with xfstests.
>> I'll try to build a C program to behave the same of filebench and to see if
>> it works.
>> At least with filebench, it can be triggered in 60s with 100% possibility to
>> reproduce.
>>>> But even followiiing the FileBench randomrw behavior(1 thread random read
>>>> 1
>>>> thread random write on preallocated space),
>>>> I still failed to reproduce it.
>>>>
>>>> Still investigating how to reproduce it.
>>>> Worst case may be add a new C program into src of xfstests?
>>> How about the sanity tests (fs/btrfs/tests/*.c)? Create an empty map
>>> tree, add some extent maps, then try to merge some new extent maps
>>> that used to fail before this fix. Seems simple, no?
>>>
>>> thanks Qu
>> It needs concurrency read and write(commit) to trigger it, I am not sure it
>> can be reproduced in sanity tests
>> since it seems not commit things and lacks multithread facility.
> Hum?
> Why does concurrency or persistence matters?
>
> Let's review the problem.
> So you fixed the function inode.c:merge_extent_mapping(). That
> function merges a new extent map (not in the extent map tree) with an
> existing extent map (which is in the tree).
> The issue was that the merge was incorrect for some cases - producing
> a bad extent map (compared to the rest of the existing extent maps)
> that either overlaps existing ones or introduces incorrect gaps, etc -
> doesn't really matter the reason.
> Now, this function is run while holding the write lock of the inode's
> extent map tree.
> So why does concurrency (or persistence) matters here?
It is true that the patch only fixed the above merge problem.

But the bug involves more.
1) the direct cause.
existing extent map's start is smaller than map_start in 
merge_extent_mapping().

2) the root cause.
As described in my V2 patch, there is a window between 
btrfs_release_path() and write_lock(em_tree->lock)
in btrfs_get_extent(), and under concurrency, one may get a big extent 
map converted from on-disk file extent,
and during the windows, a commit happens and the original extent map is 
split into several small ones.

So 1) will happen and cause the bug.

At least the reporter's filebench reproducer can be explained like above,
and that's why concurrency is needed to trigger the bug under such 
circumstance.
> Why can't we have a sanity test that simply reproduces a scenario
> where immediately after attempting to merge extent maps, we get an
> (in-memory) extent map that is incorrect?
There is other situation triggering the bug(just like the mail below),
but the above known circumstance needs concurrency to let commit happen 
during the small window.
So at least sanity test can't trigger it under the *concurrency* 
circumstance.
Maybe the fallocate/dd/filefrag circumstance will fit more for xfs test 
case.
> Also, you don't need to go to such great lengths as writing a C
> program that mimics filebench's behaviour.
> The issue can be reproduced from user space without file write and
> read concurrency as well, using only common tools like fallocate (or
> xfs_io), dd and filefrag. See the thread at:
> http://www.spinics.net/lists/linux-btrfs/msg38045.html
> thanks

Thanks for the information a lot!!
I succeeded in reproduce the bug with a 10G file just using fallcate + dd(from /dev/zero) + filefrag.
Although already good enough, I'll dig more to find out the circumstance the
bug is triggered.

Thanks,
Qu

>> I'll give it a try on the filebench-behavior C program first, and then
>> sanity tests if former doesn't work at all
>
>> Thanks,
>>
>> Qu
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>>
