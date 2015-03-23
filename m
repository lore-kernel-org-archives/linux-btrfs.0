Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:45215 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbbCWP3l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 11:29:41 -0400
Message-ID: <55103155.3040202@skagestad.org>
Date: Mon, 23 Mar 2015 16:29:25 +0100
From: =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>, Chris Mason <clm@fb.com>
CC: fdmanana@gmail.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Linux 4.0.0-rc5 - [ 1851.858652] BTRFS: error (device sda1) in
 cleanup_transaction:1686: errno=-17 Object already exists
References: <550FEC73.9010507@skagestad.org>	<CAL3q7H5E3ftp+02frB2Q3N+pt-wQmLS+1TWgYobqXZg=pu0O0A@mail.gmail.com>	<55100CE5.5020602@itpas.no> <1427118454.5707.5@mail.thefacebook.com> <55101A35.6020406@skagestad.org>
In-Reply-To: <55101A35.6020406@skagestad.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/23/2015 02:50 PM, Torbjørn wrote:
> On 23. mars 2015 14:47, Chris Mason wrote:
>> On Mon, Mar 23, 2015 at 8:53 AM, Torbjørn Skagestad 
>> <torbjorn@itpas.no> wrote:
>>> On 23. mars 2015 13:36, Filipe David Manana wrote:
>>>> On Mon, Mar 23, 2015 at 10:35 AM, Torbjørn <lists@skagestad.org> 
>>>> wrote:
>>>>> Hi,
>>>>>
>>>>> After upgrading to 4.0.0-rc5 from 4.0.0-rc4 I see "Object already 
>>>>> exists"
>>>>> after reboot.
>>>>> The fs is forced read only.
>>>>> The error does not disappear after additional reboots.
>>>> If you go back to 4.0.0-rc4, does the error still happens?
>>>
>>> As mentioned in the email to Chris:
>>> I will try to boot with 4.0.0-rc4 as soon as I get physical access, 
>>> and also revert ea526d18990018f224e5734748975bea1824545f.
>>
>> In order to revert ea526d1899, you need to revert this one first:
>>
>> commit dcdf7f6ddba006f3482ebee73dfa6b75aec5f07b
>> Author: Josef Bacik <jbacik@fb.com>
>> Date:   Mon Mar 2 16:37:31 2015 -0500
>>
>>    Btrfs: prepare block group cache before writing
>>
>>
>> This second commit relies on the first one, things won't work right 
>> with only one gone.
>>
>> -chris
>>
>>
>>
> Thanks,
>
> I would most likely have missed that.
>
> -- 
> Torbjørn

Hi,

Reboot with rc-4 did not fix anything. The same "errno=-17 Object 
already exists" was still present.
Reboot with 3.19.0 failed and went straight to initramfs/busybox.
btrfs-zero-log from busybox allowed boot to 3.19.0
Reboot to 4.0.0-rc4 without problems.

touch tmp.file
sync
btrfs fi sync
No issues
Building a new rc-5 with reverts, also no issues.

git log --oneline |head -n 3
dc68208 Revert "Btrfs: fix ASSERT(list_empty(&cur_trans->dirty_bgs_list)"
f84bf90 Revert "Btrfs: prepare block group cache before writing"
bc465aa Linux 4.0-rc5

make clean;make -j9 deb-pkg

Reboot into 4.0.0-rc5 with reverts
Same warning and read only fs.

[Mon Mar 23 16:07:42 2015] Btrfs loaded
[Mon Mar 23 16:07:42 2015] BTRFS: device label root devid 2 transid 
1881030 /dev/sdd1
[Mon Mar 23 16:07:42 2015] BTRFS: device label root devid 1 transid 
1881030 /dev/sda1
[Mon Mar 23 16:07:42 2015] BTRFS info (device sda1): disk space caching 
is enabled
[Mon Mar 23 16:07:44 2015] init: ureadahead main process (373) 
terminated with status 5
[Mon Mar 23 16:07:45 2015] BTRFS info (device sda1): disk space caching 
is enabled
[Mon Mar 23 16:07:45 2015] BTRFS warning (device sda1): block group 
19356712960 has wrong amount of free space
[Mon Mar 23 16:07:45 2015] BTRFS warning (device sda1): failed to load 
free space cache for block group 19356712960, rebuild it now
[Mon Mar 23 16:07:45 2015] BTRFS warning (device sda1): block group 
20430454784 has wrong amount of free space
[Mon Mar 23 16:07:45 2015] BTRFS warning (device sda1): failed to load 
free space cache for block group 20430454784, rebuild it now
[Mon Mar 23 16:07:49 2015] ------------[ cut here ]------------
[Mon Mar 23 16:07:49 2015] WARNING: CPU: 2 PID: 207 at 
fs/btrfs/super.c:260 __btrfs_abort_transaction+0x54/0x130 [btrfs]()
[Mon Mar 23 16:07:49 2015] BTRFS: Transaction aborted (error -17)
[Mon Mar 23 16:07:49 2015] Modules linked in: btrfs raid10 raid456 
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq 
raid0 multipath linear raid1 hid_generic usbhid hid psmouse e1000e ahci 
libahci ptp mpt2sas pps_core raid_class scsi_transport_sas
[Mon Mar 23 16:07:49 2015] CPU: 2 PID: 207 Comm: kworker/u16:7 Not 
tainted 4.0.0-rc5+ #98
[Mon Mar 23 16:07:49 2015] Hardware name: To be filled by O.E.M. To be 
filled by O.E.M./P8B-X series, BIOS 2107 05/04/2012
[Mon Mar 23 16:07:49 2015] Workqueue: btrfs-extent-refs 
btrfs_extent_refs_helper [btrfs]
[Mon Mar 23 16:07:49 2015]  ffffffffc0583832 ffff88041a3fbc28 
ffffffff8176aaed 0000000000003b5a
[Mon Mar 23 16:07:49 2015]  ffff88041a3fbc78 ffff88041a3fbc68 
ffffffff8107a0ea 0000000000000000
[Mon Mar 23 16:07:49 2015]  ffff88041c9a9210 ffff880418e17800 
00000000ffffffef ffffffffc05820d0
[Mon Mar 23 16:07:49 2015] Call Trace:
[Mon Mar 23 16:07:49 2015]  [<ffffffff8176aaed>] dump_stack+0x45/0x57
[Mon Mar 23 16:07:49 2015]  [<ffffffff8107a0ea>] 
warn_slowpath_common+0x8a/0xc0
[Mon Mar 23 16:07:49 2015]  [<ffffffff8107a166>] warn_slowpath_fmt+0x46/0x50
[Mon Mar 23 16:07:49 2015]  [<ffffffffc04d5c84>] 
__btrfs_abort_transaction+0x54/0x130 [btrfs]
[Mon Mar 23 16:07:49 2015]  [<ffffffffc04f2c0c>] 
btrfs_run_delayed_refs.part.65+0x12c/0x2a0 [btrfs]
[Mon Mar 23 16:07:49 2015]  [<ffffffffc04f2e28>] 
delayed_ref_async_start+0x88/0xa0 [btrfs]
[Mon Mar 23 16:07:49 2015]  [<ffffffffc0534182>] 
normal_work_helper+0xc2/0x2b0 [btrfs]
[Mon Mar 23 16:07:49 2015]  [<ffffffffc05345a2>] 
btrfs_extent_refs_helper+0x12/0x20 [btrfs]
[Mon Mar 23 16:07:49 2015]  [<ffffffff8109326f>] 
process_one_work+0x14f/0x420
[Mon Mar 23 16:07:49 2015]  [<ffffffff81093a28>] worker_thread+0x118/0x510
[Mon Mar 23 16:07:49 2015]  [<ffffffff81093910>] ? 
rescuer_thread+0x3d0/0x3d0
[Mon Mar 23 16:07:49 2015]  [<ffffffff81098ea2>] kthread+0xd2/0xf0
[Mon Mar 23 16:07:49 2015]  [<ffffffff81098dd0>] ? 
kthread_create_on_node+0x180/0x180
[Mon Mar 23 16:07:49 2015]  [<ffffffff81772518>] ret_from_fork+0x58/0x90
[Mon Mar 23 16:07:49 2015]  [<ffffffff81098dd0>] ? 
kthread_create_on_node+0x180/0x180
[Mon Mar 23 16:07:49 2015] ---[ end trace 4cc557b601889d6c ]---
[Mon Mar 23 16:07:49 2015] BTRFS: error (device sda1) in 
btrfs_run_delayed_refs:2790: errno=-17 Object already exists
[Mon Mar 23 16:07:49 2015] BTRFS info (device sda1): forced readonly

--
Torbjørn
