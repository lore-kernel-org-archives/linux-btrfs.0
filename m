Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17723 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751141AbdEJDJt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 23:09:49 -0400
Subject: Re: btrfsck lowmem mode shows corruptions
To: Kai Krakow <hurikhan77@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <20170504192936.5820aa76@jupiter.sol.kaishome.de>
 <37157561-b48c-bde2-cf8f-c15e8fbf38d3@cn.fujitsu.com>
 <20170505201540.2585c1a4@jupiter.sol.kaishome.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <69725afc-3732-736f-6e3c-3ae32fce59d4@cn.fujitsu.com>
Date: Wed, 10 May 2017 11:09:43 +0800
MIME-Version: 1.0
In-Reply-To: <20170505201540.2585c1a4@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/06/2017 02:15 AM, Kai Krakow wrote:
> Am Fri, 5 May 2017 08:55:10 +0800
> schrieb Qu Wenruo <quwenruo@cn.fujitsu.com>:
> 
>> At 05/05/2017 01:29 AM, Kai Krakow wrote:
>>> Hello!
>>>
>>> Since I saw a few kernel freezes lately (due to experimenting with
>>> ck-sources) including some filesystem-related backtraces, I booted
>>> my rescue system to check my btrfs filesystem.
>>>
>>> Luckily, it showed no problems. It said, everything's fine. But I
>>> also thought: Okay, let's try lowmem mode. And that showed a
>>> frightening long list of extent corruptions und unreferenced
>>> chunks. Should I worry?
>>
>> Thanks for trying lowmem mode.
>>
>> Would you please provide the version of btrfs-progs?
> 
> Sorry... I realized it myself the moment I hit the "send" button.
> 
> Here it is:
> 
> # btrfs version
> btrfs-progs v4.10.2
> 
> # uname -a
> Linux jupiter 4.10.13-ck #2 SMP PREEMPT Thu May 4 23:44:09 CEST 2017
> x86_64 Intel(R) Core(TM) i5-2500K CPU @ 3.30GHz GenuineIntel GNU/Linux
> 
>> IIRC "ERROR: data extent[96316809216 2097152] backref lost" bug has
>> been fixed in recent release.
> 
> Is there a patch I could apply?

That's strange, btrfs-progs v4.10.2 has already shipped the fix:
ad60ed92d1e0edca2769754c3a50129571a0e49d btrfs-progs: check: lowmem, fix 
false alert about backref lost for SHARED_DATA_REF

Then it's a another bug now.

> 
>> And for reference, would you please provide the tree dump of your
>> chunk and device tree?
>>
>> This can be done by running:
>> # btrfs-debug-tree -t device <device>
>> # btrfs-debug-tree -t chunk <device>
> 
> I'll attach those...
> 
> I'd like to note that between the OP and these dumps, I scrubbed and
> rebalanced the hole device. I think that would scramble up some
> numbers. Also I took the dumps while the fs was online.

Online is not a big problem.
But rebalance really changed the number, making it quite hard to
use the dump to match with previous check error output.

I'll try to make a script to filter the output, but first several chunk 
matches with its dev extent tree.

So I'd better digging the lowmem check code to find the problem.

Thanks for the report anyway,
Qu

> 
> If you want me to do clean dumps of the offline device without
> intermediate fs processing, let me know.
> 
> Thanks,
> Kai
> 
>> And this 2 dump only contains the btrfs chunk mapping info, so
>> nothing sensitive is contained.
>>
>> Thanks,
>> Qu
>>>
>>> PS: The freezes seem to be related to bfq, switching to deadline
>>> solved these.
>>>
>>> Full log attached, here's an excerpt:
>>>
>>> ---8<---
>>>
>>> checking extents
>>> ERROR: chunk[256 4324327424) stripe 0 did not find the related dev
>>> extent ERROR: chunk[256 4324327424) stripe 1 did not find the
>>> related dev extent ERROR: chunk[256 4324327424) stripe 2 did not
>>> find the related dev extent ERROR: chunk[256 7545552896) stripe 0
>>> did not find the related dev extent ERROR: chunk[256 7545552896)
>>> stripe 1 did not find the related dev extent ERROR: chunk[256
>>> 7545552896) stripe 2 did not find the related dev extent [...]
>>> ERROR: device extent[1, 1094713344, 1073741824] did not find the
>>> related chunk ERROR: device extent[1, 2168455168, 1073741824] did
>>> not find the related chunk ERROR: device extent[1, 3242196992,
>>> 1073741824] did not find the related chunk [...]
>>> ERROR: device extent[2, 608854605824, 1073741824] did not find the
>>> related chunk ERROR: device extent[2, 609928347648, 1073741824] did
>>> not find the related chunk ERROR: device extent[2, 611002089472,
>>> 1073741824] did not find the related chunk [...]
>>> ERROR: device extent[3, 64433946624, 1073741824] did not find the
>>> related chunk ERROR: device extent[3, 65507688448, 1073741824] did
>>> not find the related chunk ERROR: device extent[3, 66581430272,
>>> 1073741824] did not find the related chunk [...]
>>> ERROR: data extent[96316809216 2097152] backref lost
>>> ERROR: data extent[96316809216 2097152] backref lost
>>> ERROR: data extent[96316809216 2097152] backref lost
>>> ERROR: data extent[686074396672 13737984] backref lost
>>> ERROR: data extent[686074396672 13737984] backref lost
>>> ERROR: data extent[686074396672 13737984] backref lost
>>> [...]
>>> ERROR: errors found in extent allocation tree or chunk allocation
>>> checking free space cache
>>> checking fs roots
>>> ERROR: errors found in fs roots
>>> Checking filesystem on /dev/disk/by-label/system
>>> UUID: bc201ce5-8f2b-4263-995a-6641e89d4c88
>>> found 1960075935744 bytes used, error(s) found
>>> total csum bytes: 1673537040
>>> total tree bytes: 4899094528
>>> total fs tree bytes: 2793914368
>>> total extent tree bytes: 190398464
>>> btree space waste bytes: 871743708
>>> file data blocks allocated: 6907169177600
>>>    referenced 1979268648960
>>>    
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> 


