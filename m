Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20017 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752298AbcHXCgt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 22:36:49 -0400
Subject: Re: Btrfs send to send out metadata and data separately
To: <fdmanana@gmail.com>
References: <07e7aea4-ebc7-1c47-34fb-daaae42ab245@gmx.com>
 <CAL3q7H6Wo85Z8KV1m8JNrZALOVO+KhXo8AP2vy3X_XN4BsNySQ@mail.gmail.com>
 <9489e87c-9b54-2808-0d0c-66b80de3920d@cn.fujitsu.com>
 <CAL3q7H6jUAT0ReSur_a4SX0mYZ=9w-SF3GPnbjKT8hhu2CRNAg@mail.gmail.com>
 <2dd6a01c-3774-1789-a78e-8d1e0ca90697@cn.fujitsu.com>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <86744380-9d84-a8eb-beb3-6105de5e5654@cn.fujitsu.com>
Date: Wed, 24 Aug 2016 10:36:38 +0800
MIME-Version: 1.0
In-Reply-To: <2dd6a01c-3774-1789-a78e-8d1e0ca90697@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/04/2016 09:52 AM, Qu Wenruo wrote:
>
>
> At 08/03/2016 05:05 PM, Filipe Manana wrote:
>> On Tue, Aug 2, 2016 at 2:20 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>>
>>> At 08/02/2016 02:00 AM, Filipe Manana wrote:
>>>>
>>>> On Fri, Jul 29, 2016 at 1:40 PM, Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>> wrote:
> [snipped]
>>>>
>>>>
>>>>
>>>
>>> Hi Filipe,
>>>
>>> Thanks for your comment, it helps to refine the idea to fix the problem.
>>>
>>> New idea is stated at the ending of the mail, hopes it will address
>>> all your
>>> conern.
>>>
>>>> Qu,
>>>>
>>>> I don't like the idea at all, for several reasons:
>>>>
>>>> 1) Too complex to implement. We should really avoid making things more
>>>> complex than they are already.
>>>
>>>
>>> Yes, new command new TLV new receiver behavior, the whole idea itself is
>>> complex.
>>>
>>> But the core function for clone detection is simple.
>>> Rb_tree for sent extent bytenr, and avoid sending sent extents.
>>> At least it avoids doing expensive backref walk at all.
>>>
>>> My new idea will keep the core function, while stripe all the new
>>> command/TLV/receiver behavior.
>>>
>>>>    Your earlier suggestion to cache backref lookups is much simpler
>>>> and solves the problem for the vast majority of cases (assuming a
>>>> bounded cache of course).
>>>
>>>
>>> In fact, my earlier suggestion is not to cache backref walk result,
>>> but just
>>> like this one, implement a internal, simpler backref mapper.
>>>
>>> The biggest problem of backref cache is, it conflicts with snapshot.
>>> Any snapshot will easily trash backrefs of a tree.
>>>
>>> It means either we do a full tree walk to trash all backref cache,
>>> making
>>> snapshot much slower, or a broken cache.
>>> (And it adds more complexity to the already complex backref walk)
>>>
>>>>     There's really no need for such high complexity.
>>>>
>>>> 2) By adding new commands to the stream, you break backwards
>>>> compatibility.
>>>>    Think about all the tools out there that interpret send streams and
>>>> not just the receive command (for example snapper).
>>>>
>>>> 3) By requiring a new different behaviour for the receiver, suddenly
>>>> older versions of it will no longer be able to receive from new
>>>> kernels.
>>>
>>>
>>> That's the real problem, I'd try to get rid of these new commands.
>>> My original plan is to introduce new send flag, and make "btrfs send"
>>> command to try to use new flag if possible.
>>>
>>> But the incompatibility is still here.
>>>
>>>>
>>>> 4) By keeping temporary files on the receiver end that contains whole
>>>> extents, you're creating periods of time where stale data is exposed.
>>>
>>>
>>>
>>> At least, I didn't see direct objection against the changed clone range.
>>> (From original parent/send subvol range to send subvol range only)
>>> That's a good news, the core idea behind the fix is still OK.
>>>
>>>
>>> Then the new idea, plan B.
>>>
>>> Plan B is much like the original plan A, with same clone detection
>>> range(inside the send subvolume, not cross subvolumes).
>>>
>>> The modification is, this time, we don't only record extent disk
>>> bytenr into
>>> rb_tree at send time, but more things:
>>> 1) extent disk bytenr
>>> 2) extent offset
>>> 3) extent nr bytes
>>> 4) file offset
>>> 5) path
>>>
>>> So that, we can reuse original write and clone command, no new
>>> command/TLV
>>> is needed at all.
>>>
>>> But at the cost of keeping the rb_tree sync with other operations, like
>>> unlink.
>>
>> I don't get it. The snapshots used by a send operation are read-only -
>> it's not possible to unlink files/extents while send is in progress.
>
> My fault, unlink in send only means to unlink a inode which is in parent
> subvolume but not in send subvolume anymore.
>
> So it won't need to do the sync with cache.
>>
>>> And it causes higher memory usage.
>>>
>>> The new commands in plan A is just used to avoid such complex rb_tree
>>> nor
>>> complex sync.
>>>
>>> What do you think about this Plan B?
>>
>> Lets not rush until things are simple.
>> A (bounded) cache of backref lookups, on the send side and per inode,
>> is simple and solves your original use case.
>
> Still not very clear of your cache idea.
>
> 1) About "per-inode"
>
> Did you mean the lifetime of the cache is during sending one inode?
>
> If so, it may solve the problem of the submitted test case, but won't
> help the following case, where all different files share the same extent:
>
> Inode 1000, file offset 0 len 128K: disk bytenr X, extent offset 0
> Inode 1001, file offset 0 len 128K: disk bytenr X, extent offset 0
> ...
> Inode 5096, file offset 0 len 128K: disk bytenr X, extent offset 0
>
> And that's why my first idea is to make the cache per-subvolume.
>
> 2) About "cache of backref lookups"
>
> IMHO, we have a lot of things to consider in this case.
> For example, in the following case:
>
> Extent X: len 16M
>
> Inode 1000: file offset 0 len 4K: disk bytenr X, extent offset 0
> Inode 1001: file offset 0 len 4K: disk bytenr X, extent offset 4K
> ...
> Inode 4095: file offset 0 len 4K: disk bytenr X, extent offset 16M-4K
>
> For the first referencer, we must do the full backref walk.
> And to cache what? the complex tuple of
> (extent disk bytenr, extent offset, file offset, file path)?
>
> The tuple already seems complex for me now.
>
> And not to mention such cache doesn't have any effect in above case.
> All file extent will go through backref walk, and won't return for a
> long time.
>
>
> And, further more, above case can be more complex:
>>Inode 999: file offset 0 len 16K: disk bytenr X, extent offset 16K
> Inode 1000: file offset 0 len 4K: disk bytenr X, extent offset 0
> Inode 1001: file offset 0 len 4K: disk bytenr X, extent offset 4K
> ...
>
> For inode 999, if we cache its result with (extent disk bytenr, extent
> offset, file offset, file path), then when we send inode 1000, we will
> do a extent overlap check, to find that 1000 can reflink to the first 4K
> of inode 999.
>
> IMHO, such cache is far from simple.
>
> AFAIK, only my original plan A can handle above cases with ease.
>
> Or I misunderstand your idea on what to cache?

Hi Filipe,

Any update on the send problem?

Thanks,
Qu
>
> Thanks,
> Qu
>
>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>
>>>
>>>
>>>>
>>>> Thanks.
>>>>
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>>


