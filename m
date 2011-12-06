From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [GIT PULL] Btrfs updates
Date: Tue, 06 Dec 2011 11:25:54 +0800
Message-ID: <4EDD8B42.1060700@cn.fujitsu.com>
References: <20111201153955.GL5587@shiny> <4EDC7C89.6050803@cn.fujitsu.com> <20111205131413.GC26622@shiny>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111205131413.GC26622@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 5 Dec 2011 08:14:13 -0500, Chris Mason wrote:
> On Mon, Dec 05, 2011 at 04:10:49PM +0800, Miao Xie wrote:
>> Hi, Chris and Oliva
>>
>> On thu, 1 Dec 2011 10:39:55 -0500, Chris Mason wrote:
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
>>>
>>> Has our current set of fixes.  This is fairly small, Alexandre Oliva has
>>> been chasing problems in our block allocator and kicked out important
>>> fixes.
>>>
>>> Jan Schmidt fixed a merge error in the raid repair code, we're now
>>> properly repairing failed blocks (io errors or crc errors) without
>>> having to run a scrub.
>>>
>>> Alexandre Oliva (5) commits (+8/-8):
>>>     Btrfs: skip block groups without enough space for a cluster (+1/-1)
>>
>> This patch introduce a bug that we can not allocate blocks from the cluster
>> with enough space and it may make the block allocation fail.
>>
>> This is because the check that the above patch introduced make the allocator
>> skip the cluster allocation, and jump to the uncluster allocation without
>> reclaiming all the blocks in the cluster, At this time, if all the free space
>> is in the cluster, and no space in the block group, the allocation will fail.
>> (we can trigger this bug on SSD.)
>>
>> Fortunately, the following patch written by Oliva can fix this bug.
>>
>> [PATCH 08/20] Btrfs: try to allocate from cluster even at LOOP_NO_EMPTY_SIZE
> 
> Thanks, I'll push this 08/20 out as well.

I'm sorry for my careless test.
I tested it again just now, I found the above patch could not fix the bug completely,
we still need

  [PATCH 16/20] Btrfs: try cluster but don't advance in search list

After applying these two patch, all my test can pass.

Thanks
Miao
