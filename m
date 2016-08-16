Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34074 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbcHPMIt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 08:08:49 -0400
Received: by mail-io0-f176.google.com with SMTP id q83so105092867iod.1
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Aug 2016 05:08:48 -0700 (PDT)
Subject: Re: About minimal device number for RAID5/6
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Anand Jain <anand.jain@oracle.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
 <d27bad69-1041-7771-aff6-c15beb85fbb1@gmail.com>
 <9fb53c9f-b6c1-6bb9-8c3b-7147b64b601f@oracle.com>
 <a12a63d2-1710-611b-7d94-35db3a2aaa3d@gmail.com>
 <e2b165ec-4a82-6550-82d0-46352a32c3b8@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a995f4fc-0c42-d346-07e3-9d764d2bf9e9@gmail.com>
Date: Tue, 16 Aug 2016 08:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <e2b165ec-4a82-6550-82d0-46352a32c3b8@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-15 21:32, Qu Wenruo wrote:
>
>
> At 08/15/2016 10:10 PM, Austin S. Hemmelgarn wrote:
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
>> One disk is your data, the other is your parity.  In essence, it works
>> like a really computationally expensive version of RAID1 with 2 disks,
>> which is why it's considered a degenerate configuration.
>
> I totally agree with the fact that 2 disk raid5 is just a slow raid1.
>
>>  Three disks in
>> RAID6 is similar, but has a slight advantage at the moment in BTRFS
>> because it's the only way to configure three disks so you can lose two
>> and not lose any data as we have no support for higher order replication
>> than 2 copies yet.
>
> It's true that btrfs doesn't support any other raid level which can
> provide 2 parities.
>
> But the use case to gain the ability to lose 2 disks in a 3 disk raid6
> setup seems more like a trick other than normal use case.
It absolutely is a trick, but until we have support for more than 2 
copies in raid1 mode, it is also an absolutely legitimate use case.
>
> Either in mkfs man page, or warning at mkfs time (but still allowing to
> do it), IMHO it's better to tell user "yes, you can do it, but it's not
> a really good idea"
Agreed.

