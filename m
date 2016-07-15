Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50628 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbcGOVIz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 17:08:55 -0400
Subject: Re: A lot warnings in dmesg while running thunderbird
To: Gabriel C <nix.or.die@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <50805ba8-2681-8606-79b3-add5b47b864f@fb.com>
CC: <quwenruo@cn.fujitsu.com>
From: Chris Mason <clm@fb.com>
Message-ID: <a17a5af4-cf5e-cb4e-de09-4aeb8282e891@fb.com>
Date: Fri, 15 Jul 2016 17:08:37 -0400
MIME-Version: 1.0
In-Reply-To: <50805ba8-2681-8606-79b3-add5b47b864f@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/15/2016 03:35 PM, Chris Mason wrote:
>
>
> On 07/07/2016 06:24 AM, Gabriel C wrote:
>> Hi,
>>
>> while running thunderbird on linux 4.6.3 and 4.7.0-rc6 ( didn't tested
>> other versions )
>> I trigger the following :
>>
>>
>> [ 6393.305675] WARNING: CPU: 6 PID: 5870 at fs/btrfs/inode.c:9306
>> btrfs_destroy_inode+0x22e/0x2a0 [btrfs]
>
> Every time I've reproduced this, I've hit a warning in extent-tree.c
> about trying to decrement bytes_may_use too far.  Then I get enospc
> on every operation.
>
> Josef fixed a few corner cases here with his new enospc changes, and I'm
> not able to trigger (yet) with those applied.  Dave Sterba has them all
> in his for-next branch:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
>
> Can you please try that on top of v4.7-rc7

A few hours later and it reproduced on this kernel too.  What must be 
happening is we're freeing too many bytes from bytes_may_use.

I'll get tracing in and nail it down.

-chris
