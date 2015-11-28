Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40225 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbbK1Nqh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 08:46:37 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1a2fpi-0003Em-BA
	for linux-btrfs@vger.kernel.org; Sat, 28 Nov 2015 13:46:34 +0000
Date: Sat, 28 Nov 2015 13:46:34 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Bug/regression: Read-only mount not read-only
Message-ID: <20151128134634.GF24333@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PsoQMlSWCswIFQyi"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--PsoQMlSWCswIFQyi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   We've just had someone on IRC with a problem mounting their FS. The
main problem is that they've got a corrupt log tree. That isn't the
subject of this email, though.

   The issue I'd like to raise is that even with -oro as a point
option, the FS is trying to replay the log tree. The dmesg output from
mount -oro is at the end of the email.

   Now, my memory, experience and understanding is that the FS
doesn't, and shouldn't replay the log tree on a RO mount, because the
FS should still be consistent even without the reply, and
RO-means-actually-RO is possible and desirable. (Compared to a
journalling FS, where journal replay is required for a consistent,
usable FS).

   So, this looks to me like a regression that's come in somewhere.

   (Just for completeness, the system in question usually runs 4.2.5,
but the live CD the OP is using is 4.2.3).

   Hugo.

[ 2058.530542] BTRFS info (device sda1): disk space caching is enabled
[ 2058.530548] BTRFS: has skinny extents
[ 2060.449981] ------------[ cut here ]------------
[ 2060.450015] WARNING: CPU: 1 PID: 2650 at fs/btrfs/extent-tree.c:6255 __btrfs_free_extent.isra.68+0x8c8/0xd70 [btrfs]()
[ 2060.450031] Modules linked in: bnep bluetooth rfkill ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_filter ebtable_nat ebtable_broute bridge ebtables ip6table_mangle ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_security iptable_raw coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic gpio_ich snd_hda_intel snd_hda_codec iTCO_wdt iTCO_vendor_support ppdev lpc_ich snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd i2c_i801 soundcore mei_me mei tpm_infineon parport_pc tpm_tis parport shpchp tpm acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace isofs squashfs btrfs xor i915 raid6_pq hid_logitech_hidpp
[ 2060.450111]  video i2c_algo_bit drm_kms_helper drm uas crc32c_intel 8021q garp stp usb_storage llc serio_raw mrp r8169 hid_logitech_dj mii scsi_dh_rdac scsi_dh_emc scsi_dh_alua sunrpc loop
[ 2060.450191] CPU: 1 PID: 2650 Comm: mount Tainted: G        W       4.2.3-300.fc23.x86_64 #1
[ 2060.450195] Hardware name: MSI MS-7636/H55M-P31(MS-7636)   , BIOS V1.9 09/14/2010
[ 2060.450197]  0000000000000000 0000000073c9bbcf ffff8800780af618 ffffffff81771fca
[ 2060.450202]  0000000000000000 0000000000000000 ffff8800780af658 ffffffff8109e4a6
[ 2060.450206]  0000000000000002 000000252f595000 00000000fffffffe 0000000000000000
[ 2060.450211] Call Trace:
[ 2060.450221]  [<ffffffff81771fca>] dump_stack+0x45/0x57
[ 2060.450229]  [<ffffffff8109e4a6>] warn_slowpath_common+0x86/0xc0
[ 2060.450233]  [<ffffffff8109e5da>] warn_slowpath_null+0x1a/0x20
[ 2060.450252]  [<ffffffffa0323628>] __btrfs_free_extent.isra.68+0x8c8/0xd70 [btrfs]
[ 2060.450309]  [<ffffffffa038ba5a>] ? find_ref_head+0x5a/0x80 [btrfs]
[ 2060.450331]  [<ffffffffa03273c8>] __btrfs_run_delayed_refs+0x998/0x1080 [btrfs]
[ 2060.450351]  [<ffffffffa032a674>] btrfs_run_delayed_refs.part.73+0x74/0x270 [btrfs]
[ 2060.450371]  [<ffffffffa032a885>] btrfs_run_delayed_refs+0x15/0x20 [btrfs]
[ 2060.450420]  [<ffffffffa033ef26>] btrfs_commit_transaction+0x56/0xad0 [btrfs]
[ 2060.450447]  [<ffffffffa03620bf>] ? free_extent_buffer+0x4f/0xa0 [btrfs]
[ 2060.450474]  [<ffffffffa0383bed>] btrfs_recover_log_trees+0x3ed/0x490 [btrfs]
[ 2060.450501]  [<ffffffffa037f260>] ? replay_one_extent+0x680/0x680 [btrfs]
[ 2060.450524]  [<ffffffffa033c33e>] open_ctree+0x19be/0x23f0 [btrfs]
[ 2060.450539]  [<ffffffffa0311f8e>] btrfs_mount+0x94e/0xa70 [btrfs]
[ 2060.450546]  [<ffffffff813b0795>] ? find_next_bit+0x15/0x20
[ 2060.450551]  [<ffffffff811c66ad>] ? pcpu_alloc+0x38d/0x670
[ 2060.450557]  [<ffffffff81221ef8>] mount_fs+0x38/0x160
[ 2060.450561]  [<ffffffff811c69c5>] ? __alloc_percpu+0x15/0x20
[ 2060.450565]  [<ffffffff8123cc1b>] vfs_kern_mount+0x6b/0x110
[ 2060.450579]  [<ffffffffa0311828>] btrfs_mount+0x1e8/0xa70 [btrfs]
[ 2060.450584]  [<ffffffff811c66ad>] ? pcpu_alloc+0x38d/0x670
[ 2060.450588]  [<ffffffff81221ef8>] mount_fs+0x38/0x160
[ 2060.450592]  [<ffffffff811c69c5>] ? __alloc_percpu+0x15/0x20
[ 2060.450596]  [<ffffffff8123cc1b>] vfs_kern_mount+0x6b/0x110
[ 2060.450601]  [<ffffffff8123f7f6>] do_mount+0x246/0xce0
[ 2060.450605]  [<ffffffff811c1216>] ? memdup_user+0x46/0x80
[ 2060.450609]  [<ffffffff812405cf>] SyS_mount+0x9f/0x100
[ 2060.450616]  [<ffffffff817789ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 2060.450649] ---[ end trace 7b4fe08881eca151 ]---
[ 2060.450655] BTRFS info (device sda1): leaf 437960704 total ptrs 242 free space 2247
[ 2060.450659] 	item 0 key (159696797696 169 0) itemoff 16250 itemsize 33
[ 2060.450662] 		extent refs 1 gen 21134 flags 2
[ 2060.450664] 		tree block backref root 2
[ 2060.450667] 	item 1 key (159696830464 169 1) itemoff 16217 itemsize 33
[ 2060.450670] 		extent refs 1 gen 21134 flags 2
[ 2060.450672] 		tree block backref root 2
[ 2060.450675] 	item 2 key (159696846848 169 0) itemoff 16184 itemsize 33
[ 2060.450677] 		extent refs 1 gen 21134 flags 2
[ 2060.450679] 		tree block backref root 2
[ 2060.450682] 	item 3 key (159696863232 169 0) itemoff 16151 itemsize 33
[ 2060.450684] 		extent refs 1 gen 21134 flags 2
[ 2060.450686] 		tree block backref root 2
[ 2060.450689] 	item 4 key (159696879616 169 0) itemoff 16118 itemsize 33
[ 2060.450692] 		extent refs 1 gen 21134 flags 2
[ 2060.450694] 		tree block backref root 2
[ 2060.450697] 	item 5 key (159696945152 169 0) itemoff 16085 itemsize 33
[ 2060.450699] 		extent refs 1 gen 21134 flags 2
[ 2060.450701] 		tree block backref root 2
[ 2060.450704] 	item 6 key (159697059840 169 0) itemoff 16052 itemsize 33
[ 2060.450706] 		extent refs 1 gen 21134 flags 2
[ 2060.450708] 		tree block backref root 2
[ 2060.450711] 	item 7 key (159697076224 169 0) itemoff 16019 itemsize 33
[ 2060.450714] 		extent refs 1 gen 21134 flags 2
[ 2060.450716] 		tree block backref root 2
[ 2060.450719] 	item 8 key (159697190912 169 0) itemoff 15986 itemsize 33
[ 2060.450721] 		extent refs 1 gen 21134 flags 2
[ 2060.450723] 		tree block backref root 1
[ 2060.450726] 	item 9 key (159697207296 169 0) itemoff 15953 itemsize 33
[ 2060.450728] 		extent refs 1 gen 21134 flags 2
[ 2060.450730] 		tree block backref root 2
[ 2060.450733] 	item 10 key (159697305600 169 0) itemoff 15920 itemsize 33
[ 2060.450774] 		extent refs 1 gen 21134 flags 2
[ 2060.450777] 		tree block backref root 2
[ 2060.450781] 	item 11 key (159697321984 169 0) itemoff 15887 itemsize 33
[ 2060.450785] 		extent refs 1 gen 21134 flags 2
[ 2060.450787] 		tree block backref root 7
[ 2060.450790] 	item 12 key (159697436672 169 0) itemoff 15854 itemsize 33
[ 2060.450792] 		extent refs 1 gen 21134 flags 2
[ 2060.450794] 		tree block backref root 7
[ 2060.450797] 	item 13 key (159697502208 169 0) itemoff 15821 itemsize 33
[ 2060.450799] 		extent refs 1 gen 21134 flags 2
[ 2060.450801] 		tree block backref root 7
[ 2060.450804] 	item 14 key (159697518592 169 0) itemoff 15788 itemsize 33
[ 2060.450807] 		extent refs 1 gen 21134 flags 2
[ 2060.450812] 		tree block backref root 7
[ 2060.450815] 	item 15 key (159697567744 169 0) itemoff 15755 itemsize 33
[ 2060.450817] 		extent refs 1 gen 21134 flags 2
[ 2060.450819] 		tree block backref root 384
[ 2060.450822] 	item 16 key (159697584128 169 0) itemoff 15722 itemsize 33
[ 2060.450825] 		extent refs 1 gen 21134 flags 2
[ 2060.450827] 		tree block backref root 384
[ 2060.450830] 	item 17 key (159697633280 169 1) itemoff 15689 itemsize 33
[ 2060.450832] 		extent refs 1 gen 21134 flags 2
[ 2060.450834] 		tree block backref root 385
[ 2060.450837] 	item 18 key (159697649664 169 0) itemoff 15656 itemsize 33
[ 2060.450840] 		extent refs 1 gen 21134 flags 2
[ 2060.450842] 		tree block backref root 385
[ 2060.450845] 	item 19 key (159697666048 169 0) itemoff 15623 itemsize 33
[ 2060.450847] 		extent refs 1 gen 21134 flags 2
[ 2060.450849] 		tree block backref root 2
[ 2060.450852] 	item 20 key (159697862656 169 1) itemoff 15590 itemsize 33
[ 2060.450855] 		extent refs 1 gen 21135 flags 2
[ 2060.450857] 		tree block backref root 7
[ 2060.450859] 	item 21 key (159697879040 169 0) itemoff 15557 itemsize 33
[ 2060.450862] 		extent refs 1 gen 21135 flags 2
[ 2060.450864] 		tree block backref root 7
[ 2060.450867] 	item 22 key (159697993728 169 0) itemoff 15524 itemsize 33
[ 2060.450877] 		extent refs 1 gen 21135 flags 2
[ 2060.450879] 		tree block backref root 7
[ 2060.450882] 	item 23 key (159698026496 169 0) itemoff 15491 itemsize 33
[ 2060.450885] 		extent refs 1 gen 21135 flags 2
[ 2060.450887] 		tree block backref root 384
[ 2060.450890] 	item 24 key (159698059264 169 0) itemoff 15458 itemsize 33
[ 2060.450892] 		extent refs 1 gen 21135 flags 2
[ 2060.450894] 		tree block backref root 7
[ 2060.450897] 	item 25 key (159698075648 169 1) itemoff 15425 itemsize 33
[ 2060.450899] 		extent refs 1 gen 21135 flags 2
[ 2060.450901] 		tree block backref root 384
[ 2060.450904] 	item 26 key (159698092032 169 0) itemoff 15392 itemsize 33
[ 2060.450907] 		extent refs 1 gen 21135 flags 2
[ 2060.450909] 		tree block backref root 384
[ 2060.450912] 	item 27 key (159698108416 169 0) itemoff 15359 itemsize 33
[ 2060.450914] 		extent refs 1 gen 21135 flags 2
[ 2060.450919] 		tree block backref root 7
[ 2060.450921] 	item 28 key (159698141184 169 1) itemoff 15326 itemsize 33
[ 2060.450922] 		extent refs 1 gen 21135 flags 2
[ 2060.450922] 		tree block backref root 384
[ 2060.450924] 	item 29 key (159698157568 169 0) itemoff 15293 itemsize 33
[ 2060.450925] 		extent refs 1 gen 21135 flags 2
[ 2060.450925] 		tree block backref root 384
[ 2060.450927] 	item 30 key (159698190336 169 0) itemoff 15260 itemsize 33
[ 2060.450928] 		extent refs 1 gen 21135 flags 2
[ 2060.450928] 		tree block backref root 7
[ 2060.450930] 	item 31 key (159698223104 169 1) itemoff 15227 itemsize 33
[ 2060.450931] 		extent refs 1 gen 21135 flags 2
[ 2060.450931] 		tree block backref root 7
[ 2060.450933] 	item 32 key (159698239488 169 0) itemoff 15194 itemsize 33
[ 2060.450934] 		extent refs 1 gen 21135 flags 2
[ 2060.450934] 		tree block backref root 7
[ 2060.450936] 	item 33 key (159698255872 169 1) itemoff 15161 itemsize 33
[ 2060.450937] 		extent refs 1 gen 21135 flags 2
[ 2060.450937] 		tree block backref root 384
[ 2060.450939] 	item 34 key (159698272256 169 0) itemoff 15128 itemsize 33
[ 2060.450940] 		extent refs 1 gen 21135 flags 2
[ 2060.450940] 		tree block backref root 384
[ 2060.450942] 	item 35 key (159698354176 169 0) itemoff 15095 itemsize 33
[ 2060.450943] 		extent refs 1 gen 21135 flags 2
[ 2060.450943] 		tree block backref root 7
[ 2060.450945] 	item 36 key (159698370560 169 0) itemoff 15062 itemsize 33
[ 2060.450946] 		extent refs 1 gen 21135 flags 2
[ 2060.450946] 		tree block backref root 384
[ 2060.450948] 	item 37 key (159698386944 169 0) itemoff 15029 itemsize 33
[ 2060.450949] 		extent refs 1 gen 21135 flags 2
[ 2060.450950] 		tree block backref root 7
[ 2060.450951] 	item 38 key (159698403328 169 0) itemoff 14996 itemsize 33
[ 2060.450953] 		extent refs 1 gen 21135 flags 2
[ 2060.450954] 		tree block backref root 7
[ 2060.450955] 	item 39 key (159698419712 169 0) itemoff 14963 itemsize 33
[ 2060.450957] 		extent refs 1 gen 21135 flags 2
[ 2060.450957] 		tree block backref root 7
[ 2060.450959] 	item 40 key (159698468864 169 1) itemoff 14930 itemsize 33
[ 2060.450961] 		extent refs 1 gen 21135 flags 2
[ 2060.450962] 		tree block backref root 7
[ 2060.450964] 	item 41 key (159698485248 169 0) itemoff 14897 itemsize 33
[ 2060.450965] 		extent refs 1 gen 21135 flags 2
[ 2060.450966] 		tree block backref root 7
[ 2060.450968] 	item 42 key (159698501632 169 0) itemoff 14864 itemsize 33
[ 2060.450969] 		extent refs 1 gen 21135 flags 2
[ 2060.450970] 		tree block backref root 384
[ 2060.450972] 	item 43 key (159698518016 169 0) itemoff 14831 itemsize 33
[ 2060.450973] 		extent refs 1 gen 21135 flags 2
[ 2060.450974] 		tree block backref root 7
[ 2060.450975] 	item 44 key (159698534400 169 0) itemoff 14798 itemsize 33
[ 2060.450976] 		extent refs 1 gen 21135 flags 2
[ 2060.450977] 		tree block backref root 384
[ 2060.450979] 	item 45 key (159698567168 169 0) itemoff 14765 itemsize 33
[ 2060.450980] 		extent refs 1 gen 21135 flags 2
[ 2060.450981] 		tree block backref root 385
[ 2060.450983] 	item 46 key (159698583552 169 0) itemoff 14732 itemsize 33
[ 2060.450984] 		extent refs 1 gen 21135 flags 2
[ 2060.450985] 		tree block backref root 7
[ 2060.450987] 	item 47 key (159698599936 169 0) itemoff 14699 itemsize 33
[ 2060.450989] 		extent refs 1 gen 21135 flags 2
[ 2060.450990] 		tree block backref root 7
[ 2060.450991] 	item 48 key (159698649088 169 0) itemoff 14666 itemsize 33
[ 2060.450992] 		extent refs 1 gen 21135 flags 2
[ 2060.450993] 		tree block backref root 7
[ 2060.450995] 	item 49 key (159698665472 169 0) itemoff 14633 itemsize 33
[ 2060.450996] 		extent refs 1 gen 21135 flags 2
[ 2060.451000] 		tree block backref root 7
[ 2060.451002] 	item 50 key (159698681856 169 0) itemoff 14600 itemsize 33
[ 2060.451003] 		extent refs 1 gen 21135 flags 2
[ 2060.451004] 		tree block backref root 7
[ 2060.451006] 	item 51 key (159698829312 169 0) itemoff 14567 itemsize 33
[ 2060.451007] 		extent refs 1 gen 21135 flags 2
[ 2060.451008] 		tree block backref root 2
[ 2060.451010] 	item 52 key (159698862080 169 0) itemoff 14534 itemsize 33
[ 2060.451012] 		extent refs 1 gen 21135 flags 2
[ 2060.451013] 		tree block backref root 2
[ 2060.451014] 	item 53 key (159698944000 169 0) itemoff 14501 itemsize 33
[ 2060.451016] 		extent refs 1 gen 187 flags 2
[ 2060.451016] 		tree block backref root 2
[ 2060.451018] 	item 54 key (159698960384 169 0) itemoff 14468 itemsize 33
[ 2060.451019] 		extent refs 1 gen 21135 flags 2
[ 2060.451020] 		tree block backref root 2
[ 2060.451021] 	item 55 key (159698976768 169 0) itemoff 14435 itemsize 33
[ 2060.451022] 		extent refs 1 gen 187 flags 2
[ 2060.451023] 		tree block backref root 2
[ 2060.451025] 	item 56 key (159698993152 169 0) itemoff 14402 itemsize 33
[ 2060.451026] 		extent refs 1 gen 21135 flags 2
[ 2060.451027] 		tree block backref root 2
[ 2060.451028] 	item 57 key (159699025920 169 0) itemoff 14369 itemsize 33
[ 2060.451029] 		extent refs 1 gen 21135 flags 2
[ 2060.451030] 		tree block backref root 2
[ 2060.451032] 	item 58 key (159699042304 169 0) itemoff 14336 itemsize 33
[ 2060.451033] 		extent refs 1 gen 21135 flags 2
[ 2060.451034] 		tree block backref root 2
[ 2060.451036] 	item 59 key (159699091456 169 0) itemoff 14303 itemsize 33
[ 2060.451038] 		extent refs 1 gen 21135 flags 2
[ 2060.451039] 		tree block backref root 2
[ 2060.451041] 	item 60 key (159699107840 169 0) itemoff 14270 itemsize 33
[ 2060.451043] 		extent refs 1 gen 21135 flags 2
[ 2060.451044] 		tree block backref root 2
[ 2060.451046] 	item 61 key (159699140608 169 0) itemoff 14237 itemsize 33
[ 2060.451047] 		extent refs 1 gen 21135 flags 2
[ 2060.451048] 		tree block backref root 2
[ 2060.451050] 	item 62 key (159699156992 169 0) itemoff 14204 itemsize 33
[ 2060.451052] 		extent refs 1 gen 21135 flags 2
[ 2060.451053] 		tree block backref root 7
[ 2060.451055] 	item 63 key (159699173376 169 0) itemoff 14171 itemsize 33
[ 2060.451056] 		extent refs 1 gen 21135 flags 2
[ 2060.451057] 		tree block backref root 2
[ 2060.451059] 	item 64 key (159699189760 169 0) itemoff 14138 itemsize 33
[ 2060.451061] 		extent refs 1 gen 21135 flags 2
[ 2060.451062] 		tree block backref root 2
[ 2060.451064] 	item 65 key (159699206144 169 0) itemoff 14105 itemsize 33
[ 2060.451065] 		extent refs 1 gen 21135 flags 2
[ 2060.451066] 		tree block backref root 2
[ 2060.451068] 	item 66 key (159699222528 169 0) itemoff 14072 itemsize 33
[ 2060.451069] 		extent refs 1 gen 21135 flags 2
[ 2060.451071] 		tree block backref root 2
[ 2060.451072] 	item 67 key (159699238912 169 0) itemoff 14039 itemsize 33
[ 2060.451074] 		extent refs 1 gen 21135 flags 2
[ 2060.451075] 		tree block backref root 7
[ 2060.451077] 	item 68 key (159699255296 169 0) itemoff 14006 itemsize 33
[ 2060.451078] 		extent refs 1 gen 21135 flags 2
[ 2060.451080] 		tree block backref root 7
[ 2060.451081] 	item 69 key (159699271680 169 0) itemoff 13973 itemsize 33
[ 2060.451083] 		extent refs 1 gen 21135 flags 2
[ 2060.451084] 		tree block backref root 2
[ 2060.451085] 	item 70 key (159699353600 169 0) itemoff 13940 itemsize 33
[ 2060.451086] 		extent refs 1 gen 21135 flags 2
[ 2060.451087] 		tree block backref root 2
[ 2060.451088] 	item 71 key (159699386368 169 1) itemoff 13907 itemsize 33
[ 2060.451089] 		extent refs 1 gen 21135 flags 2
[ 2060.451090] 		tree block backref root 2
[ 2060.451091] 	item 72 key (159699402752 169 0) itemoff 13874 itemsize 33
[ 2060.451092] 		extent refs 1 gen 21135 flags 2
[ 2060.451093] 		tree block backref root 2
[ 2060.451094] 	item 73 key (159699419136 169 1) itemoff 13841 itemsize 33
[ 2060.451095] 		extent refs 1 gen 21135 flags 2
[ 2060.451096] 		tree block backref root 2
[ 2060.451097] 	item 74 key (159699435520 169 0) itemoff 13808 itemsize 33
[ 2060.451098] 		extent refs 1 gen 21135 flags 2
[ 2060.451099] 		tree block backref root 2
[ 2060.451100] 	item 75 key (159699566592 169 0) itemoff 13775 itemsize 33
[ 2060.451101] 		extent refs 1 gen 21135 flags 2
[ 2060.451101] 		tree block backref root 2
[ 2060.451103] 	item 76 key (159699582976 169 0) itemoff 13742 itemsize 33
[ 2060.451104] 		extent refs 1 gen 21135 flags 2
[ 2060.451104] 		tree block backref root 2
[ 2060.451105] 	item 77 key (159699599360 169 0) itemoff 13709 itemsize 33
[ 2060.451106] 		extent refs 1 gen 21135 flags 2
[ 2060.451107] 		tree block backref root 2
[ 2060.451109] 	item 78 key (159699615744 169 0) itemoff 13676 itemsize 33
[ 2060.451110] 		extent refs 1 gen 21135 flags 2
[ 2060.451112] 		tree block backref root 2
[ 2060.451115] 	item 79 key (159699632128 169 0) itemoff 13643 itemsize 33
[ 2060.451116] 		extent refs 1 gen 21135 flags 2
[ 2060.451125] 		tree block backref root 2
[ 2060.451127] 	item 80 key (159699648512 169 0) itemoff 13610 itemsize 33
[ 2060.451128] 		extent refs 1 gen 21135 flags 2
[ 2060.451129] 		tree block backref root 2
[ 2060.451131] 	item 81 key (159699664896 169 0) itemoff 13577 itemsize 33
[ 2060.451132] 		extent refs 1 gen 21135 flags 2
[ 2060.451133] 		tree block backref root 2
[ 2060.451135] 	item 82 key (159699681280 169 0) itemoff 13544 itemsize 33
[ 2060.451136] 		extent refs 1 gen 21135 flags 2
[ 2060.451138] 		tree block backref root 2
[ 2060.451140] 	item 83 key (159699845120 169 0) itemoff 13511 itemsize 33
[ 2060.451141] 		extent refs 1 gen 21135 flags 2
[ 2060.451143] 		tree block backref root 2
[ 2060.451144] 	item 84 key (159699861504 169 0) itemoff 13478 itemsize 33
[ 2060.451146] 		extent refs 1 gen 21135 flags 2
[ 2060.451147] 		tree block backref root 2
[ 2060.451149] 	item 85 key (159699927040 169 1) itemoff 13445 itemsize 33
[ 2060.451151] 		extent refs 1 gen 21135 flags 2
[ 2060.451152] 		tree block backref root 2
[ 2060.451154] 	item 86 key (159699943424 169 0) itemoff 13412 itemsize 33
[ 2060.451156] 		extent refs 1 gen 21135 flags 2
[ 2060.451157] 		tree block backref root 2
[ 2060.451159] 	item 87 key (159700123648 169 0) itemoff 13379 itemsize 33
[ 2060.451161] 		extent refs 1 gen 21135 flags 2
[ 2060.451162] 		tree block backref root 7
[ 2060.451164] 	item 88 key (159700385792 169 0) itemoff 13346 itemsize 33
[ 2060.451166] 		extent refs 1 gen 21136 flags 2
[ 2060.451167] 		tree block backref root 7
[ 2060.451169] 	item 89 key (159700615168 169 0) itemoff 13313 itemsize 33
[ 2060.451171] 		extent refs 1 gen 21136 flags 2
[ 2060.451172] 		tree block backref root 2
[ 2060.451174] 	item 90 key (159700746240 169 0) itemoff 13280 itemsize 33
[ 2060.451176] 		extent refs 1 gen 21136 flags 2
[ 2060.451177] 		tree block backref root 2
[ 2060.451179] 	item 91 key (159700779008 169 0) itemoff 13247 itemsize 33
[ 2060.451181] 		extent refs 1 gen 21136 flags 2
[ 2060.451183] 		tree block backref root 2
[ 2060.451185] 	item 92 key (159701336064 169 0) itemoff 13214 itemsize 33
[ 2060.451186] 		extent refs 1 gen 21137 flags 2
[ 2060.451187] 		tree block backref root 7
[ 2060.451189] 	item 93 key (159701516288 169 0) itemoff 13181 itemsize 33
[ 2060.451191] 		extent refs 1 gen 21137 flags 2
[ 2060.451192] 		tree block backref root 7
[ 2060.451194] 	item 94 key (159701630976 169 0) itemoff 13148 itemsize 33
[ 2060.451195] 		extent refs 1 gen 21137 flags 2
[ 2060.451197] 		tree block backref root 2
[ 2060.451198] 	item 95 key (159701712896 169 0) itemoff 13115 itemsize 33
[ 2060.451200] 		extent refs 1 gen 21137 flags 2
[ 2060.451202] 		tree block backref root 2
[ 2060.451203] 	item 96 key (159701729280 169 0) itemoff 13082 itemsize 33
[ 2060.451205] 		extent refs 1 gen 21137 flags 2
[ 2060.451206] 		tree block backref root 7
[ 2060.451208] 	item 97 key (159701827584 169 0) itemoff 13049 itemsize 33
[ 2060.451209] 		extent refs 1 gen 21137 flags 2
[ 2060.451211] 		tree block backref root 2
[ 2060.451213] 	item 98 key (159702859776 169 0) itemoff 13016 itemsize 33
[ 2060.451214] 		extent refs 1 gen 21139 flags 2
[ 2060.451216] 		tree block backref root 7
[ 2060.451217] 	item 99 key (159702974464 169 0) itemoff 12983 itemsize 33
[ 2060.451219] 		extent refs 1 gen 21139 flags 2
[ 2060.451220] 		tree block backref root 2
[ 2060.451222] 	item 100 key (159703007232 169 0) itemoff 12950 itemsize 33
[ 2060.451224] 		extent refs 1 gen 21139 flags 2
[ 2060.451226] 		tree block backref root 2
[ 2060.451228] 	item 101 key (159703187456 169 0) itemoff 12917 itemsize 33
[ 2060.451230] 		extent refs 1 gen 21139 flags 2
[ 2060.451231] 		tree block backref root 7
[ 2060.451233] 	item 102 key (159703482368 169 0) itemoff 12884 itemsize 33
[ 2060.451235] 		extent refs 1 gen 21140 flags 2
[ 2060.451236] 		tree block backref root 384
[ 2060.451238] 	item 103 key (159703515136 169 0) itemoff 12851 itemsize 33
[ 2060.451240] 		extent refs 1 gen 21140 flags 2
[ 2060.451241] 		tree block backref root 7
[ 2060.451243] 	item 104 key (159703629824 169 0) itemoff 12818 itemsize 33
[ 2060.451245] 		extent refs 1 gen 21140 flags 2
[ 2060.451246] 		tree block backref root 7
[ 2060.451249] 	item 105 key (159703711744 169 0) itemoff 12785 itemsize 33
[ 2060.451250] 		extent refs 1 gen 21140 flags 2
[ 2060.451252] 		tree block backref root 2
[ 2060.451254] 	item 106 key (159703777280 169 0) itemoff 12752 itemsize 33
[ 2060.451255] 		extent refs 1 gen 21140 flags 2
[ 2060.451256] 		tree block backref root 2
[ 2060.451258] 	item 107 key (159703793664 169 1) itemoff 12719 itemsize 33
[ 2060.451260] 		extent refs 1 gen 21140 flags 2
[ 2060.451261] 		tree block backref root 7
[ 2060.451263] 	item 108 key (159703810048 169 0) itemoff 12686 itemsize 33
[ 2060.451265] 		extent refs 1 gen 21140 flags 2
[ 2060.451266] 		tree block backref root 7
[ 2060.451268] 	item 109 key (159703842816 169 0) itemoff 12653 itemsize 33
[ 2060.451270] 		extent refs 1 gen 21140 flags 2
[ 2060.451271] 		tree block backref root 2
[ 2060.451273] 	item 110 key (159703990272 169 0) itemoff 12620 itemsize 33
[ 2060.451274] 		extent refs 1 gen 21140 flags 2
[ 2060.451276] 		tree block backref root 2
[ 2060.451278] 	item 111 key (159704088576 169 0) itemoff 12587 itemsize 33
[ 2060.451279] 		extent refs 1 gen 21140 flags 2
[ 2060.451280] 		tree block backref root 2
[ 2060.451282] 	item 112 key (159704219648 169 0) itemoff 12554 itemsize 33
[ 2060.451284] 		extent refs 1 gen 21140 flags 2
[ 2060.451286] 		tree block backref root 7
[ 2060.451288] 	item 113 key (159704236032 169 0) itemoff 12521 itemsize 33
[ 2060.451290] 		extent refs 1 gen 21140 flags 2
[ 2060.451291] 		tree block backref root 7
[ 2060.451293] 	item 114 key (159704547328 169 0) itemoff 12488 itemsize 33
[ 2060.451295] 		extent refs 1 gen 21141 flags 2
[ 2060.451296] 		tree block backref root 384
[ 2060.451298] 	item 115 key (159704563712 169 0) itemoff 12455 itemsize 33
[ 2060.451300] 		extent refs 1 gen 21141 flags 2
[ 2060.451301] 		tree block backref root 384
[ 2060.451303] 	item 116 key (159704580096 169 1) itemoff 12422 itemsize 33
[ 2060.451305] 		extent refs 1 gen 21141 flags 2
[ 2060.451307] 		tree block backref root 7
[ 2060.451309] 	item 117 key (159704596480 169 0) itemoff 12389 itemsize 33
[ 2060.451311] 		extent refs 1 gen 21141 flags 2
[ 2060.451312] 		tree block backref root 7
[ 2060.451314] 	item 118 key (159704694784 169 0) itemoff 12356 itemsize 33
[ 2060.451316] 		extent refs 1 gen 21141 flags 2
[ 2060.451317] 		tree block backref root 7
[ 2060.451319] 	item 119 key (159704743936 169 0) itemoff 12323 itemsize 33
[ 2060.451320] 		extent refs 1 gen 21141 flags 2
[ 2060.451322] 		tree block backref root 2
[ 2060.451323] 	item 120 key (159704760320 169 0) itemoff 12290 itemsize 33
[ 2060.451325] 		extent refs 1 gen 21141 flags 2
[ 2060.451327] 		tree block backref root 2
[ 2060.451329] 	item 121 key (159704776704 169 1) itemoff 12257 itemsize 33
[ 2060.451331] 		extent refs 1 gen 21141 flags 2
[ 2060.451332] 		tree block backref root 7
[ 2060.451334] 	item 122 key (159704793088 169 0) itemoff 12224 itemsize 33
[ 2060.451335] 		extent refs 1 gen 21141 flags 2
[ 2060.451336] 		tree block backref root 7
[ 2060.451338] 	item 123 key (159704940544 169 0) itemoff 12191 itemsize 33
[ 2060.451340] 		extent refs 1 gen 21141 flags 2
[ 2060.451341] 		tree block backref root 2
[ 2060.451343] 	item 124 key (159704989696 169 0) itemoff 12158 itemsize 33
[ 2060.451344] 		extent refs 1 gen 21141 flags 2
[ 2060.451346] 		tree block backref root 2
[ 2060.451348] 	item 125 key (159705006080 169 0) itemoff 12125 itemsize 33
[ 2060.451350] 		extent refs 1 gen 21141 flags 2
[ 2060.451351] 		tree block backref root 2
[ 2060.451354] 	item 126 key (159705452544 169 0) itemoff 12092 itemsize 33
[ 2060.451355] 		extent refs 1 gen 185 flags 2
[ 2060.451357] 		tree block backref root 2
[ 2060.451359] 	item 127 key (159705468928 169 0) itemoff 12059 itemsize 33
[ 2060.451360] 		extent refs 1 gen 185 flags 2
[ 2060.451362] 		tree block backref root 2
[ 2060.451364] 	item 128 key (159705485312 169 0) itemoff 12026 itemsize 33
[ 2060.451366] 		extent refs 1 gen 185 flags 2
[ 2060.451367] 		tree block backref root 2
[ 2060.451369] 	item 129 key (159705518080 169 0) itemoff 11993 itemsize 33
[ 2060.451371] 		extent refs 1 gen 185 flags 2
[ 2060.451372] 		tree block backref root 2
[ 2060.451374] 	item 130 key (159705567232 169 0) itemoff 11960 itemsize 33
[ 2060.451376] 		extent refs 1 gen 185 flags 2
[ 2060.451377] 		tree block backref root 2
[ 2060.451379] 	item 131 key (159705616384 169 0) itemoff 11927 itemsize 33
[ 2060.451381] 		extent refs 1 gen 185 flags 2
[ 2060.451382] 		tree block backref root 2
[ 2060.451385] 	item 132 key (159705632768 169 0) itemoff 11894 itemsize 33
[ 2060.451387] 		extent refs 1 gen 21080 flags 2
[ 2060.451388] 		tree block backref root 2
[ 2060.451390] 	item 133 key (159705665536 169 0) itemoff 11861 itemsize 33
[ 2060.451391] 		extent refs 1 gen 21142 flags 2
[ 2060.451392] 		tree block backref root 384
[ 2060.451394] 	item 134 key (159705681920 169 1) itemoff 11828 itemsize 33
[ 2060.451396] 		extent refs 1 gen 21142 flags 2
[ 2060.451397] 		tree block backref root 7
[ 2060.451398] 	item 135 key (159705698304 169 0) itemoff 11795 itemsize 33
[ 2060.451400] 		extent refs 1 gen 21142 flags 2
[ 2060.451402] 		tree block backref root 7
[ 2060.451404] 	item 136 key (159705731072 169 0) itemoff 11762 itemsize 33
[ 2060.451406] 		extent refs 1 gen 21142 flags 2
[ 2060.451407] 		tree block backref root 7
[ 2060.451409] 	item 137 key (159705747456 169 0) itemoff 11729 itemsize 33
[ 2060.451411] 		extent refs 1 gen 21142 flags 2
[ 2060.451412] 		tree block backref root 7
[ 2060.451414] 	item 138 key (159705780224 169 0) itemoff 11696 itemsize 33
[ 2060.451416] 		extent refs 1 gen 21142 flags 2
[ 2060.451417] 		tree block backref root 384
[ 2060.451419] 	item 139 key (159705796608 169 1) itemoff 11663 itemsize 33
[ 2060.451421] 		extent refs 1 gen 21142 flags 2
[ 2060.451422] 		tree block backref root 7
[ 2060.451424] 	item 140 key (159705812992 169 0) itemoff 11630 itemsize 33
[ 2060.451426] 		extent refs 1 gen 21142 flags 2
[ 2060.451427] 		tree block backref root 7
[ 2060.451429] 	item 141 key (159705829376 169 0) itemoff 11597 itemsize 33
[ 2060.451430] 		extent refs 1 gen 21142 flags 2
[ 2060.451432] 		tree block backref root 384
[ 2060.451434] 	item 142 key (159705845760 169 1) itemoff 11564 itemsize 33
[ 2060.451437] 		extent refs 1 gen 21142 flags 2
[ 2060.451438] 		tree block backref root 7
[ 2060.451440] 	item 143 key (159705862144 169 0) itemoff 11531 itemsize 33
[ 2060.451441] 		extent refs 1 gen 21142 flags 2
[ 2060.451442] 		tree block backref root 7
[ 2060.451444] 	item 144 key (159705944064 169 0) itemoff 11498 itemsize 33
[ 2060.451446] 		extent refs 1 gen 21142 flags 2
[ 2060.451447] 		tree block backref root 384
[ 2060.451449] 	item 145 key (159705960448 169 0) itemoff 11465 itemsize 33
[ 2060.451450] 		extent refs 1 gen 21142 flags 2
[ 2060.451451] 		tree block backref root 7
[ 2060.451452] 	item 146 key (159706058752 169 1) itemoff 11432 itemsize 33
[ 2060.451453] 		extent refs 1 gen 21142 flags 2
[ 2060.451454] 		tree block backref root 2
[ 2060.451455] 	item 147 key (159706075136 169 0) itemoff 11399 itemsize 33
[ 2060.451456] 		extent refs 1 gen 21142 flags 2
[ 2060.451457] 		tree block backref root 2
[ 2060.451458] 	item 148 key (159706091520 169 0) itemoff 11366 itemsize 33
[ 2060.451459] 		extent refs 1 gen 21142 flags 2
[ 2060.451459] 		tree block backref root 2
[ 2060.451461] 	item 149 key (159706206208 169 0) itemoff 11333 itemsize 33
[ 2060.451462] 		extent refs 1 gen 21142 flags 2
[ 2060.451462] 		tree block backref root 2
[ 2060.451464] 	item 150 key (159706255360 169 0) itemoff 11300 itemsize 33
[ 2060.451465] 		extent refs 1 gen 21142 flags 2
[ 2060.451465] 		tree block backref root 2
[ 2060.451467] 	item 151 key (159706288128 169 0) itemoff 11267 itemsize 33
[ 2060.451468] 		extent refs 1 gen 21142 flags 2
[ 2060.451469] 		tree block backref root 2
[ 2060.451470] 	item 152 key (159706320896 169 0) itemoff 11234 itemsize 33
[ 2060.451472] 		extent refs 1 gen 21142 flags 2
[ 2060.451473] 		tree block backref root 2
[ 2060.451474] 	item 153 key (159706337280 169 0) itemoff 11201 itemsize 33
[ 2060.451475] 		extent refs 1 gen 21142 flags 2
[ 2060.451476] 		tree block backref root 7
[ 2060.451477] 	item 154 key (159706419200 169 0) itemoff 11168 itemsize 33
[ 2060.451478] 		extent refs 1 gen 21142 flags 2
[ 2060.451479] 		tree block backref root 2
[ 2060.451480] 	item 155 key (159706632192 169 0) itemoff 11135 itemsize 33
[ 2060.451481] 		extent refs 1 gen 21080 flags 2
[ 2060.451482] 		tree block backref root 2
[ 2060.451483] 	item 156 key (159706812416 169 0) itemoff 11102 itemsize 33
[ 2060.451484] 		extent refs 1 gen 21143 flags 2
[ 2060.451485] 		tree block backref root 7
[ 2060.451486] 	item 157 key (159706877952 169 0) itemoff 11069 itemsize 33
[ 2060.451487] 		extent refs 1 gen 21080 flags 2
[ 2060.451488] 		tree block backref root 2
[ 2060.451489] 	item 158 key (159707041792 169 0) itemoff 11036 itemsize 33
[ 2060.451490] 		extent refs 1 gen 21143 flags 2
[ 2060.451490] 		tree block backref root 7
[ 2060.451492] 	item 159 key (159707828224 169 0) itemoff 11003 itemsize 33
[ 2060.451493] 		extent refs 1 gen 21144 flags 2
[ 2060.451494] 		tree block backref root 385
[ 2060.451496] 	item 160 key (159707942912 169 0) itemoff 10970 itemsize 33
[ 2060.451497] 		extent refs 1 gen 21145 flags 2
[ 2060.451498] 		tree block backref root 7
[ 2060.451500] 	item 161 key (159707975680 169 0) itemoff 10937 itemsize 33
[ 2060.451502] 		extent refs 1 gen 21081 flags 2
[ 2060.451503] 		tree block backref root 2
[ 2060.451505] 	item 162 key (159708057600 169 2) itemoff 10904 itemsize 33
[ 2060.451507] 		extent refs 1 gen 21145 flags 2
[ 2060.451508] 		tree block backref root 384
[ 2060.451509] 	item 163 key (159708073984 169 1) itemoff 10871 itemsize 33
[ 2060.451510] 		extent refs 1 gen 21145 flags 2
[ 2060.451511] 		tree block backref root 384
[ 2060.451512] 	item 164 key (159708090368 169 0) itemoff 10838 itemsize 33
[ 2060.451513] 		extent refs 1 gen 21145 flags 2
[ 2060.451514] 		tree block backref root 384
[ 2060.451515] 	item 165 key (159708106752 169 1) itemoff 10805 itemsize 33
[ 2060.451516] 		extent refs 1 gen 21145 flags 2
[ 2060.451517] 		tree block backref root 384
[ 2060.451518] 	item 166 key (159708123136 169 0) itemoff 10772 itemsize 33
[ 2060.451519] 		extent refs 1 gen 21145 flags 2
[ 2060.451520] 		tree block backref root 384
[ 2060.451521] 	item 167 key (159708168192 169 2) itemoff 10739 itemsize 33
[ 2060.451522] 		extent refs 1 gen 21146 flags 2
[ 2060.451523] 		tree block backref root 385
[ 2060.451524] 	item 168 key (159708188672 169 0) itemoff 10706 itemsize 33
[ 2060.451525] 		extent refs 1 gen 21145 flags 2
[ 2060.451526] 		tree block backref root 384
[ 2060.451527] 	item 169 key (159708254208 169 0) itemoff 10673 itemsize 33
[ 2060.451528] 		extent refs 1 gen 21145 flags 2
[ 2060.451529] 		tree block backref root 2
[ 2060.451530] 	item 170 key (159708286976 169 0) itemoff 10640 itemsize 33
[ 2060.451531] 		extent refs 1 gen 21081 flags 2
[ 2060.451532] 		tree block backref root 384
[ 2060.451533] 	item 171 key (159708385280 169 0) itemoff 10607 itemsize 33
[ 2060.451534] 		extent refs 1 gen 21145 flags 2
[ 2060.451535] 		tree block backref root 2
[ 2060.451536] 	item 172 key (159708418048 169 0) itemoff 10574 itemsize 33
[ 2060.451537] 		extent refs 1 gen 21081 flags 2
[ 2060.451538] 		tree block backref root 384
[ 2060.451539] 	item 173 key (159708483584 169 0) itemoff 10541 itemsize 33
[ 2060.451540] 		extent refs 1 gen 21081 flags 2
[ 2060.451541] 		tree block backref root 384
[ 2060.451542] 	item 174 key (159708647424 169 0) itemoff 10508 itemsize 33
[ 2060.451544] 		extent refs 1 gen 21081 flags 2
[ 2060.451545] 		tree block backref root 384
[ 2060.451546] 	item 175 key (159708663808 169 0) itemoff 10475 itemsize 33
[ 2060.451547] 		extent refs 1 gen 21145 flags 2
[ 2060.451548] 		tree block backref root 7
[ 2060.451549] 	item 176 key (159708729344 169 1) itemoff 10442 itemsize 33
[ 2060.451550] 		extent refs 1 gen 21146 flags 2
[ 2060.451551] 		tree block backref root 385
[ 2060.451552] 	item 177 key (159708745728 169 0) itemoff 10409 itemsize 33
[ 2060.451553] 		extent refs 1 gen 21146 flags 2
[ 2060.451554] 		tree block backref root 385
[ 2060.451556] 	item 178 key (159708762112 169 0) itemoff 10376 itemsize 33
[ 2060.451557] 		extent refs 1 gen 21081 flags 2
[ 2060.451557] 		tree block backref root 384
[ 2060.451559] 	item 179 key (159708778496 169 0) itemoff 10343 itemsize 33
[ 2060.451560] 		extent refs 1 gen 21081 flags 2
[ 2060.451560] 		tree block backref root 384
[ 2060.451562] 	item 180 key (159708794880 169 2) itemoff 10310 itemsize 33
[ 2060.451563] 		extent refs 1 gen 21146 flags 2
[ 2060.451563] 		tree block backref root 7
[ 2060.451565] 	item 181 key (159708811264 169 1) itemoff 10277 itemsize 33
[ 2060.451566] 		extent refs 1 gen 21146 flags 2
[ 2060.451566] 		tree block backref root 7
[ 2060.451568] 	item 182 key (159708827648 169 0) itemoff 10244 itemsize 33
[ 2060.451569] 		extent refs 1 gen 21146 flags 2
[ 2060.451569] 		tree block backref root 7
[ 2060.451570] 	item 183 key (159708876800 169 0) itemoff 10211 itemsize 33
[ 2060.451571] 		extent refs 1 gen 21146 flags 2
[ 2060.451572] 		tree block backref root 385
[ 2060.451574] 	item 184 key (159708893184 169 1) itemoff 10178 itemsize 33
[ 2060.451576] 		extent refs 1 gen 21146 flags 2
[ 2060.451577] 		tree block backref root 385
[ 2060.451578] 	item 185 key (159708909568 169 0) itemoff 10145 itemsize 33
[ 2060.451579] 		extent refs 1 gen 21146 flags 2
[ 2060.451580] 		tree block backref root 385
[ 2060.451581] 	item 186 key (159708925952 169 1) itemoff 10112 itemsize 33
[ 2060.451582] 		extent refs 1 gen 21146 flags 2
[ 2060.451583] 		tree block backref root 7
[ 2060.451584] 	item 187 key (159708942336 169 0) itemoff 10079 itemsize 33
[ 2060.451585] 		extent refs 1 gen 21146 flags 2
[ 2060.451586] 		tree block backref root 7
[ 2060.451587] 	item 188 key (159708958720 169 0) itemoff 10046 itemsize 33
[ 2060.451588] 		extent refs 1 gen 21146 flags 2
[ 2060.451589] 		tree block backref root 385
[ 2060.451590] 	item 189 key (159708975104 169 0) itemoff 10013 itemsize 33
[ 2060.451591] 		extent refs 1 gen 21146 flags 2
[ 2060.451592] 		tree block backref root 385
[ 2060.451593] 	item 190 key (159708991488 169 0) itemoff 9980 itemsize 33
[ 2060.451594] 		extent refs 1 gen 21146 flags 2
[ 2060.451595] 		tree block backref root 7
[ 2060.451596] 	item 191 key (159709007872 169 0) itemoff 9947 itemsize 33
[ 2060.451597] 		extent refs 1 gen 21081 flags 2
[ 2060.451598] 		tree block backref root 2
[ 2060.451599] 	item 192 key (159709024256 169 0) itemoff 9914 itemsize 33
[ 2060.451600] 		extent refs 1 gen 21146 flags 2
[ 2060.451600] 		tree block backref root 7
[ 2060.451602] 	item 193 key (159709040640 169 2) itemoff 9881 itemsize 33
[ 2060.451603] 		extent refs 1 gen 21146 flags 2
[ 2060.451604] 		tree block backref root 2
[ 2060.451605] 	item 194 key (159709057024 169 1) itemoff 9848 itemsize 33
[ 2060.451607] 		extent refs 1 gen 21146 flags 2
[ 2060.451608] 		tree block backref root 2
[ 2060.451609] 	item 195 key (159709073408 169 0) itemoff 9815 itemsize 33
[ 2060.451610] 		extent refs 1 gen 21146 flags 2
[ 2060.451611] 		tree block backref root 2
[ 2060.451612] 	item 196 key (159709089792 169 1) itemoff 9782 itemsize 33
[ 2060.451613] 		extent refs 1 gen 21146 flags 2
[ 2060.451614] 		tree block backref root 2
[ 2060.451615] 	item 197 key (159709106176 169 0) itemoff 9749 itemsize 33
[ 2060.451616] 		extent refs 1 gen 21146 flags 2
[ 2060.451617] 		tree block backref root 2
[ 2060.451623] 	item 198 key (159709122560 169 0) itemoff 9716 itemsize 33
[ 2060.451624] 		extent refs 1 gen 21146 flags 2
[ 2060.451625] 		tree block backref root 2
[ 2060.451627] 	item 199 key (159709138944 169 0) itemoff 9683 itemsize 33
[ 2060.451628] 		extent refs 1 gen 21146 flags 2
[ 2060.451629] 		tree block backref root 2
[ 2060.451630] 	item 200 key (159709155328 169 0) itemoff 9650 itemsize 33
[ 2060.451631] 		extent refs 1 gen 21146 flags 2
[ 2060.451632] 		tree block backref root 2
[ 2060.451633] 	item 201 key (159709171712 169 1) itemoff 9617 itemsize 33
[ 2060.451634] 		extent refs 1 gen 21146 flags 2
[ 2060.451635] 		tree block backref root 2
[ 2060.451636] 	item 202 key (159709188096 169 0) itemoff 9584 itemsize 33
[ 2060.451638] 		extent refs 1 gen 21146 flags 2
[ 2060.451639] 		tree block backref root 2
[ 2060.451640] 	item 203 key (159709204480 169 1) itemoff 9551 itemsize 33
[ 2060.451641] 		extent refs 1 gen 21146 flags 2
[ 2060.451642] 		tree block backref root 1
[ 2060.451643] 	item 204 key (159709220864 169 0) itemoff 9518 itemsize 33
[ 2060.451644] 		extent refs 1 gen 21146 flags 2
[ 2060.451645] 		tree block backref root 1
[ 2060.451646] 	item 205 key (159709237248 169 0) itemoff 9485 itemsize 33
[ 2060.451647] 		extent refs 1 gen 21146 flags 2
[ 2060.451648] 		tree block backref root 2
[ 2060.451649] 	item 206 key (159709253632 169 0) itemoff 9452 itemsize 33
[ 2060.451650] 		extent refs 1 gen 21146 flags 2
[ 2060.451651] 		tree block backref root 1
[ 2060.451652] 	item 207 key (159709270016 169 0) itemoff 9419 itemsize 33
[ 2060.451653] 		extent refs 1 gen 21146 flags 2
[ 2060.451654] 		tree block backref root 2
[ 2060.451655] 	item 208 key (159709286400 169 0) itemoff 9386 itemsize 33
[ 2060.451656] 		extent refs 1 gen 21146 flags 2
[ 2060.451657] 		tree block backref root 2
[ 2060.451658] 	item 209 key (159709302784 169 0) itemoff 9353 itemsize 33
[ 2060.451659] 		extent refs 1 gen 21146 flags 2
[ 2060.451660] 		tree block backref root 2
[ 2060.451661] 	item 210 key (159709319168 169 0) itemoff 9320 itemsize 33
[ 2060.451662] 		extent refs 1 gen 21146 flags 2
[ 2060.451663] 		tree block backref root 7
[ 2060.451664] 	item 211 key (159709335552 169 1) itemoff 9287 itemsize 33
[ 2060.451665] 		extent refs 1 gen 21146 flags 2
[ 2060.451666] 		tree block backref root 2
[ 2060.451667] 	item 212 key (159709351936 169 0) itemoff 9254 itemsize 33
[ 2060.451668] 		extent refs 1 gen 21146 flags 2
[ 2060.451670] 		tree block backref root 2
[ 2060.451671] 	item 213 key (159709368320 169 1) itemoff 9221 itemsize 33
[ 2060.451672] 		extent refs 1 gen 21146 flags 2
[ 2060.451673] 		tree block backref root 7
[ 2060.451674] 	item 214 key (159709384704 169 0) itemoff 9188 itemsize 33
[ 2060.451675] 		extent refs 1 gen 21146 flags 2
[ 2060.451676] 		tree block backref root 7
[ 2060.451677] 	item 215 key (159709401088 169 0) itemoff 9155 itemsize 33
[ 2060.451678] 		extent refs 1 gen 21146 flags 2
[ 2060.451679] 		tree block backref root 7
[ 2060.451680] 	item 216 key (159709417472 169 0) itemoff 9122 itemsize 33
[ 2060.451681] 		extent refs 1 gen 21146 flags 2
[ 2060.451681] 		tree block backref root 2
[ 2060.451683] 	item 217 key (159709433856 169 0) itemoff 9089 itemsize 33
[ 2060.451684] 		extent refs 1 gen 21146 flags 2
[ 2060.451684] 		tree block backref root 1
[ 2060.451686] 	item 218 key (159709450240 169 0) itemoff 9056 itemsize 33
[ 2060.451687] 		extent refs 1 gen 21146 flags 2
[ 2060.451687] 		tree block backref root 385
[ 2060.451689] 	item 219 key (159709466624 169 1) itemoff 9023 itemsize 33
[ 2060.451690] 		extent refs 1 gen 21146 flags 2
[ 2060.451690] 		tree block backref root 385
[ 2060.451692] 	item 220 key (159709483008 169 0) itemoff 8990 itemsize 33
[ 2060.451693] 		extent refs 1 gen 21146 flags 2
[ 2060.451693] 		tree block backref root 385
[ 2060.451695] 	item 221 key (159709499392 169 1) itemoff 8957 itemsize 33
[ 2060.451696] 		extent refs 1 gen 21146 flags 2
[ 2060.451696] 		tree block backref root 385
[ 2060.451698] 	item 222 key (159709515776 169 0) itemoff 8924 itemsize 33
[ 2060.451699] 		extent refs 1 gen 21146 flags 2
[ 2060.451700] 		tree block backref root 385
[ 2060.451701] 	item 223 key (159709532160 169 1) itemoff 8891 itemsize 33
[ 2060.451703] 		extent refs 1 gen 21146 flags 2
[ 2060.451704] 		tree block backref root 385
[ 2060.451705] 	item 224 key (159709548544 169 0) itemoff 8858 itemsize 33
[ 2060.451706] 		extent refs 1 gen 21146 flags 2
[ 2060.451707] 		tree block backref root 385
[ 2060.451708] 	item 225 key (159709564928 169 1) itemoff 8825 itemsize 33
[ 2060.451709] 		extent refs 1 gen 21146 flags 2
[ 2060.451710] 		tree block backref root 2
[ 2060.451711] 	item 226 key (159709581312 169 0) itemoff 8792 itemsize 33
[ 2060.451712] 		extent refs 1 gen 21146 flags 2
[ 2060.451713] 		tree block backref root 2
[ 2060.451714] 	item 227 key (159709597696 169 0) itemoff 8759 itemsize 33
[ 2060.451715] 		extent refs 1 gen 21146 flags 2
[ 2060.451715] 		tree block backref root 2
[ 2060.451717] 	item 228 key (159709614080 169 0) itemoff 8726 itemsize 33
[ 2060.451718] 		extent refs 1 gen 21146 flags 2
[ 2060.451718] 		tree block backref root 2
[ 2060.451720] 	item 229 key (159709630464 169 0) itemoff 8693 itemsize 33
[ 2060.451721] 		extent refs 1 gen 21146 flags 2
[ 2060.451721] 		tree block backref root 2
[ 2060.451723] 	item 230 key (159709646848 169 0) itemoff 8660 itemsize 33
[ 2060.451724] 		extent refs 1 gen 21146 flags 2
[ 2060.451724] 		tree block backref root 2
[ 2060.451726] 	item 231 key (159709663232 169 0) itemoff 8627 itemsize 33
[ 2060.451727] 		extent refs 1 gen 21146 flags 2
[ 2060.451727] 		tree block backref root 2
[ 2060.451729] 	item 232 key (159709679616 169 0) itemoff 8594 itemsize 33
[ 2060.451730] 		extent refs 1 gen 21146 flags 2
[ 2060.451730] 		tree block backref root 1
[ 2060.451732] 	item 233 key (159709696000 169 0) itemoff 8561 itemsize 33
[ 2060.451734] 		extent refs 1 gen 21146 flags 2
[ 2060.451740] 		tree block backref root 2
[ 2060.451742] 	item 234 key (159709712384 169 0) itemoff 8528 itemsize 33
[ 2060.451743] 		extent refs 1 gen 21146 flags 2
[ 2060.451744] 		tree block backref root 7
[ 2060.451746] 	item 235 key (159709728768 169 0) itemoff 8495 itemsize 33
[ 2060.451748] 		extent refs 1 gen 21146 flags 2
[ 2060.451749] 		tree block backref root 7
[ 2060.451751] 	item 236 key (159709745152 169 0) itemoff 8462 itemsize 33
[ 2060.451752] 		extent refs 1 gen 21146 flags 2
[ 2060.451753] 		tree block backref root 2
[ 2060.451755] 	item 237 key (159709761536 169 0) itemoff 8429 itemsize 33
[ 2060.451757] 		extent refs 1 gen 21146 flags 2
[ 2060.451758] 		tree block backref root 2
[ 2060.451760] 	item 238 key (159709777920 169 0) itemoff 8396 itemsize 33
[ 2060.451761] 		extent refs 1 gen 21146 flags 2
[ 2060.451762] 		tree block backref root 2
[ 2060.451763] 	item 239 key (159710711808 169 0) itemoff 8363 itemsize 33
[ 2060.451764] 		extent refs 1 gen 21082 flags 2
[ 2060.451765] 		tree block backref root 7
[ 2060.451766] 	item 240 key (159710892032 169 0) itemoff 8330 itemsize 33
[ 2060.451767] 		extent refs 1 gen 21082 flags 2
[ 2060.451768] 		tree block backref root 7
[ 2060.451769] 	item 241 key (159711268864 169 0) itemoff 8297 itemsize 33
[ 2060.451770] 		extent refs 1 gen 21082 flags 2
[ 2060.451771] 		tree block backref root 384
[ 2060.451773] BTRFS error (device sda1): unable to find ref byte nr 159708172288 parent 0 root 385  owner 2 offset 0
[ 2060.451775] ------------[ cut here ]------------
[ 2060.451784] WARNING: CPU: 1 PID: 2650 at fs/btrfs/extent-tree.c:6261 __btrfs_free_extent.isra.68+0x92f/0xd70 [btrfs]()
[ 2060.451786] BTRFS: Transaction aborted (error -2)
[ 2060.451787] Modules linked in: bnep bluetooth rfkill ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_filter ebtable_nat ebtable_broute bridge ebtables ip6table_mangle ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_security iptable_raw coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic gpio_ich snd_hda_intel snd_hda_codec iTCO_wdt iTCO_vendor_support ppdev lpc_ich snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd i2c_i801 soundcore mei_me mei tpm_infineon parport_pc tpm_tis parport shpchp tpm acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace isofs squashfs btrfs xor i915 raid6_pq hid_logitech_hidpp
[ 2060.451813]  video i2c_algo_bit drm_kms_helper drm uas crc32c_intel 8021q garp stp usb_storage llc serio_raw mrp r8169 hid_logitech_dj mii scsi_dh_rdac scsi_dh_emc scsi_dh_alua sunrpc loop
[ 2060.451824] CPU: 1 PID: 2650 Comm: mount Tainted: G        W       4.2.3-300.fc23.x86_64 #1
[ 2060.451825] Hardware name: MSI MS-7636/H55M-P31(MS-7636)   , BIOS V1.9 09/14/2010
[ 2060.451826]  0000000000000000 0000000073c9bbcf ffff8800780af5b8 ffffffff81771fca
[ 2060.451828]  0000000000000000 ffff8800780af610 ffff8800780af5f8 ffffffff8109e4a6
[ 2060.451829]  ffffffffa03be349 000000252f595000 00000000fffffffe 0000000000000000
[ 2060.451831] Call Trace:
[ 2060.451834]  [<ffffffff81771fca>] dump_stack+0x45/0x57
[ 2060.451836]  [<ffffffff8109e4a6>] warn_slowpath_common+0x86/0xc0
[ 2060.451838]  [<ffffffff8109e535>] warn_slowpath_fmt+0x55/0x70
[ 2060.451845]  [<ffffffffa032368f>] __btrfs_free_extent.isra.68+0x92f/0xd70 [btrfs]
[ 2060.451857]  [<ffffffffa038ba5a>] ? find_ref_head+0x5a/0x80 [btrfs]
[ 2060.451865]  [<ffffffffa03273c8>] __btrfs_run_delayed_refs+0x998/0x1080 [btrfs]
[ 2060.451873]  [<ffffffffa032a674>] btrfs_run_delayed_refs.part.73+0x74/0x270 [btrfs]
[ 2060.451890]  [<ffffffffa032a885>] btrfs_run_delayed_refs+0x15/0x20 [btrfs]
[ 2060.451902]  [<ffffffffa033ef26>] btrfs_commit_transaction+0x56/0xad0 [btrfs]
[ 2060.451914]  [<ffffffffa03620bf>] ? free_extent_buffer+0x4f/0xa0 [btrfs]
[ 2060.451925]  [<ffffffffa0383bed>] btrfs_recover_log_trees+0x3ed/0x490 [btrfs]
[ 2060.451936]  [<ffffffffa037f260>] ? replay_one_extent+0x680/0x680 [btrfs]
[ 2060.451946]  [<ffffffffa033c33e>] open_ctree+0x19be/0x23f0 [btrfs]
[ 2060.451953]  [<ffffffffa0311f8e>] btrfs_mount+0x94e/0xa70 [btrfs]
[ 2060.451955]  [<ffffffff813b0795>] ? find_next_bit+0x15/0x20
[ 2060.451957]  [<ffffffff811c66ad>] ? pcpu_alloc+0x38d/0x670
[ 2060.451959]  [<ffffffff81221ef8>] mount_fs+0x38/0x160
[ 2060.451960]  [<ffffffff811c69c5>] ? __alloc_percpu+0x15/0x20
[ 2060.451962]  [<ffffffff8123cc1b>] vfs_kern_mount+0x6b/0x110
[ 2060.451968]  [<ffffffffa0311828>] btrfs_mount+0x1e8/0xa70 [btrfs]
[ 2060.451970]  [<ffffffff811c66ad>] ? pcpu_alloc+0x38d/0x670
[ 2060.451972]  [<ffffffff81221ef8>] mount_fs+0x38/0x160
[ 2060.451973]  [<ffffffff811c69c5>] ? __alloc_percpu+0x15/0x20
[ 2060.451975]  [<ffffffff8123cc1b>] vfs_kern_mount+0x6b/0x110
[ 2060.451977]  [<ffffffff8123f7f6>] do_mount+0x246/0xce0
[ 2060.451980]  [<ffffffff811c1216>] ? memdup_user+0x46/0x80
[ 2060.451981]  [<ffffffff812405cf>] SyS_mount+0x9f/0x100
[ 2060.451984]  [<ffffffff817789ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 2060.451985] ---[ end trace 7b4fe08881eca152 ]---
[ 2060.451987] BTRFS: error (device sda1) in __btrfs_free_extent:6261: errno=-2 No such entry
[ 2060.451990] BTRFS: error (device sda1) in btrfs_run_delayed_refs:2781: errno=-2 No such entry
[ 2060.451997] BTRFS: error (device sda1) in btrfs_replay_log:2375: errno=-2 No such entry (Failed to recover log tree)
[ 2060.463834] BTRFS error (device sda1): cleaner transaction attach returned -30
[ 2060.501123] BTRFS: open_ctree failed

-- 
Hugo Mills             | A gentleman doesn't do damage unless he's paid for
hugo@... carfax.org.uk | it.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                            Juri Papay

--PsoQMlSWCswIFQyi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWWbA6AAoJEFheFHXiqx3kvbMQAJhNU0d2U7P4U6rcDl3N+7c8
K4mDU3eMwPlwDSIXjWwobSBLWiGpQVlRc7p4gNnBvGHB0C37pe/N7x7ElTe8WbCd
a4O6hrss3Ch+EC8nnFdwSfRMF9ni4I3mbclBu2QuaeJPELGo1xfiaU/UHhakNd+/
ss6QLFDnUIzhUT3+zpceTaBKh0LAoPUbEDwf0LneY+jlPYtz7yMpvQqzA2kTvch8
AWpAKsXzs/kzleHKUl0iYCcnnj8+5L+ChKV7Km5JZx7dC6QHO67kzgaaxyTFnmGi
5aHCrf/+ceNoB3dd198bgOEixWcJrfUGrDJY6AFAH7JYIMDEWQsWzDyEYAR85g/L
VSgjgyLJlaAAleoE1TAv99fnVtnJT9zFKbGk5GyNVkQCxlKJt6b4vwfuUAEm4Egm
SA/9fBQuZJ3RpI8Zs2NYj1wtfnouMyMzgtMy1mrrx3fJ/eMNQUU16LZsRGByOcxn
KbhMbiykKDk7Drj+kQmYEKlV7f5bV8j64Dz4KhDUzH0D/CplfmO6O1xQnldJr/AE
rtC/FFDeCw6IHb0eVXY6qpLZMi60UTzI66LHDIxDM74qriaZHWLE8MnZGht1af4L
bFBz2fam7yTgglNbbTQB326fH+ydjiv3kENHOCOKmHZuatEbcimi4c54aQ/Brdsn
nGBBsR1dIxu7c3YXdX23
=az4e
-----END PGP SIGNATURE-----

--PsoQMlSWCswIFQyi--
