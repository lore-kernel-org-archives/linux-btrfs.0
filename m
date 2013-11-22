Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53301 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3KVRaj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 12:30:39 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3FABD7C0683
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Nov 2013 10:30:39 -0700 (MST)
Date: Fri, 22 Nov 2013 12:30:37 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't clear the default compression type
Message-ID: <20131122173037.GD5349@localhost.localdomain>
References: <1385117279-32009-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1385117279-32009-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 22, 2013 at 06:47:59PM +0800, Miao Xie wrote:
> We met a oops caused by the wrong compression type:
> [  556.512356] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  556.512370] IP: [<ffffffff811dbaa0>] __list_del_entry+0x1/0x98
> [SNIP]
> [  556.512490]  [<ffffffff811dbb44>] ? list_del+0xd/0x2b
> [  556.512539]  [<ffffffffa05dd5ce>] find_workspace+0x97/0x175 [btrfs]
> [  556.512546]  [<ffffffff813c14b5>] ? _raw_spin_lock+0xe/0x10
> [  556.512576]  [<ffffffffa05de276>] btrfs_compress_pages+0x2d/0xa2 [btrfs]
> [  556.512601]  [<ffffffffa05af060>] compress_file_range.constprop.54+0x1f2/0x4e8 [btrfs]
> [  556.512627]  [<ffffffffa05af388>] async_cow_start+0x32/0x4d [btrfs]
> [  556.512655]  [<ffffffffa05cc7a1>] worker_loop+0x144/0x4c3 [btrfs]
> [  556.512661]  [<ffffffff81059404>] ? finish_task_switch+0x80/0xb8
> [  556.512689]  [<ffffffffa05cc65d>] ? btrfs_queue_worker+0x244/0x244 [btrfs]
> [  556.512695]  [<ffffffff8104fa4e>] kthread+0x8d/0x95
> [  556.512699]  [<ffffffff81050000>] ? bit_waitqueue+0x34/0x7d
> [  556.512704]  [<ffffffff8104f9c1>] ? __kthread_parkme+0x65/0x65
> [  556.512709]  [<ffffffff813c7eec>] ret_from_fork+0x7c/0xb0
> [  556.512713]  [<ffffffff8104f9c1>] ? __kthread_parkme+0x65/0x65
> 
> Steps to reproduce:
>  # mkfs.btrfs -f <dev>
>  # mount -o nodatacow <dev> <mnt>
>  # touch <mnt>/<file>
>  # chattr =c <mnt>/<file>
>  # dd if=/dev/zero of=<mnt>/<file> bs=1M count=10
> 

Please turn this into an xfstest.  Thanks,

Josef
