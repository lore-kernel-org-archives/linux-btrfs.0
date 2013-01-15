Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51603 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930Ab3AONT4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 08:19:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Tv6R0-00063G-1w
	for linux-btrfs@vger.kernel.org; Tue, 15 Jan 2013 14:20:10 +0100
Received: from tc-gate1.pci.uni-heidelberg.de ([129.206.21.241])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2013 14:20:10 +0100
Received: from bernd.schubert by tc-gate1.pci.uni-heidelberg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2013 14:20:10 +0100
To: linux-btrfs@vger.kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: abort transaction and RO
Date: Tue, 15 Jan 2013 14:19:42 +0100
Message-ID: <kd3l1c$bd$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm just improving ql-fstest[1] a bit and while testing the code I 
pressed ctrl-c. I'm not entirely sure, but rather likely that was the 
reason why the file system went into read-only.

This is with 3.7.0:

> [429066.090309] WARNING: at fs/btrfs/super.c:246 __btrfs_abort_transaction+0xd7/0xf0 [btrfs]()
> [429066.090310] Hardware name: ESPRIMO P900
> [429066.090311] btrfs: Transaction aborted
> [429066.090312] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs reiserfs ext3 jbd ext2 msr cpufreq_stats fuse xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cachefiles nfsv3 rfcomm parport_pc ppdev lp parport bnep bluetooth rfkill binfmt_misc bridge stp llc tun nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc dm_crypt xfs snd_hda_codec_conexant snd_hda_intel tpm_infineon snd_hda_codec snd_hwdep dm_multipath snd_pcm_oss snd_mixer_oss scsi_dh snd_pcm gpio_ich tpm_tis tpm tpm_bios processor ext4 mbcache mei kvm_intel jbd2 lpc_ich kvm snd_seq_midi snd_rawmidi snd_seq_midi_event joydev snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc evdev microcode sch5636 serio_raw sch56xx_common coretemp crc16 btrfs zlib_deflate libcrc32c raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod hid_microsoft hid_ge
neric usbhid hid dm_mod sr_mod sd_mod cdrom crc_t10dif i915 drm_kms_helper drm i2c_algo_bit i2c_core video thermal_sys crc32c_intel xhci_hcd ghash_clmulni_intel e1000e ahci libahci ehci_hcd usbcore aesni_intel ablk_helper cryptd lrw usb_common libata aes_x86_64 xts gf128mul scsi_mod button
> [429066.090364] Pid: 511117, comm: btrfs-transacti Tainted: G        W    3.7.0 #1
> [429066.090365] Call Trace:
> [429066.090370]  [<ffffffff81051aca>] warn_slowpath_common+0x7a/0xb0
> [429066.090374]  [<ffffffff81051ba1>] warn_slowpath_fmt+0x41/0x50
> [429066.090381]  [<ffffffffa03381f5>] ? btrfs_free_path+0x25/0x30 [btrfs]
> [429066.090386]  [<ffffffffa0334e77>] __btrfs_abort_transaction+0xd7/0xf0 [btrfs]
> [429066.090394]  [<ffffffffa035433b>] btrfs_save_ino_cache+0x2db/0x3d0 [btrfs]
> [429066.090401]  [<ffffffffa035c89c>] commit_fs_roots.isra.24+0xbc/0x190 [btrfs]
> [429066.090409]  [<ffffffffa03abb86>] ? btrfs_scrub_pause+0xf6/0x110 [btrfs]
> [429066.090416]  [<ffffffffa035d718>] btrfs_commit_transaction+0x598/0xae0 [btrfs]
> [429066.090418]  [<ffffffff81074ba0>] ? finish_wait+0x80/0x80
> [429066.090425]  [<ffffffffa03563fd>] transaction_kthread+0x19d/0x220 [btrfs]
> [429066.090432]  [<ffffffffa0356260>] ? btree_readpage_end_io_hook+0x2a0/0x2a0 [btrfs]
> [429066.090434]  [<ffffffff810742bb>] kthread+0xbb/0xc0
> [429066.090436]  [<ffffffff81074200>] ? kthread_create_on_node+0x120/0x120
> [429066.090438]  [<ffffffff8148e7bc>] ret_from_fork+0x7c/0xb0
> [429066.090440]  [<ffffffff81074200>] ? kthread_create_on_node+0x120/0x120
> [429066.090441] ---[ end trace 25cd8df3232ee3d8 ]---
> [429066.090443] BTRFS error (device dm-5) in btrfs_save_ino_cache:470: error 28
> [429066.090444] btrfs is forced readonly
> [429066.191480] ------------[ cut here ]------------
> [429066.191516] WARNING: at fs/btrfs/transaction.c:41 put_transaction+0x128/0x130 [btrfs]()
> [429066.191517] Hardware name: ESPRIMO P900
> [429066.191518] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs reiserfs ext3 jbd ext2 msr cpufreq_stats fuse xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cachefiles nfsv3 rfcomm parport_pc ppdev lp parport bnep bluetooth rfkill binfmt_misc bridge stp llc tun nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc dm_crypt xfs snd_hda_codec_conexant snd_hda_intel tpm_infineon snd_hda_codec snd_hwdep dm_multipath snd_pcm_oss snd_mixer_oss scsi_dh snd_pcm gpio_ich tpm_tis tpm tpm_bios processor ext4 mbcache mei kvm_intel jbd2 lpc_ich kvm snd_seq_midi snd_rawmidi snd_seq_midi_event joydev snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc evdev microcode sch5636 serio_raw sch56xx_common coretemp crc16 btrfs zlib_deflate libcrc32c raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod hid_microsoft hid_ge
neric usbhid hid dm_mod sr_mod sd_mod cdrom crc_t10dif i915 drm_kms_helper drm i2c_algo_bit i2c_core video thermal_sys crc32c_intel xhci_hcd ghash_clmulni_intel e1000e ahci libahci ehci_hcd usbcore aesni_intel ablk_helper cryptd lrw usb_common libata aes_x86_64 xts gf128mul scsi_mod button
> [429066.191570] Pid: 511117, comm: btrfs-transacti Tainted: G        W    3.7.0 #1
> [429066.191571] Call Trace:
> [429066.191576]  [<ffffffff81051aca>] warn_slowpath_common+0x7a/0xb0
> [429066.191578]  [<ffffffff81051b15>] warn_slowpath_null+0x15/0x20
> [429066.191585]  [<ffffffffa035ca98>] put_transaction+0x128/0x130 [btrfs]
> [429066.191592]  [<ffffffffa035db8a>] btrfs_commit_transaction+0xa0a/0xae0 [btrfs]
> [429066.191595]  [<ffffffff81074ba0>] ? finish_wait+0x80/0x80
> [429066.191602]  [<ffffffffa03563fd>] transaction_kthread+0x19d/0x220 [btrfs]
> [429066.191608]  [<ffffffffa0356260>] ? btree_readpage_end_io_hook+0x2a0/0x2a0 [btrfs]
> [429066.191610]  [<ffffffff810742bb>] kthread+0xbb/0xc0
> [429066.191612]  [<ffffffff81074200>] ? kthread_create_on_node+0x120/0x120
> [429066.191615]  [<ffffffff8148e7bc>] ret_from_fork+0x7c/0xb0
> [429066.191616]  [<ffffffff81074200>] ? kthread_create_on_node+0x120/0x120
> [429066.191618] ---[ end trace 25cd8df3232ee3d9 ]---

[1] https://bitbucket.org/aakef/ql-fstest

