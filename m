Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31354 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbcBSHKX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Feb 2016 02:10:23 -0500
Subject: Re: [PATCH 13/13] btrfs: optimize check for stale device
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
 <1455328900-1476-14-git-send-email-anand.jain@oracle.com>
 <20160218151348.GY4374@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56C6BFD8.30801@oracle.com>
Date: Fri, 19 Feb 2016 15:10:16 +0800
MIME-Version: 1.0
In-Reply-To: <20160218151348.GY4374@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/18/2016 11:13 PM, David Sterba wrote:
> On Sat, Feb 13, 2016 at 10:01:40AM +0800, Anand Jain wrote:
>> Optimize check for stale device to only be checked when there is device
>> added or changed. If there is no update to the device, there is no need
>> to call btrfs_free_stale_device().
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/48909/focus=48976
>
> So why did you include the patch in this series?

  Non technical. Getting miscellaneous device management related patches
  through.


> I see crashes with btrfs/011 on a non-debugging config
>
> [  641.714363] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [  641.716057] IP: [<ffffffffa0152eb6>] scrub_setup_ctx.isra.19+0x1f6/0x260 [btrfs]
> [  641.717036] PGD 720c1067 PUD 720c2067 PMD 0
> [  641.717749] Oops: 0000 [#1] PREEMPT SMP
::
> [  641.723163] CPU: 0 PID: 27766 Comm: btrfs Not tainted 4.5.0-rc3-next-20160212-1.g38290f0-vanilla #1
> [  641.724420] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS by qemu-project.org 04/01/2014
> [  641.725723] task: ffff8800742481c0 ti: ffff880071d10000 task.ti: ffff880071d10000
> [  641.726954] RIP: 0010:[<ffffffffa0152eb6>]  [<ffffffffa0152eb6>] scrub_setup_ctx.isra.19+0x1f6/0x260 [btrfs]
> [  641.728404] RSP: 0018:ffff880071d13ce8  EFLAGS: 00010202
> [  641.729413] RAX: ffff88007231e800 RBX: ffff88007231e800 RCX: 0000000000000000
> [  641.730610] RDX: ffffffffa0195638 RSI: ffffffffa017c5a8 RDI: ffff88007231ea80
> [  641.731832] RBP: ffff880071d13d18 R08: 0000000000000000 R09: ffff88007204ea00
> [  641.733085] R10: 0000000000000008 R11: 0000000000000000 R12: 0000000000000000
> [  641.734307] R13: 0000000000000001 R14: ffff88007231e9f8 R15: 000000000000003f
> [  641.735544] FS:  00007f03ed36d8c0(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
> [  641.736883] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  641.738022] CR2: 0000000000000068 CR3: 00000000720c0000 CR4: 00000000000006f0
> [  641.739325] Stack:
> [  641.740156]  ffff8800724d4000 ffff8800724d4000 0000000000000000 ffff8800722ef000
> [  641.741735]  0000000000000000 ffff8800724d4fc8 ffff880071d13d98 ffffffffa01566fd
> [  641.743163]  ffff88007b127000 0000001900000000 ffff8800724d4ce8 0000000000000000
> [  641.744599] Call Trace:
> [  641.745553]  [<ffffffffa01566fd>] btrfs_scrub_dev+0x13d/0x510 [btrfs]
> [  641.746894]  [<ffffffffa0169ca9>] btrfs_dev_replace_start+0x279/0x3f0 [btrfs]
> [  641.748282]  [<ffffffffa0132839>] btrfs_ioctl+0x1869/0x2070 [btrfs]
> [  641.749587]  [<ffffffff8106d553>] ? pte_alloc_one+0x33/0x40
> [  641.750850]  [<ffffffff81222516>] do_vfs_ioctl+0x96/0x590
> [  641.752128]  [<ffffffff810682d1>] ? __do_page_fault+0x181/0x450
> [  641.753432]  [<ffffffff81222a89>] SyS_ioctl+0x79/0x90
> [  641.754663]  [<ffffffff816d4336>] entry_SYSCALL_64_fastpath+0x1e/0xa8
> [  641.756037] Code: 00 48 c7 c2 38 56 19 a0 48 c7 c6 a8 c5 17 a0 e8 21 39 f7 e0 45 85 ed 48 c7 83 68 02 00 00 00 00 00 00 48 89 d8 0f 84 03 ff ff ff <49> 83 7c 24 68 00 74 40 c7 83 78 02 00 00 20 00 00 00 4c 89 a3
> [  641.760392] RIP  [<ffffffffa0152eb6>] scrub_setup_ctx.isra.19+0x1f6/0x260 [btrfs]
> [  641.761970]  RSP <ffff880071d13ce8>
> [  641.763190] CR2: 0000000000000068
> [  641.767218] ---[ end trace f46d4e6a90bda310 ]---
>
> the dereference happens at offset 0x68 which matches bdev in
> btrfs_device, so this patch is my best guess at the moment. I'm not able
> to reproduce it directly so I need to wait for a rebuild and repeat.


   Looks like dev was fine when find_device was called, but
   later it was null when ->bdev was accessed.

   I couldn't reproduce here. There are 10 workouts within btrfs/011
   any idea workout caused this? As of now I am guessing..

   workout "-m dup -d single" 1 cancel quick

   digging more.

Thanks, Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
