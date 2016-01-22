Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dnvrco-outbound-snat.email.rr.com ([107.14.73.227]:43005 "EHLO
	dnvrco-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751099AbcAVBVF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 20:21:05 -0500
Date: Thu, 21 Jan 2016 17:21:10 -0800 (PST)
From: Rian Hunter <rian@thelig.ht>
To: Chris Murphy <lists@colorremedies.com>
cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: FS corruption when mounting non-degraded after mounting
 degraded
In-Reply-To: <CAJCQCtQLFdWf35bFK2exkSg2yWu2ZtAUO+xDO6j8ZGado9VGNw@mail.gmail.com>
Message-ID: <alpine.OSX.2.20.1601211702400.579@unknown18cf5e8bc07f.att.net>
References: <alpine.OSX.2.20.1601190308520.34954@ioko> <CAGfcS_=0Fu96a=SZwYkkV7Ukk7Jc_8c6sn8ZeiacocTcRbMp8w@mail.gmail.com> <CAJCQCtTSHepYgTxiJ49wPsrO0Hh-NFEcxbo6DzG7XyFyi9ySSg@mail.gmail.com> <alpine.OSX.2.20.1601211317410.38375@ioko>
 <CAJCQCtQLFdWf35bFK2exkSg2yWu2ZtAUO+xDO6j8ZGado9VGNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 21 Jan 2016, Chris Murphy wrote:
> On Thu, Jan 21, 2016 at 3:25 PM, Rian Hunter <rian@thelig.ht> wrote:
>> Start state: Normally functioning raid6 array. Device FOO intermittently
>> fails and requires power cycle to work again. This has happened 25-50
>> times in the past with no irresolvable data corruption.
>
> For each drive, what are the results:
> # smartctl -l scterc /dev/sdX
> # cat /sys/block/sdX/device/timeout

I no longer have the failing drive in my array and it would be a bit
hard to replace it now that all drive bays are full. It was the same
make/model as my other drives.

Notably, the SMART attribute "Command_Timeout" was in the millions
when I removed the device and that is suppossed to be highly
correlated with drive failure.

"SCT Error Recovery Control command not supported" is printed for all my
devices for the "smartctl" command.

# cat /sys/block/sd{a,b,c,d,e,f,g,h}/device/timeout
30
30
30
30
30
30
30
30

>> * Unmount raid6 FS
>> * Disconnect array.
>> * Physically remove device FOO from array, add new device BAR to array.
>> * Connect array
>> * Mount raid6 array with "-o degraded"
>> * Run "btrfs replace start 2 /dev/BAR /mnt"
>> * Start VMs on FS
>> * Machine freezes (not sure why)
>> * Restart machine
>> * Mount raid6 array with "-o degraded"
>> * Replace job continues automatically
>> * Start VMs on FS
>> * After an hour: VMs have no started up yet (seeing hung-task
>>   warnings in kernel). "btrfs replace status /mnt" shows 0.1% done
>
> Do you have dmesg output that includes sysrq+w at the time of the hung
> tasks warnings? That's pretty much always requested by devs in these
> cases.

This is dmesg before the freeze:

Jan 18 15:15:40 nori kernel: [1019147.178187] INFO: task btrfs-transacti:24186 blocked for more than 120 seconds.
Jan 18 15:15:40 nori kernel: [1019147.178196]       Tainted: G        W       4.3.0-1-amd64 #1
Jan 18 15:15:40 nori kernel: [1019147.178199] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 15:15:40 nori kernel: [1019147.178202] btrfs-transacti D ffffffff810a0850     0 24186      2 0x00000000
Jan 18 15:15:40 nori kernel: [1019147.178211]  ffff88034726e0c0 0000000000000046 ffff88046c6ab040 ffff88046ab84000
Jan 18 15:15:40 nori kernel: [1019147.178217]  ffff8803b844ed08 ffff8803b844ecd0 ffff88046ab83de8 ffff88042488fb70
Jan 18 15:15:40 nori kernel: [1019147.178222]  0000000000000000 ffffffff8157d6af ffff8803b844e000 ffffffffa038362d
Jan 18 15:15:40 nori kernel: [1019147.178228] Call Trace:
Jan 18 15:15:40 nori kernel: [1019147.178240]  [<ffffffff8157d6af>] ? schedule+0x2f/0x70
Jan 18 15:15:40 nori kernel: [1019147.178284]  [<ffffffffa038362d>] ? btrfs_scrub_pause+0x8d/0x100 [btrfs]
Jan 18 15:15:40 nori kernel: [1019147.178291]  [<ffffffff810b1520>] ? wake_atomic_t_function+0x60/0x60
Jan 18 15:15:40 nori kernel: [1019147.178322]  [<ffffffffa03270fa>] ? btrfs_commit_transaction+0x47a/0xad0 [btrfs]
Jan 18 15:15:40 nori kernel: [1019147.178350]  [<ffffffffa03277e7>] ? start_transaction+0x97/0x590 [btrfs]
Jan 18 15:15:40 nori kernel: [1019147.178376]  [<ffffffffa03223b0>] ? transaction_kthread+0x220/0x240 [btrfs]
Jan 18 15:15:40 nori kernel: [1019147.178400]  [<ffffffffa0322190>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
Jan 18 15:15:40 nori kernel: [1019147.178407]  [<ffffffff8109044d>] ? kthread+0xcd/0xf0
Jan 18 15:15:40 nori kernel: [1019147.178414]  [<ffffffff81090380>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:15:40 nori kernel: [1019147.178420]  [<ffffffff815816cf>] ? ret_from_fork+0x3f/0x70
Jan 18 15:15:40 nori kernel: [1019147.178426]  [<ffffffff81090380>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:17:40 nori kernel: [1019266.951118] INFO: task btrfs-transacti:24186 blocked for more than 120 seconds.
Jan 18 15:17:40 nori kernel: [1019266.951126]       Tainted: G        W       4.3.0-1-amd64 #1
Jan 18 15:17:40 nori kernel: [1019266.951129] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 15:17:40 nori kernel: [1019266.951133] btrfs-transacti D ffffffff810a0850     0 24186      2 0x00000000
Jan 18 15:17:40 nori kernel: [1019266.951141]  ffff88034726e0c0 0000000000000046 ffff88046c6ab040 ffff88046ab84000
Jan 18 15:17:40 nori kernel: [1019266.951147]  ffff8803b844ed08 ffff8803b844ecd0 ffff88046ab83de8 ffff88042488fb70
Jan 18 15:17:40 nori kernel: [1019266.951152]  0000000000000000 ffffffff8157d6af ffff8803b844e000 ffffffffa038362d
Jan 18 15:17:40 nori kernel: [1019266.951158] Call Trace:
Jan 18 15:17:40 nori kernel: [1019266.951170]  [<ffffffff8157d6af>] ? schedule+0x2f/0x70
Jan 18 15:17:40 nori kernel: [1019266.951213]  [<ffffffffa038362d>] ? btrfs_scrub_pause+0x8d/0x100 [btrfs]
Jan 18 15:17:40 nori kernel: [1019266.951219]  [<ffffffff810b1520>] ? wake_atomic_t_function+0x60/0x60
Jan 18 15:17:40 nori kernel: [1019266.951251]  [<ffffffffa03270fa>] ? btrfs_commit_transaction+0x47a/0xad0 [btrfs]
Jan 18 15:17:40 nori kernel: [1019266.951278]  [<ffffffffa03277e7>] ? start_transaction+0x97/0x590 [btrfs]
Jan 18 15:17:40 nori kernel: [1019266.951304]  [<ffffffffa03223b0>] ? transaction_kthread+0x220/0x240 [btrfs]
Jan 18 15:17:40 nori kernel: [1019266.951328]  [<ffffffffa0322190>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
Jan 18 15:17:40 nori kernel: [1019266.951335]  [<ffffffff8109044d>] ? kthread+0xcd/0xf0
Jan 18 15:17:40 nori kernel: [1019266.951341]  [<ffffffff81090380>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:17:40 nori kernel: [1019266.951348]  [<ffffffff815816cf>] ? ret_from_fork+0x3f/0x70
Jan 18 15:17:40 nori kernel: [1019266.951354]  [<ffffffff81090380>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:17:40 nori kernel: [1019266.951368] INFO: task lxc-start:25363 blocked for more than 120 seconds.
Jan 18 15:17:40 nori kernel: [1019266.951371]       Tainted: G        W       4.3.0-1-amd64 #1
Jan 18 15:17:40 nori kernel: [1019266.951374] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 15:17:40 nori kernel: [1019266.951376] lxc-start       D ffffffff810a0850     0 25363      1 0x00000000
Jan 18 15:17:40 nori kernel: [1019266.951382]  ffff8801d8319140 0000000000000082 ffff88046c6f8080 ffff88002f49c000
Jan 18 15:17:40 nori kernel: [1019266.951387]  ffff8803dab7e1f0 ffff880237740b98 ffff8803dab7e1f0 0000000000000001
Jan 18 15:17:40 nori kernel: [1019266.951392]  ffff8801d8319140 ffffffff8157d6af ffff88042488fb70 ffffffffa032611d
Jan 18 15:17:40 nori kernel: [1019266.951397] Call Trace:
Jan 18 15:17:40 nori kernel: [1019266.951402]  [<ffffffff8157d6af>] ? schedule+0x2f/0x70
Jan 18 15:17:40 nori kernel: [1019266.951424]  [<ffffffffa032611d>] ? wait_current_trans.isra.21+0xcd/0x110 [btrfs]
Jan 18 15:17:40 nori kernel: [1019266.951429]  [<ffffffff810b1520>] ? wake_atomic_t_function+0x60/0x60
Jan 18 15:17:40 nori kernel: [1019266.951453]  [<ffffffffa0327b66>] ? start_transaction+0x416/0x590 [btrfs]
Jan 18 15:17:40 nori kernel: [1019266.951481]  [<ffffffffa0336309>] ? btrfs_create+0x49/0x1f0 [btrfs]
Jan 18 15:17:40 nori kernel: [1019266.951488]  [<ffffffff811d856a>] ? vfs_create+0xba/0x120
Jan 18 15:17:40 nori kernel: [1019266.951494]  [<ffffffff811db9d0>] ? path_openat+0x1120/0x1260
Jan 18 15:17:40 nori kernel: [1019266.951498]  [<ffffffff811d6d00>] ? terminate_walk+0x40/0xc0
Jan 18 15:17:40 nori kernel: [1019266.951503]  [<ffffffff811dc0e1>] ? filename_lookup+0xf1/0x180
Jan 18 15:17:40 nori kernel: [1019266.951509]  [<ffffffff811dcca1>] ? do_filp_open+0x91/0x100
Jan 18 15:17:40 nori kernel: [1019266.951516]  [<ffffffff811cc4e9>] ? do_sys_open+0x139/0x220
Jan 18 15:17:40 nori kernel: [1019266.951522]  [<ffffffff81581332>] ? system_call_fast_compare_end+0xc/0x67

Relavant dmesg after the restart:

Jan 18 15:24:06 nori kernel: [  205.325598] BTRFS: device fsid f3b9a0ff-85f4-40d0-a130-04db96d92836 devid 5 transid 67149 /dev/dm-3
Jan 18 15:24:19 nori kernel: [  218.385633] BTRFS: device fsid f3b9a0ff-85f4-40d0-a130-04db96d92836 devid 4 transid 67149 /dev/dm-4
Jan 18 15:24:24 nori kernel: [  223.122442] BTRFS: device fsid f3b9a0ff-85f4-40d0-a130-04db96d92836 devid 1 transid 67149 /dev/dm-5
Jan 18 15:24:30 nori kernel: [  228.995711] BTRFS: device fsid f3b9a0ff-85f4-40d0-a130-04db96d92836 devid 3 transid 67149 /dev/dm-6
Jan 18 15:24:43 nori kernel: [  242.305643] BTRFS: device fsid f3b9a0ff-85f4-40d0-a130-04db96d92836 devid 0 transid 67149 /dev/dm-7
Jan 18 15:24:44 nori kernel: [  243.036998] BTRFS info (device dm-7): allowing degraded mounts
Jan 18 15:24:44 nori kernel: [  243.037009] BTRFS info (device dm-7): disk space caching is enabled
Jan 18 15:24:44 nori kernel: [  243.037013] BTRFS: has skinny extents
Jan 18 15:24:44 nori kernel: [  243.038806] BTRFS warning (device dm-7): devid 2 uuid 4ac0186c-ad43-448c-855b-df265ae31975 is missing
Jan 18 15:24:48 nori kernel: [  247.008168] BTRFS: continuing dev_replace from <missing disk> (devid 2) to /dev/dm-7 @0%
Jan 18 15:28:41 nori kernel: [  479.247257] device vethAG2VFQ entered promiscuous mode
Jan 18 15:28:41 nori kernel: [  479.247302] IPv6: ADDRCONF(NETDEV_UP): vethAG2VFQ: link is not ready
Jan 18 15:28:42 nori kernel: [  480.263321] eth0: renamed from vethGCO23Y
Jan 18 15:28:42 nori kernel: [  480.289101] IPv6: ADDRCONF(NETDEV_CHANGE): vethAG2VFQ: link becomes ready
Jan 18 15:28:42 nori kernel: [  480.289150] lxc-bridge-nat: port 1(vethAG2VFQ) entered forwarding state
Jan 18 15:28:42 nori kernel: [  480.289172] lxc-bridge-nat: port 1(vethAG2VFQ) entered forwarding state
Jan 18 15:48:41 nori kernel: [ 1676.618159] INFO: task btrfs-transacti:2351 blocked for more than 120 seconds.
Jan 18 15:48:41 nori kernel: [ 1676.618167]       Not tainted 4.3.0-1-amd64 #1
Jan 18 15:48:41 nori kernel: [ 1676.618170] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 15:48:41 nori kernel: [ 1676.618174] btrfs-transacti D ffffffff810a08c0     0  2351      2 0x00000000
Jan 18 15:48:41 nori kernel: [ 1676.618182]  ffff88044c282100 0000000000000046 ffff88046c6a9180 ffff88044c36c000
Jan 18 15:48:41 nori kernel: [ 1676.618188]  ffff88044c36ba50 7fffffffffffffff ffffffff815818d0 ffff88044c36bac8
Jan 18 15:48:41 nori kernel: [ 1676.618193]  ffffea000fdaa880 ffffffff8158113f 0000000000000000 ffffffff81583ee9
Jan 18 15:48:41 nori kernel: [ 1676.618199] Call Trace:
Jan 18 15:48:41 nori kernel: [ 1676.618211]  [<ffffffff815818d0>] ? bit_wait+0x40/0x40
Jan 18 15:48:41 nori kernel: [ 1676.618216]  [<ffffffff8158113f>] ? schedule+0x2f/0x70
Jan 18 15:48:41 nori kernel: [ 1676.618223]  [<ffffffff81583ee9>] ? schedule_timeout+0x189/0x250
Jan 18 15:48:41 nori kernel: [ 1676.618262]  [<ffffffffa038d930>] ? __raid56_parity_write+0x30/0x40 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618295]  [<ffffffffa038eb6f>] ? raid56_parity_write+0x15f/0x170 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618324]  [<ffffffffa038b87e>] ? btrfs_bio_counter_sub+0x1e/0x50 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618355]  [<ffffffffa0347e0b>] ? btrfs_map_bio+0xfb/0x330 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618360]  [<ffffffff815818d0>] ? bit_wait+0x40/0x40
Jan 18 15:48:41 nori kernel: [ 1676.618365]  [<ffffffff815807cd>] ? io_schedule_timeout+0x9d/0x100
Jan 18 15:48:41 nori kernel: [ 1676.618370]  [<ffffffff81581901>] ? bit_wait_io+0x31/0x50
Jan 18 15:48:41 nori kernel: [ 1676.618375]  [<ffffffff815814d8>] ? __wait_on_bit+0x58/0x90
Jan 18 15:48:41 nori kernel: [ 1676.618402]  [<ffffffffa031e042>] ? btrfs_submit_bio_hook+0xe2/0x190 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618408]  [<ffffffff8115e646>] ? wait_on_page_bit+0xc6/0xe0
Jan 18 15:48:41 nori kernel: [ 1676.618414]  [<ffffffff810b15d0>] ? autoremove_wake_function+0x40/0x40
Jan 18 15:48:41 nori kernel: [ 1676.618445]  [<ffffffffa033ce52>] ? extent_write_cache_pages.isra.30.constprop.50+0x252/0x360 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618475]  [<ffffffffa033e0ad>] ? extent_writepages+0x5d/0x90 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618503]  [<ffffffffa0320660>] ? btrfs_real_readdir+0x530/0x530 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618509]  [<ffffffff81160465>] ? __filemap_fdatawrite_range+0xc5/0x100
Jan 18 15:48:41 nori kernel: [ 1676.618537]  [<ffffffffa0331dfb>] ? btrfs_fdatawrite_range+0x1b/0x50 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618567]  [<ffffffffa035e397>] ? __btrfs_write_out_cache.isra.25+0x407/0x450 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618596]  [<ffffffffa035f891>] ? btrfs_write_out_cache+0x91/0xe0 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618619]  [<ffffffffa030adea>] ? btrfs_start_dirty_block_groups+0x1ea/0x3e0 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618644]  [<ffffffffa031be44>] ? btrfs_commit_transaction+0x1c4/0xad0 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618668]  [<ffffffffa031c7e7>] ? start_transaction+0x97/0x590 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618690]  [<ffffffffa03173b0>] ? transaction_kthread+0x220/0x240 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618711]  [<ffffffffa0317190>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
Jan 18 15:48:41 nori kernel: [ 1676.618718]  [<ffffffff810904bd>] ? kthread+0xcd/0xf0
Jan 18 15:48:41 nori kernel: [ 1676.618724]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:48:41 nori kernel: [ 1676.618730]  [<ffffffff8158514f>] ? ret_from_fork+0x3f/0x70
Jan 18 15:48:41 nori kernel: [ 1676.618736]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:50:41 nori kernel: [ 1796.383713] INFO: task btrfs-transacti:2351 blocked for more than 120 seconds.
Jan 18 15:50:41 nori kernel: [ 1796.383721]       Not tainted 4.3.0-1-amd64 #1
Jan 18 15:50:41 nori kernel: [ 1796.383724] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 15:50:41 nori kernel: [ 1796.383727] btrfs-transacti D ffffffff810a08c0     0  2351      2 0x00000000
Jan 18 15:50:41 nori kernel: [ 1796.383736]  ffff88044c282100 0000000000000046 ffff88046c6a9180 ffff88044c36c000
Jan 18 15:50:41 nori kernel: [ 1796.383742]  ffff88044c36ba50 7fffffffffffffff ffffffff815818d0 ffff88044c36bac8
Jan 18 15:50:41 nori kernel: [ 1796.383747]  ffffea000fdaa880 ffffffff8158113f 0000000000000000 ffffffff81583ee9
Jan 18 15:50:41 nori kernel: [ 1796.383752] Call Trace:
Jan 18 15:50:41 nori kernel: [ 1796.383764]  [<ffffffff815818d0>] ? bit_wait+0x40/0x40
Jan 18 15:50:41 nori kernel: [ 1796.383770]  [<ffffffff8158113f>] ? schedule+0x2f/0x70
Jan 18 15:50:41 nori kernel: [ 1796.383776]  [<ffffffff81583ee9>] ? schedule_timeout+0x189/0x250
Jan 18 15:50:41 nori kernel: [ 1796.383817]  [<ffffffffa038d930>] ? __raid56_parity_write+0x30/0x40 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.383853]  [<ffffffffa038eb6f>] ? raid56_parity_write+0x15f/0x170 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.383884]  [<ffffffffa038b87e>] ? btrfs_bio_counter_sub+0x1e/0x50 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.383916]  [<ffffffffa0347e0b>] ? btrfs_map_bio+0xfb/0x330 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.383921]  [<ffffffff815818d0>] ? bit_wait+0x40/0x40
Jan 18 15:50:41 nori kernel: [ 1796.383926]  [<ffffffff815807cd>] ? io_schedule_timeout+0x9d/0x100
Jan 18 15:50:41 nori kernel: [ 1796.383931]  [<ffffffff81581901>] ? bit_wait_io+0x31/0x50
Jan 18 15:50:41 nori kernel: [ 1796.383936]  [<ffffffff815814d8>] ? __wait_on_bit+0x58/0x90
Jan 18 15:50:41 nori kernel: [ 1796.383963]  [<ffffffffa031e042>] ? btrfs_submit_bio_hook+0xe2/0x190 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.383970]  [<ffffffff8115e646>] ? wait_on_page_bit+0xc6/0xe0
Jan 18 15:50:41 nori kernel: [ 1796.383976]  [<ffffffff810b15d0>] ? autoremove_wake_function+0x40/0x40
Jan 18 15:50:41 nori kernel: [ 1796.384008]  [<ffffffffa033ce52>] ? extent_write_cache_pages.isra.30.constprop.50+0x252/0x360 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.384040]  [<ffffffffa033e0ad>] ? extent_writepages+0x5d/0x90 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.384068]  [<ffffffffa0320660>] ? btrfs_real_readdir+0x530/0x530 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.384074]  [<ffffffff81160465>] ? __filemap_fdatawrite_range+0xc5/0x100
Jan 18 15:50:41 nori kernel: [ 1796.384103]  [<ffffffffa0331dfb>] ? btrfs_fdatawrite_range+0x1b/0x50 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.384133]  [<ffffffffa035e397>] ? __btrfs_write_out_cache.isra.25+0x407/0x450 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.384162]  [<ffffffffa035f891>] ? btrfs_write_out_cache+0x91/0xe0 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.384186]  [<ffffffffa030adea>] ? btrfs_start_dirty_block_groups+0x1ea/0x3e0 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.384212]  [<ffffffffa031be44>] ? btrfs_commit_transaction+0x1c4/0xad0 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.384235]  [<ffffffffa031c7e7>] ? start_transaction+0x97/0x590 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.384258]  [<ffffffffa03173b0>] ? transaction_kthread+0x220/0x240 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.384280]  [<ffffffffa0317190>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
Jan 18 15:50:41 nori kernel: [ 1796.384287]  [<ffffffff810904bd>] ? kthread+0xcd/0xf0
Jan 18 15:50:41 nori kernel: [ 1796.384293]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:50:41 nori kernel: [ 1796.384300]  [<ffffffff8158514f>] ? ret_from_fork+0x3f/0x70
Jan 18 15:50:41 nori kernel: [ 1796.384305]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:54:41 nori kernel: [ 2035.918749] INFO: task btrfs-transacti:2351 blocked for more than 120 seconds.
Jan 18 15:54:41 nori kernel: [ 2035.918757]       Not tainted 4.3.0-1-amd64 #1
Jan 18 15:54:41 nori kernel: [ 2035.918760] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 15:54:41 nori kernel: [ 2035.918763] btrfs-transacti D ffffffff810a08c0     0  2351      2 0x00000000
Jan 18 15:54:41 nori kernel: [ 2035.918772]  ffff88044c282100 0000000000000046 ffff88046c6f6140 ffff88044c36c000
Jan 18 15:54:41 nori kernel: [ 2035.918777]  ffff88046a970d08 ffff88046a970cd0 ffff88044c36bde8 ffff880450288d10
Jan 18 15:54:41 nori kernel: [ 2035.918782]  0000000000000000 ffffffff8158113f ffff88046a970000 ffffffffa037862d
Jan 18 15:54:41 nori kernel: [ 2035.918788] Call Trace:
Jan 18 15:54:41 nori kernel: [ 2035.918800]  [<ffffffff8158113f>] ? schedule+0x2f/0x70
Jan 18 15:54:41 nori kernel: [ 2035.918844]  [<ffffffffa037862d>] ? btrfs_scrub_pause+0x8d/0x100 [btrfs]
Jan 18 15:54:41 nori kernel: [ 2035.918851]  [<ffffffff810b1590>] ? wake_atomic_t_function+0x60/0x60
Jan 18 15:54:41 nori kernel: [ 2035.918881]  [<ffffffffa031c0fa>] ? btrfs_commit_transaction+0x47a/0xad0 [btrfs]
Jan 18 15:54:41 nori kernel: [ 2035.918907]  [<ffffffffa031c7e7>] ? start_transaction+0x97/0x590 [btrfs]
Jan 18 15:54:41 nori kernel: [ 2035.918932]  [<ffffffffa03173b0>] ? transaction_kthread+0x220/0x240 [btrfs]
Jan 18 15:54:41 nori kernel: [ 2035.918954]  [<ffffffffa0317190>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
Jan 18 15:54:41 nori kernel: [ 2035.918961]  [<ffffffff810904bd>] ? kthread+0xcd/0xf0
Jan 18 15:54:41 nori kernel: [ 2035.918968]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:54:41 nori kernel: [ 2035.918975]  [<ffffffff8158514f>] ? ret_from_fork+0x3f/0x70
Jan 18 15:54:41 nori kernel: [ 2035.918980]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:54:41 nori kernel: [ 2035.918999] INFO: task gzip:5211 blocked for more than 120 seconds.
Jan 18 15:54:41 nori kernel: [ 2035.919002]       Not tainted 4.3.0-1-amd64 #1
Jan 18 15:54:41 nori kernel: [ 2035.919004] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 15:54:41 nori kernel: [ 2035.919007] gzip            D ffffffff810a08c0     0  5211   5173 0x00000100
Jan 18 15:54:41 nori kernel: [ 2035.919012]  ffff8803f941f0c0 0000000000000086 ffff88046c6a8140 ffff8803de66c000
Jan 18 15:54:41 nori kernel: [ 2035.919018]  ffff88044c2991f0 ffff8803f4f3eae0 ffff88044c2991f0 0000000000000001
Jan 18 15:54:41 nori kernel: [ 2035.919023]  ffff8803f941f0c0 ffffffff8158113f ffff880450288d10 ffffffffa031b11d
Jan 18 15:54:41 nori kernel: [ 2035.919028] Call Trace:
Jan 18 15:54:41 nori kernel: [ 2035.919033]  [<ffffffff8158113f>] ? schedule+0x2f/0x70
Jan 18 15:54:41 nori kernel: [ 2035.919056]  [<ffffffffa031b11d>] ? wait_current_trans.isra.21+0xcd/0x110 [btrfs]
Jan 18 15:54:41 nori kernel: [ 2035.919061]  [<ffffffff810b1590>] ? wake_atomic_t_function+0x60/0x60
Jan 18 15:54:41 nori kernel: [ 2035.919083]  [<ffffffffa031cb66>] ? start_transaction+0x416/0x590 [btrfs]
Jan 18 15:54:41 nori kernel: [ 2035.919088]  [<ffffffff811e5935>] ? __d_lookup+0x75/0x150
Jan 18 15:54:41 nori kernel: [ 2035.919111]  [<ffffffffa031da0f>] ? __unlink_start_trans+0x1f/0xb0 [btrfs]
Jan 18 15:54:41 nori kernel: [ 2035.919135]  [<ffffffffa0325d23>] ? btrfs_unlink+0x23/0xa0 [btrfs]
Jan 18 15:54:41 nori kernel: [ 2035.919141]  [<ffffffff811d9667>] ? vfs_unlink+0xe7/0x190
Jan 18 15:54:41 nori kernel: [ 2035.919147]  [<ffffffff811dcaa9>] ? do_unlinkat+0x299/0x2d0
Jan 18 15:54:41 nori kernel: [ 2035.919154]  [<ffffffff81584db2>] ? system_call_fast_compare_end+0xc/0x67
Jan 18 15:56:41 nori kernel: [ 2155.710465] INFO: task btrfs-transacti:2351 blocked for more than 120 seconds.
Jan 18 15:56:41 nori kernel: [ 2155.710473]       Not tainted 4.3.0-1-amd64 #1
Jan 18 15:56:41 nori kernel: [ 2155.710475] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 15:56:41 nori kernel: [ 2155.710478] btrfs-transacti D ffffffff810a08c0     0  2351      2 0x00000000
Jan 18 15:56:41 nori kernel: [ 2155.710487]  ffff88044c282100 0000000000000046 ffff88046c6f6140 ffff88044c36c000
Jan 18 15:56:41 nori kernel: [ 2155.710493]  ffff88046a970d08 ffff88046a970cd0 ffff88044c36bde8 ffff880450288d10
Jan 18 15:56:41 nori kernel: [ 2155.710498]  0000000000000000 ffffffff8158113f ffff88046a970000 ffffffffa037862d
Jan 18 15:56:41 nori kernel: [ 2155.710504] Call Trace:
Jan 18 15:56:41 nori kernel: [ 2155.710516]  [<ffffffff8158113f>] ? schedule+0x2f/0x70
Jan 18 15:56:41 nori kernel: [ 2155.710559]  [<ffffffffa037862d>] ? btrfs_scrub_pause+0x8d/0x100 [btrfs]
Jan 18 15:56:41 nori kernel: [ 2155.710566]  [<ffffffff810b1590>] ? wake_atomic_t_function+0x60/0x60
Jan 18 15:56:41 nori kernel: [ 2155.710597]  [<ffffffffa031c0fa>] ? btrfs_commit_transaction+0x47a/0xad0 [btrfs]
Jan 18 15:56:41 nori kernel: [ 2155.710624]  [<ffffffffa031c7e7>] ? start_transaction+0x97/0x590 [btrfs]
Jan 18 15:56:41 nori kernel: [ 2155.710650]  [<ffffffffa03173b0>] ? transaction_kthread+0x220/0x240 [btrfs]
Jan 18 15:56:41 nori kernel: [ 2155.710674]  [<ffffffffa0317190>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
Jan 18 15:56:41 nori kernel: [ 2155.710681]  [<ffffffff810904bd>] ? kthread+0xcd/0xf0
Jan 18 15:56:41 nori kernel: [ 2155.710688]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:56:41 nori kernel: [ 2155.710695]  [<ffffffff8158514f>] ? ret_from_fork+0x3f/0x70
Jan 18 15:56:41 nori kernel: [ 2155.710700]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:56:41 nori kernel: [ 2155.710719] INFO: task gzip:5211 blocked for more than 120 seconds.
Jan 18 15:56:41 nori kernel: [ 2155.710722]       Not tainted 4.3.0-1-amd64 #1
Jan 18 15:56:41 nori kernel: [ 2155.710724] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 15:56:41 nori kernel: [ 2155.710727] gzip            D ffffffff810a08c0     0  5211   5173 0x00000100
Jan 18 15:56:41 nori kernel: [ 2155.710732]  ffff8803f941f0c0 0000000000000086 ffff88046c6a8140 ffff8803de66c000
Jan 18 15:56:41 nori kernel: [ 2155.710737]  ffff88044c2991f0 ffff8803f4f3eae0 ffff88044c2991f0 0000000000000001
Jan 18 15:56:41 nori kernel: [ 2155.710742]  ffff8803f941f0c0 ffffffff8158113f ffff880450288d10 ffffffffa031b11d
Jan 18 15:56:41 nori kernel: [ 2155.710747] Call Trace:
Jan 18 15:56:41 nori kernel: [ 2155.710753]  [<ffffffff8158113f>] ? schedule+0x2f/0x70
Jan 18 15:56:41 nori kernel: [ 2155.710776]  [<ffffffffa031b11d>] ? wait_current_trans.isra.21+0xcd/0x110 [btrfs]
Jan 18 15:56:41 nori kernel: [ 2155.710781]  [<ffffffff810b1590>] ? wake_atomic_t_function+0x60/0x60
Jan 18 15:56:41 nori kernel: [ 2155.710804]  [<ffffffffa031cb66>] ? start_transaction+0x416/0x590 [btrfs]
Jan 18 15:56:41 nori kernel: [ 2155.710809]  [<ffffffff811e5935>] ? __d_lookup+0x75/0x150
Jan 18 15:56:41 nori kernel: [ 2155.710833]  [<ffffffffa031da0f>] ? __unlink_start_trans+0x1f/0xb0 [btrfs]
Jan 18 15:56:41 nori kernel: [ 2155.710859]  [<ffffffffa0325d23>] ? btrfs_unlink+0x23/0xa0 [btrfs]
Jan 18 15:56:41 nori kernel: [ 2155.710868]  [<ffffffff811d9667>] ? vfs_unlink+0xe7/0x190
Jan 18 15:56:41 nori kernel: [ 2155.710874]  [<ffffffff811dcaa9>] ? do_unlinkat+0x299/0x2d0
Jan 18 15:56:41 nori kernel: [ 2155.710882]  [<ffffffff81584db2>] ? system_call_fast_compare_end+0xc/0x67
Jan 18 15:58:41 nori kernel: [ 2275.507816] INFO: task btrfs-transacti:2351 blocked for more than 120 seconds.
Jan 18 15:58:41 nori kernel: [ 2275.507824]       Not tainted 4.3.0-1-amd64 #1
Jan 18 15:58:41 nori kernel: [ 2275.507826] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 15:58:41 nori kernel: [ 2275.507830] btrfs-transacti D ffffffff810a08c0     0  2351      2 0x00000000
Jan 18 15:58:41 nori kernel: [ 2275.507838]  ffff88044c282100 0000000000000046 ffff88046c6f6140 ffff88044c36c000
Jan 18 15:58:41 nori kernel: [ 2275.507844]  ffff88046a970d08 ffff88046a970cd0 ffff88044c36bde8 ffff880450288d10
Jan 18 15:58:41 nori kernel: [ 2275.507849]  0000000000000000 ffffffff8158113f ffff88046a970000 ffffffffa037862d
Jan 18 15:58:41 nori kernel: [ 2275.507855] Call Trace:
Jan 18 15:58:41 nori kernel: [ 2275.507866]  [<ffffffff8158113f>] ? schedule+0x2f/0x70
Jan 18 15:58:41 nori kernel: [ 2275.507909]  [<ffffffffa037862d>] ? btrfs_scrub_pause+0x8d/0x100 [btrfs]
Jan 18 15:58:41 nori kernel: [ 2275.507916]  [<ffffffff810b1590>] ? wake_atomic_t_function+0x60/0x60
Jan 18 15:58:41 nori kernel: [ 2275.507946]  [<ffffffffa031c0fa>] ? btrfs_commit_transaction+0x47a/0xad0 [btrfs]
Jan 18 15:58:41 nori kernel: [ 2275.507974]  [<ffffffffa031c7e7>] ? start_transaction+0x97/0x590 [btrfs]
Jan 18 15:58:41 nori kernel: [ 2275.508000]  [<ffffffffa03173b0>] ? transaction_kthread+0x220/0x240 [btrfs]
Jan 18 15:58:41 nori kernel: [ 2275.508022]  [<ffffffffa0317190>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
Jan 18 15:58:41 nori kernel: [ 2275.508030]  [<ffffffff810904bd>] ? kthread+0xcd/0xf0
Jan 18 15:58:41 nori kernel: [ 2275.508036]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:58:41 nori kernel: [ 2275.508043]  [<ffffffff8158514f>] ? ret_from_fork+0x3f/0x70
Jan 18 15:58:41 nori kernel: [ 2275.508049]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 15:58:41 nori kernel: [ 2275.508067] INFO: task gzip:5211 blocked for more than 120 seconds.
Jan 18 15:58:41 nori kernel: [ 2275.508070]       Not tainted 4.3.0-1-amd64 #1
Jan 18 15:58:41 nori kernel: [ 2275.508072] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 15:58:41 nori kernel: [ 2275.508075] gzip            D ffffffff810a08c0     0  5211   5173 0x00000100
Jan 18 15:58:41 nori kernel: [ 2275.508080]  ffff8803f941f0c0 0000000000000086 ffff88046c6a8140 ffff8803de66c000
Jan 18 15:58:41 nori kernel: [ 2275.508086]  ffff88044c2991f0 ffff8803f4f3eae0 ffff88044c2991f0 0000000000000001
Jan 18 15:58:41 nori kernel: [ 2275.508091]  ffff8803f941f0c0 ffffffff8158113f ffff880450288d10 ffffffffa031b11d
Jan 18 15:58:41 nori kernel: [ 2275.508095] Call Trace:
Jan 18 15:58:41 nori kernel: [ 2275.508101]  [<ffffffff8158113f>] ? schedule+0x2f/0x70
Jan 18 15:58:41 nori kernel: [ 2275.508123]  [<ffffffffa031b11d>] ? wait_current_trans.isra.21+0xcd/0x110 [btrfs]
Jan 18 15:58:41 nori kernel: [ 2275.508128]  [<ffffffff810b1590>] ? wake_atomic_t_function+0x60/0x60
Jan 18 15:58:41 nori kernel: [ 2275.508152]  [<ffffffffa031cb66>] ? start_transaction+0x416/0x590 [btrfs]
Jan 18 15:58:41 nori kernel: [ 2275.508157]  [<ffffffff811e5935>] ? __d_lookup+0x75/0x150
Jan 18 15:58:41 nori kernel: [ 2275.508181]  [<ffffffffa031da0f>] ? __unlink_start_trans+0x1f/0xb0 [btrfs]
Jan 18 15:58:41 nori kernel: [ 2275.508207]  [<ffffffffa0325d23>] ? btrfs_unlink+0x23/0xa0 [btrfs]
Jan 18 15:58:41 nori kernel: [ 2275.508213]  [<ffffffff811d9667>] ? vfs_unlink+0xe7/0x190
Jan 18 15:58:41 nori kernel: [ 2275.508219]  [<ffffffff811dcaa9>] ? do_unlinkat+0x299/0x2d0
Jan 18 15:58:41 nori kernel: [ 2275.508226]  [<ffffffff81584db2>] ? system_call_fast_compare_end+0xc/0x67
Jan 18 16:00:41 nori kernel: [ 2395.299270] INFO: task btrfs-transacti:2351 blocked for more than 120 seconds.
Jan 18 16:00:41 nori kernel: [ 2395.299278]       Not tainted 4.3.0-1-amd64 #1
Jan 18 16:00:41 nori kernel: [ 2395.299281] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 16:00:41 nori kernel: [ 2395.299284] btrfs-transacti D ffffffff810a08c0     0  2351      2 0x00000000
Jan 18 16:00:41 nori kernel: [ 2395.299293]  ffff88044c282100 0000000000000046 ffff88046c6f6140 ffff88044c36c000
Jan 18 16:00:41 nori kernel: [ 2395.299299]  ffff88046a970d08 ffff88046a970cd0 ffff88044c36bde8 ffff880450288d10
Jan 18 16:00:41 nori kernel: [ 2395.299304]  0000000000000000 ffffffff8158113f ffff88046a970000 ffffffffa037862d
Jan 18 16:00:41 nori kernel: [ 2395.299309] Call Trace:
Jan 18 16:00:41 nori kernel: [ 2395.299322]  [<ffffffff8158113f>] ? schedule+0x2f/0x70
Jan 18 16:00:41 nori kernel: [ 2395.299365]  [<ffffffffa037862d>] ? btrfs_scrub_pause+0x8d/0x100 [btrfs]
Jan 18 16:00:41 nori kernel: [ 2395.299371]  [<ffffffff810b1590>] ? wake_atomic_t_function+0x60/0x60
Jan 18 16:00:41 nori kernel: [ 2395.299402]  [<ffffffffa031c0fa>] ? btrfs_commit_transaction+0x47a/0xad0 [btrfs]
Jan 18 16:00:41 nori kernel: [ 2395.299429]  [<ffffffffa031c7e7>] ? start_transaction+0x97/0x590 [btrfs]
Jan 18 16:00:41 nori kernel: [ 2395.299455]  [<ffffffffa03173b0>] ? transaction_kthread+0x220/0x240 [btrfs]
Jan 18 16:00:41 nori kernel: [ 2395.299478]  [<ffffffffa0317190>] ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
Jan 18 16:00:41 nori kernel: [ 2395.299485]  [<ffffffff810904bd>] ? kthread+0xcd/0xf0
Jan 18 16:00:41 nori kernel: [ 2395.299492]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 16:00:41 nori kernel: [ 2395.299499]  [<ffffffff8158514f>] ? ret_from_fork+0x3f/0x70
Jan 18 16:00:41 nori kernel: [ 2395.299505]  [<ffffffff810903f0>] ? kthread_create_on_node+0x190/0x190
Jan 18 16:00:41 nori kernel: [ 2395.299522] INFO: task gzip:5211 blocked for more than 120 seconds.
Jan 18 16:00:41 nori kernel: [ 2395.299526]       Not tainted 4.3.0-1-amd64 #1
Jan 18 16:00:41 nori kernel: [ 2395.299528] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 18 16:00:41 nori kernel: [ 2395.299530] gzip            D ffffffff810a08c0     0  5211   5173 0x00000100
Jan 18 16:00:41 nori kernel: [ 2395.299536]  ffff8803f941f0c0 0000000000000086 ffff88046c6a8140 ffff8803de66c000
Jan 18 16:00:41 nori kernel: [ 2395.299541]  ffff88044c2991f0 ffff8803f4f3eae0 ffff88044c2991f0 0000000000000001
Jan 18 16:00:41 nori kernel: [ 2395.299546]  ffff8803f941f0c0 ffffffff8158113f ffff880450288d10 ffffffffa031b11d
Jan 18 16:00:41 nori kernel: [ 2395.299551] Call Trace:
Jan 18 16:00:41 nori kernel: [ 2395.299557]  [<ffffffff8158113f>] ? schedule+0x2f/0x70
Jan 18 16:00:41 nori kernel: [ 2395.299580]  [<ffffffffa031b11d>] ? wait_current_trans.isra.21+0xcd/0x110 [btrfs]
Jan 18 16:00:41 nori kernel: [ 2395.299585]  [<ffffffff810b1590>] ? wake_atomic_t_function+0x60/0x60
Jan 18 16:00:41 nori kernel: [ 2395.299608]  [<ffffffffa031cb66>] ? start_transaction+0x416/0x590 [btrfs]
Jan 18 16:00:41 nori kernel: [ 2395.299614]  [<ffffffff811e5935>] ? __d_lookup+0x75/0x150
Jan 18 16:00:41 nori kernel: [ 2395.299637]  [<ffffffffa031da0f>] ? __unlink_start_trans+0x1f/0xb0 [btrfs]
Jan 18 16:00:41 nori kernel: [ 2395.299662]  [<ffffffffa0325d23>] ? btrfs_unlink+0x23/0xa0 [btrfs]
Jan 18 16:00:41 nori kernel: [ 2395.299669]  [<ffffffff811d9667>] ? vfs_unlink+0xe7/0x190
Jan 18 16:00:41 nori kernel: [ 2395.299674]  [<ffffffff811dcaa9>] ? do_unlinkat+0x299/0x2d0
Jan 18 16:00:41 nori kernel: [ 2395.299681]  [<ffffffff81584db2>] ? system_call_fast_compare_end+0xc/0x67

After that last line, I cancelled the replace and unmounted the FS and
then proceeded to start it again with the previously missing drive.

>> * Cancel replace: "btrfs replace cancel /mnt"
>> * Unmount raid6 FS
>> * Disconnect array
>> * Physically add device FOO back to array
>> * Reconnect array
>> * Mount raid6 array normally (no "-o degraded")
>> * Run "btrfs replace start 2 /dev/BAR /mnt"
>
> Hmm. Open question if 'btrfs replace cancel' actually marked /dev/BAR
> as wiped. If it doesn't, then this 2nd replace start should have
> failed unless you had used -f, or you used wipefs -a. If it's not
> wiped by any of the above, then I'd expect it's possible things get
> messy.

I'm fairly positive that it must have marked it as wiped because I
don't remember it failing or having to use -f.


> Some others (no devs however) have disagreed with me on this, so take
> it with a grain of salt, but I don't understand the rationale of
> running scrub on degraded arrays. The first order of business is to
> get it non-degraded. If that can't be done, scrub is pointless. Of
> course it's going to produce millions of unrecoverable errors. There's
> a device missing, so I'd expect many unrecoverable errors during a
> degraded scrub.

Yes I searched and I found your opinion on this. I was fairly
confident that the "unrecoverable errors" in the scrub were due to it
being degraded.  I did the scrub because I felt I was running out of
options.

My only opinion, after going through this experience would be that
btrfs-scrub fail fast and returned a hard error like "Cannot scrub
degraded mount." That would have saved me some time.

>> From a black box perspective, this led me to believe that the
>> corruption happened during the replace operation after mounting
>> normally after first mounting with "-o degraded." Of course,
>> knowledge of the internals could easily verify this.
>
> Filesystems are really difficult, so even knowledge of the internals
> doesn't guarantee the devs will understand where the problem first
> started in this case.

Fair point. I have experience writing a file system myself and I agree.
Though sometimes it helps when you have a non-zero mental model of
the internals.
