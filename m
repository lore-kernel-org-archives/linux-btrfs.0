Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpcmd13146.aruba.it ([62.149.156.146]:51685 "EHLO
        smtpcmd13146.aruba.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbdINKYi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 06:24:38 -0400
Subject: Re: Workqueue: events_unbound btrfs_async_reclaim_metadata_space
 [btrfs]
To: Peter Becker <floyd.net@gmail.com>
Cc: bo.li.liu@oracle.com, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <737e0bff-dad1-d779-4de8-46f8995d5f42@prismatelecomtesting.com>
 <20170905162718.GC14677@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <315fef6d-e60a-3155-e10c-bebdf21cb55a@prismatelecomtesting.com>
 <CAEtw4r0By7Gmdo6=yFKi2t6LyKHAOygKdMW-+2OUkQ041zWZ7Q@mail.gmail.com>
 <ed7cf7b6-e848-e581-e079-6c0cec383140@prismatelecomtesting.com>
 <CAEtw4r0vY0SanSuLfx1+TKbxY7h85wZTf6TKOhV_j-+exWCG0w@mail.gmail.com>
From: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Message-ID: <6c834de2-10a4-2bb6-0276-41026dfb80c1@prismatelecomtesting.com>
Date: Thu, 14 Sep 2017 12:24:36 +0200
MIME-Version: 1.0
In-Reply-To: <CAEtw4r0vY0SanSuLfx1+TKbxY7h85wZTf6TKOhV_j-+exWCG0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/09/2017 16:43, Peter Becker wrote:
> 2017-09-07 16:37 GMT+02:00 Marco Lorenzo Crociani
> <marcoc@prismatelecomtesting.com>:
> [...]
>> I got:
>>
>> 00-49:  1
>> 50-79:  0
>> 80-89:  0
>> 90-99:  1
>> 100:    25540
>>
>> this means that fs has only one block group used under 50% and 1 between 90
>> and 99% while the rest are all full?
>>
> 
> yes .. imo, balance wouldn't help
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi,
after
btrfs balance start -musage=50 /data/R6HW/
and
btrfs balance start -musage=99 /data/R6HW/

I wasn't able to reproduce those messages.

Regards,

-- 
Marco Crociani
