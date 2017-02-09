Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30711 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751812AbdBIBQj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 20:16:39 -0500
Subject: Re: Very slow balance / btrfs-transaction
To: <fdmanana@gmail.com>
References: <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
 <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
 <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
 <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
 <f9e2b226440e4f6e17e61ce86eecc7eb@88cbed2449cf>
 <57259b63-2f26-0da4-16f6-5fbd781daeb0@cn.fujitsu.com>
 <4200a425-890f-b283-b43b-e5911b1c6d8c@suse.de>
 <3c9ce5e2-6bc0-96d3-1d99-75f96e03afd1@cn.fujitsu.com>
 <CAL3q7H6n9MVz7187GCn-oT0_5fLAxhsgJPA0fjrdvVMQ+4HqTw@mail.gmail.com>
 <8e2d5864-16e0-a92d-9237-ed8001543b06@cn.fujitsu.com>
 <CAL3q7H4z1S1xCv10VGutEGJWF+ROQB0-pc9nPWAdqFyue08S9g@mail.gmail.com>
CC: Goldwyn Rodrigues <rgoldwyn@suse.de>, Jorg Bornschein <jb@capsec.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <2c726883-c0c9-9ea2-cfa5-764e47bcc21f@cn.fujitsu.com>
Date: Thu, 9 Feb 2017 09:13:07 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4z1S1xCv10VGutEGJWF+ROQB0-pc9nPWAdqFyue08S9g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/08/2017 09:56 PM, Filipe Manana wrote:
> On Wed, Feb 8, 2017 at 12:39 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> At 02/07/2017 11:55 PM, Filipe Manana wrote:
>>>
>>> On Tue, Feb 7, 2017 at 12:22 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> wrote:
>>>>
>>>>
>>>>
>>>> At 02/07/2017 12:09 AM, Goldwyn Rodrigues wrote:
>>>>>
>>>>>
>>>>>
>>>>> Hi Qu,
>>>>>
>>>>> On 02/05/2017 07:45 PM, Qu Wenruo wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> At 02/04/2017 09:47 AM, Jorg Bornschein wrote:
>>>>>>>
>>>>>>>
>>>>>>> February 4, 2017 1:07 AM, "Goldwyn Rodrigues" <rgoldwyn@suse.de>
>>>>>>> wrote:
>>>>>
>>>>>
>>>>>
>>>>> <snipped>
>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Quata support was indeed active -- and it warned me that the qroup
>>>>>>> data was inconsistent.
>>>>>>>
>>>>>>> Disabling quotas had an immediate impact on balance throughput -- it's
>>>>>>> *much* faster now!
>>>>>>> From a quick glance at iostat I would guess it's at least a factor 100
>>>>>>> faster.
>>>>>>>
>>>>>>>
>>>>>>> Should quota support generally be disabled during balances? Or did I
>>>>>>> somehow push my fs into a weired state where it triggered a slow-path?
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Thanks!
>>>>>>>
>>>>>>>    j
>>>>>>
>>>>>>
>>>>>>
>>>>>> Would you please provide the kernel version?
>>>>>>
>>>>>> v4.9 introduced a bad fix for qgroup balance, which doesn't completely
>>>>>> fix qgroup bytes leaking, but also hugely slow down the balance
>>>>>> process:
>>>>>>
>>>>>> commit 62b99540a1d91e46422f0e04de50fc723812c421
>>>>>> Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>>> Date:   Mon Aug 15 10:36:51 2016 +0800
>>>>>>
>>>>>>     btrfs: relocation: Fix leaking qgroups numbers on data extents
>>>>>>
>>>>>> Sorry for that.
>>>>>>
>>>>>> And in v4.10, a better method is applied to fix the byte leaking
>>>>>> problem, and should be a little faster than previous one.
>>>>>>
>>>>>> commit 824d8dff8846533c9f1f9b1eabb0c03959e989ca
>>>>>> Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>>> Date:   Tue Oct 18 09:31:29 2016 +0800
>>>>>>
>>>>>>     btrfs: qgroup: Fix qgroup data leaking by using subtree tracing
>>>>>>
>>>>>>
>>>>>> However, using balance with qgroup is still slower than balance without
>>>>>> qgroup, the root fix needs us to rework current backref iteration.
>>>>>>
>>>>>
>>>>> This patch has made the btrfs balance performance worse. The balance
>>>>> task has become more CPU intensive compared to earlier and takes longer
>>>>> to complete, besides hogging resources. While correctness is important,
>>>>> we need to figure out how this can be made more efficient.
>>>>>
>>>> The cause is already known.
>>>>
>>>> It's find_parent_node() which takes most of the time to find all
>>>> referencer
>>>> of an extent.
>>>>
>>>> And it's also the cause for FIEMAP softlockup (fixed in recent release by
>>>> early quit).
>>>>
>>>> The biggest problem is, current find_parent_node() uses list to iterate,
>>>> which is quite slow especially it's done in a loop.
>>>> In real world find_parent_node() is about O(n^3).
>>>> We can either improve find_parent_node() by using rb_tree, or introduce
>>>> some
>>>> cache for find_parent_node().
>>>
>>>
>>> Even if anyone is able to reduce that function's complexity from
>>> O(n^3) down to lets say O(n^2) or O(n log n) for example, the current
>>> implementation of qgroups will always be a problem. The real problem
>>> is that this more recent rework of qgroups does all this accounting
>>> inside the critical section of a transaction - blocking any other
>>> tasks that want to start a new transaction or attempt to join the
>>> current transaction. Not to mention that on systems with small amounts
>>> of memory (2Gb or 4Gb from what I've seen from user reports) we also
>>> OOM due this allocation of struct btrfs_qgroup_extent_record per
>>> delayed data reference head, that are used for that accounting phase
>>> in the critical section of a transaction commit.
>>>
>>> Let's face it and be realistic, even if someone manages to make
>>> find_parent_node() much much better, like O(n) for example, it will
>>> always be a problem due to the reasons mentioned before. Many extents
>>> touched per transaction and many subvolumes/snapshots, will always
>>> expose that root problem - doing the accounting in the transaction
>>> commit critical section.
>>
>>
>> You must accept the fact that we must call find_parent_node() at least twice
>> to get correct owner modification for each touched extent.
>> Or qgroup number will never be correct.
>>
>> One for old_roots by searching commit root, and one for new_roots by
>> searching current root.
>>
>> You can call find_parent_node() as many time as you like, but that's just
>> wasting your CPU time.
>>
>> Only the final find_parent_node() will determine new_roots for that extent,
>> and there is no better timing than commit_transaction().
>
> You're missing my point.
>
> My point is not about needing to call find_parent_nodes() nor how many
> times to call it, or whether it's needed or not. My point is about
> doing expensive things inside the critical section of a transaction
> commit, which leads not only to low performance but getting a system
> becoming unresponsive and with too high latency - and this is not
> theory or speculation, there are upstream reports about this as well
> as several in suse's bugzilla, all caused when qgroups are enabled on
> 4.2+ kernels (when the last qgroups major changes landed).
>
> Judging from that code and from your reply to this and other threads
> it seems you didn't understand the consequences of doing all that
> accounting stuff inside the critical section of a transaction commit.

NO, I know what you're talking about.
Or I won't send the patch to move half of the find_all_roots() call out 
of commit_trans().
(OK, I just like refer to commit_trans() to its critical section, as 
quick exit or other part doesn't make much impact in this context)

While it seems that you still don't understand the necessity to call 
find_all_roots() in critical section.
It's the base stone of qgroup, or we get back to the qgroup mismatch days.

As I already mentioned, only before we switch fs commit roots, we can 
avoid calling extra expensive find_all_roots() and get correct new_roots.

That's to say, at least one find_all_roots() should be called at 
critical section for extent modified extent, to keep qgroup correct.

If you could have any better solution to keep qgroup correct and avoid 
calling find_all_roots() in critical section, I'm happy to listen.

>
> Forget find_parent_nodes() for a moment, yes it has problems, but it's
> not what I'm trying to make you understand. Just look at
> btrfs_qgroup_account_extents(), called within the critical section -
> it iterates all elements of a red black tree, and each element
> corresponds to some data extent allocated in the current transaction -
> if we have thousands, tens of thousands, or more, even if whatever the
> loop calls had an awesome complexity of O(1) or O(log N) it would
> still be bad, exactly because it's blocking future transactions to
> start and tasks from joining the current transaction. CPU time and
> memory consumption (used for those struct btrfs_qgroup_extent_record)
> are also concerns, but to a smaller extent imo.

That's another problem.

For worst case, we could limit the number of delayed ref head before 
triggering a transaction commit.
But I still doubt if qgroup extent record is the cause for OOM.

Memory consumption of qgroup_extent_record is quite small, it's only 48 
bytes for one extent.
(And delayed ref head is much larger than qgroup_extent_record)

While for one extent, its minimum size is 4K, overhead would be at most 1%.

IIRC before we hit OOM, memory pressure should trigger 
commit_transaction(), and freeing all the qgroup_extent_record().
So there is some other problem related to this.

>
>>
>> Or you can wasting more time calling find_parent_node() every time you
>> touched a extent, saving one find_parent_node() in commit_transaction() with
>> the cost of more find_parent_node() in other place.
>> Is that what you want?
>>
>> I can move the find_parent_node() for old_roots out of commit_transaction().
>> But that will only reduce 50% of the time spent on commit_transaction().
>>
>> Compared to O(n^3) find_parent_node(), that's not the determining fact even.
>>
>> Thanks,
>> Qu
>>
>>
>>>
>>>>
>>>>
>>>> IIRC SUSE guys(maybe Jeff?) are working on it with the first method, but
>>>> I
>>>> didn't hear anything about it recently.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>>
>>
>>
>
>
>


