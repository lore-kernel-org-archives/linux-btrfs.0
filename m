Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f193.google.com ([209.85.217.193]:32929 "EHLO
	mail-lb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbbL2JBg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 04:01:36 -0500
Received: by mail-lb0-f193.google.com with SMTP id bc4so3433612lbc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 01:01:35 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 29 Dec 2015 10:01:34 +0100
Message-ID: <CAC+fKQXdQLWE5VzvXEt94e8TXBzt7Y+v=x3pGAs+HD_uoTWSTw@mail.gmail.com>
Subject: [BUG] unable to handle kernel NULL pointer dereference when removing device
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
To: Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, I've hit this bug when removing the device
/dev/mapper/vg_hd04-lv_btrfs_hd04 from this filesystem. The only
peculiarity is that it mixes partitions and a lvm logical volume.

The device was removed successfully and no further errors have been seen.

# btrfs fi show
Label: 'btrfs_raid1'  uuid: 038b2b48-fd2d-4565-b2b1-d07847ecca8c
        Total devices 4 FS bytes used 1.90TiB
        devid    1 size 1.81TiB used 1.30TiB path /dev/sdb4
        devid    2 size 1.81TiB used 1.30TiB path /dev/sdc4
        devid    3 size 1.81TiB used 1.30TiB path /dev/sdd4
        devid    4 size 1.60TiB used 0.00B path
/dev/mapper/vg_hd04-lv_btrfs_hd04

btrfs-progs v4.2.2

# uname -a
Linux xenon 4.2.8-300.fc23.x86_64 #1 SMP Tue Dec 15 16:49:06 UTC 2015
x86_64 x86_64 x86_64 GNU/Linux

# btrfs dev remove /dev/mapper/vg_hd04-lv_btrfs_hd04 /mnt/btrfs

# dmesg
[ 5557.353436] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000380
[ 5557.353492] IP: [<ffffffff81366d65>] bio_get_nr_vecs+0x15/0x40
[ 5557.353532] PGD 0
[ 5557.353547] Oops: 0000 [#1] SMP
[ 5557.353571] Modules linked in: hfsplus hfs minix msdos jfs xfs
libcrc32c xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun xt_set
xt_multiport ip_set_h
ash_ip ip_set nfnetlink nf_conntrack_netbios_ns nf_conntrack_broadcast
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_broute
bridge ebtable_filter ebtable_nat ebtables ip6table_mangle
ip6table_raw ip6table_security ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_filter ip6_tables iptable_mangle
iptable_raw iptable_security iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack vfat fat uvcvideo
videobuf2_vmalloc videobuf2_core videobuf2_memops v4l2_common videodev
media intel_rapl iosf_mbi x86_pkg_temp_thermal coretemp kvm_intel kvm
snd_hda_codec_realtek snd_hda_codec_g
eneric snd_hda_codec_hdmi
[ 5557.354070]  crct10dif_pclmul crc32_pclmul snd_hda_intel
snd_hda_codec snd_usb_audio snd_hda_core snd_usbmidi_lib snd_hwdep
snd_rawmidi snd_seq snd_seq_dev
ice snd_pcm fuse snd_timer iTCO_wdt iTCO_vendor_support snd eeepc_wmi
asus_wmi sparse_keymap rfkill mei_me lpc_ich joydev i2c_i801 shpchp
soundcore mei video
wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc btrfs xor
raid6_pq amdkfd amd_iommu_v2 radeon i2c_algo_bit drm_kms_helper ttm
crc32c_intel drm 802
1q serio_raw garp stp llc mrp r8169 mii
[ 5557.354424] CPU: 1 PID: 1626 Comm: transmission-da Not tainted
4.2.8-300.fc23.x86_64 #1
[ 5557.354467] Hardware name: System manufacturer System Product
Name/P8Z68-V LE, BIOS 4102 09/09/2013
[ 5557.354514] task: ffff8803f8cc0000 ti: ffff8803dffb4000 task.ti:
ffff8803dffb4000
[ 5557.354554] RIP: 0010:[<ffffffff81366d65>]  [<ffffffff81366d65>]
bio_get_nr_vecs+0x15/0x40
[ 5557.354600] RSP: 0018:ffff8803dffb7a88  EFLAGS: 00010246
[ 5557.354629] RAX: 0000000000000000 RBX: 0000000000001000 RCX: 0000000000000100
[ 5557.354666] RDX: 0000000000000100 RSI: ffffffffffffffff RDI: ffff88040dc296c0
[ 5557.354703] RBP: ffff8803dffb7a88 R08: 000000010050516f R09: ffff88040c142000
[ 5557.354740] R10: ffff8803777928a0 R11: 0000000000000000 R12: ffff8803dffb7d30
[ 5557.354777] R13: 0000000000000000 R14: 0000000130e7b360 R15: ffff88007f2c97b0
[ 5557.354815] FS:  00007fc64ffa0700(0000) GS:ffff88041ec40000(0000)
knlGS:0000000000000000
[ 5557.354856] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5557.354887] CR2: 0000000000000380 CR3: 00000003df687000 CR4: 00000000000406e0
[ 5557.354923] Stack:
[ 5557.354936]  ffff8803dffb7ae8 ffffffffa035dae7 0000000000000000
0000000000000000
[ 5557.354981]  0000000000000000 ffffea000e2b3740 ffff8803dffb7b68
0000000000000000
[ 5557.355028]  ffffea000e2b3740 0000000000000000 ffff8803dffb7d40
000000000da6c000
[ 5557.355074] Call Trace:
[ 5557.355110]  [<ffffffffa035dae7>] submit_extent_page+0x177/0x1e0 [btrfs]
[ 5557.355160]  [<ffffffffa035ec4e>] __do_readpage+0x39e/0x910 [btrfs]
[ 5557.355206]  [<ffffffffa035d1a0>] ?
btrfs_create_repair_bio+0x100/0x100 [btrfs]
[ 5557.355257]  [<ffffffffa0341a30>] ? btrfs_real_readdir+0x570/0x570 [btrfs]
[ 5557.355305]  [<ffffffffa035f584>]
__extent_readpages.constprop.41+0x2c4/0x2e0 [btrfs]
[ 5557.355349]  [<ffffffff811a26f6>] ? __add_to_page_cache_locked+0x1c6/0x2b0
[ 5557.355397]  [<ffffffffa0341a30>] ? btrfs_real_readdir+0x570/0x570 [btrfs]
[ 5557.355446]  [<ffffffffa035fc2e>] extent_readpages+0x1de/0x1f0 [btrfs]
[ 5557.355491]  [<ffffffffa0341a30>] ? btrfs_real_readdir+0x570/0x570 [btrfs]
[ 5557.355530]  [<ffffffff811f50e1>] ? alloc_pages_current+0x91/0x100
[ 5557.355573]  [<ffffffffa033f74f>] btrfs_readpages+0x1f/0x30 [btrfs]
[ 5557.355608]  [<ffffffff811b1286>] __do_page_cache_readahead+0x1b6/0x230
[ 5557.355644]  [<ffffffff811b161a>] force_page_cache_readahead+0x3a/0x60
[ 5557.355680]  [<ffffffff811e6546>] SyS_fadvise64+0x1f6/0x250
[ 5557.355712]  [<ffffffff8177a2ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 5557.355746] Code: 5b 5d c3 e8 5e 75 d3 ff 90 90 90 90 90 90 90 90
90 90 90 90 90 90 66 66 66 66 90 48 8b 87 98 00 00 00 55 b9 00 01 00
00 48 89 e5 <48> 8b
90 80 03 00 00 5d 8b 82 00 07 00 00 0f b7 92 2a 07 00 00
[ 5557.355987] RIP  [<ffffffff81366d65>] bio_get_nr_vecs+0x15/0x40
[ 5557.356022]  RSP <ffff8803dffb7a88>
[ 5557.356041] CR2: 0000000000000380
[ 5557.369444] ---[ end trace b3c3f1a1174600de ]---
[ 5557.369446] ------------[ cut here ]------------
[ 5557.369451] WARNING: CPU: 1 PID: 1626 at kernel/exit.c:661
do_exit+0x5f/0xae0()
[ 5557.369452] Modules linked in: hfsplus hfs minix msdos jfs xfs
libcrc32c xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun xt_set
xt_multiport ip_set_h
ash_ip ip_set nfnetlink nf_conntrack_netbios_ns nf_conntrack_broadcast
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_broute
bridge ebtable_fil
ter ebtable_nat ebtables ip6table_mangle ip6table_raw
ip6table_security ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_filter ip6_tables i
ptable_mangle iptable_raw iptable_security iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack vfat
fat uvcvideo videobuf2_vmalloc vi
deobuf2_core videobuf2_memops v4l2_common videodev media intel_rapl
iosf_mbi x86_pkg_temp_thermal coretemp kvm_intel kvm
snd_hda_codec_realtek snd_hda_codec_g
eneric snd_hda_codec_hdmi
[ 5557.369507]  crct10dif_pclmul crc32_pclmul snd_hda_intel
snd_hda_codec snd_usb_audio snd_hda_core snd_usbmidi_lib snd_hwdep
snd_rawmidi snd_seq snd_seq_dev
ice snd_pcm fuse snd_timer iTCO_wdt iTCO_vendor_support snd eeepc_wmi
asus_wmi sparse_keymap rfkill mei_me lpc_ich joydev i2c_i801 shpchp
soundcore mei video
wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc btrfs xor
raid6_pq amdkfd amd_iommu_v2 radeon i2c_algo_bit drm_kms_helper ttm
crc32c_intel drm 802
1q serio_raw garp stp llc mrp r8169 mii
[ 5557.369545] CPU: 1 PID: 1626 Comm: transmission-da Tainted: G
D         4.2.8-300.fc23.x86_64 #1
[ 5557.369547] Hardware name: System manufacturer System Product
Name/P8Z68-V LE, BIOS 4102 09/09/2013
[ 5557.369549]  0000000000000000 00000000be9d5b68 ffff8803dffb7728
ffffffff817738ca
[ 5557.369552]  0000000000000000 0000000000000000 ffff8803dffb7768
ffffffff8109e4c6
[ 5557.369555]  0000000000000009 ffff8803f8cc0000 0000000000000009
ffff8803dffb79d8
[ 5557.369558] Call Trace:
[ 5557.369562]  [<ffffffff817738ca>] dump_stack+0x45/0x57
[ 5557.369567]  [<ffffffff8109e4c6>] warn_slowpath_common+0x86/0xc0
[ 5557.369571]  [<ffffffff8109e5fa>] warn_slowpath_null+0x1a/0x20
[ 5557.369573]  [<ffffffff810a089f>] do_exit+0x5f/0xae0
[ 5557.369576]  [<ffffffff81772956>] ? printk+0x55/0x6b
[ 5557.369580]  [<ffffffff810180fe>] oops_end+0x9e/0xd0
[ 5557.369585]  [<ffffffff81064c25>] no_context+0x135/0x380
[ 5557.369588]  [<ffffffff81064ef0>] __bad_area_nosemaphore+0x80/0x1f0
[ 5557.369592]  [<ffffffff810650c7>] bad_area+0x47/0x60
[ 5557.369595]  [<ffffffff810655fb>] __do_page_fault+0x35b/0x400
[ 5557.369599]  [<ffffffff810656cf>] do_page_fault+0x2f/0x80
[ 5557.369602]  [<ffffffff8177c238>] page_fault+0x28/0x30
[ 5557.369606]  [<ffffffff81366d65>] ? bio_get_nr_vecs+0x15/0x40
[ 5557.369622]  [<ffffffffa035dae7>] submit_extent_page+0x177/0x1e0 [btrfs]
[ 5557.369636]  [<ffffffffa035ec4e>] __do_readpage+0x39e/0x910 [btrfs]
[ 5557.369648]  [<ffffffffa035d1a0>] ?
btrfs_create_repair_bio+0x100/0x100 [btrfs]
[ 5557.369662]  [<ffffffffa0341a30>] ? btrfs_real_readdir+0x570/0x570 [btrfs]
[ 5557.369676]  [<ffffffffa035f584>]
__extent_readpages.constprop.41+0x2c4/0x2e0 [btrfs]
[ 5557.369680]  [<ffffffff811a26f6>] ? __add_to_page_cache_locked+0x1c6/0x2b0
[ 5557.369693]  [<ffffffffa0341a30>] ? btrfs_real_readdir+0x570/0x570 [btrfs]
[ 5557.369706]  [<ffffffffa035fc2e>] extent_readpages+0x1de/0x1f0 [btrfs]
[ 5557.369719]  [<ffffffffa0341a30>] ? btrfs_real_readdir+0x570/0x570 [btrfs]
[ 5557.369723]  [<ffffffff811f50e1>] ? alloc_pages_current+0x91/0x100
[ 5557.369735]  [<ffffffffa033f74f>] btrfs_readpages+0x1f/0x30 [btrfs]
[ 5557.369739]  [<ffffffff811b1286>] __do_page_cache_readahead+0x1b6/0x230
[ 5557.369742]  [<ffffffff811b161a>] force_page_cache_readahead+0x3a/0x60
[ 5557.369746]  [<ffffffff811e6546>] SyS_fadvise64+0x1f6/0x250
[ 5557.369749]  [<ffffffff8177a2ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 5557.369752] ---[ end trace b3c3f1a1174600df ]---

-- 
Juan Orti
https://apuntesderootblog.wordpress.com/
