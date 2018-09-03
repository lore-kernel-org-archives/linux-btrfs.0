Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:43322 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbeIDAqv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2018 20:46:51 -0400
Message-ID: <7146cafcc48d46ad123388d492807cbba08e101c.camel@scientia.net>
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Su Yue <Damenly_Su@gmx.com>
Date: Mon, 03 Sep 2018 22:24:57 +0200
In-Reply-To: <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
         <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey.


On Fri, 2018-08-31 at 10:33 +0800, Su Yue wrote:
> Can you please fetch btrfs-progs from my repo and run lowmem check
> in readonly?
> Repo: https://github.com/Damenly/btrfs-progs/tree/lowmem_debug
> It's based on v4.17.1 plus additonal output for debug only.

I've adapted your patch to 4.17 from Debian (i.e. not the 4.17.1).


First I ran it again with the pristine 4.17 from Debian:
# btrfs check --mode=lowmem /dev/mapper/system ; echo $?
Checking filesystem on /dev/mapper/system
UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
checking extents
checking free space cache
checking fs roots
ERROR: errors found in fs roots
found 435924422656 bytes used, error(s) found
total csum bytes: 423418948
total tree bytes: 2218328064
total fs tree bytes: 1557168128
total extent tree bytes: 125894656
btree space waste bytes: 429599230
file data blocks allocated: 5193373646848
 referenced 555255164928
[ 1248.687628] ------------[ cut here ]------------
[ 1248.688352] generic_make_request: Trying to write to read-only block-device dm-0 (partno 0)
[ 1248.689127] WARNING: CPU: 3 PID: 933 at /build/linux-LgHyGB/linux-4.17.17/block/blk-core.c:2180 generic_make_request_checks+0x43d/0x610
[ 1248.689909] Modules linked in: dm_crypt algif_skcipher af_alg dm_mod snd_hda_codec_hdmi snd_hda_codec_realtek intel_rapl snd_hda_codec_generic x86_pkg_temp_thermal intel_powerclamp i915 iwlwifi btusb coretemp btrtl btbcm uvcvideo kvm_intel snd_hda_intel btintel videobuf2_vmalloc bluetooth snd_hda_codec kvm videobuf2_memops videobuf2_v4l2 videobuf2_common cfg80211 snd_hda_core irqbypass videodev jitterentropy_rng drm_kms_helper crct10dif_pclmul snd_hwdep crc32_pclmul drbg ghash_clmulni_intel intel_cstate snd_pcm ansi_cprng ppdev intel_uncore drm media ecdh_generic iTCO_wdt snd_timer iTCO_vendor_support rtsx_pci_ms crc16 snd intel_rapl_perf memstick joydev mei_me rfkill evdev soundcore sg parport_pc pcspkr serio_raw fujitsu_laptop mei i2c_algo_bit parport shpchp sparse_keymap pcc_cpufreq lpc_ich button
[ 1248.693639]  video battery ac ip_tables x_tables autofs4 btrfs zstd_decompress zstd_compress xxhash raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath linear md_mod sd_mod uas usb_storage crc32c_intel rtsx_pci_sdmmc mmc_core ahci xhci_pci libahci aesni_intel ehci_pci aes_x86_64 libata crypto_simd xhci_hcd ehci_hcd cryptd glue_helper psmouse i2c_i801 scsi_mod rtsx_pci e1000e usbcore usb_common
[ 1248.696956] CPU: 3 PID: 933 Comm: btrfs Not tainted 4.17.0-3-amd64 #1 Debian 4.17.17-1
[ 1248.698118] Hardware name: FUJITSU LIFEBOOK E782/FJNB253, BIOS Version 2.11 07/15/2014
[ 1248.699299] RIP: 0010:generic_make_request_checks+0x43d/0x610
[ 1248.700495] RSP: 0018:ffffac89827c7d88 EFLAGS: 00010286
[ 1248.701702] RAX: 0000000000000000 RBX: ffff98f4848a9200 RCX: 0000000000000006
[ 1248.702930] RDX: 0000000000000007 RSI: 0000000000000082 RDI: ffff98f49e2d6730
[ 1248.704170] RBP: ffff98f484f6d460 R08: 000000000000033e R09: 0000000000aaaaaa
[ 1248.705422] R10: ffffac89827c7e60 R11: 00000000ffffffff R12: 0000000000000000
[ 1248.706675] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[ 1248.707928] FS:  00007f92842018c0(0000) GS:ffff98f49e2c0000(0000) knlGS:0000000000000000
[ 1248.709190] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1248.710448] CR2: 000055fc6fe1a5b0 CR3: 0000000407f62001 CR4: 00000000001606e0
[ 1248.711707] Call Trace:
[ 1248.712960]  ? do_writepages+0x4b/0xe0
[ 1248.714201]  ? blkdev_readpages+0x20/0x20
[ 1248.715441]  ? do_writepages+0x4b/0xe0
[ 1248.716684]  generic_make_request+0x64/0x400
[ 1248.717935]  ? finish_wait+0x80/0x80
[ 1248.719181]  ? mempool_alloc+0x67/0x1a0
[ 1248.720425]  ? submit_bio+0x6c/0x140
[ 1248.721663]  submit_bio+0x6c/0x140
[ 1248.722902]  submit_bio_wait+0x53/0x80
[ 1248.724139]  blkdev_issue_flush+0x7c/0xb0
[ 1248.725377]  blkdev_fsync+0x2f/0x40
[ 1248.726612]  do_fsync+0x38/0x60
[ 1248.727849]  __x64_sys_fsync+0x10/0x20
[ 1248.729086]  do_syscall_64+0x55/0x110
[ 1248.730323]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1248.731565] RIP: 0033:0x7f928354d161
[ 1248.732805] RSP: 002b:00007ffd35e3f5d8 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
[ 1248.734067] RAX: ffffffffffffffda RBX: 000055fc09c0c260 RCX: 00007f928354d161
[ 1248.735342] RDX: 000055fc09c13e28 RSI: 000055fc0899f820 RDI: 0000000000000004
[ 1248.736614] RBP: 000055fc09c0c2d0 R08: 0000000000000005 R09: 000055fc09c0da70
[ 1248.738001] R10: 000000000000009e R11: 0000000000000246 R12: 0000000000000000
[ 1248.739272] R13: 000055fc0899d213 R14: 000055fc09c0c290 R15: 0000000000000001
[ 1248.740542] Code: 24 54 03 00 00 48 8d 74 24 08 48 89 df c6 05 3e 03 d9 00 01 e8 d5 63 01 00 44 89 e2 48 89 c6 48 c7 c7 80 e1 e6 ad e8 a3 4e d1 ff <0f> 0b 4c 8b 63 08 e9 7b fc ff ff 80 3d 15 03 d9 00 00 0f 85 94
[ 1248.741909] ---[ end trace c2f580dbd579028c ]---
1

Not really sure why btrfs-check apparently tries to write to the device
(I've had set it blockdev --setro).



And with your patch:
# btrfs check --mode=lowmem /dev/mapper/system ; echo $?
checking extents
checking free space cache
checking fs roots
ERROR: errors found in fs roots
Checking filesystem on /dev/mapper/system
UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
DEBUG: error before walking while checking fs root 3 ret -694376768
DEBUG: normal error in walking while checking node 125988438016 fs root
257 ret 524296
DEBUG: error in checking fs root 257 ret 524296
DEBUG: normal error in walking while checking node 230148259840 fs root
743 ret 524296
DEBUG: error in checking fs root 743 ret 524296
DEBUG: error in checking fs roots ret:
found 435924422656 bytes used, error(s) found
total csum bytes: 423418948
total tree bytes: 2218328064
total fs tree bytes: 1557168128
total extent tree bytes: 125894656
btree space waste bytes: 429599230
file data blocks allocated: 5193373646848
 referenced 555255164928
1

Interestingly it doesn't try to write again (or the kernel doesn't just
print another call trace this time).



Cheers,
Chris.
