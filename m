Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35000 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbcHOOKY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 10:10:24 -0400
Received: by mail-io0-f171.google.com with SMTP id m101so80269764ioi.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 07:10:24 -0700 (PDT)
Subject: Re: About minimal device number for RAID5/6
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
 <d27bad69-1041-7771-aff6-c15beb85fbb1@gmail.com>
 <9fb53c9f-b6c1-6bb9-8c3b-7147b64b601f@oracle.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a12a63d2-1710-611b-7d94-35db3a2aaa3d@gmail.com>
Date: Mon, 15 Aug 2016 10:10:01 -0400
MIME-Version: 1.0
In-Reply-To: <9fb53c9f-b6c1-6bb9-8c3b-7147b64b601f@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-15 10:08, Anand Jain wrote:
>
>
>>> IMHO it's better to warn user about 2 devices RAID5 or 3 devices RAID6.
>>>
>>> Any comment is welcomed.
>>>
>> Based on looking at the code, we do in fact support 2/3 devices for
>> raid5/6 respectively.
>>
>> Personally, I agree that we should warn when trying to do this, but I
>> absolutely don't think we should stop it from happening.
>
>
>  How does 2 disks RAID5 work ?
One disk is your data, the other is your parity.  In essence, it works 
like a really computationally expensive version of RAID1 with 2 disks, 
which is why it's considered a degenerate configuration.  Three disks in 
RAID6 is similar, but has a slight advantage at the moment in BTRFS 
because it's the only way to configure three disks so you can lose two 
and not lose any data as we have no support for higher order replication 
than 2 copies yet.
