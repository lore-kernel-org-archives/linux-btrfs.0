Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:33121 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753810AbcHXT2s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 15:28:48 -0400
Received: by mail-lf0-f51.google.com with SMTP id b199so19237586lfe.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Aug 2016 12:27:18 -0700 (PDT)
MIME-Version: 1.0
From: Sverd Johnsen <sverd.johnsen@googlemail.com>
Date: Wed, 24 Aug 2016 21:27:16 +0200
Message-ID: <CAGmahrRYDVaJ3eGLZhe=fEtbE_5fx51hxX3KuUxK3i8Kt=3Wxw@mail.gmail.com>
Subject: kernel BUG at fs/btrfs/delayed-inode.c:1579!
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=153891

[  879.935385] ------------[ cut here ]------------
[  879.935400] kernel BUG at fs/btrfs/delayed-inode.c:1579!
[  879.935414] invalid opcode: 0000 [#1] PREEMPT SMP
[  879.935425] Modules linked in: veth binfmt_misc nft_reject_inet
nf_reject_ipv4 nf_reject_ipv6 nft_reject nf_log_ipv6 nf_log_ipv4
nf_log_common nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4
nf_defrag_ipv4 nft_ct nf_conntrack nft_log nft_counter nft_meta
nft_hash nft_rbtree nf_tables_inet nf_tables_ipv6 nf_tables_ipv4
nf_tables nfnetlink algif_skcipher af_alg af_packet bridge hid_generic
usbhid hid ghash_clmulni_intel stp intel_cstate llc intel_uncore
psmouse intel_rapl_perf efi_pstore efivarfs snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal
intel_powerclamp atkbd libps2 kvm_intel kvm irqbypass crct10dif_pclmul
crc32_pclmul crc32c_intel aesni_intel aes_x86_64 glue_helper lrw
gf128mul ablk_helper cryptd efivars snd_hda_intel snd_hda_codec
snd_hda_core snd_pcm
[  879.935636]  snd_timer i915 shpchp sd_mod xhci_pci xhci_hcd usbcore
mei_me mei usb_common intel_gtt fan thermal battery i8042 serio
pinctrl_sunrisepoint pinctrl_intel acpi_pad tpm_infineon tpm_tis tpm
[  879.935694] CPU: 2 PID: 3125 Comm: CJobMgr::m_Work Tainted: G
 W       4.7.2-1-ph #1
[  879.935713] Hardware name: Gigabyte Technology Co., Ltd.
Z170X-UD3/Z170X-UD3-CF, BIOS F6 03/01/2016
[  879.935733] task: ffff88045cae9a80 ti: ffff880070910000 task.ti:
ffff880070910000
[  879.935750] RIP: 0010:[<ffffffffa5276355>]  [<ffffffffa5276355>]
btrfs_delete_delayed_dir_index+0x215/0x220
[  879.935775] RSP: 0018:ffff880070913d48  EFLAGS: 00010246
[  879.935787] RAX: 0000000000000000 RBX: ffff880461fc6180 RCX: 0000000000000000
[  879.935804] RDX: 0000000000000000 RSI: ffff880475d0c9e8 RDI: ffff880475d0c9e8
[  879.935820] RBP: ffff8803ef4de4c0 R08: 0000000000000533 R09: 0000000000000005
[  879.935842] R10: 0000000000000000 R11: ffffffffa597e28d R12: ffff8803ef4de508
[  879.935858] R13: 0000000000000f18 R14: ffff880463326000 R15: ffff880458ebac78
[  879.935874] FS:  0000000000000000(0000) GS:ffff880475d00000(0063)
knlGS:00000000ed7ffb40
[  879.935893] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  879.935906] CR2: 00007f0bfe6b7000 CR3: 00000003fd5ae000 CR4: 00000000003406e0
[  879.935922] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  879.935938] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  879.935955] Stack:
[  879.935961]  0000000000040000 42ffffffa5275611 60000000000013d4
0000000000000f18
[  879.935981]  00000000cfbff096 ffff8803f16ac788 ffff880070913e20
ffff8804601a01f0
[  879.936001]  000000000013d6da 000000000013d442 ffff880458ed3000
ffffffffa5224fbe
[  879.936021] Call Trace:
[  879.936030]  [<ffffffffa5224fbe>] ? __btrfs_unlink_inode+0x1ae/0x470
[  879.936045]  [<ffffffffa5228be2>] ? btrfs_unlink_inode+0x12/0x40
[  879.936060]  [<ffffffffa5228c71>] ? btrfs_unlink+0x61/0xb0
[  879.936074]  [<ffffffffa5139c0d>] ? vfs_unlink+0xed/0x180
[  879.936087]  [<ffffffffa513f195>] ? do_unlinkat+0x295/0x310
[  879.936101]  [<ffffffffa500277d>] ? do_fast_syscall_32+0x8d/0x150
[  879.936116]  [<ffffffffa55d1d7c>] ? entry_SYSENTER_compat+0x4c/0x5b
[  879.936130] Code: ff 0f 0b 48 8b 55 10 41 89 c1 49 8b be f0 01 00
00 48 c7 c6 78 5b 73 a5 4c 8b 45 00 48 8b 8a 48 03 00 00 4c 89 ea e8
eb 84 f7 ff <0f> 0b e8 e4 0b dd ff 0f 1f 40 00 53 48 89 fb e8 e7 e1 ff
ff 48
[  879.936234] RIP  [<ffffffffa5276355>]
btrfs_delete_delayed_dir_index+0x215/0x220
[  879.936253]  RSP <ffff880070913d48>
[  879.939739] ---[ end trace b01dc7191bc4c300 ]---
