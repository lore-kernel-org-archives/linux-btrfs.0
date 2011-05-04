From: whirm@gmx.com
Subject: kernel BUG at fs/btrfs/inode.c:149!
Date: Wed, 4 May 2011 16:26:35 +0200
Message-ID: <201105041626.36039.whirm@gmx.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_cIWwNab6kem8mhE"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Boundary-00=_cIWwNab6kem8mhE
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a traceback from a failed attempt to mount a btrfs in lvm in luks  
filesystem.

Note that if I mount it readonly it mounts successfully (haven't tried to 
recover any data as I have recent backups).

Yesterday I defragmented both / and /home with:

find /home -xdev -type f -print0 | xargs -0 sudo ./btrfs filesystem defragment 
-c

with btrfs-tools v0.19-35-g1b444cd and rebooted a couple of times. And today I 
got this traceback while trying to mount home at boot time (/ is working ok)

btrfsck fails with the following error:

couldn't open because of unsupported option features (8).
btrfsck: disk-io.c:682: open_ctree_fd: Assertion `!(1)' failed.

I'm using a 2.6.39-rc5+ kernel from Linus' tree.

If someone needs any extra info, just ask for it, Ill keep the corrupted 
filesystem for a few days before destroying it.

Thanks.

-- 

Elric Milon

--Boundary-00=_cIWwNab6kem8mhE
Content-Type: text/x-log;
  charset="UTF-8";
  name="trackeback-btrfs.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="trackeback-btrfs.log"

[ 2821.536431] device label home devid 1 transid 94826 /dev/mapper/volumes-home--fotut
[ 2821.611807] btrfs: disk space caching is enabled
[ 2845.785626] device label home devid 1 transid 94826 /dev/mapper/volumes-home--fotut
[ 2845.852420] btrfs: disk space caching is enabled
[ 2846.133252] ------------[ cut here ]------------
[ 2846.133284] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.133286] Hardware name: Latitude E4300                  
[ 2846.133288] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.133332] Pid: 10611, comm: mount Not tainted 2.6.39-rc5+ #36
[ 2846.133334] Call Trace:
[ 2846.133341]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.133345]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.133361]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.133377]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.133393]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.133406]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.133419]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.133424]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.133428]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.133441]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.133455]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.133472]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.133488]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.133500]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.133511]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.133523]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.133535]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.133552]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.133555]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.133572]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.133575]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.133592]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.133607]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.133620]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.133624]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.133627]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.133632]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.133635]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.133639]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.133643]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.133646]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.133650]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.133653]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.133656]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.133661]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.133664] ---[ end trace bbe9330ec7714672 ]---
[ 2846.133667] ------------[ cut here ]------------
[ 2846.133682] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.133684] Hardware name: Latitude E4300                  
[ 2846.133686] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.133723] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.133725] Call Trace:
[ 2846.133729]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.133732]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.133748]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.133764]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.133780]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.133793]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.133806]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.133809]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.133813]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.133826]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.133840]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.133856]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.133872]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.133884]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.133896]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.133907]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.133919]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.133936]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.133939]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.133956]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.133959]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.133975]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.133991]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.134003]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.134023]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.134026]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.134031]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.134035]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.134040]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.134044]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.134048]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.134052]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.134056]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.134060]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.134064]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.134068] ---[ end trace bbe9330ec7714673 ]---
[ 2846.134074] ------------[ cut here ]------------
[ 2846.134090] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.134092] Hardware name: Latitude E4300                  
[ 2846.134094] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.134147] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.134149] Call Trace:
[ 2846.134154]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.134158]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.134174]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.134191]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.134207]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.134222]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.134236]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.134241]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.134245]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.134259]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.134274]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.134291]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.134308]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.134321]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.134333]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.134346]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.134359]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.134377]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.134381]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.134398]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.134403]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.134420]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.134437]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.134451]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.134454]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.134458]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.134463]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.134467]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.134471]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.134476]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.134479]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.134483]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.134487]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.134491]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.134495]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.134499] ---[ end trace bbe9330ec7714674 ]---
[ 2846.134501] ------------[ cut here ]------------
[ 2846.134517] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.134520] Hardware name: Latitude E4300                  
[ 2846.134522] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.134574] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.134577] Call Trace:
[ 2846.134581]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.134585]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.134601]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.134618]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.134634]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.134649]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.134663]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.134667]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.134672]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.134686]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.134701]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.134718]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.134735]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.134747]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.134760]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.134773]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.134786]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.134803]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.134807]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.134824]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.134829]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.134846]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.134862]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.134876]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.134880]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.134884]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.134889]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.134892]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.134896]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.134901]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.134905]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.134909]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.134912]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.134916]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.134920]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.134924] ---[ end trace bbe9330ec7714675 ]---
[ 2846.134927] ------------[ cut here ]------------
[ 2846.134942] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.134945] Hardware name: Latitude E4300                  
[ 2846.134947] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.135010] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.135012] Call Trace:
[ 2846.135017]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.135022]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.135038]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.135055]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.135071]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.135086]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.135100]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.135104]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.135109]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.135123]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.135137]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.135155]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.135172]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.135184]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.135197]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.135209]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.135222]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.135239]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.135243]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.135261]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.135265]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.135282]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.135299]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.135312]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.135316]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.135320]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.135325]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.135328]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.135333]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.135337]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.135341]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.135345]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.135349]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.135353]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.135357]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.135360] ---[ end trace bbe9330ec7714676 ]---
[ 2846.135363] ------------[ cut here ]------------
[ 2846.135378] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.135381] Hardware name: Latitude E4300                  
[ 2846.135383] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.135436] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.135438] Call Trace:
[ 2846.135442]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.135447]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.135463]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.135479]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.135496]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.135511]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.135525]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.135529]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.135534]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.135548]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.135563]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.135580]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.135596]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.135609]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.135621]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.135634]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.135647]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.135665]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.135669]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.135686]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.135691]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.135707]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.135724]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.135738]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.135742]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.135745]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.135750]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.135754]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.135758]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.135762]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.135766]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.135770]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.135774]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.135778]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.135782]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.135785] ---[ end trace bbe9330ec7714677 ]---
[ 2846.135788] ------------[ cut here ]------------
[ 2846.135803] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.135806] Hardware name: Latitude E4300                  
[ 2846.135808] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.135848] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.135850] Call Trace:
[ 2846.135854]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.135857]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.135873]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.135888]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.135904]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.135917]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.135930]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.135934]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.135937]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.135950]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.135964]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.135981]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.135997]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.136020]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.136033]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.136046]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.136058]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.136076]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.136080]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.136098]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.136102]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.136119]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.136136]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.136149]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.136153]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.136157]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.136162]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.136165]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.136169]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.136174]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.136178]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.136182]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.136186]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.136190]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.136194]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.136197] ---[ end trace bbe9330ec7714678 ]---
[ 2846.136200] ------------[ cut here ]------------
[ 2846.136215] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.136218] Hardware name: Latitude E4300                  
[ 2846.136220] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.136273] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.136275] Call Trace:
[ 2846.136280]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.136284]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.136300]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.136317]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.136333]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.136348]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.136362]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.136366]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.136371]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.136385]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.136400]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.136417]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.136434]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.136447]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.136459]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.136472]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.136485]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.136502]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.136506]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.136524]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.136529]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.136546]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.136562]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.136576]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.136579]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.136583]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.136588]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.136592]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.136596]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.136600]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.136604]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.136608]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.136612]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.136617]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.136621]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.136624] ---[ end trace bbe9330ec7714679 ]---
[ 2846.136627] ------------[ cut here ]------------
[ 2846.136642] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.136645] Hardware name: Latitude E4300                  
[ 2846.136647] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.136700] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.136703] Call Trace:
[ 2846.136707]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.136712]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.136728]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.136744]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.136761]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.136775]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.136789]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.136793]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.136798]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.136812]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.136826]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.136844]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.136860]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.136873]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.136886]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.136898]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.136911]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.136929]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.136933]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.136951]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.136955]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.136972]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.136989]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.137003]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.137017]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.137021]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.137026]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.137030]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.137034]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.137038]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.137042]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.137046]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.137050]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.137054]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.137058]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.137061] ---[ end trace bbe9330ec771467a ]---
[ 2846.137114] ------------[ cut here ]------------
[ 2846.137130] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.137133] Hardware name: Latitude E4300                  
[ 2846.137135] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.137188] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.137190] Call Trace:
[ 2846.137195]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.137200]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.137216]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.137232]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.137249]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.137263]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.137277]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.137281]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.137286]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.137300]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.137314]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.137332]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.137348]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.137361]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.137374]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.137387]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.137400]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.137417]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.137421]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.137439]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.137443]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.137460]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.137477]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.137490]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.137494]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.137498]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.137503]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.137506]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.137510]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.137515]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.137519]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.137523]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.137526]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.137531]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.137535]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.137538] ---[ end trace bbe9330ec771467b ]---
[ 2846.137541] ------------[ cut here ]------------
[ 2846.137556] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.137559] Hardware name: Latitude E4300                  
[ 2846.137561] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.137599] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.137600] Call Trace:
[ 2846.137604]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.137608]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.137623]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.137639]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.137654]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.137668]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.137681]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.137684]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.137688]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.137701]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.137715]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.137733]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.137749]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.137762]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.137774]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.137787]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.137800]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.137817]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.137822]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.137839]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.137844]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.137861]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.137878]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.137891]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.137895]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.137899]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.137904]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.137907]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.137912]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.137916]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.137920]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.137924]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.137928]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.137932]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.137936]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.137939] ---[ end trace bbe9330ec771467c ]---
[ 2846.137941] ------------[ cut here ]------------
[ 2846.137956] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.137959] Hardware name: Latitude E4300                  
[ 2846.137961] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.138023] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.138026] Call Trace:
[ 2846.138030]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.138035]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.138051]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.138067]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.138084]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.138099]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.138112]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.138117]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.138121]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.138136]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.138150]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.138167]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.138184]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.138197]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.138209]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.138222]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.138235]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.138252]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.138256]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.138273]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.138278]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.138295]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.138311]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.138325]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.138329]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.138332]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.138338]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.138341]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.138345]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.138350]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.138354]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.138357]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.138361]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.138365]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.138370]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.138373] ---[ end trace bbe9330ec771467d ]---
[ 2846.138376] ------------[ cut here ]------------
[ 2846.138391] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.138394] Hardware name: Latitude E4300                  
[ 2846.138396] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.138450] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.138452] Call Trace:
[ 2846.138456]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.138461]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.138477]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.138494]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.138510]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.138524]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.138538]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.138542]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.138547]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.138561]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.138575]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.138592]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.138609]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.138622]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.138634]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.138647]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.138660]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.138677]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.138681]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.138698]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.138703]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.138720]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.138736]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.138750]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.138754]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.138757]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.138762]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.138765]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.138770]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.138774]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.138778]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.138782]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.138785]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.138789]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.138793]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.138797] ---[ end trace bbe9330ec771467e ]---
[ 2846.138799] ------------[ cut here ]------------
[ 2846.138814] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.138817] Hardware name: Latitude E4300                  
[ 2846.138818] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.138870] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.138872] Call Trace:
[ 2846.138877]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.138881]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.138897]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.138913]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.138930]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.138944]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.138958]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.138963]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.138968]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.138982]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.138997]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.139024]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.139041]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.139054]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.139066]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.139079]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.139092]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.139109]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.139113]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.139131]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.139135]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.139152]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.139168]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.139182]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.139186]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.139189]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.139194]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.139197]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.139202]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.139206]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.139210]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.139214]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.139217]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.139222]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.139226]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.139229] ---[ end trace bbe9330ec771467f ]---
[ 2846.139231] ------------[ cut here ]------------
[ 2846.139246] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.139249] Hardware name: Latitude E4300                  
[ 2846.139251] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.139302] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.139305] Call Trace:
[ 2846.139309]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.139313]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.139329]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.139346]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.139362]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.139377]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.139391]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.139395]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.139400]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.139413]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.139428]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.139445]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.139462]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.139475]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.139487]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.139500]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.139513]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.139530]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.139534]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.139551]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.139554]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.139570]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.139585]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.139597]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.139600]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.139603]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.139607]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.139610]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.139613]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.139617]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.139620]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.139623]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.139626]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.139629]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.139633]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.139635] ---[ end trace bbe9330ec7714680 ]---
[ 2846.139637] ------------[ cut here ]------------
[ 2846.139652] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[ 2846.139654] Hardware name: Latitude E4300                  
[ 2846.139655] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.139698] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.139700] Call Trace:
[ 2846.139704]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.139709]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.139725]  [<ffffffffa014ef9c>] tree_insert_offset+0x77/0xbc [btrfs]
[ 2846.139741]  [<ffffffffa014f277>] link_free_space+0x3b/0x53 [btrfs]
[ 2846.139758]  [<ffffffffa0150e1e>] load_free_space_cache+0x47e/0x69a [btrfs]
[ 2846.139773]  [<ffffffffa0112481>] cache_block_group+0x9c/0x244 [btrfs]
[ 2846.139786]  [<ffffffffa0116338>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[ 2846.139791]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[ 2846.139795]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.139809]  [<ffffffffa01171ac>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[ 2846.139824]  [<ffffffffa011779b>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[ 2846.139841]  [<ffffffffa013c066>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[ 2846.139858]  [<ffffffffa014018f>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[ 2846.139871]  [<ffffffffa010a8d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[ 2846.139883]  [<ffffffffa0109316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[ 2846.139896]  [<ffffffffa010abee>] btrfs_cow_block+0x100/0x176 [btrfs]
[ 2846.139909]  [<ffffffffa010dc10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[ 2846.139926]  [<ffffffffa012a1cd>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[ 2846.139930]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.139948]  [<ffffffffa012aa97>] btrfs_truncate+0x41a/0x4db [btrfs]
[ 2846.139952]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.139969]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.139986]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.140000]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.140014]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.140018]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.140022]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.140026]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.140030]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.140034]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.140038]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.140042]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.140045]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.140050]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.140054]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.140057] ---[ end trace bbe9330ec7714681 ]---
[ 2846.140095] block group 135614431232 has an wrong amount of free space
[ 2846.207234] ------------[ cut here ]------------
[ 2846.207268] WARNING: at fs/btrfs/file.c:368 btrfs_drop_extents+0x27f/0x6f5 [btrfs]()
[ 2846.207271] Hardware name: Latitude E4300                  
[ 2846.207274] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.207332] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36
[ 2846.207335] Call Trace:
[ 2846.207343]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[ 2846.207348]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[ 2846.207373]  [<ffffffffa012f6e5>] btrfs_drop_extents+0x27f/0x6f5 [btrfs]
[ 2846.207398]  [<ffffffffa0128424>] cow_file_range_inline+0xde/0x15c [btrfs]
[ 2846.207423]  [<ffffffffa012856c>] cow_file_range+0xca/0x307 [btrfs]
[ 2846.207429]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.207453]  [<ffffffffa0128e2e>] run_delalloc_range+0xa6/0x324 [btrfs]
[ 2846.207479]  [<ffffffffa013c34b>] ? free_extent_state+0x17/0x46 [btrfs]
[ 2846.207504]  [<ffffffffa013dd87>] ? find_lock_delalloc_range.constprop.25+0x188/0x1b1 [btrfs]
[ 2846.207530]  [<ffffffffa013e62f>] __extent_writepage+0x1d5/0x5ba [btrfs]
[ 2846.207554]  [<ffffffffa0140599>] ? map_private_extent_buffer+0xaa/0xcd [btrfs]
[ 2846.207559]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.207563]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.207567]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.207572]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.207598]  [<ffffffffa013eb52>] extent_write_cache_pages.isra.14.constprop.22+0x13e/0x276 [btrfs]
[ 2846.207625]  [<ffffffffa013eedb>] extent_writepages+0x3e/0x4f [btrfs]
[ 2846.207649]  [<ffffffffa01261cc>] ? uncompress_inline.isra.41+0x113/0x113 [btrfs]
[ 2846.207655]  [<ffffffff810db06e>] ? kmem_cache_free+0x17/0xba
[ 2846.207680]  [<ffffffffa0125158>] btrfs_writepages+0x23/0x25 [btrfs]
[ 2846.207686]  [<ffffffff810b159a>] do_writepages+0x1c/0x25
[ 2846.207690]  [<ffffffff810aaa8b>] __filemap_fdatawrite_range+0x4b/0x4d
[ 2846.207695]  [<ffffffff810ab618>] filemap_fdatawrite_range+0xe/0x10
[ 2846.207720]  [<ffffffffa013b20e>] btrfs_wait_ordered_range+0x56/0x124 [btrfs]
[ 2846.207745]  [<ffffffffa012a952>] btrfs_truncate+0x2d5/0x4db [btrfs]
[ 2846.207770]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.207793]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.207812]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.207817]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.207821]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.207828]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.207832]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.207838]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.207843]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.207848]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.207853]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.207858]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.207863]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.207868]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.207872] ---[ end trace bbe9330ec7714682 ]---
[ 2846.207900] ------------[ cut here ]------------
[ 2846.207946] kernel BUG at fs/btrfs/inode.c:149!
[ 2846.207984] invalid opcode: 0000 [#1] PREEMPT SMP 
[ 2846.208033] last sysfs file: /sys/devices/virtual/bdi/btrfs-4/uevent
[ 2846.208085] CPU 1 
[ 2846.208103] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.208183] 
[ 2846.208183] Pid: 10611, comm: mount Tainted: G        W   2.6.39-rc5+ #36 Dell Inc. Latitude E4300                  /0D201R
[ 2846.208183] RIP: 0010:[<ffffffffa01281c8>]  [<ffffffffa01281c8>] insert_inline_extent+0xab/0x229 [btrfs]
[ 2846.208183] RSP: 0018:ffff880114ad94f8  EFLAGS: 00010282
[ 2846.208183] RAX: 00000000ffffffef RBX: ffff88003e2ff138 RCX: ffff880114ad9340
[ 2846.208183] RDX: ffff8801157e3b18 RSI: 0000000000000000 RDI: ffff880114ad9348
[ 2846.208183] RBP: ffff880114ad9578 R08: ffff880114ad9348 R09: ffff880114ad9350
[ 2846.208183] R10: ffff8800449cc000 R11: ffff8801157e3aa0 R12: ffff880114c11bd0
[ 2846.208183] R13: 0000000000000000 R14: 0000000000000806 R15: ffff8801140a8d40
[ 2846.208183] FS:  00007fb66e98f7e0(0000) GS:ffff88011bd00000(0000) knlGS:0000000000000000
[ 2846.208183] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2846.208183] CR2: 00007fe7c0004208 CR3: 0000000105921000 CR4: 00000000000006e0
[ 2846.208183] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2846.208183] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2846.208183] Process mount (pid: 10611, threadinfo ffff880114ad8000, task ffff8800db7f3d00)
[ 2846.208183] Stack:
[ 2846.208183]  ffff8800449cc000 ffff8800449cc000 0000000000000000 ffff8801140a8d40
[ 2846.208183]  0000000000000000 00000000000007f1 0001000000000000 00000047d5000000
[ 2846.208183]  000000006c000000 0000080600000000 0000000000000000 ffff8800449cc000
[ 2846.208183] Call Trace:
[ 2846.208183]  [<ffffffffa0128463>] cow_file_range_inline+0x11d/0x15c [btrfs]
[ 2846.208183]  [<ffffffffa012856c>] cow_file_range+0xca/0x307 [btrfs]
[ 2846.208183]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.208183]  [<ffffffffa0128e2e>] run_delalloc_range+0xa6/0x324 [btrfs]
[ 2846.208183]  [<ffffffffa013c34b>] ? free_extent_state+0x17/0x46 [btrfs]
[ 2846.208183]  [<ffffffffa013dd87>] ? find_lock_delalloc_range.constprop.25+0x188/0x1b1 [btrfs]
[ 2846.208183]  [<ffffffffa013e62f>] __extent_writepage+0x1d5/0x5ba [btrfs]
[ 2846.208183]  [<ffffffffa0140599>] ? map_private_extent_buffer+0xaa/0xcd [btrfs]
[ 2846.208183]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.208183]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.208183]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.208183]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.208183]  [<ffffffffa013eb52>] extent_write_cache_pages.isra.14.constprop.22+0x13e/0x276 [btrfs]
[ 2846.208183]  [<ffffffffa013eedb>] extent_writepages+0x3e/0x4f [btrfs]
[ 2846.208183]  [<ffffffffa01261cc>] ? uncompress_inline.isra.41+0x113/0x113 [btrfs]
[ 2846.208183]  [<ffffffff810db06e>] ? kmem_cache_free+0x17/0xba
[ 2846.208183]  [<ffffffffa0125158>] btrfs_writepages+0x23/0x25 [btrfs]
[ 2846.208183]  [<ffffffff810b159a>] do_writepages+0x1c/0x25
[ 2846.208183]  [<ffffffff810aaa8b>] __filemap_fdatawrite_range+0x4b/0x4d
[ 2846.208183]  [<ffffffff810ab618>] filemap_fdatawrite_range+0xe/0x10
[ 2846.208183]  [<ffffffffa013b20e>] btrfs_wait_ordered_range+0x56/0x124 [btrfs]
[ 2846.208183]  [<ffffffffa012a952>] btrfs_truncate+0x2d5/0x4db [btrfs]
[ 2846.208183]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.208183]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.208183]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.208183]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.208183]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.208183]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.208183]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.208183]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.208183]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.208183]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.208183]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.208183]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.208183]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.208183]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b
[ 2846.208183] Code: e8 3d e0 fb e0 48 8b 75 88 41 b9 01 00 00 00 48 8b 7d 98 4c 8d 45 cc 4c 89 e2 48 8d 4d bb 44 89 75 cc e8 1b 69 fe ff 85 c0 74 02 <0f> 0b 4d 8b 34 24 41 8b 74 24 40 4c 89 f7 e8 c6 b8 ff ff 48 8b 
[ 2846.208183] RIP  [<ffffffffa01281c8>] insert_inline_extent+0xab/0x229 [btrfs]
[ 2846.208183]  RSP <ffff880114ad94f8>
[ 2846.269334] ---[ end trace bbe9330ec7714683 ]---
[ 2846.269340] note: mount[10611] exited with preempt_count 1
[ 2846.269359] BUG: scheduling while atomic: mount/10611/0x10000002
[ 2846.269363] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm sg sr_mod snd_seq_midi snd_rawmidi snd_seq_midi_event cdrom snd_seq tpm_tis ac tpm i2c_i801 dell_laptop rfkill snd_timer snd_seq_device sdhci_pci tpm_bios snd sdhci soundcore psmouse dcdbas snd_page_alloc mmc_core pcspkr sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[ 2846.269459] Pid: 10611, comm: mount Tainted: G      D W   2.6.39-rc5+ #36
[ 2846.269462] Call Trace:
[ 2846.269470]  [<ffffffff8137ad49>] __schedule_bug+0x57/0x5b
[ 2846.269477]  [<ffffffff81380fa6>] schedule+0x8e/0x68c
[ 2846.269484]  [<ffffffff81034ed2>] __cond_resched+0x13/0x1f
[ 2846.269490]  [<ffffffff8138178d>] _cond_resched+0x14/0x1d
[ 2846.269496]  [<ffffffff810c2e03>] unmap_vmas+0x61c/0x73f
[ 2846.269505]  [<ffffffff810c7ec2>] exit_mmap+0x7c/0xc2
[ 2846.269511]  [<ffffffff810393d1>] mmput+0x56/0xff
[ 2846.269517]  [<ffffffff8103d2a4>] exit_mm+0x12d/0x13a
[ 2846.269522]  [<ffffffff8103e819>] do_exit+0x26a/0x75f
[ 2846.269529]  [<ffffffff810054b2>] oops_end+0xb0/0xb8
[ 2846.269534]  [<ffffffff810055f5>] die+0x55/0x60
[ 2846.269541]  [<ffffffff81002928>] do_trap+0x11c/0x12b
[ 2846.269547]  [<ffffffff81002b76>] do_invalid_op+0x93/0x9c
[ 2846.269572]  [<ffffffffa01281c8>] ? insert_inline_extent+0xab/0x229 [btrfs]
[ 2846.269591]  [<ffffffffa01093f3>] ? unlock_up+0xa7/0xcb [btrfs]
[ 2846.269610]  [<ffffffffa010df2d>] ? btrfs_search_slot+0x45c/0x4fd [btrfs]
[ 2846.269617]  [<ffffffff813844d5>] invalid_op+0x15/0x20
[ 2846.269643]  [<ffffffffa01281c8>] ? insert_inline_extent+0xab/0x229 [btrfs]
[ 2846.269669]  [<ffffffffa01281c4>] ? insert_inline_extent+0xa7/0x229 [btrfs]
[ 2846.269696]  [<ffffffffa0128463>] cow_file_range_inline+0x11d/0x15c [btrfs]
[ 2846.269723]  [<ffffffffa012856c>] cow_file_range+0xca/0x307 [btrfs]
[ 2846.269730]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.269755]  [<ffffffffa0128e2e>] run_delalloc_range+0xa6/0x324 [btrfs]
[ 2846.269781]  [<ffffffffa013c34b>] ? free_extent_state+0x17/0x46 [btrfs]
[ 2846.269807]  [<ffffffffa013dd87>] ? find_lock_delalloc_range.constprop.25+0x188/0x1b1 [btrfs]
[ 2846.269834]  [<ffffffffa013e62f>] __extent_writepage+0x1d5/0x5ba [btrfs]
[ 2846.269859]  [<ffffffffa0140599>] ? map_private_extent_buffer+0xaa/0xcd [btrfs]
[ 2846.269865]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.269871]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.269876]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[ 2846.269882]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[ 2846.269910]  [<ffffffffa013eb52>] extent_write_cache_pages.isra.14.constprop.22+0x13e/0x276 [btrfs]
[ 2846.269939]  [<ffffffffa013eedb>] extent_writepages+0x3e/0x4f [btrfs]
[ 2846.269965]  [<ffffffffa01261cc>] ? uncompress_inline.isra.41+0x113/0x113 [btrfs]
[ 2846.269971]  [<ffffffff810db06e>] ? kmem_cache_free+0x17/0xba
[ 2846.269995]  [<ffffffffa0125158>] btrfs_writepages+0x23/0x25 [btrfs]
[ 2846.270014]  [<ffffffff810b159a>] do_writepages+0x1c/0x25
[ 2846.270018]  [<ffffffff810aaa8b>] __filemap_fdatawrite_range+0x4b/0x4d
[ 2846.270031]  [<ffffffff810ab618>] filemap_fdatawrite_range+0xe/0x10
[ 2846.270083]  [<ffffffffa013b20e>] btrfs_wait_ordered_range+0x56/0x124 [btrfs]
[ 2846.270136]  [<ffffffffa012a952>] btrfs_truncate+0x2d5/0x4db [btrfs]
[ 2846.270188]  [<ffffffffa012b7ac>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[ 2846.270240]  [<ffffffffa0121709>] open_ctree+0x1062/0x129d [btrfs]
[ 2846.270280]  [<ffffffffa01088d4>] btrfs_mount+0x21f/0x46d [btrfs]
[ 2846.270291]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[ 2846.270302]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[ 2846.270317]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[ 2846.270328]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[ 2846.270341]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[ 2846.270355]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[ 2846.270367]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[ 2846.270379]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[ 2846.270391]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[ 2846.270404]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[ 2846.270417]  [<ffffffff8138357b>] system_call_fastpath+0x16/0x1b

--Boundary-00=_cIWwNab6kem8mhE--
