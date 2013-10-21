Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:40372 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3JUQMY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 12:12:24 -0400
Received: by mail-ea0-f173.google.com with SMTP id g10so3648204eak.32
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 09:12:22 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 21 Oct 2013 18:12:22 +0200
Message-ID: <CAD_cGvEwU+WFNZaW=3KwQZST=_PWH62GVNiZd8zs9NCKRA-RUg@mail.gmail.com>
Subject: System crash with recursive btrfs defrag on kernel 3.11.5
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I decided to try full defrag on my btrfs array today. Sadly the system
crashed after a few hours.
No data lost as far as I have seen after reboot and the filesystem is
mounted and seemingly ok now.
Any ideas?

Hardware:
CPU: Intel Xeon X3430
MB: Supermicro X8SI6-F
RAM: 16GB (4x4GB) Samsung ECC/Unbuffered DDR3 1333mhz CL9
(MEM-DR340L-SL01-EU13)
HDDs in btrfs RAID10: 4 x Western Digital Se 4TB 64MB 7200RPM SATA
6Gb/s (WD4000F9YZ)
HBAs: LSI SAS 9211-8i, LSI SAS 9201-16i

Software:
- Kernel v3.11.5. Debian standard config for 3.2 + olddefconfig
- Debian Wheezy 7.2 64-bit
- btrfs-progs v0.20-rc1
- Command in screen shell (screen -l -S defrag):
---
sudo find /btrfs/storage-vol0 -xdev \( -type f -o -type d \) -exec
btrfs filesystem defragment -- {} +
----

btrfs fi df /btrfs/storage-vol0/
-----
Data, RAID10: total=6.73TB, used=6.22TB
Data: total=8.00MB, used=0.00
System, RAID10: total=16.00MB, used=744.00KB
System: total=4.00MB, used=0.00
Metadata, RAID10: total=10.00GB, used=8.76GB
Metadata: total=8.00MB, used=0.00
-----

btrfs fi show --all-devices
-----
Label: none  uuid: b64daec7-6c14-4996-94b3-80c6abfa26ce
        Total devices 4 FS bytes used 6.22TB
        devid    2 size 3.64TB used 3.37TB path /dev/sdm
        devid    4 size 3.64TB used 3.37TB path /dev/sdo
        devid    1 size 3.64TB used 3.37TB path /dev/sdl
        devid    3 size 3.64TB used 3.37TB path /dev/sdn
-----

cat /etc/fstab | grep btrfs
-----
UUID=b64daec7-6c14-4996-94b3-80c6abfa26ce   /btrfs
             btrfs   defaults,compress=lzo           0   2
UUID=b64daec7-6c14-4996-94b3-80c6abfa26ce   /storage/storage-vol0
             btrfs   defaults,subvol=storage-vol0    0   2
-----

btrfs subvolume list /storage/storage-vol0/
-----
ID 259 gen 63363 top level 5 path storage-vol0
ID 4162 gen 63356 top level 5 path backups/storage-vol0_2013-10-18_182648
ID 4163 gen 63356 top level 5 path backups/storage-vol0_2013-10-18_183302
ID 4164 gen 63356 top level 5 path backups/storage-vol0_2013-10-18_213301
ID 4165 gen 63356 top level 5 path backups/storage-vol0_2013-10-19_003301
ID 4166 gen 63356 top level 5 path backups/storage-vol0_2013-10-19_033301
ID 4167 gen 63356 top level 5 path backups/storage-vol0_2013-10-19_063301
ID 4168 gen 63356 top level 5 path backups/storage-vol0_2013-10-19_093301
ID 4169 gen 63356 top level 5 path backups/storage-vol0_2013-10-19_115516
ID 4170 gen 63356 top level 5 path backups/storage-vol0_2013-10-19_115534
ID 4171 gen 63356 top level 5 path backups/storage-vol0_2013-10-19_123301
ID 4172 gen 63356 top level 5 path backups/storage-vol0_2013-10-19_153301
ID 4173 gen 63356 top level 5 path backups/storage-vol0_2013-10-19_183301
ID 4174 gen 63356 top level 5 path backups/storage-vol0_2013-10-19_213301
ID 4175 gen 63356 top level 5 path backups/storage-vol0_2013-10-20_003301
ID 4176 gen 63356 top level 5 path backups/storage-vol0_2013-10-20_033301
ID 4177 gen 63356 top level 5 path backups/storage-vol0_2013-10-20_063301
ID 4178 gen 63356 top level 5 path backups/storage-vol0_2013-10-20_093301
ID 4179 gen 63356 top level 5 path backups/storage-vol0_2013-10-20_123301
ID 4180 gen 63356 top level 5 path backups/storage-vol0_2013-10-20_153301
ID 4181 gen 63356 top level 5 path backups/storage-vol0_2013-10-20_183301
ID 4182 gen 63356 top level 5 path backups/storage-vol0_2013-10-20_213301
ID 4183 gen 63356 top level 5 path backups/storage-vol0_2013-10-21_003301
ID 4184 gen 63356 top level 5 path backups/storage-vol0_2013-10-21_033301
ID 4185 gen 63356 top level 5 path backups/storage-vol0_2013-10-21_063301
ID 4186 gen 63356 top level 5 path backups/storage-vol0_2013-10-21_093301
ID 4187 gen 63356 top level 5 path backups/storage-vol0_2013-10-21_123301
ID 4188 gen 63356 top level 5 path backups/storage-vol0_2013-10-21_153301
----


Error message in /var/log/syslog
----
Oct 21 13:20:54 merkur kernel: [150476.396320] INFO: task
kworker/u16:0:10146 blocked for more than 120 seconds.
Oct 21 13:20:54 merkur kernel: [150476.396346] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 21 13:20:54 merkur kernel: [150476.396364] kworker/u16:0   D
ffff88043fc92ec0     0 10146      2 0x00000000
Oct 21 13:20:54 merkur kernel: [150476.396375] Workqueue: writeback
bdi_writeback_workfn (flush-btrfs-1)
Oct 21 13:20:54 merkur kernel: [150476.396378]  ffff880224535180
0000000000000046 ffff88042f0c5180 0000000000000000
Oct 21 13:20:54 merkur kernel: [150476.396383]  0000000000012ec0
ffff8800618f1fd8 ffff8800618f1fd8 ffff880224535180
Oct 21 13:20:54 merkur kernel: [150476.396387]  0000000000000246
ffff88010e6bdd78 ffff8804218b79e8 ffff8800618f1740
Oct 21 13:20:54 merkur kernel: [150476.396392] Call Trace:
Oct 21 13:20:54 merkur kernel: [150476.396430]  [<ffffffffa0181bb1>] ?
wait_current_trans.isra.28+0xbc/0x117 [btrfs]
Oct 21 13:20:54 merkur kernel: [150476.396436]  [<ffffffff8104fd15>] ?
wake_up_atomic_t+0x22/0x22
Oct 21 13:20:54 merkur kernel: [150476.396458]  [<ffffffffa01834df>] ?
start_transaction+0x1d3/0x46d [btrfs]
Oct 21 13:20:54 merkur kernel: [150476.396481]  [<ffffffffa01886b5>] ?
run_delalloc_nocow+0xa2/0x7aa [btrfs]
Oct 21 13:20:54 merkur kernel: [150476.396505]  [<ffffffffa0197f62>] ?
__set_extent_bit+0x329/0x36d [btrfs]
Oct 21 13:20:54 merkur kernel: [150476.396529]  [<ffffffffa0188ee6>] ?
run_delalloc_range+0x64/0x333 [btrfs]
Oct 21 13:20:54 merkur kernel: [150476.396553]  [<ffffffffa0197a24>] ?
free_extent_state+0x12/0x21 [btrfs]
Oct 21 13:20:54 merkur kernel: [150476.396576]  [<ffffffffa019a779>] ?
__extent_writepage+0x1e5/0x62a [btrfs]
Oct 21 13:20:54 merkur kernel: [150476.396592]  [<ffffffffa0007444>] ?
scsi_request_fn+0x411/0x4e8 [scsi_mod]
Oct 21 13:20:54 merkur kernel: [150476.396598]  [<ffffffff810be424>] ?
find_get_pages_tag+0x66/0x121
Oct 21 13:20:54 merkur kernel: [150476.396622]  [<ffffffffa019ad08>] ?
extent_write_cache_pages.isra.23.constprop.45+0x14a/0x255 [btrfs]
Oct 21 13:20:54 merkur kernel: [150476.396645]  [<ffffffffa018461f>] ?
btrfs_submit_bio_hook+0x14f/0x14f [btrfs]
Oct 21 13:20:54 merkur kernel: [150476.396669]  [<ffffffffa019b04f>] ?
extent_writepages+0x49/0x60 [btrfs]
Oct 21 13:20:54 merkur kernel: [150476.396692]  [<ffffffffa01865cf>] ?
btrfs_submit_direct+0x3c8/0x3c8 [btrfs]
Oct 21 13:20:54 merkur kernel: [150476.396697]  [<ffffffff811202b0>] ?
__writeback_single_inode+0x6d/0x1e8
Oct 21 13:20:54 merkur kernel: [150476.396701]  [<ffffffff81120af4>] ?
writeback_sb_inodes+0x1f0/0x322
Oct 21 13:20:54 merkur kernel: [150476.396705]  [<ffffffff81120c8f>] ?
__writeback_inodes_wb+0x69/0xab
Oct 21 13:20:54 merkur kernel: [150476.396709]  [<ffffffff81120e07>] ?
wb_writeback+0x136/0x292
Oct 21 13:20:54 merkur kernel: [150476.396714]  [<ffffffff8104c295>] ?
set_worker_desc+0x61/0x6c
Oct 21 13:20:54 merkur kernel: [150476.396718]  [<ffffffff81121784>] ?
bdi_writeback_workfn+0xc1/0x29f
Oct 21 13:20:54 merkur kernel: [150476.396722]  [<ffffffff81057304>] ?
mmdrop+0xd/0x1c
Oct 21 13:20:54 merkur kernel: [150476.396726]  [<ffffffff81057ef7>] ?
finish_task_switch+0x7e/0xa8
Oct 21 13:20:54 merkur kernel: [150476.396731]  [<ffffffff8104a540>] ?
process_one_work+0x191/0x294
Oct 21 13:20:54 merkur kernel: [150476.396735]  [<ffffffff8104a9f2>] ?
worker_thread+0x121/0x1e7
Oct 21 13:20:54 merkur kernel: [150476.396740]  [<ffffffff8104a8d1>] ?
rescuer_thread+0x269/0x269
Oct 21 13:20:54 merkur kernel: [150476.396744]  [<ffffffff8104f375>] ?
kthread+0x81/0x89
Oct 21 13:20:54 merkur kernel: [150476.396748]  [<ffffffff8104f2f4>] ?
__kthread_parkme+0x5d/0x5d
Oct 21 13:20:54 merkur kernel: [150476.396753]  [<ffffffff81371f2c>] ?
ret_from_fork+0x7c/0xb0
Oct 21 13:20:54 merkur kernel: [150476.396757]  [<ffffffff8104f2f4>] ?
__kthread_parkme+0x5d/0x5d
----

Mvh

Hans-Kristian Bakke
Mob: 91 76 17 38
