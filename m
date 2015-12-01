Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58123 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753998AbbLAAvJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 19:51:09 -0500
Subject: Re: BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
To: Vegard Nossum <vegard.nossum@oracle.com>, <dsterba@suse.cz>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <5648CD1D.9070804@oracle.com>
 <20151130134851.GZ31035@twin.jikos.cz> <20151130163407.GA31035@twin.jikos.cz>
 <565CC820.9020706@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <565CEEF1.80006@cn.fujitsu.com>
Date: Tue, 1 Dec 2015 08:50:57 +0800
MIME-Version: 1.0
In-Reply-To: <565CC820.9020706@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Vegard Nossum wrote on 2015/11/30 23:05 +0100:
> On 11/30/2015 05:34 PM, David Sterba wrote:
>> On Mon, Nov 30, 2015 at 02:48:51PM +0100, David Sterba wrote:
>>> On Sun, Nov 15, 2015 at 07:21:17PM +0100, Vegard Nossum wrote:
>>>> With the attached btrfs image, I get the following splat when mounting:
>>>>
>>>> """
>>>> # mount -o loop -t btrfs ./btrfs.0 /mnt/0/
>>>> BTRFS: device fsid 9006933e-2a9a-44f0-917f-514252aeec2c devid 1 transid
>>>> 7 /dev/loop0
>>>> BTRFS info (device loop0): disk space caching is enabled
>>>> BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
>>
>> The fix, worked for me on the provided image:
>> https://patchwork.kernel.org/patch/7728051/
>>
>> I'll add the attached image to btrfs-progs testsuite as it triggers
>> crashes in other tools.
>>
>
> Thanks, that seems to fix the problem.
>
> With your patch and a new image, I run into a second issue (which is
> probably unrelated):
>
> BTRFS critical (device loop0): unable to find logical 4294963200 len
> 40966cc7e != de8
> BUG: failure at fs/btrfs/inode.c:1805/btrfs_merge_bio_hook()!
> Kernel panic - not syncing: BUG! errors
> CPU: 0 PID: 913 Comm: mount Not tainted 4.2.5 #1cc7e devid 1 transid 7
> /dev/loop0
> Stack: dev_item UUID does not match fsid:
> de80ced1-18ac-490c-9afb-cf0a7d66cc7e != de8
>    e0147430 60075412 600bd457 603f5080
>    606dfc7a 605e2b14 e0147440 605e595fors
>    e0147560 605e291e e00cb2e8 00001000
>   Call Trace:
>    [<60029f3b>] show_stack+0xdb/0x1a0
>    [<605e595f>] dump_stack+0x2a/0x2c
>    [<605e291e>] panic+0x137/0x2ac
>    [<602b8d0c>] btrfs_merge_bio_hook+0xfc/0x100
>    [<602e3923>] submit_extent_page+0x223/0x330
>    [<602e51a6>] __do_readpage+0x476/0xb60
>    [<602e59bf>] __extent_read_full_page+0x12f/0x140
>    [<602e8264>] read_extent_buffer_pages+0x1e4/0x410
>    [<602a9d46>] btree_read_extent_buffer_pages.constprop.24+0x106/0x1a0
>    [<602aa67e>] read_tree_block+0x5e/0xa0
>    [<602b0064>] open_ctree+0x1814/0x2db0
>    [<60273a3b>] btrfs_mount+0xf3b/0x1010
>    [<601054d3>] mount_fs+0x33/0x210
>    [<60124b94>] vfs_kern_mount+0x74/0x170
>    [<60272df3>] btrfs_mount+0x2f3/0x1010
>    [<601054d3>] mount_fs+0x33/0x210
>    [<60124b94>] vfs_kern_mount+0x74/0x170
>    [<601264dc>] do_mount+0x26c/0xf30
>    [<6012768b>] SyS_mount+0xab/0x120
>
> Should I start a new thread? I've attached the new image. Thanks,
>
>
> Vegard
>
>
Glad to see btrfsck is much robust than kernel now. :)

Btrfsck already gives quite good clue on the problem:

ERROR: chunk_root block unaligned: 4294967168
ERROR: chunk_root block unaligned: 4294967168

Chunk root in superblock is not aligned, and the superblock is not valid.

It would be better to copy all these btrfs-progs enhancement to kernel.

Thanks,
Qu


