Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49579 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751328AbdJYGy3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Oct 2017 02:54:29 -0400
Subject: Re: check: "warning line 4144"
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <82b863c8-ef92-736c-2a9d-51102db07919@hale.ee>
 <c9a41b3b-16d8-e504-bfd1-79295cc465a7@gmx.com>
From: Tom Hale <tom@hale.ee>
Message-ID: <101d5f86-acd1-8d94-4d10-df49335465dc@hale.ee>
Date: Wed, 25 Oct 2017 13:54:25 +0700
MIME-Version: 1.0
In-Reply-To: <c9a41b3b-16d8-e504-bfd1-79295cc465a7@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19/10/17 15:58, Qu Wenruo wrote:
> On 2017年10月19日 16:53, Tom Hale wrote:
>> In running btrfs check, I got the following message:
>>
>>     warning line 4144
>>
>> Could this be a little more descriptive?
>>
>> * Does it mean I should rebuild my FS from scratch?
>> * Is there anything I can do to remove this warning?
>>
> 
> --repair is dangerous, use it unless you're sure the problem can be
> fixed by it.
> 
> What's the output of "btrfs check" and "btrfs check --mode=lowmem" after
> doing the repair?

Plain `btrfs check` gives me:

checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/mapper/vg_svelte-home
UUID: 93722fa7-7e8f-418a-a7ca-080aca8db94b
found 192318169092 bytes used, no error found
total csum bytes: 185482112
total tree bytes: 1924104192
total fs tree bytes: 1597767680
total extent tree bytes: 102514688
btree space waste bytes: 325265468
file data blocks allocated: 6169163599872
 referenced 575636733952

Could somebody please answer my initial questions about this obscure
warning?

Thanks,

-- 
Tom Hale
