Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44235 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbbK3WFc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 17:05:32 -0500
Subject: Re: BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <5648CD1D.9070804@oracle.com>
 <20151130134851.GZ31035@twin.jikos.cz> <20151130163407.GA31035@twin.jikos.cz>
From: Vegard Nossum <vegard.nossum@oracle.com>
Message-ID: <565CC820.9020706@oracle.com>
Date: Mon, 30 Nov 2015 23:05:20 +0100
MIME-Version: 1.0
In-Reply-To: <20151130163407.GA31035@twin.jikos.cz>
Content-Type: multipart/mixed;
 boundary="------------050506050205020403040907"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050506050205020403040907
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/2015 05:34 PM, David Sterba wrote:
> On Mon, Nov 30, 2015 at 02:48:51PM +0100, David Sterba wrote:
>> On Sun, Nov 15, 2015 at 07:21:17PM +0100, Vegard Nossum wrote:
>>> With the attached btrfs image, I get the following splat when mounting:
>>>
>>> """
>>> # mount -o loop -t btrfs ./btrfs.0 /mnt/0/
>>> BTRFS: device fsid 9006933e-2a9a-44f0-917f-514252aeec2c devid 1 transid
>>> 7 /dev/loop0
>>> BTRFS info (device loop0): disk space caching is enabled
>>> BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
>
> The fix, worked for me on the provided image:
> https://patchwork.kernel.org/patch/7728051/
>
> I'll add the attached image to btrfs-progs testsuite as it triggers
> crashes in other tools.
>

Thanks, that seems to fix the problem.

With your patch and a new image, I run into a second issue (which is 
probably unrelated):

BTRFS critical (device loop0): unable to find logical 4294963200 len 
40966cc7e != de8
BUG: failure at fs/btrfs/inode.c:1805/btrfs_merge_bio_hook()!
Kernel panic - not syncing: BUG! errors
CPU: 0 PID: 913 Comm: mount Not tainted 4.2.5 #1cc7e devid 1 transid 7 
/dev/loop0
Stack: dev_item UUID does not match fsid: 
de80ced1-18ac-490c-9afb-cf0a7d66cc7e != de8
   e0147430 60075412 600bd457 603f5080
   606dfc7a 605e2b14 e0147440 605e595fors
   e0147560 605e291e e00cb2e8 00001000
  Call Trace:
   [<60029f3b>] show_stack+0xdb/0x1a0
   [<605e595f>] dump_stack+0x2a/0x2c
   [<605e291e>] panic+0x137/0x2ac
   [<602b8d0c>] btrfs_merge_bio_hook+0xfc/0x100
   [<602e3923>] submit_extent_page+0x223/0x330
   [<602e51a6>] __do_readpage+0x476/0xb60
   [<602e59bf>] __extent_read_full_page+0x12f/0x140
   [<602e8264>] read_extent_buffer_pages+0x1e4/0x410
   [<602a9d46>] btree_read_extent_buffer_pages.constprop.24+0x106/0x1a0
   [<602aa67e>] read_tree_block+0x5e/0xa0
   [<602b0064>] open_ctree+0x1814/0x2db0
   [<60273a3b>] btrfs_mount+0xf3b/0x1010
   [<601054d3>] mount_fs+0x33/0x210
   [<60124b94>] vfs_kern_mount+0x74/0x170
   [<60272df3>] btrfs_mount+0x2f3/0x1010
   [<601054d3>] mount_fs+0x33/0x210
   [<60124b94>] vfs_kern_mount+0x74/0x170
   [<601264dc>] do_mount+0x26c/0xf30
   [<6012768b>] SyS_mount+0xab/0x120

Should I start a new thread? I've attached the new image. Thanks,


Vegard

--------------050506050205020403040907
Content-Type: application/x-bzip;
 name="btrfs.1.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="btrfs.1.bz2"

QlpoOTFBWSZTWdFBvv0AgkR/////////////////////////////////////////////4BQe
+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
Ki1NupCDwQAhHE9lEAc44Xkn/i7kinChIaKDffo=
--------------050506050205020403040907--
