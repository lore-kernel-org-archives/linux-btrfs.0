Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35379 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753695AbcH3AtA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 20:49:00 -0400
Subject: Re: btrfs send extremely slow (almost stuck)
To: Oliver Freyermuth <o.freyermuth@googlemail.com>,
        <linux-btrfs@vger.kernel.org>
References: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
 <6bebd709-8fdd-5e88-650d-f1c551946505@cn.fujitsu.com>
 <2926d118-6a2f-2066-529d-1dd8335200dc@googlemail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a7ead62b-38f5-2ed6-c24b-1960a8fc6ba8@cn.fujitsu.com>
Date: Tue, 30 Aug 2016 08:48:18 +0800
MIME-Version: 1.0
In-Reply-To: <2926d118-6a2f-2066-529d-1dd8335200dc@googlemail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/29/2016 06:02 PM, Oliver Freyermuth wrote:
> Am 29.08.2016 um 04:11 schrieb Qu Wenruo:
>> Unknown bug, while unfortunately no good idea to solve yet.
>>
>> I sent a RFC patch to completely disable shared extent detection, while
>> got strong objection.
>>
>> I also submitted some other ideas on fixing it, while still got strong
>> objection. Objection includes this is a performance problem, not a
>> function problem and we should focus on function problem first and
>> postpone such performance problem.
>>
>> And further more, Btrfs from the beginning of its design, focuses on
>> fast snapshot creation, and takes backref walk as sacrifice.
>> So it's not an easy thing to fix.
>
> As a user, I must say, thanks a lot for your work on this!
>
>>
>> I don't expect there will be even an agreement on how to fix the problem
>> in v4.1x.
>>
>> Fixes in send will lead to obvious speed improvement, while cause
>> incompatibility or super complex design.
>> Fixes in backref will lead to a backref rework, which normally comes
>> with new regression, and we are even unsure if it will really help.
>>
>> If you just hate the super slow send, and can accept the extra space
>> usage, please try this RFC patch:
>>
>> https://patchwork.kernel.org/patch/9245287/
>>
>>
>> This patch, just as its name, will completely stop same extent(reflink)
>> detection.
>> Which will cause more space usage, while it skipped the super time
>> consuming find_parent_nodes(), it should at least workaround your problem.
>
> If I interpret the code correctly, this only affects "btrfs send", and
> only causes "duplication" of previously shared extents, correct?

Yes.
And more specifically, it doesn't even affect delta backup.

For shared extents caused by reflink/dedupe(out-of-band or even incoming 
in-band), it will be send as individual files.

For contents, they are all the same, just more space usage.

>
> Then this is for me (as a user) perfectly fine - btrfs send should run
> much faster (< 3 hours instead of unusable 80 hours for my root volume)
> and I can just run duperemove on the readonly snapshots at the backup
> location later without issues (it's of course some extra I/O on disk and
> network, but at least it will be usable).

Nice to hear that.

>
>> I have some other idea to fix it with less aggressive idea, while since
>> there is objection against it, I didn't code it further.
>>
>> But, since there are *REAL* *WORLD* users reporting such problem, I
>> think I'd better restart the fix as an RFC.
>
> Thanks a lot, as a user I would certainly appreciate work in this area.
>
> I would not have expected that this really is a known issue,
> since I would have thought that btrfs send was commonly used for backup
> purposes, and offline deduplication on SSD drives especially on mobile
> devices to gain significant amount of space did not seem like an exotic
> usecase to me.
>
> So in short, I'm really suprised to be one of the first / few to
> complain about this as a user, I did not feel like my usecase was
> special or exotic (at least, up to now).

Not the first, but although still few.

There is a xfstest case submitted for it, and even before the test case, 
there are already report from IRC.

Anyway, I'll add Cc for you after the new IRC patch is out.

Thanks,
Qu

>
> Thanks a lot,
> 	Oliver
>
>
>> Thanks,
>> Qu
>
>


