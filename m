Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36721 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbcHOPCD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 11:02:03 -0400
Received: by mail-io0-f180.google.com with SMTP id b62so81597155iod.3
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 08:02:02 -0700 (PDT)
Subject: Re: About minimal device number for RAID5/6
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
 <d27bad69-1041-7771-aff6-c15beb85fbb1@gmail.com>
 <9fb53c9f-b6c1-6bb9-8c3b-7147b64b601f@oracle.com>
 <a12a63d2-1710-611b-7d94-35db3a2aaa3d@gmail.com>
 <089d5900-8915-bf74-ffb3-044be11b04ae@oracle.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d89bf137-096e-b524-74c6-7568b34c7b5a@gmail.com>
Date: Mon, 15 Aug 2016 11:01:38 -0400
MIME-Version: 1.0
In-Reply-To: <089d5900-8915-bf74-ffb3-044be11b04ae@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-15 10:32, Anand Jain wrote:
>
>
> On 08/15/2016 10:10 PM, Austin S. Hemmelgarn wrote:
>> On 2016-08-15 10:08, Anand Jain wrote:
>>>
>>>
>>>>> IMHO it's better to warn user about 2 devices RAID5 or 3 devices
>>>>> RAID6.
>>>>>
>>>>> Any comment is welcomed.
>>>>>
>>>> Based on looking at the code, we do in fact support 2/3 devices for
>>>> raid5/6 respectively.
>>>>
>>>> Personally, I agree that we should warn when trying to do this, but I
>>>> absolutely don't think we should stop it from happening.
>>>
>>>
>>>  How does 2 disks RAID5 work ?
>> One disk is your data, the other is your parity.
>
>
>> In essence, it works
>> like a really computationally expensive version of RAID1 with 2 disks,
>> which is why it's considered a degenerate configuration.
>
>    How do you generate parity with only one data ?
You treat the data as a stripe of width 1.  That's really all there is 
to it, it's just the same as using 3 or 4 or 5 disks, just with a 
smaller stripe size.

In other systems, 4 is the minimum disk count for RAID5.  I'm not sure 
why they usually disallow 3 disks (it's perfectly legitimate usage, it's 
just almost never seen in practice (largely because nothing supports it 
and erasure coding only makes sense from an economic perspective when 
dealing with lots of data)), but they disallow 2 because it gives no 
benefit over RAID1 with 2 copies and gives worse performance, not 
because the math doesn't work with 2 disks.
