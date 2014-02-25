Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37350 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaBYFbX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 00:31:23 -0500
Date: Mon, 24 Feb 2014 21:31:13 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140225053113.GC3521@merlins.org>
References: <20140224061426.GB15937@merlins.org>
 <20140224061714.GC15937@merlins.org>
 <pan$5eb48$855696ce$5bb0f0dc$b9ce161e@cox.net>
 <20140224065847.GE15937@merlins.org>
 <pan$2c66d$b9df9232$d5e4e0c4$992cc0f6@cox.net>
 <20140224173519.GD11827@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140224173519.GD11827@merlins.org>
Subject: Re: 3.14rc3 kernel also hangs some processes with btrfs
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 09:35:19AM -0800, Marc MERLIN wrote:
> On Mon, Feb 24, 2014 at 07:29:58AM +0000, Duncan wrote:
> > > But I'm still seeing these, albeit less often.
> > > Any idea what they could be linked to?
> > > (I have a btrs send/receive going right now, it could hanging
> > > /mnt/btrfs_pool1 in a way that affects smbd, but the array feels ok
> > > otherwise, weird...)
> > > 
> > > [ 1332.548370] INFO: task smbd:21882 blocked for more than 120 seconds.
> > > [ 1332.587455]       Not tainted 3.13.5-ia32-i915-preempt-20140216 #1
> > > [ 1332.625478] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > disables this message.
> > 
> > I've not seen anything like that here, but there are several kernel 
> > 3.13/3.14-rc reports of similar behavior on the list.
>  
> I'll have to try this. Interestingly, I just got the following overnight.
> 
> Something killed 3 different drives from software raid arrays, and the
> drives are all fine.
> 
> It looks like btrfs hung my kernel hard enough that it messed up
> software raid, killed my array on which btrfs was, and then caused a
> cascade of further btrfs failures.
> Are those 2 traces useful?

I upgraded to 3.14rc3  and I'm also seeing hangs, although not as severe

To answer earlier questions:
1) the filesystem I'm copying is brand new, I just created it
2) files were contiguous and not being written randomly (mp3s)

Here are the logs:

[  381.512765] BTRFS: device label bigbackup devid 3 transid 179 /dev/dm-5
[  382.875847] BTRFS: device label bigbackup devid 2 transid 179 /dev/dm-6
[  384.795334] BTRFS: device label bigbackup devid 4 transid 179 /dev/dm-7
[  387.265961] BTRFS: device label bigbackup devid 5 transid 179 /dev/dm-8
[  389.904834] BTRFS: device label bigbackup devid 1 transid 179 /dev/dm-9
[  390.054771] BTRFS: device label bigbackup devid 3 transid 179 /dev/mapper/crypt_sdo1
[  390.107006] BTRFS: device label bigbackup devid 3 transid 179 /dev/dm-5
[  390.129071] BTRFS: device label bigbackup devid 2 transid 179 /dev/mapper/crypt_sdn1
[  390.177737] BTRFS: device label bigbackup devid 2 transid 179 /dev/dm-6
[  390.221597] BTRFS: device label bigbackup devid 4 transid 179 /dev/mapper/crypt_sdp1
[  390.291095] BTRFS: device label bigbackup devid 1 transid 179 /dev/mapper/crypt_sdm1
[  390.334910] BTRFS: device label bigbackup devid 1 transid 179 /dev/dm-9
[  390.357362] BTRFS: device label bigbackup devid 4 transid 179 /dev/dm-7
[  390.378629] BTRFS: device label bigbackup devid 5 transid 179 /dev/mapper/crypt_sdq1
[  390.441157] BTRFS: device label bigbackup devid 1 transid 179 /dev/mapper/crypt_sdm1
[  390.468279] BTRFS info (device dm-9): disk space caching is enabled
[  390.476577] BTRFS: device label bigbackup devid 5 transid 179 /dev/dm-8
[  725.501091] INFO: task btrfs-transacti:3218 blocked for more than 120 seconds.
[  725.529118]       Not tainted 3.14.0-rc3 #1
[  725.542713] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  725.567489] btrfs-transacti D ffff88020d5fa880     0  3218      2 0x00000000
[  725.591645]  ffff88020cad3dc8 0000000000000046 ffff88020cad3fd8 ffff88020d5fa350
[  725.616304]  00000000000141c0 ffff88020d5fa350 ffff8801a5ed82a0 ffff8801a5ed8310
[  725.640545]  ffff8801a5ed82a0 ffff8801a5ed82a0 0000000000000000 ffff88020cad3dd8
[  725.665227] Call Trace:
[  725.674397]  [<ffffffff8160b059>] schedule+0x73/0x75
[  725.690761]  [<ffffffff81229973>] wait_for_commit.isra.10+0x50/0x67
[  725.711610]  [<ffffffff81085062>] ? finish_wait+0x65/0x65
[  725.729355]  [<ffffffff8122acd8>] btrfs_commit_transaction+0x143/0x849
[  725.750238]  [<ffffffff81227598>] transaction_kthread+0xf8/0x1ab
[  725.769867]  [<ffffffff812274a0>] ? btrfs_cleanup_transaction+0x43f/0x43f
[  725.791465]  [<ffffffff8106bc1b>] kthread+0xae/0xb6
[  725.807384]  [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61
[  725.826176]  [<ffffffff8161413c>] ret_from_fork+0x7c/0xb0
[  725.843645]  [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61
[  845.962068] INFO: task btrfs-transacti:3218 blocked for more than 120 seconds.
[  845.986941]       Not tainted 3.14.0-rc3 #1
[  846.000617] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  846.025730] btrfs-transacti D ffff88020d5fa880     0  3218      2 0x00000000
[  846.048610]  ffff88020cad3dc8 0000000000000046 ffff88020cad3fd8 ffff88020d5fa350
[  846.072100]  00000000000141c0 ffff88020d5fa350 ffff8801a5ed82a0 ffff8801a5ed8310
[  846.095559]  ffff8801a5ed82a0 ffff8801a5ed82a0 0000000000000000 ffff88020cad3dd8
[  846.119008] Call Trace:
[  846.127440]  [<ffffffff8160b059>] schedule+0x73/0x75
[  846.144015]  [<ffffffff81229973>] wait_for_commit.isra.10+0x50/0x67
[  846.164512]  [<ffffffff81085062>] ? finish_wait+0x65/0x65
[  846.182412]  [<ffffffff8122acd8>] btrfs_commit_transaction+0x143/0x849
[  846.203734]  [<ffffffff81227598>] transaction_kthread+0xf8/0x1ab
[  846.223484]  [<ffffffff812274a0>] ? btrfs_cleanup_transaction+0x43f/0x43f
[  846.245587]  [<ffffffff8106bc1b>] kthread+0xae/0xb6
[  846.261992]  [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61
[  846.281143]  [<ffffffff8161413c>] ret_from_fork+0x7c/0xb0
[  846.299126]  [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61
[  966.418867] INFO: task btrfs-transacti:3218 blocked for more than 120 seconds.
[  966.442696]       Not tainted 3.14.0-rc3 #1
[  966.457407] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  966.483016] btrfs-transacti D ffff88020d5fa880     0  3218      2 0x00000000
[  966.506440]  ffff88020cad3dc8 0000000000000046 ffff88020cad3fd8 ffff88020d5fa350
[  966.530916]  00000000000141c0 ffff88020d5fa350 ffff8801a5ed82a0 ffff8801a5ed8310
[  966.555390]  ffff8801a5ed82a0 ffff8801a5ed82a0 0000000000000000 ffff88020cad3dd8
[  966.579921] Call Trace:
[  966.589422]  [<ffffffff8160b059>] schedule+0x73/0x75
[  966.606433]  [<ffffffff81229973>] wait_for_commit.isra.10+0x50/0x67
[  966.627339]  [<ffffffff81085062>] ? finish_wait+0x65/0x65
[  966.645553]  [<ffffffff8122acd8>] btrfs_commit_transaction+0x143/0x849
[  966.667268]  [<ffffffff81227598>] transaction_kthread+0xf8/0x1ab
[  966.687403]  [<ffffffff812274a0>] ? btrfs_cleanup_transaction+0x43f/0x43f
[  966.709881]  [<ffffffff8106bc1b>] kthread+0xae/0xb6
[  966.726630]  [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61
[  966.746227]  [<ffffffff8161413c>] ret_from_fork+0x7c/0xb0
[  966.764083]  [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61
[ 1086.879792] INFO: task btrfs-transacti:3218 blocked for more than 120 seconds.
[ 1086.903594]       Not tainted 3.14.0-rc3 #1
[ 1086.918322] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1086.943833] btrfs-transacti D ffff88020d5fa880     0  3218      2 0x00000000
[ 1086.967139]  ffff88020cad3dc8 0000000000000046 ffff88020cad3fd8 ffff88020d5fa350
[ 1086.991476]  00000000000141c0 ffff88020d5fa350 ffff8801a5ed82a0 ffff8801a5ed8310
[ 1087.015821]  ffff8801a5ed82a0 ffff8801a5ed82a0 0000000000000000 ffff88020cad3dd8
[ 1087.039461] Call Trace:
[ 1087.048083]  [<ffffffff8160b059>] schedule+0x73/0x75
[ 1087.064249]  [<ffffffff81229973>] wait_for_commit.isra.10+0x50/0x67
[ 1087.084318]  [<ffffffff81085062>] ? finish_wait+0x65/0x65
[ 1087.101780]  [<ffffffff8122acd8>] btrfs_commit_transaction+0x143/0x849
[ 1087.122610]  [<ffffffff81227598>] transaction_kthread+0xf8/0x1ab
[ 1087.141906]  [<ffffffff812274a0>] ? btrfs_cleanup_transaction+0x43f/0x43f
[ 1087.163541]  [<ffffffff8106bc1b>] kthread+0xae/0xb6
[ 1087.179446]  [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61
[ 1087.198812]  [<ffffffff8161413c>] ret_from_fork+0x7c/0xb0
[ 1087.216988]  [<ffffffff8106bb6d>] ? __kthread_parkme+0x61/0x61
[ 1693.760950] perf samples too long (2502 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[ 1693.789603] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 28.656 msecs

My btrfs copy is working now, without hangs, but 2mn hangs on the above is still bad, especially
on a brand new filesystem.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
