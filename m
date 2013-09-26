Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53789 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab3IZJ2s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 05:28:48 -0400
Message-ID: <5243FE86.1000509@cn.fujitsu.com>
Date: Thu, 26 Sep 2013 17:29:42 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs: fix oops caused by the space balance and dead
 roots
References: <1380116865-23406-1-git-send-email-miaox@cn.fujitsu.com> <1380116865-23406-2-git-send-email-miaox@cn.fujitsu.com> <20130925141125.GE18681@localhost.localdomain>
In-Reply-To: <20130925141125.GE18681@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 25 Sep 2013 10:11:25 -0400, Josef Bacik wrote:
> On Wed, Sep 25, 2013 at 09:47:44PM +0800, Miao Xie wrote:
>> When doing space balance and subvolume destroy at the same time, we met
>> the following oops:
>>
>> kernel BUG at fs/btrfs/relocation.c:2247!
>> RIP: 0010: [<ffffffffa04cec16>] prepare_to_merge+0x154/0x1f0 [btrfs]
>> Call Trace:
>>  [<ffffffffa04b5ab7>] relocate_block_group+0x466/0x4e6 [btrfs]
>>  [<ffffffffa04b5c7a>] btrfs_relocate_block_group+0x143/0x275 [btrfs]
>>  [<ffffffffa0495c56>] btrfs_relocate_chunk.isra.27+0x5c/0x5a2 [btrfs]
>>  [<ffffffffa0459871>] ? btrfs_item_key_to_cpu+0x15/0x31 [btrfs]
>>  [<ffffffffa048b46a>] ? btrfs_get_token_64+0x7e/0xcd [btrfs]
>>  [<ffffffffa04a3467>] ? btrfs_tree_read_unlock_blocking+0xb2/0xb7 [btrfs]
>>  [<ffffffffa049907d>] btrfs_balance+0x9c7/0xb6f [btrfs]
>>  [<ffffffffa049ef84>] btrfs_ioctl_balance+0x234/0x2ac [btrfs]
>>  [<ffffffffa04a1e8e>] btrfs_ioctl+0xd87/0x1ef9 [btrfs]
>>  [<ffffffff81122f53>] ? path_openat+0x234/0x4db
>>  [<ffffffff813c3b78>] ? __do_page_fault+0x31d/0x391
>>  [<ffffffff810f8ab6>] ? vma_link+0x74/0x94
>>  [<ffffffff811250f5>] vfs_ioctl+0x1d/0x39
>>  [<ffffffff811258c8>] do_vfs_ioctl+0x32d/0x3e2
>>  [<ffffffff811259d4>] SyS_ioctl+0x57/0x83
>>  [<ffffffff813c3bfa>] ? do_page_fault+0xe/0x10
>>  [<ffffffff813c73c2>] system_call_fastpath+0x16/0x1b
>>
> 
> Can you put this into an xfstest please so I can reproduce and verify your patch
> fixes the problem?  Thanks,

No problem, I will send out a test case soon.

Thanks
Miao
