Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li1424-102.members.linode.com ([139.162.157.102]:59022 "EHLO
        smtp.tevsa.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751112AbdLYBLA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Dec 2017 20:11:00 -0500
Subject: Re: Linux 4.14 breaks btrfs filesystems (3 times already)
To: Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <cf9e2d88-2251-7593-3c8b-d0ea198fd481@mokrynskyi.com>
From: Alec Blayne <ab@tevsa.net>
Message-ID: <f48a0423-0599-9b12-23d7-8c9530093dab@tevsa.net>
Date: Mon, 25 Dec 2017 01:00:28 +0000
MIME-Version: 1.0
In-Reply-To: <cf9e2d88-2251-7593-3c8b-d0ea198fd481@mokrynskyi.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24-12-2017 09:37, Nazar Mokrynskyi wrote:
> Hi folks,
> 
> I know this is a bold statement, but this is also exactly what I'm experiencing.
> 
> 2 filesystems that worked perfectly since July 2015 and one freshly created crashed during last 5 weeks since Ubuntu 18.04 switched from 4.13 to 4.14 (my current kernel is 4.14.0-11-generic).
> 
> I wrote about the first case (backup partition) 5 weeks ago (title was "Unrecoverable scrub errors"), but eventually recreated mentioned corrupted filesystem, scrubbed and checked other filesystems - everything was good, no errors and no warnings.
> 
> 4 days ago I noticed that random files on my primary filesystem become corrupted in a very interesting way. Sometimes completely, sometimes only partially (like I was playing a game and it crashed at certain moment, when particular piece of data file was read). I've recreated primary filesystem too.
> 
> This morning primary filesystem crashed again even harder that before.
> 
> Scrub on latest crashed filesystem:
> 
> [ 1074.544160] ------------[ cut here ]------------
> [ 1074.544162] kernel BUG at /build/linux-XO_uEE/linux-4.13.0/fs/btrfs/ctree.h:1802!
> [ 1074.544166] invalid opcode: 0000 [#1] SMP
> [ 1074.544174] Modules linked in: btrfs xor raid6_pq dm_crypt algif_skcipher af_alg intel_rapl x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_hdmi coretemp kvm_intel kvm snd_usb_audio snd_hda_intel snd_usbmidi_lib irqbypass snd_hda_codec crct10dif_pclmul crc32_pclmul snd_hda_core ghash_clmulni_intel snd_hwdep pcbc snd_seq_midi snd_seq_midi_event aesni_intel snd_seq snd_rawmidi snd_pcm snd_seq_device snd_timer snd cdc_acm soundcore joydev input_leds aes_x86_64 crypto_simd glue_helper serio_raw cryptd intel_cstate intel_rapl_perf lpc_ich mei_me mei shpchp mac_hid parport_pc ppdev lp parport ip_tables x_tables autofs4 overlay nls_iso8859_1 dm_mirror dm_region_hash dm_log hid_generic usbhid hid uas usb_storage nouveau mxm_wmi video ttm drm_kms_helper igb syscopyarea sysfillrect sysimgblt dca fb_sys_fops
> [ 1074.544232]  ahci i2c_algo_bit drm ptp libahci nvme pps_core nvme_core wmi
> [ 1074.544240] CPU: 8 PID: 5459 Comm: kworker/u24:0 Not tainted 4.13.0-16-generic #19-Ubuntu
> [ 1074.544244] Hardware name: MSI MS-7885/X99A SLI Krait Edition (MS-7885), BIOS N.92 01/10/2017
> [ 1074.544271] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
> [ 1074.544276] task: ffff8d7eaecf5d00 task.stack: ffff9ab182ecc000
> [ 1074.544292] RIP: 0010:btrfs_extent_inline_ref_size.part.38+0x4/0x6 [btrfs]
> [ 1074.544296] RSP: 0018:ffff9ab182ecfa98 EFLAGS: 00010297
> [ 1074.544300] RAX: 0000000000000000 RBX: 00000000000000b6 RCX: ffff9ab182ecfa50
> [ 1074.544303] RDX: 0000000000000001 RSI: 00000000000036a6 RDI: 0000000000000000
> [ 1074.544307] RBP: ffff9ab182ecfa98 R08: 00000000000036a7 R09: ffff9ab182ecfa60
> [ 1074.544310] R10: 0000000000000000 R11: 0000000000000003 R12: ffff8d7e860c6348
> [ 1074.544313] R13: 0000000000000000 R14: 00000000000036a6 R15: 00000000000036e5
> [ 1074.544317] FS:  0000000000000000(0000) GS:ffff8d7eef400000(0000) knlGS:0000000000000000
> [ 1074.544321] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1074.544324] CR2: 00007faeb4020000 CR3: 00000003bb609000 CR4: 00000000003406e0
> [ 1074.544328] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1074.544332] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1074.544335] Call Trace:
> [ 1074.544348]  lookup_inline_extent_backref+0x5a3/0x5b0 [btrfs]
> [ 1074.544360]  ? setup_inline_extent_backref+0x16e/0x260 [btrfs]
> [ 1074.544371]  insert_inline_extent_backref+0x50/0xe0 [btrfs]
> [ 1074.544382]  __btrfs_inc_extent_ref.isra.51+0x7e/0x260 [btrfs]
> [ 1074.544396]  ? btrfs_merge_delayed_refs+0x62/0x550 [btrfs]
> [ 1074.544408]  __btrfs_run_delayed_refs+0xc52/0x1380 [btrfs]
> [ 1074.544420]  btrfs_run_delayed_refs+0x6b/0x250 [btrfs]
> [ 1074.544431]  delayed_ref_async_start+0x98/0xb0 [btrfs]
> [ 1074.544445]  btrfs_worker_helper+0x7a/0x2e0 [btrfs]
> [ 1074.544458]  btrfs_extent_refs_helper+0xe/0x10 [btrfs]
> [ 1074.544464]  process_one_work+0x1e7/0x410
> [ 1074.544467]  worker_thread+0x4a/0x410
> [ 1074.544471]  kthread+0x125/0x140
> [ 1074.544474]  ? process_one_work+0x410/0x410
> [ 1074.544478]  ? kthread_create_on_node+0x70/0x70
> [ 1074.544482]  ? SyS_exit_group+0x14/0x20
> [ 1074.544486]  ret_from_fork+0x25/0x30
> [ 1074.544489] Code: 89 d1 4c 89 da e8 26 ae f4 ff 58 48 8b 45 c0 65 48 33 04 25 28 00 00 00 74 05 e8 81 a8 a0 fa c9 c3 55 48 89 e5 0f 0b 55 48 89 e5 <0f> 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 0f 1f 44 00 00 55 31
> [ 1074.544527] RIP: btrfs_extent_inline_ref_size.part.38+0x4/0x6 [btrfs] RSP: ffff9ab182ecfa98
> [ 1074.546960] ---[ end trace ef4fb892f79e3e86 ]---
> 
> btrfsck wasn't helpful either and failed very quickly:
> 
> Checking filesystem on /dev/mapper/luks-739967f1-9770-470a-a031-8d8b8bcdb350
> UUID: 5170aca4-061a-4c6c-ab00-bd7fc8ae6030
> checking extents
> cmds-check.c:6824: process_extent_item: BUG_ON `item_size != sizeof(*ei0)` triggered, value 1
> btrfs check(+0x4d654)[0x55748d39d654]
> btrfs check(+0x1202f)[0x55748d36202f]
> btrfs check(+0x4d8cf)[0x55748d39d8cf]
> btrfs check(+0x4f1c3)[0x55748d39f1c3]
> btrfs check(+0x52a1c)[0x55748d3a2a1c]
> btrfs check(+0x53265)[0x55748d3a3265]
> btrfs check(+0x53d3d)[0x55748d3a3d3d]
> btrfs check(cmd_check+0x1309)[0x55748d3a6fbc]
> btrfs check(main+0x142)[0x55748d3686e9]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7fccb1f971c1]
> btrfs check(_start+0x2a)[0x55748d36872a]
> 
> Simple ls in the root of the filesystem right after fresh boot and mount resulted in following:
> 
> [  106.573579] ------------[ cut here ]------------
> [  106.573582] kernel BUG at /build/linux-XO_uEE/linux-4.13.0/fs/btrfs/ctree.h:1802!
> [  106.573589] invalid opcode: 0000 [#1] SMP
> [  106.573602] Modules linked in: btrfs xor raid6_pq dm_crypt algif_skcipher af_alg intel_rapl snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm snd_hda_intel snd_usb_audio snd_hda_codec snd_hda_core snd_usbmidi_lib snd_hwdep snd_pcm irqbypass crct10dif_pclmul crc32_pclmul snd_seq_midi ghash_clmulni_intel snd_seq_midi_event pcbc aesni_intel snd_rawmidi snd_seq snd_seq_device cdc_acm snd_timer aes_x86_64 joydev input_leds snd crypto_simd glue_helper soundcore cryptd intel_cstate serio_raw intel_rapl_perf lpc_ich mei_me mei shpchp mac_hid parport_pc ppdev lp parport ip_tables x_tables autofs4 overlay nls_iso8859_1 dm_mirror dm_region_hash dm_log hid_generic usbhid hid uas usb_storage nouveau mxm_wmi video igb ttm drm_kms_helper syscopyarea sysfillrect dca sysimgblt fb_sys_fops
> [  106.573704]  i2c_algo_bit ahci ptp libahci drm pps_core nvme nvme_core wmi
> [  106.573720] CPU: 6 PID: 245 Comm: kworker/u24:4 Not tainted 4.13.0-16-generic #19-Ubuntu
> [  106.573727] Hardware name: MSI MS-7885/X99A SLI Krait Edition (MS-7885), BIOS N.92 01/10/2017
> [  106.573773] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
> [  106.573785] task: ffff92b56227dd00 task.stack: ffffa2fb8237c000
> [  106.573817] RIP: 0010:btrfs_extent_inline_ref_size.part.38+0x4/0x6 [btrfs]
> [  106.573825] RSP: 0018:ffffa2fb8237fa98 EFLAGS: 00010297
> [  106.573831] RAX: 0000000000000000 RBX: 00000000000000b6 RCX: ffffa2fb8237fa50
> [  106.573838] RDX: 0000000000000001 RSI: 00000000000036a6 RDI: 0000000000000000
> [  106.573845] RBP: ffffa2fb8237fa98 R08: 00000000000036a7 R09: ffffa2fb8237fa60
> [  106.573852] R10: 0000000000000000 R11: 0000000000000003 R12: ffff92b52ac96460
> [  106.573858] R13: 0000000000000000 R14: 00000000000036a6 R15: 00000000000036e5
> [  106.573866] FS:  0000000000000000(0000) GS:ffff92b56f380000(0000) knlGS:0000000000000000
> [  106.573873] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  106.573879] CR2: 00007f67cc017028 CR3: 0000000275009000 CR4: 00000000003406e0
> [  106.573886] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  106.573893] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  106.573899] Call Trace:
> [  106.573923]  lookup_inline_extent_backref+0x5a3/0x5b0 [btrfs]
> [  106.573946]  ? setup_inline_extent_backref+0x16e/0x260 [btrfs]
> [  106.573968]  insert_inline_extent_backref+0x50/0xe0 [btrfs]
> [  106.573990]  __btrfs_inc_extent_ref.isra.51+0x7e/0x260 [btrfs]
> [  106.574019]  ? btrfs_merge_delayed_refs+0x62/0x550 [btrfs]
> [  106.574042]  __btrfs_run_delayed_refs+0xc52/0x1380 [btrfs]
> [  106.574052]  ? __slab_free+0x14c/0x2d0
> [  106.574075]  btrfs_run_delayed_refs+0x6b/0x250 [btrfs]
> [  106.574097]  delayed_ref_async_start+0x98/0xb0 [btrfs]
> [  106.574126]  btrfs_worker_helper+0x7a/0x2e0 [btrfs]
> [  106.574151]  btrfs_extent_refs_helper+0xe/0x10 [btrfs]
> [  106.574160]  process_one_work+0x1e7/0x410
> [  106.574167]  worker_thread+0x4a/0x410
> [  106.574174]  kthread+0x125/0x140
> [  106.574181]  ? process_one_work+0x410/0x410
> [  106.574187]  ? kthread_create_on_node+0x70/0x70
> [  106.574195]  ret_from_fork+0x25/0x30
> [  106.574200] Code: 89 d1 4c 89 da e8 26 ae f4 ff 58 48 8b 45 c0 65 48 33 04 25 28 00 00 00 74 05 e8 81 a8 80 c1 c9 c3 55 48 89 e5 0f 0b 55 48 89 e5 <0f> 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 0f 1f 44 00 00 55 31
> [  106.574276] RIP: btrfs_extent_inline_ref_size.part.38+0x4/0x6 [btrfs] RSP: ffffa2fb8237fa98
> [  106.578666] ---[ end trace bd9d2e91fa0ddda7 ]---
> 
> After this kernel was also corrupted and not capable of running the system anymore, so I had to hard reset the system after collecting each piece above.
> 
> Thankfully I'm doing backups each 15 minutes (after initial btrfs experience) and backup partition is fine (I did scrub and btrfsck on it), so I've quickly restored everything, but this is not funny anymore.
> 
> Here are mount options for my primary filesystem (SSD > LUKS > BTRFS) and backup filesystem (HDD > LUKS > GPT > BTRFS):
> 
> compress=lzo,noatime,ssd,subvol=/root
> compress=lzo,noatime,noexec,noauto
> 
> Have anyone noticed anything similar (I'm not subscribed to the mailing list)?
> 

I've experienced the same kind of issue with a similar crash on two
separate machines. One after upgrading from 4.9 to 4.14. And a new one
running 4.15-rc3/rc4.
The kernel locked up. After reboot btrfs would go read-only. I had
success repairing the filesystem with btrfsck (with data loss on some
files). I didn't experience btrfsck crashing, but it was done booting
from an usb pen with a not that recent kernel/btrfs-progs.
Both filesystems are single disk, no fancy features other than compression.
I have high confidence both machines have no hardware issues. One has
been been running 24/7 for a long time prior to the kernel update. And
the other is a new ryzen machine (hence the 4.15 kernel for amdgpu),
that has ECC ram and prior to the set up I did some basic checks on the
hardware. Everything seems to check out.
