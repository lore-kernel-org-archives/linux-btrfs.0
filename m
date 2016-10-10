Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35923 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752426AbcJJMyf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 08:54:35 -0400
Received: by mail-qk0-f176.google.com with SMTP id o68so108849349qkf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2016 05:54:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_kfgbvJG=k3+S4BQ8jOXY+gFZ7oxiAp0OxbRM+qzGquRA@mail.gmail.com>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com> <CAGfcS_mLABcdd_3n=0cV8nx1DXoLBDFC6SbmMou_ZXWjw0BqRA@mail.gmail.com>
 <a8dac132-78b3-4276-2ed3-d30a74b0d31b@suse.com> <CAGfcS_=2x-CqGwXXeWejiUoDTgy9HxAtPdy2Nur2CAMYT3d26A@mail.gmail.com>
 <6bf85d64-2792-85db-0169-c6288e95a775@suse.com> <CAGfcS_nKwJB+v+5+TB1GU+ywxYh9dBD6vCUXbMnAyU4JwvdiRg@mail.gmail.com>
 <CAGfcS_kfgbvJG=k3+S4BQ8jOXY+gFZ7oxiAp0OxbRM+qzGquRA@mail.gmail.com>
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Date: Mon, 10 Oct 2016 08:54:33 -0400
Message-ID: <CAGfcS_=YepPWfpr6Oz4XZoBo3CmmMkk1MiYSwxRGNVOmtE1i6w@mail.gmail.com>
Subject: Re: unable to handle kernel paging request - btrfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is another trace, similar to the original issue, but I have a bit
more detail on this one and it is available as text which if nothing
else is more convenient so I'll go ahead and paste this.  I don't
intend to keep pasting these unless I get something that looks
different.

I only posted the initial BUG.

Oct 10 05:11:15 hab nc[1250]: ip_tables ext4 crc16 mbcache jbd2 radeon
nxt200x cx88_dvb cx88_vp3054_i2c videobuf2_dvb dvb_core tuner_simple
tuner_types tuner cx8800 cx8802 videobuf2_dma_sg videobuf2_memops
videobuf2_v4l2 cx88_alsa cx88xx mousedev fbcon videobuf2_core bitblit
dm_region_hash dm_log dm_mod
Oct 10 05:11:15 hab nc[1250]: [81346.935203] CPU: 3 PID: 29648 Comm:
kworker/u16:3 Not tainted 4.4.24 #1
Oct 10 05:11:15 hab nc[1250]: [81346.935317] Hardware name: Gigabyte
Technology Co., Ltd. GA-880GM-UD2H/GA-880GM-UD2H, BIOS F8 10/11/2010
Oct 10 05:11:15 hab nc[1250]: [81346.935544] Workqueue: btrfs-endio
btrfs_endio_helper [btrfs]
Oct 10 05:11:15 hab nc[1250]: [81346.935657] task: ffff880415acae00
ti: ffff88019a584000 task.ti: ffff88019a584000
Oct 10 05:11:15 hab nc[1250]: [81346.935783] RIP:
0010:[<ffffffff81296e72>]  [<ffffffff81296e72>] __memcpy+0x12/0x20
Oct 10 05:11:15 hab nc[1250]: [81346.935930] RSP:
0018:ffff88019a587c68  EFLAGS: 00010246
Oct 10 05:11:15 hab nc[1250]: [81346.936023] RAX: ffffc90002ecfff8
RBX: 0000000000001000 RCX: 00000000000001ff
Oct 10 05:11:15 hab nc[1250]: [81346.936142] RDX: 0000000000000000
RSI: ffff88008c950008 RDI: ffffc90002ed0000
Oct 10 05:11:15 hab nc[1250]: [81346.936262] RBP: ffff88019a587d30
R08: 0000000041545345 R09: ffffc90002ece000
Oct 10 05:11:15 hab nc[1250]: [81346.936382] R10: ffffe8ffffcc09e0
R11: 0000000000001000 R12: ffff88008c950000
Oct 10 05:11:15 hab nc[1250]: [81346.936502] R13: 000000004154534d
R14: 0000000000000000 R15: ffff8802b25b2798
Oct 10 05:11:15 hab nc[1250]: [81346.936623] FS:
00007fe90a15d780(0000) GS:ffff880427cc0000(0000)
knlGS:0000000000000000
Oct 10 05:11:15 hab nc[1250]: [81346.936756] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Oct 10 05:11:16 hab nc[1250]: [81346.937182]  ffff8800102c5720
0000000000000004 0000000041545345 000000004154334d
Oct 10 05:11:16 hab nc[1250]: [81346.937347]  ffffc90002ece000
0000000000001000 0000000000000002 00000000003a0000
Oct 10 05:11:16 hab nc[1250]: [81346.937515] Call Trace:
Oct 10 05:11:16 hab nc[1250]: [81346.937621]  [<ffffffffa02ef741>] ?
lzo_decompress_biovec+0x1d1/0x2c0 [btrfs]
Oct 10 05:11:16 hab nc[1250]: [81346.944148]  [<ffffffffa02f06fc>]
end_compressed_bio_read+0x20c/0x2c0 [btrfs]
Oct 10 05:11:16 hab nc[1250]: [81346.950610]  [<ffffffff8107cb30>] ?
resched_curr+0x60/0xc0
Oct 10 05:11:16 hab nc[1250]: [81346.957055]  [<ffffffff8125e3ca>]
bio_endio+0x3a/0x70
Oct 10 05:11:16 hab nc[1250]: [81346.963516]  [<ffffffffa029f1e7>]
end_workqueue_fn+0x37/0x40 [btrfs]
Oct 10 05:11:16 hab nc[1250]: [81346.970009]  [<ffffffffa02d908e>]
normal_work_helper+0xae/0x2d0 [btrfs]
Oct 10 05:11:16 hab nc[1250]: [81346.976532]  [<ffffffffa02d931d>]
btrfs_endio_helper+0xd/0x10 [btrfs]
Oct 10 05:11:16 hab nc[1250]: [81346.983010]  [<ffffffff8106eb58>]
process_one_work+0x148/0x400
Oct 10 05:11:16 hab nc[1250]: [81346.989509]  [<ffffffff8106f126>]
worker_thread+0x46/0x430
Oct 10 05:11:16 hab nc[1250]: [81346.996013]  [<ffffffff8106f0e0>] ?
rescuer_thread+0x2d0/0x2d0
Oct 10 05:11:16 hab nc[1250]: [81347.034423] Code: ff ff 48 8b 43 60
48 2b 43 50 88 43 4e 5b 5d f3 c3 90 90 90 90 90 90 90 90 00 48 89 f8
48 89 d1 48 c1 e9 03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00
00 48 89 f8 48 89 d1 f3
Oct 10 05:11:16 hab nc[1250]: [81347.041852] RIP  [<ffffffff81296e72>]
__memcpy+0x12/0x20
Oct 10 05:11:16 hab nc[1250]: [81347.048565]  RSP <ffff88019a587c68>
Oct 10 05:11:16 hab nc[1250]: [81347.055218] CR2: ffffc90002ed0000
Oct 10 05:11:16 hab nc[1250]: [81347.104741] ---[ end trace
9a43c0b6d874fe31 ]---
Oct 10 05:11:16 hab nc[1250]: [81347.104752] BUG: unable to handle
kernel paging request at ffffc90002c4a000
Oct 10 05:11:16 hab nc[1250]: [81347.104761] IP: [<ffffffff81296e72>]
__memcpy+0x12/0x20
Oct 10 05:11:16 hab nc[1250]: [81347.104767] PGD 417427067 PUD
417488067 PMD 410881067 PTE 0
Oct 10 05:11:16 hab nc[1250]: [81347.104771] Oops: 0002 [#2] SMP
Oct 10 05:11:16 hab nc[1250]: [81347.104825] Modules linked in:
netconsole configfs tun ipt_MASQUERADE nf_nat_masquerade_ipv4
xt_conntrack veth iptable_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter
ip_tables ext4 crc16 mbcache jbd2 radeon nxt200x cx88_dvb
cx88_vp3054_i2c videobuf2_dvb dvb_core tuner_simple tuner_types tuner
cx8800 cx8802 videobuf2_dma_sg videobuf2_memops videobuf2_v4l2
cx88_alsa cx88xx mousedev fbcon videobuf2_core bitblit softcursor
tveeprom font tileblit drm_kms_helper kvm_amd rc_core kvm v4l2_common
cfbfillrect syscopyarea videodev cfbimgblt sysfillrect
snd_hda_codec_realtek snd_hda_codec_generic irqbypass i2c_algo_bit
sysimgblt fb_sys_fops snd_hda_intel k10temp cfbcopyarea ttm
snd_hda_codec snd_hwdep i2c_piix4 snd_hda_core drm hid_logitech_hidpp
snd_pcm r8169[81347.104954] CR2: ffffc90002c4a000 CR3:
00000000cb2fb000 CR4: 00000000000006e0
Oct 10 05:11:16 hab nc[1250]: [81347.104955] Stack:
Oct 10 05:11:16 hab nc[1250]: [81347.104960]  ffffffffa02ef741
ffff8801a4736280 ffff8800cb1cc200 0000160000000000
Oct 10 05:11:16 hab nc[1250]: [81347.104964]  ffff88011c5eae00
000000000000000e 00000000b93d27eb 00000000b93d07f3
Oct 10 05:11:16 hab nc[1250]: [81347.104968]  ffffc90002c48000
0000000000001000 0000000000000002 0000000000260000
Oct 10 05:11:16 hab nc[1250]: [81347.104969] Call Trace:
Oct 10 05:11:16 hab nc[1250]: [81347.105023]  [<ffffffffa02ef741>] ?
lzo_decompress_biovec+0x1d1/0x2c0 [btrfs]
Oct 10 05:11:16 hab nc[1250]: [81347.105073]  [<ffffffffa02f06fc>]
end_compressed_bio_read+0x20c/0x2c0 [btrfs]
Oct 10 05:11:16 hab nc[1250]: [81347.105079]  [<ffffffff8125e3ca>]
bio_endio+0x3a/0x70
Oct 10 05:11:16 hab nc[1250]: [81347.105122]  [<ffffffffa029f1e7>]
end_workqueue_fn+0x37/0x40 [btrfs]
Oct 10 05:11:16 hab nc[1250]: [81347.105170]  [<ffffffffa02d908e>]
normal_work_helper+0xae/0x2d0 [btrfs]
Oct 10 05:11:16 hab nc[1250]: [81347.105218]  [<ffffffffa02d931d>]
btrfs_endio_helper+0xd/0x10 [btrfs]
Oct 10 05:11:16 hab nc[1250]: [81347.105223]  [<ffffffff8106eb58>]
process_one_work+0x148/0x400
Oct 10 05:11:16 hab nc[1250]: [81347.105227]  [<ffffffff8106f126>]
worker_thread+0x46/0x430
Oct 10 05:11:16 hab nc[1250]: [81347.105230]  [<ffffffff8106f0e0>] ?
rescuer_thread+0x2d0/0x2d0
Oct 10 05:11:16 hab nc[1250]: [81347.105235]  [<ffffffff81073f54>]
kthread+0xc4/0xe0
Oct 10 05:11:16 hab nc[1250]: [81347.105239]  [<ffffffff81073e90>] ?
kthread_park+0x50/0x50
Oct 10 05:11:16 hab nc[1250]: [81347.105244]  [<ffffffff8155169f>]
ret_from_fork+0x3f/0x70
Oct 10 05:11:17 hab nc[1250]: [81347.105426] Hardware name: Gigabyte
Technology Co., Ltd. GA-880GM-UD2H/GA-880GM-UD2H, BIOS F8 10/11/2010
Oct 10 05:11:17 hab nc[1250]: [81347.105495] Workqueue: btrfs-endio
btrfs_endio_helper [btrfs]
Oct 10 05:11:17 hab nc[1250]: [81347.105498] task: ffff88041197b980
ti: ffff88019f5bc000 task.ti: ffff88019f5bc000
Oct 10 05:11:17 hab nc[1250]: [81347.105506] RIP:
0010:[<ffffffff81296e72>]  [<ffffffff81296e72>] __memcpy+0x12/0x20
Oct 10 05:11:17 hab nc[1250]: [81347.105508] RSP:
0018:ffff88019f5bfc68  EFLAGS: 00010246
Oct 10 05:11:17 hab nc[1250]: [81347.105511] RAX: ffffc90002e9cff8
RBX: 0000000000001000 RCX: 00000000000001ff
Oct 10 05:11:17 hab nc[1250]: [81347.105513] RDX: 0000000000000000
RSI: ffff8800a0f0c008 RDI: ffffc90002e9d000
Oct 10 05:11:17 hab nc[1250]: [81347.105515] RBP: ffff88019f5bfd30
R08: 00000000f86f2235 R09: ffffc90002e9b000
Oct 10 05:11:17 hab nc[1250]: [81347.105517] R10: ffffe8ffffc809e0
R11: 0000000000001000 R12: ffff8800a0f0c000
Oct 10 05:11:17 hab nc[1250]: [81347.105519] R13: 00000000f86f223d
R14: 0000000000000000 R15: ffff88034f468f98
Oct 10 05:11:17 hab nc[1250]: [81347.105522] FS:
00007f397f8df7c0(0000) GS:ffff880427c80000(0000)
knlGS:0000000000000000
Oct 10 05:11:17 hab nc[1250]: [81347.105524] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Oct 10 05:11:17 hab nc[1250]: [81347.105526] CR2: ffffc90002e9d000
CR3: 00000000cb2fb000 CR4: 00000000000006e0
Oct 10 05:11:17 hab nc[1250]: [81347.105527] Stack:
Oct 10 05:11:17 hab nc[1250]: [81347.105532]  ffffffffa02ef741
ffff880417403300 ffff880303e63040 0000160000000000
Oct 10 05:11:17 hab nc[1250]: [81347.105536]  ffff88034970b540
0000000000000008 00000000f86f2235 00000000f86f023d
Oct 10 05:11:17 hab nc[1250]: [81347.105540]  ffffc90002e9b000
0000000000001000 0000000000000002 0000000000380000
Oct 10 05:11:17 hab nc[1250]: [81347.105823]  [<ffffffff81073e90>] ?
kthread_park+0x50/0x50
Oct 10 05:11:17 hab nc[1250]: [81347.105829]  [<ffffffff8155169f>]
ret_from_fork+0x3f/0x70
Oct 10 05:11:17 hab nc[1250]: [81347.105833]  [<ffffffff81073e90>] ?
kthread_park+0x50/0x50
Oct 10 05:11:17 hab nc[1250]: [81347.105873] Code: ff ff 48 8b 43 60
48 2b 43 50 88 43 4e 5b 5d f3 c3 90 90 90 90 90 90 90 90 0f 1f 44 00
00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 66
0f 1f 44 00 00 48 89 f8 48 89 d1 f3
Oct 10 05:11:17 hab nc[1250]: [81347.105878] RIP  [<ffffffff81296e72>]
__memcpy+0x12/0x20
Oct 10 05:11:17 hab nc[1250]: [81347.105879]  RSP <ffff88019f5bfc68>
Oct 10 05:11:17 hab nc[1250]: [81347.105880] CR2: ffffc90002e9d000
Oct 10 05:11:17 hab nc[1250]: [81347.105884] ---[ end trace
9a43c0b6d874fe33 ]---
