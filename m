Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56751 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab3AWKUB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 05:20:01 -0500
Message-ID: <50FFB978.3060802@cn.fujitsu.com>
Date: Wed, 23 Jan 2013 18:20:40 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
Subject: Re: [PATCH 1/5] Btrfs: fix repeated delalloc work allocation
References: <50FE6E9C.2040803@cn.fujitsu.com> <20130122142414.GA15978@liubo> <50FF50EF.9010907@cn.fujitsu.com> <20130123035647.GB17162@liubo.jp.oracle.com> <50FF6AC1.6030602@cn.fujitsu.com> <20130123060618.GC17162@liubo.jp.oracle.com> <50FF8437.3010703@cn.fujitsu.com> <20130123081751.GF17162@liubo.jp.oracle.com> <50FFA633.1070101@cn.fujitsu.com> <20130123095132.GA31998@liubo.jp.oracle.com>
In-Reply-To: <20130123095132.GA31998@liubo.jp.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 23 Jan 2013 17:52:14 +0800, Liu Bo wrote:
> On Wed, Jan 23, 2013 at 04:58:27PM +0800, Miao Xie wrote:
>> On wed, 23 Jan 2013 16:17:53 +0800, Liu Bo wrote:
>>> On Wed, Jan 23, 2013 at 02:33:27PM +0800, Miao Xie wrote:
>>>> On wed, 23 Jan 2013 14:06:21 +0800, Liu Bo wrote:
>>>>> On Wed, Jan 23, 2013 at 12:44:49PM +0800, Miao Xie wrote:
>>>>>> No, we can't. The other tasks which flush the delalloc data may remove the inode
>>>>>> from the delalloc list/splice list. If we release the lock, we will meet the race
>>>>>> between list traversing and list_del().
>>>>>
>>>>> OK, then please merge patch 1 and 4 so that we can backport 1 less patch
>>>>> at least.
>>>>
>>>> I don't think we should merge these two patch because they do two different things - one
>>>> is bug fix, and the other is just a improvement, and this improvement changes the logic
>>>> of the code and might be argumentative for some developers. So 2 patches is  better than one,
>>>> I think.
>>>
>>> Sorry, this is right only when patch 1 really fixes the problem Alex reported.
>>>
>>> But the fact is
>>>
>>> 1)  patch 1 is not enough to fix the bug, it just fixes the OOM of
>>> allocating 'struct btrfs_delalloc_work' while the original OOM of allocating
>>> requests remains.  We can still get the same inode over and over again
>>> and then stuck in btrfs_start_delalloc_inodes() because we 'goto again' to
>>> make sure we flush all inodes listed in fs_info->delalloc_inodes.
>>>
>>> 2)  patch 4 fixes 1)'s problems by removing 'goto again'.
>>>
>>> Am I missing something?
>>
>> In fact, there are two different problems.
>> One is OOM bug. it is a serious problem and also is an regression, so we should fix it
>> as soon as possible.
>> The other one is that we may fetch the same inode again and again if someone write data
>> into it endlessly. This problem is not so urgent to deal with. and perhaps some developers
>> think it is not a problem, we should flush that inode since there are dirty pages in it.
>> So we need split it from the patch of the 1st problem.
> 
> All right, I'm ok with this.
> 
> But the TWO different problems are both due to fetching the same inode more
> than once, and the solutions are indeed same, "fetch every inode on
> the list just once", and they are in the same code.

I forgot to say that the first problem can happen even though no task writes data into
the file after we start to flush the delalloc inodes.

Thanks
Miao

> 
> It is definitely a bug/problem if any users complains about their box
> getting stuck.  It is KERNEL that should be blamed.
> 
> thanks,
> liubo
> 

