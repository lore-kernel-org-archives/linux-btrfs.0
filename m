From: Jim Schutt <jaschut@sandia.gov>
Subject: Re: WARNING: at fs/btrfs/inode.c:2193 btrfs_orphan_commit_root+0xb0/0xc0
 [btrfs]()
Date: Fri, 16 Sep 2011 10:25:51 -0600
Message-ID: <4E73788F.3060906@sandia.gov>
References: <4E6BDAEB.7020206@tuxadero.com> <4E6EABAF.9010903@cn.fujitsu.com> <Pine.LNX.4.64.1109151137420.17623@cobra.newdream.net> <20110915195556.GI22205@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Cc: Sage Weil <sage@newdream.net>, Liu Bo <liubo2009@cn.fujitsu.com>,
	<martin@tuxadero.com>, <ceph-devel@vger.kernel.org>,
	<linux-btrfs@vger.kernel.org>, <josef@redhat.com>
To: <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110915195556.GI22205@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:
> On Thu, Sep 15, 2011 at 11:44:09AM -0700, Sage Weil wrote:
>> On Tue, 13 Sep 2011, Liu Bo wrote:
>>> On 09/11/2011 05:47 AM, Martin Mailand wrote:
>>>> Hi
>>>> I am hitting this Warning reproducible, the workload is a ceph osd,
>>>> kernel ist 3.1.0-rc5.
>>>>
>>> Have posted a patch for this:
>>>
>>> http://marc.info/?l=linux-btrfs&m=131547325515336&w=2
>> We're still seeing this with -rc6, which includes 98c9942 and 65450aa.
> 
> Me too, for the 
> 
> WARNING: at fs/btrfs/extent-tree.c:5711 btrfs_alloc_free_block+0x180/0x350 [btrfs]()
> 

FWIW, I'm seeing a slightly different case, while testing branch
integration/btrfs-next (commit 2828cbd9620e03) from
git://repo.or.cz/linux-2.6/btrfs-unstable.git merged into branch
master (commit c455ea4f122d21) from git://github.com/torvalds/linux.git

Under a heavy ceph write load, I see lots of these:

[ 2369.797044] ------------[ cut here ]------------
[ 2369.801759] WARNING: at fs/btrfs/extent-tree.c:5751 use_block_rsv+0x177/0x180 [btrfs]()
[ 2369.809864] Hardware name: X8DTH-i/6/iF/6F
[ 2369.814062] Modules linked in: loop btrfs zlib_deflate lzo_compress ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
[ 2369.828671] btrfs: journal_info set but trans not join/nolock: 0x1
[ 2369.829040]  ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp scsi_transport_iscsi rds ib_ipoib rdma_ucm rdma_cm ib_ucm ib_uverbs ib_umad ib_cm iw_cm ib_addr ipv6 ib_sa dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod video sbs sbshc pci_slot battery acpi_pad ac kvm sg sd_mod mlx4_ib ib_mad ib_core mlx4_en joydev mpt2sas tpm_tis tpm scsi_transport_sas mlx4_core cxgb4 button serio_raw raid_class tpm_bios ata_piix libata scsi_mod i2c_i801 ioatdma ehci_hcd iTCO_wdt uhci_hcd i2c_core i7core_edac iTCO_vendor_support edac_core pcspkr rtc nfs nfs_acl auth_rpcgss fscache lockd sunrpc tg3 bnx2 igb dca e1000
[ 2369.889908] Pid: 23744, comm: kworker/19:3 Tainted: G        W   3.1.0-rc6-00265-gf883c8c #33
[ 2369.898510] Call Trace:
[ 2369.901026]  [<ffffffff8104e02f>] warn_slowpath_common+0x7f/0xc0
[ 2369.907046]  [<ffffffff8104e08a>] warn_slowpath_null+0x1a/0x20
[ 2369.912935]  [<ffffffffa05c7fb7>] use_block_rsv+0x177/0x180 [btrfs]
[ 2369.919422]  [<ffffffffa05d122d>] btrfs_alloc_free_block+0x3d/0x220 [btrfs]
[ 2369.926431]  [<ffffffff810f1a01>] ? __set_page_dirty_nobuffers+0xe1/0x150
[ 2369.933265]  [<ffffffffa05ff3c1>] ? read_extent_buffer+0xc1/0x1a0 [btrfs]
[ 2369.940085]  [<ffffffffa05bf58e>] __btrfs_cow_block+0x11e/0x4d0 [btrfs]
[ 2369.946737]  [<ffffffffa0610091>] ? btrfs_tree_lock+0x161/0x2c0 [btrfs]
[ 2369.953391]  [<ffffffffa05bfefa>] btrfs_cow_block+0xea/0x200 [btrfs]
[ 2369.959756]  [<ffffffffa05c2b2f>] btrfs_search_slot+0x31f/0x720 [btrfs]
[ 2369.966362]  [<ffffffffa05d3a9b>] btrfs_del_csums+0x23b/0x320 [btrfs]
[ 2369.972833]  [<ffffffffa05cf41b>] __btrfs_free_extent+0x49b/0x720 [btrfs]
[ 2369.979660]  [<ffffffffa05cf969>] run_delayed_data_ref+0x159/0x160 [btrfs]
[ 2369.986591]  [<ffffffffa05cfa20>] run_one_delayed_ref+0xb0/0xd0 [btrfs]
[ 2369.993257]  [<ffffffffa05cfb0f>] run_clustered_refs+0xcf/0x240 [btrfs]
[ 2369.999928]  [<ffffffffa05cfd58>] btrfs_run_delayed_refs+0xd8/0x260 [btrfs]
[ 2370.006937]  [<ffffffffa05dde77>] btrfs_commit_transaction+0x87/0x8b0 [btrfs]
[ 2370.014238]  [<ffffffff81072930>] ? wake_up_bit+0x40/0x40
[ 2370.019710]  [<ffffffffa05de6a0>] ? btrfs_commit_transaction+0x8b0/0x8b0 [btrfs]
[ 2370.027180]  [<ffffffffa05de6bf>] do_async_commit+0x1f/0x30 [btrfs]
[ 2370.033578]  [<ffffffffa05de6a0>] ? btrfs_commit_transaction+0x8b0/0x8b0 [btrfs]
[ 2370.041039]  [<ffffffff8106c03f>] process_one_work+0x13f/0x490
[ 2370.046950]  [<ffffffff8106ddb7>] worker_thread+0x187/0x3e0
[ 2370.052679]  [<ffffffff8106dc30>] ? manage_workers+0x120/0x120
[ 2370.058682]  [<ffffffff810723a6>] kthread+0x96/0xa0
[ 2370.063690]  [<ffffffff8145c7f4>] kernel_thread_helper+0x4/0x10
[ 2370.069695]  [<ffffffff8145284a>] ? retint_restore_args+0xe/0xe
[ 2370.075720]  [<ffffffff81072310>] ? kthread_worker_fn+0x1d0/0x1d0
[ 2370.081919]  [<ffffffff8145c7f0>] ? gs_change+0xb/0xb
[ 2370.087103] ---[ end trace a6d5cd679d4e46b9 ]---


I don't know if it matters, but I also see lots of this sort of thing:

[ 2370.131721] btrfs: all snaps cleaned
[ 2370.241382] btrfs: btrfs_clean_old_snapshots to process 1 old snaps
[ 2370.275303] btrfs: btrfs_clean_old_snapshots to process 0 old snaps
[ 2370.275306] btrfs: all snaps cleaned
[ 2370.296461] btrfs: all snaps cleaned
[ 2370.639211] btrfs: btrfs_clean_old_snapshots to process 1 old snaps
[ 2370.688785] btrfs: all snaps cleaned
[ 2370.811568] btrfs: journal_info set but trans not join/nolock: 0x1
[ 2370.830958] btrfs: btrfs_clean_old_snapshots to process 0 old snaps
[ 2370.830962] btrfs: all snaps cleaned
[ 2371.040634] btrfs: journal_info set but trans not join/nolock: 0x1
[ 2371.057286] btrfs: journal_info set but trans not join/nolock: 0x1
[ 2371.267641] btrfs: btrfs_clean_old_snapshots to process 1 old snaps
[ 2371.285724] btrfs: journal_info set but trans not join/nolock: 0x1
[ 2371.301746] btrfs: journal_info set but trans not join/nolock: 0x1
[ 2371.328422] btrfs: all snaps cleaned
[ 2371.371326] btrfs: btrfs_clean_old_snapshots to process 1 old snaps
[ 2371.417955] btrfs: all snaps cleaned
[ 2371.498012] btrfs: btrfs_clean_old_snapshots to process 1 old snaps
[ 2371.530904] btrfs: btrfs_clean_old_snapshots to process 0 old snaps
[ 2371.530906] btrfs: all snaps cleaned
[ 2371.553309] btrfs: all snaps cleaned
[ 2371.574753] btrfs: btrfs_clean_old_snapshots to process 1 old snaps
[ 2371.625655] btrfs: all snaps cleaned

-- Jim

> 
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

