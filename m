Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:34805 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3KDXMG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 18:12:06 -0500
Received: by mail-vc0-f182.google.com with SMTP id if17so5143180vcb.13
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 15:12:05 -0800 (PST)
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 4 Nov 2013 15:11:44 -0800
Message-ID: <CALCETrX9M2SFAFHB9AaAm+X-a=XfqJ9ivjy7neoQgHF9UH_dBA@mail.gmail.com>
Subject: OOPS on 3.11.6
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(This is Fedora's kernel 3.11.6-200.fc19.x86_64)

I have a file on my btrfs filesystem.  Reading it results in:

[  170.261789] general protection fault: 0000 [#1] SMP
[  170.261950] Modules linked in: rfcomm fuse xt_CHECKSUM
nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE
ip6t_REJECT tun bnep bluetooth rfkill xt_conntrack ebtable_nat
ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
iptable_mangle iptable_security iptable_raw f71882fg vfat fat
snd_hda_codec_hdmi snd_hda_codec_realtek btrfs zlib_deflate raid6_pq
libcrc32c xor x86_pkg_temp_thermal coretemp kvm_intel iTCO_wdt joydev
kvm iTCO_vendor_support snd_hda_intel mxm_wmi snd_hda_codec snd_hwdep
snd_seq snd_seq_device snd_pcm microcode sb_edac i2c_i801 serio_raw
edac_core e1000e snd_page_alloc
[  170.264416]  ntb snd_timer mei_me snd ptp mei lpc_ich soundcore
shpchp pps_core wmi mfd_core mperf uinput binfmt_misc dm_crypt radeon
hid_logitech_dj crc32_pclmul i2c_algo_bit drm_kms_helper crc32c_intel
ttm ghash_clmulni_intel drm firewire_ohci firewire_core i2c_core
crc_itu_t
[  170.265260] CPU: 0 PID: 2947 Comm: thg Tainted: G        W
3.11.6-200.fc19.x86_64 #1
[  170.265503] Hardware name: MSI MS-7760/X79A-GD65 (8D) (MS-7760),
BIOS V1.8 10/18/2012
[  170.265745] task: ffff88042ee48f40 ti: ffff8803fdb30000 task.ti:
ffff8803fdb30000
[  170.265975] RIP: 0010:[<ffffffff81307d7d>]  [<ffffffff81307d7d>]
memcpy+0xd/0x110
[  170.266209] RSP: 0018:ffff8803fdb31960  EFLAGS: 00010202
[  170.266373] RAX: ffff88040369ede9 RBX: 000000000000006c RCX: 000000000000000d
[  170.266592] RDX: 0000000000000004 RSI: 0005080000000000 RDI: ffff88040369ede9
[  170.266812] RBP: ffff8803fdb31998 R08: 0000000000001000 R09: ffff88040369e000
[  170.267031] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8803eac91390
[  170.267251] R13: 0000160000000000 R14: ffff88040369ee55 R15: 000000000000006c
[  170.267471] FS:  00007f223b42c740(0000) GS:ffff88045fc00000(0000)
knlGS:0000000000000000
[  170.267721] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  170.267898] CR2: 00000000031a1024 CR3: 0000000412d6a000 CR4: 00000000000407f0
[  170.268117] Stack:
[  170.268179]  ffffffffa04bf26c 0000000000001000 ffff8804477de000
0000000000000000
[  170.268424]  ffff88041688a900 ffff8803eaca2210 ffff8803f0fcda18
ffff8803fdb31a58
[  170.268666]  ffffffffa04a4376 0000000000000000 000000000000019d
00000000ffffffff
[  170.268909] Call Trace:
[  170.268994]  [<ffffffffa04bf26c>] ? read_extent_buffer+0xbc/0x110 [btrfs]
[  170.269202]  [<ffffffffa04a4376>] btrfs_get_extent+0x926/0x9b0 [btrfs]
[  170.269403]  [<ffffffffa04bc53e>] __extent_read_full_page+0x2ee/0x700 [btrfs]
[  170.269622]  [<ffffffffa04a3a50>] ? btrfs_submit_direct+0x660/0x660 [btrfs]
[  170.269832]  [<ffffffff81159f53>] ? __inc_zone_page_state+0x33/0x40
[  170.270028]  [<ffffffffa04a3a50>] ? btrfs_submit_direct+0x660/0x660 [btrfs]
[  170.270243]  [<ffffffffa04bd945>] extent_readpages+0x195/0x200 [btrfs]
[  170.270440]  [<ffffffff81183129>] ? alloc_pages_current+0xa9/0x170
[  170.270635]  [<ffffffffa04a136f>] btrfs_readpages+0x1f/0x30 [btrfs]
[  170.270824]  [<ffffffff811484fe>] __do_page_cache_readahead+0x1ae/0x240
[  170.271027]  [<ffffffff811489c6>] ondemand_readahead+0x126/0x250
[  170.271212]  [<ffffffff81148b23>] page_cache_sync_readahead+0x33/0x50
[  170.271410]  [<ffffffff8113da45>] generic_file_aio_read+0x4b5/0x700
[  170.271604]  [<ffffffff811a7ab0>] do_sync_read+0x80/0xb0
[  170.271766]  [<ffffffff811a80de>] vfs_read+0x9e/0x170
[  170.271921]  [<ffffffff811a8c09>] SyS_read+0x49/0xa0
[  170.272074]  [<ffffffff810e6496>] ? __audit_syscall_exit+0x1f6/0x2a0
[  170.272271]  [<ffffffff81656e99>] system_call_fastpath+0x16/0x1b
[  170.272458] Code: 43 4e 5b 5d c3 66 0f 1f 84 00 00 00 00 00 e8 fb
fb ff ff eb e2 90 90 90 90 90 90 90 90 90 48 89 f8 48 89 d1 48 c1 e9
03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56
10 4c
[  170.273297] RIP  [<ffffffff81307d7d>] memcpy+0xd/0x110
[  170.273457]  RSP <ffff8803fdb31960>
[  170.348204] ---[ end trace 7d04a6835a0093fd ]---


This issue has survived a reboot.

(The taint flag is due to a bogus BGRT table in my EFI BIOS.  It's not
corrupting any kernel data structures.)


--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
