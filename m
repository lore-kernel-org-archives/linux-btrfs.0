Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60996 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3CCN57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 08:57:59 -0500
Received: by mail-ee0-f47.google.com with SMTP id e52so3292651eek.34
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Mar 2013 05:57:57 -0800 (PST)
Message-ID: <513356D5.5030301@gmail.com>
Date: Sun, 03 Mar 2013 14:57:41 +0100
From: Michael Schmitt <tcwardrobe@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: weird kernel-oopses while deleting files on btrfs
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

some rather unexpected btrfs-oopses for my taste. I use btrfs for some 
time now (mostly on external harddisks) and these "oopses" happened 
during some simple file and folder deletion operation on that device. It 
is a luks-encrypted 80GB drive. Anything like that known? And the fs was 
created just yesterday, how come there is a message like...

[91491.919358] btrfs: mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.

... but the kernel used (3.7.3 from Debian experimental on Debian sid) 
was installed several days ago. What kind of oopses are these? As of now 
there is no real data on that device. But if there were, would I need to 
be concerned about the integrity of those files?

ii  btrfs-tools                                   0.19+20130131-2 (if 
that matters)

The whole log is at http://paste.debian.net/hidden/6ee00823/ (if a mua 
fails to display the text unwrapped) and a copy right here:

[91491.900736] device label samsung_S0DWJ30L373663 devid 1 transid 10 /dev/mapper/udisks-luks-uuid-64e6f540-8df0-49b2-af3d-ea18e07355d2-uid1000
[91491.904416] btrfs: disk space caching is enabled
[91491.919358] btrfs: mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.
[91978.944644] device label seagate_W1E2Z3TA devid 1 transid 439 /dev/dm-8
[91979.320743] device label seagate_W1E2Z3TA devid 1 transid 439 /dev/mapper/udisks-luks-uuid-24593edd-349c-451f-9b6d-eab1120471f6-uid1000
[91979.322221] btrfs: disk space caching is enabled
[93283.761960] btrfs: block rsv returned -28
[93283.761965] ------------[ cut here ]------------
[93283.762006] WARNING: at /build/buildd-linux_3.7.3-1~experimental.1-i386-eX5kUQ/linux-3.7.3/fs/btrfs/extent-tree.c:6297 btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]()
[93283.762010] Hardware name: System Product Name
[93283.762012] Modules linked in: hid_logitech usbhid ff_memless ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace ppdev lp bnep rfcomm bluetooth rfkill binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd dns_resolver fscache sunrpc bridge stp llc ext4 crc16 jbd2 hwmon_vid loop fuse snd_hda_codec_analog snd_wavefront snd_cs4236 snd_hda_intel btrfs sg snd_opl3_lib sr_mod snd_hda_codec nouveau snd_hwdep cdrom snd_pcm_oss crc32c libcrc32c zlib_deflate snd_wss_lib joydev usb_storage hid_generic sata_sil snd_mpu401 snd_mixer_oss snd_mpu401_uart coretemp kvm_intel usbled snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq mxm_wmi wmi video snd_seq_device snd_timer ttm i2c_i801 iTCO_wdt snd ns558 drm_kms_helper drm i2c_algo_bit soundcore gameport iTCO_vendor_support kvm lpc_ich mfd_core rng_core pcspkr i2c_core psmouse evdev acpi_cpufreq mperf parport_pc parport processor r8169 mii serio_raw ehci_hcd asus_atk0110 thermal_sys button ext3 mbcache jbd dm_crypt dm_mod raid1 md_mod sha256_generic aes_i586 cbc hid sd_mod crc_t10dif ata_generic microcode ata_piix uhci_hcd libata scsi_mod usbcore usb_common [last unloaded: usbhid]
[93283.762149] Pid: 10948, comm: pool Not tainted 3.7-trunk-686-pae #1 Debian 3.7.3-1~experimental.1
[93283.762151] Call Trace:
[93283.762160]  [<c10310a1>] ? warn_slowpath_common+0x68/0x79
[93283.762187]  [<fbe07206>] ? btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]
[93283.762193]  [<c10310bf>] ? warn_slowpath_null+0xd/0x10
[93283.762219]  [<fbe07206>] ? btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]
[93283.762226]  [<c10b9541>] ? page_address+0x1b/0x85
[93283.762254]  [<fbe0ed11>] ? btrfs_header_generation.isra.75+0xb/0x14 [btrfs]
[93283.762277]  [<fbdf929c>] ? __btrfs_cow_block+0xfb/0x3b4 [btrfs]
[93283.762301]  [<fbdfa8b9>] ? read_block_for_search.isra.42+0x91/0x31e [btrfs]
[93283.762325]  [<fbdf966d>] ? btrfs_cow_block+0xe2/0x11f [btrfs]
[93283.762349]  [<fbdfbea3>] ? btrfs_search_slot+0x1e6/0x5ab [btrfs]
[93283.762377]  [<fbe0c613>] ? btrfs_del_csums+0xd7/0x30a [btrfs]
[93283.762402]  [<fbe029d7>] ? __btrfs_free_extent+0x5f8/0x67f [btrfs]
[93283.762428]  [<fbe0654e>] ? run_clustered_refs+0x7a7/0x803 [btrfs]
[93283.762435]  [<c10a89ec>] ? __set_page_dirty_nobuffers+0x11/0xb7
[93283.762462]  [<fbe088f2>] ? btrfs_run_delayed_refs+0xe7/0x220 [btrfs]
[93283.762491]  [<fbe151c4>] ? __btrfs_end_transaction+0xfb/0x275 [btrfs]
[93283.762521]  [<fbe1df70>] ? btrfs_evict_inode+0x277/0x2a1 [btrfs]
[93283.762528]  [<c10eae11>] ? evict+0x89/0x122
[93283.762533]  [<c10e3721>] ? do_unlinkat+0xcc/0x108
[93283.762538]  [<c10dbc57>] ? fput+0xc/0x8a
[93283.762543]  [<c10e6b16>] ? sys_getdents64+0xaa/0xc4
[93283.762549]  [<c12ecd4d>] ? sysenter_do_call+0x12/0x28
[93283.762555]  [<c12e007b>] ? set_cpu_sibling_map+0x2cf/0x2e5
[93283.762560]  [<c12e0000>] ? set_cpu_sibling_map+0x254/0x2e5
[93283.762563] ---[ end trace df33f1170ca5b533 ]---
[93283.762697] btrfs: block rsv returned -28
[93283.762699] ------------[ cut here ]------------
[93283.762725] WARNING: at /build/buildd-linux_3.7.3-1~experimental.1-i386-eX5kUQ/linux-3.7.3/fs/btrfs/extent-tree.c:6297 btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]()
[93283.762728] Hardware name: System Product Name
[93283.762730] Modules linked in: hid_logitech usbhid ff_memless ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace ppdev lp bnep rfcomm bluetooth rfkill binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd dns_resolver fscache sunrpc bridge stp llc ext4 crc16 jbd2 hwmon_vid loop fuse snd_hda_codec_analog snd_wavefront snd_cs4236 snd_hda_intel btrfs sg snd_opl3_lib sr_mod snd_hda_codec nouveau snd_hwdep cdrom snd_pcm_oss crc32c libcrc32c zlib_deflate snd_wss_lib joydev usb_storage hid_generic sata_sil snd_mpu401 snd_mixer_oss snd_mpu401_uart coretemp kvm_intel usbled snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq mxm_wmi wmi video snd_seq_device snd_timer ttm i2c_i801 iTCO_wdt snd ns558 drm_kms_helper drm i2c_algo_bit soundcore gameport iTCO_vendor_support kvm lpc_ich mfd_core rng_core pcspkr i2c_core psmouse evdev acpi_cpufreq mperf parport_pc parport processor r8169 mii serio_raw ehci_hcd asus_atk0110 thermal_sys button ext3 mbcache jbd dm_crypt dm_mod raid1 md_mod sha256_generic aes_i586 cbc hid sd_mod crc_t10dif ata_generic microcode ata_piix uhci_hcd libata scsi_mod usbcore usb_common [last unloaded: usbhid]
[93283.762855] Pid: 10948, comm: pool Tainted: G        W    3.7-trunk-686-pae #1 Debian 3.7.3-1~experimental.1
[93283.762858] Call Trace:
[93283.762863]  [<c10310a1>] ? warn_slowpath_common+0x68/0x79
[93283.762889]  [<fbe07206>] ? btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]
[93283.762895]  [<c10310bf>] ? warn_slowpath_null+0xd/0x10
[93283.762921]  [<fbe07206>] ? btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]
[93283.762927]  [<c10b9541>] ? page_address+0x1b/0x85
[93283.762954]  [<fbe0ed11>] ? btrfs_header_generation.isra.75+0xb/0x14 [btrfs]
[93283.762978]  [<fbdf929c>] ? __btrfs_cow_block+0xfb/0x3b4 [btrfs]
[93283.763001]  [<fbdfa8b9>] ? read_block_for_search.isra.42+0x91/0x31e [btrfs]
[93283.763025]  [<fbdf966d>] ? btrfs_cow_block+0xe2/0x11f [btrfs]
[93283.763049]  [<fbdfbea3>] ? btrfs_search_slot+0x1e6/0x5ab [btrfs]
[93283.763076]  [<fbe0c613>] ? btrfs_del_csums+0xd7/0x30a [btrfs]
[93283.763102]  [<fbe029d7>] ? __btrfs_free_extent+0x5f8/0x67f [btrfs]
[93283.763128]  [<fbe0654e>] ? run_clustered_refs+0x7a7/0x803 [btrfs]
[93283.763133]  [<c10a89ec>] ? __set_page_dirty_nobuffers+0x11/0xb7
[93283.763161]  [<fbe088f2>] ? btrfs_run_delayed_refs+0xe7/0x220 [btrfs]
[93283.763189]  [<fbe151c4>] ? __btrfs_end_transaction+0xfb/0x275 [btrfs]
[93283.763219]  [<fbe1df70>] ? btrfs_evict_inode+0x277/0x2a1 [btrfs]
[93283.763225]  [<c10eae11>] ? evict+0x89/0x122
[93283.763229]  [<c10e3721>] ? do_unlinkat+0xcc/0x108
[93283.763234]  [<c10dbc57>] ? fput+0xc/0x8a
[93283.763238]  [<c10e6b16>] ? sys_getdents64+0xaa/0xc4
[93283.763243]  [<c12ecd4d>] ? sysenter_do_call+0x12/0x28
[93283.763248]  [<c12e007b>] ? set_cpu_sibling_map+0x2cf/0x2e5
[93283.763253]  [<c12e0000>] ? set_cpu_sibling_map+0x254/0x2e5
[93283.763256] ---[ end trace df33f1170ca5b534 ]---
[94951.373618] use_block_rsv: 1647 callbacks suppressed
[94951.373622] btrfs: block rsv returned -28
[94951.373625] ------------[ cut here ]------------
[94951.373664] WARNING: at /build/buildd-linux_3.7.3-1~experimental.1-i386-eX5kUQ/linux-3.7.3/fs/btrfs/extent-tree.c:6297 btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]()
[94951.373668] Hardware name: System Product Name
[94951.373670] Modules linked in: hid_logitech usbhid ff_memless ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace ppdev lp bnep rfcomm bluetooth rfkill binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd dns_resolver fscache sunrpc bridge stp llc ext4 crc16 jbd2 hwmon_vid loop fuse snd_hda_codec_analog snd_wavefront snd_cs4236 snd_hda_intel btrfs sg snd_opl3_lib sr_mod snd_hda_codec nouveau snd_hwdep cdrom snd_pcm_oss crc32c libcrc32c zlib_deflate snd_wss_lib joydev usb_storage hid_generic sata_sil snd_mpu401 snd_mixer_oss snd_mpu401_uart coretemp kvm_intel usbled snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq mxm_wmi wmi video snd_seq_device snd_timer ttm i2c_i801 iTCO_wdt snd ns558 drm_kms_helper drm i2c_algo_bit soundcore gameport iTCO_vendor_support kvm lpc_ich mfd_core rng_core pcspkr i2c_core psmouse evdev acpi_cpufreq mperf parport_pc parport processor r8169 mii serio_raw ehci_hcd asus_atk0110 thermal_sys button ext3 mbcache jbd dm_crypt dm_mod raid1 md_mod sha256_generic aes_i586 cbc hid sd_mod crc_t10dif ata_generic microcode ata_piix uhci_hcd libata scsi_mod usbcore usb_common [last unloaded: usbhid]
[94951.373806] Pid: 15223, comm: pool Tainted: G        W    3.7-trunk-686-pae #1 Debian 3.7.3-1~experimental.1
[94951.373808] Call Trace:
[94951.373817]  [<c10310a1>] ? warn_slowpath_common+0x68/0x79
[94951.373844]  [<fbe07206>] ? btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]
[94951.373850]  [<c10310bf>] ? warn_slowpath_null+0xd/0x10
[94951.373876]  [<fbe07206>] ? btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]
[94951.373883]  [<c10b9541>] ? page_address+0x1b/0x85
[94951.373911]  [<fbe0ed11>] ? btrfs_header_generation.isra.75+0xb/0x14 [btrfs]
[94951.373935]  [<fbdf929c>] ? __btrfs_cow_block+0xfb/0x3b4 [btrfs]
[94951.373959]  [<fbdfa8b9>] ? read_block_for_search.isra.42+0x91/0x31e [btrfs]
[94951.373964]  [<c10b9541>] ? page_address+0x1b/0x85
[94951.373988]  [<fbdf966d>] ? btrfs_cow_block+0xe2/0x11f [btrfs]
[94951.374012]  [<fbdfbea3>] ? btrfs_search_slot+0x1e6/0x5ab [btrfs]
[94951.374017]  [<c10865dd>] ? __call_rcu+0xb1/0x16f
[94951.374045]  [<fbe0c613>] ? btrfs_del_csums+0xd7/0x30a [btrfs]
[94951.374070]  [<fbe029d7>] ? __btrfs_free_extent+0x5f8/0x67f [btrfs]
[94951.374096]  [<fbe0654e>] ? run_clustered_refs+0x7a7/0x803 [btrfs]
[94951.374124]  [<fbe088f2>] ? btrfs_run_delayed_refs+0xe7/0x220 [btrfs]
[94951.374153]  [<fbe15187>] ? __btrfs_end_transaction+0xbe/0x275 [btrfs]
[94951.374183]  [<fbe1deec>] ? btrfs_evict_inode+0x1f3/0x2a1 [btrfs]
[94951.374189]  [<c1047ef7>] ? autoremove_wake_function+0x29/0x29
[94951.374195]  [<c10eae11>] ? evict+0x89/0x122
[94951.374201]  [<c10e3721>] ? do_unlinkat+0xcc/0x108
[94951.374206]  [<c1050bb1>] ? should_resched+0x5/0x1e
[94951.374211]  [<c12e808e>] ? _cond_resched+0x5/0x18
[94951.374217]  [<c117b9da>] ? copy_to_user+0x2b/0x48
[94951.374223]  [<c12ecd4d>] ? sysenter_do_call+0x12/0x28
[94951.374229]  [<c12e0000>] ? set_cpu_sibling_map+0x254/0x2e5
[94951.374232] ---[ end trace df33f1170ca5b535 ]---
[94951.374253] btrfs: block rsv returned -28
[94951.374255] ------------[ cut here ]------------
[94951.374281] WARNING: at /build/buildd-linux_3.7.3-1~experimental.1-i386-eX5kUQ/linux-3.7.3/fs/btrfs/extent-tree.c:6297 btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]()
[94951.374284] Hardware name: System Product Name
[94951.374286] Modules linked in: hid_logitech usbhid ff_memless ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace ppdev lp bnep rfcomm bluetooth rfkill binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd dns_resolver fscache sunrpc bridge stp llc ext4 crc16 jbd2 hwmon_vid loop fuse snd_hda_codec_analog snd_wavefront snd_cs4236 snd_hda_intel btrfs sg snd_opl3_lib sr_mod snd_hda_codec nouveau snd_hwdep cdrom snd_pcm_oss crc32c libcrc32c zlib_deflate snd_wss_lib joydev usb_storage hid_generic sata_sil snd_mpu401 snd_mixer_oss snd_mpu401_uart coretemp kvm_intel usbled snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq mxm_wmi wmi video snd_seq_device snd_timer ttm i2c_i801 iTCO_wdt snd ns558 drm_kms_helper drm i2c_algo_bit soundcore gameport iTCO_vendor_support kvm lpc_ich mfd_core rng_core pcspkr i2c_core psmouse evdev acpi_cpufreq mperf parport_pc parport processor r8169 mii serio_raw ehci_hcd asus_atk0110 thermal_sys button ext3 mbcache jbd dm_crypt dm_mod raid1 md_mod sha256_generic aes_i586 cbc hid sd_mod crc_t10dif ata_generic microcode ata_piix uhci_hcd libata scsi_mod usbcore usb_common [last unloaded: usbhid]
[94951.374410] Pid: 15223, comm: pool Tainted: G        W    3.7-trunk-686-pae #1 Debian 3.7.3-1~experimental.1
[94951.374413] Call Trace:
[94951.374418]  [<c10310a1>] ? warn_slowpath_common+0x68/0x79
[94951.374444]  [<fbe07206>] ? btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]
[94951.374449]  [<c10310bf>] ? warn_slowpath_null+0xd/0x10
[94951.374475]  [<fbe07206>] ? btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]
[94951.374500]  [<fbe0018d>] ? block_group_cache_tree_search+0xc5/0xcf [btrfs]
[94951.374523]  [<fbdf929c>] ? __btrfs_cow_block+0xfb/0x3b4 [btrfs]
[94951.374554]  [<fbe2df29>] ? map_private_extent_buffer+0x7a/0x9d [btrfs]
[94951.374584]  [<fbe25d83>] ? btrfs_get_token_32+0x6c/0xaf [btrfs]
[94951.374608]  [<fbdf966d>] ? btrfs_cow_block+0xe2/0x11f [btrfs]
[94951.374631]  [<fbdfb12c>] ? push_leaf_left+0x93/0xf6 [btrfs]
[94951.374655]  [<fbdfd28e>] ? btrfs_del_items+0x1de/0x280 [btrfs]
[94951.374685]  [<fbe2df29>] ? map_private_extent_buffer+0x7a/0x9d [btrfs]
[94951.374713]  [<fbe0c703>] ? btrfs_del_csums+0x1c7/0x30a [btrfs]
[94951.374738]  [<fbe029d7>] ? __btrfs_free_extent+0x5f8/0x67f [btrfs]
[94951.374764]  [<fbe0654e>] ? run_clustered_refs+0x7a7/0x803 [btrfs]
[94951.374792]  [<fbe088f2>] ? btrfs_run_delayed_refs+0xe7/0x220 [btrfs]
[94951.374821]  [<fbe15187>] ? __btrfs_end_transaction+0xbe/0x275 [btrfs]
[94951.374850]  [<fbe1deec>] ? btrfs_evict_inode+0x1f3/0x2a1 [btrfs]
[94951.374855]  [<c1047ef7>] ? autoremove_wake_function+0x29/0x29
[94951.374861]  [<c10eae11>] ? evict+0x89/0x122
[94951.374865]  [<c10e3721>] ? do_unlinkat+0xcc/0x108
[94951.374870]  [<c1050bb1>] ? should_resched+0x5/0x1e
[94951.374875]  [<c12e808e>] ? _cond_resched+0x5/0x18
[94951.374879]  [<c117b9da>] ? copy_to_user+0x2b/0x48
[94951.374884]  [<c12ecd4d>] ? sysenter_do_call+0x12/0x28
[94951.374889]  [<c12e0000>] ? set_cpu_sibling_map+0x254/0x2e5
[94951.374892] ---[ end trace df33f1170ca5b536 ]---

regards
Michael

