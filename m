Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27940 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbcHOOa7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 10:30:59 -0400
Subject: Re: About minimal device number for RAID5/6
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
 <d27bad69-1041-7771-aff6-c15beb85fbb1@gmail.com>
 <9fb53c9f-b6c1-6bb9-8c3b-7147b64b601f@oracle.com>
 <a12a63d2-1710-611b-7d94-35db3a2aaa3d@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <089d5900-8915-bf74-ffb3-044be11b04ae@oracle.com>
Date: Mon, 15 Aug 2016 22:32:25 +0800
MIME-Version: 1.0
In-Reply-To: <a12a63d2-1710-611b-7d94-35db3a2aaa3d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/15/2016 10:10 PM, Austin S. Hemmelgarn wrote:
> On 2016-08-15 10:08, Anand Jain wrote:
>>
>>
>>>> IMHO it's better to warn user about 2 devices RAID5 or 3 devices RAID6.
>>>>
>>>> Any comment is welcomed.
>>>>
>>> Based on looking at the code, we do in fact support 2/3 devices for
>>> raid5/6 respectively.
>>>
>>> Personally, I agree that we should warn when trying to do this, but I
>>> absolutely don't think we should stop it from happening.
>>
>>
>>  How does 2 disks RAID5 work ?
> One disk is your data, the other is your parity.


>In essence, it works
> like a really computationally expensive version of RAID1 with 2 disks,
> which is why it's considered a degenerate configuration.

    How do you generate parity with only one data ?

-Anand


>  Three disks in
> RAID6 is similar, but has a slight advantage at the moment in BTRFS
> because it's the only way to configure three disks so you can lose two
> and not lose any data as we have no support for higher order replication
> than 2 copies yet.
