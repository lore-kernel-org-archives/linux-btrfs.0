Return-Path: <SRS0=JEJz=MP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBA2C00449
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 19:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAAAD2082A
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 19:29:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAAAD2082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=swiss-wireless.com.ar
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbeJDCTV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Oct 2018 22:19:21 -0400
Received: from mail.jelmoni.net ([78.47.55.84]:50246 "EHLO mail.jelmoni.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbeJDCTU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Oct 2018 22:19:20 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2018 22:19:16 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.jelmoni.net (Postfix) with ESMTP id 7C2F9627AB
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Oct 2018 21:20:20 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at mail.jelmoni.net
Received: from mail.jelmoni.net ([78.47.55.84])
        by localhost (mail.jelmoni.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id okR7v+TTBlAP for <linux-btrfs@vger.kernel.org>;
        Wed,  3 Oct 2018 21:20:19 +0200 (CEST)
Received: from laptop-beat.swiss-wireless.com.ar (unknown [138.117.76.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: genauth@swiss-wireless.com.ar)
        by mail.jelmoni.net (Postfix) with ESMTPSA id 8C799618C8
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Oct 2018 21:20:18 +0200 (CEST)
To:     linux-btrfs@vger.kernel.org
From:   Beat Meier <mbe_ml@swiss-wireless.com.ar>
Subject: What to do with damaged root fllesystem (opensuse leap 42.2)
Message-ID: <d2d4ca86-1b51-d14f-150f-cf6b10aa44d8@swiss-wireless.com.ar>
Date:   Wed, 3 Oct 2018 16:20:14 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello

I'm using btrfs on opensuse leap 42.2.

This days I had a power loss and system does not mount anymore root 
filesystem with subvolumes.

My original problem in dmesg was skinny extents and space cache 
generation (...) does not match inode (...) errors.


After investiagting a little bit I did the following commands, which 
already told me was an error...

btrfsck /dev/sdc18

several times

After that

btrfs rescue zero-log

And at least

btrfs check --repair

All this was done on recues system or live system of opensuse


Not they told me that I should do

"btrfs restore"

with guidance of the list

So please can you guide me what to do do recover filesystem....


I have now removed disk from original system and tried to mount on leap 
15 and of course won't work :-(

Information of my leap 15 system which has not damaged root fs of my 
leap 42.2

btrfs --version
btrfs-progs v4.15

uname -a

Linux laptop 4.12.14-lp150.12.16-default #1 SMP Tue Aug 14 17:51:27 UTC 
2018 (28574e6) x86_64 x86_64 x86_64 GNU/Linux

### Disk partition info of damged root filesystem

btrfs fi show /dev/sdc18
Label: none  uuid: 5f51d84f-9c5e-4751-b0dd-93b384cea9b0
         Total devices 1 FS bytes used 29.71GiB
         devid    1 size 40.00GiB used 32.07GiB path /dev/sdc18


Here my dmesg portion:

[30145.636787] scsi host6: uas
[30145.638746] scsi 6:0:0:0: Direct-Access     ASMT ASM1156-PM       
0    PQ: 0 ANSI: 6
[30145.640777] sd 6:0:0:0: Attached scsi generic sg3 type 0
[30145.642664] sd 6:0:0:0: [sdc] 7814037168 512-byte logical blocks: 
(4.00 TB/3.64 TiB)
[30145.642676] sd 6:0:0:0: [sdc] 4096-byte physical blocks
[30145.642875] sd 6:0:0:0: [sdc] Write Protect is off
[30145.642877] sd 6:0:0:0: [sdc] Mode Sense: 43 00 00 00
[30145.643211] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[30147.021391]  sdc: sdc1 sdc2 sdc3 sdc4 sdc5 sdc6 sdc7 sdc8 sdc9 sdc10 
sdc11 sdc12 sdc13 sdc14 sdc15 sdc16 sdc17 sdc18
[30147.025728] sd 6:0:0:0: [sdc] Attached SCSI disk
[30148.996764] BTRFS: device fsid 5f51d84f-9c5e-4751-b0dd-93b384cea9b0 
devid 1 transid 510538 /dev/sdc18
[30149.222231] BTRFS: device label OS_13_1 devid 1 transid 3325 /dev/sdc4
[30237.953225] BTRFS info (device sdc18): disk space caching is enabled
[30237.953227] BTRFS info (device sdc18): has skinny extents
[30238.537571] BTRFS error (device sdc18): space cache generation 
(510509) does not match inode (510512)
[30238.537577] BTRFS warning (device sdc18): failed to load free space 
cache for block group 2176843776, rebuilding it now
[30239.565017] BTRFS: Transaction aborted (error -117)
[30239.565064] ------------[ cut here ]------------
[30239.565089] WARNING: CPU: 5 PID: 25049 at 
../fs/btrfs/extent-tree.c:6995 __btrfs_free_extent.isra.64+0xb9d/0xd40 
[btrfs]
[30239.565090] Modules linked in: uas usb_storage bnep af_packet 
vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) dm_crypt 
algif_skcipher af_alg fuse ath3k btusb uvcvideo btrtl btbcm 
videobuf2_vmalloc btintel videobuf2_memops videobuf2_v4l2 videobuf2_core 
bluetooth videodev ecdh_generic hp_wmi sparse_keymap intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_hdmi 
snd_hda_codec_idt snd_hda_codec_generic arc4 kvm irqbypass 
crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel ath9k 
pcbc ath9k_common snd_hda_codec ath9k_hw aesni_intel snd_hda_core 
aes_x86_64 snd_hwdep ath crypto_simd iTCO_wdt glue_helper msr 
iTCO_vendor_support joydev cryptd i2c_i801 snd_pcm pcspkr snd_timer 
mac80211 rtsx_pci_ms memstick snd wmi cfg80211 hp_accel r8169 lpc_ich 
rfkill lis3lv02d input_polldev
[30239.565129]  battery mii soundcore thermal mei_me ac mei shpchp btrfs 
xor raid6_pq sr_mod cdrom hid_generic usbhid amdkfd amd_iommu_v2 
rtsx_pci_sdmmc i915 radeon ahci i2c_algo_bit ehci_pci drm_kms_helper 
ehci_hcd syscopyarea sysfillrect sdhci_pci xhci_pci sysimgblt 
fb_sys_fops ttm crc32c_intel sdhci xhci_hcd serio_raw libahci mmc_core 
rtsx_pci usbcore drm drm_panel_orientation_quirks video button sg 
dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua
[30239.565160] CPU: 5 PID: 25049 Comm: mount Tainted: G O     
4.12.14-lp150.12.16-default #1 openSUSE Leap 15.0
[30239.565161] Hardware name: Hewlett-Packard HP Pavilion dv7 Notebook 
PC/1803, BIOS F.12 10/26/2011
[30239.565162] task: ffff8801966ea100 task.stack: ffffc9000441c000
[30239.565176] RIP: 0010:__btrfs_free_extent.isra.64+0xb9d/0xd40 [btrfs]
[30239.565177] RSP: 0018:ffffc9000441f6f8 EFLAGS: 00010292
[30239.565178] RAX: 0000000000000027 RBX: 0000000000000000 RCX: 
0000000000000000
[30239.565179] RDX: ffff88025fb5fd40 RSI: ffff88025fb57a68 RDI: 
ffff88025fb57a68
[30239.565180] RBP: 00000002b7b14000 R08: 00000000000004b6 R09: 
0000000000000001
[30239.565181] R10: ffff880105b64a78 R11: 0000000000000001 R12: 
ffff88017bcee000
[30239.565182] R13: 00000000ffffff8b R14: ffff880174f5e618 R15: 
ffff88019ad5c2a0
[30239.565184] FS:  00007f5f07f1dfc0(0000) GS:ffff88025fb40000(0000) 
knlGS:0000000000000000
[30239.565185] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[30239.565186] CR2: 00007f79a2ce6ff0 CR3: 000000010b644001 CR4: 
00000000000606e0
[30239.565187] Call Trace:
[30239.565203]  ? block_group_cache_tree_search+0x22/0xd0 [btrfs]
[30239.565215]  ? update_block_group.isra.63+0x142/0x3f0 [btrfs]
[30239.565233]  ? btrfs_merge_delayed_refs+0x62/0x4f0 [btrfs]
[30239.565246]  __btrfs_run_delayed_refs+0x5b9/0x1300 [btrfs]
[30239.565259]  btrfs_run_delayed_refs+0x68/0x250 [btrfs]
[30239.565272]  btrfs_write_dirty_block_groups+0x146/0x360 [btrfs]
[30239.565287]  commit_cowonly_roots+0x220/0x2c0 [btrfs]
[30239.565301]  btrfs_commit_transaction+0x389/0x900 [btrfs]
[30239.565318]  btrfs_recover_log_trees+0x3c4/0x440 [btrfs]
[30239.565332]  ? btree_read_extent_buffer_pages+0xca/0x1f0 [btrfs]
[30239.565347]  ? replay_one_extent+0x720/0x720 [btrfs]
[30239.565359]  open_ctree+0x238f/0x2480 [btrfs]
[30239.565371]  btrfs_mount+0xdd0/0xeb0 [btrfs]
[30239.565375]  ? pcpu_next_unpop+0x3b/0x50
[30239.565377]  ? pcpu_alloc+0x242/0x650
[30239.565380]  mount_fs+0x35/0x150
[30239.565383]  vfs_kern_mount.part.20+0x54/0x100
[30239.565394]  btrfs_mount+0x18a/0xeb0 [btrfs]
[30239.565397]  ? pcpu_next_unpop+0x3b/0x50
[30239.565399]  ? pcpu_alloc+0x242/0x650
[30239.565401]  mount_fs+0x35/0x150
[30239.565403]  vfs_kern_mount.part.20+0x54/0x100
[30239.565405]  do_mount+0x512/0xc30
[30239.565407]  ? memdup_user+0x3e/0x70
[30239.565409]  SyS_mount+0x80/0xd0
[30239.565412]  do_syscall_64+0x7b/0x150
[30239.565415]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[30239.565417] RIP: 0033:0x7f5f0780d19a
[30239.565418] RSP: 002b:00007ffd1420a728 EFLAGS: 00000246 ORIG_RAX: 
00000000000000a5
[30239.565420] RAX: ffffffffffffffda RBX: 0000557df1fd9170 RCX: 
00007f5f0780d19a
[30239.565420] RDX: 0000557df1fe7d10 RSI: 0000557df1fd9430 RDI: 
0000557df1fd9350
[30239.565421] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000004
[30239.565422] R10: 00000000c0ed0000 R11: 0000000000000246 R12: 
0000557df1fd9350
[30239.565423] R13: 0000557df1fe7d10 R14: 0000000000000000 R15: 
00007f5f07d241c4
[30239.565424] Code: 00 00 48 c7 c6 c0 57 87 a0 4c 89 f7 41 bd ea ff ff 
ff e8 ad d0 09 00 e9 a0 f5 ff ff 44 89 ee 48 c7 c7 30 c1 87 a0 e8 89 46 
9d e0 <0f> 0b e9 73 f5 ff ff 49 8b 46 60 f0 0f ba a8 30 17 00 00 02 72
[30239.565451] ---[ end trace 436c78d5c0b6ad39 ]---
[30239.565454] BTRFS: error (device sdc18) in __btrfs_free_extent:6995: 
errno=-117 unknown
[30239.565458] BTRFS: error (device sdc18) in 
btrfs_run_delayed_refs:3016: errno=-117 unknown
[30239.565514] BTRFS warning (device sdc18): Skipping commit of aborted 
transaction.
[30239.565519] BTRFS: error (device sdc18) in cleanup_transaction:1876: 
errno=-117 unknown
[30239.565751] BTRFS: error (device sdc18) in btrfs_replay_log:2545: 
errno=-117 unknown (Failed to recover log tree)
[30239.565835] BTRFS error (device sdc18): cleaner transaction attach 
returned -30
[30239.569437] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000024
[30239.569469] IP: btrfs_search_slot+0xd5/0xa30 [btrfs]
[30239.569487] PGD 0 P4D 0
[30239.569508] Oops: 0002 [#1] SMP PTI
[30239.569528] Modules linked in: uas usb_storage bnep af_packet 
vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) dm_crypt 
algif_skcipher af_alg fuse ath3k btusb uvcvideo btrtl btbcm 
videobuf2_vmalloc btintel videobuf2_memops videobuf2_v4l2 videobuf2_core 
bluetooth videodev ecdh_generic hp_wmi sparse_keymap intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_hdmi 
snd_hda_codec_idt snd_hda_codec_generic arc4 kvm irqbypass 
crct10dif_pclmul crc32_pclmul snd_hda_intel ghash_clmulni_intel ath9k 
pcbc ath9k_common snd_hda_codec ath9k_hw aesni_intel snd_hda_core 
aes_x86_64 snd_hwdep ath crypto_simd iTCO_wdt glue_helper msr 
iTCO_vendor_support joydev cryptd i2c_i801 snd_pcm pcspkr snd_timer 
mac80211 rtsx_pci_ms memstick snd wmi cfg80211 hp_accel r8169 lpc_ich 
rfkill lis3lv02d input_polldev
[30239.569569]  battery mii soundcore thermal mei_me ac mei shpchp btrfs 
xor raid6_pq sr_mod cdrom hid_generic usbhid amdkfd amd_iommu_v2 
rtsx_pci_sdmmc i915 radeon ahci i2c_algo_bit ehci_pci drm_kms_helper 
ehci_hcd syscopyarea sysfillrect sdhci_pci xhci_pci sysimgblt 
fb_sys_fops ttm crc32c_intel sdhci xhci_hcd serio_raw libahci mmc_core 
rtsx_pci usbcore drm drm_panel_orientation_quirks video button sg 
dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua
[30239.569652] CPU: 7 PID: 24392 Comm: kworker/u16:0 Tainted: G        
W  O     4.12.14-lp150.12.16-default #1 openSUSE Leap 15.0
[30239.569653] Hardware name: Hewlett-Packard HP Pavilion dv7 Notebook 
PC/1803, BIOS F.12 10/26/2011
[30239.569677] Workqueue: btrfs-cache btrfs_cache_helper [btrfs]
[30239.569768] task: ffff88024ed3e000 task.stack: ffffc9000477c000
[30239.569784] RIP: 0010:btrfs_search_slot+0xd5/0xa30 [btrfs]
[30239.569785] RSP: 0018:ffffc9000477fc78 EFLAGS: 00010246
[30239.569787] RAX: 0000000000000000 RBX: ffff88019ad5cb60 RCX: 
ffff88019ad5cb60
[30239.569788] RDX: ffffc9000477fd47 RSI: ffff880253f20000 RDI: 
0000000000000000
[30239.569789] RBP: 0000000000000124 R08: 0000000000000000 R09: 
0000000000000000
[30239.569791] R10: ffff880146c1b0e0 R11: ffff880000000000 R12: 
ffff880000000000
[30239.569792] R13: ffffc9000477fd47 R14: 0000000000000000 R15: 
ffff880253f20000
[30239.569794] FS:  0000000000000000(0000) GS:ffff88025fbc0000(0000) 
knlGS:0000000000000000
[30239.569795] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[30239.569797] CR2: 0000000000000024 CR3: 000000000200a001 CR4: 
00000000000606e0
[30239.569797] Call Trace:
[30239.569816]  ? read_block_for_search.isra.35+0x189/0x350 [btrfs]
[30239.569833]  btrfs_next_old_leaf+0xe8/0x480 [btrfs]
[30239.569849]  caching_thread+0x2c8/0x490 [btrfs]
[30239.569869]  btrfs_worker_helper+0x81/0x300 [btrfs]
[30239.569874]  process_one_work+0x1da/0x3f0
[30239.570118]  worker_thread+0x2b/0x3f0
[30239.570120]  ? process_one_work+0x3f0/0x3f0
[30239.570122]  kthread+0x11a/0x130
[30239.570125]  ? kthread_create_on_node+0x40/0x40
[30239.570127]  ? kthread_create_on_node+0x40/0x40
[30239.570129]  ret_from_fork+0x35/0x40
[30239.570130] Code: 48 89 cb 49 89 d5 49 89 f7 48 89 7c 24 10 0f b6 43 
6a a8 10 0f 84 a2 04 00 00 a8 20 0f 85 6f 07 00 00 49 8b 47 08 48 89 44 
24 48 <f0> ff 40 24 48 8b 44 24 48 48 ba 00 00 00 00 00 16 00 00 48 b9
[30239.570175] RIP: btrfs_search_slot+0xd5/0xa30 [btrfs] RSP: 
ffffc9000477fc78
[30239.570177] CR2: 0000000000000024
[30239.578613] ---[ end trace 436c78d5c0b6ad3a ]---


