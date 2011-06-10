From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: 3.0-rcX BUG at fs/btrfs/ioctl.c:432 - bisected
Date: Fri, 10 Jun 2011 11:06:22 -0600
Message-ID: <4DF24F0E.4040306@sandia.gov>
References: <4DF140AB.4030805@sandia.gov>
 <20110609234553.GN12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Cc: jaschut@sandia.gov, miaox@cn.fujitsu.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
To: dave@jikos.cz
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20110609234553.GN12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:
> Hi,
> 
> a candidate fix:
> 
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=aa0467d8d2a00e75b2bb6a56a4ee6d70c5d1928f
> 
> "
>  With Linus' tree, today's linux-next build (powercp ppc64_defconfig)
>  produced this warning:
> 
>  fs/btrfs/delayed-inode.c: In function 'btrfs_delayed_update_inode':
>  fs/btrfs/delayed-inode.c:1598:6: warning: 'ret' may be used
>  uninitialized in this function
>  Introduced by commit 16cdcec736cd ("btrfs: implement delayed inode items
>  operation").
> 
>  This fixes a bug in btrfs_update_inode(): if the returned value from
>  btrfs_delayed_update_inode is a nonzero garbage, inode stat data are not
>  updated and several call paths may hit a BUG_ON or fail with strange
>  code.
> "
> 
> if you can reproduce it reliably, add this patch on top of the delayed inodes.
> 

I cherry-picked aa0467d8d2a00e on top of 16cdcec736cd21, which
gave me the following instead of a BUG:

[  246.986087] ------------[ cut here ]------------
[  246.990714] WARNING: at mm/page_alloc.c:2032 __alloc_pages_slowpath+0x54/0x3c5()
[  246.998100] Hardware name: PowerEdge 1950
[  247.002110] Modules linked in: btrfs zlib_deflate lzo_compress ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp i2c_dev i2c_core ext3 jbd scsi_transport_iscsi rds ib_ipoib rdma_ucm rdma_cm ib_ucm ib_uverbs ib_umad ib_cm iw_cm ib_addr ipv6 ib_sa dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod video sbs sbshc pci_slot battery acpi_pad ac kvm sg ses sd_mod enclosure megaraid_sas ide_cd_mod cdrom ib_mthca qla2xxx serio_raw ib_mad ib_core scsi_transport_fc button scsi_tgt ata_piix libata scsi_mod dcdbas i5k_amb tpm_tis tpm ioatdma hwmon tpm_bios ehci_hcd dca i5000_edac pcspkr iTCO_wdt uhci_hcd iTCO_vendor_support edac_core rtc nfs nfs_acl auth_rpcgss fscache lockd sunrpc tg3 
 bnx2 e1000 [last unloaded: freq_table]
[  247.076305] Pid: 6044, comm: cosd Not tainted 2.6.39-00002-gf47e9fd #25
[  247.082911] Call Trace:
[  247.085358]  [<ffffffff810ccf8a>] ? __alloc_pages_slowpath+0x54/0x3c5
[  247.091793]  [<ffffffff81049379>] ? warn_slowpath_common+0x85/0x9e
[  247.097974]  [<ffffffff810493ac>] ? warn_slowpath_null+0x1a/0x1c
[  247.103974]  [<ffffffff810ccf8a>] ? __alloc_pages_slowpath+0x54/0x3c5
[  247.110409]  [<ffffffff810ccae2>] ? get_page_from_freelist+0x166/0x198
[  247.116928]  [<ffffffff810cd3c5>] ? __alloc_pages_nodemask+0xca/0xf4
[  247.123297]  [<ffffffffa0702884>] ? unmap_extent_buffer+0x11/0x13 [btrfs]
[  247.130079]  [<ffffffff810fd957>] ? alloc_pages_current+0xa3/0xac
[  247.136166]  [<ffffffff810cc5f7>] ? alloc_pages+0xe/0x10
[  247.141472]  [<ffffffff810cc607>] ? __get_free_pages+0xe/0x4b
[  247.147218]  [<ffffffff811061eb>] ? kmalloc_order_trace+0x27/0x55
[  247.153304]  [<ffffffff8110664e>] ? __kmalloc+0x37/0x100
[  247.158625]  [<ffffffffa072622a>] ? btrfs_batch_insert_items+0xe0/0x229 [btrfs]
[  247.165933]  [<ffffffffa06d454b>] ? btrfs_block_rsv_release+0x39/0x3b [btrfs]
[  247.173072]  [<ffffffffa07265e7>] ? btrfs_insert_delayed_items+0xac/0xef [btrfs]
[  247.180472]  [<ffffffffa0726798>] ? btrfs_run_delayed_items+0x68/0xd9 [btrfs]
[  247.187610]  [<ffffffffa06e85fc>] ? btrfs_commit_transaction+0x266/0x5c9 [btrfs]
[  247.195000]  [<ffffffff81066118>] ? list_del_init+0x21/0x21
[  247.200583]  [<ffffffffa0710c4c>] ? create_subvol+0x420/0x440 [btrfs]
[  247.207018]  [<ffffffff810362ec>] ? need_resched+0x23/0x2d
[  247.212511]  [<ffffffffa0710d7a>] ? btrfs_mksubvol+0x10e/0x167 [btrfs]
[  247.219043]  [<ffffffffa071129f>] ? btrfs_ioctl_snap_create_transid+0x9c/0x121 [btrfs]
[  247.226962]  [<ffffffffa071145e>] ? btrfs_ioctl_snap_create+0x50/0x67 [btrfs]
[  247.234101]  [<ffffffffa0712c5a>] ? btrfs_ioctl+0x1d0/0x2c6 [btrfs]
[  247.240364]  [<ffffffff8111fe12>] ? vfs_ioctl+0x1d/0x34
[  247.245582]  [<ffffffff8112048d>] ? do_vfs_ioctl+0x171/0x17a
[  247.251242]  [<ffffffff811130a2>] ? fget_light+0x69/0x81
[  247.256549]  [<ffffffff811204f2>] ? sys_ioctl+0x5c/0x7c
[  247.261770]  [<ffffffff8111d48d>] ? putname+0x33/0x37
[  247.266819]  [<ffffffff813b21eb>] ? system_call_fastpath+0x16/0x1b
[  247.272993] ---[ end trace 9c75d74017f060f5 ]---

The mkcephfs command I was attempting succeeded, so I'm
not sure if the above matters; mm/page_alloc.c:2032 is

	/*
	 * In the slowpath, we sanity check order to avoid ever trying to
	 * reclaim >= MAX_ORDER areas which will never succeed. Callers may
	 * be using allocators in order of preference for an area that is
	 * too large.
	 */
	if (order >= MAX_ORDER) {
		WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
		return NULL;
	}

When I did my bisection, my criteria for success/failure was
"did mkcephfs succeed?".  When I apply this criteria to a recent
linus kernel (e.g. 06e86849cf4019), which includes the fix you
mentioned (aa0467d8d2a00e), I get still a different failure mode,
which doesn't actually reference btrfs:

[  276.364178] BUG: unable to handle kernel NULL pointer dereference at 000000000000000a
[  276.365127] IP: [<ffffffffa05434b1>] journal_start+0x3e/0x9c [jbd]
[  276.365127] PGD 1e4469067 PUD 1e1658067 PMD 0
[  276.365127] Oops: 0000 [#1] SMP
[  276.365127] CPU 2
[  276.365127] Modules linked in: btrfs zlib_deflate lzo_compress ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp i2c_dev i2c_core ext3 jbd scsi_transport_iscsi rds ib_ipoib rdma_ucm rdma_cm ib_ucm ib_uverbs ib_umad ib_cm iw_cm ib_addr ipv6 ib_sa dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod video sbs sbshc pci_slot battery acpi_pad ac kvm sg ses sd_mod enclosure megaraid_sas ide_cd_mod cdrom ib_mthca ib_mad qla2xxx button ib_core serio_raw scsi_transport_fc scsi_tgt dcdbas ata_piix libata tpm_tis tpm i5k_amb ioatdma tpm_bios hwmon iTCO_wdt scsi_mod i5000_edac iTCO_vendor_support ehci_hcd dca edac_core uhci_hcd pcspkr rtc nfs nfs_acl auth_rpcgss fscache lockd sunrpc tg3 
 bnx2 e1000 [last unloaded: freq_table]
[  276.365127]
[  276.365127] Pid: 6076, comm: cosd Not tainted 3.0.0-rc2-00196-g06e8684 #26 Dell Inc. PowerEdge 1950/0DT097
[  276.365127] RIP: 0010:[<ffffffffa05434b1>]  [<ffffffffa05434b1>] journal_start+0x3e/0x9c [jbd]
[  276.365127] RSP: 0018:ffff8801e2897b28  EFLAGS: 00010286
[  276.365127] RAX: 000000000000000a RBX: ffff8801de8e1090 RCX: 0000000000000002
[  276.365127] RDX: 0000000019b2d000 RSI: 000000000000000e RDI: 000000000000000e
[  276.365127] RBP: ffff8801e2897b48 R08: 0000000000000003 R09: ffff8801e2897c38
[  276.365127] R10: ffff8801e2897ed8 R11: 0000000000000001 R12: ffff880223ff4400
[  276.365127] R13: ffff880218522d60 R14: 0000000000000ec6 R15: ffff88021f54d878
[  276.365127] FS:  00007f8ff0bbb710(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
[  276.365127] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  276.365127] CR2: 000000000000000a CR3: 000000021744f000 CR4: 00000000000006e0
[  276.365127] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  276.365127] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  276.365127] Process cosd (pid: 6076, threadinfo ffff8801e2896000, task ffff880218522d60)
[  276.365127] Stack:
[  276.365127]  ffff8801e2897b68 ffffea000756e788 ffff88021f54d728 ffff8801e2897c78
[  276.365127]  ffff8801e2897b58 ffffffffa05670ce ffff8801e2897b68 ffffffffa055c72d
[  276.365127]  ffff8801e2897be8 ffffffffa055f044 ffff8801e2897c38 0000007400000000
[  276.365127] Call Trace:
[  276.365127]  [<ffffffffa05670ce>] ext3_journal_start_sb+0x4f/0x51 [ext3]
[  276.365127]  [<ffffffffa055c72d>] ext3_journal_start+0x12/0x14 [ext3]
[  276.365127]  [<ffffffffa055f044>] ext3_write_begin+0x93/0x1a1 [ext3]
[  276.365127]  [<ffffffff810c6f0e>] ? __kunmap_atomic+0xe/0x10
[  276.365127]  [<ffffffff810c75e5>] generic_perform_write+0xb1/0x172
[  276.365127]  [<ffffffff81036a33>] ? need_resched+0x23/0x2d
[  276.365127]  [<ffffffff810c76ea>] generic_file_buffered_write+0x44/0x6f
[  276.365127]  [<ffffffff810c91f5>] __generic_file_aio_write+0x253/0x2a8
[  276.365127]  [<ffffffff810c92ad>] generic_file_aio_write+0x63/0xb8
[  276.365127]  [<ffffffff81113b26>] do_sync_write+0xc7/0x10b
[  276.365127]  [<ffffffff81036a4b>] ? should_resched+0xe/0x2f
[  276.365127]  [<ffffffff813b0faf>] ? _cond_resched+0xe/0x22
[  276.365127]  [<ffffffff811986c3>] ? security_file_permission+0x2c/0x31
[  276.365127]  [<ffffffff81113d21>] ? rw_verify_area+0xac/0xdb
[  276.365127]  [<ffffffff81114253>] vfs_write+0xac/0xe4
[  276.365127]  [<ffffffff8111434f>] sys_write+0x4c/0x71
[  276.365127]  [<ffffffff813b8beb>] system_call_fastpath+0x16/0x1b
[  276.365127] Code: 89 fc 48 c7 c3 e2 ff ff ff 89 f7 65 4c 8b 2c 25 c0 b5 00 00 4d 85 e4 49 8b 85 48 06 00 00 74 5e 48 85 c0 74 14 48 89 c3 48 8b 00 <4c> 39 20 74 04 0f 0b eb fe ff 43 0c eb 45 e8 70 ff ff ff 48 85
[  276.365127] RIP  [<ffffffffa05434b1>] journal_start+0x3e/0x9c [jbd]
[  276.365127]  RSP <ffff8801e2897b28>
[  276.365127] CR2: 000000000000000a
[  276.725157] ---[ end trace 8a802dc03e3972ad ]---


My ceph OSDs are using btrfs for data, but the cosd process
is logging debug info to an ext3 filesystem, so when I bisected
"mkcephfs fails" to commit 16cdcec736cd21, I assumed it was the
root cause of the above.

What else do I need to do to help sort this out?

-- Jim

> 
> 
> On Thu, Jun 09, 2011 at 03:52:43PM -0600, Jim Schutt wrote:
>> Hi,
>>
>> I've run into the following BUG on 3.0-rcX kernels when
>> running mkcephfs:
>>
>> Jun  9 15:14:50 an1 [  299.446615] ------------[ cut here ]------------
>> Jun  9 15:14:50 an1 [  299.447357] kernel BUG at fs/btrfs/ioctl.c:432!
> 
> ioctl.c:
>  431         ret = btrfs_update_inode(trans, root, dir);
>  432         BUG_ON(ret);
> 
>> Jun  9 15:14:50 an1 [  299.447357] RSP: 0018:ffff88021b163c48  EFLAGS: 00010206
>> Jun  9 15:14:50 an1 [  299.447357] RAX: 0000000019b201a0 RBX: ffff88022402d800 RCX: ffff88019206c028
>                                           ^^^^^^^^^^^^^^^^
> ret, which seems to contain value of delayed_node from previous return value
> (deduced from assembly):
> 
> delayed-node.c:
> 1600         delayed_node = btrfs_get_or_create_delayed_node(inode);
> 1601         if (IS_ERR(delayed_node))
> 1602                 return PTR_ERR(delayed_node);
> 
> 
>> Please let me know what other information I can provide, or
>> any testing I can do, that will help to resolve this issue.
> 
> thanks, I think the stacktrace contains everything important. I was trying to
> trigger the bugon myself when the report arrived, but did not succeed. the
> issue is quite recent and seeing this report was a "cache" hit :)
> 
> Note: there are two more possibilities to hit the bugon in the ioctl: ENOMEM
> and ENOENT being retunred from btrfs_update_inode, but the symptoms fit the
> case described above.
> 
> 
> david
> 
> 


