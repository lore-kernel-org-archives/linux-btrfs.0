Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from homie.mail.dreamhost.com ([208.97.132.208]:50722 "EHLO
	homiemail-a37.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754029AbaJNH2D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 03:28:03 -0400
Message-ID: <1413271664.27233.13.camel@linux-t7sj.site>
Subject: btrfs soft lockups: locks gone crazy
From: Davidlohr Bueso <dave@stgolabs.net>
To: LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Date: Tue, 14 Oct 2014 00:27:44 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm getting massive amounts of cpu soft lockups in Linus's tree for
today. This occurs almost immediately and is very reproducible in aim7
disk workloads using btrfs:

 kernel:[  559.800017] NMI watchdog: BUG: soft lockup - CPU#114 stuck for 22s! [reaim:44435]
...
[  999.800070] Modules linked in: iptable_filter(E) ip_tables(E) x_tables(E) rpcsec_gss_krb5(E) auth_rpcgss(E) nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E) sunrpc(E) fscache(E) iscsi_ibft(E) iscsi_boot_sysfs(E) af_packet(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) ext4(E) crc16(E) mbcache(E) coretemp(E) jbd2(E) kvm_intel(E) kvm(E) crct10dif_pclmul(E) crc32_pclmul(E) iTCO_wdt(E) sb_edac(E) iTCO_vendor_support(E) joydev(E) ghash_clmulni_intel(E) aesni_intel(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E) cryptd(E) pcspkr(E) edac_core(E) i2c_i801(E) lpc_ich(E) mfd_core(E) ipmi_si(E) ipmi_msghandler(E) wmi(E) processor(E) shpchp(E) acpi_pad(E) button(E) dm_mod(E) btrfs(E) xor(E) raid6_pq(E) sd_mod(E) hid_generic(E) usbhid(E) sr_mod(E) cdrom(E) mgag200(E) syscopyarea(E) sysfillrect(E) ehci_pci(E) sysimgblt(E) i2c_algo_bit(E) drm_kms_helper(E) ixgbe(E) ahci(E) ehci_hcd(E) ttm(E) mdio(E) libahci(E) ptp(E) crc32c_intel(E) mpt2sas(E) pps_core(E) usbcore(E) drm(E) libata(E) raid_class(E) usb_common(E) dca(E) scsi_transport_sas(E) sg(E) scsi_mod(E) autofs4(E)
[  999.800070] CPU: 53 PID: 1027 Comm: kworker/u292:3 Tainted: G            EL 3.17.0-3-default+ #2
[  999.800070] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BIVTSDP1.86B.0044.R01.1310221705 10/22/2013
[  999.800070] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  999.800070] task: ffff882054e76190 ti: ffff882054e78000 task.ti: ffff882054e78000
[  999.800070] RIP: 0010:[<ffffffff810a2e46>]  [<ffffffff810a2e46>] queue_read_lock_slowpath+0x86/0x90
[  999.800070] RSP: 0018:ffff882054e7ba00  EFLAGS: 00000216
[  999.800070] RAX: 0000000000008a64 RBX: ffff882054e7b9b0 RCX: 0000000000008a70
[  999.800070] RDX: 0000000000008a70 RSI: 00000000000000c0 RDI: ffff881833b49ea0
[  999.800070] RBP: ffff882054e7ba00 R08: ffff881833b49e64 R09: 0000000000000001
[  999.800070] R10: 0000000000000000 R11: 00000000ffffffff R12: ffff881047377f00
[  999.800070] R13: 0000000000000007 R14: ffff88203bf6d520 R15: ffff881000000000
[  999.800070] FS:  0000000000000000(0000) GS:ffff88207f500000(0000) knlGS:0000000000000000
[  999.800070] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  999.800070] CR2: 00000000006a7f80 CR3: 0000000001a14000 CR4: 00000000001407e0
[  999.800070] Stack:
[  999.800070]  ffff882054e7ba10 ffffffff81573cfc ffff882054e7ba70 ffffffffa033349b
[  999.800070]  ffff882038e9ac80 ffff88203b58fd00 ffff882038cd4ed8 0000000000000000
[  999.800070]  ffff882054e7ba68 ffff881833b49e30 ffff882057fb4800 0000000000000001
[  999.800070] Call Trace:
[  999.800070]  [<ffffffff81573cfc>] _raw_read_lock+0x1c/0x30
[  999.800070]  [<ffffffffa033349b>] btrfs_tree_read_lock+0x5b/0x120 [btrfs]
[  999.800070]  [<ffffffffa02d1f6b>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[  999.800070]  [<ffffffffa02d726a>] btrfs_search_slot+0x53a/0xab0 [btrfs]
[  999.800070]  [<ffffffff812c84c7>] ? cpumask_next_and+0x37/0x50
[  999.800070]  [<ffffffffa02eebf7>] btrfs_lookup_file_extent+0x37/0x40 [btrfs]
[  999.800070]  [<ffffffffa030e1ca>] __btrfs_drop_extents+0x16a/0xdb0 [btrfs]
[  999.800070]  [<ffffffffa03170cc>] ? __set_extent_bit+0x22c/0x550 [btrfs]
[  999.800070]  [<ffffffffa02d1cea>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  999.800070]  [<ffffffffa02fe26e>] insert_reserved_file_extent.constprop.58+0x9e/0x2f0 [btrfs]
[  999.800070]  [<ffffffffa0303ff5>] btrfs_finish_ordered_io+0x2e5/0x600 [btrfs]
...

[ 1011.800059] CPU: 2 PID: 1 Comm: systemd Tainted: G            EL 3.17.0-3-default+ #2
[ 1011.800059] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BIVTSDP1.86B.0044.R01.1310221705 10/22/2013
[ 1011.800059] task: ffff880857eb8010 ti: ffff880857ebc000 task.ti: ffff880857ebc000
[ 1011.800059] RIP: 0010:[<ffffffff810a2e46>]  [<ffffffff810a2e46>] queue_read_lock_slowpath+0x86/0x90
[ 1011.800059] RSP: 0018:ffff880857ebfce0  EFLAGS: 00000202
[ 1011.800059] RAX: 0000000000008a64 RBX: ffff8808549cd910 RCX: 0000000000008a74
[ 1011.800059] RDX: 0000000000008a74 RSI: 00000000000000c4 RDI: ffff881833b49ea0
[ 1011.800059] RBP: ffff880857ebfce0 R08: ffff881833b49e64 R09: 0000000000000000
[ 1011.800059] R10: ffffe8e7ffc4ed60 R11: 0000000000000000 R12: ffff8808549cd900
[ 1011.800059] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880855e931e0
[ 1011.800059] FS:  00007f12cb6ec880(0000) GS:ffff88087f840000(0000) knlGS:0000000000000000
[ 1011.800059] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1011.800059] CR2: 00007f12cb707000 CR3: 0000002054f16000 CR4: 00000000001407e0
[ 1011.800059] Stack:
[ 1011.800059]  ffff880857ebfcf0 ffffffff81573cfc ffff880857ebfd50 ffffffffa033349b
[ 1011.800059]  ffff880857ebfda8 ffffffff811cf72e ffff880857ebfd20 ffffffff811cbef8
[ 1011.800059]  ffff880857ebfda8 ffff881833b49e30 ffff882057fb4800 0000000000000000
[ 1011.800059] Call Trace:
[ 1011.800059]  [<ffffffff81573cfc>] _raw_read_lock+0x1c/0x30
[ 1011.800059]  [<ffffffffa033349b>] btrfs_tree_read_lock+0x5b/0x120 [btrfs]
[ 1011.800059]  [<ffffffff811cf72e>] ? do_last+0x18e/0x11d0
[ 1011.800059]  [<ffffffff811cbef8>] ? inode_permission+0x18/0x50
[ 1011.800059]  [<ffffffffa02d1f6b>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[ 1011.800059]  [<ffffffffa02d726a>] btrfs_search_slot+0x53a/0xab0 [btrfs]
[ 1011.800059]  [<ffffffff811a644e>] ? kmem_cache_alloc+0x47e/0x490
[ 1011.800059]  [<ffffffffa02ff04a>] btrfs_real_readdir+0xda/0x570 [btrfs]
[ 1011.800059]  [<ffffffff811d3e53>] iterate_dir+0xa3/0x130
[ 1011.800059]  [<ffffffff811d42e9>] SyS_getdents+0x89/0x100
[ 1011.800059]  [<ffffffff811d3fb0>] ? fillonedir+0xd0/0xd0
[ 1011.800059]  [<ffffffff81574329>] system_call_fastpath+0x16/0x1b
[ 1011.800059] Code: 07 3c ff 74 f8 66 83 47 04 01 5d c3 8b 07 3c ff 75 f8 f3 90 8b 07 3c ff 74 f8 5d c3 0f b7 47 04 66 39 c2 74 b5 f3 90 0f b7 47 04 <66> 39 c1 75 f5 eb a8 0f 1f 00 0f 1f 44 00 00 48 63 ff 55 48 8b 
 3c ff 74 f8 5d c3 0f b7 47 04 66 39 c2 74 b5 f3 90 0f b7 47 04 <66> 39 c1 75 f5 eb a8 0f 1f 00 0f 1f 44 00 00 48 63 ff 55 48 8b 

The closes report I've been able to found was from Fengguang:
https://lkml.org/lkml/2014/10/3/183
However it seems that the 'fix' (commit ea4ebde02e08) does not work in
this case. Are there any particular semantics btrfs relies on for rw
spinlocks that could of been broken with qrwlocks?

This issue is seen as far as 3.15 (3.14 is ok), however while bisecting
I ran into other, at first glance similar issues, also related to
locking in btrfs. This one actually prevents the whole system from
booting. 

[   52.294136] ------------[ cut here ]------------
[   52.298112] kernel BUG at fs/btrfs/locking.c:269!
[   52.298112] invalid opcode: 0000 [#1] SMP 
[   52.298112] Modules linked in: acpi_cpufreq(E-) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) aesni_intel(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) pcspkr(E) joydev(E) sb_edac(E) ablk_helper(E) edac_core(E) cryptd(E) i2c_i801(E) lpc_ich(E) mfd_core(E) ipmi_si(E) ipmi_msghandler(E) wmi(E) shpchp(E) button(E) acpi_pad(E) processor(E) dm_mod(E) btrfs(E) xor(E) raid6_pq(E) sd_mod(E) hid_generic(E) usbhid(E) sr_mod(E) cdrom(E) mgag200(E) syscopyarea(E) ixgbe(E) sysfillrect(E) sysimgblt(E) i2c_algo_bit(E) ehci_pci(E) drm_kms_helper(E) mdio(E) ahci(E) ehci_hcd(E) libahci(E) ptp(E) ttm(E) mpt2sas(E) crc32c_intel(E) raid_class(E) pps_core(E) libata(E) drm(E) usbcore(E) usb_common(E) dca(E) scsi_transport_sas(E) sg(E) scsi_mod(E) autofs4(E)
[   52.298112] CPU: 70 PID: 1304 Comm: systemd-readahe Tainted: G            E 3.15.0-3-default #8
[   52.298112] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BIVTSDP1.86B.0044.R01.1310221705 10/22/2013
[   52.298112] task: ffff881052f78010 ti: ffff881055964000 task.ti: ffff881055964000
[   52.298112] RIP: 0010:[<ffffffffa0306fed>]  [<ffffffffa0306fed>] btrfs_assert_tree_read_locked.part.0+0x9/0xb [btrfs]
[   52.298112] RSP: 0018:ffff881055967948  EFLAGS: 00010246
[   52.298112] RAX: 0000000000000000 RBX: ffff880852806e10 RCX: 0000000000000004
[   52.298112] RDX: 0000000000000000 RSI: ffff88085285b270 RDI: ffff880852806e10
[   52.298112] RBP: ffff881055967948 R08: 0000000000000000 R09: 000000002d748000
[   52.298112] R10: 00000000000003ff R11: 0000000000000001 R12: 0000000000001e1b
[   52.298112] R13: ffff88087f272c00 R14: 0000000000000001 R15: ffff88085605a000
[   52.298112] FS:  00007f33834d2740(0000) GS:ffff88087fb20000(0000) knlGS:0000000000000000
[   52.298112] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   52.298112] CR2: 00007f50589787b0 CR3: 00000008553c2000 CR4: 00000000001407e0
[   52.298112] Stack:
[   52.298112]  ffff881055967960 ffffffffa02cd8a9 ffff880852806e10 ffff881055967998
[   52.298112]  ffffffffa028daf6 0000000000000000 0000000000000000 0000000000000000
[   52.298112]  0000000000000000 ffff880852806e10 ffff8810559679e8 ffffffffa028eaac
[   52.298112] Call Trace:
[   52.298112]  [<ffffffffa02cd8a9>] btrfs_tree_read_unlock_blocking+0xc9/0xd0 [btrfs]
[   52.298112]  [<ffffffffa028daf6>] verify_parent_transid+0x146/0x1f0 [btrfs]
[   52.298112]  [<ffffffffa028eaac>] btree_read_extent_buffer_pages.constprop.52+0xcc/0x120 [btrfs]
[   52.298112]  [<ffffffffa02908f8>] read_tree_block+0x38/0x60 [btrfs]
[   52.298112]  [<ffffffffa02912c6>] btrfs_read_tree_root+0x126/0x190 [btrfs]
[   52.298112]  [<ffffffffa0291342>] btrfs_read_fs_root+0x12/0x50 [btrfs]
[   52.298112]  [<ffffffff812b23ad>] ? radix_tree_lookup+0xd/0x10
[   52.298112]  [<ffffffffa029140d>] btrfs_get_fs_root+0x8d/0x240 [btrfs]
[   52.298112]  [<ffffffffa02f1b67>] __resolve_indirect_refs+0xf7/0x6f0 [btrfs]
[   52.298112]  [<ffffffffa02cd5cc>] ? btrfs_tree_read_lock+0x4c/0xf0 [btrfs]
[   52.298112]  [<ffffffffa02f21d6>] ? __add_missing_keys.isra.14+0x76/0x150 [btrfs]
[   52.298112]  [<ffffffffa02f2d40>] find_parent_nodes+0x3c0/0x740 [btrfs]
[   52.298112]  [<ffffffffa02f315a>] __btrfs_find_all_roots+0x9a/0x100 [btrfs]
[   52.298112]  [<ffffffffa02b0d80>] ? set_state_bits+0x80/0x80 [btrfs]
[   52.298112]  [<ffffffffa02f3b4d>] iterate_extent_inodes+0x12d/0x310 [btrfs]
[   52.298112]  [<ffffffffa02b0d80>] ? set_state_bits+0x80/0x80 [btrfs]
[   52.298112]  [<ffffffffa02f3db7>] iterate_inodes_from_logical+0x87/0xa0 [btrfs]
[   52.298112]  [<ffffffffa02b89d2>] extent_fiemap+0x262/0x580 [btrfs]
[   52.298112]  [<ffffffffa029be30>] ? btrfs_get_extent+0xaf0/0xaf0 [btrfs]
[   52.298112]  [<ffffffffa0299935>] btrfs_fiemap+0x45/0x50 [btrfs]
[   52.298112]  [<ffffffff811bd9b3>] do_vfs_ioctl+0x153/0x4b0
[   52.298112]  [<ffffffff811c1444>] ? dput+0xb4/0x170
[   52.298112]  [<ffffffff811bdd91>] SyS_ioctl+0x81/0xa0
[   52.298112]  [<ffffffff815510e9>] system_call_fastpath+0x16/0x1b
[   52.298112] Code: bd d9 ff ff ff 48 89 df e8 91 7f f6 ff 44 89 e8 eb 05 b8 f4 ff ff ff 48 83 c4 30 5b 41 5c 41 5d 5d c3 0f 1f 44 00 00 55 48 89 e5 <0f> 0b 0f 1f 44 00 00 55 48 89 e5 0f 0b 55 be 7f 05 00 00 48 c7 
[   52.298112] RIP  [<ffffffffa0306fed>] btrfs_assert_tree_read_locked.part.0+0x9/0xb [btrfs]
[   52.298112]  RSP <ffff881055967948>
[   53.230969] ---[ end trace 42ee398737c77c00 ]---

The apparent culprit is:

commit a26e8c9f75b0bfd8cccc9e8f110737b136eb5994
Author: Josef Bacik <jbacik@fb.com>
Date:   Fri Mar 28 17:07:27 2014 -0400

    Btrfs: don't clear uptodate if the eb is under IO

But I cannot say if this is in fact related to the issue I see in newer kernels.

Ring any bells?

Thanks,
Davidlohr

