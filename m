Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34815 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbcG2NhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 09:37:09 -0400
Received: by mail-lf0-f67.google.com with SMTP id l69so5310423lfg.1
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jul 2016 06:37:08 -0700 (PDT)
MIME-Version: 1.0
From: Mordechay Kaganer <mkaganer@gmail.com>
Date: Fri, 29 Jul 2016 16:37:05 +0300
Message-ID: <CA+xOVSOx56oc5kF+oj18B3m23wcpy2OqbKbH9j13se+s98YvdQ@mail.gmail.com>
Subject: BTRFS: Transaction aborted (error -28)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

Hello!

While saving a backup (using rsync) the FS went read only and i've got
BTRFS: Transaction aborted (error -28) error. While writing a new
backup i was also doing btrfs send of another subvolume on the same FS
from this server out to another server.

After reboot, the device mounts OK. Does it mean something went wrong
with the FS? Need to run a full balance?

The device actually has more than 3TB free space:

# btrfs fi usage .
Overall:
    Device size:                  43.66TiB
    Device allocated:             40.43TiB
    Device unallocated:            3.23TiB
    Device missing:                  0.00B
    Used:                         40.42TiB
    Free (estimated):              3.24TiB      (min: 1.62TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 48.00KiB)

Data,single: Size:39.92TiB, Used:39.92TiB
   /dev/md1       10.19TiB
   /dev/md2       10.21TiB
   /dev/md3       10.41TiB
   /dev/md4        9.11TiB

Metadata,RAID1: Size:261.00GiB, Used:259.69GiB
   /dev/md1      196.00GiB
   /dev/md2      178.00GiB
   /dev/md3       65.00GiB
   /dev/md4       83.00GiB

System,RAID1: Size:8.00MiB, Used:4.47MiB
   /dev/md1        8.00MiB
   /dev/md2        8.00MiB

Unallocated:
   /dev/md1      545.79GiB
   /dev/md2      544.80GiB
   /dev/md3      457.81GiB
   /dev/md4        1.72TiB

btrfs-tools version: btrfs-progs v4.3.1

The kernel is based on Ubuntu mainline PPA 4.3.3
(http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.3.3-wily/) with a
patch to fix RAID10 issue.

The kernel log:
[5099580.930974] ------------[ cut here ]------------
[5099580.930989] WARNING: CPU: 1 PID: 6643 at
/home/yemot/build/ubuntu-mainline/fs/btrfs/extent-tree.c:6362
__btrfs_free_extent.isra.66+0x132/0xcb0 [btrfs]()
[5099580.930990] BTRFS: Transaction aborted (error -28)
[5099580.930991] Modules linked in: ipmi_ssif x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper ast
snd_hda_codec_realtek cryptd snd_hda_codec_generic ttm sb_edac
serio_raw drm_kms_helper edac_core joydev input_leds drm snd_hda_intel
snd_hda_codec fb_sys_fops syscopyarea lpc_ich snd_hda_core sysfillrect
sysimgblt snd_hwdep snd_pcm snd_timer mei_me snd soundcore mei ipmi_si
8250_fintek ipmi_msghandler wmi nfsd shpchp auth_rpcgss lp mac_hid
nfs_acl parport nfs lockd grace sunrpc fscache btrfs ses enclosure
raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
async_tx xor raid6_pq raid1 igb i2c_algo_bit hid_generic isci dca
firewire_ohci usbhid raid0 libsas ptp firewire_core ahci psmouse hid
multipath pps_core libahci scsi_transport_sas crc_itu_t aacraid fjes
linear
[5099580.931025] CPU: 1 PID: 6643 Comm: kworker/u16:19 Not tainted
4.3.3-040303.20160107-raid10-patch-generic #patch
[5099580.931026] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./EPC602D8A, BIOS P1.20 04/16/2014
[5099580.931036] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[5099580.931037]  ffffffffc02aa7b0 ffff88000bfd3ab0 ffffffff813a4524
ffff88000bfd3af8
[5099580.931039]  ffff88000bfd3ae8 ffffffff81079226 00000000ffffffe4
00000deed72a4000
[5099580.931040]  ffff8805fca9a1b0 ffff880857982000 0000000000000000
ffff88000bfd3b48
[5099580.931041] Call Trace:
[5099580.931045]  [<ffffffff813a4524>] dump_stack+0x44/0x60
[5099580.931047]  [<ffffffff81079226>] warn_slowpath_common+0x86/0xc0
[5099580.931049]  [<ffffffff810792ac>] warn_slowpath_fmt+0x4c/0x50
[5099580.931054]  [<ffffffffc020fe32>]
__btrfs_free_extent.isra.66+0x132/0xcb0 [btrfs]
[5099580.931059]  [<ffffffffc0213e2c>]
__btrfs_run_delayed_refs+0x71c/0x10e0 [btrfs]
[5099580.931065]  [<ffffffffc021751d>] btrfs_run_delayed_refs+0x7d/0x2b0 [btrfs]
[5099580.931070]  [<ffffffffc0217787>] delayed_ref_async_start+0x37/0x90 [btrfs]
[5099580.931078]  [<ffffffffc025c100>] normal_work_helper+0xc0/0x270 [btrfs]
[5099580.931080]  [<ffffffff8108ee9d>] ? pwq_activate_delayed_work+0x3d/0x80
[5099580.931087]  [<ffffffffc025c4e2>]
btrfs_extent_refs_helper+0x12/0x20 [btrfs]
[5099580.931088]  [<ffffffff81091057>] process_one_work+0x157/0x3e0
[5099580.931090]  [<ffffffff81091a3e>] worker_thread+0x4e/0x470
[5099580.931091]  [<ffffffff810919f0>] ? rescuer_thread+0x300/0x300
[5099580.931093]  [<ffffffff81096d09>] kthread+0xc9/0xe0
[5099580.931095]  [<ffffffff81096c40>] ? kthread_park+0x60/0x60
[5099580.931098]  [<ffffffff817b4acf>] ret_from_fork+0x3f/0x70
[5099580.931100]  [<ffffffff81096c40>] ? kthread_park+0x60/0x60
[5099580.931101] ---[ end trace 771ebb14ef31d548 ]---
[5099580.931102] BTRFS: error (device md1) in
__btrfs_free_extent:6362: errno=-28 No space left
[5099580.931126] BTRFS info (device md1): forced readonly
[5099580.931127] BTRFS: error (device md1) in
btrfs_run_delayed_refs:2858: errno=-28 No space left
[5099580.935938] BTRFS: error (device md1) in
__btrfs_free_extent:6362: errno=-28 No space left
[5099580.935939] BTRFS: error (device md1) in
__btrfs_free_extent:6362: errno=-28 No space left
[5099580.935941] BTRFS: error (device md1) in
btrfs_run_delayed_refs:2858: errno=-28 No space left
[5099580.936037] BTRFS: error (device md1) in
btrfs_run_delayed_refs:2858: errno=-28 No space left
[5099581.122804] BTRFS: error (device md1) in
__btrfs_free_extent:6362: errno=-28 No space left
[5099581.122830] BTRFS: error (device md1) in
btrfs_run_delayed_refs:2858: errno=-28 No space left

Thanks!


-- 
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
