Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:58986 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab3CZTWO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 15:22:14 -0400
Message-ID: <5151F56C.5070502@profihost.ag>
Date: Tue, 26 Mar 2013 20:22:20 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
References: <20130326125319.GH1955@localhost.localdomain> <51519ABB.4030207@profihost.ag> <20130326133053.GK1955@localhost.localdomain> <5151A75C.6080703@profihost.ag> <20130326144426.GL1955@localhost.localdomain> <5151B8AF.60900@profihost.ag> <20130326152553.GN1955@localhost.localdomain> <5151CA87.3050801@profihost.ag> <20130326174554.GB28030@localhost.localdomain> <5151F180.4050405@profihost.ag> <20130326191651.GF28030@localhost.localdomain>
In-Reply-To: <20130326191651.GF28030@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

but when i transfer big files i see now this one:
[20368.784736] INFO: task rsync:14911 blocked for more than 120 seconds.
[20368.821978] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[20368.895140] rsync           D ffffffff8160f580     0 14911      1 
0x00000000
[20368.895148]  ffff8801ca63fc78 0000000000000086 ffff8800c28f8198 
ffff88022394f800
[20368.895158]  ffff8801ca63ffd8 ffff8801ca63ffd8 ffff8801ca63ffd8 
0000000000012c40
[20368.895163]  ffffffff81a11440 ffff8801c9d36340 ffff8801ca63fc88 
ffff8801cefce130
[20368.895169] Call Trace:
[20368.895180]  [<ffffffff8151a774>] schedule+0x24/0x70
[20368.895207]  [<ffffffffa0158c75>] 
wait_current_trans.isra.32+0x95/0x100 [btrfs]
[20368.895214]  [<ffffffff8106d4f0>] ? add_wait_queue+0x60/0x60
[20368.895236]  [<ffffffffa015a45d>] 
start_transaction.part.33+0x13d/0x4d0 [btrfs]
[20368.895252]  [<ffffffff811420f3>] ? inode_permission+0x13/0x50
[20368.895271]  [<ffffffffa015a814>] start_transaction+0x24/0x30 [btrfs]
[20368.895287]  [<ffffffffa015aae3>] btrfs_start_transaction+0x13/0x20 
[btrfs]
[20368.895302]  [<ffffffffa015b2f0>] __unlink_start_trans+0x70/0x460 [btrfs]
[20368.895307]  [<ffffffff8150ee3e>] ? check_acl+0x5a/0x122
[20368.895312]  [<ffffffff81055ff0>] ? ns_capable+0x30/0x60
[20368.895317]  [<ffffffff811413bd>] ? generic_permission+0xbd/0x110
[20368.895336]  [<ffffffffa0163f92>] btrfs_unlink+0x32/0xc0 [btrfs]
[20368.895341]  [<ffffffff8114186d>] vfs_unlink.part.61+0x6d/0xd0
[20368.895345]  [<ffffffff81143ad7>] vfs_unlink+0x37/0x50
[20368.895349]  [<ffffffff81143c8b>] do_unlinkat+0x19b/0x240
[20368.895354]  [<ffffffff81146171>] sys_unlink+0x11/0x20
[20368.895359]  [<ffffffff8151c2e9>] system_call_fastpath+0x16/0x1b

Speed is just 100kb/s instead of 100MB/s.

Stefan

Am 26.03.2013 20:16, schrieb Josef Bacik:
> On Tue, Mar 26, 2013 at 01:05:36PM -0600, Stefan Priebe wrote:
>> Hi Josef,
>>
>> Am 26.03.2013 18:45, schrieb Josef Bacik:
>>>> Am 26.03.2013 16:25, schrieb Josef Bacik:
>>>>> On Tue, Mar 26, 2013 at 09:03:11AM -0600, Stefan Priebe - Profihost AG wrote:
>>>>>> Hi,
>>>>>> Am 26.03.2013 15:44, schrieb Josef Bacik:
>>>>>>>>>> Am 26.03.2013 13:53, schrieb Josef Bacik:
>>>>>>>>>> no - it's just mounted with mount -o noatime
>>>>>>>>>>
>>>>>>>>>> :~# cat /proc/mounts | grep btrfs
>>>>>>>>>> /dev/mapper/raid54tb1 /mnt btrfs rw,noatime,space_cache 0 0
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Ok I think I see what's going on.  Can you try this patch and see if it fixes
>>>>>>>>> it?  Thanks,
>>>>>>>>
>>>>>>>> It still does not fix the problem.
>>>>>>>>
>>>>>>>> The rsync output looks like this so it does not work for file a but then
>>>>>>>> continues on c d e, ...
>>>>>>>>
>>>>>>>> sync -av --progress /backup/ /mnt/
>>>>>>>> sending incremental file list
>>>>>>>> .etc_openvpn/ipp.txt
>>>>>>>>             229 100%    3.99kB/s    0:00:00 (xfer#2, to-check=1009/1196)
>>>>>>>> .etc_openvpn/openvpn-status.log
>>>>>>>>             360 100%    6.28kB/s    0:00:00 (xfer#3, to-check=1007/1196)
>>>>>>>> rsync: rename "/mnt/.etc_openvpn/.ipp.txt.t9lucX" ->
>>>>>>>> ".etc_openvpn/ipp.txt": No space left on device (28)
>>>>>>>> .log/
>>>>>>>> .log/UcliEvt.log
>>>>>>>>          104188 100%  147.67kB/s    0:00:00 (xfer#4, to-check=1131/2700)
>>>>>>>> .log/auth.log
>>>>>>>>        15211522 100%    2.97MB/s    0:00:04 (xfer#5, to-check=1105/2700)
>>>>>>>> .log/auth.log.1
>>>>>>>>        19431424  61%    7.35MB/s    0:00:01
>>>>>>>>
>>>>>>>> the dmesg output looks like this:
>>>>>>>> [  551.321576] returning enospc, space_info 3, size 0 reserved 0, flush
>>>>>>>> 2, flush_state 7  dumping space info
>>>>>>>> [  551.323694] space_info 4 has 6439526400 free, is full
>>>>>>>> [  551.323696] space_info total=25748307968, used=19308666880, pinned=0,
>>>>>>>> reserved=49152, may_use=6438453248, readonly=65536
>>>>>>>>
>>>>>>>
>>>>>>> Ok so then this is probably it, let me know if it helps.  Thanks,
>>>>>>
>>>>>> OK it now has copied a lot of files (170) without an error all were very
>>>>>> small.
>>>>>>
>>>>>
>>>>> Welp progress is good.  Throw this into the mix and go again, it's just adding
>>>>> some more debugging so I can make sure I'm going down the right rabbit hole.
>>>>> Thanks,
>>>>
>>>> Output is now:
>>>> [ 9587.445642] returning enospc, space_info 3, size 0 reserved 0, flush
>>>> 2, flush_state 7  dumping space info
>>>> [ 9587.527392] dumping block rsv 2, size 0 reserved 0
>>>> [ 9587.567871] dumping block rsv 5, size 196608 reserved 196608
>>>> [ 9587.607661] dumping block rsv 1, size 6438256640 reserved 6438256640
>>>> [ 9587.646958] space_info 4 has 6439428096 free, is full
>>>> [ 9587.646963] space_info total=25748307968, used=19308769280, pinned=0,
>>>> reserved=45056, may_use=6438453248, readonly=65536
>>>> [ 9587.649410] returning enospc, space_info 3, size 0 reserved 0, flush
>>>> 2, flush_state 7  dumping space info
>>>> [ 9587.727000] dumping block rsv 2, size 0 reserved 0
>>>> [ 9587.765284] dumping block rsv 5, size 98304 reserved 98304
>>>> [ 9587.802849] dumping block rsv 1, size 6438256640 reserved 6438256640
>>>> [ 9587.839935] space_info 4 has 6439428096 free, is full
>>>> [ 9587.839936] space_info total=25748307968, used=19308769280, pinned=0,
>>>> reserved=45056, may_use=6438354944, readonly=65536
>>>>
>>>
>>> Well then that looks like I was going down the wrong rabbit hole.  This should
>>> fix you up, for real this time ;).  Thanks,
>>
>> Yes - this works now. Which of the patches can i drop? Do i just need
>> the last one?
>> Is it safe to add another 18TB raid via converting it to btrfs raid0?
>> Will the fix be part of 3.9-rc5?
>>
>
> So I'll put together all of the patches that actually need to go up for this and
> post them, but basically its the mutex patch, the last patch I sent you and the
> one that adjusts the reservations for rename and delete.  Thanks,
>
> Josef
>
