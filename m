Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50605 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbcCIJyx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 04:54:53 -0500
Subject: Re: [PATCH 13/13] btrfs: optimize check for stale device
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
 <1455328900-1476-14-git-send-email-anand.jain@oracle.com>
 <20160218151348.GY4374@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56DFF2E6.4020300@oracle.com>
Date: Wed, 9 Mar 2016 17:54:47 +0800
MIME-Version: 1.0
In-Reply-To: <20160218151348.GY4374@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Dave,

> I see crashes with btrfs/011 on a non-debugging config
>
> [  641.714363] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
> [  641.716057] IP: [<ffffffffa0152eb6>] scrub_setup_ctx.isra.19+0x1f6/0x260 [btrfs]
::
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


  As of now,
  There is nothing that tells me the above crash is due to this patch.

  By any chance were you running multiple instance of fstests ? If that's
  possible ?

Thanks, Anand
