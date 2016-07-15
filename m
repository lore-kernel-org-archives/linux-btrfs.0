Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32729 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751312AbcGOTf1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 15:35:27 -0400
Subject: Re: A lot warnings in dmesg while running thunderbird
To: Gabriel C <nix.or.die@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
CC: <quwenruo@cn.fujitsu.com>
From: Chris Mason <clm@fb.com>
Message-ID: <50805ba8-2681-8606-79b3-add5b47b864f@fb.com>
Date: Fri, 15 Jul 2016 15:35:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/07/2016 06:24 AM, Gabriel C wrote:
> Hi,
>
> while running thunderbird on linux 4.6.3 and 4.7.0-rc6 ( didn't tested
> other versions )
> I trigger the following :
>
>
> [ 6393.305675] WARNING: CPU: 6 PID: 5870 at fs/btrfs/inode.c:9306
> btrfs_destroy_inode+0x22e/0x2a0 [btrfs]

Every time I've reproduced this, I've hit a warning in extent-tree.c 
about trying to decrement bytes_may_use too far.  Then I get enospc
on every operation.

Josef fixed a few corner cases here with his new enospc changes, and I'm 
not able to trigger (yet) with those applied.  Dave Sterba has them all 
in his for-next branch:

git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next

Can you please try that on top of v4.7-rc7

-chris
