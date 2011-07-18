From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: don't be as agressive with delalloc metadata reservations
Date: Mon, 18 Jul 2011 09:33:35 -0400
Message-ID: <4E24362F.5030909@redhat.com>
References: <1310754551-30924-1-git-send-email-josef@redhat.com> <4E23A2AD.8030901@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E23A2AD.8030901@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/17/2011 11:04 PM, liubo wrote:
> On 07/16/2011 02:29 AM, Josef Bacik wrote:
>> Currently we reserve enough space to COW an entirely full btree for every extent
>> we have reserved for an inode.  This _sucks_, because you only need to COW once,
>> and then everybody else is ok.  Unfortunately we don't know we'll all be able to
>> get into the same transaction so that's what we have had to do.  But the global
>> reserve holds a reservation large enough to cover a large percentage of all the
>> metadata currently in the fs.  So all we really need to account for is any new
>> blocks that we may allocate.  So fix this by
>>
>> 1) Passing to btrfs_alloc_free_block() wether this is a new block or a COW
>> block.  If it is a COW block we use the global reserve, if not we use the
>> trans->block_rsv.
>> 2) Reduce the amount of space we reserve.  Since we don't need to account for
>> cow'ing the tree we can just keep track of new blocks to reserve, which greatly
>> reduces the reservation amount.
>>
>> This makes my basic random write test go from 3 mb/s to 75 mb/s.  I've tested
>> this with my horrible ENOSPC test and it seems to work out fine.  Thanks,
>>
> 
> Hi, Josef,
> 
> After I patched this and did a "tar xf source.tar", I got lots of warnings,
> 
> Would you like to look into this?
> 
> ------------[ cut here ]------------
> WARNING: at fs/btrfs/extent-tree.c:5695 btrfs_alloc_free_block+0x178/0x340 [btrfs]()
> Hardware name: QiTianM7150
> Modules linked in: btrfs iptable_nat nf_nat zlib_deflate libcrc32c ebtable_nat ebtables bridge stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libcxgbi cxgb3 mdio iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd dm_mirror dm_region_hash dm_log dm_mod sg ppdev serio_raw pcspkr i2c_i801 iTCO_wdt iTCO_vendor_support sky2 parport_pc parport ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi ata_generic ata_piix i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: btrfs]
> Pid: 16008, comm: umount Tainted: G        W   2.6.39+ #9
> Call Trace:
>  [<ffffffff81053baf>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff81053c0a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffffa04d37d8>] btrfs_alloc_free_block+0x178/0x340 [btrfs]
>  [<ffffffffa0501768>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
>  [<ffffffffa04be625>] __btrfs_cow_block+0x155/0x5f0 [btrfs]
>  [<ffffffffa04bebcb>] btrfs_cow_block+0x10b/0x240 [btrfs]
>  [<ffffffffa04c4c8e>] btrfs_search_slot+0x49e/0x7a0 [btrfs]
>  [<ffffffffa04d2399>] btrfs_write_dirty_block_groups+0x1a9/0x4d0 [btrfs]
>  [<ffffffffa0512e20>] ? btrfs_tree_unlock+0x50/0x50 [btrfs]
>  [<ffffffffa04df845>] commit_cowonly_roots+0x105/0x1e0 [btrfs]
>  [<ffffffffa04e0708>] btrfs_commit_transaction+0x428/0x850 [btrfs]
>  [<ffffffffa04df9b8>] ? wait_current_trans+0x28/0x100 [btrfs]
>  [<ffffffffa04e0c25>] ? join_transaction+0x25/0x250 [btrfs]
>  [<ffffffff81075590>] ? wake_up_bit+0x40/0x40
>  [<ffffffffa04bb187>] btrfs_sync_fs+0x67/0xd0 [btrfs]
>  [<ffffffff8116c27e>] __sync_filesystem+0x5e/0x90
>  [<ffffffff8116c38b>] sync_filesystem+0x4b/0x70
>  [<ffffffff811441c4>] generic_shutdown_super+0x34/0xf0
>  [<ffffffff81144316>] kill_anon_super+0x16/0x60
>  [<ffffffff81144a25>] deactivate_locked_super+0x45/0x70
>  [<ffffffff8114568a>] deactivate_super+0x4a/0x70
>  [<ffffffff8115efdc>] mntput_no_expire+0x13c/0x1c0
>  [<ffffffff8115f7bb>] sys_umount+0x7b/0x3a0
>  [<ffffffff81466b2b>] system_call_fastpath+0x16/0x1b
> ---[ end trace 9a65800674b03b84 ]---
> 

Hmm, not reserving enough room for the chunk tree it seems, or I screwed
something up and we're not using the right reserve.  I will look into
this, thanks,

Josef
