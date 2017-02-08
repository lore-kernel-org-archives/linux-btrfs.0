Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:34471 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932077AbdBHB2T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 20:28:19 -0500
Received: by mail-ua0-f172.google.com with SMTP id 35so98662424uak.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 17:28:19 -0800 (PST)
MIME-Version: 1.0
From: Peter Zaitsev <pz@percona.com>
Date: Tue, 7 Feb 2017 20:28:17 -0500
Message-ID: <CA+RUij17gdN-iyVvQpDJXqshby-4=JOsGT5OAgzQai+H=r3L2w@mail.gmail.com>
Subject: Troubleshooting crash due to running out of space issues
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running BTRFS on Ubuntu 16.04  - I was testing intensive database
IO which ends up with pretty fragmented data file:

root@blinky:/var/lib/mysql/sbtest# filefrag sbtest1.ibd

sbtest1.ibd: 13415923 extents found

This is 500G device which is some 60% full:

/dev/nvme0n1                500107608 308009444 189718556  62% /mnt/data/mysql

root@blinky:/# btrfs fi show Label: none uuid:
2a396366-e3c9-4d14-b4cc-3d8992bd1c6b Total devices 1 FS bytes used
293.24GiB devid 1 size 476.94GiB used 476.94GiB path /dev/nvme0n1


this file (sbtest1.ibd) takes some 250GB - majority of space

As I try to defrag this file with:

btrfs fi defrag sbtest1.ibd

I get either error of "no space available"   and file system goes to
read only or filesystem completely breaks down and IO errors are
reported.

Note during my experiments I have mounted this filesystem repeatedly
with and without nodatacow and autodefrag   options, I assume these
should not cause any file system dammage, do they ?

Here is the portion of the latest log:

Feb  7 19:10:42 blinky kernel: [40722.055010] ------------[ cut here
]------------
Feb  7 19:10:42 blinky kernel: [40722.055060] WARNING: CPU: 12 PID:
17002 at /build/linux-W6HB68/linux-4.4.0/fs/btrfs/extent-tree.c:6552
__btrfs_free_extent.isr
a.70+0x2e6/0xd30 [btrfs]()
Feb  7 19:10:42 blinky kernel: [40722.055063] BTRFS: error (device
nvme0n1) in __btrfs_free_extent:6552: errno=-28 No space left
Feb  7 19:10:42 blinky kernel: [40722.055066] BTRFS info (device
nvme0n1): forced readonly
Feb  7 19:10:42 blinky kernel: [40722.055068] BTRFS: error (device
nvme0n1) in btrfs_run_delayed_refs:2927: errno=-28 No space left
Feb  7 19:10:42 blinky kernel: [40722.055086] BTRFS: Transaction
aborted (error -28)
Feb  7 19:10:42 blinky kernel: [40722.055087] Modules linked in:
snd_hda_codec_hdmi nls_iso8859_1 intel_rapl x86_pkg_temp_thermal
intel_powerclamp coretemp kvm
snd_hda_codec_realtek irqbypass snd_hda_codec_generic serio_raw
sb_edac snd_hda_intel edac_core snd_hda_codec snd_hda_core snd_hwdep
snd_pcm input_leds snd_time
r mei_me lpc_ich snd mei soundcore shpchp tpm_infineon mac_hid ib_iser
rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp
libiscsi_tcp libiscsi scsi_tra
nsport_iscsi autofs4 btrfs raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1
raid0 multipath linear hid_gen
eric usbhid hid nouveau crct10dif_pclmul mxm_wmi crc32_pclmul video
ghash_clmulni_intel i2c_algo_bit aesni_intel ttm aes_x86_64 lrw
drm_kms_helper gf128mul glue
_helper ablk_helper syscopyarea psmouse cryptd sysfillrect e1000e
sysimgblt fb_sys_fops ahci libahci alx ptp drm mdio pps_core nvme fjes
wmi
Feb  7 19:10:42 blinky kernel: [40722.055180] CPU: 12 PID: 17002 Comm:
btrfs-transacti Tainted: G        W       4.4.0-62-generic #83-Ubuntu
Feb  7 19:10:42 blinky kernel: [40722.055181] Hardware name: Gigabyte
Technology Co., Ltd. Default string/X99-Ultra Gaming-CF, BIOS F5
08/29/2016
Feb  7 19:10:42 blinky kernel: [40722.055183]  0000000000000286
000000007c7f47a0 ffff880f1b4c7b00 ffffffff813f7c63
Feb  7 19:10:42 blinky kernel: [40722.055185]  ffff880f1b4c7b48
ffffffffc0392498 ffff880f1b4c7b38 ffffffff810812d2
Feb  7 19:10:42 blinky kernel: [40722.055188]  0000007021b82000
00000000ffffffe4 0000000000000000 ffff880fe62a4000
Feb  7 19:10:42 blinky kernel: [40722.055190] Call Trace:
Feb  7 19:10:42 blinky kernel: [40722.055197]  [<ffffffff813f7c63>]
dump_stack+0x63/0x90
Feb  7 19:10:42 blinky kernel: [40722.055202]  [<ffffffff810812d2>]
warn_slowpath_common+0x82/0xc0
Feb  7 19:10:42 blinky kernel: [40722.055205]  [<ffffffff8108136c>]
warn_slowpath_fmt+0x5c/0x80
Feb  7 19:10:42 blinky kernel: [40722.055219]  [<ffffffffc02f1ec6>]
__btrfs_free_extent.isra.70+0x2e6/0xd30 [btrfs]
Feb  7 19:10:42 blinky kernel: [40722.055232]  [<ffffffffc02f5e34>]
__btrfs_run_delayed_refs+0x444/0x11f0 [btrfs]
Feb  7 19:10:42 blinky kernel: [40722.055236]  [<ffffffff810ece94>] ?
lock_timer_base.isra.22+0x54/0x70
Feb  7 19:10:42 blinky kernel: [40722.055248]  [<ffffffffc02f9a8d>]
btrfs_run_delayed_refs+0x7d/0x2a0 [btrfs]
Feb  7 19:10:42 blinky kernel: [40722.055251]  [<ffffffff810ed018>] ?
del_timer_sync+0x48/0x50
Feb  7 19:10:42 blinky kernel: [40722.055266]  [<ffffffffc030ecbc>]
btrfs_commit_transaction+0xac/0xa90 [btrfs]
Feb  7 19:10:42 blinky kernel: [40722.055279]  [<ffffffffc030a2b9>]
transaction_kthread+0x229/0x240 [btrfs]
Feb  7 19:10:42 blinky kernel: [40722.055291]  [<ffffffffc030a090>] ?
btrfs_cleanup_transaction+0x570/0x570 [btrfs]
Feb  7 19:10:42 blinky kernel: [40722.055294]  [<ffffffff810a0ba8>]
kthread+0xd8/0xf0
Feb  7 19:10:42 blinky kernel: [40722.055296]  [<ffffffff810a0ad0>] ?
kthread_create_on_node+0x1e0/0x1e0
Feb  7 19:10:42 blinky kernel: [40722.055300]  [<ffffffff8183898f>]
ret_from_fork+0x3f/0x70
Feb  7 19:10:42 blinky kernel: [40722.055301]  [<ffffffff810a0ad0>] ?
kthread_create_on_node+0x1e0/0x1e0
Feb  7 19:10:42 blinky kernel: [40722.055303] ---[ end trace
92a6418dcae8a352 ]---
Feb  7 19:10:42 blinky kernel: [40722.055306] BTRFS: error (device
nvme0n1) in __btrfs_free_extent:6552: errno=-28 No space left
Feb  7 19:10:42 blinky kernel: [40722.055314] BTRFS: error (device
nvme0n1) in btrfs_run_delayed_refs:2927: errno=-28 No space left
Feb  7 19:10:42 blinky kernel: [40722.353231] pending csums is 482394112
Feb  7 19:11:28 blinky kernel: [40768.119500] BTRFS error (device
nvme0n1): parent transid verify failed on 249832390656 wanted 5084
found 5065
Feb  7 19:11:28 blinky kernel: [40768.119517] BTRFS info (device
nvme0n1): no csum found for inode 554 start 34088566784
Feb  7 19:11:28 blinky kernel: [40768.119675] BTRFS error (device
nvme0n1): parent transid verify failed on 249832390656 wanted 5084
found 5065
Feb  7 19:11:28 blinky kernel: [40768.119682] BTRFS info (device
nvme0n1): no csum found for inode 554 start 34088570880
Feb  7 19:11:28 blinky kernel: [40768.119835] BTRFS error (device
nvme0n1): parent transid verify failed on 249832390656 wanted 5084
found 5065
Feb  7 19:11:28 blinky kernel: [40768.119842] BTRFS info (device
nvme0n1): no csum found for inode 554 start 34088574976
Feb  7 19:11:28 blinky kernel: [40768.119996] BTRFS error (device
nvme0n1): parent transid verify failed on 249832390656 wanted 5084
found 5065
Feb  7 19:11:28 blinky kernel: [40768.120006] BTRFS info (device
nvme0n1): no csum found for inode 554 start 34088579072
Feb  7 19:11:28 blinky kernel: [40768.120110] BTRFS warning (device
nvme0n1): csum failed ino 554 off 34088566784 csum 1373278930 expected
csum 0
Feb  7 19:11:28 blinky kernel: [40768.120115] BTRFS warning (device
nvme0n1): csum failed ino 554 off 34088570880 csum 4181088238 expected
csum 0
Feb  7 19:11:28 blinky kernel: [40768.120117] BTRFS warning (device
nvme0n1): csum failed ino 554 off 34088574976 csum 3715803016 expected
csum 0
Feb  7 19:11:28 blinky kernel: [40768.120120] BTRFS warning (device
nvme0n1): csum failed ino 554 off 34088579072 csum 1194440854 expected
csum 0
Feb  7 19:11:30 blinky kernel: [40770.940061] BTRFS error (device
nvme0n1): parent transid verify failed on 249827934208 wanted 5084
found 5065
Feb  7 19:11:30 blinky kernel: [40770.940078] BTRFS info (device
nvme0n1): no csum found for inode 554 start 34968256512
Feb  7 19:11:30 blinky kernel: [40770.940235] BTRFS error (device
nvme0n1): parent transid verify failed on 249827934208 wanted 5084
found 5065
Feb  7 19:11:30 blinky kernel: [40770.940243] BTRFS info (device
nvme0n1): no csum found for inode 554 start 34968260608
Feb  7 19:11:30 blinky kernel: [40770.940395] BTRFS error (device
nvme0n1): parent transid verify failed on 249827934208 wanted 5084
found 5065
Feb  7 19:11:30 blinky kernel: [40770.940403] BTRFS info (device
nvme0n1): no csum found for inode 554 start 34968264704
Feb  7 19:11:30 blinky kernel: [40770.940558] BTRFS error (device
nvme0n1): parent transid verify failed on 249827934208 wanted 5084
found 5065
Feb  7 19:11:30 blinky kernel: [40770.940566] BTRFS info (device
nvme0n1): no csum found for inode 554 start 34968268800
Feb  7 19:11:30 blinky kernel: [40770.940692] BTRFS warning (device
nvme0n1): csum failed ino 554 off 34968256512 csum 3504832266 expected
csum 0
Feb  7 19:11:30 blinky kernel: [40770.940697] BTRFS warning (device
nvme0n1): csum failed ino 554 off 34968260608 csum 3188344593 expected
csum 0
Feb  7 19:11:30 blinky kernel: [40770.940700] BTRFS warning (device
nvme0n1): csum failed ino 554 off 34968264704 csum 3938983550 expected
csum 0
Feb  7 19:11:30 blinky kernel: [40770.940703] BTRFS warning (device
nvme0n1): csum failed ino 554 off 34968268800 csum 238540766 expected
csum 0
Feb  7 19:11:34 blinky kernel: [40774.871386] BTRFS error (device
nvme0n1): parent transid verify failed on 329898901504 wanted 5084
found 5065
Feb  7 19:11:34 blinky kernel: [40774.871403] BTRFS info (device
nvme0n1): no csum found for inode 554 start 36158881792
Feb  7 19:11:34 blinky kernel: [40774.871527] BTRFS error (device
nvme0n1): parent transid verify failed on 329898901504 wanted 5084
found 5065
Feb  7 19:11:34 blinky kernel: [40774.871535] BTRFS info (device
nvme0n1): no csum found for inode 554 start 36158885888
Feb  7 19:11:34 blinky kernel: [40774.871655] BTRFS error (device
nvme0n1): parent transid verify failed on 329898901504 wanted 5084
found 5065
Feb  7 19:11:34 blinky kernel: [40774.871662] BTRFS info (device
nvme0n1): no csum found for inode 554 start 36158889984
Feb  7 19:11:34 blinky kernel: [40774.871784] BTRFS error (device
nvme0n1): parent transid verify failed on 329898901504 wanted 5084
found 5065
Feb  7 19:11:34 blinky kernel: [40774.871791] BTRFS info (device
nvme0n1): no csum found for inode 554 start 36158894080
Feb  7 19:11:34 blinky kernel: [40774.871886] BTRFS warning (device
nvme0n1): csum failed ino 554 off 36158881792 csum 2472964550 expected
csum 0
Feb  7 19:11:34 blinky kernel: [40774.871890] BTRFS warning (device
nvme0n1): csum failed ino 554 off 36158885888 csum 2540567641 expected
csum 0
Feb  7 19:11:34 blinky kernel: [40774.871894] BTRFS warning (device
nvme0n1): csum failed ino 554 off 36158889984 csum 1718736600 expected
csum 0
Feb  7 19:11:34 blinky kernel: [40774.871896] BTRFS warning (device
nvme0n1): csum failed ino 554 off 36158894080 csum 1541543398 expected
csum 0
Feb  7 19:11:36 blinky kernel: [40776.947022] BTRFS error (device
nvme0n1): parent transid verify failed on 249831424000 wanted 5084
found 5065
Feb  7 19:11:36 blinky kernel: [40776.947037] BTRFS info (device
nvme0n1): no csum found for inode 554 start 36834557952

I have performed scrub before running defrag it did not find any errors.

This is the test data which I can easily recreate but I'm generally
interested what could be the cause of this and how to repair system in
such condition.

As I run file system check it seems to be OK:

root@blinky:~# btrfsck /dev/nvme0n1 Checking filesystem on
/dev/nvme0n1 UUID: 2a396366-e3c9-4d14-b4cc-3d8992bd1c6b checking
extents checking free space cache checking fs roots checking csums
checking root refs found 314622067165 bytes used err is 0 total csum
bytes: 302861376 total tree bytes: 4492017664 total fs tree bytes:
1496743936 total extent tree bytes: 2126643200 btree space waste
bytes: 1389440305 file data blocks allocated: 345977790464 referenced
288756027392

Let me know if you have any ideas how to troubleshoot

-- 
Peter Zaitsev, CEO, Percona
Tel: +1 888 401 3401 ext 7360   Skype:  peter_zaitsev
