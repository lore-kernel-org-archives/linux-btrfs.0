Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37380 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab3CVO0Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 10:26:25 -0400
Received: by mail-ob0-f171.google.com with SMTP id x4so4044291obh.30
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Mar 2013 07:26:24 -0700 (PDT)
MIME-Version: 1.0
From: Jon Nelson <jnelson@jamponi.net>
Date: Fri, 22 Mar 2013 09:26:03 -0500
Message-ID: <CAKuK5J1KQvWw-kLhqJ6_t9XnDS3+C0Qfg0QViqvkiKRExSF8BQ@mail.gmail.com>
Subject: crash with 3.7.10 and balance.
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running openSUSE 12.3 on x86_64.
I was running a balance:
btrfs balance -dusage=5 -v /

using the latest btrfs tools code from git (as of this writing)
and got a crash:

[304158.496250] btrfs: found 75 extents
[304159.309289] btrfs: relocating block group 2303295684608 flags 17
[304159.839886] btrfs: found 1 extents
[304161.484616] ------------[ cut here ]------------
[304161.484668] WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-default-3.7.10/linux-3.7/fs/btrfs/super.c:246
__btrfs_abort_transaction+0xc3/0xe0 [btrfs]()
[304161.484671] Hardware name: TA790GX XE
[304161.484673] btrfs: Transaction aborted
[304161.484675] Modules linked in: af_packet md5 xt_REDIRECT
xt_pkttype xt_physdev xt_TCPMSS xt_tcpudp xt_LOG xt_limit iptable_nat
nf_nat_ipv4 nf_nat iptable_mangle xt_mark nfsd nfs_acl nfs fscache
lockd auth_rpcgss ebt_ip sunrpc ebtable_filter ebtables bridge stp llc
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_ftp
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
ip6_tables x_tables cpufreq_conservative cpufreq_userspace
cpufreq_powersave snd_hda_codec_hdmi snd_hda_codec_realtek
acpi_cpufreq snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd sr_mod cdrom radeon mperf ttm soundcore ata_generic sg
via_velocity sp5100_tco drm_kms_helper kvm_amd kvm microcode
snd_page_alloc r8169 pcspkr crc_ccitt button i2c_piix4 k10temp
edac_core drm pata_atiixp i2c_algo_bit edac_mce_amd shpchp pci_hotplug
wmi tcp_htcp autofs4 btrfs zlib_deflate libcrc32c raid456
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy
async_tx raid10 raid0 raid1 ohci_hcd ehci_hcd usbcore usb_common
scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua scsi_dh dm_mirror
dm_region_hash dm_log dm_mod edd fan thermal processor thermal_sys
[304161.484749] Pid: 22397, comm: btrfs Tainted: G        W
3.7.10-1.1-default #1
[304161.484751] Call Trace:
[304161.484770]  [<ffffffff81004728>] dump_trace+0x78/0x2c0
[304161.484777]  [<ffffffff8153b44e>] dump_stack+0x69/0x6f
[304161.484785]  [<ffffffff81043f69>] warn_slowpath_common+0x79/0xc0
[304161.484791]  [<ffffffff81044065>] warn_slowpath_fmt+0x45/0x50
[304161.484812]  [<ffffffffa01662e3>]
__btrfs_abort_transaction+0xc3/0xe0 [btrfs]
[304161.484844]  [<ffffffffa0175ddd>] __btrfs_inc_extent_ref+0x1ed/0x250 [btrfs]
[304161.484899]  [<ffffffffa017c3f6>] run_clustered_refs+0x666/0xa90 [btrfs]
[304161.484954]  [<ffffffffa017f4ea>] btrfs_run_delayed_refs+0xca/0x310 [btrfs]
[304161.485012]  [<ffffffffa018f7d9>] __btrfs_end_transaction+0xf9/0x420 [btrfs]
[304161.485085]  [<ffffffffa01d457d>] merge_reloc_root+0x48d/0x520 [btrfs]
[304161.485214]  [<ffffffffa01d4711>] merge_reloc_roots+0x101/0x140 [btrfs]
[304161.485337]  [<ffffffffa01d4bde>] relocate_block_group+0x25e/0x6b0 [btrfs]
[304161.485459]  [<ffffffffa01d51d9>]
btrfs_relocate_block_group+0x1a9/0x2e0 [btrfs]
[304161.485579]  [<ffffffffa01aed4d>]
btrfs_relocate_chunk.isra.53+0x5d/0x6e0 [btrfs]
[304161.485674]  [<ffffffffa01b3086>] btrfs_balance+0x826/0xd60 [btrfs]
[304161.485770]  [<ffffffffa01b88f6>] btrfs_ioctl_balance+0x136/0x420 [btrfs]
[304161.485878]  [<ffffffffa01bcc64>] btrfs_ioctl+0xe54/0x1870 [btrfs]
[304161.485967]  [<ffffffff81177b1f>] do_vfs_ioctl+0x8f/0x520
[304161.485973]  [<ffffffff81178050>] sys_ioctl+0xa0/0xc0
[304161.485979]  [<ffffffff8154f2ed>] system_call_fastpath+0x1a/0x1f
[304161.485989]  [<00007f03050aef27>] 0x7f03050aef26
[304161.485991] ---[ end trace d010cbea0d653c96 ]---
[304161.485995] BTRFS error (device sdd) in
__btrfs_inc_extent_ref:1952: Object already exists
[304161.485996] btrfs is forced readonly
[304161.486051] ------------[ cut here ]------------
[304161.486138] kernel BUG at
/home/abuild/rpmbuild/BUILD/kernel-default-3.7.10/linux-3.7/fs/btrfs/relocation.c:2279!
[304161.486299] invalid opcode: 0000 [#1] SMP
[304161.486371] Modules linked in: af_packet md5 xt_REDIRECT
xt_pkttype xt_physdev xt_TCPMSS xt_tcpudp xt_LOG xt_limit iptable_nat
nf_nat_ipv4 nf_nat iptable_mangle xt_mark nfsd nfs_acl nfs fscache
lockd auth_rpcgss ebt_ip sunrpc ebtable_filter ebtables bridge stp llc
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT
iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_ftp
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
ip6_tables x_tables cpufreq_conservative cpufreq_userspace
cpufreq_powersave snd_hda_codec_hdmi snd_hda_codec_realtek
acpi_cpufreq snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer
snd sr_mod cdrom radeon mperf ttm soundcore ata_generic sg
via_velocity sp5100_tco drm_kms_helper kvm_amd kvm microcode
snd_page_alloc r8169 pcspkr crc_ccitt button i2c_piix4 k10temp
edac_core drm pata_atiixp i2c_algo_bit edac_mce_amd shpchp pci_hotplug
wmi tcp_htcp autofs4 btrfs zlib_deflate libcrc32c raid456
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy
async_tx raid10 raid0 raid1 ohci_hcd ehci_hcd usbcore usb_common
scsi_dh_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua scsi_dh dm_mirror
dm_region_hash dm_log dm_mod edd fan thermal processor thermal_sys
[304161.488642] CPU 3
[304161.488678] Pid: 22397, comm: btrfs Tainted: G        W
3.7.10-1.1-default #1 BIOSTAR Group TA790GX XE/TA790GX XE
[304161.488851] RIP: 0010:[<ffffffffa01d473f>]  [<ffffffffa01d473f>]
merge_reloc_roots+0x12f/0x140 [btrfs]
[304161.489024] RSP: 0018:ffff8800560e3ae8  EFLAGS: 00010286
[304161.489109] RAX: 00000000ffffffe2 RBX: ffff880075ada000 RCX:
00000000ffffffe2
[304161.489222] RDX: 0000000000000001 RSI: ffffffffa01f2140 RDI:
ffff88007ec44000
[304161.489335] RBP: ffff88003dc0a000 R08: 0000000000000000 R09:
ffff88000ad589c0
[304161.489447] R10: ffff880007fd7840 R11: 0000000000000000 R12:
ffff8800560e3ae8
[304161.489560] R13: ffff88003dc0a590 R14: 0000000000000000 R15:
ffff88003dc0a000
[304161.489674] FS:  00007f03062fa740(0000) GS:ffff88008fcc0000(0000)
knlGS:0000000000000000
[304161.489800] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[304161.489892] CR2: 00007fb1b64f3000 CR3: 000000000ec90000 CR4:
00000000000007e0
[304161.490005] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[304161.490117] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[304161.490231] Process btrfs (pid: 22397, threadinfo
ffff8800560e2000, task ffff8800315d8440)
[304161.490359] Stack:
[304161.490393]  ffff880089556c40 ffff88001da2fc40 ffff88003dc0a020
0000000000000000
[304161.490527]  ffff88003dc0a020 ffff88003dc0a0e8 ffff880011ed7e20
ffffffffa01d4bde
[304161.490661]  ffff8800315d8440 ffff88000e8a19e8 0000000000000001
ffff8800560e3b70
[304161.490794] Call Trace:
[304161.490959]  [<ffffffffa01d4bde>] relocate_block_group+0x25e/0x6b0 [btrfs]
[304161.491188]  [<ffffffffa01d51d9>]
btrfs_relocate_block_group+0x1a9/0x2e0 [btrfs]
[304161.491423]  [<ffffffffa01aed4d>]
btrfs_relocate_chunk.isra.53+0x5d/0x6e0 [btrfs]
[304161.496247]  [<ffffffffa01b3086>] btrfs_balance+0x826/0xd60 [btrfs]
[304161.501104]  [<ffffffffa01b88f6>] btrfs_ioctl_balance+0x136/0x420 [btrfs]
[304161.506028]  [<ffffffffa01bcc64>] btrfs_ioctl+0xe54/0x1870 [btrfs]
[304161.510965]  [<ffffffff81177b1f>] do_vfs_ioctl+0x8f/0x520
[304161.515804]  [<ffffffff81178050>] sys_ioctl+0xa0/0xc0
[304161.520633]  [<ffffffff8154f2ed>] system_call_fastpath+0x1a/0x1f
[304161.525500]  [<00007f03050aef27>] 0x7f03050aef26
[304161.530364] Code: 98 0f 0b 66 0f 1f 84 00 00 00 00 00 85 d2 0f 85
08 ff ff ff 48 83 bd 80 05 00 00 00 75 13 48 83 c4 18 31 c0 5b 5d 41
5c 41 5d c3 <0f> 0b 0f 0b 0f 0b 0f 0b 66 0f 1f 84 00 00 00 00 00 41 57
41 56
[304161.540686] RIP  [<ffffffffa01d473f>] merge_reloc_roots+0x12f/0x140 [btrfs]
[304161.545834]  RSP <ffff8800560e3ae8>
[304161.567260] ---[ end trace d010cbea0d653c97 ]---


after reboot, I had these in dmesg:

[    2.987614] Btrfs loaded
[    3.086503] device fsid 7feedf1e-9711-4900-af9c-92738ea8aace devid
3 transid 191375 /dev/sda3
[    3.266789] device fsid 7feedf1e-9711-4900-af9c-92738ea8aace devid
4 transid 191375 /dev/sdb3
[    3.295747] device fsid 7feedf1e-9711-4900-af9c-92738ea8aace devid
6 transid 191375 /dev/sdc
[    3.323649] device fsid 7feedf1e-9711-4900-af9c-92738ea8aace devid
5 transid 191375 /dev/sdd
...
[    3.397936] device fsid 7feedf1e-9711-4900-af9c-92738ea8aace devid
3 transid 191375 /dev/sda3
[    3.399260] btrfs: enabling inode map caching
[    3.399263] btrfs: disk space caching is enabled
[   31.647466] btrfs: unlinked 1 orphans
[  148.625870] btrfs: unlinked 9 orphans
[  150.308382] auto deleting 2158
[  150.308576] auto deleting 2157
[  150.308627] auto deleting 2156
[  150.308671] auto deleting 2155
[  150.308715] auto deleting 2154
[  150.308763] auto deleting 2153
[  150.308808] auto deleting 2152
[  150.308851] auto deleting 2151
[  150.308898] auto deleting 2150
[  150.308944] auto deleting 2149
[  150.309004] auto deleting 2148
[  150.309090] auto deleting 2147
[  150.309148] auto deleting 2146
[  150.309210] auto deleting 2145
[  150.309287] auto deleting 2144
[  150.309343] auto deleting 2143
[  150.309398] auto deleting 2142
[  150.309460] auto deleting 2141
[  150.309517] auto deleting 2140
[  150.309574] auto deleting 2139
[  150.309653] auto deleting 2138
[  150.309715] auto deleting 2137
[  150.309772] auto deleting 2136
[  150.309829] auto deleting 2134
[  150.309885] auto deleting 2132
[  150.309967] auto deleting 2128
[  150.310023] auto deleting 2127
[  150.310077] auto deleting 2126
[  150.312906] btrfs: continuing balance

As soon as I could log in, I cancelled the balance.

-- 
Jon
Software Blacksmith
