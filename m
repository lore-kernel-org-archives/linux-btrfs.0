Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5760 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756090AbcHaByQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 21:54:16 -0400
Subject: Re: btrfs send extremely slow (almost stuck)
To: Jeff Mahoney <jeffm@suse.com>,
        Oliver Freyermuth <o.freyermuth@googlemail.com>,
        <linux-btrfs@vger.kernel.org>
References: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
 <6bebd709-8fdd-5e88-650d-f1c551946505@cn.fujitsu.com>
 <d7346353-8e61-27b1-df2f-aabcad0580f4@cn.fujitsu.com>
 <57C6345E.5010006@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9b5357b7-3cf0-81c8-0020-46a72944b7ed@cn.fujitsu.com>
Date: Wed, 31 Aug 2016 09:54:07 +0800
MIME-Version: 1.0
In-Reply-To: <57C6345E.5010006@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/31/2016 09:35 AM, Jeff Mahoney wrote:
> On 8/28/16 10:12 PM, Qu Wenruo wrote:
>>
>>
>> At 08/29/2016 10:11 AM, Qu Wenruo wrote:
>>>
>>>
>>> At 08/28/2016 11:38 AM, Oliver Freyermuth wrote:
>>>> Dear btrfs experts,
>>>>
>>>> I just tried to make use of btrfs send / receive for incremental
>>>> backups (using btrbk to simplify the process).
>>>> It seems that on my two machines, btrfs send gets stuck after
>>>> transferring some GiB - it's not fully halted, but instead of making
>>>> full use of the available I/O, I get something < 500 kiB on average,
>>>> which are just some "full speed spikes" with many seconds / minutes of
>>>> no I/O in between.
>>>>
>>>> During this "halting", btrfs send eats one full CPU core.
>>>> A "perf top" shows this is spent in "find_parent_nodes" and
>>>> "__merge_refs" inside the kernel.
>>>> I am using btrfs-progs 4.7 and kernel 4.7.0.
>>>
>>> Unknown bug, while unfortunately no good idea to solve yet.
>>
>> Sorry, known bug, not unknown....
>
> I'm working on a patch to replace the lists with a pair of trees that
> get merged after filling in the missing parents.
>
Wow, nice.
I was planning to do it but didn't get started yet.

The list is really causing the problem.
Converting to rb_tree should at least reduce the O(n^3)~O(n^4)
to O(n^2logn).


While the backref walk call in the loop of iterating every file extents 
is never a good idea for me, I'll still try to fix at the send side as 
an RFC patch too.

Thanks,
Qu

> The reflink xfstests don't complete, ever.  btrfs/130 triggers soft
> lockups but do complete eventually -- and that's only with ~4k list
> elements.
>
> -Jeff
>



