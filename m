Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:54143 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbdJMJOu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 05:14:50 -0400
Received: by mail-wm0-f54.google.com with SMTP id q132so19929183wmd.2
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 02:14:50 -0700 (PDT)
Subject: Re: btrfs errors over NFS
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
References: <87o9pcmfad.fsf@shaw.ca>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <0f4c26ac-9c31-7312-096d-f4b69bfc8365@gmail.com>
Date: Fri, 13 Oct 2017 12:14:44 +0300
MIME-Version: 1.0
In-Reply-To: <87o9pcmfad.fsf@shaw.ca>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.10.2017 20:44, Steve Leung wrote:
> Hi list,
> 
>   TL;DR: ran into some btrfs errors and weird behaviour, but things generally seem 
>   to work.  Just posting some details in case it helps devs or other users.
> 
> I've run into a btrfs error trying to do a -j8 build of android on a btrfs 
> filesystem exported over NFSv3.  That in itself might be unwise, but should be 
> legal.  :)  This is on 64-bit Arch, kernel 4.13.3, and the filesystem is RAID1 on 4 
> devices, with nearly 4TiB unallocated.
> 
> The build itself failed when part of the build process noticed that a file got 
> created with mode 000.  i.e. in "ls -l" the mode column looked like ?---------.
> 
> That much happened without any errors in dmesg, though the NFS client complained 
> about some inodes having a mode of 0.
> 
> Then when I tried to delete those files, I got the error below:
> 
> [21476.546060] BTRFS error (device sdc1): err add delayed dir index item(index: 17) into the deletion tree of the delayed node(root id: 21780, inode id: 15668343, errno: -17)
> [21476.546194] ------------[ cut here ]------------
> [21476.546196] kernel BUG at fs/btrfs/delayed-inode.c:1552!
> [21476.546231] invalid opcode: 0000 [#1] PREEMPT SMP
> [21476.546258] Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_filter tun coretemp kvm_intel kvm iTCO_wdt ppdev gpio_ich iTCO_vendor_support evdev i915 input_leds psmouse pcspkr irqbypass i2c_i801 snd_hda_codec_idt snd_hda_codec_generic mac_hid lpc_ich tpm_tis tpm_tis_core parport_pc tpm parport video drm_kms_helper drm syscopyarea winbond_cir sysfillrect sysimgblt rc_core led_class snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer shpchp snd button e1000e soundcore intel_agp intel_gtt acpi_cpufreq mei_me mei fb_sys_fops i2c_algo_bit ptp pps_core sch_fq_codel nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc ip_tables x_tables crc32c_generic btrfs xor raid6_pq sr_mod cdrom
> [21476.546623]  sd_mod hid_generic usbhid hid serio_raw atkbd libps2 uhci_hcd pata_it821x ahci libahci libata firewire_ohci scsi_mod firewire_core crc_itu_t i8042 serio ehci_pci ehci_hcd usbcore usb_common
> [21476.546725] CPU: 0 PID: 984 Comm: rm Not tainted 4.13.3-1-ARCH #1
> [21476.546756] Hardware name:                  /DG33TL, BIOS DPP3510J.86A.0572.2009.0715.2346 07/15/2009
> [21476.546801] task: ffff943668131b80 task.stack: ffffaa3840da4000
> [21476.546854] RIP: 0010:btrfs_delete_delayed_dir_index+0x24d/0x330 [btrfs]
> [21476.546889] RSP: 0018:ffffaa3840da7d18 EFLAGS: 00010286
> [21476.546918] RAX: 0000000000000000 RBX: ffff94367c074b90 RCX: 0000000000000000
> [21476.546953] RDX: 0000000000000000 RSI: ffff9436abc0dc78 RDI: ffff9436abc0dc78
> [21476.546989] RBP: ffffaa3840da7d88 R08: 0000000000000323 R09: 0000000000000000
> [21476.547025] R10: ffffaa3840da7bd8 R11: 00000000ffffffff R12: ffff943583503100
> [21476.547060] R13: ffff94367c074bd8 R14: ffff94367c074bd0 R15: ffff943583503218
> [21476.547096] FS:  00007f57da0f6500(0000) GS:ffff9436abc00000(0000) knlGS:0000000000000000
> [21476.547138] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [21476.547167] CR2: 00007f57d9c809c0 CR3: 000000005e39b000 CR4: 00000000000006f0
> [21476.547203] Call Trace:
> [21476.547235]  __btrfs_unlink_inode+0x1bc/0x550 [btrfs]
> [21476.547278]  btrfs_unlink_inode+0x1c/0x50 [btrfs]
> [21476.547317]  btrfs_unlink+0x88/0xe0 [btrfs]
> [21476.547343]  vfs_unlink+0x111/0x1c0
> [21476.547365]  ? __lookup_hash+0x22/0xa0
> [21476.547389]  do_unlinkat+0x2b1/0x310
> [21476.547412]  SyS_unlinkat+0x1b/0x30
> [21476.547434]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> [21476.547460] RIP: 0033:0x7f57d9c303d7
> [21476.547481] RSP: 002b:00007fff4bc1a6b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000107
> [21476.547520] RAX: ffffffffffffffda RBX: 00005644fee69540 RCX: 00007f57d9c303d7
> [21476.547556] RDX: 0000000000000000 RSI: 00005644fee68310 RDI: 00000000ffffff9c
> [21476.547591] RBP: 00005644fee69648 R08: 0000000000000003 R09: 0000000000000000
> [21476.547627] R10: 0000000000000100 R11: 0000000000000246 R12: 00005644fee68280
> [21476.547662] R13: 00007fff4bc1a7f0 R14: 00005644fd37094f R15: 0000000000000000
> [21476.547700] Code: ff ff ff 48 8b 43 10 4c 8b 03 41 b9 ef ff ff ff 48 8b 55 b0 48 8b 7d a8 48 c7 c6 b0 99 3f c0 48 8b 88 38 03 00 00 e8 f3 0d f7 ff <0f> 0b 48 8b 4d a8 49 8b 7e 38 8b 81 70 10 00 00 48 8d b1 c8 01 
> [21476.547840] RIP: btrfs_delete_delayed_dir_index+0x24d/0x330 [btrfs] RSP: ffffaa3840da7d18
> [21476.549333] ---[ end trace 41039f5467d88882 ]---
> 

Well, the main thing here is that you hit the BUG() in btrfs_delete_delayed_dir_index. 
So this happened because you tried to delete a file, which was already staged for deletion. 

So which directory corresponds to inode 15668343, presumably the android build dir?

If you could print the output of the following commands that could help in narrowing down the problem: 

btrfs inspect-internal dump-tree /dev/sdc1 | grep -A3 "(15668343 DIR_INDEX"

That will print all the DIR_INDEX items of the directory, and I will be particularly 
interested in item with index 17. Which should print something like: 

	item 12 key (257 DIR_INDEX 17) itemoff 15624 itemsize 35
		location key (259 INODE_ITEM 0) type FILE
		namelen 5 datalen 0 name: file2

Your numbers will be different of course (apart from the index).

At which point you can get the inode item corresponding to this file : 

btrfs inspect-internal dump-tree /dev/sdc1 | grep -A4 "(259 INODE_ITEM 0) itemoff" 
where the stuff in the brackets should be the same as the contents of () following 
"location key" string. 

> After that, a bunch of processes started hanging and I eventually stopped being 
> able to do useful things on the machine, so I hard rebooted it.
> 
> It booted back up fine.  I tried scrubbing the filesystem at that point and scrub 
> returned with no errors.  I then noticed 4.13.5 had some btrfs fixes so I upgraded 
> to that.  Now, I still have one bogus file in a directory - it's in the directory 
> listing but nothing can stat the file to change it or remove it.  i.e.:
> 
>   > ls -l
>   /bin/ls: cannot access 'tab_unselected_pressed_holo.9.png': No such file or directory
>   total 0
>   -????????? ? ? ? ?            ? tab_unselected_pressed_holo.9.png
> 
>   > stat tab_unselected_pressed_holo.9.png 
>   stat: cannot stat 'tab_unselected_pressed_holo.9.png': No such file or directory
> 
>   > rm tab_unselected_pressed_holo.9.png 
>   rm: cannot remove 'tab_unselected_pressed_holo.9.png': No such file or directory
> 
>   > cp /dev/null tab_unselected_pressed_holo.9.png 
>   > ls -l
>   total 0
>   -rw-r--r-- 1 steve steve 0 Oct 12 10:43 tab_unselected_pressed_holo.9.png
>   -rw-r--r-- 1 steve steve 0 Oct 12 10:43 tab_unselected_pressed_holo.9.png
> 
>   > rm tab_unselected_pressed_holo.9.png 
> 
>   > ls -l
>   /bin/ls: cannot access 'tab_unselected_pressed_holo.9.png': No such file or directory
>   total 0
>   -????????? ? ? ? ?            ? tab_unselected_pressed_holo.9.png
> 
> I'm guessing a btrfs check would fix this but haven't gotten around to running it 
> yet.
> 
> After moving aside the dir with the bogus file, I was able to complete the Android 
> build successfully, but noticed these warnings in the log afterward:
> 
> [11319.762849] ------------[ cut here ]------------
> [11319.762883] WARNING: CPU: 1 PID: 451 at fs/btrfs/ctree.h:1559 btrfs_update_device+0x1be/0x1d0 [btrfs]
> [11319.762884] Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_filter tun coretemp kvm_intel iTCO_wdt iTCO_vendor_support i915 gpio_ich ppdev kvm video i2c_algo_bit drm_kms_helper snd_hda_codec_idt snd_hda_codec_generic irqbypass drm syscopyarea psmouse sysfillrect snd_hda_intel pcspkr i2c_i801 e1000e mei_me sysimgblt snd_hda_codec evdev fb_sys_fops input_leds mei lpc_ich snd_hda_core snd_hwdep snd_pcm snd_timer snd soundcore parport_pc parport mac_hid ptp pps_core shpchp winbond_cir rc_core intel_agp intel_gtt led_class agpgart tpm_tis tpm_tis_core tpm button acpi_cpufreq nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc sch_fq_codel ip_tables x_tables crc32c_generic btrfs xor raid6_pq hid_generic
> [11319.762937]  sr_mod cdrom sd_mod usbhid hid serio_raw atkbd libps2 uhci_hcd firewire_ohci pata_it821x ahci libahci libata firewire_core scsi_mod crc_itu_t i8042 serio ehci_pci ehci_hcd usbcore usb_common
> [11319.762957] CPU: 1 PID: 451 Comm: nfsd Not tainted 4.13.5-1-ARCH #1
> [11319.762959] Hardware name:                  /DG33TL, BIOS DPP3510J.86A.0572.2009.0715.2346 07/15/2009
> [11319.762960] task: ffff90dce9e5b700 task.stack: ffff9e1fc1448000
> [11319.762975] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
> [11319.762977] RSP: 0018:ffff9e1fc144b468 EFLAGS: 00010206
> [11319.762978] RAX: 0000000000000fff RBX: ffff90dd227d7a80 RCX: 000003a3816d1e00
> [11319.762980] RDX: 0000000000000004 RSI: 0000000000007e98 RDI: ffff90dc990fbb58
> [11319.762981] RBP: ffff9e1fc144b4b0 R08: 0000000000007e9c R09: ffff9e1fc144b420
> [11319.762982] R10: 0000000000001000 R11: 0000000000000007 R12: ffff90dd21f77c00
> [11319.762984] R13: 0000000000000000 R14: 0000000000007e78 R15: ffff90dc990fbb58
> [11319.762985] FS:  0000000000000000(0000) GS:ffff90dd2bc80000(0000) knlGS:0000000000000000
> [11319.762987] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [11319.762988] CR2: 00005572c6c61c90 CR3: 000000016741a000 CR4: 00000000000006e0
> [11319.762990] Call Trace:
> [11319.763008]  btrfs_finish_chunk_alloc+0x136/0x4f0 [btrfs]
> [11319.763020]  ? btrfs_free_path.part.31+0x21/0x30 [btrfs]
> [11319.763033]  btrfs_create_pending_block_groups+0x135/0x250 [btrfs]
> [11319.763045]  ? btrfs_create_pending_block_groups+0x135/0x250 [btrfs]
> [11319.763060]  __btrfs_end_transaction+0x8e/0x2e0 [btrfs]
> [11319.763231]  btrfs_end_transaction+0x10/0x20 [btrfs]
> [11319.763243]  find_free_extent+0xc05/0x1020 [btrfs]
> [11319.763257]  btrfs_reserve_extent+0x9b/0x190 [btrfs]
> [11319.763272]  cow_file_range.isra.67+0x13a/0x420 [btrfs]
> [11319.763287]  run_delalloc_range+0x359/0x380 [btrfs]
> [11319.763302]  ? find_lock_delalloc_range.constprop.56+0x1cf/0x1f0 [btrfs]
> [11319.763317]  writepage_delalloc.isra.45+0xbc/0x170 [btrfs]
> [11319.763332]  __extent_writepage+0x17c/0x320 [btrfs]
> [11319.763348]  extent_write_cache_pages.constprop.53+0x1cd/0x460 [btrfs]
> [11319.763364]  extent_writepages+0x5d/0x90 [btrfs]
> [11319.763378]  ? btrfs_releasepage+0x20/0x20 [btrfs]
> [11319.763392]  btrfs_writepages+0x28/0x30 [btrfs]
> [11319.763396]  do_writepages+0x48/0xd0
> [11319.763400]  ? exportfs_decode_fh+0x100/0x390
> [11319.763404]  __filemap_fdatawrite_range+0xc1/0x100
> [11319.763405]  ? __filemap_fdatawrite_range+0xc1/0x100
> [11319.763408]  ? iter_div_u64_rem+0x20/0x20
> [11319.763411]  filemap_fdatawrite_range+0x13/0x20
> [11319.763425]  btrfs_fdatawrite_range+0x20/0x50 [btrfs]
> [11319.763440]  start_ordered_ops+0x19/0x30 [btrfs]
> [11319.763454]  btrfs_sync_file+0x76/0x420 [btrfs]
> [11319.763457]  ? get_empty_filp+0xc9/0x1b0
> [11319.763461]  vfs_fsync_range+0x4b/0xb0
> [11319.763473]  nfsd_commit+0xb1/0xe0 [nfsd]
> [11319.763481]  nfsd3_proc_commit+0x6e/0xd0 [nfsd]
> [11319.763487]  nfsd_dispatch+0xfb/0x230 [nfsd]
> [11319.763499]  svc_process_common+0x4a6/0x680 [sunrpc]
> [11319.763507]  svc_process+0xec/0x1c0 [sunrpc]
> [11319.763513]  nfsd+0xf4/0x160 [nfsd]
> [11319.763516]  kthread+0x125/0x140
> [11319.763522]  ? nfsd_destroy+0x70/0x70 [nfsd]
> [11319.763524]  ? kthread_create_on_node+0x70/0x70
> [11319.763528]  ret_from_fork+0x25/0x30
> [11319.763530] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 fa 21 ff ff 4c 89 ff e8 62 f3 fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9 d0 fe ff ff <0f> ff eb b6 e8 d9 e3 c5 d0 66 0f 1f 84 00 00 00 00 00 66 66 66 
> [11319.763568] ---[ end trace 40295351501208ff ]---
> 
> [11330.152285] ------------[ cut here ]------------
> [11330.152319] WARNING: CPU: 0 PID: 203 at fs/btrfs/ctree.h:1559 btrfs_update_device+0x1be/0x1d0 [btrfs]
> [11330.152320] Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_filter tun coretemp kvm_intel iTCO_wdt iTCO_vendor_support i915 gpio_ich ppdev kvm video i2c_algo_bit drm_kms_helper snd_hda_codec_idt snd_hda_codec_generic irqbypass drm syscopyarea psmouse sysfillrect snd_hda_intel pcspkr i2c_i801 e1000e mei_me sysimgblt snd_hda_codec evdev fb_sys_fops input_leds mei lpc_ich snd_hda_core snd_hwdep snd_pcm snd_timer snd soundcore parport_pc parport mac_hid ptp pps_core shpchp winbond_cir rc_core intel_agp intel_gtt led_class agpgart tpm_tis tpm_tis_core tpm button acpi_cpufreq nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc sch_fq_codel ip_tables x_tables crc32c_generic btrfs xor raid6_pq hid_generic
> [11330.152389]  sr_mod cdrom sd_mod usbhid hid serio_raw atkbd libps2 uhci_hcd firewire_ohci pata_it821x ahci libahci libata firewire_core scsi_mod crc_itu_t i8042 serio ehci_pci ehci_hcd usbcore usb_common
> [11330.152409] CPU: 0 PID: 203 Comm: btrfs-cleaner Tainted: G        W       4.13.5-1-ARCH #1
> [11330.152410] Hardware name:                  /DG33TL, BIOS DPP3510J.86A.0572.2009.0715.2346 07/15/2009
> [11330.152411] task: ffff90dd221ec4c0 task.stack: ffff9e1fc13f4000
> [11330.152427] RIP: 0010:btrfs_update_device+0x1be/0x1d0 [btrfs]
> [11330.152428] RSP: 0018:ffff9e1fc13f7d28 EFLAGS: 00010206
> [11330.152430] RAX: 0000000000000fff RBX: ffff90dd227d7c40 RCX: 000003a3816d1e00
> [11330.152431] RDX: 0000000000000004 RSI: 0000000000007e98 RDI: ffff90dcf76e2578
> [11330.152432] RBP: ffff9e1fc13f7d70 R08: 0000000000007e9c R09: ffff9e1fc13f7ce0
> [11330.152434] R10: 0000000000001000 R11: 0000000000000007 R12: ffff90dd21f77c00
> [11330.152435] R13: 0000000000000000 R14: 0000000000007e78 R15: ffff90dcf76e2578
> [11330.152437] FS:  0000000000000000(0000) GS:ffff90dd2bc00000(0000) knlGS:0000000000000000
> [11330.152438] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [11330.152440] CR2: 00007fec55264d30 CR3: 00000001703bf000 CR4: 00000000000006f0
> [11330.152441] Call Trace:
> [11330.152459]  btrfs_remove_chunk+0x365/0x890 [btrfs]
> [11330.152474]  btrfs_delete_unused_bgs+0x30d/0x3b0 [btrfs]
> [11330.152488]  cleaner_kthread+0x165/0x180 [btrfs]
> [11330.152493]  kthread+0x125/0x140
> [11330.152507]  ? __btree_submit_bio_start+0x20/0x20 [btrfs]
> [11330.152513]  ? kthread_create_on_node+0x70/0x70
> [11330.152516]  ret_from_fork+0x25/0x30
> [11330.152518] Code: 4c 89 ff 45 31 c0 ba 10 00 00 00 4c 89 f6 e8 fa 21 ff ff 4c 89 ff e8 62 f3 fc ff e9 d3 fe ff ff 41 bd f4 ff ff ff e9 d0 fe ff ff <0f> ff eb b6 e8 d9 e3 c5 d0 66 0f 1f 84 00 00 00 00 00 66 66 66 
> [11330.152556] ---[ end trace 4029535150120900 ]---

Those warnings are mostly, harmless and they are invoked when your device's size isn't a multiple of of sectorsize (which for now can only be 4kb). The easiest way to get rid of them is to resize your volume and make it a multiple of 4k. There are currently pending changes in btrfs progs which will be able to do that automatically. In any case there is nothing to worry about them. 

> 
> That first warning appeared 13 times in the logs, and the second one appeared only 
> once.
> 
> I haven't rebooted the machine since observing these warnings.  Things seem to be 
> working ok.  Please let me know if there's anything interesting to be learned from 
> it.
> 
> Thanks!
> 
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
