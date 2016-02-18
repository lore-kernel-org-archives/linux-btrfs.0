Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22305 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946257AbcBRQ7t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 11:59:49 -0500
Date: Thu, 18 Feb 2016 08:59:43 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Christian Rohmann <crohmann@netcologne.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
Message-ID: <20160218165943.GB2492@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
 <20160211191741.GA4762@localhost.localdomain>
 <CABXGCsPN3MOLkU68gpw=TsnZLODEkYZ66ZHgUxMyeqbdNME9Sw@mail.gmail.com>
 <20160212032226.GA10542@localhost.localdomain>
 <CABXGCsNjHq4M8TBibeWQLyK+Of0cu++P3QQ=+e=TUuZjaPMLtA@mail.gmail.com>
 <20160212203426.GA24399@localhost.localdomain>
 <CABXGCsMMkcMmEH8=d3TqJksB8uc_OVrRqfjX7E1RO+4R94O=Ug@mail.gmail.com>
 <20160214213224.GB28882@localhost.localdomain>
 <20160215034219.2f0df0ce@natsu>
 <56C5BA8C.1020106@netcologne.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56C5BA8C.1020106@netcologne.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2016 at 01:35:24PM +0100, Christian Rohmann wrote:
> 
> 
> On 02/14/2016 11:42 PM, Roman Mamedov wrote:
> > FWIW I had a persistently repeating deadlock on 4.1 and 4.3, but
> > after upgrade to 4.4 it no longer happens.
> 
> 
> Apparently also with 4.4 there is some sort of blocking happening ...
> just at 38580:

OK, what does 'sysrq-w' say?

Thanks,

-liubo

> 
> ---- cut ----
> 
> [Wed Feb 17 16:43:48 2016] INFO: task btrfs-cleaner:38580 blocked for
> more than 120 seconds.
> [Wed Feb 17 16:43:48 2016]       Not tainted 4.4.0-customkernel #1
> [Wed Feb 17 16:43:48 2016] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Wed Feb 17 16:43:48 2016] btrfs-cleaner   D ffff882c27295dc0     0
> 38580      2 0x00000000
> [Wed Feb 17 16:43:48 2016]  ffff882c16fa6480 ffff88161a980280
> ffff882a3d744000 ffff882a3d743df8
> [Wed Feb 17 16:43:48 2016]  ffff8815fead7104 ffff882c16fa6480
> 00000000ffffffff ffff8815fead7108
> [Wed Feb 17 16:43:48 2016]  ffffffff81559a31 ffff8815fead7100
> ffffffff81559cba ffffffff8155b5a0
> [Wed Feb 17 16:43:48 2016] Call Trace:
> [Wed Feb 17 16:43:48 2016]  [<ffffffff81559a31>] ? schedule+0x31/0x80
> [Wed Feb 17 16:43:48 2016]  [<ffffffff81559cba>] ?
> schedule_preempt_disabled+0xa/0x10
> [Wed Feb 17 16:43:48 2016]  [<ffffffff8155b5a0>] ?
> __mutex_lock_slowpath+0x90/0x110
> [Wed Feb 17 16:43:48 2016]  [<ffffffff8155b63b>] ? mutex_lock+0x1b/0x30
> [Wed Feb 17 16:43:48 2016]  [<ffffffffa01bf51e>] ?
> btrfs_delete_unused_bgs+0xee/0x3f0 [btrfs]
> [Wed Feb 17 16:43:48 2016]  [<ffffffff81559396>] ? __schedule+0x286/0x8f0
> [Wed Feb 17 16:43:48 2016]  [<ffffffffa01c6ff7>] ?
> cleaner_kthread+0x1a7/0x200 [btrfs]
> [Wed Feb 17 16:43:48 2016]  [<ffffffffa01c6e50>] ?
> check_leaf+0x340/0x340 [btrfs]
> [Wed Feb 17 16:43:48 2016]  [<ffffffff8108df6f>] ? kthread+0xcf/0xf0
> [Wed Feb 17 16:43:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50
> [Wed Feb 17 16:43:48 2016]  [<ffffffff8155d74f>] ? ret_from_fork+0x3f/0x70
> [Wed Feb 17 16:43:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50
> 
> [Wed Feb 17 17:23:48 2016] INFO: task btrfs-cleaner:38580 blocked for
> more than 120 seconds.
> [Wed Feb 17 17:23:48 2016]       Not tainted 4.4.0-customkernel #1
> [Wed Feb 17 17:23:48 2016] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Wed Feb 17 17:23:48 2016] btrfs-cleaner   D ffff881627a35dc0     0
> 38580      2 0x00000000
> [Wed Feb 17 17:23:48 2016]  ffff882c16fa6480 ffff88161a956f00
> ffff882a3d744000 ffff882a3d743df8
> [Wed Feb 17 17:23:48 2016]  ffff8815fead7104 ffff882c16fa6480
> 00000000ffffffff ffff8815fead7108
> [Wed Feb 17 17:23:48 2016]  ffffffff81559a31 ffff8815fead7100
> ffffffff81559cba ffffffff8155b5a0
> [Wed Feb 17 17:23:48 2016] Call Trace:
> [Wed Feb 17 17:23:48 2016]  [<ffffffff81559a31>] ? schedule+0x31/0x80
> [Wed Feb 17 17:23:48 2016]  [<ffffffff81559cba>] ?
> schedule_preempt_disabled+0xa/0x10
> [Wed Feb 17 17:23:48 2016]  [<ffffffff8155b5a0>] ?
> __mutex_lock_slowpath+0x90/0x110
> [Wed Feb 17 17:23:48 2016]  [<ffffffff8155b63b>] ? mutex_lock+0x1b/0x30
> [Wed Feb 17 17:23:48 2016]  [<ffffffffa01bf51e>] ?
> btrfs_delete_unused_bgs+0xee/0x3f0 [btrfs]
> [Wed Feb 17 17:23:48 2016]  [<ffffffff81559396>] ? __schedule+0x286/0x8f0
> [Wed Feb 17 17:23:48 2016]  [<ffffffffa01c6ff7>] ?
> cleaner_kthread+0x1a7/0x200 [btrfs]
> [Wed Feb 17 17:23:48 2016]  [<ffffffffa01c6e50>] ?
> check_leaf+0x340/0x340 [btrfs]
> [Wed Feb 17 17:23:48 2016]  [<ffffffff8108df6f>] ? kthread+0xcf/0xf0
> [Wed Feb 17 17:23:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50
> [Wed Feb 17 17:23:48 2016]  [<ffffffff8155d74f>] ? ret_from_fork+0x3f/0x70
> [Wed Feb 17 17:23:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50
> 
> [Wed Feb 17 17:57:48 2016] INFO: task btrfs-cleaner:38580 blocked for
> more than 120 seconds.
> [Wed Feb 17 17:57:48 2016]       Not tainted 4.4.0-customkernel #1
> [Wed Feb 17 17:57:48 2016] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Wed Feb 17 17:57:48 2016] btrfs-cleaner   D ffff881627a95dc0     0
> 38580      2 0x00000000
> [Wed Feb 17 17:57:48 2016]  ffff882c16fa6480 ffff88161a980fc0
> ffff882a3d744000 ffff882a3d743df8
> [Wed Feb 17 17:57:48 2016]  ffff8815fead7104 ffff882c16fa6480
> 00000000ffffffff ffff8815fead7108
> [Wed Feb 17 17:57:48 2016]  ffffffff81559a31 ffff8815fead7100
> ffffffff81559cba ffffffff8155b5a0
> [Wed Feb 17 17:57:48 2016] Call Trace:
> [Wed Feb 17 17:57:48 2016]  [<ffffffff81559a31>] ? schedule+0x31/0x80
> [Wed Feb 17 17:57:48 2016]  [<ffffffff81559cba>] ?
> schedule_preempt_disabled+0xa/0x10
> [Wed Feb 17 17:57:48 2016]  [<ffffffff8155b5a0>] ?
> __mutex_lock_slowpath+0x90/0x110
> [Wed Feb 17 17:57:48 2016]  [<ffffffff8155b63b>] ? mutex_lock+0x1b/0x30
> [Wed Feb 17 17:57:48 2016]  [<ffffffffa01bf51e>] ?
> btrfs_delete_unused_bgs+0xee/0x3f0 [btrfs]
> [Wed Feb 17 17:57:48 2016]  [<ffffffff81559396>] ? __schedule+0x286/0x8f0
> [Wed Feb 17 17:57:48 2016]  [<ffffffffa01c6ff7>] ?
> cleaner_kthread+0x1a7/0x200 [btrfs]
> [Wed Feb 17 17:57:48 2016]  [<ffffffffa01c6e50>] ?
> check_leaf+0x340/0x340 [btrfs]
> [Wed Feb 17 17:57:48 2016]  [<ffffffff8108df6f>] ? kthread+0xcf/0xf0
> [Wed Feb 17 17:57:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50
> [Wed Feb 17 17:57:48 2016]  [<ffffffff8155d74f>] ? ret_from_fork+0x3f/0x70
> [Wed Feb 17 17:57:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50
> 
> 
> ---- cut ----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
