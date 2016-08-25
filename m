Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:60178 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755211AbcHYEcp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 00:32:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailext.virtall.com (Postfix) with ESMTP id A8A0048BC0A
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 05:16:36 +0200 (CEST)
Received: from mailext.virtall.com ([127.0.0.1])
        by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TUDvfGweKoc1 for <linux-btrfs@vger.kernel.org>;
        Thu, 25 Aug 2016 05:16:36 +0200 (CEST)
Received: from admin.virtall.com (localhost [127.0.0.1])
        by mailext.virtall.com (Postfix) with ESMTP
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 05:16:36 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 25 Aug 2016 12:16:36 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: WARNING: CPU: 7 PID: 23122 at
 /home/kernel/COD/linux/lib/list_debug.c:59 btrfs_clear_bit_hook+0x2b9/0x350
 [btrfs]
Message-ID: <cde05da520afb2a6d031d4a2ab1fed3b@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a brand new btrfs filesystem (few hours of uptime) on 4.7.2 
kernel:

1) first, this one repeated in syslog several times:

Aug 24 21:54:15 srv8 kernel: [ 9626.010136] ------------[ cut here 
]------------
Aug 24 21:54:15 srv8 kernel: [ 9626.010162] WARNING: CPU: 2 PID: 71 at 
/home/kernel/COD/linux/fs/btrfs/inode.c:9303 
btrfs_destroy_inode+0x296/0x2c0 [btrfs]
Aug 24 21:54:15 srv8 kernel: [ 9626.010163] Modules linked in: 
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables 
bridge stp llc cpufreq_conservative cpufreq_userspace
cpufreq_powersave cpufreq_stats fuse intel_rapl x86_pkg_temp_thermal 
intel_powerclamp coretemp kvm_intel kvm irqbypass btrfs crct10dif_pclmul 
crc32_pclmul eeepc_wmi asus_wmi sparse_keymap
rfkill ghash_clmulni_intel ppdev hmac drbg ansi_cprng aesni_intel 
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd lpc_ich shpchp 
intel_cstate serio_raw intel_rapl_perf ie31200_edac
mfd_core sg parport_pc evdev tpm_infineon edac_core tpm_tis tpm parport 
battery autofs4 ext4 crc16 jbd2 mbcache raid0 multipath linear raid456 
async_raid6_recov async_memcpy async_pq async
_xor async_tx xor raid1 raid6_pq libcrc32c crc32c_generic raid10 md_mod 
sd_mod ahci libahci crc32c_intel libata scsi_mod r8169 xhci_pci ehci_pci 
xhci_hcd ehci_hcd mii usbcore fan thermal w
mi usb_common video fjes button
Aug 24 21:54:15 srv8 kernel: [ 9626.010204] CPU: 2 PID: 71 Comm: kswapd0 
Not tainted 4.7.2-040702-generic #201608201334
Aug 24 21:54:15 srv8 kernel: [ 9626.010205] Hardware name: System 
manufacturer System Product Name/P8H77-M PRO, BIOS 9002 05/30/2014
Aug 24 21:54:15 srv8 kernel: [ 9626.010207]  0000000000000286 
00000000add763bd ffffffff81324b26 0000000000000000
Aug 24 21:54:15 srv8 kernel: [ 9626.010209]  0000000000000000 
ffffffff81078aae ffff8805dc8fb7a8 ffff8805dc8fb698
Aug 24 21:54:15 srv8 kernel: [ 9626.010210]  ffff880742a5f000 
ffff8800c761c000 0000000000000000 0000000000000000
Aug 24 21:54:15 srv8 kernel: [ 9626.010212] Call Trace:
Aug 24 21:54:15 srv8 kernel: [ 9626.010217]  [<ffffffff81324b26>] ? 
dump_stack+0x5c/0x86
Aug 24 21:54:15 srv8 kernel: [ 9626.010220]  [<ffffffff81078aae>] ? 
__warn+0xbe/0xe0
Aug 24 21:54:15 srv8 kernel: [ 9626.010237]  [<ffffffffc0531806>] ? 
btrfs_destroy_inode+0x296/0x2c0 [btrfs]
Aug 24 21:54:15 srv8 kernel: [ 9626.010240]  [<ffffffff81214626>] ? 
dispose_list+0x36/0x50
Aug 24 21:54:15 srv8 kernel: [ 9626.010241]  [<ffffffff812156b2>] ? 
prune_icache_sb+0x52/0x70
Aug 24 21:54:15 srv8 kernel: [ 9626.010243]  [<ffffffff811fbd4b>] ? 
super_cache_scan+0x13b/0x190
Aug 24 21:54:15 srv8 kernel: [ 9626.010246]  [<ffffffff8118cdd3>] ? 
shrink_slab.part.39+0x1e3/0x3d0
Aug 24 21:54:15 srv8 kernel: [ 9626.010248]  [<ffffffff81190e98>] ? 
shrink_zone+0x118/0x320
Aug 24 21:54:15 srv8 kernel: [ 9626.010250]  [<ffffffff8119209b>] ? 
kswapd+0x4ab/0x850
Aug 24 21:54:15 srv8 kernel: [ 9626.010253]  [<ffffffff81191bf0>] ? 
mem_cgroup_shrink_node_zone+0x170/0x170
Aug 24 21:54:15 srv8 kernel: [ 9626.010255]  [<ffffffff8109769d>] ? 
kthread+0xcd/0xf0
Aug 24 21:54:15 srv8 kernel: [ 9626.010258]  [<ffffffff815f201f>] ? 
ret_from_fork+0x1f/0x40
Aug 24 21:54:15 srv8 kernel: [ 9626.010259]  [<ffffffff810975d0>] ? 
kthread_create_on_node+0x1a0/0x1a0
Aug 24 21:54:15 srv8 kernel: [ 9626.010261] ---[ end trace 
36156eeb236e4bfc ]---
Aug 24 21:54:15 srv8 kernel: [ 9626.010262] ------------[ cut here 
]------------


2) followed by WARNING in list_debug.c:xx (different lines), repeated 
more than 20000 times:

Aug 24 21:54:19 srv8 kernel: [ 9630.222850] ------------[ cut here 
]------------
Aug 24 21:54:19 srv8 kernel: [ 9630.222874] WARNING: CPU: 7 PID: 812 at 
/home/kernel/COD/linux/lib/list_debug.c:59 
btrfs_clear_bit_hook+0x2b9/0x350 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.222875] list_del corruption. 
prev->next should be ffff88012507e1f8, but was ffff8806a5ee89c8
Aug 24 21:54:19 srv8 kernel: [ 9630.222876] Modules linked in: 
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables 
bridge stp llc cpufreq_conservative cpufreq_userspace cpufreq_powersave 
cpufreq_stats fuse intel_rapl x86_pkg_temp_thermal intel_powerclamp 
coretemp kvm_intel kvm irqbypass btrfs crct10dif_pclmul crc32_pclmul 
eeepc_wmi asus_wmi sparse_keymap rfkill ghash_clmulni_intel ppdev hmac 
drbg ansi_cprng aesni_intel aes_x86_64 lrw gf128mul glue_helper 
ablk_helper cryptd lpc_ich shpchp intel_cstate serio_raw intel_rapl_perf 
ie31200_edac mfd_core sg parport_pc evdev tpm_infineon edac_core tpm_tis 
tpm parport battery autofs4 ext4 crc16 jbd2 mbcache raid0 multipath 
linear raid456 async_raid6_recov async_memcpy async_pq async_xor 
async_tx xor raid1 raid6_pq libcrc32c crc32c_generic raid10 md_mod 
sd_mod ahci libahci crc32c_intel libata scsi_mod r8169 xhci_pci ehci_pci 
xhci_hcd ehci_hcd mii usbcore fan thermal wmi usb_common video fjes 
button
Aug 24 21:54:19 srv8 kernel: [ 9630.222912] CPU: 7 PID: 812 Comm: 
kworker/u16:3 Tainted: G        W       4.7.2-040702-generic 
#201608201334
Aug 24 21:54:19 srv8 kernel: [ 9630.222913] Hardware name: System 
manufacturer System Product Name/P8H77-M PRO, BIOS 9002 05/30/2014
Aug 24 21:54:19 srv8 kernel: [ 9630.222930] Workqueue: btrfs-delalloc 
btrfs_delalloc_helper [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.222931]  0000000000000286 
000000000de77a07 ffffffff81324b26 ffff8807f516ba08
Aug 24 21:54:19 srv8 kernel: [ 9630.222933]  0000000000000000 
ffffffff81078aae ffff88012507e11c ffff8807f516ba60
Aug 24 21:54:19 srv8 kernel: [ 9630.222935]  ffff88012507e1f8 
ffff88012507e2f0 0000000000002000 ffff8807f516bb24
Aug 24 21:54:19 srv8 kernel: [ 9630.222936] Call Trace:
Aug 24 21:54:19 srv8 kernel: [ 9630.222940]  [<ffffffff81324b26>] ? 
dump_stack+0x5c/0x86
Aug 24 21:54:19 srv8 kernel: [ 9630.222943]  [<ffffffff81078aae>] ? 
__warn+0xbe/0xe0
Aug 24 21:54:19 srv8 kernel: [ 9630.222945]  [<ffffffff81078b2f>] ? 
warn_slowpath_fmt+0x5f/0x80
Aug 24 21:54:19 srv8 kernel: [ 9630.222957]  [<ffffffffc050382a>] ? 
btrfs_free_reserved_data_space_noquota+0x4a/0x100 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.222969]  [<ffffffffc05206f9>] ? 
btrfs_clear_bit_hook+0x2b9/0x350 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.222982]  [<ffffffffc053e7c5>] ? 
clear_state_bit+0x55/0x1d0 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.222993]  [<ffffffffc053ea9e>] ? 
__clear_extent_bit+0x15e/0x400 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.223005]  [<ffffffffc053f985>] ? 
extent_clear_unlock_delalloc+0x75/0x2b0 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.223007]  [<ffffffff811d9b2d>] ? 
kmem_cache_alloc+0x13d/0x550
Aug 24 21:54:19 srv8 kernel: [ 9630.223019]  [<ffffffffc053ad67>] ? 
__btrfs_add_ordered_extent+0x1f7/0x310 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.223031]  [<ffffffffc0526470>] ? 
cow_file_range+0x2b0/0x4c0 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.223041]  [<ffffffffc0527b60>] ? 
submit_compressed_extents+0x540/0x540 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.223051]  [<ffffffffc05277fe>] ? 
submit_compressed_extents+0x1de/0x540 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.223060]  [<ffffffffc0527b60>] ? 
submit_compressed_extents+0x540/0x540 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.223072]  [<ffffffffc05527cd>] ? 
btrfs_scrubparity_helper+0x1fd/0x2d0 [btrfs]
Aug 24 21:54:19 srv8 kernel: [ 9630.223074]  [<ffffffff81091454>] ? 
process_one_work+0x184/0x440
Aug 24 21:54:19 srv8 kernel: [ 9630.223076]  [<ffffffff8109175d>] ? 
worker_thread+0x4d/0x480
Aug 24 21:54:19 srv8 kernel: [ 9630.223078]  [<ffffffff81091710>] ? 
process_one_work+0x440/0x440
Aug 24 21:54:19 srv8 kernel: [ 9630.223079]  [<ffffffff8109769d>] ? 
kthread+0xcd/0xf0
Aug 24 21:54:19 srv8 kernel: [ 9630.223082]  [<ffffffff815f201f>] ? 
ret_from_fork+0x1f/0x40
Aug 24 21:54:19 srv8 kernel: [ 9630.223083]  [<ffffffff810975d0>] ? 
kthread_create_on_node+0x1a0/0x1a0
Aug 24 21:54:19 srv8 kernel: [ 9630.223085] ---[ end trace 
36156eeb236e4c02 ]---
Aug 24 21:54:19 srv8 kernel: [ 9630.235926] ------------[ cut here 
]------------


3) in the end, the system died, the last message recorded in syslog 
being this:

Aug 24 23:37:42 srv8 kernel: [15833.456769] ------------[ cut here 
]------------
Aug 24 23:37:42 srv8 kernel: [15833.456789] WARNING: CPU: 1 PID: 25383 
at /home/kernel/COD/linux/lib/list_debug.c:62 
__start_delalloc_inodes+0xed/0x2c0 [btrfs]
Aug 24 23:37:42 srv8 kernel: [15833.456791] list_del corruption. 
next->prev should be ffff8804431ffc08, but was ffff880103897be8
Aug 24 23:37:42 srv8 kernel: [15833.456791] Modules linked in: 
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables 
bridge stp llc cpufreq_conservative cpufreq_userspace
cpufreq_powersave cpufreq_stats fuse intel_rapl x86_pkg_temp_thermal 
intel_powerclamp coretemp kvm_intel kvm irqbypass btrfs crct10dif_pclmul 
crc32_pclmul eeepc_wmi asus_wmi sparse_keymap
rfkill ghash_clmulni_intel ppdev hmac drbg ansi_cprng aesni_intel 
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd lpc_ich shpchp 
intel_cstate serio_raw intel_rapl_perf ie31200_edac
mfd_core sg parport_pc evdev tpm_infineon edac_core tpm_tis tpm parport 
battery autofs4 ext4 crc16 jbd2 mbcache raid0 multipath linear raid456 
async_raid6_recov async_memcpy async_pq async
_xor async_tx xor raid1 raid6_pq libcrc32c crc32c_generic raid10 md_mod 
sd_mod ahci libahci crc32c_intel libata scsi_mod r8169 xhci_pci ehci_pci 
xhci_hcd ehci_hcd mii usbcore fan thermal w
mi usb_common video fjes button
Aug 24 23:37:42 srv8 kernel: [15833.456823] CPU: 1 PID: 25383 Comm: 
btrfs Tainted: G        W       4.7.2-040702-generic #201608201334
Aug 24 23:37:42 srv8 kernel: [15833.456823] Hardware name: System 
manufacturer System Product Name/P8H77-M PRO, BIOS 9002 05/30/2014
Aug 24 23:37:42 srv8 kernel: [15833.456825]  0000000000000286 
00000000de790d51 ffffffff81324b26 ffff880103897b50
Aug 24 23:37:42 srv8 kernel: [15833.456826]  0000000000000000 
ffffffff81078aae ffff8804431ffc08 ffff880103897ba8
Aug 24 23:37:42 srv8 kernel: [15833.456828]  ffff880742a5f000 
0000000000000000 ffff880103897bd8 00000000ffffffff
Aug 24 23:37:42 srv8 kernel: [15833.456829] Call Trace:
Aug 24 23:37:42 srv8 kernel: [15833.456833]  [<ffffffff81324b26>] ? 
dump_stack+0x5c/0x86
Aug 24 23:37:42 srv8 kernel: [15833.456836]  [<ffffffff81078aae>] ? 
__warn+0xbe/0xe0
Aug 24 23:37:42 srv8 kernel: [15833.456837]  [<ffffffff81078b2f>] ? 
warn_slowpath_fmt+0x5f/0x80
Aug 24 23:37:42 srv8 kernel: [15833.456845]  [<ffffffffc04f2cc1>] ? 
btrfs_set_path_blocking+0x31/0x60 [btrfs]
Aug 24 23:37:42 srv8 kernel: [15833.456854]  [<ffffffffc0531b4d>] ? 
__start_delalloc_inodes+0xed/0x2c0 [btrfs]
Aug 24 23:37:42 srv8 kernel: [15833.456863]  [<ffffffffc0531d8c>] ? 
btrfs_start_delalloc_inodes+0x4c/0x140 [btrfs]
Aug 24 23:37:42 srv8 kernel: [15833.456865]  [<ffffffff810b8a5b>] ? 
finish_wait+0x3b/0x70
Aug 24 23:37:42 srv8 kernel: [15833.456874]  [<ffffffffc0556b3f>] ? 
btrfs_mksubvol+0x26f/0x5b0 [btrfs]
Aug 24 23:37:42 srv8 kernel: [15833.456876]  [<ffffffff810b8c90>] ? 
prepare_to_wait_event+0xe0/0xe0
Aug 24 23:37:42 srv8 kernel: [15833.456885]  [<ffffffffc0556ffe>] ? 
btrfs_ioctl_snap_create_transid+0x17e/0x190 [btrfs]
Aug 24 23:37:42 srv8 kernel: [15833.456894]  [<ffffffffc05571a3>] ? 
btrfs_ioctl_snap_create_v2+0x113/0x170 [btrfs]
Aug 24 23:37:42 srv8 kernel: [15833.456903]  [<ffffffffc055aa8d>] ? 
btrfs_ioctl+0x5ed/0x1fd0 [btrfs]
Aug 24 23:37:42 srv8 kernel: [15833.456904]  [<ffffffff811acdcc>] ? 
handle_pte_fault+0x8dc/0x16f0
Aug 24 23:37:42 srv8 kernel: [15833.456906]  [<ffffffff811fd76d>] ? 
cp_new_stat+0x14d/0x180
Aug 24 23:37:42 srv8 kernel: [15833.456908]  [<ffffffff8120be9e>] ? 
do_vfs_ioctl+0x9e/0x5e0
Aug 24 23:37:42 srv8 kernel: [15833.456909]  [<ffffffff811ae07a>] ? 
handle_mm_fault+0x29a/0x5a0
Aug 24 23:37:42 srv8 kernel: [15833.456910]  [<ffffffff8120c454>] ? 
SyS_ioctl+0x74/0x80
Aug 24 23:37:42 srv8 kernel: [15833.456912]  [<ffffffff815f1df6>] ? 
entry_SYSCALL_64_fastpath+0x1e/0xa8
Aug 24 23:37:42 srv8 kernel: [15833.456922] ---[ end trace 
36156eeb236e9c12 ]---



Tomasz Chmielewski
https://lxadm.com
