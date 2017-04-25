Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52895 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S979281AbdDYGNh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 02:13:37 -0400
Subject: Re: Problem with file system
To: Marat Khalili <mkh@rqc.ru>, <linux-btrfs@vger.kernel.org>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com>
 <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com>
Date: Tue, 25 Apr 2017 14:13:29 +0800
MIME-Version: 1.0
In-Reply-To: <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/25/2017 01:33 PM, Marat Khalili wrote:
> On 25/04/17 03:26, Qu Wenruo wrote:
>> IIRC qgroup for subvolume deletion will cause full subtree rescan 
>> which can cause tons of memory. 
> Could it be this bad, 24GB of RAM for a 5.6TB volume? What does it even 
> use this absurd amount of memory for? Is it swappable?

The memory is used for 2 reasons.

1) Record which extents are needed to trace
    Freed at transaction commit.

    Need better idea to handle them. Maybe create a new tree so that we
    can write it to disk?
    Or another qgroup rework?

2) Record current roots referring to this extent
    Only after v4.10 IIRC.

The memory allocated is not swappable.

How many memory it uses depends on the number of extents of that subvolume.

It's 56 bytes for one extent, both tree block and data extent.
To use up 16G ram, it's about 300 million extents.
For 5.6T volume, its average extent size is about 20K.

It seems that your volume is highly fragmented though.

If that's the problem, disabling qgroup may be the best workaround.

Thanks,
Qu

> 
> Haven't read about RAM limitations for running qgroups before, only 
> about CPU load (which importantly only requires patience, does not crash 
> servers).
> 
> -- 
> 
> With Best Regards,
> Marat Khalili
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


