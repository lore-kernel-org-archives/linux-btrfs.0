From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Having parent transid verify failed
Date: Thu, 05 May 2011 14:19:52 +0300
Message-ID: <4DC287D8.3040705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, I have a 5.5TB Btrfs filesystem on top of a md-raid 5 device. Now 
if i run some file operations like find, i get these messages.
kernel is 2.6.38.5-1 on arch linux

May  5 14:15:12 mail kernel: [13559.089713] parent transid verify failed 
on 3062073683968 wanted 5181 found 5188
May  5 14:15:12 mail kernel: [13559.089834] parent transid verify failed 
on 3062073683968 wanted 5181 found 5188
May  5 14:15:14 mail kernel: [13560.752074] btrfs-transacti D 
ffff88007211ac78     0  5339      2 0x00000000
May  5 14:15:14 mail kernel: [13560.752078]  ffff880023167d30 
0000000000000046 ffff880000000000 ffff8800195b6000
May  5 14:15:14 mail kernel: [13560.752082]  ffff880023167c10 
000002c8f27b4000 ffff880023167fd8 ffff88007211a9a0
May  5 14:15:14 mail kernel: [13560.752085]  ffff880023167fd8 
ffff880023167fd8 ffff88007211ac80 ffff880023167fd8
May  5 14:15:14 mail kernel: [13560.752087] Call Trace:
May  5 14:15:14 mail kernel: [13560.752101]  [<ffffffffa0850d02>] ? 
run_clustered_refs+0x132/0x830 [btrfs]
May  5 14:15:14 mail kernel: [13560.752105]  [<ffffffff813aff3d>] 
schedule_timeout+0x2fd/0x380
May  5 14:15:14 mail kernel: [13560.752108]  [<ffffffff813b0cf9>] ? 
mutex_unlock+0x9/0x10
May  5 14:15:14 mail kernel: [13560.752115]  [<ffffffffa087e9f4>] ? 
btrfs_run_ordered_operations+0x1f4/0x210 [btrfs]
May  5 14:15:14 mail kernel: [13560.752122]  [<ffffffffa0860fa3>] 
btrfs_commit_transaction+0x263/0x750 [btrfs]
May  5 14:15:14 mail kernel: [13560.752126]  [<ffffffff81079ff0>] ? 
autoremove_wake_function+0x0/0x40
May  5 14:15:14 mail kernel: [13560.752131]  [<ffffffffa085a9bd>] 
transaction_kthread+0x26d/0x290 [btrfs]
May  5 14:15:14 mail kernel: [13560.752137]  [<ffffffffa085a750>] ? 
transaction_kthread+0x0/0x290 [btrfs]
May  5 14:15:14 mail kernel: [13560.752139]  [<ffffffff81079717>] 
kthread+0x87/0x90
May  5 14:15:14 mail kernel: [13560.752142]  [<ffffffff8100bc24>] 
kernel_thread_helper+0x4/0x10
May  5 14:15:14 mail kernel: [13560.752145]  [<ffffffff81079690>] ? 
kthread+0x0/0x90
May  5 14:15:14 mail kernel: [13560.752147]  [<ffffffff8100bc20>] ? 
kernel_thread_helper+0x0/0x10
May  5 14:15:17 mail kernel: [13564.092081] verify_parent_transid: 40736 
callbacks suppressed
May  5 14:15:17 mail kernel: [13564.092084] parent transid verify failed 
on 3062073683968 wanted 5181 found 5188

--snip--
May  5 14:17:13 mail kernel: [13679.169772] parent transid verify failed 
on 3062073683968 wanted 5181 found 5188
--snip--
May  5 14:17:14 mail kernel: [13680.751996] btrfs-transacti D 
ffff88007211ac78     0  5339      2 0x00000000
May  5 14:17:14 mail kernel: [13680.752000]  ffff880023167d30 
0000000000000046 ffff880000000000 ffff8800195b6000
May  5 14:17:14 mail kernel: [13680.752004]  ffff880023167c10 
000002c8f27b4000 ffff880023167fd8 ffff88007211a9a0
May  5 14:17:14 mail kernel: [13680.752006]  ffff880023167fd8 
ffff880023167fd8 ffff88007211ac80 ffff880023167fd8
May  5 14:17:14 mail kernel: [13680.752009] Call Trace:
May  5 14:17:14 mail kernel: [13680.752024]  [<ffffffffa0850d02>] ? 
run_clustered_refs+0x132/0x830 [btrfs]
May  5 14:17:14 mail kernel: [13680.752030]  [<ffffffff813aff3d>] 
schedule_timeout+0x2fd/0x380
May  5 14:17:14 mail kernel: [13680.752032]  [<ffffffff813b0cf9>] ? 
mutex_unlock+0x9/0x10
May  5 14:17:14 mail kernel: [13680.752040]  [<ffffffffa087e9f4>] ? 
btrfs_run_ordered_operations+0x1f4/0x210 [btrfs]
May  5 14:17:14 mail kernel: [13680.752046]  [<ffffffffa0860fa3>] 
btrfs_commit_transaction+0x263/0x750 [btrfs]
May  5 14:17:14 mail kernel: [13680.752051]  [<ffffffff81079ff0>] ? 
autoremove_wake_function+0x0/0x40
May  5 14:17:14 mail kernel: [13680.752057]  [<ffffffffa085a9bd>] 
transaction_kthread+0x26d/0x290 [btrfs]
May  5 14:17:14 mail kernel: [13680.752062]  [<ffffffffa085a750>] ? 
transaction_kthread+0x0/0x290 [btrfs]
May  5 14:17:14 mail kernel: [13680.752065]  [<ffffffff81079717>] 
kthread+0x87/0x90
May  5 14:17:14 mail kernel: [13680.752068]  [<ffffffff8100bc24>] 
kernel_thread_helper+0x4/0x10
May  5 14:17:14 mail kernel: [13680.752070]  [<ffffffff81079690>] ? 
kthread+0x0/0x90
May  5 14:17:14 mail kernel: [13680.752072]  [<ffffffff8100bc20>] ? 
kernel_thread_helper+0x0/0x10
May  5 14:17:14 mail kernel: [13680.752079] dd              D 
ffff8800714c4838     0  5792   5740 0x00000004
May  5 14:17:14 mail kernel: [13680.752082]  ffff88006a205b38 
0000000000000082 ffff88006a205af8 0000000000000246
May  5 14:17:14 mail kernel: [13680.752085]  ffffea00017f57e8 
ffff88006a205fd8 ffff88006a205fd8 ffff8800714c4560
May  5 14:17:14 mail kernel: [13680.752088]  ffff88006a205fd8 
ffff88006a205fd8 ffff8800714c4840 ffff88006a205fd8
May  5 14:17:14 mail kernel: [13680.752090] Call Trace:
May  5 14:17:14 mail kernel: [13680.752095]  [<ffffffff810ff145>] ? 
zone_statistics+0x75/0x90
May  5 14:17:14 mail kernel: [13680.752098]  [<ffffffff810ea8b7>] ? 
get_page_from_freelist+0x3c7/0x820
May  5 14:17:14 mail kernel: [13680.752101]  [<ffffffff810e3588>] ? 
find_get_page+0x68/0xb0
May  5 14:17:14 mail kernel: [13680.752108]  [<ffffffffa08603f9>] 
wait_current_trans.isra.19+0x79/0xd0 [btrfs]
May  5 14:17:14 mail kernel: [13680.752110]  [<ffffffff81079ff0>] ? 
autoremove_wake_function+0x0/0x40
May  5 14:17:14 mail kernel: [13680.752117]  [<ffffffffa08618cf>] 
start_transaction+0xdf/0x270 [btrfs]
May  5 14:17:14 mail kernel: [13680.752123]  [<ffffffffa0861d9e>] 
btrfs_start_transaction+0xe/0x10 [btrfs]
May  5 14:17:14 mail kernel: [13680.752130]  [<ffffffffa086aa6b>] 
btrfs_setattr+0x10b/0x2b0 [btrfs]
May  5 14:17:14 mail kernel: [13680.752133]  [<ffffffff81159a91>] 
notify_change+0x181/0x350
May  5 14:17:14 mail kernel: [13680.752136]  [<ffffffff8113dd46>] 
do_truncate+0x56/0x90
May  5 14:17:14 mail kernel: [13680.752138]  [<ffffffff8114dde0>] 
finish_open+0x140/0x1b0
May  5 14:17:14 mail kernel: [13680.752140]  [<ffffffff8114dece>] 
do_last+0x7e/0x3f0
May  5 14:17:14 mail kernel: [13680.752142]  [<ffffffff8114e580>] 
do_filp_open+0x340/0x760
May  5 14:17:14 mail kernel: [13680.752145]  [<ffffffff81108cc1>] ? 
handle_mm_fault+0x1a1/0x360
May  5 14:17:14 mail kernel: [13680.752147]  [<ffffffff8113ee14>] 
do_sys_open+0x64/0x110
May  5 14:17:14 mail kernel: [13680.752149]  [<ffffffff8113f48e>] ? 
sys_lseek+0x6e/0x80
May  5 14:17:14 mail kernel: [13680.752151]  [<ffffffff8113eedb>] 
sys_open+0x1b/0x20
May  5 14:17:14 mail kernel: [13680.752153]  [<ffffffff8100ae12>] 
system_call_fastpath+0x16/0x1b
May  5 14:17:18 mail kernel: [13684.172013] verify_parent_transid: 40752 
callbacks suppressed
May  5 14:17:18 mail kernel: [13684.172016] parent transid verify failed 
on 3062073683968 wanted 5181 found 5188

