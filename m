Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82DDC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 02:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E7D92080F
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 02:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfCZCxQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 22:53:16 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35836 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbfCZCxQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 22:53:16 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 28D4627C903; Mon, 25 Mar 2019 22:50:28 -0400 (EDT)
Date:   Mon, 25 Mar 2019 22:50:28 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: WARNING at fs/btrfs/delayed-ref.c:296
 btrfs_merge_delayed_refs+0x3dc/0x410 (new on 5.0.4, not in 5.0.3)
Message-ID: <20190326025028.GG16651@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Running balance, rsync, and dedupe, I get kernel warnings every few
minutes on 5.0.4.  No warnings on 5.0.3 under similar conditions.

Mount options are:  flushoncommit,space_cache=v2,compress=zstd.

There are two different stacks on the warnings.  This one comes from
btrfs balance:

	[Mon Mar 25 18:22:42 2019] WARNING: CPU: 0 PID: 4786 at fs/btrfs/delayed-ref.c:296 btrfs_merge_delayed_refs+0x3dc/0x410
	[Mon Mar 25 18:22:42 2019] Modules linked in: ppdev joydev crct10dif_pclmul crc32_pclmul dm_cache_smq crc32c_intel ghash_clmulni_intel dm_cache dm_persistent_data dm_bio_prison dm_bufio dm_mod rtc_cmos floppy parport_pc parport aesni_intel sr_mod cdrom aes_x86_64 crypto_simd cryptd glue_helper sg ide_pci_generic piix ide_core evbug evdev bochs_drm i2c_piix4 input_leds psmouse serio_raw snd_pcm snd_timer snd soundcore pcspkr qemu_fw_cfg ip_tables x_tables ipv6 crc_ccitt autofs4
	[Mon Mar 25 18:22:42 2019] CPU: 0 PID: 4786 Comm: btrfs-balance Tainted: G        W         5.0.4-zb64-303ce93b05c9+ #1
	[Mon Mar 25 18:22:42 2019] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	[Mon Mar 25 18:22:42 2019] RIP: 0010:btrfs_merge_delayed_refs+0x3dc/0x410
	[Mon Mar 25 18:22:42 2019] Code: 7c 24 28 be ff ff ff ff e8 31 a0 c1 ff 85 c0 0f 85 7c fe ff ff 0f 0b e9 75 fe ff ff 0f 0b e9 0a fe ff ff 0f 0b e9 1b fe ff ff <0f> 0b e9 25 ff ff ff 0f 0b e9 b0 fe ff ff 48 c7 44 24 10 00 00 00
	[Mon Mar 25 18:22:42 2019] RSP: 0018:ffffabb981377b70 EFLAGS: 00010246
	[Mon Mar 25 18:22:42 2019] RAX: 00000000000000b6 RBX: 00000000ffffffff RCX: 0000000000000001
	[Mon Mar 25 18:22:42 2019] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000282
	[Mon Mar 25 18:22:42 2019] RBP: ffff9392514bbb80 R08: ffff9392514bbc80 R09: 0000000000000000
	[Mon Mar 25 18:22:42 2019] R10: 0000000000000000 R11: 0000000000000001 R12: ffff93928a5c8f08
	[Mon Mar 25 18:22:42 2019] R13: ffff939269744e38 R14: ffff939269744e38 R15: ffff9392697449c0
	[Mon Mar 25 18:22:42 2019] FS:  0000000000000000(0000) GS:ffff939475c00000(0000) knlGS:0000000000000000
	[Mon Mar 25 18:22:42 2019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[Mon Mar 25 18:22:42 2019] CR2: 00007f0882d38600 CR3: 0000000230eb6002 CR4: 00000000001606f0
	[Mon Mar 25 18:22:42 2019] Call Trace:
	[Mon Mar 25 18:22:42 2019]  __btrfs_run_delayed_refs+0x70/0x170
	[Mon Mar 25 18:22:42 2019]  btrfs_run_delayed_refs+0x7d/0x1d0
	[Mon Mar 25 18:22:42 2019]  btrfs_commit_transaction+0x50/0x9e0
	[Mon Mar 25 18:22:42 2019]  ? start_transaction+0x91/0x4d0
	[Mon Mar 25 18:22:42 2019]  relocate_block_group+0x1bd/0x600
	[Mon Mar 25 18:22:42 2019]  btrfs_relocate_block_group+0x15b/0x260
	[Mon Mar 25 18:22:42 2019]  btrfs_relocate_chunk+0x46/0xf0
	[Mon Mar 25 18:22:42 2019]  btrfs_balance+0xa60/0x12b0
	[Mon Mar 25 18:22:42 2019]  balance_kthread+0x36/0x50
	[Mon Mar 25 18:22:42 2019]  kthread+0x106/0x140
	[Mon Mar 25 18:22:42 2019]  ? btrfs_balance+0x12b0/0x12b0
	[Mon Mar 25 18:22:42 2019]  ? kthread_park+0x90/0x90
	[Mon Mar 25 18:22:42 2019]  ret_from_fork+0x3a/0x50
	[Mon Mar 25 18:22:42 2019] irq event stamp: 81529004
	[Mon Mar 25 18:22:42 2019] hardirqs last  enabled at (81529003): [<ffffffffaa2be2b7>] kmem_cache_free+0x67/0x1e0
	[Mon Mar 25 18:22:42 2019] hardirqs last disabled at (81529004): [<ffffffffaa00379f>] trace_hardirqs_off_thunk+0x1a/0x1c
	[Mon Mar 25 18:22:42 2019] softirqs last  enabled at (81527500): [<ffffffffab0003a4>] __do_softirq+0x3a4/0x45f
	[Mon Mar 25 18:22:42 2019] softirqs last disabled at (81527493): [<ffffffffaa0a3d24>] irq_exit+0xe4/0xf0
	[Mon Mar 25 18:22:42 2019] ---[ end trace 3d8cdfff7444099a ]---

This one comes from btrfs-transaction:

	[Mon Mar 25 18:27:58 2019] WARNING: CPU: 3 PID: 4137 at fs/btrfs/delayed-ref.c:296 btrfs_merge_delayed_refs+0x3dc/0x410
	[Mon Mar 25 18:27:58 2019] Modules linked in: ppdev joydev crct10dif_pclmul crc32_pclmul dm_cache_smq crc32c_intel ghash_clmulni_intel dm_cache dm_persistent_data dm_bio_prison dm_bufio dm_mod rtc_cmos floppy parport_pc parport aesni_intel sr_mod cdrom aes_x86_64 crypto_simd cryptd glue_helper sg ide_pci_generic piix ide_core evbug evdev bochs_drm i2c_piix4 input_leds psmouse serio_raw snd_pcm snd_timer snd soundcore pcspkr qemu_fw_cfg ip_tables x_tables ipv6 crc_ccitt autofs4
	[Mon Mar 25 18:27:58 2019] CPU: 3 PID: 4137 Comm: btrfs-transacti Tainted: G        W         5.0.4-zb64-303ce93b05c9+ #1
	[Mon Mar 25 18:27:58 2019] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	[Mon Mar 25 18:27:58 2019] RIP: 0010:btrfs_merge_delayed_refs+0x3dc/0x410
	[Mon Mar 25 18:27:58 2019] Code: 7c 24 28 be ff ff ff ff e8 31 a0 c1 ff 85 c0 0f 85 7c fe ff ff 0f 0b e9 75 fe ff ff 0f 0b e9 0a fe ff ff 0f 0b e9 1b fe ff ff <0f> 0b e9 25 ff ff ff 0f 0b e9 b0 fe ff ff 48 c7 44 24 10 00 00 00
	[Mon Mar 25 18:27:58 2019] RSP: 0018:ffffabb9812f7d40 EFLAGS: 00010246
	[Mon Mar 25 18:27:58 2019] RAX: 00000000000000b6 RBX: 00000000ffffffff RCX: 0000000000000001
	[Mon Mar 25 18:27:58 2019] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000286
	[Mon Mar 25 18:27:58 2019] RBP: ffff93925b187ce0 R08: ffff93925b187de0 R09: 0000000000000000
	[Mon Mar 25 18:27:58 2019] R10: 0000000000000000 R11: 0000000000000001 R12: ffff93938b59d308
	[Mon Mar 25 18:27:58 2019] R13: ffff9393a5d09820 R14: ffff9393a5d09820 R15: ffff939261978820
	[Mon Mar 25 18:27:58 2019] FS:  0000000000000000(0000) GS:ffff939476800000(0000) knlGS:0000000000000000
	[Mon Mar 25 18:27:58 2019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[Mon Mar 25 18:27:58 2019] CR2: 00007f91f6321c50 CR3: 00000001ef54e003 CR4: 00000000001606e0
	[Mon Mar 25 18:27:58 2019] Call Trace:
	[Mon Mar 25 18:27:58 2019]  __btrfs_run_delayed_refs+0x70/0x170
	[Mon Mar 25 18:27:58 2019]  btrfs_run_delayed_refs+0x7d/0x1d0
	[Mon Mar 25 18:27:58 2019]  btrfs_commit_transaction+0x50/0x9e0
	[Mon Mar 25 18:27:58 2019]  ? start_transaction+0x91/0x4d0
	[Mon Mar 25 18:27:58 2019]  transaction_kthread+0x146/0x180
	[Mon Mar 25 18:27:58 2019]  kthread+0x106/0x140
	[Mon Mar 25 18:27:58 2019]  ? btrfs_cleanup_transaction+0x620/0x620
	[Mon Mar 25 18:27:58 2019]  ? kthread_park+0x90/0x90
	[Mon Mar 25 18:27:58 2019]  ret_from_fork+0x3a/0x50
	[Mon Mar 25 18:27:58 2019] irq event stamp: 81665152
	[Mon Mar 25 18:27:58 2019] hardirqs last  enabled at (81665151): [<ffffffffaa2be2b7>] kmem_cache_free+0x67/0x1e0
	[Mon Mar 25 18:27:58 2019] hardirqs last disabled at (81665152): [<ffffffffaa00379f>] trace_hardirqs_off_thunk+0x1a/0x1c
	[Mon Mar 25 18:27:58 2019] softirqs last  enabled at (81664580): [<ffffffffab0003a4>] __do_softirq+0x3a4/0x45f
	[Mon Mar 25 18:27:58 2019] softirqs last disabled at (81664565): [<ffffffffaa0a3d24>] irq_exit+0xe4/0xf0
	[Mon Mar 25 18:27:58 2019] ---[ end trace 3d8cdfff7444099c ]---

Sometimes they both happen at the same time, and the stack trace is a
confusing jumble!  I didn't know Linux kernel stack traces could do this:

	Mar 25 14:46:52 [24240.160913] WARNING: CPU: 3 PID: 4214 at fs/btrfs/delayed-ref.c:296 btrfs_merge_delayed_refs+0x3dc/0x410
	Mar 25 14:46:52 [24240.161158] WARNING: CPU: 0 PID: 4254 at fs/btrfs/delayed-ref.c:296 btrfs_merge_delayed_refs+0x3dc/0x410
	Mar 25 14:46:52 [24240.167509] Modules linked in: bochs_drm dm_cache_smq joydev dm_cache dm_persistent_data dm_bio_prison dm_bufio dm_mod ppdev crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 crypto_simd cryptd glue_helper sr_mod cdrom sg ide_pci_generic piix i2c_piix4 ide_core input_leds psmouse rtc_cmos floppy pcc_cpufreq snd_pcm serio_raw parport_pc parport evbug evdev snd_timer snd soundcore pcspkr qemu_fw_cfg ip_tables x_tables ipv6 crc_ccitt autofs4
	Mar 25 14:46:52 [24240.169564] Modules linked in: bochs_drm dm_cache_smq joydev dm_cache dm_persistent_data dm_bio_prison dm_bufio dm_mod ppdev crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 crypto_simd cryptd glue_helper sr_mod cdrom sg ide_pci_generic piix i2c_piix4 ide_core input_leds psmouse rtc_cmos floppy pcc_cpufreq snd_pcm serio_raw parport_pc parport evbug evdev snd_timer snd soundcore pcspkr qemu_fw_cfg ip_tables x_tables ipv6 crc_ccitt autofs4
	Mar 25 14:46:52 [24240.179818] CPU: 3 PID: 4214 Comm: btrfs-transacti Tainted: G        W         5.0.4-zb64-2b44cea8b720+ #1
	Mar 25 14:46:52 [24240.179820] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	Mar 25 14:46:52 [24240.188662] CPU: 0 PID: 4254 Comm: btrfs-balance Tainted: G        W         5.0.4-zb64-2b44cea8b720+ #1
	Mar 25 14:46:52 [24240.190711] RIP: 0010:btrfs_merge_delayed_refs+0x3dc/0x410
	Mar 25 14:46:52 [24240.192571] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
	Mar 25 14:46:52 [24240.192576] RIP: 0010:btrfs_merge_delayed_refs+0x3dc/0x410
	Mar 25 14:46:52 [24240.194563] Code: 7c 24 28 be ff ff ff ff e8 31 a0 c1 ff 85 c0 0f 85 7c fe ff ff 0f 0b e9 75 fe ff ff 0f 0b e9 0a fe ff ff 0f 0b e9 1b fe ff ff <0f> 0b e9 25 ff ff ff 0f 0b e9 b0 fe ff ff 48 c7 44 24 10 00 00 00
	Mar 25 14:46:52 [24240.195747] Code: 7c 24 28 be ff ff ff ff e8 31 a0 c1 ff 85 c0 0f 85 7c fe ff ff 0f 0b e9 75 fe ff ff 0f 0b e9 0a fe ff ff 0f 0b e9 1b fe ff ff <0f> 0b e9 25 ff ff ff 0f 0b e9 b0 fe ff ff 48 c7 44 24 10 00 00 00
	Mar 25 14:46:52 [24240.195749] RSP: 0000:ffffb1ad0121bb70 EFLAGS: 00010246
	Mar 25 14:46:52 [24240.197511] RSP: 0000:ffffb1ad0122bd40 EFLAGS: 00010246
	Mar 25 14:46:52 [24240.198686] RAX: 00000000000000b6 RBX: 00000000ffffffff RCX: 0000000000000001
	Mar 25 14:46:52 [24240.198689] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000282
	Mar 25 14:46:52 [24240.202841] RAX: 00000000000000b6 RBX: 00000000ffffffff RCX: 0000000000000001
	Mar 25 14:46:52 [24240.206920] RBP: ffff9a015e0b6460 R08: ffff9a015e0b6560 R09: 0000000000000000
	Mar 25 14:46:52 [24240.206922] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9a01967a2308
	Mar 25 14:46:52 [24240.208040] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000286
	Mar 25 14:46:52 [24240.209158] R13: ffff9a0025aab208 R14: ffff9a0025aab208 R15: ffff99ffc8d8b7b8
	Mar 25 14:46:52 [24240.209160] FS:  0000000000000000(0000) GS:ffff9a01f5c00000(0000) knlGS:0000000000000000
	Mar 25 14:46:52 [24240.210671] RBP: ffff9a00f01841e0 R08: ffff9a00f01842e0 R09: 0000000000000000
	Mar 25 14:46:52 [24240.212191] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	Mar 25 14:46:52 [24240.212193] CR2: 000055c2d6202280 CR3: 0000000185eae001 CR4: 00000000001606f0
	Mar 25 14:46:52 [24240.213833] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9a01967a2308
	Mar 25 14:46:52 [24240.215309] Call Trace:
	Mar 25 14:46:52 [24240.216762] R13: ffff99ffe4f9f208 R14: ffff99ffe4f9f208 R15: ffff9a01ea9441a0
	Mar 25 14:46:52 [24240.216764] FS:  0000000000000000(0000) GS:ffff9a01f6800000(0000) knlGS:0000000000000000
	Mar 25 14:46:52 [24240.218283]  __btrfs_run_delayed_refs+0x70/0x170
	Mar 25 14:46:52 [24240.219755] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	Mar 25 14:46:52 [24240.219757] CR2: 000055e5c552f988 CR3: 00000001fcb3a002 CR4: 00000000001606e0
	Mar 25 14:46:52 [24240.221535]  btrfs_run_delayed_refs+0x7d/0x1d0
	Mar 25 14:46:52 [24240.223014] Call Trace:
	Mar 25 14:46:52 [24240.224251]  btrfs_commit_transaction+0x50/0x9e0
	Mar 25 14:46:52 [24240.225887]  __btrfs_run_delayed_refs+0x70/0x170
	Mar 25 14:46:52 [24240.227403]  ? start_transaction+0x91/0x4d0
	Mar 25 14:46:52 [24240.227921]  btrfs_run_delayed_refs+0x7d/0x1d0
	Mar 25 14:46:52 [24240.229688]  relocate_block_group+0x1bd/0x600
	Mar 25 14:46:52 [24240.229702]  btrfs_relocate_block_group+0x15b/0x260
	Mar 25 14:46:52 [24240.229710]  btrfs_relocate_chunk+0x46/0xf0
	Mar 25 14:46:52 [24240.229716]  btrfs_balance+0xa60/0x12b0
	Mar 25 14:46:52 [24240.231375]  btrfs_commit_transaction+0x50/0x9e0
	Mar 25 14:46:52 [24240.232353]  balance_kthread+0x36/0x50
	Mar 25 14:46:52 [24240.233507]  ? start_transaction+0x91/0x4d0
	Mar 25 14:46:52 [24240.235001]  kthread+0x106/0x140
	Mar 25 14:46:52 [24240.235953]  transaction_kthread+0x146/0x180
	Mar 25 14:46:52 [24240.236485]  ? btrfs_balance+0x12b0/0x12b0
	Mar 25 14:46:52 [24240.237497]  kthread+0x106/0x140
	Mar 25 14:46:52 [24240.238526]  ? kthread_park+0x90/0x90
	Mar 25 14:46:52 [24240.239455]  ? btrfs_cleanup_transaction+0x620/0x620
	Mar 25 14:46:52 [24240.240455]  ret_from_fork+0x3a/0x50
	Mar 25 14:46:52 [24240.241413]  ? kthread_park+0x90/0x90
	Mar 25 14:46:52 [24240.242511] irq event stamp: 2299215120
	Mar 25 14:46:52 [24240.243436]  ret_from_fork+0x3a/0x50
	Mar 25 14:46:52 [24240.244286] hardirqs last  enabled at (2299215119): [<ffffffffbc2be2b7>] kmem_cache_free+0x67/0x1e0
	Mar 25 14:46:52 [24240.244291] hardirqs last disabled at (2299215120): [<ffffffffbc00379f>] trace_hardirqs_off_thunk+0x1a/0x1c
	Mar 25 14:46:52 [24240.245320] irq event stamp: 1574357192
	Mar 25 14:46:52 [24240.246152] softirqs last  enabled at (2299214848): [<ffffffffbd0003a4>] __do_softirq+0x3a4/0x45f
	Mar 25 14:46:52 [24240.246157] softirqs last disabled at (2299214665): [<ffffffffbc0a3d24>] irq_exit+0xe4/0xf0
	Mar 25 14:46:52 [24240.247088] hardirqs last  enabled at (1574357191): [<ffffffffbc2be2b7>] kmem_cache_free+0x67/0x1e0
	Mar 25 14:46:52 [24240.247091] hardirqs last disabled at (1574357192): [<ffffffffbc00379f>] trace_hardirqs_off_thunk+0x1a/0x1c
	Mar 25 14:46:52 [24240.247806] ---[ end trace c0ec186e7aead1da ]---
	Mar 25 14:46:52 [24240.248719] softirqs last  enabled at (1574357050): [<ffffffffbd0003a4>] __do_softirq+0x3a4/0x45f
	Mar 25 14:46:52 [24240.248723] softirqs last disabled at (1574356895): [<ffffffffbc0a3d24>] irq_exit+0xe4/0xf0
	Mar 25 14:46:52 [24240.249728] WARNING: CPU: 0 PID: 4254 at fs/btrfs/delayed-ref.c:296 btrfs_merge_delayed_refs+0x3dc/0x410
	Mar 25 14:46:52 [24240.250325] ---[ end trace c0ec186e7aead1db ]---

Pausing the balance makes the warnings stop.

Mounting with noflushoncommit looks like it might also stop the warnings,
but I haven't let it run long enough to be sure.
