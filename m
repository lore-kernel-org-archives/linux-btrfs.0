Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:36391 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2H0LM1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 07:12:27 -0400
Message-ID: <503B561A.1060203@giantdisaster.de>
Date: Mon, 27 Aug 2012 13:12:26 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: tubalcane@earthlink.net
CC: linux-btrfs@vger.kernel.org
Subject: Re: crash while trying to access corrupt fs
References: <alpine.LFD.2.02.1208261605440.5416@bubblegum>
In-Reply-To: <alpine.LFD.2.02.1208261605440.5416@bubblegum>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 26 Aug 2012 16:07:33 -0400 (EDT), tubalcane wrote:
> I'm primarily interested in the block level checksums of files and the
> scrubbing
> feature to detect corrupt files.  Currently I use ext4 and create and keep
> md5sums of everything which is tedious but I care about my data (quadruple
> backups including offsite)
> 
> I decided to experiment by copying 7 large video files (total 900MB) to
> a btrfs
> test drive and purposely corrupted the 4th file using the instructions
> here:
> 
> https://blogs.oracle.com/wim/entry/btrfs_scrub_go_fix_corruptions
> 
> umount, then remount, md5sum of the files and the entire machine locks
> up when
> accessing the 4th file.  I rebooted, ran btrfs scrub, waited for it to
> finish. It detects the corruptions but I'm not doing RAID so it can't
> fix them.  Then I
> tried to access the 4th file again and another crash.  Rebooted again and
> crashed a third time just to be sure.
> 
> I'm running Fedora 17 and kernel 3.5.2, crash info below.  I saved the
> btrfs-debug-tree output and can email it someone wants it (only 21K
> gzipped)
> 
> 
> Aug 25 11:37:24 bubblegum kernel: [ 1183.786267] btrfs csum failed ino
> 260 off 0 csum 3029581555 private 3057259415
> Aug 25 11:37:24 bubblegum kernel: [ 1183.786273] unable to find logical
> 0 len 0
> Aug 25 11:37:24 bubblegum kernel: [ 1183.786297] ------------[ cut here
> ]------------
> Aug 25 11:37:24 bubblegum kernel: [ 1183.787326] kernel BUG at
> fs/btrfs/volumes.c:3762!
> Aug 25 11:37:24 bubblegum kernel: [ 1183.789085] invalid opcode: 0000
> [#1] SMP
> Aug 25 11:37:24 bubblegum kernel: [ 1183.792003] CPU 6
> Aug 25 11:37:24 bubblegum kernel: [ 1183.792008] Modules linked in:
> btrfs libcrc32c zlib_deflate fuse ip6table_filter ip6_tables ebtable_nat
> ebtables ipt_MASQUERADE iptab
> le_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
> xt_CHECKSUM iptable_mangle bridge stp llc tpm_bios vhost_net tun macvtap
> macvlan nfsd coretemp kvm_in
> tel kvm snd_hda_codec_realtek nfs_acl auth_rpcgss lockd snd_hda_intel
> snd_hda_codec sunrpc lpc_ich mfd_core i7core_edac edac_core i2c_i801
> snd_hwdep snd_pcm snd_page_allo
> c snd_timer snd soundcore microcode r8169 uinput mii binfmt_misc
> ata_generic pata_acpi crc32c_intel usb_storage pata_jmicron sata_mv
> hid_logitech_dj nouveau mxm_wmi wmi v
> ideo i2c_algo_bit drm_kms_helper ttm drm i2c_core [last unloaded:
> scsi_wait_scan]
> Aug 25 11:37:24 bubblegum kernel: [ 1183.802920]
> Aug 25 11:37:24 bubblegum kernel: [ 1183.805100] Pid: 1783, comm:
> btrfs-endio-1 Not tainted 3.5.2-1.fc17.x86_64 #1 Gigabyte Technology
> Co., Ltd. P55M-UD2/P55M-UD2
> Aug 25 11:37:24 bubblegum kernel: [ 1183.809165] RIP:
> 0010:[<ffffffffa04ce1e8>]  [<ffffffffa04ce1e8>]
> __btrfs_map_block+0x678/0x690 [btrfs]
> Aug 25 11:37:24 bubblegum kernel: [ 1183.813476] RSP:
> 0018:ffff8803e5c3fc60  EFLAGS: 00010282
> Aug 25 11:37:24 bubblegum kernel: [ 1183.815061] RAX: 000000000000001e
> RBX: 0000000000000000 RCX: 00000000000000c4
> Aug 25 11:37:24 bubblegum kernel: [ 1183.816203] RDX: 000000000000004a
> RSI: 0000000000000046 RDI: 0000000000000246
> Aug 25 11:37:24 bubblegum kernel: [ 1183.817347] RBP: ffff8803e5c3fd00
> R08: 0000000000000449 R09: 0000000000000000
> Aug 25 11:37:24 bubblegum kernel: [ 1183.818748] R10: 0000000000000000
> R11: 0000000000040000 R12: ffff88040109e108
> Aug 25 11:37:24 bubblegum kernel: [ 1183.819904] R13: ffff8803f4e54010
> R14: 0000000000000fff R15: ffff8803e5c3fd10
> Aug 25 11:37:24 bubblegum kernel: [ 1183.821067] FS: 
> 0000000000000000(0000) GS:ffff88041fd80000(0000) knlGS:0000000000000000
> Aug 25 11:37:24 bubblegum kernel: [ 1183.822236] CS:  0010 DS: 0000 ES:
> 0000 CR0: 000000008005003b
> Aug 25 11:37:24 bubblegum kernel: [ 1183.823411] CR2: 0000003b66b47090
> CR3: 0000000001c0b000 CR4: 00000000000007e0
> Aug 25 11:37:24 bubblegum kernel: [ 1183.824594] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Aug 25 11:37:24 bubblegum kernel: [ 1183.825783] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Aug 25 11:37:24 bubblegum kernel: [ 1183.826974] Process btrfs-endio-1
> (pid: 1783, threadinfo ffff8803e5c3e000, task ffff8803e5c10000)
> Aug 25 11:37:24 bubblegum kernel: [ 1183.828168] Stack:
> Aug 25 11:37:24 bubblegum kernel: [ 1183.829363]  ffff8803f37c2c00
> 0000000000001000 ffff8803e5c3fcd0 ffffffff81602828
> Aug 25 11:37:24 bubblegum kernel: [ 1183.830579]  ffff8803e5c3fcc0
> 0000000000000028 ffff8803e5c3fce0 ffff8803e5c3fca0
> Aug 25 11:37:24 bubblegum kernel: [ 1183.831796]  ffff88034b6c410c
> ffff8803e5c3fd18 0000000000000000 00000000b493bef3
> Aug 25 11:37:24 bubblegum kernel: [ 1183.833013] Call Trace:
> Aug 25 11:37:24 bubblegum kernel: [ 1183.834243]  [<ffffffff81602828>] ?
> printk+0x61/0x63
> Aug 25 11:37:24 bubblegum kernel: [ 1183.835479]  [<ffffffffa04d344a>]
> btrfs_find_device_for_logical+0x4a/0xa0 [btrfs]
> Aug 25 11:37:24 bubblegum kernel: [ 1183.836717]  [<ffffffffa04c6955>]
> end_bio_extent_readpage+0x105/0xa80 [btrfs]
> Aug 25 11:37:24 bubblegum kernel: [ 1183.837938]  [<ffffffff81173569>] ?
> kfree+0x139/0x160
> Aug 25 11:37:24 bubblegum kernel: [ 1183.839157]  [<ffffffff811baaad>]
> bio_endio+0x1d/0x40
> Aug 25 11:37:24 bubblegum kernel: [ 1183.840395]  [<ffffffffa049be81>]
> end_workqueue_fn+0x41/0x50 [btrfs]
> Aug 25 11:37:24 bubblegum kernel: [ 1183.841635]  [<ffffffffa04d4d46>]
> worker_loop+0x136/0x580 [btrfs]

That crash is a bug which I have introduced with the IO error stats. It can happen after checksum errors are detected.
I'll send a patch to (temporarily) remove the counting for checksum errors in the IO error stats.
