Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:45912 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbaCKXol (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 19:44:41 -0400
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 20A2080069
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Mar 2014 16:44:41 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id EE49A80069
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Mar 2014 16:44:40 -0700 (PDT)
Date: Tue, 11 Mar 2014 16:44:40 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: linux-btrfs@vger.kernel.org
Subject: warn at fs/btrfs/extent-tree.c:5748
 __btrfs_free_extent+0x9ce/0xa20
Message-ID: <alpine.DEB.2.00.1403111642350.5511@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

Is this something you guys have seen before?  This is from v3.13-rc2.

kernel: [49432.696440] WARNING: CPU: 3 PID: 26411 at /srv/autobuild-ceph/gitbuilder.git/build/fs/btrfs/extent-tree.c:5748 __btrfs_free_extent+0x9ce/0xa20 [btrfs]()
kernel: [49432.710128] Modules linked in: arc4(F) md4(F) nls_utf8(F) cifs(F) ufs(F) qnx4(F) hfsplus(F) hfs(F) minix(F) ntfs(F) msdos(F) jfs(F) xfs(F) reiserfs(F) ext2(F) kvm_intel(F) kvm(F) ib_iser(F) rdma_cm(F) ib_cm(F) iw_cm(F) ib_sa(F) ib_mad(F) ib_core(F) ib_addr(F) iscsi_tcp(F) libiscsi_tcp(F) libiscsi(F) psmouse(F) ipmi_si(F) serio_raw(F) gpio_ich(F) joydev(F) dcdbas(F) i7core_edac(F) edac_core(F) ipmi_msghandler(F) mac_hid(F) acpi_power_meter(F) lpc_ich(F) tpm_tis(F) nfsd(F) nfs_acl(F) auth_rpcgss(F) scsi_transport_iscsi(F) nfs(F) fscache(F) lockd(F) lp(F) sunrpc(F) parport(F) hid_generic(F) usbhid(F) hid(F) btrfs(F) raid6_pq(F) mptsas(F) ixgbe(F) mptscsih(F) dca(F) mptbase(F) ptp(F) pps_core(F) scsi_transport_sas(F) xor(F) mdio(F) bnx2(F) libcrc32c(F)
kernel: [49432.777445] CPU: 3 PID: 26411 Comm: ceph-osd Tainted: GF         I  3.14.0-rc5-ceph-00016-gf31a96a #1
kernel: [49432.786704] Hardware name: Dell Inc. PowerEdge R410/01V648, BIOS 1.6.3 02/07/2011
kernel: [49432.794223]  0000000000001674 ffff8800bf1cbac8 ffffffff816e4840 ffff88022726ef90
kernel: [49432.801700]  0000000000000000 ffff8800bf1cbb08 ffffffff810524ac a800000000b07e50
kernel: [49432.809176]  ffff880094e74120 0000000000000000 00000000b07c9000 0000000000000000
kernel: [49432.816653] Call Trace:
kernel: [49432.819119]  [<ffffffff816e4840>] dump_stack+0x46/0x58
kernel: [49432.825384]  [<ffffffff810524ac>] warn_slowpath_common+0x8c/0xc0
kernel: [49432.831413]  [<ffffffff810524fa>] warn_slowpath_null+0x1a/0x20
kernel: [49432.837284]  [<ffffffffa010b4be>] __btrfs_free_extent+0x9ce/0xa20 [btrfs]
kernel: [49432.844108]  [<ffffffffa01110b8>] __btrfs_run_delayed_refs+0x428/0x11e0 [btrfs]
kernel: [49432.851465]  [<ffffffffa0109458>] ? block_rsv_release_bytes+0x108/0x190 [btrfs]
kernel: [49432.858823]  [<ffffffffa0114066>] btrfs_run_delayed_refs+0x76/0x2a0 [btrfs]
kernel: [49432.865869]  [<ffffffffa01251ff>] __btrfs_end_transaction+0x26f/0x370 [btrfs]
kernel: [49432.873044]  [<ffffffffa0125330>] btrfs_end_transaction+0x10/0x20 [btrfs]
kernel: [49432.879872]  [<ffffffffa01327de>] btrfs_link+0x13e/0x1d0 [btrfs]
kernel: [49432.885903]  [<ffffffff811b7571>] vfs_link+0x1b1/0x270
kernel: [49432.891060]  [<ffffffff811b8120>] SyS_linkat+0x210/0x2d0
kernel: [49432.896394]  [<ffffffff811b81fe>] SyS_link+0x1e/0x20
kernel: [49432.901380]  [<ffffffff816f7cd6>] system_call_fastpath+0x1a/0x1f

The full dump is at

	http://tracker.ceph.com/issues/7688
	http://tracker.ceph.com/attachments/download/1141/kern.log.gz

Thanks-
sage
