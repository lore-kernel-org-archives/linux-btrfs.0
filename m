From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: kernel BUG at fs/btrfs/inode.c:3037
Date: Mon, 14 Nov 2011 17:09:43 +0100
Message-ID: <CABVOS09ugTBxMUYczixx2FRoeUtAaHTmY=d7n+6BsF1HGg183A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm hitting following kernel bug when trying to rmdir empty directory
from btrfs filesystem.
I'm on Linux 3.1.1-1.fc16.i686.PAE.
rmdir ends with segfault.
I have found similar problem in this mailing list but not the same one
so I'm reporting it.

[  281.284923] btrfs: could not do orphan cleanup -116
[  433.019128] ------------[ cut here ]------------
[  433.019155] WARNING: at fs/dcache.c:1270 d_set_d_op+0x2c/0x85()
[  433.019163] Hardware name: System Product Name
[  433.019169] Modules linked in: btrfs zlib_deflate libcrc32c
sha256_generic dm_crypt bnep bluetooth ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 w83627ehf nf_defrag_ipv4
hwmon_vid xt_state nf_conntrack snd_hda_codec_realtek
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_timer eeepc_wmi snd asus_wmi soundcore
r8169 mii sp5100_tco serio_raw i2c_piix4 uinput i2c_core k10temp
snd_page_alloc sparse_keymap rfkill microcode firewire_ohci
firewire_core crc_itu_t wmi [last unloaded: scsi_wait_scan]
[  433.019303] Pid: 2112, comm: autojump Not tainted 3.1.1-1.fc16.i686.PAE #1
[  433.019311] Call Trace:
[  433.019327]  [<c082001f>] ? printk+0x2d/0x2f
[  433.019342]  [<c0447951>] warn_slowpath_common+0x7c/0x91
[  433.019354]  [<c05068f5>] ? d_set_d_op+0x2c/0x85
[  433.019365]  [<c05068f5>] ? d_set_d_op+0x2c/0x85
[  433.019377]  [<c0447988>] warn_slowpath_null+0x22/0x24
[  433.019388]  [<c05068f5>] d_set_d_op+0x2c/0x85
[  433.019398]  [<c0510810>] simple_lookup+0x25/0x3d
[  433.019409]  [<c04ffc2e>] d_alloc_and_lookup+0x34/0x52
[  433.019420]  [<c0500610>] walk_component+0x1ec/0x383
[  433.019431]  [<c0500ce4>] link_path_walk+0x14e/0x3a1
[  433.019441]  [<c0501116>] ? path_init+0x16a/0x24e
[  433.019452]  [<c05027de>] path_openat+0x8c/0x283
[  433.019464]  [<c04d5a80>] ? handle_pte_fault+0x34b/0x8ce
[  433.019474]  [<c0500229>] ? putname+0x29/0x2c
[  433.019484]  [<c0502aae>] do_filp_open+0x2b/0x6c
[  433.019496]  [<c04eb8f5>] ? kmem_cache_alloc+0x26/0xe9
[  433.019508]  [<c0434d74>] ? should_resched+0xd/0x27
[  433.019522]  [<c05d99de>] ? strncpy_from_user+0x34/0x4e
[  433.019533]  [<c050ad3a>] ? alloc_fd+0x53/0xbf
[  433.019546]  [<c04f7a1c>] do_sys_open+0x5f/0xe5
[  433.019558]  [<c0499349>] ? call_rcu_sched+0x12/0x14
[  433.019570]  [<c04f7ac8>] sys_open+0x26/0x2c
[  433.019581]  [<c0827f14>] syscall_call+0x7/0xb
[  433.019589] ---[ end trace 2d971029a7846877 ]---
[  433.019596] ------------[ cut here ]------------
[  433.019606] WARNING: at fs/dcache.c:1274 d_set_d_op+0x50/0x85()
[  433.019613] Hardware name: System Product Name
[  433.019618] Modules linked in: btrfs zlib_deflate libcrc32c
sha256_generic dm_crypt bnep bluetooth ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 w83627ehf nf_defrag_ipv4
hwmon_vid xt_state nf_conntrack snd_hda_codec_realtek
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_timer eeepc_wmi snd asus_wmi soundcore
r8169 mii sp5100_tco serio_raw i2c_piix4 uinput i2c_core k10temp
snd_page_alloc sparse_keymap rfkill microcode firewire_ohci
firewire_core crc_itu_t wmi [last unloaded: scsi_wait_scan]
[  433.019731] Pid: 2112, comm: autojump Tainted: G        W
3.1.1-1.fc16.i686.PAE #1
[  433.019738] Call Trace:
[  433.019748]  [<c082001f>] ? printk+0x2d/0x2f
[  433.019760]  [<c0447951>] warn_slowpath_common+0x7c/0x91
[  433.019771]  [<c0506919>] ? d_set_d_op+0x50/0x85
[  433.019781]  [<c0506919>] ? d_set_d_op+0x50/0x85
[  433.019792]  [<c0447988>] warn_slowpath_null+0x22/0x24
[  433.019803]  [<c0506919>] d_set_d_op+0x50/0x85
[  433.019813]  [<c0510810>] simple_lookup+0x25/0x3d
[  433.019822]  [<c04ffc2e>] d_alloc_and_lookup+0x34/0x52
[  433.019832]  [<c0500610>] walk_component+0x1ec/0x383
[  433.019843]  [<c0500ce4>] link_path_walk+0x14e/0x3a1
[  433.019854]  [<c0501116>] ? path_init+0x16a/0x24e
[  433.019864]  [<c05027de>] path_openat+0x8c/0x283
[  433.019875]  [<c04d5a80>] ? handle_pte_fault+0x34b/0x8ce
[  433.019885]  [<c0500229>] ? putname+0x29/0x2ckernel BUG at
fs/btrfs/inode.c:3037
[  433.019894]  [<c0502aae>] do_filp_open+0x2b/0x6c
[  433.019905]  [<c04eb8f5>] ? kmem_cache_alloc+0x26/0xe9
[  433.019917]  [<c0434d74>] ? should_resched+0xd/0x27
[  433.019929]  [<c05d99de>] ? strncpy_from_user+0x34/0x4e
[  433.019940]  [<c050ad3a>] ? alloc_fd+0x53/0xbf
[  433.019952]  [<c04f7a1c>] do_sys_open+0x5f/0xe5
[  433.019962]  [<c0499349>] ? call_rcu_sched+0x12/0x14
[  433.019974]  [<c04f7ac8>] sys_open+0x26/0x2c
[  433.019984]  [<c0827f14>] syscall_call+0x7/0xb
[  433.019992] ---[ end trace 2d971029a7846878 ]---
[  460.693013] ------------[ cut here ]------------
[  460.693013] kernel BUG at fs/btrfs/inode.c:3037!
[  460.693013] invalid opcode: 0000 [#1] SMP
[  460.693013] Modules linked in: btrfs zlib_deflate libcrc32c
sha256_generic dm_crypt bnep bluetooth ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 w83627ehf nf_defrag_ipv4
hwmon_vid xt_state nf_conntrack snd_hda_codec_realtek
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_timer eeepc_wmi snd asus_wmi soundcore
r8169 mii sp5100_tco serio_raw i2c_piix4 uinput i2c_core k10temp
snd_page_alloc sparse_keymap rfkill microcode firewire_ohci
firewire_core crc_itu_t wmi [last unloaded: scsi_wait_scan]
[  460.693013]
[  460.693013] Pid: 2186, comm: rmdir Tainted: G        W
3.1.1-1.fc16.i686.PAE #1 System manufacturer System Product
Name/E35M1-M
[  460.693013] EIP: 0060:[<f8332528>] EFLAGS: 00010202 CPU: 0
[  460.693013] EIP is at btrfs_unlink_subvol+0x74/0x201 [btrfs]
[  460.693013] EAX: 00000001 EBX: d84d75a4 ECX: 00000000 EDX: 00000001
[  460.693013] ESI: 000091d3 EDI: 00000000 EBP: cfe45ee8 ESP: cfe45e80
[  460.693013]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  460.693013] Process rmdir (pid: 2186, ti=cfe44000 task=ee671920
task.ti=cfe44000)
[  460.693013] Stack:
[  460.693013]  000091d3 00000000 d84d75a4 00000010 ffffffff cfe45ee8
f832b387 00000000
[  460.693013]  00000000 00000000 00000000 00000699 ecbd0630 ea007008
e64a8c00 ec965070
[  460.693013]  00000000 000091d3 00000000 00000000 d84d7580 ecbd0630
e64a8c00 ecbd0630
[  460.693013] Call Trace:
[  460.693013]  [<f832b387>] ? __unlink_start_trans+0x46/0x3c0 [btrfs]
[  460.693013]  [<f8332758>] btrfs_rmdir+0xa3/0x113 [btrfs]
[  460.693013]  [<c0501dd1>] vfs_rmdir+0x6a/0xa2
[  460.693013]  [<c0501e96>] do_rmdir+0x8d/0xc5
[  460.693013]  [<c04f6e08>] ? filp_close+0x5c/0x64
[  460.693013]  [<c0502e0a>] sys_rmdir+0x15/0x17
[  460.693013]  [<c082da1f>] sysenter_do_call+0x12/0x28
[  460.693013] Code: c7 44 24 10 ff ff ff ff 89 5c 24 0c 8b 5d 10 89
34 24 89 7c 24 04 89 5c 24 08 e8 99 f0 fe ff 89 45 bc e8 96 8a ff ff
85 c0 74 02 <0f> 0b 8b 5d d4 8d 4d db 8b 55 bc 8b 03 e8 2d 8b ff ff 80
7d e3
[  460.693013] EIP: [<f8332528>] btrfs_unlink_subvol+0x74/0x201
[btrfs] SS:ESP 0068:cfe45e80
[  460.693525] ---[ end trace 2d971029a7846879 ]---
