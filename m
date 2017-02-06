Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16534 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752068AbdBFBpM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Feb 2017 20:45:12 -0500
Subject: Re: Very slow balance / btrfs-transaction
To: Jorg Bornschein <jb@capsec.org>, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        <linux-btrfs@vger.kernel.org>
References: <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
 <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
 <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
 <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
 <f9e2b226440e4f6e17e61ce86eecc7eb@88cbed2449cf>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <57259b63-2f26-0da4-16f6-5fbd781daeb0@cn.fujitsu.com>
Date: Mon, 6 Feb 2017 09:45:01 +0800
MIME-Version: 1.0
In-Reply-To: <f9e2b226440e4f6e17e61ce86eecc7eb@88cbed2449cf>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/04/2017 09:47 AM, Jorg Bornschein wrote:
> February 4, 2017 1:07 AM, "Goldwyn Rodrigues" <rgoldwyn@suse.de> wrote:
>
>> On 02/03/2017 06:30 PM, Jorg Bornschein wrote:
>>
>>> February 3, 2017 11:26 PM, "Goldwyn Rodrigues" <rgoldwyn@suse.com> wrote:
>>>
>>> Hi,
>>>
>>> I'm currently running a balance (without any filters) on a 4 drives raid1 filesystem. The array
>>> contains 3 3TB drives and one 6TB drive; I'm running the rebalance because the 6TB drive recently
>>> replaced a 2TB drive.
>>>
>>> I know that balance is not supposed to be a fast operation, but this one is now running for ~6 days
>>> and it managed to balance ~18% (754 out of about 4250 chunks balanced (755 considered), 82% left)
>>> -- so I expect it to take another ~4 weeks.
>>>
>>> That seems excessively slow for ~8TiB of data.
>>>
>>> Is this expected behavior? In case it's not: Is there anything I can do to help debug it?
>>>> Do you have quotas enabled?
>>>
>>> I might have activated it when playing with "snapper" -- I remember using some quota command
>>> without knowing what it does.
>>>
>>> How can I check its active? Shall I just disable it wit "btrfs quota disable"?
>>
>> To check your quota limits:
>> # btrfs qgroup show <mountpoint>
>>
>> To disable
>> # btrfs quota disable <mountpoint>
>>
>> Yes, please check if disabling quotas makes a difference in execution
>> time of btrfs balance.
>
>
> Quata support was indeed active -- and it warned me that the qroup data was inconsistent.
>
> Disabling quotas had an immediate impact on balance throughput -- it's *much* faster now!
> From a quick glance at iostat I would guess it's at least a factor 100 faster.
>
>
> Should quota support generally be disabled during balances? Or did I somehow push my fs into a weired state where it triggered a slow-path?
>
>
>
> Thanks!
>
>    j

Would you please provide the kernel version?

v4.9 introduced a bad fix for qgroup balance, which doesn't completely 
fix qgroup bytes leaking, but also hugely slow down the balance process:

commit 62b99540a1d91e46422f0e04de50fc723812c421
Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date:   Mon Aug 15 10:36:51 2016 +0800

     btrfs: relocation: Fix leaking qgroups numbers on data extents

Sorry for that.

And in v4.10, a better method is applied to fix the byte leaking 
problem, and should be a little faster than previous one.

commit 824d8dff8846533c9f1f9b1eabb0c03959e989ca
Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date:   Tue Oct 18 09:31:29 2016 +0800

     btrfs: qgroup: Fix qgroup data leaking by using subtree tracing


However, using balance with qgroup is still slower than balance without 
qgroup, the root fix needs us to rework current backref iteration.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


