Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C689C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 12:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33871206B6
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 12:45:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="zw//4h6G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33871206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jakorasia.info
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbeK2Xum (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 18:50:42 -0500
Received: from mail.kapsi.fi ([91.232.154.25]:55273 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbeK2Xum (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 18:50:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Message-ID:Subject:To:From:Date:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AnlpT4lD5BRj+1hE0CRz3tTsyX7hFR5zNbTa6XSz2eo=; b=zw//4h6G6pSmRGfIRuqAstxUrL
        4GKBDjOowkaJXEbsmVbq66OdqfsuffYZWEgDqxF/wEviE3g7Ph0Sw8nD1rXSs9SQVJkEnOuD9gNIx
        xtjnDAobNbXRngZvZGCquNN8l/fFKY0f5kUjNchd2tg10UbzrzLjeUOMi0ekohdiVe/jY6TCR/eXw
        /1PCFlgJH+0Fy+EK19a9yitMtUuUo/BaahXYySdadjg2+J6/0p3ZIU6FO1IF9uWmognGyENRljw62
        ZAy9XKSqqd1iraPIcxRAmnmwjpJ9E29QvDnXCEIDkud73+1aOwhATAGuifzn1LOm1uI2hmD+RzhfB
        NH7yPviw==;
Received: from 87-93-107-160.bb.dnainternet.fi ([87.93.107.160] helo=jakorasia.info)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <cg@jakorasia.info>)
        id 1gSLh5-0007hv-Fg
        for linux-btrfs@vger.kernel.org; Thu, 29 Nov 2018 14:45:23 +0200
Received: from jakorasia.info (localhost [IPv6:::1])
        by jakorasia.info (Postfix) with ESMTP id E37D02EAC5E
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 14:45:22 +0200 (EET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 29 Nov 2018 14:45:22 +0200
From:   Henri Valta <cg@jakorasia.info>
To:     linux-btrfs@vger.kernel.org
Subject: Bogus ENOSPC during send/receive
Message-ID: <a0c5ee219fb8e5e2fcacc1137b52551a@jakorasia.info>
X-Sender: cg@jakorasia.info
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 87.93.107.160
X-SA-Exim-Mail-From: cg@jakorasia.info
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I've encountered mostly reproducable ENOSPC problem with send/receive.
The target is empty, newly created btrfs on regular HDD.

Reproduced twice with Arch Linux 4.19.4 kernel and once with the system 
booted from arch install ISO
Current Release: 2018.11.01
Included Kernel: 4.18.16

The failing file is not always the same, and the fail seems to happen 
either at about 20GB or 70GB in during the process of 92GB total

-Henri

System info:

Linux 4.19.4-arch1-1-ARCH #1 SMP PREEMPT Fri Nov 23 09:06:58 UTC 2018 
x86_64 GNU/Linux

processor       : 15
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 8
model name      : AMD Ryzen 7 2700X Eight-Core Processor
stepping        : 2
microcode       : 0x800820b

MS-7B79/X470 GAMING PRO (MS-7B79), BIOS 1.50 11/16/2018

What I did:

# lsblk
NAME         MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda            8:0    0 447.1G  0 disk
├─sda1         8:1    0   430G  0 part  /btrfs-root
├─sda2         8:2    0   200M  0 part  /boot
├─sda3         8:3    0     1M  0 part
└─sda4         8:4    0    17G  0 part  [SWAP]
sdb            8:16   0 298.1G  0 disk
└─sdb1         8:17   0 298.1G  0 part
sdc            8:32   0 931.5G  0 disk
└─cryptspace 254:0    0 931.5G  0 crypt /space
sdd            8:48   1   3.8G  0 disk
├─sdd1         8:49   1   586M  0 part
└─sdd2         8:50   1    64M  0 part

# mkfs.btrfs -f /dev/sdb1
btrfs-progs v4.19
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               19974bba-3d07-4c06-bb89-b089f7dfc348
Node size:          16384
Sector size:        4096
Filesystem size:    298.09GiB
Block group profiles:
   Data:             single            8.00MiB
   Metadata:         DUP               1.00GiB
   System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
    ID        SIZE  PATH
     1   298.09GiB  /dev/sdb1

# mkdir /tmp/m
# mount /dev/sdb1 /tmp/m -o compress=zstd,enospc_debug

# dmesg
...
[ 1367.364041] BTRFS: device fsid 19974bba-3d07-4c06-bb89-b089f7dfc348 
devid 1 transid 5 /dev/sdb1
[ 1389.892696] BTRFS info (device sdb1): setting 16 feature flag
[ 1389.892699] BTRFS info (device sdb1): use zstd compression, level 0
[ 1389.892702] BTRFS info (device sdb1): disk space caching is enabled
[ 1389.892703] BTRFS info (device sdb1): has skinny extents
[ 1389.892705] BTRFS info (device sdb1): flagging fs with big metadata 
feature
[ 1389.910456] BTRFS info (device sdb1): checking UUID tree


# btrfs filesystem usage /tmp/m
Overall:
     Device size:                 298.09GiB
     Device allocated:              2.02GiB
     Device unallocated:          296.07GiB
     Device missing:                  0.00B
     Used:                        512.00KiB
     Free (estimated):            296.07GiB      (min: 148.04GiB)
     Data ratio:                       1.00
     Metadata ratio:                   2.00
     Global reserve:               16.00MiB      (used: 0.00B)

Data,single: Size:8.00MiB, Used:256.00KiB
    /dev/sdb1       8.00MiB

Metadata,DUP: Size:1.00GiB, Used:112.00KiB
    /dev/sdb1       2.00GiB

System,DUP: Size:8.00MiB, Used:16.00KiB
    /dev/sdb1      16.00MiB

Unallocated:
    /dev/sdb1     296.07GiB

# btrfs filesystem usage /btrfs-root
Overall:
     Device size:                 430.00GiB
     Device allocated:            105.07GiB
     Device unallocated:          324.93GiB
     Device missing:                  0.00B
     Used:                         91.40GiB
     Free (estimated):            335.36GiB      (min: 172.89GiB)
     Data ratio:                       1.00
     Metadata ratio:                   2.00
     Global reserve:              199.52MiB      (used: 0.00B)

Data,single: Size:99.01GiB, Used:88.58GiB
    /dev/sda1      99.01GiB

Metadata,DUP: Size:3.00GiB, Used:1.41GiB
    /dev/sda1       6.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
    /dev/sda1      64.00MiB

Unallocated:
    /dev/sda1     324.93GiB

# mount
...
/dev/sda1 on / type btrfs 
(rw,relatime,compress=zstd,ssd,discard,space_cache,subvolid=349,subvol=/rootvol)
/dev/sda1 on /btrfs-root type btrfs 
(rw,relatime,compress=zstd,ssd,discard,space_cache,subvolid=5,subvol=/)
/dev/sdb1 on /tmp/m type btrfs 
(rw,relatime,compress=zstd,space_cache,enospc_debug,subvolid=5,subvol=/)

# cd /btrfs-root
# btrfs subvolume snapshot -r rootvol rootvol_ro
Create a readonly snapshot of 'rootvol' in './rootvol_ro'


# btrfs send rootvol_ro | btrfs receive /tmp/m/
At subvol rootvol_ro
At subvol rootvol_ro

...
send still running, about 20GB copied, some messages appear on dmesg:

[ 2144.411529] ------------[ cut here ]------------
[ 2144.411532] BTRFS: block rsv returned -28
[ 2144.411586] WARNING: CPU: 2 PID: 5334 at fs/btrfs/extent-tree.c:8203 
btrfs_alloc_tree_block+0x21b/0x5b0 [btrfs]
[ 2144.411587] Modules linked in: cmac rfcomm bnep dm_crypt 
algif_skcipher af_alg amdkfd amd_iommu_v2 nls_iso8859_1 nls_cp437 vfat 
amdgpu fat edac_mce_amd chash gpu_sched i2c_algo_bit ttm kvm_amd 
snd_hda_codec_realtek drm_kms_helper snd_hda_codec_generic kvm 
snd_hda_codec_hdmi drm snd_hda_intel irqbypass dm_mod snd_hda_codec 
crct10dif_pclmul btusb crc32_pclmul snd_hda_core btrtl agpgart 
ghash_clmulni_intel btbcm snd_hwdep ppdev syscopyarea btintel pcbc 
wmi_bmof bluetooth aesni_intel aes_x86_64 crypto_simd snd_pcm cryptd 
glue_helper r8169 sp5100_tco ccp snd_timer i2c_piix4 ecdh_generic 
k10temp pcspkr sysfillrect snd joydev sysimgblt rfkill input_leds 
rng_core mousedev libphy soundcore crc16 fb_sys_fops parport_pc parport 
evdev pinctrl_amd wmi pcc_cpufreq gpio_amdpt mac_hid acpi_cpufreq sg 
crypto_user
[ 2144.411626]  ip_tables x_tables btrfs libcrc32c crc32c_generic xor 
raid6_pq sd_mod hid_generic usbhid uas hid usb_storage ahci libahci 
libata xhci_pci crc32c_intel scsi_mod xhci_hcd
[ 2144.411640] CPU: 2 PID: 5334 Comm: kworker/u32:18 Not tainted 
4.19.4-arch1-1-ARCH #1
[ 2144.411641] Hardware name: Micro-Star International Co., Ltd. 
MS-7B79/X470 GAMING PRO (MS-7B79), BIOS 1.50 11/16/2018
[ 2144.411663] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[ 2144.411678] RIP: 0010:btrfs_alloc_tree_block+0x21b/0x5b0 [btrfs]
[ 2144.411680] Code: 48 c7 c7 60 e5 36 c0 89 44 24 28 e8 af 76 19 f9 8b 
54 24 28 85 c0 0f 84 36 ff ff ff 89 d6 48 c7 c7 98 36 32 c0 e8 0f c1 a0 
f8 <0f> 0b e9 21 ff ff ff 49 8b 84 24 f0 01 00 00 48 8b 74 24 37 48 89
[ 2144.411681] RSP: 0018:ffff952c4cd93b28 EFLAGS: 00010282
[ 2144.411683] RAX: 0000000000000000 RBX: ffff8bd4d7e42000 RCX: 
0000000000000000
[ 2144.411684] RDX: 0000000000000007 RSI: ffffffffb9c9e3ce RDI: 
00000000ffffffff
[ 2144.411685] RBP: 0000000000004000 R08: 0000000000000001 R09: 
00000000000004c5
[ 2144.411686] R10: 0000000000000001 R11: 0000000000000000 R12: 
ffff8bd41cda3000
[ 2144.411687] R13: ffff8bd532f6c208 R14: ffff8bcd8093e328 R15: 
0000000000000000
[ 2144.411689] FS:  0000000000000000(0000) GS:ffff8bd53ea80000(0000) 
knlGS:0000000000000000
[ 2144.411690] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2144.411691] CR2: 00007f2bf8b6b6c0 CR3: 00000007bf706000 CR4: 
00000000003406e0
[ 2144.411692] Call Trace:
[ 2144.411708]  ? leaf_space_used+0xdc/0x100 [btrfs]
[ 2144.411722]  split_leaf+0x145/0x5f0 [btrfs]
[ 2144.411736]  btrfs_search_slot+0x9cc/0xa00 [btrfs]
[ 2144.411751]  btrfs_insert_empty_items+0x67/0xc0 [btrfs]
[ 2144.411768]  insert_reserved_file_extent.constprop.26+0x106/0x2f0 
[btrfs]
[ 2144.411787]  btrfs_finish_ordered_io+0x5d8/0x7c0 [btrfs]
[ 2144.411807]  normal_work_helper+0xbd/0x350 [btrfs]
[ 2144.411812]  process_one_work+0x1eb/0x410
[ 2144.411815]  worker_thread+0x2d/0x3d0
[ 2144.411817]  ? process_one_work+0x410/0x410
[ 2144.411819]  kthread+0x112/0x130
[ 2144.411821]  ? kthread_park+0x80/0x80
[ 2144.411824]  ret_from_fork+0x22/0x40
[ 2144.411828] ---[ end trace f0a292bb1b26398c ]---
[ 2196.110071] use_block_rsv: 5 callbacks suppressed
[ 2196.110072] ------------[ cut here ]------------
[ 2196.110074] BTRFS: block rsv returned -28
[ 2196.110123] WARNING: CPU: 3 PID: 7 at fs/btrfs/extent-tree.c:8203 
btrfs_alloc_tree_block+0x21b/0x5b0 [btrfs]
[ 2196.110124] Modules linked in: cmac rfcomm bnep dm_crypt 
algif_skcipher af_alg amdkfd amd_iommu_v2 nls_iso8859_1 nls_cp437 vfat 
amdgpu fat edac_mce_amd chash gpu_sched i2c_algo_bit ttm kvm_amd 
snd_hda_codec_realtek drm_kms_helper snd_hda_codec_generic kvm 
snd_hda_codec_hdmi drm snd_hda_intel irqbypass dm_mod snd_hda_codec 
crct10dif_pclmul btusb crc32_pclmul snd_hda_core btrtl agpgart 
ghash_clmulni_intel btbcm snd_hwdep ppdev syscopyarea btintel pcbc 
wmi_bmof bluetooth aesni_intel aes_x86_64 crypto_simd snd_pcm cryptd 
glue_helper r8169 sp5100_tco ccp snd_timer i2c_piix4 ecdh_generic 
k10temp pcspkr sysfillrect snd joydev sysimgblt rfkill input_leds 
rng_core mousedev libphy soundcore crc16 fb_sys_fops parport_pc parport 
evdev pinctrl_amd wmi pcc_cpufreq gpio_amdpt mac_hid acpi_cpufreq sg 
crypto_user
[ 2196.110163]  ip_tables x_tables btrfs libcrc32c crc32c_generic xor 
raid6_pq sd_mod hid_generic usbhid uas hid usb_storage ahci libahci 
libata xhci_pci crc32c_intel scsi_mod xhci_hcd
[ 2196.110177] CPU: 3 PID: 7 Comm: kworker/u32:0 Tainted: G        W     
     4.19.4-arch1-1-ARCH #1
[ 2196.110178] Hardware name: Micro-Star International Co., Ltd. 
MS-7B79/X470 GAMING PRO (MS-7B79), BIOS 1.50 11/16/2018
[ 2196.110201] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[ 2196.110218] RIP: 0010:btrfs_alloc_tree_block+0x21b/0x5b0 [btrfs]
[ 2196.110220] Code: 48 c7 c7 60 e5 36 c0 89 44 24 28 e8 af 76 19 f9 8b 
54 24 28 85 c0 0f 84 36 ff ff ff 89 d6 48 c7 c7 98 36 32 c0 e8 0f c1 a0 
f8 <0f> 0b e9 21 ff ff ff 49 8b 84 24 f0 01 00 00 48 8b 74 24 37 48 89
[ 2196.110222] RSP: 0018:ffff952c43213b18 EFLAGS: 00010286
[ 2196.110223] RAX: 0000000000000000 RBX: ffff8bd4d7e42000 RCX: 
0000000000000000
[ 2196.110225] RDX: 0000000000000007 RSI: ffffffffb9c9e3ce RDI: 
00000000ffffffff
[ 2196.110226] RBP: 0000000000004000 R08: 0000000000000001 R09: 
00000000000004e8
[ 2196.110227] R10: 0000000000000001 R11: 0000000000000000 R12: 
ffff8bd4de851800
[ 2196.110228] R13: ffff8bd53575f680 R14: ffff8bd532cc8188 R15: 
0000000000000000
[ 2196.110229] FS:  0000000000000000(0000) GS:ffff8bd53eac0000(0000) 
knlGS:0000000000000000
[ 2196.110231] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2196.110232] CR2: 00007fd0d813e2b0 CR3: 00000006de2c0000 CR4: 
00000000003406e0
[ 2196.110233] Call Trace:
[ 2196.110250]  ? leaf_space_used+0xdc/0x100 [btrfs]
[ 2196.110263]  split_leaf+0x145/0x5f0 [btrfs]
[ 2196.110278]  btrfs_search_slot+0x9cc/0xa00 [btrfs]
[ 2196.110292]  btrfs_insert_empty_items+0x67/0xc0 [btrfs]
[ 2196.110307]  btrfs_csum_file_blocks+0x124/0x570 [btrfs]
[ 2196.110325]  add_pending_csums+0x50/0x70 [btrfs]
[ 2196.110342]  btrfs_finish_ordered_io+0x33f/0x7c0 [btrfs]
[ 2196.110361]  normal_work_helper+0xbd/0x350 [btrfs]
[ 2196.110366]  process_one_work+0x1eb/0x410
[ 2196.110369]  worker_thread+0x2d/0x3d0
[ 2196.110371]  ? process_one_work+0x410/0x410
[ 2196.110373]  kthread+0x112/0x130
[ 2196.110375]  ? kthread_park+0x80/0x80
[ 2196.110378]  ret_from_fork+0x22/0x40
[ 2196.110381] ---[ end trace f0a292bb1b26398d ]---

[ 2273.212181] ------------[ cut here ]------------
[ 2273.212183] BTRFS: block rsv returned -28
[ 2273.212232] WARNING: CPU: 14 PID: 5326 at fs/btrfs/extent-tree.c:8203 
btrfs_alloc_tree_block+0x21b/0x5b0 [btrfs]
[ 2273.212233] Modules linked in: cmac rfcomm bnep dm_crypt 
algif_skcipher af_alg amdkfd amd_iommu_v2 nls_iso8859_1 nls_cp437 vfat 
amdgpu fat edac_mce_amd chash gpu_sched i2c_algo_bit ttm kvm_amd 
snd_hda_codec_realtek drm_kms_helper snd_hda_codec_generic kvm 
snd_hda_codec_hdmi drm snd_hda_intel irqbypass dm_mod snd_hda_codec 
crct10dif_pclmul btusb crc32_pclmul snd_hda_core btrtl agpgart 
ghash_clmulni_intel btbcm snd_hwdep ppdev syscopyarea btintel pcbc 
wmi_bmof bluetooth aesni_intel aes_x86_64 crypto_simd snd_pcm cryptd 
glue_helper r8169 sp5100_tco ccp snd_timer i2c_piix4 ecdh_generic 
k10temp pcspkr sysfillrect snd joydev sysimgblt rfkill input_leds 
rng_core mousedev libphy soundcore crc16 fb_sys_fops parport_pc parport 
evdev pinctrl_amd wmi pcc_cpufreq gpio_amdpt mac_hid acpi_cpufreq sg 
crypto_user
[ 2273.212269]  ip_tables x_tables btrfs libcrc32c crc32c_generic xor 
raid6_pq sd_mod hid_generic usbhid uas hid usb_storage ahci libahci 
libata xhci_pci crc32c_intel scsi_mod xhci_hcd
[ 2273.212282] CPU: 14 PID: 5326 Comm: kworker/u32:11 Tainted: G        
W         4.19.4-arch1-1-ARCH #1
[ 2273.212283] Hardware name: Micro-Star International Co., Ltd. 
MS-7B79/X470 GAMING PRO (MS-7B79), BIOS 1.50 11/16/2018
[ 2273.212304] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[ 2273.212319] RIP: 0010:btrfs_alloc_tree_block+0x21b/0x5b0 [btrfs]
[ 2273.212321] Code: 48 c7 c7 60 e5 36 c0 89 44 24 28 e8 af 76 19 f9 8b 
54 24 28 85 c0 0f 84 36 ff ff ff 89 d6 48 c7 c7 98 36 32 c0 e8 0f c1 a0 
f8 <0f> 0b e9 21 ff ff ff 49 8b 84 24 f0 01 00 00 48 8b 74 24 37 48 89
[ 2273.212322] RSP: 0018:ffff952c4cd63b28 EFLAGS: 00010282
[ 2273.212323] RAX: 0000000000000000 RBX: ffff8bd4d7e42000 RCX: 
0000000000000000
[ 2273.212324] RDX: 0000000000000007 RSI: ffffffffb9c9e3ce RDI: 
00000000ffffffff
[ 2273.212325] RBP: 0000000000004000 R08: 0000000000000001 R09: 
000000000000050d
[ 2273.212326] R10: 0000000000000001 R11: 0000000000000000 R12: 
ffff8bd41cda3000
[ 2273.212327] R13: ffff8bd535465a90 R14: ffff8bd536eeb6c8 R15: 
0000000000000000
[ 2273.212329] FS:  0000000000000000(0000) GS:ffff8bd53ed80000(0000) 
knlGS:0000000000000000
[ 2273.212330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2273.212331] CR2: 00007f287938d010 CR3: 00000006de2c0000 CR4: 
00000000003406e0
[ 2273.212332] Call Trace:
[ 2273.212348]  ? leaf_space_used+0xdc/0x100 [btrfs]
[ 2273.212361]  split_leaf+0x145/0x5f0 [btrfs]
[ 2273.212376]  btrfs_search_slot+0x9cc/0xa00 [btrfs]
[ 2273.212390]  btrfs_insert_empty_items+0x67/0xc0 [btrfs]
[ 2273.212407]  insert_reserved_file_extent.constprop.26+0x106/0x2f0 
[btrfs]
[ 2273.212425]  btrfs_finish_ordered_io+0x5d8/0x7c0 [btrfs]
[ 2273.212444]  normal_work_helper+0xbd/0x350 [btrfs]
[ 2273.212449]  process_one_work+0x1eb/0x410
[ 2273.212452]  worker_thread+0x2d/0x3d0
[ 2273.212454]  ? process_one_work+0x410/0x410
[ 2273.212456]  kthread+0x112/0x130
[ 2273.212458]  ? kthread_park+0x80/0x80
[ 2273.212461]  ret_from_fork+0x22/0x40
[ 2273.212464] ---[ end trace f0a292bb1b26398e ]---

...
back to the previous send which was still running... Now it fails with 
this error after ~70GB transferred
# btrfs send rootvol_ro | btrfs receive /tmp/m/
At subvol rootvol_ro
At subvol rootvol_ro
ERROR: rename o379967-120-0 -> 
opt/altera/13.0sp1/modelsim_ae/altera/vhdl/arriavgz_hssi/8bc44/_primary.dat 
failed: No space left on device

New stuff from dmesg:

[ 3707.694762] use_block_rsv: 6 callbacks suppressed
[ 3707.694763] ------------[ cut here ]------------
[ 3707.694766] BTRFS: block rsv returned -28
[ 3707.694814] WARNING: CPU: 13 PID: 5392 at fs/btrfs/extent-tree.c:8203 
btrfs_alloc_tree_block+0x21b/0x5b0 [btrfs]
[ 3707.694815] Modules linked in: cmac rfcomm bnep dm_crypt 
algif_skcipher af_alg amdkfd amd_iommu_v2 nls_iso8859_1 nls_cp437 vfat 
amdgpu fat edac_mce_amd chash gpu_sched i2c_algo_bit ttm kvm_amd 
snd_hda_codec_realtek drm_kms_helper snd_hda_codec_generic kvm 
snd_hda_codec_hdmi drm snd_hda_intel irqbypass dm_mod snd_hda_codec 
crct10dif_pclmul btusb crc32_pclmul snd_hda_core btrtl agpgart 
ghash_clmulni_intel btbcm snd_hwdep ppdev syscopyarea btintel pcbc 
wmi_bmof bluetooth aesni_intel aes_x86_64 crypto_simd snd_pcm cryptd 
glue_helper r8169 sp5100_tco ccp snd_timer i2c_piix4 ecdh_generic 
k10temp pcspkr sysfillrect snd joydev sysimgblt rfkill input_leds 
rng_core mousedev libphy soundcore crc16 fb_sys_fops parport_pc parport 
evdev pinctrl_amd wmi pcc_cpufreq gpio_amdpt mac_hid acpi_cpufreq sg 
crypto_user
[ 3707.694851]  ip_tables x_tables btrfs libcrc32c crc32c_generic xor 
raid6_pq sd_mod hid_generic usbhid uas hid usb_storage ahci libahci 
libata xhci_pci crc32c_intel scsi_mod xhci_hcd
[ 3707.694864] CPU: 13 PID: 5392 Comm: kworker/u32:23 Tainted: G        
W         4.19.4-arch1-1-ARCH #1
[ 3707.694865] Hardware name: Micro-Star International Co., Ltd. 
MS-7B79/X470 GAMING PRO (MS-7B79), BIOS 1.50 11/16/2018
[ 3707.694886] Workqueue: btrfs-endio-write btrfs_endio_write_helper 
[btrfs]
[ 3707.694901] RIP: 0010:btrfs_alloc_tree_block+0x21b/0x5b0 [btrfs]
[ 3707.694902] Code: 48 c7 c7 60 e5 36 c0 89 44 24 28 e8 af 76 19 f9 8b 
54 24 28 85 c0 0f 84 36 ff ff ff 89 d6 48 c7 c7 98 36 32 c0 e8 0f c1 a0 
f8 <0f> 0b e9 21 ff ff ff 49 8b 84 24 f0 01 00 00 48 8b 74 24 37 48 89
[ 3707.694904] RSP: 0018:ffff952c4c943ad0 EFLAGS: 00010286
[ 3707.694905] RAX: 0000000000000000 RBX: ffff8bd4d7e42000 RCX: 
0000000000000000
[ 3707.694906] RDX: 0000000000000007 RSI: ffffffffb9c9e3ce RDI: 
00000000ffffffff
[ 3707.694907] RBP: 0000000000004000 R08: 0000000000000001 R09: 
0000000000000535
[ 3707.694908] R10: 0000000000000001 R11: 0000000000000000 R12: 
ffff8bd4de851800
[ 3707.694909] R13: ffff8bd532c33d68 R14: ffff8bd482282098 R15: 
0000000000000000
[ 3707.694911] FS:  0000000000000000(0000) GS:ffff8bd53ed40000(0000) 
knlGS:0000000000000000
[ 3707.694912] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3707.694913] CR2: 00007ffc6ce90ff8 CR3: 00000007fa85a000 CR4: 
00000000003406e0
[ 3707.694914] Call Trace:
[ 3707.694930]  __btrfs_cow_block+0x142/0x520 [btrfs]
[ 3707.694944]  btrfs_cow_block+0xdc/0x1a0 [btrfs]
[ 3707.694958]  btrfs_search_slot+0x282/0xa00 [btrfs]
[ 3707.694973]  btrfs_lookup_csum+0x52/0x150 [btrfs]
[ 3707.694977]  ? kmem_cache_alloc+0x16e/0x1c0
[ 3707.694992]  btrfs_csum_file_blocks+0x22c/0x570 [btrfs]
[ 3707.695009]  add_pending_csums+0x50/0x70 [btrfs]
[ 3707.695026]  btrfs_finish_ordered_io+0x33f/0x7c0 [btrfs]
[ 3707.695045]  normal_work_helper+0xbd/0x350 [btrfs]
[ 3707.695049]  process_one_work+0x1eb/0x410
[ 3707.695052]  worker_thread+0x2d/0x3d0
[ 3707.695054]  ? process_one_work+0x410/0x410
[ 3707.695056]  kthread+0x112/0x130
[ 3707.695058]  ? kthread_park+0x80/0x80
[ 3707.695061]  ret_from_fork+0x22/0x40
[ 3707.695064] ---[ end trace f0a292bb1b26398f ]---
[ 3714.148546] BTRFS info (device sdb1): space_info 4 has 
18446744058945519616 free, is not full
[ 3714.148549] BTRFS info (device sdb1): space_info total=1073741824, 
used=308281344, pinned=0, reserved=360448, may_use=15529066496, 
readonly=65536

# btrfs filesystem usage /tmp/m
Overall:
     Device size:                 298.09GiB
     Device allocated:             78.02GiB
     Device unallocated:          220.07GiB
     Device missing:                  0.00B
     Used:                         75.88GiB
     Free (estimated):            220.78GiB      (min: 110.75GiB)
     Data ratio:                       1.00
     Metadata ratio:                   2.00
     Global reserve:              111.95MiB      (used: 0.00B)

Data,single: Size:76.01GiB, Used:75.29GiB
    /dev/sdb1      76.01GiB

Metadata,DUP: Size:1.00GiB, Used:302.73MiB
    /dev/sdb1       2.00GiB

System,DUP: Size:8.00MiB, Used:16.00KiB
    /dev/sdb1      16.00MiB

Unallocated:
    /dev/sdb1     220.07GiB

# ls -oah 
/btrfs-root/rootvol/opt/altera/13.0sp1/modelsim_ae/altera/vhdl/arriavgz_hssi/8bc44/_primary.dat
-rw-r--r-- 1 root 8.2K Jun 13  2013 
/opt/altera/13.0sp1/modelsim_ae/altera/vhdl/arriavgz_hssi/8bc44/_primary.dat

