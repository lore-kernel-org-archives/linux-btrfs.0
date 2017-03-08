Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63473 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750770AbdCHHj4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 02:39:56 -0500
Subject: Re: [PATCH v3 0/7] Chunk level degradable check
To: Adam Borowski <kilobyte@angband.pl>
References: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
 <20170308064720.o5j24elapzjc5loz@angband.pl>
CC: <linux-btrfs@vger.kernel.org>, <anand.jain@oracle.com>,
        <demfloro@demfloro.ru>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <40bfe74e-ff6c-9efe-9dcb-381855654b40@cn.fujitsu.com>
Date: Wed, 8 Mar 2017 15:39:07 +0800
MIME-Version: 1.0
In-Reply-To: <20170308064720.o5j24elapzjc5loz@angband.pl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/08/2017 02:47 PM, Adam Borowski wrote:
> On Wed, Mar 08, 2017 at 10:41:17AM +0800, Qu Wenruo wrote:
>> This patchset will introduce a new per-chunk degradable check for
>> btrfs, allow above case to succeed, and it's quite small anyway.
>
>> v3:
>>   Remove one duplicated missing device output
>>   Use the advice from Anand Jain, not to add new members in btrfs_device,
>>   but use a new structure extra_rw_degrade_errors, to record error when
>>   sending down/waiting device.
>>
>> Sorry Dmitrii Tcvetkov and Adam Borowski, I'm afraid I can't add your
>> tested-by tags in v3, as the 4th and 4th patches have quite a big change,
>> so you may need to retest the new patchset.
>
> Well, testing stuff is why we're here :)
>
> Re-tested, as far as your patch goes all is well.
>
>
> Looks like I found an unrelated bug, though, that messed with my testing.
> And it looks like a nasty one: once "btrfs dev scan" sees a disk, it stores
> its device and will then happily use it without verification even if it's
> been pulled out and replaced by something else.  Lemme investigate that
> later today.

It would be nice if you can send detailed info to mail list.

AFAIK, btrfs will check its superblock for devid and device UUID, to 
ensure that's the device we're using.

Thanks,
Qu


