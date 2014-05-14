Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:65135 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaENMLa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 08:11:30 -0400
Received: by mail-oa0-f44.google.com with SMTP id o6so2024698oag.17
        for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 05:11:30 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 14 May 2014 17:41:29 +0530
Message-ID: <CAJqT0iz2ZM7mygQQg6sE9-rg=wMNboOi-PgFZ=Cyw-FVhhoVtw@mail.gmail.com>
Subject: "No space left on device" though btrfs df shows lots of space left
From: sampath rapaka <sampath.rapaka@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I have started using Btrfs for the first time today. I have created a
RAID 5 Array. Did a mount and created Btrfs on top of it.

I was doing some IO using FIO tool. After 2 tests one of the tests
have got below error.

Console log:
============
stress: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
fio-2.1.7
Starting 1 process
fio: io_u error on file /mnt/btrfs_raid5/stress.0.0: No space left on device
     write offset=5415628800, buflen=4096
fio: io_u error on file /mnt/btrfs_raid5/stress.0.0: Read-only file system
     write offset=457945088, buflen=4096
fio: pid=16013, err=28/file:io_u.c:1550, func=io_u error, error=No
space left on device

stress: (groupid=0, jobs=1): err=28 (file:io_u.c:1550, func=io_u
error, error=No space left on device): pid=16013: Thu May 15 00:21:02
2014

Uname Output:
============

Linux  3.12.15-1.1+ #2 SMP  x86_64 x86_64 x86_64 GNU/Linux

Btrfs Show output;
=================
:~$ btrfs fi df /mnt/btrfs_raid5/
Data, single: total=12.01GiB, used=10.69GiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=1.00GiB, used=266.41MiB
Metadata, single: total=8.00MiB, used=0.00

~$ sudo btrfs fi show
[sudo] password for rapaka:
Label: 'btrfs_md5'  uuid: 9645bc32-579b-429d-99c2-7e2fd519de6f
        Total devices 1 FS bytes used 10.95GiB
        devid    1 size 1.31TiB used 14.04GiB path /dev/md5

Btrfs v3.14.1


Dmesg log:
=========

[81028.942683] btrfs: device label btrfs_md5 devid 1 transid 4 /dev/md5
[81028.943120] btrfs: disk space caching is enabled
[81028.943122] btrfs flagging fs with big metadata feature
[81028.944880] btrfs: creating UUID tree
[81144.555977] md: md5: recovery done.
[81144.557917] RAID conf printout:
[81144.557920]  --- level:5 rd:4 wd:4
[81144.557923]  disk 0, o:1, dev:sda
[81144.557924]  disk 1, o:1, dev:sdc
[81144.557926]  disk 2, o:1, dev:sdd
[81144.557927]  disk 3, o:1, dev:sde
[93241.295892] ------------[ cut here ]------------
[93241.295908] WARNING: CPU: 0 PID: 13706 at fs/btrfs/super.c:255
__btrfs_abort_transaction+0x12d/0x140 [btrfs]()
[93241.295909] btrfs: Transaction aborted (error -28)
[93241.295910] Modules linked in: nouveau snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec mxm_wmi wmi ttm
snd_hwdep snd_pcm drm_kms_helper raid456 drm snd_page_alloc snd_timer
async_memcpy async_raid6_recov snd async_pq async_xor psmouse async_tx
soundcore serio_raw md_mod i2c_algo_bit lp video lpc_ich parport
mac_hid btrfs xor raid6_pq libcrc32c hid_generic usbhid hid e1000e
ahci libahci ptp pps_core
[93241.295923] CPU: 0 PID: 13706 Comm: btrfs-transacti Tainted: G
    I  3.12.15-1.1+ #2
[93241.295924] Hardware name:                  /DH87RL, BIOS
RLH8710H.86A.0320.2013.0606.1802 06/06/2013
[93241.295925]  0000000000000009 ffff8800cd99dac0 ffffffff816a3e43
ffff8800cd99db08
[93241.295927]  ffff8800cd99daf8 ffffffff8104e46c 00000000ffffffe4
ffff8800cc622800
[93241.295929]  ffff8800cdfd5b40 ffffffffa0151ba0 0000000000001661
ffff8800cd99db58
[93241.295931] Call Trace:
[93241.295935]  [<ffffffff816a3e43>] dump_stack+0x45/0x56
[93241.295938]  [<ffffffff8104e46c>] warn_slowpath_common+0x8c/0xc0
[93241.295940]  [<ffffffff8104e55c>] warn_slowpath_fmt+0x4c/0x50
[93241.295945]  [<ffffffffa00b5ced>]
__btrfs_abort_transaction+0x12d/0x140 [btrfs]
[93241.295950]  [<ffffffffa00c76f3>] __btrfs_free_extent+0x553/0xa50 [btrfs]
[93241.295959]  [<ffffffffa0123bac>] ?
btrfs_merge_delayed_refs+0x1fc/0x3c0 [btrfs]
[93241.295965]  [<ffffffffa00cb86f>] run_clustered_refs+0x40f/0xe80 [btrfs]
[93241.295970]  [<ffffffffa00cbb1f>] ? run_clustered_refs+0x6bf/0xe80 [btrfs]
[93241.295975]  [<ffffffffa00cbb1f>] ? run_clustered_refs+0x6bf/0xe80 [btrfs]
[93241.295981]  [<ffffffffa00cff70>] btrfs_run_delayed_refs+0xe0/0x5a0 [btrfs]
[93241.295983]  [<ffffffff8105afd8>] ? lock_timer_base.isra.34+0x38/0x70
[93241.295990]  [<ffffffffa00e0489>] btrfs_commit_transaction+0x59/0x920 [btrfs]
[93241.295996]  [<ffffffffa00d8ccd>] transaction_kthread+0x1bd/0x230 [btrfs]
[93241.296002]  [<ffffffffa00d8b10>] ? cleaner_kthread+0x190/0x190 [btrfs]
[93241.296004]  [<ffffffff81070e80>] kthread+0xc0/0xd0
[93241.296006]  [<ffffffff81070dc0>] ? kthread_create_on_node+0x120/0x120
[93241.296009]  [<ffffffff816b2b2c>] ret_from_fork+0x7c/0xb0
[93241.296010]  [<ffffffff81070dc0>] ? kthread_create_on_node+0x120/0x120
[93241.296011] ---[ end trace 2f0caa7baa4183d8 ]---
[93241.296013] BTRFS error (device md5) in __btrfs_free_extent:5729:
errno=-28 No space left
[93241.296181] BTRFS info (device md5): forced readonly
[93241.296182] BTRFS debug (device md5): run_one_delayed_ref returned -28
[93241.296184] BTRFS error (device md5) in
btrfs_run_delayed_refs:2715: errno=-28 No space left


Though the used space is only 14.04 G I was facing ENOSPC.

When See through the FAQ for the same problem it advices to run
balance. But in that case all the space it utilized .  which is not
the case here.

Could some help me whether I am using unstable version or If this is a
known issue
please help me with patch if available.

As I Plan to run multiple test could some one help me with more stable
version of Btrfs.

Regards
Sampath
