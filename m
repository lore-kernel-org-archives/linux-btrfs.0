From: whirm@gmx.com
Subject: Re: kernel BUG at fs/btrfs/inode.c:149!
Date: Wed, 4 May 2011 19:43:31 +0200
Message-ID: <201105041943.31809.whirm@gmx.com>
References: <201105041626.36039.whirm@gmx.com> <4DC166D4.4000801@redhat.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_DBZwNppVm/UBdRb"
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DC166D4.4000801@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Boundary-00=_DBZwNppVm/UBdRb
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Wednesday 04 May 2011 16:46:44 Josef Bacik wrote:
> On 05/04/2011 10:26 AM, whirm@gmx.com wrote:
> > Hi all,
> > 
> > Here's a traceback from a failed attempt to mount a btrfs in lvm in luks
> > filesystem.
> > 
> > Note that if I mount it readonly it mounts successfully (haven't tried to
> > recover any data as I have recent backups).
> > 
> > Yesterday I defragmented both / and /home with:
> > 
> > find /home -xdev -type f -print0 | xargs -0 sudo ./btrfs filesystem
> > defragment -c
> > 
> > with btrfs-tools v0.19-35-g1b444cd and rebooted a couple of times. And
> > today I got this traceback while trying to mount home at boot time (/ is
> > working ok)
> > 
> > btrfsck fails with the following error:
> > 
> > couldn't open because of unsupported option features (8).
> > btrfsck: disk-io.c:682: open_ctree_fd: Assertion `!(1)' failed.
> > 
> > I'm using a 2.6.39-rc5+ kernel from Linus' tree.
> > 
> > If someone needs any extra info, just ask for it, Ill keep the corrupted
> > filesystem for a few days before destroying it.
> > 
> > Thanks.
> 
> I just posted a patch for this, please try
> 
> [PATCH] Btrfs: fix how we do space reservation for truncate
> 
> thanks,
> 
> Josef

Still getting the same traceback when trying to mount the filesystem (see file 
attached).

Thanks,

--Boundary-00=_DBZwNppVm/UBdRb
Content-Type: text/x-log;
  charset="UTF-8";
  name="trackeback-btrfs.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="trackeback-btrfs.log"

[   96.389337] device label home devid 1 transid 94826 /dev/mapper/volumes-home--fotut
[   96.512843] btrfs: disk space caching is enabled
[   97.501715] ------------[ cut here ]------------
[   97.501747] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.501749] Hardware name: Latitude E4300                  
[   97.501751] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.501795] Pid: 3476, comm: mount Not tainted 2.6.39-rc6+ #2
[   97.501797] Call Trace:
[   97.501804]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.501808]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.501824]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.501840]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.501856]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.501869]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.501882]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.501887]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.501891]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.501904]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.501918]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.501935]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.501951]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.501963]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.501975]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.501987]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.501999]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.502030]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.502048]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.502065]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.502081]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.502093]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.502098]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.502101]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.502106]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.502109]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.502113]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.502117]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.502120]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.502124]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.502127]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.502130]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.502135]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.502137] ---[ end trace ae3c8c27e68823ea ]---
[   97.502141] ------------[ cut here ]------------
[   97.502156] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.502159] Hardware name: Latitude E4300                  
[   97.502161] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.502216] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.502218] Call Trace:
[   97.502223]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.502227]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.502243]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.502260]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.502277]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.502292]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.502306]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.502310]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.502315]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.502329]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.502344]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.502362]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.502378]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.502392]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.502404]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.502417]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.502430]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.502447]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.502465]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.502483]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.502500]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.502514]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.502518]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.502522]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.502527]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.502530]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.502535]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.502539]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.502543]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.502547]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.502551]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.502555]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.502559]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.502563] ---[ end trace ae3c8c27e68823eb ]---
[   97.502571] ------------[ cut here ]------------
[   97.502587] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.502590] Hardware name: Latitude E4300                  
[   97.502592] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.502646] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.502649] Call Trace:
[   97.502653]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.502658]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.502674]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.502691]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.502707]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.502722]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.502736]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.502741]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.502745]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.502759]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.502774]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.502792]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.502809]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.502822]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.502834]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.502847]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.502860]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.502878]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.502896]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.502914]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.502931]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.502944]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.502948]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.502952]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.502957]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.502960]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.502965]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.502969]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.502973]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.502977]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.502981]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.502985]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.502989]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.502992] ---[ end trace ae3c8c27e68823ec ]---
[   97.502995] ------------[ cut here ]------------
[   97.503010] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.503023] Hardware name: Latitude E4300                  
[   97.503025] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.503081] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.503083] Call Trace:
[   97.503087]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.503092]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.503108]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.503125]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.503141]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.503156]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.503169]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.503174]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.503179]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.503193]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.503208]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.503226]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.503242]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.503256]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.503268]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.503281]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.503294]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.503311]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.503329]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.503347]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.503364]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.503378]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.503382]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.503386]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.503391]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.503394]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.503399]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.503403]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.503407]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.503411]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.503415]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.503419]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.503423]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.503426] ---[ end trace ae3c8c27e68823ed ]---
[   97.503429] ------------[ cut here ]------------
[   97.503444] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.503447] Hardware name: Latitude E4300                  
[   97.503449] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.503504] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.503507] Call Trace:
[   97.503511]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.503516]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.503532]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.503549]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.503565]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.503580]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.503594]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.503599]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.503604]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.503618]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.503633]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.503650]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.503667]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.503680]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.503692]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.503705]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.503718]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.503735]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.503754]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.503772]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.503789]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.503803]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.503806]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.503810]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.503815]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.503818]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.503823]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.503827]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.503831]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.503835]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.503839]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.503843]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.503847]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.503850] ---[ end trace ae3c8c27e68823ee ]---
[   97.503852] ------------[ cut here ]------------
[   97.503868] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.503870] Hardware name: Latitude E4300                  
[   97.503872] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.503919] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.503920] Call Trace:
[   97.503924]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.503928]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.503943]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.503959]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.503975]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.503988]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.504001]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.504013]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.504017]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.504030]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.504044]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.504061]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.504077]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.504089]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.504102]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.504115]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.504128]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.504145]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.504163]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.504181]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.504198]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.504211]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.504215]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.504219]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.504224]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.504227]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.504232]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.504236]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.504240]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.504244]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.504248]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.504252]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.504256]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.504260] ---[ end trace ae3c8c27e68823ef ]---
[   97.504262] ------------[ cut here ]------------
[   97.504277] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.504280] Hardware name: Latitude E4300                  
[   97.504282] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.504338] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.504340] Call Trace:
[   97.504344]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.504349]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.504365]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.504382]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.504398]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.504413]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.504427]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.504431]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.504436]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.504450]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.504465]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.504482]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.504499]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.504512]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.504525]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.504538]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.504551]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.504568]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.504586]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.504604]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.504621]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.504635]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.504639]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.504642]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.504648]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.504651]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.504656]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.504660]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.504664]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.504667]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.504671]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.504676]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.504680]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.504683] ---[ end trace ae3c8c27e68823f0 ]---
[   97.504685] ------------[ cut here ]------------
[   97.504700] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.504703] Hardware name: Latitude E4300                  
[   97.504705] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.504761] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.504763] Call Trace:
[   97.504768]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.504772]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.504788]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.504805]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.504821]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.504836]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.504850]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.504854]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.504859]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.504874]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.504888]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.504906]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.504923]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.504936]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.504948]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.504961]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.504974]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.504992]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.505008]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.505039]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.505056]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.505070]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.505073]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.505077]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.505082]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.505085]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.505090]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.505094]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.505098]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.505102]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.505106]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.505111]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.505115]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.505118] ---[ end trace ae3c8c27e68823f1 ]---
[   97.505122] ------------[ cut here ]------------
[   97.505137] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.505140] Hardware name: Latitude E4300                  
[   97.505142] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.505197] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.505200] Call Trace:
[   97.505204]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.505209]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.505225]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.505242]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.505258]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.505273]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.505287]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.505291]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.505296]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.505310]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.505324]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.505342]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.505359]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.505372]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.505384]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.505397]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.505410]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.505428]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.505446]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.505464]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.505481]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.505494]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.505498]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.505502]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.505507]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.505510]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.505515]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.505519]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.505523]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.505527]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.505531]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.505535]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.505539]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.505543] ---[ end trace ae3c8c27e68823f2 ]---
[   97.505545] ------------[ cut here ]------------
[   97.505560] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.505563] Hardware name: Latitude E4300                  
[   97.505565] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.505621] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.505623] Call Trace:
[   97.505628]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.505632]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.505648]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.505665]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.505681]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.505696]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.505710]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.505715]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.505719]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.505733]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.505748]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.505766]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.505783]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.505795]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.505808]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.505821]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.505834]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.505851]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.505868]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.505885]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.505900]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.505913]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.505916]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.505919]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.505923]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.505926]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.505929]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.505933]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.505936]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.505939]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.505942]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.505946]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.505949]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.505951] ---[ end trace ae3c8c27e68823f3 ]---
[   97.505953] ------------[ cut here ]------------
[   97.505968] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.505970] Hardware name: Latitude E4300                  
[   97.505972] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.506030] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.506032] Call Trace:
[   97.506036]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.506040]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.506055]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.506071]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.506087]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.506101]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.506114]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.506118]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.506122]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.506135]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.506149]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.506166]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.506182]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.506194]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.506205]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.506217]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.506229]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.506246]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.506263]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.506280]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.506296]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.506308]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.506311]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.506314]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.506318]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.506321]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.506325]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.506329]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.506332]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.506335]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.506338]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.506342]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.506345]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.506348] ---[ end trace ae3c8c27e68823f4 ]---
[   97.506379] ------------[ cut here ]------------
[   97.506395] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.506397] Hardware name: Latitude E4300                  
[   97.506399] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.506438] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.506440] Call Trace:
[   97.506445]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.506449]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.506465]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.506482]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.506498]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.506513]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.506527]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.506532]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.506537]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.506551]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.506566]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.506583]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.506600]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.506613]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.506625]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.506638]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.506651]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.506668]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.506687]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.506704]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.506721]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.506735]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.506739]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.506743]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.506748]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.506751]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.506755]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.506760]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.506764]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.506768]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.506772]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.506776]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.506780]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.506783] ---[ end trace ae3c8c27e68823f5 ]---
[   97.506786] ------------[ cut here ]------------
[   97.506801] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.506804] Hardware name: Latitude E4300                  
[   97.506806] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.506861] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.506864] Call Trace:
[   97.506868]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.506873]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.506889]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.506906]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.506922]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.506937]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.506951]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.506956]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.506960]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.506974]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.506989]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.507006]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.507034]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.507047]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.507059]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.507072]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.507085]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.507103]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.507121]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.507139]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.507156]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.507169]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.507173]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.507177]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.507182]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.507185]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.507189]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.507193]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.507197]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.507201]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.507205]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.507209]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.507213]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.507216] ---[ end trace ae3c8c27e68823f6 ]---
[   97.507218] ------------[ cut here ]------------
[   97.507233] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.507236] Hardware name: Latitude E4300                  
[   97.507238] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.507292] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.507294] Call Trace:
[   97.507299]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.507303]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.507319]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.507336]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.507352]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.507367]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.507381]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.507385]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.507390]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.507404]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.507418]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.507436]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.507452]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.507465]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.507478]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.507490]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.507503]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.507521]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.507539]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.507556]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.507573]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.507587]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.507591]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.507595]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.507599]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.507603]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.507607]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.507611]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.507616]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.507620]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.507624]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.507628]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.507632]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.507635] ---[ end trace ae3c8c27e68823f7 ]---
[   97.507637] ------------[ cut here ]------------
[   97.507652] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.507655] Hardware name: Latitude E4300                  
[   97.507657] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.507711] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.507713] Call Trace:
[   97.507718]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.507722]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.507738]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.507754]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.507771]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.507785]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.507799]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.507804]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.507808]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.507822]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.507837]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.507854]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.507871]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.507884]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.507896]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.507909]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.507923]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.507940]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.507958]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.507975]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.507992]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.508006]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.508019]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.508023]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.508028]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.508031]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.508036]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.508040]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.508044]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.508048]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.508052]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.508056]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.508060]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.508063] ---[ end trace ae3c8c27e68823f8 ]---
[   97.508065] ------------[ cut here ]------------
[   97.508081] WARNING: at fs/btrfs/free-space-cache.c:915 tree_insert_offset+0x77/0xbc [btrfs]()
[   97.508083] Hardware name: Latitude E4300                  
[   97.508085] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.508138] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.508140] Call Trace:
[   97.508144]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.508147]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.508163]  [<ffffffffa014a054>] tree_insert_offset+0x77/0xbc [btrfs]
[   97.508179]  [<ffffffffa014a32f>] link_free_space+0x3b/0x53 [btrfs]
[   97.508195]  [<ffffffffa014bed6>] load_free_space_cache+0x47e/0x69a [btrfs]
[   97.508208]  [<ffffffffa010d481>] cache_block_group+0x9c/0x244 [btrfs]
[   97.508221]  [<ffffffffa011137b>] find_free_extent.constprop.68+0x3b6/0x936 [btrfs]
[   97.508225]  [<ffffffff8102cbef>] ? perf_event_task_sched_out+0x50/0x5c
[   97.508228]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.508242]  [<ffffffffa01121ef>] btrfs_reserve_extent+0xab/0x19c [btrfs]
[   97.508255]  [<ffffffffa01127de>] btrfs_alloc_free_block+0x16d/0x28b [btrfs]
[   97.508272]  [<ffffffffa013711e>] ? __kunmap_atomic.isra.12+0x23/0x2e [btrfs]
[   97.508288]  [<ffffffffa013b247>] ? read_extent_buffer+0xbb/0xdb [btrfs]
[   97.508300]  [<ffffffffa01058d9>] __btrfs_cow_block+0xf8/0x30d [btrfs]
[   97.508312]  [<ffffffffa0104316>] ? __kunmap_atomic.isra.13+0xe/0x29 [btrfs]
[   97.508324]  [<ffffffffa0105bee>] btrfs_cow_block+0x100/0x176 [btrfs]
[   97.508336]  [<ffffffffa0108c10>] btrfs_search_slot+0x13f/0x4fd [btrfs]
[   97.508352]  [<ffffffffa012520d>] btrfs_truncate_inode_items+0xfd/0x5ad [btrfs]
[   97.508369]  [<ffffffffa0125af1>] btrfs_truncate+0x434/0x553 [btrfs]
[   97.508386]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.508401]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.508414]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.508417]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.508420]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.508424]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.508427]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.508430]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.508434]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.508437]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.508440]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.508443]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.508447]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.508450]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.508453] ---[ end trace ae3c8c27e68823f9 ]---
[   97.508490] block group 135614431232 has an wrong amount of free space
[   97.867234] ------------[ cut here ]------------
[   97.867271] WARNING: at fs/btrfs/file.c:368 btrfs_drop_extents+0x27f/0x6f5 [btrfs]()
[   97.867274] Hardware name: Latitude E4300                  
[   97.867276] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.867339] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2
[   97.867343] Call Trace:
[   97.867352]  [<ffffffff8103b70a>] warn_slowpath_common+0x7e/0x96
[   97.867358]  [<ffffffff8103b737>] warn_slowpath_null+0x15/0x17
[   97.867382]  [<ffffffffa012a79d>] btrfs_drop_extents+0x27f/0x6f5 [btrfs]
[   97.867408]  [<ffffffffa0123464>] cow_file_range_inline+0xde/0x15c [btrfs]
[   97.867433]  [<ffffffffa01235ac>] cow_file_range+0xca/0x307 [btrfs]
[   97.867439]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[   97.867463]  [<ffffffffa0123e6e>] run_delalloc_range+0xa6/0x324 [btrfs]
[   97.867488]  [<ffffffffa0137403>] ? free_extent_state+0x17/0x46 [btrfs]
[   97.867512]  [<ffffffffa0138e3f>] ? find_lock_delalloc_range.constprop.25+0x188/0x1b1 [btrfs]
[   97.867538]  [<ffffffffa01396e7>] __extent_writepage+0x1d5/0x5ba [btrfs]
[   97.867562]  [<ffffffffa013b651>] ? map_private_extent_buffer+0xaa/0xcd [btrfs]
[   97.867567]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.867571]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.867575]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.867580]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[   97.867605]  [<ffffffffa0139c0a>] extent_write_cache_pages.isra.14.constprop.22+0x13e/0x276 [btrfs]
[   97.867632]  [<ffffffffa0139f93>] extent_writepages+0x3e/0x4f [btrfs]
[   97.867656]  [<ffffffffa012120c>] ? uncompress_inline.isra.41+0x113/0x113 [btrfs]
[   97.867662]  [<ffffffff810db06e>] ? kmem_cache_free+0x17/0xba
[   97.867686]  [<ffffffffa0120198>] btrfs_writepages+0x23/0x25 [btrfs]
[   97.867692]  [<ffffffff810b159a>] do_writepages+0x1c/0x25
[   97.867696]  [<ffffffff810aaa8b>] __filemap_fdatawrite_range+0x4b/0x4d
[   97.867701]  [<ffffffff810ab618>] filemap_fdatawrite_range+0xe/0x10
[   97.867726]  [<ffffffffa01362c6>] btrfs_wait_ordered_range+0x56/0x124 [btrfs]
[   97.867750]  [<ffffffffa0125994>] btrfs_truncate+0x2d7/0x553 [btrfs]
[   97.867775]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.867799]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.867817]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.867822]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.867826]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.867833]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.867837]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.867843]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.867848]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.867853]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.867858]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.867863]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.867867]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.867873]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.867877] ---[ end trace ae3c8c27e68823fa ]---
[   97.867902] ------------[ cut here ]------------
[   97.867948] kernel BUG at fs/btrfs/inode.c:149!
[   97.867986] invalid opcode: 0000 [#1] PREEMPT SMP 
[   97.868035] last sysfs file: /sys/devices/virtual/bdi/btrfs-3/uevent
[   97.868086] CPU 0 
[   97.868105] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.868181] 
[   97.868181] Pid: 3476, comm: mount Tainted: G        W   2.6.39-rc6+ #2 Dell Inc. Latitude E4300                  /0D201R
[   97.868181] RIP: 0010:[<ffffffffa0123208>]  [<ffffffffa0123208>] insert_inline_extent+0xab/0x229 [btrfs]
[   97.868181] RSP: 0018:ffff88010819b4f8  EFLAGS: 00010282
[   97.868181] RAX: 00000000ffffffef RBX: ffff880110ddb138 RCX: ffff88010819b340
[   97.868181] RDX: ffff8800d411dd38 RSI: 0000000000000000 RDI: ffff88010819b348
[   97.868181] RBP: ffff88010819b578 R08: ffff88010819b348 R09: ffff88010819b350
[   97.868181] R10: ffff88011a58a000 R11: ffff8800d411dcc0 R12: ffff880114827e10
[   97.868181] R13: 0000000000000000 R14: 0000000000000806 R15: ffff8800cb7abf80
[   97.868181] FS:  00007f4f286067e0(0000) GS:ffff88011bc00000(0000) knlGS:0000000000000000
[   97.868181] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   97.868181] CR2: 00007fc1148b85e4 CR3: 0000000101c6f000 CR4: 00000000000006f0
[   97.868181] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   97.868181] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   97.868181] Process mount (pid: 3476, threadinfo ffff88010819a000, task ffff8800db2a2620)
[   97.868181] Stack:
[   97.868181]  ffff88011a58a000 ffff88011a58a000 0000000000000000 ffff8800cb7abf80
[   97.868181]  0000000000000000 00000000000007f1 0001000000000000 00000047d5000000
[   97.868181]  000000006c000000 0000080600000000 0000000000000000 ffff88011a58a000
[   97.868181] Call Trace:
[   97.868181]  [<ffffffffa01234a3>] cow_file_range_inline+0x11d/0x15c [btrfs]
[   97.868181]  [<ffffffffa01235ac>] cow_file_range+0xca/0x307 [btrfs]
[   97.868181]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[   97.868181]  [<ffffffffa0123e6e>] run_delalloc_range+0xa6/0x324 [btrfs]
[   97.868181]  [<ffffffffa0137403>] ? free_extent_state+0x17/0x46 [btrfs]
[   97.868181]  [<ffffffffa0138e3f>] ? find_lock_delalloc_range.constprop.25+0x188/0x1b1 [btrfs]
[   97.868181]  [<ffffffffa01396e7>] __extent_writepage+0x1d5/0x5ba [btrfs]
[   97.868181]  [<ffffffffa013b651>] ? map_private_extent_buffer+0xaa/0xcd [btrfs]
[   97.868181]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.868181]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.868181]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.868181]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[   97.868181]  [<ffffffffa0139c0a>] extent_write_cache_pages.isra.14.constprop.22+0x13e/0x276 [btrfs]
[   97.868181]  [<ffffffffa0139f93>] extent_writepages+0x3e/0x4f [btrfs]
[   97.868181]  [<ffffffffa012120c>] ? uncompress_inline.isra.41+0x113/0x113 [btrfs]
[   97.868181]  [<ffffffff810db06e>] ? kmem_cache_free+0x17/0xba
[   97.868181]  [<ffffffffa0120198>] btrfs_writepages+0x23/0x25 [btrfs]
[   97.868181]  [<ffffffff810b159a>] do_writepages+0x1c/0x25
[   97.868181]  [<ffffffff810aaa8b>] __filemap_fdatawrite_range+0x4b/0x4d
[   97.868181]  [<ffffffff810ab618>] filemap_fdatawrite_range+0xe/0x10
[   97.868181]  [<ffffffffa01362c6>] btrfs_wait_ordered_range+0x56/0x124 [btrfs]
[   97.868181]  [<ffffffffa0125994>] btrfs_truncate+0x2d7/0x553 [btrfs]
[   97.868181]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.868181]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.868181]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.868181]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.868181]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.868181]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.868181]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.868181]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.868181]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.868181]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.868181]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.868181]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.868181]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.868181]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.868181] Code: e8 fd 2f fc e0 48 8b 75 88 41 b9 01 00 00 00 48 8b 7d 98 4c 8d 45 cc 4c 89 e2 48 8d 4d bb 44 89 75 cc e8 db 68 fe ff 85 c0 74 02 <0f> 0b 4d 8b 34 24 41 8b 74 24 40 4c 89 f7 e8 c6 b8 ff ff 48 8b 
[   97.868181] RIP  [<ffffffffa0123208>] insert_inline_extent+0xab/0x229 [btrfs]
[   97.868181]  RSP <ffff88010819b4f8>
[   97.935416] ---[ end trace ae3c8c27e68823fb ]---
[   97.935421] note: mount[3476] exited with preempt_count 1
[   97.935436] BUG: scheduling while atomic: mount/3476/0x10000002
[   97.935440] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.935541] Pid: 3476, comm: mount Tainted: G      D W   2.6.39-rc6+ #2
[   97.935545] Call Trace:
[   97.935552]  [<ffffffff8137ae49>] __schedule_bug+0x57/0x5b
[   97.935559]  [<ffffffff813810a6>] schedule+0x8e/0x68c
[   97.935566]  [<ffffffff81034ed2>] __cond_resched+0x13/0x1f
[   97.935572]  [<ffffffff8138188d>] _cond_resched+0x14/0x1d
[   97.935578]  [<ffffffff810c2e03>] unmap_vmas+0x61c/0x73f
[   97.935586]  [<ffffffff810c7ec2>] exit_mmap+0x7c/0xc2
[   97.935592]  [<ffffffff810393d1>] mmput+0x56/0xff
[   97.935597]  [<ffffffff8103d2a4>] exit_mm+0x12d/0x13a
[   97.935603]  [<ffffffff8103e819>] do_exit+0x26a/0x75f
[   97.935610]  [<ffffffff810054b2>] oops_end+0xb0/0xb8
[   97.935616]  [<ffffffff810055f5>] die+0x55/0x60
[   97.935622]  [<ffffffff81002928>] do_trap+0x11c/0x12b
[   97.935629]  [<ffffffff81002b76>] do_invalid_op+0x93/0x9c
[   97.935654]  [<ffffffffa0123208>] ? insert_inline_extent+0xab/0x229 [btrfs]
[   97.935672]  [<ffffffffa01043f3>] ? unlock_up+0xa7/0xcb [btrfs]
[   97.935692]  [<ffffffffa0108f2d>] ? btrfs_search_slot+0x45c/0x4fd [btrfs]
[   97.935699]  [<ffffffff813845d5>] invalid_op+0x15/0x20
[   97.935725]  [<ffffffffa0123208>] ? insert_inline_extent+0xab/0x229 [btrfs]
[   97.935751]  [<ffffffffa0123204>] ? insert_inline_extent+0xa7/0x229 [btrfs]
[   97.935777]  [<ffffffffa01234a3>] cow_file_range_inline+0x11d/0x15c [btrfs]
[   97.935803]  [<ffffffffa01235ac>] cow_file_range+0xca/0x307 [btrfs]
[   97.935811]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[   97.935836]  [<ffffffffa0123e6e>] run_delalloc_range+0xa6/0x324 [btrfs]
[   97.935862]  [<ffffffffa0137403>] ? free_extent_state+0x17/0x46 [btrfs]
[   97.935888]  [<ffffffffa0138e3f>] ? find_lock_delalloc_range.constprop.25+0x188/0x1b1 [btrfs]
[   97.935915]  [<ffffffffa01396e7>] __extent_writepage+0x1d5/0x5ba [btrfs]
[   97.935941]  [<ffffffffa013b651>] ? map_private_extent_buffer+0xaa/0xcd [btrfs]
[   97.935947]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.935952]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.935958]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.935964]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[   97.935992]  [<ffffffffa0139c0a>] extent_write_cache_pages.isra.14.constprop.22+0x13e/0x276 [btrfs]
[   97.936020]  [<ffffffffa0139f93>] extent_writepages+0x3e/0x4f [btrfs]
[   97.936057]  [<ffffffffa012120c>] ? uncompress_inline.isra.41+0x113/0x113 [btrfs]
[   97.936063]  [<ffffffff810db06e>] ? kmem_cache_free+0x17/0xba
[   97.936088]  [<ffffffffa0120198>] btrfs_writepages+0x23/0x25 [btrfs]
[   97.936095]  [<ffffffff810b159a>] do_writepages+0x1c/0x25
[   97.936100]  [<ffffffff810aaa8b>] __filemap_fdatawrite_range+0x4b/0x4d
[   97.936107]  [<ffffffff810ab618>] filemap_fdatawrite_range+0xe/0x10
[   97.936132]  [<ffffffffa01362c6>] btrfs_wait_ordered_range+0x56/0x124 [btrfs]
[   97.936159]  [<ffffffffa0125994>] btrfs_truncate+0x2d7/0x553 [btrfs]
[   97.936186]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.936211]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.936232]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.936237]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.936243]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.936250]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.936256]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.936263]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.936270]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.936276]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.936282]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.936288]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.936294]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.936301]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[   97.936545] BUG: scheduling while atomic: mount/3476/0x10000002
[   97.936548] Modules linked in: vboxnetadp vboxnetflt vboxdrv iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep sg snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi sr_mod snd_rawmidi cdrom snd_seq_midi_event snd_seq dell_laptop sdhci_pci rfkill sdhci psmouse dcdbas mmc_core snd_timer snd_seq_device snd soundcore snd_page_alloc tpm_tis tpm pcspkr i2c_i801 tpm_bios ac sha256_generic i2o_config i2o_block i2o_core btrfs zlib_deflate usbhid hid sd_mod crc_t10dif uhci_hcd ahci libahci libata ehci_hcd scsi_mod thermal usbcore
[   97.936591] Pid: 3476, comm: mount Tainted: G      D W   2.6.39-rc6+ #2
[   97.936593] Call Trace:
[   97.936597]  [<ffffffff8137ae49>] __schedule_bug+0x57/0x5b
[   97.936600]  [<ffffffff813810a6>] schedule+0x8e/0x68c
[   97.936604]  [<ffffffff81034ed2>] __cond_resched+0x13/0x1f
[   97.936607]  [<ffffffff8138188d>] _cond_resched+0x14/0x1d
[   97.936610]  [<ffffffff810c2e03>] unmap_vmas+0x61c/0x73f
[   97.936614]  [<ffffffff810c7ec2>] exit_mmap+0x7c/0xc2
[   97.936617]  [<ffffffff810393d1>] mmput+0x56/0xff
[   97.936620]  [<ffffffff8103d2a4>] exit_mm+0x12d/0x13a
[   97.936623]  [<ffffffff8103e819>] do_exit+0x26a/0x75f
[   97.936626]  [<ffffffff810054b2>] oops_end+0xb0/0xb8
[   97.936629]  [<ffffffff810055f5>] die+0x55/0x60
[   97.936632]  [<ffffffff81002928>] do_trap+0x11c/0x12b
[   97.936635]  [<ffffffff81002b76>] do_invalid_op+0x93/0x9c
[   97.936651]  [<ffffffffa0123208>] ? insert_inline_extent+0xab/0x229 [btrfs]
[   97.936662]  [<ffffffffa01043f3>] ? unlock_up+0xa7/0xcb [btrfs]
[   97.936674]  [<ffffffffa0108f2d>] ? btrfs_search_slot+0x45c/0x4fd [btrfs]
[   97.936678]  [<ffffffff813845d5>] invalid_op+0x15/0x20
[   97.936694]  [<ffffffffa0123208>] ? insert_inline_extent+0xab/0x229 [btrfs]
[   97.936711]  [<ffffffffa0123204>] ? insert_inline_extent+0xa7/0x229 [btrfs]
[   97.936729]  [<ffffffffa01234a3>] cow_file_range_inline+0x11d/0x15c [btrfs]
[   97.936747]  [<ffffffffa01235ac>] cow_file_range+0xca/0x307 [btrfs]
[   97.936752]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[   97.936769]  [<ffffffffa0123e6e>] run_delalloc_range+0xa6/0x324 [btrfs]
[   97.936786]  [<ffffffffa0137403>] ? free_extent_state+0x17/0x46 [btrfs]
[   97.936804]  [<ffffffffa0138e3f>] ? find_lock_delalloc_range.constprop.25+0x188/0x1b1 [btrfs]
[   97.936822]  [<ffffffffa01396e7>] __extent_writepage+0x1d5/0x5ba [btrfs]
[   97.936839]  [<ffffffffa013b651>] ? map_private_extent_buffer+0xaa/0xcd [btrfs]
[   97.936843]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.936846]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.936850]  [<ffffffff81033252>] ? get_parent_ip+0xf/0x40
[   97.936854]  [<ffffffff81033312>] ? sub_preempt_count+0x8f/0xa3
[   97.936872]  [<ffffffffa0139c0a>] extent_write_cache_pages.isra.14.constprop.22+0x13e/0x276 [btrfs]
[   97.936892]  [<ffffffffa0139f93>] extent_writepages+0x3e/0x4f [btrfs]
[   97.936909]  [<ffffffffa012120c>] ? uncompress_inline.isra.41+0x113/0x113 [btrfs]
[   97.936913]  [<ffffffff810db06e>] ? kmem_cache_free+0x17/0xba
[   97.936930]  [<ffffffffa0120198>] btrfs_writepages+0x23/0x25 [btrfs]
[   97.936934]  [<ffffffff810b159a>] do_writepages+0x1c/0x25
[   97.936938]  [<ffffffff810aaa8b>] __filemap_fdatawrite_range+0x4b/0x4d
[   97.936942]  [<ffffffff810ab618>] filemap_fdatawrite_range+0xe/0x10
[   97.936959]  [<ffffffffa01362c6>] btrfs_wait_ordered_range+0x56/0x124 [btrfs]
[   97.936977]  [<ffffffffa0125994>] btrfs_truncate+0x2d7/0x553 [btrfs]
[   97.936995]  [<ffffffffa0126864>] btrfs_orphan_cleanup+0x1f1/0x2dd [btrfs]
[   97.937024]  [<ffffffffa011c749>] open_ctree+0x1062/0x129d [btrfs]
[   97.937039]  [<ffffffffa01038d4>] btrfs_mount+0x21f/0x46d [btrfs]
[   97.937043]  [<ffffffff810bf30e>] ? pcpu_next_pop+0x38/0x45
[   97.937047]  [<ffffffff810c037e>] ? pcpu_alloc+0x7c4/0x7db
[   97.937052]  [<ffffffff810e513d>] mount_fs+0x64/0x14f
[   97.937056]  [<ffffffff810c03a0>] ? __alloc_percpu+0xb/0xd
[   97.937060]  [<ffffffff810f9360>] vfs_kern_mount+0x5e/0x98
[   97.937065]  [<ffffffff810f9672>] do_kern_mount+0x48/0xda
[   97.937069]  [<ffffffff810fad47>] do_mount+0x651/0x6b4
[   97.937073]  [<ffffffff810bc599>] ? memdup_user+0x38/0x60
[   97.937077]  [<ffffffff810bc5f7>] ? strndup_user+0x36/0x4c
[   97.937081]  [<ffffffff810fb03a>] sys_mount+0x83/0xbd
[   97.937085]  [<ffffffff8138367b>] system_call_fastpath+0x16/0x1b
[  104.597173] dell-wmi: Received unknown WMI event (0x11)

--Boundary-00=_DBZwNppVm/UBdRb--
