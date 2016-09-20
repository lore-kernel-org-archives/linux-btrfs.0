Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35979 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753632AbcITXQz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 19:16:55 -0400
Received: by mail-oi0-f44.google.com with SMTP id t83so40671925oie.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 16:16:55 -0700 (PDT)
MIME-Version: 1.0
From: Mirak M <mirak63@gmail.com>
Date: Wed, 21 Sep 2016 01:16:54 +0200
Message-ID: <CAB1rxdbJX7rgv-NrHyGD7wMMcFf1EDR_aJ8yaTs7r=O-iXTo7w@mail.gmail.com>
Subject: Can't mount btrfs raid1
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a failure when mounting btrfs.

> mount -oro,recovery /dev/sda2 sda2_btrfs
> mount: /dev/sda2: can't read superblock

The kernel log is here http://pastebin.com/tHihHT92 and at the bottom
of the email

I must admit I did the error of running btrfs check --repair at some
point, not knowing this was not a good idea.

I run ubuntu 16.04 with kernel 4.4.0-36-generic .

Regards,
Mirak


[ 1685.255619] BTRFS info (device sda2): enabling auto recovery
[ 1685.255626] BTRFS info (device sda2): disk space caching is enabled
[ 1685.255628] BTRFS: has skinny extents
[ 1692.712574] BTRFS critical (device sda2): corrupt leaf, bad key
order: block=1957998690304,root=1, slot=29
[ 1692.712819] BTRFS critical (device sda2): corrupt leaf, bad key
order: block=1957998690304,root=1, slot=29
[ 1692.712827] ------------[ cut here ]------------
[ 1692.712865] WARNING: CPU: 3 PID: 6305 at
/build/linux-a2WvEb/linux-4.4.0/fs/btrfs/extent-tree.c:6552
__btrfs_free_extent.isra.70+0x2e6/0xd30 [btrfs]()
[ 1692.712867] BTRFS: Transaction aborted (error -5)
[ 1692.712868] Modules linked in: nvram msr joydev input_leds
ir_xmp_decoder ir_lirc_codec ir_mce_kbd_decoder ir_sharp_decoder
ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder
ir_nec_decoder ir_rc5_decoder rc_rc6_mce mceusb lirc_dev rc_core
snd_hda_codec_realtek snd_hda_codec_generic binfmt_misc coretemp
kvm_intel kvm irqbypass snd_hda_codec_hdmi snd_hda_intel serio_raw
snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_seq_midi
snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd
shpchp soundcore 8250_fintek i2c_nforce2 mac_hid parport_pc ppdev lp
parport autofs4 btrfs raid10 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0
multipath linear dm_mirror dm_region_hash dm_log hid_logitech
ff_memless pata_acpi hid_logitech_hidpp
[ 1692.712936]  hid_logitech_dj usbhid hid uas usb_storage amdkfd
amd_iommu_v2 radeon i2c_algo_bit ttm drm_kms_helper syscopyarea
sysfillrect sysimgblt firewire_ohci pata_jmicron fb_sys_fops psmouse
firewire_core drm forcedeth crc_itu_t ahci libahci video wmi fjes
[ 1692.712960] CPU: 3 PID: 6305 Comm: mount Tainted: P           OE
4.4.0-36-generic #55-Ubuntu
[ 1692.712963] Hardware name: Gigabyte Technology Co., Ltd.
GA-E7AUM-DS2H/GA-E7AUM-DS2H, BIOS F2 12/17/2008
[ 1692.712965]  0000000000000286 00000000b16cde4b ffff880098c3f688
ffffffff813f13b3
[ 1692.712968]  ffff880098c3f6d0 ffffffffc04b5468 ffff880098c3f6c0
ffffffff810810f2
[ 1692.712972]  000001c81f860000 00000000fffffffb 0000000000000000
ffff8801756c2000
[ 1692.712975] Call Trace:
[ 1692.712983]  [<ffffffff813f13b3>] dump_stack+0x63/0x90
[ 1692.712988]  [<ffffffff810810f2>] warn_slowpath_common+0x82/0xc0
[ 1692.712991]  [<ffffffff8108118c>] warn_slowpath_fmt+0x5c/0x80
[ 1692.713009]  [<ffffffffc0414ec6>]
__btrfs_free_extent.isra.70+0x2e6/0xd30 [btrfs]
[ 1692.713031]  [<ffffffffc047dbe6>] ?
btrfs_merge_delayed_refs+0x66/0x650 [btrfs]
[ 1692.713050]  [<ffffffffc041948b>]
__btrfs_run_delayed_refs+0xaab/0x11f0 [btrfs]
[ 1692.713068]  [<ffffffffc041ca1d>] btrfs_run_delayed_refs+0x7d/0x2a0 [btrfs]
[ 1692.713085]  [<ffffffffc040694f>] ? btrfs_set_path_blocking+0x3f/0x70 [btrfs]
[ 1692.713105]  [<ffffffffc0431bf6>] btrfs_commit_transaction+0x56/0xa90 [btrfs]
[ 1692.713110]  [<ffffffff811ec9d4>] ? kmem_cache_free+0x1d4/0x1e0
[ 1692.713132]  [<ffffffffc0474d67>] btrfs_recover_log_trees+0x3e7/0x480 [btrfs]
[ 1692.713155]  [<ffffffffc0472690>] ? replay_one_extent+0x6c0/0x6c0 [btrfs]
[ 1692.713175]  [<ffffffffc042f01c>] open_ctree+0x1a5c/0x2460 [btrfs]
[ 1692.713192]  [<ffffffffc0403a94>] btrfs_mount+0x944/0xa60 [btrfs]
[ 1692.713196]  [<ffffffff81405fd5>] ? find_next_bit+0x15/0x20
[ 1692.713200]  [<ffffffff811b1aff>] ? pcpu_alloc+0x37f/0x640
[ 1692.713203]  [<ffffffff812111d8>] mount_fs+0x38/0x160
[ 1692.713206]  [<ffffffff811b1df5>] ? __alloc_percpu+0x15/0x20
[ 1692.713209]  [<ffffffff8122d1d7>] vfs_kern_mount+0x67/0x110
[ 1692.713226]  [<ffffffffc040332f>] btrfs_mount+0x1df/0xa60 [btrfs]
[ 1692.713228]  [<ffffffff811b1aff>] ? pcpu_alloc+0x37f/0x640
[ 1692.713231]  [<ffffffff812111d8>] mount_fs+0x38/0x160
[ 1692.713233]  [<ffffffff811b1df5>] ? __alloc_percpu+0x15/0x20
[ 1692.713236]  [<ffffffff8122d1d7>] vfs_kern_mount+0x67/0x110
[ 1692.713239]  [<ffffffff8122f9a9>] do_mount+0x269/0xde0
[ 1692.713242]  [<ffffffff8123084f>] SyS_mount+0x9f/0x100
[ 1692.713246]  [<ffffffff8182dfb2>] entry_SYSCALL_64_fastpath+0x16/0x71
[ 1692.713249] ---[ end trace e6d60ad04bc3178e ]---
[ 1692.713252] BTRFS: error (device sda2) in __btrfs_free_extent:6552:
errno=-5 IO failure
[ 1692.713257] BTRFS: error (device sda2) in
btrfs_run_delayed_refs:2927: errno=-5 IO failure
[ 1692.713950] pending csums is 4096
[ 1692.713963] BTRFS: error (device sda2) in btrfs_replay_log:2401:
errno=-5 IO failure (Failed to recover log tree)
[ 1692.713994] BTRFS error (device sda2): cleaner transaction attach
returned -30
[ 1692.760459] BTRFS: open_ctree failed
