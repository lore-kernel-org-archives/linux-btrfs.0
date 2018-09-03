Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33478 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbeICSMe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2018 14:12:34 -0400
Received: by mail-oi0-f51.google.com with SMTP id 8-v6so1131745oip.0
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Sep 2018 06:52:17 -0700 (PDT)
MIME-Version: 1.0
From: Etienne Champetier <champetier.etienne@gmail.com>
Date: Mon, 3 Sep 2018 09:52:02 -0400
Message-ID: <CAOdf3gor3zmZ5Wu4w6KEKYjxLU+DBr5UF95SrT1=wELeBHBAKg@mail.gmail.com>
Subject: RAID1 & BTRFS critical (device sda2): corrupt leaf, bad key order
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello linux-btfrs,

I have a computer acting as backup server with BTRFS RAID1, and I
would like to know the different options to rebuild this RAID
(I saw this thread
https://www.spinics.net/lists/linux-btrfs/msg68679.html but there was
no raid 1)

# uname -a
Linux servmaison 4.4.0-134-generic #160-Ubuntu SMP Wed Aug 15 14:58:00
UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.4

# dmesg
...
[ 1955.581972] BTRFS critical (device sda2): corrupt leaf, bad key
order: block=6020235362304,root=1, slot=63
[ 1955.582299] BTRFS critical (device sda2): corrupt leaf, bad key
order: block=6020235362304,root=1, slot=63
[ 1955.582414] ------------[ cut here ]------------
[ 1955.582452] WARNING: CPU: 0 PID: 2071 at
/build/linux-osVS4h/linux-4.4.0/fs/btrfs/extent-tree.c:2930
btrfs_run_delayed_refs+0x26b/0x2a0 [btrfs]()
[ 1955.582454] BTRFS: Transaction aborted (error -5)
[ 1955.582456] Modules linked in: eeepc_wmi asus_wmi sparse_keymap
ppdev intel_rapl x86_pkg_temp_thermal snd_hda_codec_hdmi
snd_hda_codec_realtek intel_powerclamp snd_hda_codec_generic coretemp
snd_hda_intel snd_hda_codec bridge kvm_intel crct10dif_pclmul stp
crc32_pclmul kvm snd_hda_core snd_hwdep llc ghash_clmulni_intel
irqbypass snd_pcm input_leds serio_raw snd_timer 8250_fintek snd
mei_me ie31200_edac mei lpc_ich mac_hid soundcore edac_core parport_pc
shpchp parport ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core
ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4
btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear
hid_generic usbhid pata_acpi hid i915 aesni_intel i2c_algo_bit
aes_x86_64 glue_helper
[ 1955.582509]  drm_kms_helper lrw gf128mul ablk_helper syscopyarea
cryptd sysfillrect sysimgblt fb_sys_fops ahci drm r8169 libahci mii
wmi fjes video
[ 1955.582522] CPU: 0 PID: 2071 Comm: kworker/u8:1 Not tainted
4.4.0-134-generic #160-Ubuntu
[ 1955.582524] Hardware name: System manufacturer System Product
Name/P8H77-M PRO, BIOS 1003 10/12/2012
[ 1955.582546] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[ 1955.582548]  0000000000000286 e1236dd013ef459f ffff88034938fc98
ffffffff814039f3
[ 1955.582552]  ffff88034938fce0 ffffffffc03ff478 ffff88034938fcd0
ffffffff81084982
[ 1955.582555]  ffff880405a62980 ffff8804076f7800 ffff8803e6c6d0a0
00000000000002ec
[ 1955.582558] Call Trace:
[ 1955.582566]  [<ffffffff814039f3>] dump_stack+0x63/0x90
[ 1955.582571]  [<ffffffff81084982>] warn_slowpath_common+0x82/0xc0
[ 1955.582574]  [<ffffffff81084a1c>] warn_slowpath_fmt+0x5c/0x80
[ 1955.582592]  [<ffffffffc0363777>] ?
__btrfs_run_delayed_refs+0xce7/0x1220 [btrfs]
[ 1955.582608]  [<ffffffffc0366d4b>] btrfs_run_delayed_refs+0x26b/0x2a0 [btrfs]
[ 1955.582624]  [<ffffffffc0366db7>] delayed_ref_async_start+0x37/0x90 [btrfs]
[ 1955.582643]  [<ffffffffc03ae2ef>] btrfs_scrubparity_helper+0xcf/0x320 [btrfs]
[ 1955.582661]  [<ffffffffc03ae57e>] btrfs_extent_refs_helper+0xe/0x10 [btrfs]
[ 1955.582666]  [<ffffffff8109e68b>] process_one_work+0x16b/0x490
[ 1955.582670]  [<ffffffff8109e9fb>] worker_thread+0x4b/0x4d0
[ 1955.582674]  [<ffffffff8109e9b0>] ? process_one_work+0x490/0x490
[ 1955.582677]  [<ffffffff810a4dc7>] kthread+0xe7/0x100
[ 1955.582680]  [<ffffffff810a4ce0>] ? kthread_create_on_node+0x1e0/0x1e0
[ 1955.582685]  [<ffffffff81855735>] ret_from_fork+0x55/0x80
[ 1955.582689]  [<ffffffff810a4ce0>] ? kthread_create_on_node+0x1e0/0x1e0
[ 1955.582691] ---[ end trace cc65b5ec2d2430fc ]---
[ 1955.582694] BTRFS: error (device sda2) in
btrfs_run_delayed_refs:2930: errno=-5 IO failure
[ 1955.582743] BTRFS info (device sda2): forced readonly
[ 1955.595017] BTRFS critical (device sda2): corrupt leaf, bad key
order: block=6020235362304,root=1, slot=63
[ 1955.595106] BTRFS: error (device sda2) in
btrfs_run_delayed_refs:2930: errno=-5 IO failure
[ 1955.604374] BTRFS critical (device sda2): corrupt leaf, bad key
order: block=6020235362304,root=1, slot=63
[ 1955.604444] BTRFS: error (device sda2) in
btrfs_run_delayed_refs:2930: errno=-5 IO failure
[ 1955.605331] BTRFS warning (device sda2): failed setting block group
ro, ret=-30
[ 1955.605334] BTRFS warning (device sda2): failed setting block group
ro, ret=-30

# btrfs fi show /
Label: none  uuid: 4917db5e-fc20-4369-9556-83082a32d4cd
    Total devices 2 FS bytes used 2.25TiB
    devid    1 size 3.64TiB used 2.34TiB path /dev/sda2
    devid    2 size 3.64TiB used 2.34TiB path /dev/sdb2

# btrfs device stats /
[/dev/sda2].write_io_errs   0
[/dev/sda2].read_io_errs    0
[/dev/sda2].flush_io_errs   0
[/dev/sda2].corruption_errs 0
[/dev/sda2].generation_errs 0
[/dev/sdb2].write_io_errs   0
[/dev/sdb2].read_io_errs    0
[/dev/sdb2].flush_io_errs   0
[/dev/sdb2].corruption_errs 0
[/dev/sdb2].generation_errs 0

device stats report no errors :(

# btrfs fi df /
Data, RAID1: total=2.32TiB, used=2.23TiB
System, RAID1: total=96.00MiB, used=368.00KiB
Metadata, RAID1: total=22.00GiB, used=19.12GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

# btrfs scrub status /
scrub status for 4917db5e-fc20-4369-9556-83082a32d4cd
    scrub started at Mon Sep  3 05:32:52 2018, interrupted after
00:27:35, not running
    total bytes scrubbed: 514.05GiB with 0 errors

I've already tried 2 times to run btrfs scrub (after reboot), but it
stops before the end, with the previous dmesg error

My question is what is the safest way to rebuild this BTRFS RAID1?
I haven't tried "btrfs check --repair" yet
(I can boot on a more up to date Linux live if it helps)

Thanks
Etienne
