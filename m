Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:57035 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425371AbcBRMf2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 07:35:28 -0500
Received: from cc-smtpin3.netcologne.de (cc-smtpin3.netcologne.de [89.1.8.203])
	by cc-smtpout2.netcologne.de (Postfix) with ESMTP id DFB4C125D4
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 13:35:24 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by cc-smtpin3.netcologne.de (Postfix) with ESMTP id D15BB11DCC
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 13:35:24 +0100 (CET)
Received: from [194.8.193.239] (helo=cc-smtpin3.netcologne.de)
	by localhost with ESMTP (eXpurgate 4.0.9)
	(envelope-from <crohmann@netcologne.de>)
	id 56c5ba8c-0b56-7f0000012729-7f000001b19b-1
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 13:35:24 +0100
Received: from [194.8.193.239] (sys-239.netcologne.de [194.8.193.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cc-smtpin3.netcologne.de (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 13:35:24 +0100 (CET)
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
References: <CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
 <CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
 <CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
 <CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
 <20160211191741.GA4762@localhost.localdomain>
 <CABXGCsPN3MOLkU68gpw=TsnZLODEkYZ66ZHgUxMyeqbdNME9Sw@mail.gmail.com>
 <20160212032226.GA10542@localhost.localdomain>
 <CABXGCsNjHq4M8TBibeWQLyK+Of0cu++P3QQ=+e=TUuZjaPMLtA@mail.gmail.com>
 <20160212203426.GA24399@localhost.localdomain>
 <CABXGCsMMkcMmEH8=d3TqJksB8uc_OVrRqfjX7E1RO+4R94O=Ug@mail.gmail.com>
 <20160214213224.GB28882@localhost.localdomain>
 <20160215034219.2f0df0ce@natsu>
From: Christian Rohmann <crohmann@netcologne.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <56C5BA8C.1020106@netcologne.de>
Date: Thu, 18 Feb 2016 13:35:24 +0100
MIME-Version: 1.0
In-Reply-To: <20160215034219.2f0df0ce@natsu>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/14/2016 11:42 PM, Roman Mamedov wrote:
> FWIW I had a persistently repeating deadlock on 4.1 and 4.3, but
> after upgrade to 4.4 it no longer happens.


Apparently also with 4.4 there is some sort of blocking happening ...
just at 38580:

---- cut ----

[Wed Feb 17 16:43:48 2016] INFO: task btrfs-cleaner:38580 blocked for
more than 120 seconds.
[Wed Feb 17 16:43:48 2016]       Not tainted 4.4.0-customkernel #1
[Wed Feb 17 16:43:48 2016] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Wed Feb 17 16:43:48 2016] btrfs-cleaner   D ffff882c27295dc0     0
38580      2 0x00000000
[Wed Feb 17 16:43:48 2016]  ffff882c16fa6480 ffff88161a980280
ffff882a3d744000 ffff882a3d743df8
[Wed Feb 17 16:43:48 2016]  ffff8815fead7104 ffff882c16fa6480
00000000ffffffff ffff8815fead7108
[Wed Feb 17 16:43:48 2016]  ffffffff81559a31 ffff8815fead7100
ffffffff81559cba ffffffff8155b5a0
[Wed Feb 17 16:43:48 2016] Call Trace:
[Wed Feb 17 16:43:48 2016]  [<ffffffff81559a31>] ? schedule+0x31/0x80
[Wed Feb 17 16:43:48 2016]  [<ffffffff81559cba>] ?
schedule_preempt_disabled+0xa/0x10
[Wed Feb 17 16:43:48 2016]  [<ffffffff8155b5a0>] ?
__mutex_lock_slowpath+0x90/0x110
[Wed Feb 17 16:43:48 2016]  [<ffffffff8155b63b>] ? mutex_lock+0x1b/0x30
[Wed Feb 17 16:43:48 2016]  [<ffffffffa01bf51e>] ?
btrfs_delete_unused_bgs+0xee/0x3f0 [btrfs]
[Wed Feb 17 16:43:48 2016]  [<ffffffff81559396>] ? __schedule+0x286/0x8f0
[Wed Feb 17 16:43:48 2016]  [<ffffffffa01c6ff7>] ?
cleaner_kthread+0x1a7/0x200 [btrfs]
[Wed Feb 17 16:43:48 2016]  [<ffffffffa01c6e50>] ?
check_leaf+0x340/0x340 [btrfs]
[Wed Feb 17 16:43:48 2016]  [<ffffffff8108df6f>] ? kthread+0xcf/0xf0
[Wed Feb 17 16:43:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50
[Wed Feb 17 16:43:48 2016]  [<ffffffff8155d74f>] ? ret_from_fork+0x3f/0x70
[Wed Feb 17 16:43:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50

[Wed Feb 17 17:23:48 2016] INFO: task btrfs-cleaner:38580 blocked for
more than 120 seconds.
[Wed Feb 17 17:23:48 2016]       Not tainted 4.4.0-customkernel #1
[Wed Feb 17 17:23:48 2016] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Wed Feb 17 17:23:48 2016] btrfs-cleaner   D ffff881627a35dc0     0
38580      2 0x00000000
[Wed Feb 17 17:23:48 2016]  ffff882c16fa6480 ffff88161a956f00
ffff882a3d744000 ffff882a3d743df8
[Wed Feb 17 17:23:48 2016]  ffff8815fead7104 ffff882c16fa6480
00000000ffffffff ffff8815fead7108
[Wed Feb 17 17:23:48 2016]  ffffffff81559a31 ffff8815fead7100
ffffffff81559cba ffffffff8155b5a0
[Wed Feb 17 17:23:48 2016] Call Trace:
[Wed Feb 17 17:23:48 2016]  [<ffffffff81559a31>] ? schedule+0x31/0x80
[Wed Feb 17 17:23:48 2016]  [<ffffffff81559cba>] ?
schedule_preempt_disabled+0xa/0x10
[Wed Feb 17 17:23:48 2016]  [<ffffffff8155b5a0>] ?
__mutex_lock_slowpath+0x90/0x110
[Wed Feb 17 17:23:48 2016]  [<ffffffff8155b63b>] ? mutex_lock+0x1b/0x30
[Wed Feb 17 17:23:48 2016]  [<ffffffffa01bf51e>] ?
btrfs_delete_unused_bgs+0xee/0x3f0 [btrfs]
[Wed Feb 17 17:23:48 2016]  [<ffffffff81559396>] ? __schedule+0x286/0x8f0
[Wed Feb 17 17:23:48 2016]  [<ffffffffa01c6ff7>] ?
cleaner_kthread+0x1a7/0x200 [btrfs]
[Wed Feb 17 17:23:48 2016]  [<ffffffffa01c6e50>] ?
check_leaf+0x340/0x340 [btrfs]
[Wed Feb 17 17:23:48 2016]  [<ffffffff8108df6f>] ? kthread+0xcf/0xf0
[Wed Feb 17 17:23:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50
[Wed Feb 17 17:23:48 2016]  [<ffffffff8155d74f>] ? ret_from_fork+0x3f/0x70
[Wed Feb 17 17:23:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50

[Wed Feb 17 17:57:48 2016] INFO: task btrfs-cleaner:38580 blocked for
more than 120 seconds.
[Wed Feb 17 17:57:48 2016]       Not tainted 4.4.0-customkernel #1
[Wed Feb 17 17:57:48 2016] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Wed Feb 17 17:57:48 2016] btrfs-cleaner   D ffff881627a95dc0     0
38580      2 0x00000000
[Wed Feb 17 17:57:48 2016]  ffff882c16fa6480 ffff88161a980fc0
ffff882a3d744000 ffff882a3d743df8
[Wed Feb 17 17:57:48 2016]  ffff8815fead7104 ffff882c16fa6480
00000000ffffffff ffff8815fead7108
[Wed Feb 17 17:57:48 2016]  ffffffff81559a31 ffff8815fead7100
ffffffff81559cba ffffffff8155b5a0
[Wed Feb 17 17:57:48 2016] Call Trace:
[Wed Feb 17 17:57:48 2016]  [<ffffffff81559a31>] ? schedule+0x31/0x80
[Wed Feb 17 17:57:48 2016]  [<ffffffff81559cba>] ?
schedule_preempt_disabled+0xa/0x10
[Wed Feb 17 17:57:48 2016]  [<ffffffff8155b5a0>] ?
__mutex_lock_slowpath+0x90/0x110
[Wed Feb 17 17:57:48 2016]  [<ffffffff8155b63b>] ? mutex_lock+0x1b/0x30
[Wed Feb 17 17:57:48 2016]  [<ffffffffa01bf51e>] ?
btrfs_delete_unused_bgs+0xee/0x3f0 [btrfs]
[Wed Feb 17 17:57:48 2016]  [<ffffffff81559396>] ? __schedule+0x286/0x8f0
[Wed Feb 17 17:57:48 2016]  [<ffffffffa01c6ff7>] ?
cleaner_kthread+0x1a7/0x200 [btrfs]
[Wed Feb 17 17:57:48 2016]  [<ffffffffa01c6e50>] ?
check_leaf+0x340/0x340 [btrfs]
[Wed Feb 17 17:57:48 2016]  [<ffffffff8108df6f>] ? kthread+0xcf/0xf0
[Wed Feb 17 17:57:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50
[Wed Feb 17 17:57:48 2016]  [<ffffffff8155d74f>] ? ret_from_fork+0x3f/0x70
[Wed Feb 17 17:57:48 2016]  [<ffffffff8108dea0>] ? kthread_park+0x50/0x50


---- cut ----
