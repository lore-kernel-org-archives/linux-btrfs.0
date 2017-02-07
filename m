Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34591 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752534AbdBGAWf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 19:22:35 -0500
Subject: Re: Very slow balance / btrfs-transaction
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, Jorg Bornschein <jb@capsec.org>,
        <linux-btrfs@vger.kernel.org>
References: <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
 <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
 <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
 <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
 <f9e2b226440e4f6e17e61ce86eecc7eb@88cbed2449cf>
 <57259b63-2f26-0da4-16f6-5fbd781daeb0@cn.fujitsu.com>
 <4200a425-890f-b283-b43b-e5911b1c6d8c@suse.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <3c9ce5e2-6bc0-96d3-1d99-75f96e03afd1@cn.fujitsu.com>
Date: Tue, 7 Feb 2017 08:22:29 +0800
MIME-Version: 1.0
In-Reply-To: <4200a425-890f-b283-b43b-e5911b1c6d8c@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/07/2017 12:09 AM, Goldwyn Rodrigues wrote:
>
> Hi Qu,
>
> On 02/05/2017 07:45 PM, Qu Wenruo wrote:
>>
>>
>> At 02/04/2017 09:47 AM, Jorg Bornschein wrote:
>>> February 4, 2017 1:07 AM, "Goldwyn Rodrigues" <rgoldwyn@suse.de> wrote:
>
> <snipped>
>
>>>
>>>
>>> Quata support was indeed active -- and it warned me that the qroup
>>> data was inconsistent.
>>>
>>> Disabling quotas had an immediate impact on balance throughput -- it's
>>> *much* faster now!
>>> From a quick glance at iostat I would guess it's at least a factor 100
>>> faster.
>>>
>>>
>>> Should quota support generally be disabled during balances? Or did I
>>> somehow push my fs into a weired state where it triggered a slow-path?
>>>
>>>
>>>
>>> Thanks!
>>>
>>>    j
>>
>> Would you please provide the kernel version?
>>
>> v4.9 introduced a bad fix for qgroup balance, which doesn't completely
>> fix qgroup bytes leaking, but also hugely slow down the balance process:
>>
>> commit 62b99540a1d91e46422f0e04de50fc723812c421
>> Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Date:   Mon Aug 15 10:36:51 2016 +0800
>>
>>     btrfs: relocation: Fix leaking qgroups numbers on data extents
>>
>> Sorry for that.
>>
>> And in v4.10, a better method is applied to fix the byte leaking
>> problem, and should be a little faster than previous one.
>>
>> commit 824d8dff8846533c9f1f9b1eabb0c03959e989ca
>> Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Date:   Tue Oct 18 09:31:29 2016 +0800
>>
>>     btrfs: qgroup: Fix qgroup data leaking by using subtree tracing
>>
>>
>> However, using balance with qgroup is still slower than balance without
>> qgroup, the root fix needs us to rework current backref iteration.
>>
>
> This patch has made the btrfs balance performance worse. The balance
> task has become more CPU intensive compared to earlier and takes longer
> to complete, besides hogging resources. While correctness is important,
> we need to figure out how this can be made more efficient.
>
The cause is already known.

It's find_parent_node() which takes most of the time to find all 
referencer of an extent.

And it's also the cause for FIEMAP softlockup (fixed in recent release 
by early quit).

The biggest problem is, current find_parent_node() uses list to iterate, 
which is quite slow especially it's done in a loop.
In real world find_parent_node() is about O(n^3).
We can either improve find_parent_node() by using rb_tree, or introduce 
some cache for find_parent_node().


IIRC SUSE guys(maybe Jeff?) are working on it with the first method, but 
I didn't hear anything about it recently.

Thanks,
Qu


