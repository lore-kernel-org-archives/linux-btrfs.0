Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:47447 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab3KTUXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 15:23:17 -0500
Received: by mail-bk0-f41.google.com with SMTP id v15so8746bkz.14
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 12:23:16 -0800 (PST)
Received: from linux-suse.hu (5401C5A6.dsl.pool.telekom.hu. [84.1.197.166])
        by mx.google.com with ESMTPSA id w9sm24620113bkn.12.2013.11.20.12.23.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2013 12:23:15 -0800 (PST)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Kernel panic at (among others): free-space-cache.c:1179
Date: Wed, 20 Nov 2013 21:22:55 +0100
Message-ID: <2488362.jL0k9zUXb2@linux-suse.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list members,

When the kernel had paniced because of the key_search_validate() defrag bug, 
on the next restart it started to recreate its space- and inode caches. Both 
were finished in 5 minutes but when I tried to enter back to "init 3", the 
kernel paniced and hung up again.

Versions:
- OS: openSUSE 13.1
- Kernel: Linux linux-suse.hu 3.12.0-6.ge7c00d8-desktop #1 SMP PREEMPT Tue Nov 
12 13:09:24 UTC 2013 (e7c00d8) x86_64 x86_64 x86_64 GNU/Linux
- Mount parameters: compress=lzo,space_cache,inode_cache,noatime

Details (look at the timestamps, also):
[  118.916686] BTRFS error (device sda7): block group 191155404800 has wrong 
amount of free space
[  118.916689] BTRFS error (device sda7): failed to load free space cache for 
block group 191155404800
[  119.918977] r8169 0000:06:00.0 eth0: link up
[  119.918985] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  125.812329] BTRFS error (device sda7): block group 216925208576 has wrong 
amount of free space
[  125.812334] BTRFS error (device sda7): failed to load free space cache for 
block group 216925208576
[  151.923717] nf_conntrack: automatic helper assignment is deprecated and it 
will be removed soon. Use the iptables CT target to attach helpers instead.
[  158.606316] BTRFS error (device sda7): block group 189007921152 has wrong 
amount of free space
[  158.606321] BTRFS error (device sda7): failed to load free space cache for 
block group 189007921152
[  256.812050] BTRFS error (device sda7): block group 157869408256 has wrong 
amount of free space
[  256.812054] BTRFS error (device sda7): failed to load free space cache for 
block group 157869408256
[  436.042090] systemd-journald[350]: Received request to flush runtime journal 
from PID 1
[  436.046824] ------------[ cut here ]------------
[  436.046857] WARNING: CPU: 5 PID: 5297 at 
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.12.0/linux-3.12/fs/btrfs/free-
space-cache.c:1179 tree_insert_offset+0xbc/0xd0 [btrfs]()
[  436.046859] Modules linked in: xt_tcpudp xt_pkttype xt_LOG xt_limit 
af_packet ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT 
iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns 
nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack 
ip6table_filter ip6_tables fuse nvidia(PO) snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm iTCO_wdt 
snd_seq gpio_ich iTCO_vendor_support lpc_ich snd_timer snd_seq_device coretemp 
mxm_wmi sr_mod usb_storage kvm_intel kvm pcspkr serio_raw snd mfd_core cdrom 
i2c_i801 r8169 mii drm soundcore i7core_edac acpi_cpufreq edac_core 
snd_page_alloc wmi shpchp button sg nf_conntrack ip_tables x_tables dm_mod 
autofs4 btrfs raid6_pq xor libcrc32c crc32c_intel hid_logitech_dj processor 
thermal_sys
[  436.046886]  scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua scsi_dh 
ata_generic ata_piix
[  436.046892] CPU: 5 PID: 5297 Comm: plymouthd Tainted: P           O 
3.12.0-6.ge7c00d8-desktop #1
[  436.046894] Hardware name: MSI MS-7522/MSI X58 Pro-E (MS-7522), BIOS V8.15 
03/19/2011
[  436.046896]  0000000000000009 ffffffff815bd494 0000000000000000 ffffffff810521d2
[  436.046899]  ffff8802926be2a0 ffff8802aada9540 ffff8802926be2a0 ffff8800371ac150
[  436.046902]  0000000000008000 ffffffffa01d000c ffffffffa01d0519 0000000000000582
[  436.046905] Call Trace:
[  436.046918]  [<ffffffff81004a28>] dump_trace+0x88/0x310
[  436.046927]  [<ffffffff81004d80>] show_stack_log_lvl+0xd0/0x1d0
[  436.046934]  [<ffffffff810061cc>] show_stack+0x1c/0x50
[  436.046941]  [<ffffffff815bd494>] dump_stack+0x50/0x89
[  436.046951]  [<ffffffff810521d2>] warn_slowpath_common+0x72/0x90
[  436.046977]  [<ffffffffa01d000c>] tree_insert_offset+0xbc/0xd0 [btrfs]
[  436.047132]  [<ffffffffa01d0519>] link_free_space+0x29/0x60 [btrfs]
[  436.047229]  [<ffffffffa01d21bb>] __btrfs_add_free_space+0x1db/0x430 [btrfs]
[  436.047356]  [<ffffffffa019d079>] btrfs_evict_inode+0x339/0x370 [btrfs]
[  436.047406]  [<ffffffff811a5f57>] evict+0xa7/0x1a0
[  436.047414]  [<ffffffff8119c45b>] do_unlinkat+0x19b/0x250
[  436.047423]  [<ffffffff815cb03d>] system_call_fastpath+0x1a/0x1f
[  436.047430]  [<00007f64a66d81b7>] 0x7f64a66d81b6
[  436.047432] ---[ end trace c339ba3ff12c6258 ]---
[  436.047434] btrfs: unable to add free space :-17
[  436.047436] BTRFS assertion failed: ret != -EEXIST, file: 
/home/abuild/rpmbuild/BUILD/kernel-desktop-3.12.0/linux-3.12/fs/btrfs/free-
space-cache.c, line: 1902
[  436.047453] ------------[ cut here ]------------
[  436.047646] kernel BUG at /home/abuild/rpmbuild/BUILD/kernel-
desktop-3.12.0/linux-3.12/fs/btrfs/ctree.h:3832!
[  436.047843] invalid opcode: 0000 [#1] PREEMPT SMP 
[  436.048113] Modules linked in: xt_tcpudp xt_pkttype xt_LOG xt_limit 
af_packet ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT 
iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns 
nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack 
ip6table_filter ip6_tables fuse nvidia(PO) snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm iTCO_wdt 
snd_seq gpio_ich iTCO_vendor_support lpc_ich snd_timer snd_seq_device coretemp 
mxm_wmi sr_mod usb_storage kvm_intel kvm pcspkr serio_raw snd mfd_core cdrom 
i2c_i801 r8169 mii drm soundcore i7core_edac acpi_cpufreq edac_core 
snd_page_alloc wmi shpchp button sg nf_conntrack ip_tables x_tables dm_mod 
autofs4 btrfs raid6_pq xor libcrc32c crc32c_intel hid_logitech_dj processor 
thermal_sys
[  436.051328]  scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua scsi_dh 
ata_generic ata_piix
[  436.051716] CPU: 5 PID: 5297 Comm: plymouthd Tainted: P        W  O 
3.12.0-6.ge7c00d8-desktop #1
[  436.051873] Hardware name: MSI MS-7522/MSI X58 Pro-E (MS-7522), BIOS V8.15 
03/19/2011
[  436.052026] task: ffff8802964d81c0 ti: ffff880296bd6000 task.ti: ffff880296bd6000
[  436.052179] RIP: 0010:[<ffffffffa01d003a>]  [<ffffffffa01d003a>] 
assfail.constprop.35+0x1a/0x20 [btrfs]
[  436.052383] RSP: 0018:ffff880296bd7de0  EFLAGS: 00010286
[  436.052480] RAX: 0000000000000092 RBX: 00000000ffffffef RCX: 0000000000008c8b
[  436.052579] RDX: 0000000000008c8b RSI: 0000000000000046 RDI: 
0000000000000246
[  436.052678] RBP: 0000000000000001 R08: 000000000000000a R09: 
00000000000003ff
[  436.052778] R10: 0000000000000000 R11: ffff880296bd7bae R12: ffff8802926be2a0
[  436.052877] R13: ffff8800371ac150 R14: 0000000000008000 R15: ffff8802aada9540
[  436.052977] FS:  00007f64a6fb3700(0000) GS:ffff8802bfca0000(0000) 
knlGS:0000000000000000
[  436.053131] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  436.053228] CR2: 0000000001f18b10 CR3: 0000000291a7a000 CR4: 
00000000000007e0
[  436.053328] Stack:
[  436.053418]  ffffffffa01d2408 00000000ffffffff ffff8802857df9f0 00000000ffffffff
[  436.053705]  ffffffffa0193ef1 0000000000000286 ffff8802857df9f0 ffff8800bb2b0638
[  436.053991]  ffff8802aadcc000 ffff8800371ac150 0000000000008000 ffff8802ae220440
[  436.054278] Call Trace:
[  436.054439]  [<ffffffffa01d2408>] __btrfs_add_free_space+0x428/0x430 [btrfs]
[  436.054608]  [<ffffffffa019d079>] btrfs_evict_inode+0x339/0x370 [btrfs]
[  436.054741]  [<ffffffff811a5f57>] evict+0xa7/0x1a0
[  436.054840]  [<ffffffff8119c45b>] do_unlinkat+0x19b/0x250
[  436.054940]  [<ffffffff815cb03d>] system_call_fastpath+0x1a/0x1f
[  436.055041]  [<00007f64a66d81b7>] 0x7f64a66d81b6
[  436.055135] Code: df 05 00 01 b8 ef ff ff ff c3 0f 1f 80 00 00 00 00 89 f1 48 
c7 c2 70 c5 20 a0 48 89 fe 31 c0 48 c7 c7 d0 c5 20 a0 e8 da 86 3e e1 <0f> 0b 
0f 1f 40 00 41 55 49 89 f5 41 54 55 48 89 d5 53 48 89 fb 
[  436.057622] RIP  [<ffffffffa01d003a>] assfail.constprop.35+0x1a/0x20 [btrfs]
[  436.057763]  RSP <ffff880296bd7de0>
[  436.057891] ---[ end trace c339ba3ff12c6259 ]---
[  532.980046] SFW2-INext-ACC-TCP IN=eth0 OUT= 
MAC=40:61:86:2b:92:ba:6c:e9:07:8c:16:df:08:00 SRC=192.168.1.66 
DST=192.168.1.110 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=55213 DF PROTO=TCP 
SPT=64245 DPT=22 WINDOW=14600 RES=0x00 SYN URGP=0 OPT 
(020405B40402080A004955650000000001030306) 
[  577.836368] SysRq : Show Blocked State
[  577.836451]   task                        PC stack   pid father
[  577.836525] btrfs-transacti D ffff8802bfc13800     0   307      2 0x00000000
[  577.836644]  ffff8802aadc5e08 0000000000000046 0000000000013800 
ffff8802aadc5fd8
[  577.836837]  ffff8802aadc5fd8 0000000000013800 ffff8802abeea080 ffff8800b215bea8
[  577.837079]  ffff880037a431e8 0000000000000000 0000000000000000 
ffff8802857df8b0
[  577.837268] Call Trace:
[  577.837347]  [<ffffffffa0191aaf>] wait_current_trans.isra.17+0xaf/0x110 [btrfs]
[  577.837455]  [<ffffffffa0193198>] start_transaction+0x268/0x520 [btrfs]
[  577.837558]  [<ffffffffa0189f14>] transaction_kthread+0x144/0x210 [btrfs]
[  577.837643]  [<ffffffff8107355f>] kthread+0xaf/0xc0
[  577.837694]  [<ffffffff815caf8c>] ret_from_fork+0x7c/0xb0
[  577.837745] systemd-journal D ffff8802bfcb3800     0   350      1 0x00000000
[  577.837864]  ffff8802af927b98 0000000000000086 0000000000013800 
ffff8802af927fd8
[  577.838115]  ffff8802af927fd8 0000000000013800 ffff8802abfda380 ffff8800b215bea8
[  577.838303]  ffff8802aadcc1e8 0000000000000001 0000000000000000 
ffff8800a9ea5bd0
[  577.838491] Call Trace:
[  577.838551]  [<ffffffffa0191aaf>] wait_current_trans.isra.17+0xaf/0x110 [btrfs]
[  577.838760]  [<ffffffffa0193198>] start_transaction+0x268/0x520 [btrfs]
[  577.838920]  [<ffffffffa01989a8>] btrfs_dirty_inode+0x38/0xd0 [btrfs]
[  577.839142]  [<ffffffff811a5c30>] file_update_time+0x80/0xd0
[  577.839263]  [<ffffffffa01a1bf5>] btrfs_page_mkwrite+0xa5/0x300 [btrfs]
[  577.839416]  [<ffffffff8114adcd>] do_wp_page+0x5fd/0x830
[  577.839522]  [<ffffffff8114bf7b>] handle_pte_fault+0x29b/0xa90
[  577.839626]  [<ffffffff8114d5eb>] handle_mm_fault+0x36b/0x770
[  577.839730]  [<ffffffff815c7382>] __do_page_fault+0x132/0x580
[  577.839834]  [<ffffffff815c4838>] page_fault+0x28/0x30
[  577.839944]  [<000000000041b550>] 0x41b54f
[  577.840108] btrfs-endio-wri D ffff8802bfc33800     0  5331      2 0x00000000
[  577.840283]  ffff8800b9f41cd0 0000000000000046 0000000000013800 
ffff8800b9f41fd8
[  577.840578]  ffff8800b9f41fd8 0000000000013800 ffff8802964106c0 ffff8800b215bea8
[  577.840875]  ffff8802aadcc1e8 0000000000000001 0000000000000000 
ffff8802857df6d0
[  577.841230] Call Trace:
[  577.841344]  [<ffffffffa0191aaf>] wait_current_trans.isra.17+0xaf/0x110 [btrfs]
[  577.841552]  [<ffffffffa0193198>] start_transaction+0x268/0x520 [btrfs]
[  577.841710]  [<ffffffffa019e6e5>] btrfs_finish_ordered_io+0x305/0xad0 [btrfs]
[  577.841897]  [<ffffffffa01c03d9>] worker_loop+0x149/0x550 [btrfs]
[  577.842126]  [<ffffffff8107355f>] kthread+0xaf/0xc0
[  577.842230]  [<ffffffff815caf8c>] ret_from_fork+0x7c/0xb0
[  577.842332] btrfs-endio-wri D ffff8802bfc13800     0  5337      2 0x00000000
[  577.842505]  ffff8800a807bcd0 0000000000000046 0000000000013800 
ffff8800a807bfd8
[  577.842802]  ffff8800a807bfd8 0000000000013800 ffff880296be03c0 ffff8800b215bea8
[  577.843125]  ffff8802aadcc1e8 0000000000000001 0000000000000000 
ffff8800a9ea5e50
[  577.843421] Call Trace:
[  577.843534]  [<ffffffffa0191aaf>] wait_current_trans.isra.17+0xaf/0x110 [btrfs]
[  577.843751]  [<ffffffffa0193198>] start_transaction+0x268/0x520 [btrfs]
[  577.843941]  [<ffffffffa019e6e5>] btrfs_finish_ordered_io+0x305/0xad0 [btrfs]
[  577.844108]  [<ffffffffa01c03d9>] worker_loop+0x149/0x550 [btrfs]
[  577.844284]  [<ffffffff8107355f>] kthread+0xaf/0xc0
[  577.844387]  [<ffffffff815caf8c>] ret_from_fork+0x7c/0xb0
[  577.844490] sync            D ffff8802bfc93800     0  5344   3345 0x00000000
[  577.844664]  ffff8802ad98dee0 0000000000000086 0000000000013800 
ffff8802ad98dfd8
[  577.844989]  ffff8802ad98dfd8 0000000000013800 ffff8802964005c0 ffff8800a9ea5ef0
[  577.845285]  ffff8802ad98def0 ffff8800b215bea8 ffff8800b215bf18 0000000000000000
[  577.845583] Call Trace:
[  577.845731]  [<ffffffffa0192885>] btrfs_commit_transaction+0x345/0x9f0 [btrfs]
[  577.845936]  [<ffffffff81190178>] iterate_supers+0xa8/0x110
[  577.846041]  [<ffffffff811b977d>] sys_sync+0x4d/0x90
[  577.846143]  [<ffffffff815cb03d>] system_call_fastpath+0x1a/0x1f
[  577.846248]  [<00007f9699768b07>] 0x7f9699768b06
[  577.846348] touch           D ffff8802bfc93800     0  5358   5347 0x00000000
[  577.846522]  ffff880283b8dd40 0000000000000086 0000000000013800 
ffff880283b8dfd8
[  577.846850]  ffff880283b8dfd8 0000000000013800 ffff8802ac4cc480 ffff8800b215bea8
[  577.847146]  ffff8802b0f0e9e8 0000000000000001 0000000000000000 
ffff8802857dfef0
[  577.847444] Call Trace:
[  577.847586]  [<ffffffffa0191aaf>] wait_current_trans.isra.17+0xaf/0x110 [btrfs]
[  577.847797]  [<ffffffffa0193198>] start_transaction+0x268/0x520 [btrfs]
[  577.847955]  [<ffffffffa01989a8>] btrfs_dirty_inode+0x38/0xd0 [btrfs]
[  577.848117]  [<ffffffffa019cb32>] btrfs_setattr+0xa2/0x2b0 [btrfs]
[  577.848268]  [<ffffffff811a72bc>] notify_change+0x1dc/0x360
[  577.848377]  [<ffffffff811b9ae2>] utimes_common+0xb2/0x140
[  577.848487]  [<ffffffff811b9c23>] do_utimes+0xb3/0x150
[  577.848619]  [<ffffffff811b9d8f>] SyS_utimensat+0x4f/0x90
[  577.848722]  [<ffffffff815cb03d>] system_call_fastpath+0x1a/0x1f
[  577.848827]  [<00007f715bcdfea2>] 0x7f715bcdfea1

SysRq + W:
http://paste.opensuse.org/15832548

Ákos
Ps.: this dmesg copying over SSH is a wonderful invention :).
