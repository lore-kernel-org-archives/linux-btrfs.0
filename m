Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62843 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751868AbcCUCQQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 22:16:16 -0400
Subject: Re: Btrfsck memory usage reduce idea
To: <dsterba@suse.cz>, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <56DD14B6.4070908@cn.fujitsu.com>
 <56DE8D1D.5050504@jp.fujitsu.com> <56DE9171.8040309@cn.fujitsu.com>
 <20160318181854.GF21722@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56EF595B.7080509@cn.fujitsu.com>
Date: Mon, 21 Mar 2016 10:15:55 +0800
MIME-Version: 1.0
In-Reply-To: <20160318181854.GF21722@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/03/18 19:18 +0100:
> On Tue, Mar 08, 2016 at 04:46:41PM +0800, Qu Wenruo wrote:
>>> 1. Could you tell me what you'd like to do?
>>>
>>>      a) Provide completely the same function with current
>>>         implementation by other, more efficient way.
>>
>> Same function, but less efficient.
>> It may takes longer time, more IO, but less memory.
>
> IOW, there will be two options for the use to choose from, right? That's
> what I'd expect. Be able to check the filesystem on a machine with less
> memory at the cost of IO, but also do the faster check on a different
> machine.
>

I was planning to use the new extent tree check to replace current one, 
as a rework.
Am I always reworking things? :)

The point that I didn't want to keep the current behavior is, the old 
one is just OK or OOM, no one would know if it will OOM until it happens.

But the new one would be much flex than current behavior.
As it fully uses the IO cache provided by kernel.

For machine with lot of memory, the whole IO will be cached except the 
first read.
Making the difference between new and old implementation quite small.

For machine with less memory or the fs is just too large, at least 
btrfsck won't cause OOM.


Another point is, the new implementation would be smaller and simpler.
For non performance critical case, the simpler code the better.

But that's not settled yet, maybe just like 
multi-snapshot+quota+rebalance case, the old implementation may be times 
faster on some special case.
So my teammate and I will keeps the old one until enough feedback.

Thanks,
Qu

>> And some error message will be output at different time.
>> E.g, error message for missing backref may be output at fs tree checking
>> time, instead of extent tree checking time.
>
> This is acceptable.
>
>


