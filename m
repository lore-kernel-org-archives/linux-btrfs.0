Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56931 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbcGZLbX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 07:31:23 -0400
Subject: Re: [PATCH RFC] btrfs: send: Disable clone detection
To: fdmanana@gmail.com, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20160725071959.28107-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H7sbHH16nFextVEwY_zYHyKhpSQE7phm687Viuq5U0k6A@mail.gmail.com>
 <8893545f-3a01-d1ac-517f-6536539dc69b@cn.fujitsu.com>
 <CAL3q7H46wzBB0w3iBb9B_1Zu2yRKp27LyFSXHVuEnaq861FKGQ@mail.gmail.com>
 <a23115e4-baa8-69cf-cfb5-721cb1bef944@cn.fujitsu.com>
 <CAL3q7H46HvWb1iYz7iL5OFVXXn58k8z01N7g7uy7wOfQaqsx0Q@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6d5d2e82-cbdf-515e-f27e-9d1327e6a439@gmx.com>
Date: Tue, 26 Jul 2016 19:31:09 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H46HvWb1iYz7iL5OFVXXn58k8z01N7g7uy7wOfQaqsx0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/26/2016 06:57 PM, Filipe Manana wrote:
> On Tue, Jul 26, 2016 at 11:04 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> At 07/26/2016 05:28 PM, Filipe Manana wrote:
>>>
>>> On Tue, Jul 26, 2016 at 1:57 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> wrote:
>>>>
>>>>
>>>>
>>>> At 07/25/2016 09:48 PM, Filipe Manana wrote:
>>>>>
>>>>>
>>>>> On Mon, Jul 25, 2016 at 8:19 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>> This patch will disable clone detection of send.
>>>>>>
>>>>>> The main problem of clone detetion in send is its memory usage and long
>>>>>> execution time.
>>>>>>
>>>>>> The clone detection is done by iterating all backrefs and adding
>>>>>> backref
>>>>>> whose root is the source.
>>>>>>
>>>>>> However iterating all backrefs is already quite a bad idea, we should
>>>>>> never try to do it in a loop, and unfortunately in-band/out-of-band and
>>>>>> reflink can easily create a file whose file extents are point to the
>>>>>> same extent.
>>>>>>
>>>>>> In that case, btrfs will do backref walk for the same extent again and
>>>>>> again, until either OOM or soft lockup is triggered.
>>>>>>
>>>>>> So disabling clone detection until we find a method that iterates
>>>>>> backrefs of one extent only once, just like what balance/qgroup is
>>>>>> doing.
>>>>>
>>>>>
>>>>>
>>>>> Is this really a common scenario?
>>>>
>>>>
>>>>
>>>> If any user can create such file without root privilege, and takes kernel
>>>> CPU for a long time, no matter if it's a common scenario, it's a big
>>>> problem.
>>>
>>>
>>> He can also cause large cpu consumption by making an extent shared
>>> many many times. There's a recent generic fstests case that exercises
>>> that (keeps doing reflinks until ENOSPC happens).
>>
>>
>> Which one?
>> And if you're talking about generic/175, then btrfs is not that slow.
>> Btrfsck is the problem.
>
> generic/333 and generic/334.
>
>>
>>> Shall we disable reflink support too? (clone and extent_same ioctls)
>>
>>
>> No, you didn't ever understand the problem.
>> Unlike reflink, which won't ever do backref walk on the same extent.
>
> I'm giving you an example where too many references cause a slowdown.
> I'm not telling you that it's caused by backref walking. It does not
> matter what causes it,
> the point is if should we completely disable some feature if it has
> performance problems for some edge case(s)?
> Being the example shared extents/reflinks here.

OK, I got the point.

Although I didn't mean to really disable the clone detection, (the 
reason why the patch is RFC).

But too long time to trigger soft lock or sometimes even OOM on small 
memory system is problem.

For other slow speed, yes, it can be caused by whatever the reason is.
But if the time consumption is growing at O(n^3)~O(n^4), then that's a 
problem we can't avoid.

At least, no such O(n^3) example is provided yet.

[snipped]
>>
>> Instead of complaining the slow backref walk, why not do the current best
>> fix to avoid calling unneeded find_parent_nodes() in send?
>
> You got a whole different interpretation of my reply.
> What I've been trying to tell you is that trying to disable things
> because of performance problems for edge cases is not always a good
> idea,
> and that different variants of the problem exist.

Yeah, I know that's not a good idea from the beginning.
But no other good ideas until now.

My new fix plan will be at the end of the mail.

[snipped]
>>
>> But in that case, find_parent_nodes() will just be called once.
>
> Just called once for each different physical extent.
> If it has to be called once for too many different physical extents,
> it will also be slow.

If that different physical extents has different referencer, than the N 
is already larger than the case I'm testing.

We should put the N to the same level.

For example, for N = 4096.
1 Extent, 4096 reference, same root.
And
4096 extent, 1 reference for each, same root.

Is completely different.
The former one is 4096 * O(n^3).
The later one is 4096 * O(1)

You can tweak the above numbers, like 256 extents, 32 reference for 
each, but just keep in mind under the same N value, send time is very 
different.
And for the worst case, it is a problem.


> If some one keeps calling the ioctls that end up doing backref walking
> in a loop, or doing thousands of them in parallel, you also see a
> negative impact...

But that's a different level of N.
Control variable.

>
> Some of these problems, which you only found out recently, have been
> known for quite some time and reported by Zygo Blaxwell on IRC for
> example.

Not even found by myself though.

>
>> Just extra several seconds.
>> (Unless the other file extents inside the send source root also refers to
>> it)
>>
>> I'm so surprised that one put so much effort to make btrfs stable would
>> refuse to see the existing bugs of send, even other backref walk callers
>> find their method to solve the problem.
>
> Where did I say that send has no problems?
>
> All I have been saying to you is that there are many similar problems
> using shared extents and backref walking.

For example? If the same O(n^3)~O(n^4), it should be fixed too.
If normal O(N), or O(logN), then not a problem.

> And just disabling cloning for all cases is extreme when only a few
> rare cases cause problems.

For stability, no case is rare, especially the high level of time 
consumption growth.


Finally the new fix plan.
The main reason I sent the RFC patch, is not to argue where the problem 
is, but to get advice and ideas.
But unfortunately, I didn't get really useful ideas though.

1) Send will sending out the whole extent
    Not the part the file extent uses.
    (Although I'm still not familiar with send/receive yet)

2) Send part record every *extent* it iterated
    Only bytenr is good enough.

3) Before sending an extent, check above rb_tree of bytenr
    If found, send out clone.
    Not found, send the whole extent, and record bytenr into rb_tree.

The rb_tree search is O(logN), the total time consumption is O(NlogN).

Fpr all shared extent case, tree operation will be O(1) (tree only 
contains 1 node), total time consumption will be O(N).

For all exclusive extent case, tree operation will be O(N), total will 
be O(N^2).

Memory usage will be O(1) to O(N).

My only concern is, if it is possible, and will such change will 
introduce incompatibility.

Thanks,
Qu
