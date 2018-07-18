Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:42216 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729374AbeGRNN1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 09:13:27 -0400
Received: by mail-io0-f178.google.com with SMTP id g11-v6so3927900ioq.9
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 05:35:43 -0700 (PDT)
Subject: Re: Healthy amount of free space?
To: Martin Steigerwald <martin@lichtvoll.de>,
        Nikolay Borisov <nborisov@suse.com>
Cc: Wolf <wolf@wolfsden.cz>, linux-btrfs@vger.kernel.org
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz>
 <2197534.TZSffJRfLT@merkaba> <9ea19b13-3c46-666f-fa79-f40bd1ae7658@suse.com>
 <1736761.B5nO4FXixV@merkaba>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <33396c10-33ef-b8ff-0041-c94d87c67722@gmail.com>
Date: Wed, 18 Jul 2018 08:35:40 -0400
MIME-Version: 1.0
In-Reply-To: <1736761.B5nO4FXixV@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-17 13:54, Martin Steigerwald wrote:
> Nikolay Borisov - 17.07.18, 10:16:
>> On 17.07.2018 11:02, Martin Steigerwald wrote:
>>> Nikolay Borisov - 17.07.18, 09:20:
>>>> On 16.07.2018 23:58, Wolf wrote:
>>>>> Greetings,
>>>>> I would like to ask what what is healthy amount of free space to
>>>>> keep on each device for btrfs to be happy?
>>>>>
>>>>> This is how my disk array currently looks like
>>>>>
>>>>>      [root@dennas ~]# btrfs fi usage /raid
>>>>>      
>>>>>      Overall:
>>>>>          Device size:                  29.11TiB
>>>>>          Device allocated:             21.26TiB
>>>>>          Device unallocated:            7.85TiB
>>>>>          Device missing:                  0.00B
>>>>>          Used:                         21.18TiB
>>>>>          Free (estimated):              3.96TiB      (min: 3.96TiB)
>>>>>          Data ratio:                       2.00
>>>>>          Metadata ratio:                   2.00
>>>>>          Global reserve:              512.00MiB      (used: 0.00B)
>>>
>>> […]
>>>
>>>>> Btrfs does quite good job of evenly using space on all devices.
>>>>> No,
>>>>> how low can I let that go? In other words, with how much space
>>>>> free/unallocated remaining space should I consider adding new
>>>>> disk?
>>>>
>>>> Btrfs will start running into problems when you run out of
>>>> unallocated space. So the best advice will be monitor your device
>>>> unallocated, once it gets really low - like 2-3 gb I will suggest
>>>> you run balance which will try to free up unallocated space by
>>>> rewriting data more compactly into sparsely populated block
>>>> groups. If after running balance you haven't really freed any
>>>> space then you should consider adding a new drive and running
>>>> balance to even out the spread of data/metadata.
>>>
>>> What are these issues exactly?
>>
>> For example if you have plenty of data space but your metadata is full
>> then you will be getting ENOSPC.
> 
> Of that one I am aware.
> 
> This just did not happen so far.
> 
> I did not yet add it explicitly to the training slides, but I just make
> myself a note to do that.
> 
> Anything else?

If you're doing a training presentation, it may be worth mentioning that 
preallocation with fallocate() does not behave the same on BTRFS as it 
does on other filesystems.  For example, the following sequence of commands:

     fallocate -l X ./tmp
     dd if=/dev/zero of=./tmp bs=1 count=X

Will always work on ext4, XFS, and most other filesystems, for any value 
of X between zero and just below the total amount of free space on the 
filesystem.  On BTRFS though, it will reliably fail with ENOSPC for 
values of X that are greater than _half_ of the total amount of free 
space on the filesystem (actually, greater than just short of half).  In 
essence, preallocating space does not prevent COW semantics for the 
first write unless the file is marked NOCOW.

