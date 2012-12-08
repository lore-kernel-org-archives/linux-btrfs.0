Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57735 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab2LHQRL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Dec 2012 11:17:11 -0500
Received: by mail-gg0-f174.google.com with SMTP id k2so252898ggd.19
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Dec 2012 08:17:10 -0800 (PST)
Date: Sat, 8 Dec 2012 10:16:53 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Help with corrupt filesystem: __btrfs_free_extent:5236: IO failure
Message-ID: <20121208161653.GA31750@lintop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It appears I've managed to corrupt my btrfs filesystem, and I'm
looking for some advice on how to proceed hopefully loosing as little
of my data as possible.

I have two 3TB drives configured as btrfs RAID 1, sdc and sdd.  My
system is currently running Fedora 17 with the stock Fedora 3.6.8
kernel.  The problem started Wednesday night when I started when I got
the following errors:

 5 19:35:57 mediacenter kernel: [ 5663.700468] ata5.00: exception Emask 0x10 SAct 0x7fffffff SErr 0x400100 action 0x6 frozen
Dec  5 19:35:57 mediacenter kernel: [ 5663.700473] ata5.00: irq_stat 0x08000000, interface fatal error
Dec  5 19:35:57 mediacenter kernel: [ 5663.700476] ata5: SError: { UnrecovData Handshk }
Dec  5 19:35:57 mediacenter kernel: [ 5663.700479] ata5.00: failed command: WRITE FPDMA QUEUED
Dec  5 19:35:57 mediacenter kernel: [ 5663.700483] ata5.00: cmd 61/08:00:28:ad:26/00:00:00:00:00/40 tag 0 ncq 4096 out
Dec  5 19:35:57 mediacenter kernel: [ 5663.700483]          res 40/00:90:28:c0:26/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
Dec  5 19:35:57 mediacenter kernel: [ 5663.700498] ata5.00: status: { DRDY }
Dec  5 19:35:57 mediacenter kernel: [ 5663.700500] ata5.00: failed command: WRITE FPDMA QUEUED
Dec  5 19:35:57 mediacenter kernel: [ 5663.700504] ata5.00: cmd 61/08:08:50:af:26/00:00:00:00:00/40 tag 1 ncq 4096 out
Dec  5 19:35:57 mediacenter kernel: [ 5663.700504]          res 40/00:90:28:c0:26/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
... snip ...
Dec  5 19:35:57 mediacenter kernel: [ 5723.886287] sd 4:0:0:0: [sdc] Unhandled error code
Dec  5 19:35:57 mediacenter kernel: [ 5723.886290] sd 4:0:0:0: [sdc]  
Dec  5 19:35:57 mediacenter kernel: [ 5723.886292] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Dec  5 19:35:57 mediacenter kernel: [ 5723.886295] sd 4:0:0:0: [sdc] CDB: 
Dec  5 19:35:57 mediacenter kernel: [ 5723.886296] Write(10): 2a 00 0d 80 32 d0 00 00 10 00
Dec  5 19:35:57 mediacenter kernel: [ 5723.886314] sd 4:0:0:0: [sdc] Unhandled error code
Dec  5 19:35:57 mediacenter kernel: [ 5723.886316] sd 4:0:0:0: [sdc]  
Dec  5 19:35:57 mediacenter kernel: [ 5723.886318] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Dec  5 19:35:57 mediacenter kernel: [ 5723.886321] sd 4:0:0:0: [sdc] CDB: 
Dec  5 19:35:57 mediacenter kernel: [ 5723.886323] Write(10): 2a 00 0d 8e d2 30 00 00 08 00
Dec  5 19:35:57 mediacenter kernel: [ 5723.886344] sd 4:0:0:0: [sdc] Unhandled error code
Dec  5 19:35:57 mediacenter kernel: [ 5723.886347] sd 4:0:0:0: [sdc]  
...

The DID_BAD_TARGET errors repeat over and over.  As soon as I realized
this was happening ~30 minutes later.  I shutdown the machine and
rebooted.  When the machine came back up the sdc errors had stopped
but there were numerous 'btrfs checksum failed sdc fixing' type
messages which seemed to indicate btrfs was successfully rebuilding my
RAID 1 array as it encountered bad blocks on sdc.  At this point I
thought it would be a good idea to help the process along so I started
a 'btrfs scrub start /' and went off to bed to let it churn through my
~3TB of data.  Sadly in the morning I was met with the following
"kernel BUG at fs/btrfs/print-tree.c:136!" traces.

https://dl.dropbox.com/u/84066079/2012-12-06%2007.14.45.jpg
https://dl.dropbox.com/u/84066079/2012-12-06%2007.15.41.jpg

I apologize for the image quality.  You can also see this was not the
first trace so perhaps those stacks are useless.  At this point I once
again rebooted the machine, and now get the following error:


[   85.654087] btrfs: sdd2 checksum verify failed on 2846359552 wanted 629C2943 found F9E529B8 level 0
[   85.665055] btrfs: sdd2 checksum verify failed on 2846359552 wanted 629C2943 found 6FA72C28 level 0
[   85.665069] ------------[ cut here ]------------
[   85.665099] WARNING: at fs/btrfs/super.c:246 __btrfs_abort_transaction+0xad/0xc0 [btrfs]()
[   85.665101] Hardware name:         
[   85.665103] btrfs: Transaction aborted
[   85.665105] Modules linked in: lockd sunrpc bnep bluetooth rfkill ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_mac nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_filter xt_state nf_conntrack ip6_tables snd_hda_codec_idt snd_hda_codec_hdmi rc_imon_pad imon snd_hda_intel snd_hda_codec snd_hwdep snd_seq rc_core snd_seq_device snd_pcm snd_page_alloc raid1 raid0 coretemp snd_timer iTCO_wdt kvm_intel iTCO_vendor_support snd kvm e1000e serio_raw lpc_ich microcode soundcore mfd_core i2c_i801 mei uinput btrfs libcrc32c zlib_deflate firewire_ohci ata_generic firewire_core pata_acpi crc_itu_t pata_marvell i915 video i2c_algo_bit drm_kms_helper drm i2c_core usb_storage
[   85.665158] Pid: 1091, comm: xkbcomp Not tainted 3.6.8-2.fc17.x86_64 #1
[   85.665161] Call Trace:
[   85.665168]  [<ffffffff8105c8ef>] warn_slowpath_common+0x7f/0xc0
[   85.665173]  [<ffffffff8105c9e6>] warn_slowpath_fmt+0x46/0x50
[   85.665179]  [<ffffffff8117a899>] ? kmem_cache_free+0x39/0x130
[   85.665192]  [<ffffffffa014ae4d>] __btrfs_abort_transaction+0xad/0xc0 [btrfs]
[   85.665217]  [<ffffffffa015bc03>] __btrfs_free_extent+0x223/0x800 [btrfs]
[   85.665228]  [<ffffffffa0160676>] run_clustered_refs+0x466/0xb50 [btrfs]
[   85.665242]  [<ffffffffa01b7257>] ? __btrfs_release_delayed_node+0x67/0x190 [btrfs]
[   85.665255]  [<ffffffffa01ad3a3>] ? find_ref_head+0x83/0xf0 [btrfs]
[   85.665265]  [<ffffffffa0160e48>] btrfs_run_delayed_refs+0xe8/0x2e0 [btrfs]
[   85.665277]  [<ffffffffa01730f1>] __btrfs_end_transaction+0xf1/0x3a0 [btrfs]
[   85.665290]  [<ffffffffa0173415>] btrfs_end_transaction+0x15/0x20 [btrfs]
[   85.665302]  [<ffffffffa017f96b>] btrfs_create+0x7b/0x210 [btrfs]
[   85.665306]  [<ffffffff8119ec05>] vfs_create+0xb5/0x110
[   85.665308]  [<ffffffff8119f5c2>] do_last+0x962/0xdf0
[   85.665311]  [<ffffffff8119c048>] ? inode_permission+0x18/0x50
[   85.665314]  [<ffffffff8119fb0a>] path_openat+0xba/0x4d0
[   85.665316]  [<ffffffff811a7303>] ? d_splice_alias+0x53/0x100
[   85.665329]  [<ffffffffa017e521>] ? btrfs_lookup+0x21/0x50 [btrfs]
[   85.665332]  [<ffffffff8119a84b>] ? lookup_dcache+0xab/0xd0
[   85.665334]  [<ffffffff811a0181>] do_filp_open+0x41/0xa0
[   85.665337]  [<ffffffff811ac20d>] ? alloc_fd+0x4d/0x120
[   85.665340]  [<ffffffff8118f4e6>] do_sys_open+0xf6/0x1e0
[   85.665344]  [<ffffffff810d860c>] ? __audit_syscall_entry+0xcc/0x300
[   85.665346]  [<ffffffff8118f5f1>] sys_open+0x21/0x30
[   85.665349]  [<ffffffff81626e69>] system_call_fastpath+0x16/0x1b
[   85.665351] ---[ end trace 408cb625cd30dc8d ]---
[   85.665353] BTRFS error (device sdd2) in __btrfs_free_extent:5236: IO failure
[   85.665355] btrfs is forced readonly
[   85.665357] btrfs: run_one_delayed_ref returned -5
[   85.665359] BTRFS error (device sdd2) in btrfs_run_delayed_refs:2521: IO failure

So am I screwed?  I suppose since the drives do mount read only I
should be able to copy all of the salvageable data to some new drives.
Is this my only option?

Thanks,
Shawn
