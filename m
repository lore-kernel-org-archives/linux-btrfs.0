Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:44934 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753445AbdKRBP2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 20:15:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sat, 18 Nov 2017 10:15:23 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 4.14 balance: kernel BUG at
 /home/kernel/COD/linux/fs/btrfs/ctree.c:1856!
In-Reply-To: <5000f429-8b4b-b4ea-5e38-89f7c91af6f3@mendix.com>
References: <e01cb2f95b44b7648855a4fe5070fd10@wpkg.org>
 <5000f429-8b4b-b4ea-5e38-89f7c91af6f3@mendix.com>
Message-ID: <bbe5a5f53efffcd38db8de92f519beca@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-18 10:08, Hans van Kranenburg wrote:
> On 11/18/2017 01:49 AM, Tomasz Chmielewski wrote:
>> I'm getting the following BUG when running balance on one of my 
>> systems:
>> 
>> 
>> [ 3458.698704] BTRFS info (device sdb3): relocating block group
>> 306045779968 flags data|raid1
>> [ 3466.892933] BTRFS info (device sdb3): found 2405 extents
>> [ 3495.408630] BTRFS info (device sdb3): found 2405 extents
>> [ 3498.161144] ------------[ cut here ]------------
>> [ 3498.161150] kernel BUG at 
>> /home/kernel/COD/linux/fs/btrfs/ctree.c:1856!
>> [ 3498.161264] invalid opcode: 0000 [#1] SMP

(...)

>> [ 3498.164523] Call Trace:
>> [ 3498.164694]  tree_advance+0x16e/0x1d0 [btrfs]
>> [ 3498.164874]  btrfs_compare_trees+0x2da/0x6a0 [btrfs]
>> [ 3498.165078]  ? process_extent+0x1580/0x1580 [btrfs]
>> [ 3498.165264]  btrfs_ioctl_send+0xe94/0x1120 [btrfs]
> 
> It's using send + balance at the same time. There's something that 
> makes
> btrfs explode when you do that.
> 
> It's not new in 4.14, I have seen it in 4.7 and 4.9 also, various
> different explosions in kernel log. Since that happened, I made sure I
> never did those two things at the same time.

Indeed, send was started when balance was running.

Thanks for the hint.


Tomasz Chmielewski
https://lxadm.com
