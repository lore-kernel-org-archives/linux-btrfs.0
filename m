Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fall-lakeland.atl.sa.earthlink.net ([207.69.195.103]:46073 "EHLO
	fall-lakeland.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142Ab2HZUSt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Aug 2012 16:18:49 -0400
Received: from pop-gadwall.atl.sa.earthlink.net ([207.69.195.61])
	by fall-lakeland.atl.sa.earthlink.net with esmtp (Exim 4.34)
	id 1T5jIG-00035n-H9
	for linux-btrfs@vger.kernel.org; Sun, 26 Aug 2012 16:18:48 -0400
Received: from user-0c99blm.cable.mindspring.com ([24.148.174.182] helo=bubblegum.trusted)
	by pop-gadwall.atl.sa.earthlink.net with esmtp (Exim 3.36 #1)
	id 1T5j7O-00001L-00
	for linux-btrfs@vger.kernel.org; Sun, 26 Aug 2012 16:07:34 -0400
Date: Sun, 26 Aug 2012 16:07:33 -0400 (EDT)
From: tubalcane@earthlink.net
To: linux-btrfs@vger.kernel.org
Subject: crash while trying to access corrupt fs
Message-ID: <alpine.LFD.2.02.1208261605440.5416@bubblegum>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm primarily interested in the block level checksums of files and the scrubbing
feature to detect corrupt files.  Currently I use ext4 and create and keep
md5sums of everything which is tedious but I care about my data (quadruple
backups including offsite)

I decided to experiment by copying 7 large video files (total 900MB) to a btrfs
test drive and purposely corrupted the 4th file using the instructions here:

https://blogs.oracle.com/wim/entry/btrfs_scrub_go_fix_corruptions

umount, then remount, md5sum of the files and the entire machine locks up when
accessing the 4th file.  I rebooted, ran btrfs scrub, waited for it to finish. 
It detects the corruptions but I'm not doing RAID so it can't fix them.  Then I
tried to access the 4th file again and another crash.  Rebooted again and
crashed a third time just to be sure.

I'm running Fedora 17 and kernel 3.5.2, crash info below.  I saved the
btrfs-debug-tree output and can email it someone wants it (only 21K gzipped)


Aug 25 11:37:24 bubblegum kernel: [ 1183.786267] btrfs csum failed ino 260 off 0 csum 3029581555 private 3057259415
Aug 25 11:37:24 bubblegum kernel: [ 1183.786273] unable to find logical 0 len 0
Aug 25 11:37:24 bubblegum kernel: [ 1183.786297] ------------[ cut here ]------------
Aug 25 11:37:24 bubblegum kernel: [ 1183.787326] kernel BUG at fs/btrfs/volumes.c:3762!
Aug 25 11:37:24 bubblegum kernel: [ 1183.789085] invalid opcode: 0000 [#1] SMP
Aug 25 11:37:24 bubblegum kernel: [ 1183.792003] CPU 6
Aug 25 11:37:24 bubblegum kernel: [ 1183.792008] Modules linked in: btrfs libcrc32c zlib_deflate fuse ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptab
le_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc tpm_bios vhost_net tun macvtap macvlan nfsd coretemp kvm_in
tel kvm snd_hda_codec_realtek nfs_acl auth_rpcgss lockd snd_hda_intel snd_hda_codec sunrpc lpc_ich mfd_core i7core_edac edac_core i2c_i801 snd_hwdep snd_pcm snd_page_allo
c snd_timer snd soundcore microcode r8169 uinput mii binfmt_misc ata_generic pata_acpi crc32c_intel usb_storage pata_jmicron sata_mv hid_logitech_dj nouveau mxm_wmi wmi v
ideo i2c_algo_bit drm_kms_helper ttm drm i2c_core [last unloaded: scsi_wait_scan]
Aug 25 11:37:24 bubblegum kernel: [ 1183.802920]
Aug 25 11:37:24 bubblegum kernel: [ 1183.805100] Pid: 1783, comm: btrfs-endio-1 Not tainted 3.5.2-1.fc17.x86_64 #1 Gigabyte Technology Co., Ltd. P55M-UD2/P55M-UD2
Aug 25 11:37:24 bubblegum kernel: [ 1183.809165] RIP: 0010:[<ffffffffa04ce1e8>]  [<ffffffffa04ce1e8>] __btrfs_map_block+0x678/0x690 [btrfs]
Aug 25 11:37:24 bubblegum kernel: [ 1183.813476] RSP: 0018:ffff8803e5c3fc60  EFLAGS: 00010282
Aug 25 11:37:24 bubblegum kernel: [ 1183.815061] RAX: 000000000000001e RBX: 0000000000000000 RCX: 00000000000000c4
Aug 25 11:37:24 bubblegum kernel: [ 1183.816203] RDX: 000000000000004a RSI: 0000000000000046 RDI: 0000000000000246
Aug 25 11:37:24 bubblegum kernel: [ 1183.817347] RBP: ffff8803e5c3fd00 R08: 0000000000000449 R09: 0000000000000000
Aug 25 11:37:24 bubblegum kernel: [ 1183.818748] R10: 0000000000000000 R11: 0000000000040000 R12: ffff88040109e108
Aug 25 11:37:24 bubblegum kernel: [ 1183.819904] R13: ffff8803f4e54010 R14: 0000000000000fff R15: ffff8803e5c3fd10
Aug 25 11:37:24 bubblegum kernel: [ 1183.821067] FS:  0000000000000000(0000) GS:ffff88041fd80000(0000) knlGS:0000000000000000
Aug 25 11:37:24 bubblegum kernel: [ 1183.822236] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 25 11:37:24 bubblegum kernel: [ 1183.823411] CR2: 0000003b66b47090 CR3: 0000000001c0b000 CR4: 00000000000007e0
Aug 25 11:37:24 bubblegum kernel: [ 1183.824594] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 25 11:37:24 bubblegum kernel: [ 1183.825783] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 25 11:37:24 bubblegum kernel: [ 1183.826974] Process btrfs-endio-1 (pid: 1783, threadinfo ffff8803e5c3e000, task ffff8803e5c10000)
Aug 25 11:37:24 bubblegum kernel: [ 1183.828168] Stack:
Aug 25 11:37:24 bubblegum kernel: [ 1183.829363]  ffff8803f37c2c00 0000000000001000 ffff8803e5c3fcd0 ffffffff81602828
Aug 25 11:37:24 bubblegum kernel: [ 1183.830579]  ffff8803e5c3fcc0 0000000000000028 ffff8803e5c3fce0 ffff8803e5c3fca0
Aug 25 11:37:24 bubblegum kernel: [ 1183.831796]  ffff88034b6c410c ffff8803e5c3fd18 0000000000000000 00000000b493bef3
Aug 25 11:37:24 bubblegum kernel: [ 1183.833013] Call Trace:
Aug 25 11:37:24 bubblegum kernel: [ 1183.834243]  [<ffffffff81602828>] ? printk+0x61/0x63
Aug 25 11:37:24 bubblegum kernel: [ 1183.835479]  [<ffffffffa04d344a>] btrfs_find_device_for_logical+0x4a/0xa0 [btrfs]
Aug 25 11:37:24 bubblegum kernel: [ 1183.836717]  [<ffffffffa04c6955>] end_bio_extent_readpage+0x105/0xa80 [btrfs]
Aug 25 11:37:24 bubblegum kernel: [ 1183.837938]  [<ffffffff81173569>] ? kfree+0x139/0x160
Aug 25 11:37:24 bubblegum kernel: [ 1183.839157]  [<ffffffff811baaad>] bio_endio+0x1d/0x40
Aug 25 11:37:24 bubblegum kernel: [ 1183.840395]  [<ffffffffa049be81>] end_workqueue_fn+0x41/0x50 [btrfs]
Aug 25 11:37:24 bubblegum kernel: [ 1183.841635]  [<ffffffffa04d4d46>] worker_loop+0x136/0x580 [btrfs]
Aug 25 11:37:24 bubblegum kernel: [ 1183.842876]  [<ffffffffa04d4c10>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
Aug 25 11:37:24 bubblegum kernel: [ 1183.844093]  [<ffffffff8107b4e3>] kthread+0x93/0xa0
Aug 25 11:37:24 bubblegum kernel: [ 1183.845309]  [<ffffffff81615be4>] kernel_thread_helper+0x4/0x10
Aug 25 11:37:24 bubblegum kernel: [ 1183.846522]  [<ffffffff8107b450>] ? flush_kthread_worker+0x80/0x80
Aug 25 11:37:24 bubblegum kernel: [ 1183.847741]  [<ffffffff81615be0>] ? gs_change+0x13/0x13
Aug 25 11:37:24 bubblegum kernel: [ 1183.848952] Code: e6 89 c7 eb a4 0f 0b c7 45 c4 01 00 00 00 31 db e9 06 fd ff ff 0f 0b 49 8b 17 48 89 de 48 c7 c7 e8 92 50 a0 31 c0 e
8 df 45 13 e1 <0f> 0b 0f 0b 89 df e9 73 ff ff ff 66 66 66 66 2e 0f 1f 84 00 00
Aug 25 11:37:24 bubblegum kernel: [ 1183.850358] RIP  [<ffffffffa04ce1e8>] __btrfs_map_block+0x678/0x690 [btrfs]
Aug 25 11:37:24 bubblegum kernel: [ 1183.851677]  RSP <ffff8803e5c3fc60>
Aug 25 11:37:24 bubblegum kernel: [ 1183.890781] ---[ end trace afd1a418cb384dde ]---
Aug 25 11:37:25 bubblegum sh[676]: abrt-dump-oops: Found oopses: 1
Aug 25 11:37:25 bubblegum sh[676]: abrt-dump-oops: Creating dump directories
Aug 25 11:37:25 bubblegum abrtd: Directory 'oops-2012-08-25-11:37:25-1856-0' creation detected
Aug 25 11:37:25 bubblegum abrt-dump-oops: Reported 1 kernel oopses to Abrt
Aug 25 11:37:25 bubblegum abrtd: Can't open file '/var/spool/abrt/oops-2012-08-25-11:37:25-1856-0/uid': No such file or directory
Aug 25 11:37:25 bubblegum abrtd: New problem directory /var/spool/abrt/oops-2012-08-25-11:37:25-1856-0, processing
Aug 25 11:37:25 bubblegum abrtd: Can't open file '/var/spool/abrt/oops-2012-08-25-11:37:25-1856-0/uid': No such file or directory
Aug 25 11:37:46 bubblegum dbus-daemon[791]: ** Message: No devices in use, exit

