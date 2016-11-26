Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i4.italiaonline.it ([212.48.25.215]:34604 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751634AbcKZPFe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Nov 2016 10:05:34 -0500
From: Giuseppe Della Bianca <bepi@adria.it>
To: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Sat, 26 Nov 2016 15:56:34 +0100
Message-ID: <5108140.l7kIxhTaVr@exnet.gdb.it>
In-Reply-To: <1479730155.5832e3eb3fde8@webmail.adria.it>
References: <1479730155.5832e3eb3fde8@webmail.adria.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

from /var/log/messages

Nov 20 20:04:29 exnetold kernel: Modules linked in: fuse bridge ebtable_filter 
ebtables tun 8021q bnx2fc cnic uio garp mrp fcoe stp llc libfcoe libfc 
scsi_transport_fc nvidia_modeset(POE) nf_log_ipv4 nf_log_common xt_LOG 
xt_limit xt_multiport ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 
nf_defrag_ipv6 xt_CHECKSUM xt_conntrack iptable_mangle ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip6table_filter ip6_tables hwmon_vid btrfs 
snd_hda_codec_analog xor snd_hda_codec_generic raid6_pq snd_hda_codec_hdmi 
powernow_k8 snd_hda_intel kvm_amd snd_hda_codec nvidia(POE) kvm snd_hda_core 
snd_hwdep ppdev irqbypass snd_seq snd_seq_device snd_pcm amd64_edac_mod 
edac_mce_amd edac_core snd_timer snd drm parport_pc k8temp soundcore shpchp 
parport asus_atk0110 i2c_nforce2
Nov 20 20:04:29 exnetold kernel: acpi_cpufreq tpm_tis tpm vboxnetadp(OE) 
vboxnetflt(OE) vboxdrv(OE) binfmt_misc ata_generic pata_acpi serio_raw sata_nv 
forcedeth fjes analog gameport joydev i2c_dev
Nov 20 20:04:29 exnetold kernel: CPU: 1 PID: 16330 Comm: kworker/u4:0 Tainted: 
P           OE   4.4.6-301.fc23.x86_64 #1
Nov 20 20:04:29 exnetold kernel: Hardware name: System manufacturer System 
Product Name/M2N, BIOS 0902    02/16/2009
Nov 20 20:04:29 exnetold kernel: Workqueue: btrfs-extent-refs 
btrfs_extent_refs_helper [btrfs]
Nov 20 20:04:29 exnetold kernel: 0000000000000286 0000000061a6ce66 
ffff88008c797ae0 ffffffff813b542e
Nov 20 20:04:29 exnetold kernel: 0000000000000000 ffffffffa0c944d2 ffff88008c797b18 
ffffffff810a40f2
Nov 20 20:04:29 exnetold kernel: 00000006e7a80000 00000000fffffffe 
0000000000000000 ffff88004edc0000
Nov 20 20:04:29 exnetold kernel: Call Trace:
Nov 20 20:04:29 exnetold kernel: [<ffffffff813b542e>] dump_stack+0x63/0x85
Nov 20 20:04:29 exnetold kernel: [<ffffffff810a40f2>] 
warn_slowpath_common+0x82/0xc0
Nov 20 20:04:29 exnetold kernel: [<ffffffff810a423a>] warn_slowpath_null+0x1a/0x20
Nov 20 20:04:29 exnetold kernel: [<ffffffffa0bf8148>] 
__btrfs_free_extent.isra.69+0x898/0xd30 [btrfs]
Nov 20 20:04:29 exnetold kernel: [<ffffffffa0be99e6>] ? btrfs_free_path+0x26/0x30 
[btrfs]
Nov 20 20:04:29 exnetold kernel: [<ffffffffa0bf6601>] ? 
__btrfs_inc_extent_ref.isra.53+0x11/0x270 [btrfs]
Nov 20 20:04:29 exnetold kernel: [<ffffffffa0bfc0fc>] 
__btrfs_run_delayed_refs+0xa7c/0x11a0 [btrfs]
Nov 20 20:04:29 exnetold kernel: [<ffffffffa0bff4f2>] 
btrfs_run_delayed_refs+0x82/0x2a0 [btrfs]
Nov 20 20:04:29 exnetold kernel: [<ffffffffa0bff747>] 
delayed_ref_async_start+0x37/0x90 [btrfs]
Nov 20 20:04:29 exnetold kernel: [<ffffffffa0c45f42>] 
btrfs_scrubparity_helper+0xc2/0x2e0 [btrfs]
Nov 20 20:04:29 exnetold kernel: [<ffffffff810bae3d>] ? 
pwq_activate_delayed_work+0x3d/0x90
Nov 20 20:04:29 exnetold kernel: [<ffffffffa0c4619e>] 
btrfs_extent_refs_helper+0xe/0x10 [btrfs]
Nov 20 20:04:29 exnetold kernel: [<ffffffff810bc596>] process_one_work+0x156/0x430
Nov 20 20:04:29 exnetold kernel: [<ffffffff810bc8be>] worker_thread+0x4e/0x450
Nov 20 20:04:29 exnetold kernel: [<ffffffff810bc870>] ? 
process_one_work+0x430/0x430
Nov 20 20:04:29 exnetold kernel: [<ffffffff810c2648>] kthread+0xd8/0xf0
Nov 20 20:04:29 exnetold kernel: [<ffffffff810c2570>] ? 
kthread_worker_fn+0x160/0x160
Nov 20 20:04:29 exnetold kernel: [<ffffffff817a090f>] ret_from_fork+0x3f/0x70
Nov 20 20:04:29 exnetold kernel: [<ffffffff810c2570>] ? 
kthread_worker_fn+0x160/0x160
Nov 20 20:04:29 exnetold kernel: ---[ end trace 4a87ca727985e15e ]---
Nov 20 20:04:29 exnetold kernel: BTRFS info (device sda1): leaf 95421874176 
total ptrs 209 free space 3459
Nov 20 20:04:29 exnetold kernel: #011item 0 key (29654663168 169 0) itemoff 
16250 itemsize 33
Nov 20 20:04:29 exnetold kernel: #011#011extent refs 1 gen 400 flags 258
8717 itemsize 33
...... long text ......
Nov 20 20:04:30 exnetold kernel: #011#011extent refs 1 gen 473 flags 258
Nov 20 20:04:30 exnetold kernel: #011#011shared block backref parent 
29657972736
Nov 20 20:04:30 exnetold kernel: #011item 208 key (29658071040 169 0) itemoff 
8684 itemsize 33
Nov 20 20:04:30 exnetold kernel: #011#011extent refs 1 gen 473 flags 258
Nov 20 20:04:30 exnetold kernel: #011#011shared block backref parent 
29657972736
Nov 20 20:04:30 exnetold kernel: BTRFS error (device sda1): unable to find ref 
byte nr 29656350720 parent 0 root 448  owner 1 offset 0
Nov 20 20:04:30 exnetold kernel: ------------[ cut here ]------------
Nov 20 20:04:30 exnetold kernel: WARNING: CPU: 1 PID: 16330 at 
fs/btrfs/extent-tree.c:6549 __btrfs_free_extent.isra.69+0x8ff/0xd30 [btrfs]()
Nov 20 20:04:30 exnetold kernel: Modules linked in: fuse bridge ebtable_filter 
ebtables tun 8021q bnx2fc cnic uio garp mrp fcoe stp llc libfcoe libfc 
scsi_transport_fc nvidia_modeset(POE) nf_log_ipv4 nf_log_common xt_LOG 
xt_limit xt_multiport ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 
nf_defrag_ipv6 xt_CHECKSUM xt_conntrack iptable_mangle ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip6table_filter ip6_tables hwmon_vid btrfs 
snd_hda_codec_analog xor snd_hda_codec_generic raid6_pq snd_hda_codec_hdmi 
powernow_k8 snd_hda_intel kvm_amd snd_hda_codec nvidia(POE) kvm snd_hda_core 
snd_hwdep ppdev irqbypass snd_seq snd_seq_device snd_pcm amd64_edac_mod 
edac_mce_amd edac_core snd_timer snd drm parport_pc k8temp soundcore shpchp 
parport asus_atk0110 i2c_nforce2
Nov 20 20:04:30 exnetold kernel: acpi_cpufreq tpm_tis tpm vboxnetadp(OE) 
vboxnetflt(OE) vboxdrv(OE) binfmt_misc ata_generic pata_acpi serio_raw sata_nv 
forcedeth fjes analog gameport joydev i2c_dev
Nov 20 20:04:30 exnetold kernel: CPU: 1 PID: 16330 Comm: kworker/u4:0 Tainted: 
P        W  OE   4.4.6-301.fc23.x86_64 #1
Nov 20 20:04:30 exnetold kernel: Hardware name: System manufacturer System 
Product Name/M2N, BIOS 0902    02/16/2009
Nov 20 20:04:30 exnetold kernel: Workqueue: btrfs-extent-refs 
btrfs_extent_refs_helper [btrfs]
Nov 20 20:04:30 exnetold kernel: 0000000000000286 0000000061a6ce66 
ffff88008c797a88 ffffffff813b542e
Nov 20 20:04:30 exnetold kernel: ffff88008c797ad0 ffffffffa0c944d2 ffff88008c797ac0 
ffffffff810a40f2
Nov 20 20:04:30 exnetold kernel: 00000006e7a80000 00000000fffffffe 
0000000000000000 ffff88004edc0000
Nov 20 20:04:30 exnetold kernel: Call Trace:
Nov 20 20:04:30 exnetold kernel: [<ffffffff813b542e>] dump_stack+0x63/0x85
Nov 20 20:04:30 exnetold kernel: [<ffffffff810a40f2>] 
warn_slowpath_common+0x82/0xc0
Nov 20 20:04:30 exnetold kernel: [<ffffffff810a418c>] warn_slowpath_fmt+0x5c/0x80
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0bf81af>] 
__btrfs_free_extent.isra.69+0x8ff/0xd30 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0be99e6>] ? btrfs_free_path+0x26/0x30 
[btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0bf6601>] ? 
__btrfs_inc_extent_ref.isra.53+0x11/0x270 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0bfc0fc>] 
__btrfs_run_delayed_refs+0xa7c/0x11a0 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0bff4f2>] 
btrfs_run_delayed_refs+0x82/0x2a0 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0bff747>] 
delayed_ref_async_start+0x37/0x90 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0c45f42>] 
btrfs_scrubparity_helper+0xc2/0x2e0 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffff810bae3d>] ? 
pwq_activate_delayed_work+0x3d/0x90
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0c4619e>] 
btrfs_extent_refs_helper+0xe/0x10 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffff810bc596>] process_one_work+0x156/0x430
Nov 20 20:04:30 exnetold kernel: [<ffffffff810bc8be>] worker_thread+0x4e/0x450
Nov 20 20:04:30 exnetold kernel: [<ffffffff810bc870>] ? 
process_one_work+0x430/0x430
Nov 20 20:04:30 exnetold kernel: [<ffffffff810c2648>] kthread+0xd8/0xf0
Nov 20 20:04:30 exnetold kernel: [<ffffffff810c2570>] ? 
kthread_worker_fn+0x160/0x160
Nov 20 20:04:30 exnetold kernel: [<ffffffff817a090f>] ret_from_fork+0x3f/0x70
Nov 20 20:04:30 exnetold kernel: [<ffffffff810c2570>] ? 
kthread_worker_fn+0x160/0x160
Nov 20 20:04:30 exnetold kernel: ---[ end trace 4a87ca727985e15f ]---
Nov 20 20:04:30 exnetold kernel: BTRFS warning (device sda1): 
__btrfs_free_extent:6549: Aborting unused transaction(No such entry).
Nov 20 20:04:30 exnetold kernel: BTRFS warning (device sda1): 
btrfs_run_delayed_refs:2927: Aborting unused transaction(No such entry).
Nov 20 20:04:30 exnetold kernel: ------------[ cut here ]------------
Nov 20 20:04:30 exnetold kernel: WARNING: CPU: 1 PID: 16330 at 
fs/btrfs/extent-tree.c:6543 __btrfs_free_extent.isra.69+0x898/0xd30 [btrfs]()
Nov 20 20:04:30 exnetold kernel: Modules linked in: fuse bridge ebtable_filter 
ebtables tun 8021q bnx2fc cnic uio garp mrp fcoe stp llc libfcoe libfc 
scsi_transport_fc nvidia_modeset(POE) nf_log_ipv4 nf_log_common xt_LOG 
xt_limit xt_multiport ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 
nf_defrag_ipv6 xt_CHECKSUM xt_conntrack iptable_mangle ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack ip6table_filter ip6_tables hwmon_vid btrfs 
snd_hda_codec_analog xor snd_hda_codec_generic raid6_pq snd_hda_codec_hdmi 
powernow_k8 snd_hda_intel kvm_amd snd_hda_codec nvidia(POE) kvm snd_hda_core 
snd_hwdep ppdev irqbypass snd_seq snd_seq_device snd_pcm amd64_edac_mod 
edac_mce_amd edac_core snd_timer snd drm parport_pc k8temp soundcore shpchp 
parport asus_atk0110 i2c_nforce2
Nov 20 20:04:30 exnetold kernel: acpi_cpufreq tpm_tis tpm vboxnetadp(OE) 
vboxnetflt(OE) vboxdrv(OE) binfmt_misc ata_generic pata_acpi serio_raw sata_nv 
forcedeth fjes analog gameport joydev i2c_dev
Nov 20 20:04:30 exnetold kernel: CPU: 1 PID: 16330 Comm: kworker/u4:0 Tainted: 
P        W  OE   4.4.6-301.fc23.x86_64 #1
Nov 20 20:04:30 exnetold kernel: Hardware name: System manufacturer System 
Product Name/M2N, BIOS 0902    02/16/2009
Nov 20 20:04:30 exnetold kernel: Workqueue: btrfs-extent-refs 
btrfs_extent_refs_helper [btrfs]
Nov 20 20:04:30 exnetold kernel: 0000000000000286 0000000061a6ce66 
ffff88008c797ae0 ffffffff813b542e
Nov 20 20:04:30 exnetold kernel: 0000000000000000 ffffffffa0c944d2 ffff88008c797b18 
ffffffff810a40f2
Nov 20 20:04:30 exnetold kernel: 00000006e813c000 00000000fffffffe 
0000000000000000 ffff88004edc0000
Nov 20 20:04:30 exnetold kernel: Call Trace:
Nov 20 20:04:30 exnetold kernel: [<ffffffff813b542e>] dump_stack+0x63/0x85
Nov 20 20:04:30 exnetold kernel: [<ffffffff810a40f2>] 
warn_slowpath_common+0x82/0xc0
Nov 20 20:04:30 exnetold kernel: [<ffffffff810a423a>] warn_slowpath_null+0x1a/0x20
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0bf8148>] 
__btrfs_free_extent.isra.69+0x898/0xd30 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffff810fa10a>] ? console_unlock+0x20a/0x540
Nov 20 20:04:30 exnetold kernel: [<ffffffff810dabc2>] ? enqueue_entity+0x3a2/0xc90
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0bfc0fc>] 
__btrfs_run_delayed_refs+0xa7c/0x11a0 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffff8104f57d>] ? 
native_smp_send_reschedule+0x4d/0x70
Nov 20 20:04:30 exnetold kernel: [<ffffffff810cc1c5>] ? resched_curr+0x65/0xc0
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0bff4f2>] 
btrfs_run_delayed_refs+0x82/0x2a0 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0bff747>] 
delayed_ref_async_start+0x37/0x90 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0c45f42>] 
btrfs_scrubparity_helper+0xc2/0x2e0 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffff810bae3d>] ? 
pwq_activate_delayed_work+0x3d/0x90
Nov 20 20:04:30 exnetold kernel: [<ffffffffa0c4619e>] 
btrfs_extent_refs_helper+0xe/0x10 [btrfs]
Nov 20 20:04:30 exnetold kernel: [<ffffffff810bc596>] process_one_work+0x156/0x430
Nov 20 20:04:30 exnetold kernel: [<ffffffff810bc8be>] worker_thread+0x4e/0x450
Nov 20 20:04:30 exnetold kernel: [<ffffffff810bc870>] ? 
process_one_work+0x430/0x430
Nov 20 20:04:30 exnetold kernel: [<ffffffff810c2648>] kthread+0xd8/0xf0
Nov 20 20:04:30 exnetold kernel: [<ffffffff810c2570>] ? 
kthread_worker_fn+0x160/0x160
Nov 20 20:04:30 exnetold kernel: [<ffffffff817a090f>] ret_from_fork+0x3f/0x70
Nov 20 20:04:30 exnetold kernel: [<ffffffff810c2570>] ? 
kthread_worker_fn+0x160/0x160
Nov 20 20:04:30 exnetold kernel: ---[ end trace 4a87ca727985e160 ]---
Nov 20 20:04:30 exnetold kernel: BTRFS info (device sda1): leaf 95549276160 
total ptrs 230 free space 270
Nov 20 20:04:30 exnetold kernel: #011item 0 key (29662576640 169 0) itemoff 
16250 itemsize 33
Nov 20 20:04:30 exnetold kernel: #011#011extent refs 1 gen 473 flags 258
Nov 20 20:04:30 exnetold kernel: #011#011shared block backref parent 
29657972736
...... long text ......
Nov 20 20:04:30 exnetold kernel: #011#011shared block backref parent 
29744676864
Nov 20 20:04:30 exnetold kernel: #011#011shared block backref parent 
29637902336
Nov 20 20:04:30 exnetold kernel: #011#011shared block backref parent 
21741715456
Nov 20 20:04:30 exnetold kernel: #011#011shared block backref parent 
21556609024
Nov 20 20:04:30 exnetold kernel: BTRFS error (device sda1): unable to find ref 
byte nr 29663412224 parent 0 root 448  owner 1 offset 0
Nov 20 20:04:30 exnetold kernel: BTRFS: error (device sda1) in 
__btrfs_free_extent:6549: errno=-2 No such entry
Nov 20 20:04:31 exnetold kernel: BTRFS info (device sda1): forced readonly
Nov 20 20:04:31 exnetold kernel: BTRFS: error (device sda1) in 
btrfs_run_delayed_refs:2927: errno=-2 No such entry
................
Nov 20 20:04:44 exnetold kernel: BTRFS error (device sda1): cleaner 
transaction attach returned -30



In data lunedì 21 novembre 2016 13:09:15, bepi@adria.it ha scritto:
> Hi.
> 
> My system: Fedora 23, kernel-4.7.10-100.fc23.x86_64
> btrfs-progs-4.4.1-1.fc23.x86_64
> 
> Testing the remote differential receive (via ssh and in local network) of 24
> sequential snapshots, and simultaneously deleting the snapshot, (in the
> same file system, but in a different subvolume), there has been an file
> access error, and the file system has corrupt.
> 
> Both scrub, both recovery and clear_cache mount options, both btrfsck, have
> failed, the file system is left in a state unusable.
> 
> After reformatting the filesystem, remote receive of 24 snapshots worked
> properly.
> 
> The file system is used exclusively for receive the snapshot, it is composed
> of a single device.
> The initial snapshot is a linux installation of 50Gb.
> 
> 
> I think that there was a race condition between the receive and deletion of
> snapshots (that were performed on two different subvolume).
> 
> 
> Best regards.
> 
> gdb
> 
> ----------------------------------------------------
> This mail has been sent using Alpikom webmail system
> http://www.alpikom.it

