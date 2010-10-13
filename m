From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] btrfs: Switching the extent buffer rbtree into a
 unlock radix tree
Date: Wed, 13 Oct 2010 10:17:22 +0800
Message-ID: <4CB516B2.10809@cn.fujitsu.com>
References: <4CB42DB2.5080906@cn.fujitsu.com> <20101012184323.GU22691@think>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101012184323.GU22691@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 12 Oct 2010 14:43:23 -0400, Chris Mason wrote:
> On Tue, Oct 12, 2010 at 05:43:14PM +0800, Miao Xie wrote:
>> This patch reduces the CPU time spent in the extent buffer search by using the
>> radix tree instead of the rbtree and using the rcu lock instead of the spin
>> lock.
>>
>> I did a quick test by the benchmark tool[1] and found the patch improve the
>> file creation/deletion performance problem that I have reported[2].
>
> Thanks, this is much smaller than I expected.  I'll hammer on it here.

By the way, I found we had 16T limit on 32-bits machines, because the page cache
of 32-bits machines can only manage 16T data, and the btrfs metadata is cached
in the page cache.

Regards
Miao
