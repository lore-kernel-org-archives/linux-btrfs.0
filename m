Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36282 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbcJHVzt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Oct 2016 17:55:49 -0400
Received: by mail-qk0-f182.google.com with SMTP id o68so70534364qkf.3
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Oct 2016 14:55:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_nKwJB+v+5+TB1GU+ywxYh9dBD6vCUXbMnAyU4JwvdiRg@mail.gmail.com>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com> <CAGfcS_mLABcdd_3n=0cV8nx1DXoLBDFC6SbmMou_ZXWjw0BqRA@mail.gmail.com>
 <a8dac132-78b3-4276-2ed3-d30a74b0d31b@suse.com> <CAGfcS_=2x-CqGwXXeWejiUoDTgy9HxAtPdy2Nur2CAMYT3d26A@mail.gmail.com>
 <6bf85d64-2792-85db-0169-c6288e95a775@suse.com> <CAGfcS_nKwJB+v+5+TB1GU+ywxYh9dBD6vCUXbMnAyU4JwvdiRg@mail.gmail.com>
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Date: Sat, 8 Oct 2016 17:55:47 -0400
Message-ID: <CAGfcS_kfgbvJG=k3+S4BQ8jOXY+gFZ7oxiAp0OxbRM+qzGquRA@mail.gmail.com>
Subject: Re: unable to handle kernel paging request - btrfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not sure if this is related to the same issue or not, but I just
started getting a new BUG, followed by a panic.  (I'm also enabled
network console capture so that you won't have to squint at photos.)

Original BUG is:


[14740.444257] ------------[ cut here ]------------
[14740.444293] kernel BUG at /usr/src/linux-stable/fs/btrfs/volumes.c:5509!
[14740.444323] invalid opcode: 0000 [#1] SMP
[14740.444348] Modules linked in: nfsd auth_rpcgss oid_registry lockd
grace sunrpc it87 hwmon_vid netconsole configfs tun ipt_MASQUERADE
nf_nat_masquerade_ipv4 xt_conntrack veth iptable_mangle iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_n
         at nf_conntrack iptable_filter ip_tables ext4 crc16 mbcache
jbd2 radeon nxt200x cx88_dvb cx88_vp3054_i2c videobuf2_dvb
dvb_coretuner_simple tuner_types tuner fbcon bitblit softcursor font
tileblit drm_kms_helper kvm_amd kvm cfbfillrect syscopyarea cfbimgblt
sysfillrect sysimgblt mousedev fb_sys_fops cfbcopyarea cx88_alsa ttm
cx8802 drm cx8800 videobuf2_dma_sg videobuf2_memops videobuf2_v4l2
cx88xx snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel
videobuf2_core snd_hda_codec tveeprom rc_core irqbypass v4l2_common
videodev k10temp i2c_algo_bit
[14740.444799]  snd_hwdep i2c_piix4 snd_hda_core hid_logitech_hidpp
snd_pcm r8169 8250 snd_timer snd mii 8250_base backlight serial_core
soundcore evdev sch_fq_codel hid_logitech_dj hid_generic usbhid btrfs
firewire_ohci atkbd ata_generic pata_acpi firew
       ire_core crc_itu_t xor zlib_deflate ohci_pci pata_atiixp
raid6_pq ehci_pci ohci_hcd ehci_hcd usbcore usb_common dm_mirror
dm_region_hash dm_log dm_mod
[14740.445028] CPU: 1 PID: 3213 Comm: kworker/u16:2 Not tainted 4.4.24 #1
[14740.445056] Hardware name: Gigabyte Technology Co., Ltd.
GA-880GM-UD2H/GA-880GM-UD2H, BIOS F8 10/11/2010
[14740.445116] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
[14740.445143] task: ffff8803ff527300 ti: ffff8803e3c8c000 task.ti:
ffff8803e3c8c000
[14740.445173] RIP: 0010:[<ffffffffa02c3ffd>]  [<ffffffffa02c3ffd>]
__btrfs_map_block+0xdfd/0x1140 [btrfs]
[14740.445226] RSP: 0018:ffff8803e3c8faa0  EFLAGS: 00010282
[14740.445248] RAX: 00000000cdf2f040 RBX: 0000000000000002 RCX: 0000000000000002
[14740.445277] RDX: 0000000000000000 RSI: 0000000021b27000 RDI: ffff8800cab4fb40
[14740.445306] RBP: ffff8803e3c8fb88 R08: 0000050743c00000 R09: 00000000cdf2f040
[14740.445334] R10: 0000000000010000 R11: 0000000000001e4d R12: 00000000cdf2f03f
[14740.445363] R13: 0000000000009000 R14: ffff8803e3c8fbd0 R15: 0000000000010000
[14740.445391] FS:  00007f9e2befc7c0(0000) GS:ffff880427c40000(0000)
knlGS:0000000000000000
[14740.445423] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[14740.445446] CR2: 00007fc533bf7000 CR3: 00000003e29e4000 CR4: 00000000000006e0
[14740.445474] Stack:
[14740.445484]  ffff8803e3c8fab0 ffffffff81084577 ffffffff8112acf0
0000000002011200
[14740.445526]  ffff880410cacc60 ffff880410cacc90 000000001e4e0000
ffff8803ff527300
[14740.445565]  0000000000000000 0000000000001e4e ffff880414e68ee8
ffffffff00000000
[14740.445603] Call Trace:
[14740.445618]  [<ffffffff81084577>] ? __enqueue_entity+0x67/0x70
[14740.445644]  [<ffffffff8112acf0>] ? mempool_alloc_slab+0x10/0x20
[14740.445680]  [<ffffffffa02c48e1>] btrfs_map_bio+0x71/0x320 [btrfs]
[14740.445707]  [<ffffffff8117e630>] ? kmem_cache_alloc+0x190/0x1f0
[14740.445742]  [<ffffffffa0290d4e>] ? btrfs_bio_wq_end_io+0x2e/0x80 [btrfs]
[14740.445780]  [<ffffffffa02e0f91>]
btrfs_submit_compressed_read+0x451/0x4a0 [btrfs]
[14740.445821]  [<ffffffffa029bae0>] btrfs_submit_bio_hook+0x1a0/0x1b0 [btrfs]
[14740.445860]  [<ffffffffa02b9870>] ? btrfs_io_bio_alloc+0x10/0x30 [btrfs]
[14740.445900]  [<ffffffffa02b9d93>] ? btrfs_create_repair_bio+0xc3/0xe0 [btrfs]
[14740.445940]  [<ffffffffa02ba1ff>] end_bio_extent_readpage+0x44f/0x510 [btrfs]
[14740.445981]  [<ffffffffa02b9db0>] ? btrfs_create_repair_bio+0xe0/0xe0 [btrfs]
[14740.446011]  [<ffffffff8125e3ca>] bio_endio+0x3a/0x70
[14740.446042]  [<ffffffffa028f1e7>] end_workqueue_fn+0x37/0x40 [btrfs]
[14740.446080]  [<ffffffffa02c908e>] normal_work_helper+0xae/0x2d0 [btrfs]
[14740.446118]  [<ffffffffa02c931d>] btrfs_endio_helper+0xd/0x10 [btrfs]
[14740.446145]  [<ffffffff8106eb58>] process_one_work+0x148/0x400
[14740.446170]  [<ffffffff8106f126>] worker_thread+0x46/0x430
[14740.446193]  [<ffffffff8106f0e0>] ? rescuer_thread+0x2d0/0x2d0
[14740.446217]  [<ffffffff8106f0e0>] ? rescuer_thread+0x2d0/0x2d0
[14740.446241]  [<ffffffff81073f54>] kthread+0xc4/0xe0
[14740.446262]  [<ffffffff81073e90>] ? kthread_park+0x50/0x50
[14740.446286]  [<ffffffff8155169f>] ret_from_fork+0x3f/0x70
[14740.446309]  [<ffffffff81073e90>] ? kthread_park+0x50/0x50
[14740.446332] Code: 60 ff ff ff 48 63 d3 48 2b 4d c0 48 0f af c1 48
39 c2 48 0f 46 c2 48 89 45 90 89 d9 c7 85 70 ff ff ff 00 0
                  0 00 00 e9 f9 f3 ff ff <0f> 0b bb f4 ff ff ff e9 c7
fa ff ff be 6a 16 00 00 48 c7 c7 18
[14740.446672] RIP  [<ffffffffa02c3ffd>] __btrfs_map_block+0xdfd/0x1140 [btrfs]
[14740.446714]  RSP <ffff8803e3c8faa0>
[14740.456756] ---[ end trace e349a675c6512569 ]---
[14740.456832] BUG: unable to handle kernel paging request at ffffffffffffffd8
[14740.456869] IP: [<ffffffff810746bb>] kthread_data+0xb/0x20
[14740.456896] PGD 1a0a067 PUD 1a0c067 PMD 0
