Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:41843 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3CZTrF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 15:47:05 -0400
Message-ID: <5151FB3F.3060406@profihost.ag>
Date: Tue, 26 Mar 2013 20:47:11 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
References: <20130326133053.GK1955@localhost.localdomain> <5151A75C.6080703@profihost.ag> <20130326144426.GL1955@localhost.localdomain> <5151B8AF.60900@profihost.ag> <20130326152553.GN1955@localhost.localdomain> <5151CA87.3050801@profihost.ag> <20130326174554.GB28030@localhost.localdomain> <5151F180.4050405@profihost.ag> <20130326191651.GF28030@localhost.localdomain> <5151F56C.5070502@profihost.ag> <20130326193805.GG28030@localhost.localdomain>
In-Reply-To: <20130326193805.GG28030@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI,
Am 26.03.2013 20:38, schrieb Josef Bacik:
> On Tue, Mar 26, 2013 at 01:22:20PM -0600, Stefan Priebe wrote:
>> Hi,
>>
>> but when i transfer big files i see now this one:
>> [20368.784736] INFO: task rsync:14911 blocked for more than 120 seconds.
>> [20368.821978] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [20368.895140] rsync           D ffffffff8160f580     0 14911      1
>> 0x00000000
>> [20368.895148]  ffff8801ca63fc78 0000000000000086 ffff8800c28f8198
>> ffff88022394f800
>> [20368.895158]  ffff8801ca63ffd8 ffff8801ca63ffd8 ffff8801ca63ffd8
>> 0000000000012c40
>> [20368.895163]  ffffffff81a11440 ffff8801c9d36340 ffff8801ca63fc88
>> ffff8801cefce130
>> [20368.895169] Call Trace:
>> [20368.895180]  [<ffffffff8151a774>] schedule+0x24/0x70
>> [20368.895207]  [<ffffffffa0158c75>]
>> wait_current_trans.isra.32+0x95/0x100 [btrfs]
>> [20368.895214]  [<ffffffff8106d4f0>] ? add_wait_queue+0x60/0x60
>> [20368.895236]  [<ffffffffa015a45d>]
>> start_transaction.part.33+0x13d/0x4d0 [btrfs]
>> [20368.895252]  [<ffffffff811420f3>] ? inode_permission+0x13/0x50
>> [20368.895271]  [<ffffffffa015a814>] start_transaction+0x24/0x30 [btrfs]
>> [20368.895287]  [<ffffffffa015aae3>] btrfs_start_transaction+0x13/0x20
>> [btrfs]
>> [20368.895302]  [<ffffffffa015b2f0>] __unlink_start_trans+0x70/0x460 [btrfs]
>> [20368.895307]  [<ffffffff8150ee3e>] ? check_acl+0x5a/0x122
>> [20368.895312]  [<ffffffff81055ff0>] ? ns_capable+0x30/0x60
>> [20368.895317]  [<ffffffff811413bd>] ? generic_permission+0xbd/0x110
>> [20368.895336]  [<ffffffffa0163f92>] btrfs_unlink+0x32/0xc0 [btrfs]
>> [20368.895341]  [<ffffffff8114186d>] vfs_unlink.part.61+0x6d/0xd0
>> [20368.895345]  [<ffffffff81143ad7>] vfs_unlink+0x37/0x50
>> [20368.895349]  [<ffffffff81143c8b>] do_unlinkat+0x19b/0x240
>> [20368.895354]  [<ffffffff81146171>] sys_unlink+0x11/0x20
>> [20368.895359]  [<ffffffff8151c2e9>] system_call_fastpath+0x16/0x1b
>>
>> Speed is just 100kb/s instead of 100MB/s.
>>
>
> Hrm I wonder if 512 is too small for your case, can you add this patch to the
> pile and see what dmesg says when you are having these problems?  Thanks,

No idea why but i can't reproduce... ;-(

Stefan
