From: Sage Weil <sage@newdream.net>
Subject: Re: 3.0-rcX BUG at fs/btrfs/ioctl.c:432 - bisected
Date: Fri, 10 Jun 2011 11:08:34 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1106101100310.5245@cobra.newdream.net>
References: <4DF140AB.4030805@sandia.gov> <20110609234553.GN12709@twin.jikos.cz>
 <4DF24F0E.4040306@sandia.gov> <1307726732-sup-3404@shiny>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jim Schutt <jaschut@sandia.gov>, dave <dave@jikos.cz>,
	miaox <miaox@cn.fujitsu.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	ceph-devel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <1307726732-sup-3404@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 10 Jun 2011, Chris Mason wrote:
> Excerpts from Jim Schutt's message of 2011-06-10 13:06:22 -0400:
> 
> [ two different btrfs crashes ]
> 
> I think your two crashes in btrfs were from the uninit variables and
> those should be fixed in rc2.
> 
> > When I did my bisection, my criteria for success/failure was
> > "did mkcephfs succeed?".  When I apply this criteria to a recent
> > linus kernel (e.g. 06e86849cf4019), which includes the fix you
> > mentioned (aa0467d8d2a00e), I get still a different failure mode,
> > which doesn't actually reference btrfs:
> > 
> > [  276.364178] BUG: unable to handle kernel NULL pointer dereference at 000000000000000a
> > [  276.365127] IP: [<ffffffffa05434b1>] journal_start+0x3e/0x9c [jbd]
> 
> Looking at the resulting code in the oops, we're here in journal_start:
> 
>         if (handle) {
>                 J_ASSERT(handle->h_transaction->t_journal == journal);
> 
> handle comes from current->journal_info, and we're doing a deref on
> handle->h_transaction, which is probably 0xa.
> 
> So, we're leaving crud in current->journal_info and ext3 is finding it.
> 
> Perhaps its from ceph starting a transaction but leaving it running?
> The bug came with Josef's transaction performance fixes, but it is
> probably a mixture of his code with the ioctls ceph is using.

Ah, yeah, that's the problem.  We saw a similar problem a while back with 
the start/stop transaction ioctls.  In this case, create_snapshot is doing

	trans = btrfs_start_transaction(root->fs_info->extent_root, 5);
	if (IS_ERR(trans)) {
		ret = PTR_ERR(trans);
		goto fail;
	}

which sets current->journal_info.  Then

	ret = btrfs_snap_reserve_metadata(trans, pending_snapshot);
	BUG_ON(ret);

	list_add(&pending_snapshot->list,
		 &trans->transaction->pending_snapshots);
	if (async_transid) {
		*async_transid = trans->transid;
		ret = btrfs_commit_transaction_async(trans,
				     root->fs_info->extent_root, 1);
	} else {
		ret = btrfs_commit_transaction(trans,
				       root->fs_info->extent_root);
	}

but the async snap creation ioctl takes the async path, which runs 
btrfs_commit_transaction in a worker thread.

I'm not sure what the right thing to do is here is... can whatever is in 
journal_info be attached to trans instead in 
btrfs_commit_transaction_async()?

sage






> 
> [ rest of the oops below for context ]
> 
> -chris
> 
> > [  276.365127] PGD 1e4469067 PUD 1e1658067 PMD 0
> > [  276.365127] Oops: 0000 [#1] SMP
> > [  276.365127] CPU 2
> > [  276.365127] Modules linked in: btrfs zlib_deflate lzo_compress ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp i2c_dev i2c_core ext3 jbd scsi_transport_iscsi rds ib_ipoib rdma_ucm rdma_cm ib_ucm ib_uverbs ib_umad ib_cm iw_cm ib_addr ipv6 ib_sa dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod video sbs sbshc pci_slot battery acpi_pad ac kvm sg ses sd_mod enclosure megaraid_sas ide_cd_mod cdrom ib_mthca ib_mad qla2xxx button ib_core serio_raw scsi_transport_fc scsi_tgt dcdbas ata_piix libata tpm_tis tpm i5k_amb ioatdma tpm_bios hwmon iTCO_wdt scsi_mod i5000_edac iTCO_vendor_support ehci_hcd dca edac_core uhci_hcd pcspkr rtc nfs nfs_acl auth_rpcgss fscache lockd sunrpc 
 tg3 bnx2 e1000 [last unloaded: freq_table]
> > [  276.365127]
> > [  276.365127] Pid: 6076, comm: cosd Not tainted 3.0.0-rc2-00196-g06e8684 #26 Dell Inc. PowerEdge 1950/0DT097
> > [  276.365127] RIP: 0010:[<ffffffffa05434b1>]  [<ffffffffa05434b1>] journal_start+0x3e/0x9c [jbd]
> > [  276.365127] RSP: 0018:ffff8801e2897b28  EFLAGS: 00010286
> > [  276.365127] RAX: 000000000000000a RBX: ffff8801de8e1090 RCX: 0000000000000002
> > [  276.365127] RDX: 0000000019b2d000 RSI: 000000000000000e RDI: 000000000000000e
> > [  276.365127] RBP: ffff8801e2897b48 R08: 0000000000000003 R09: ffff8801e2897c38
> > [  276.365127] R10: ffff8801e2897ed8 R11: 0000000000000001 R12: ffff880223ff4400
> > [  276.365127] R13: ffff880218522d60 R14: 0000000000000ec6 R15: ffff88021f54d878
> > [  276.365127] FS:  00007f8ff0bbb710(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
> > [  276.365127] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [  276.365127] CR2: 000000000000000a CR3: 000000021744f000 CR4: 00000000000006e0
> > [  276.365127] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  276.365127] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [  276.365127] Process cosd (pid: 6076, threadinfo ffff8801e2896000, task ffff880218522d60)
> > [  276.365127] Stack:
> > [  276.365127]  ffff8801e2897b68 ffffea000756e788 ffff88021f54d728 ffff8801e2897c78
> > [  276.365127]  ffff8801e2897b58 ffffffffa05670ce ffff8801e2897b68 ffffffffa055c72d
> > [  276.365127]  ffff8801e2897be8 ffffffffa055f044 ffff8801e2897c38 0000007400000000
> > [  276.365127] Call Trace:
> > [  276.365127]  [<ffffffffa05670ce>] ext3_journal_start_sb+0x4f/0x51 [ext3]
> > [  276.365127]  [<ffffffffa055c72d>] ext3_journal_start+0x12/0x14 [ext3]
> > [  276.365127]  [<ffffffffa055f044>] ext3_write_begin+0x93/0x1a1 [ext3]
> > [  276.365127]  [<ffffffff810c6f0e>] ? __kunmap_atomic+0xe/0x10
> > [  276.365127]  [<ffffffff810c75e5>] generic_perform_write+0xb1/0x172
> > [  276.365127]  [<ffffffff81036a33>] ? need_resched+0x23/0x2d
> > [  276.365127]  [<ffffffff810c76ea>] generic_file_buffered_write+0x44/0x6f
> > [  276.365127]  [<ffffffff810c91f5>] __generic_file_aio_write+0x253/0x2a8
> > [  276.365127]  [<ffffffff810c92ad>] generic_file_aio_write+0x63/0xb8
> > [  276.365127]  [<ffffffff81113b26>] do_sync_write+0xc7/0x10b
> > [  276.365127]  [<ffffffff81036a4b>] ? should_resched+0xe/0x2f
> > [  276.365127]  [<ffffffff813b0faf>] ? _cond_resched+0xe/0x22
> > [  276.365127]  [<ffffffff811986c3>] ? security_file_permission+0x2c/0x31
> > [  276.365127]  [<ffffffff81113d21>] ? rw_verify_area+0xac/0xdb
> > [  276.365127]  [<ffffffff81114253>] vfs_write+0xac/0xe4
> > [  276.365127]  [<ffffffff8111434f>] sys_write+0x4c/0x71
> > [  276.365127]  [<ffffffff813b8beb>] system_call_fastpath+0x16/0x1b
> > [  276.365127] Code: 89 fc 48 c7 c3 e2 ff ff ff 89 f7 65 4c 8b 2c 25 c0 b5 00 00 4d 85 e4 49 8b 85 48 06 00 00 74 5e 48 85 c0 74 14 48 89 c3 48 8b 00 <4c> 39 20 74 04 0f 0b eb fe ff 43 0c eb 45 e8 70 ff ff ff 48 85
> > [  276.365127] RIP  [<ffffffffa05434b1>] journal_start+0x3e/0x9c [jbd]
> > [  276.365127]  RSP <ffff8801e2897b28>
> > [  276.365127] CR2: 000000000000000a
> > [  276.725157] ---[ end trace 8a802dc03e3972ad ]---
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
