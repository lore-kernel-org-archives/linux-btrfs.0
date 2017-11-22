Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44341 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdKVXkS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 18:40:18 -0500
Date: Wed, 22 Nov 2017 15:35:35 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: =?iso-8859-1?B?Suly9G1l?= Carretero <cJ-ko@zougloub.eu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: WARNING: CPU: 3 PID: 20953 at
 /usr/src/linux/fs/btrfs/raid56.c:848 __free_raid_bio+0x8e/0xa0
Message-ID: <20171122233534.GA8475@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20171120020007.01897b13@Vantage.cJ>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20171120020007.01897b13@Vantage.cJ>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 20, 2017 at 02:00:07AM -0500, Jérôme Carretero wrote:
> Hi,
> 
> 
> 
> This was while doing a "userspace scrub" with "tar c":
> 
> [633250.707455] btrfs_print_data_csum_error: 14608 callbacks suppressed
> [633250.707459] BTRFS warning (device dm-18): csum failed root 5 ino 1376 off 3530293248 csum 0xb8c194fb expected csum 0xb3680c88 mirror 2
> [633250.707465] BTRFS warning (device dm-18): csum failed root 5 ino 1376 off 3530293248 csum 0x7f422a5d expected csum 0xb3680c88 mirror 2
> [633250.707470] BTRFS warning (device dm-18): csum failed root 5 ino 1376 off 3530293248 csum 0xa5db59eb expected csum 0xb3680c88 mirror 2
> [633250.707473] BTRFS warning (device dm-18): csum failed root 5 ino 1376 off 3530293248 csum 0x5d244234 expected csum 0xb3680c88 mirror 2
> [633250.707475] BTRFS warning (device dm-18): csum failed root 5 ino 1376 off 3530293248 csum 0x7f422a5d expected csum 0xb3680c88 mirror 2
> [633250.707478] BTRFS warning (device dm-18): csum failed root 5 ino 1376 off 3530301440 csum 0xc0a71540 expected csum 0x904f75bc mirror 2
> [633250.707480] BTRFS warning (device dm-18): csum failed root 5 ino 1376 off 3530293248 csum 0x7f422a5d expected csum 0xb3680c88 mirror 2
> [633250.707483] BTRFS warning (device dm-18): csum failed root 5 ino 1376 off 3530293248 csum 0x7f422a5d expected csum 0xb3680c88 mirror 2
> [633250.707484] BTRFS warning (device dm-18): csum failed root 5 ino 1376 off 3530301440 csum 0x0abd2cac expected csum 0x904f75bc mirror 2
> [633250.707488] BTRFS warning (device dm-18): csum failed root 5 ino 1376 off 3530301440 csum 0x0d046c34 expected csum 0x904f75bc mirror 2
> [633250.888501] BTRFS info (device dm-18): read error corrected: ino 1376 off 230948864 (dev /dev/mapper/I8U2-4 sector 1373688)
> [633250.937373] BTRFS info (device dm-18): read error corrected: ino 1376 off 230952960 (dev /dev/mapper/I8U2-4 sector 1373688)
> [633250.949808] BTRFS info (device dm-18): read error corrected: ino 1376 off 230957056 (dev /dev/mapper/I8U2-4 sector 1373688)
> [633250.961703] BTRFS info (device dm-18): read error corrected: ino 1376 off 230961152 (dev /dev/mapper/I8U2-4 sector 1373688)
> [633250.973827] BTRFS info (device dm-18): read error corrected: ino 1376 off 230965248 (dev /dev/mapper/I8U2-4 sector 1373688)
> [633250.986271] BTRFS info (device dm-18): read error corrected: ino 1376 off 230969344 (dev /dev/mapper/I8U2-4 sector 1373688)
> [633250.998517] BTRFS info (device dm-18): read error corrected: ino 1376 off 230973440 (dev /dev/mapper/I8U2-4 sector 1373688)
> [633251.010537] BTRFS info (device dm-18): read error corrected: ino 1376 off 230977536 (dev /dev/mapper/I8U2-4 sector 1373688)
> [633251.022767] BTRFS info (device dm-18): read error corrected: ino 1376 off 230981632 (dev /dev/mapper/I8U2-4 sector 1373688)
> [633251.034990] BTRFS info (device dm-18): read error corrected: ino 1376 off 230985728 (dev /dev/mapper/I8U2-4 sector 1373688)
> [633254.456570] ------------[ cut here ]------------
> [633254.461294] WARNING: CPU: 3 PID: 20953 at /usr/src/linux/fs/btrfs/raid56.c:848 __free_raid_bio+0x8e/0xa0


The vanilla 4.14.0 shows it is WARN_ON(!bio_list_empty(&rbio->bio_list));
but we just emptied rbio->bio_list two lines above, i.e.
struct bio *cur = bio_list_get(&rbio->bio_list);

Either we have some weird race, or the line number is misleading me.

Can you please check the code which warning fs/btrfs/raid56.c:848 points to?

thanks,
-liubo

> [633254.470863] Modules linked in: bfq twofish_avx_x86_64 twofish_x86_64_3way xts twofish_x86_64 twofish_common serpent_avx_x86_64 serpent_generic lrw gf128mul ablk_helper algif_skcipher af_alg nfnetlink_queue nfnetlink_log nfnetlink cfg80211 rfkill usbmon fuse usb_storage dm_crypt dm_mod dax coretemp hwmon intel_rapl snd_hda_codec_realtek x86_pkg_temp_thermal snd_hda_codec_generic iTCO_wdt kvm_intel iTCO_vendor_support snd_hda_intel kvm snd_hda_codec irqbypass snd_hwdep aesni_intel snd_hda_core aes_x86_64 snd_pcm xhci_pci snd_timer ehci_pci crypto_simd xhci_hcd cryptd ehci_hcd sdhci_pci glue_helper pcspkr snd usbcore sdhci soundcore lpc_ich mmc_core usb_common mfd_core bnx2 bonding autofs4 [last unloaded: i2c_dev]
> [633254.533987] CPU: 3 PID: 20953 Comm: kworker/u16:18 Tainted: G        W       4.14.0-Vantage-dirty #14
> [633254.543298] Hardware name: LENOVO 056851U/LENOVO, BIOS A0KT56AUS 02/01/2016
> [633254.550365] Workqueue: btrfs-endio btrfs_endio_helper
> [633254.555508] task: ffff880859523b00 task.stack: ffffc90006164000
> [633254.561528] RIP: 0010:__free_raid_bio+0x8e/0xa0
> [633254.566143] RSP: 0018:ffffc90006167bc8 EFLAGS: 00010282
> [633254.571457] RAX: ffff88052540d010 RBX: ffff8801ffd02800 RCX: 0000000000000001
> [633254.578683] RDX: ffff88052540d010 RSI: 0000000000000246 RDI: ffff88052540d000
> [633254.585912] RBP: ffff88052540d000 R08: 0000000000000000 R09: 0000000000010000
> [633254.593131] R10: ffff8805ad3a2e60 R11: 0000000000000006 R12: 000000000000000a
> [633254.600378] R13: 0000000000000004 R14: 0000000000000001 R15: ffff880537d1c000
> [633254.607604] FS:  0000000000000000(0000) GS:ffff88087fcc0000(0000) knlGS:0000000000000000
> [633254.615804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [633254.621635] CR2: 00007f13db554000 CR3: 0000000001e09002 CR4: 00000000000606e0
> [633254.628870] Call Trace:
> [633254.631421]  rbio_orig_end_io+0x42/0x80
> [633254.635352]  __raid56_parity_recover+0x17a/0x1f0
> [633254.640078]  raid56_parity_recover+0x193/0x1d0
> [633254.644623]  btrfs_map_bio+0x209/0x330
> [633254.648484]  btrfs_submit_compressed_read+0x2f7/0x4a0
> [633254.653640]  btrfs_submit_bio_hook+0x13e/0x170
> [633254.658192]  end_bio_extent_readpage+0x4fb/0x5a0
> [633254.662904]  btrfs_scrubparity_helper+0xcd/0x340
> [633254.667623]  process_one_work+0x1d2/0x410
> [633254.671723]  worker_thread+0x42/0x3e0
> [633254.675474]  kthread+0xf7/0x130
> [633254.678707]  ? process_one_work+0x410/0x410
> [633254.682989]  ? kthread_create_on_node+0x40/0x40
> [633254.687621]  ? do_group_exit+0x35/0xa0
> [633254.691473]  ret_from_fork+0x25/0x30
> [633254.695138] Code: 00 00 4a c7 04 e0 00 00 00 00 83 c5 01 3b ab d8 00 00 00 7c cc 48 8b 7b 08 e8 ef 4f fb ff 48 89 df 5b 5d 41 5c e9 03 a6 e5 ff c3 <0f> ff eb a3 0f ff eb 88 0f ff eb 91 66 0f 1f 44 00 00 48 8b 87 
> [633254.714135] ---[ end trace a831ae18db38254d ]---
> 
> 
> Regards,
> 
> -- 
> Jérôme
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
