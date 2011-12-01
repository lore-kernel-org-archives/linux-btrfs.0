From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] fix bugs of sub transid -- WARNING: at fs/btrfs/ctree.c:432
Date: Thu, 01 Dec 2011 09:32:19 +0800
Message-ID: <4ED6D923.9010805@cn.fujitsu.com>
References: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com> <20111128151030.GK12759@twin.jikos.cz> <4ED432EB.2070706@cn.fujitsu.com> <20111129161729.GM12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: David Sterba <dave@jikos.cz>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, sensille@gmx.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111129161729.GM12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/30/2011 12:17 AM, David Sterba wrote:
> On Tue, Nov 29, 2011 at 09:18:35AM +0800, Liu Bo wrote:
>> a) For the first one (last_snapshot bug),
>>
>> The test involves three processes (derived from Chris):
>>
>> mkfs.btrfs /dev/xxx
>> mount /dev/xxx /mnt
>>
>> 1) run compilebench -i 30 --makej -D /mnt
>>
>> Let compilebench run until it starts the create phase.
>>
>> 2) run synctest -f -u -n 200 -t 3 /mnt
>> 3) for x in `seq 1 200` ; do btrfs subvol snap /mnt /mnt/snap$x ; sleep 0.5 ; done
> 
> I have hit following 2 warnings during this test. Phase 1 was at compile
> stage, 2 and 3 were running. I did not see them during first run and other
> activity at the filestystem was 'du -sh /mnt'.
> 
> mount options: compress-force=lzo,discard,space_cache,autodefrag,inode_cache
> 
> Label: none  uuid: 79f4160b-81f8-46ed-968c-968cb17a2e87
>         Total devices 4 FS bytes used 7.76GB
>         devid    4 size 13.96GB used 2.26GB path /dev/sdb4
>         devid    3 size 13.96GB used 2.26GB path /dev/sdb3
>         devid    2 size 13.96GB used 3.00GB path /dev/sdb2
>         devid    1 size 13.96GB used 3.02GB path /dev/sdb1
> 
> fresh and default mkfs
> 
>  430         WARN_ON(root->ref_cows && trans->transaction->transid !=
>  431                 root->fs_info->running_transaction->transid);
>  432         WARN_ON(root->ref_cows && trans->transid < root->last_trans);
> 

Hi, David,

This should be a miss from me.

The warning is aimed to check whether this ref_cow root is in this transaction, so we can change it
to WARN_ON(root->ref_cows && trans->transaction->transid > root->last_trans);

BTW, did you catch any "parent transid mismatch" during the test? :)

thanks,
liubo

> 
> 20433.473713] ------------[ cut here ]------------
> [20433.478825] WARNING: at fs/btrfs/ctree.c:432 __btrfs_cow_block+0x429/0x5e0 [btrfs]()
> [20433.487148] Hardware name: Santa Rosa platform
> [20433.487150] Modules linked in: btrfs aoe sr_mod ide_cd_mod cdrom loop [last unloaded: btrfs]
> [20433.487162] Pid: 12099, comm: btrfs Tainted: G        W   3.1.0-default+ #80
> [20433.487165] Call Trace:
> [20433.487174]  [<ffffffff81051c0f>] warn_slowpath_common+0x7f/0xc0
> [20433.487179]  [<ffffffff81051c6a>] warn_slowpath_null+0x1a/0x20
> [20433.487190]  [<ffffffffa00d6909>] __btrfs_cow_block+0x429/0x5e0 [btrfs]
> [20433.487196]  [<ffffffff8108a429>] ? trace_hardirqs_off_caller+0x29/0xc0
> [20433.487201]  [<ffffffff8108a7ed>] ? lock_release_holdtime+0x3d/0x1c0
> [20433.487218]  [<ffffffffa0129cc0>] ? btrfs_set_lock_blocking_rw+0x50/0xb0 [btrfs]
> [20433.487230]  [<ffffffffa00d6c66>] btrfs_cow_block+0x1a6/0x3d0 [btrfs]
> [20433.487236]  [<ffffffff818b90cb>] ? _raw_write_unlock+0x2b/0x50
> [20433.487247]  [<ffffffffa00dae70>] btrfs_search_slot+0x300/0xd20 [btrfs]
> [20433.487262]  [<ffffffffa00eedcf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
> [20433.487279]  [<ffffffffa00fd186>] btrfs_update_inode_item+0x66/0x120 [btrfs]
> [20433.487296]  [<ffffffffa00fe63b>] btrfs_update_inode+0xab/0xc0 [btrfs]
> [20433.487313]  [<ffffffffa0134e61>] ? lookup_free_ino_inode+0x51/0xe0 [btrfs]
> [20433.487327]  [<ffffffffa00ef515>] btrfs_save_ino_cache+0x145/0x2f0 [btrfs]
> [20433.487342]  [<ffffffffa00f7464>] ? commit_fs_roots+0xa4/0x1c0 [btrfs]
> [20433.487357]  [<ffffffffa00f7494>] commit_fs_roots+0xd4/0x1c0 [btrfs]
> [20433.487373]  [<ffffffffa00f86a4>] btrfs_commit_transaction+0x454/0x900 [btrfs]
> [20433.487378]  [<ffffffff8108a7ed>] ? lock_release_holdtime+0x3d/0x1c0
> [20433.487395]  [<ffffffffa0126e08>] ? btrfs_mksubvol+0x298/0x360 [btrfs]
> [20433.487400]  [<ffffffff81076550>] ? wake_up_bit+0x40/0x40
> [20433.487405]  [<ffffffff8134738e>] ? do_raw_spin_unlock+0x5e/0xb0
> [20433.487421]  [<ffffffffa0126ec8>] btrfs_mksubvol+0x358/0x360 [btrfs]
> [20433.487427]  [<ffffffff8110ece3>] ? might_fault+0x53/0xb0
> [20433.487443]  [<ffffffffa0126fd0>] btrfs_ioctl_snap_create_transid+0x100/0x160 [btrfs]
> [20433.487448]  [<ffffffff8110ece3>] ? might_fault+0x53/0xb0
> [20433.487464]  [<ffffffffa01271ad>] btrfs_ioctl_snap_create_v2.clone.0+0xfd/0x110 [btrfs]
> [20433.487482]  [<ffffffffa0128a78>] btrfs_ioctl+0x588/0x1080 [btrfs]
> [20433.487487]  [<ffffffff818bd9c0>] ? do_page_fault+0x2d0/0x580
> [20433.487492]  [<ffffffff8107d6cf>] ? local_clock+0x6f/0x80
> [20433.487498]  [<ffffffff811473e8>] do_vfs_ioctl+0x98/0x560
> [20433.487502]  [<ffffffff818b9fd9>] ? retint_swapgs+0x13/0x1b
> [20433.487507]  [<ffffffff811478ff>] sys_ioctl+0x4f/0x80
> [20433.487512]  [<ffffffff818c21c2>] system_call_fastpath+0x16/0x1b
> [20433.487515] ---[ end trace d93007cf8d0a8eac ]---
> [20433.487576] ------------[ cut here ]------------
> [20433.487587] WARNING: at fs/btrfs/ctree.c:432 __btrfs_cow_block+0x429/0x5e0 [btrfs]()
> [20433.487590] Hardware name: Santa Rosa platform
> [20433.487592] Modules linked in: btrfs aoe sr_mod ide_cd_mod cdrom loop [last unloaded: btrfs]
> [20433.487601] Pid: 12099, comm: btrfs Tainted: G        W   3.1.0-default+ #80
> [20433.487603] Call Trace:
> [20433.487608]  [<ffffffff81051c0f>] warn_slowpath_common+0x7f/0xc0
> [20433.487613]  [<ffffffff81051c6a>] warn_slowpath_null+0x1a/0x20
> [20433.487623]  [<ffffffffa00d6909>] __btrfs_cow_block+0x429/0x5e0 [btrfs]
> [20433.487628]  [<ffffffff8108a429>] ? trace_hardirqs_off_caller+0x29/0xc0
> [20433.487633]  [<ffffffff8108a7ed>] ? lock_release_holdtime+0x3d/0x1c0
> [20433.487649]  [<ffffffffa0129cc0>] ? btrfs_set_lock_blocking_rw+0x50/0xb0 [btrfs]
> [20433.487660]  [<ffffffffa00d6c66>] btrfs_cow_block+0x1a6/0x3d0 [btrfs]
> [20433.487665]  [<ffffffff818b90cb>] ? _raw_write_unlock+0x2b/0x50
> [20433.487676]  [<ffffffffa00dae70>] btrfs_search_slot+0x300/0xd20 [btrfs]
> [20433.487691]  [<ffffffffa00eedcf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
> [20433.487707]  [<ffffffffa00fd186>] btrfs_update_inode_item+0x66/0x120 [btrfs]
> [20433.487723]  [<ffffffffa00fe63b>] btrfs_update_inode+0xab/0xc0 [btrfs]
> [20433.487739]  [<ffffffffa0134e61>] ? lookup_free_ino_inode+0x51/0xe0 [btrfs]
> [20433.487753]  [<ffffffffa00ef515>] btrfs_save_ino_cache+0x145/0x2f0 [btrfs]
> [20433.487769]  [<ffffffffa00f7464>] ? commit_fs_roots+0xa4/0x1c0 [btrfs]
> [20433.487784]  [<ffffffffa00f7494>] commit_fs_roots+0xd4/0x1c0 [btrfs]
> [20433.487800]  [<ffffffffa00f86a4>] btrfs_commit_transaction+0x454/0x900 [btrfs]
> [20433.487805]  [<ffffffff8108a7ed>] ? lock_release_holdtime+0x3d/0x1c0
> [20433.487821]  [<ffffffffa0126e08>] ? btrfs_mksubvol+0x298/0x360 [btrfs]
> [20433.487826]  [<ffffffff81076550>] ? wake_up_bit+0x40/0x40
> [20433.487830]  [<ffffffff8134738e>] ? do_raw_spin_unlock+0x5e/0xb0
> [20433.487846]  [<ffffffffa0126ec8>] btrfs_mksubvol+0x358/0x360 [btrfs]
> [20433.487851]  [<ffffffff8110ece3>] ? might_fault+0x53/0xb0
> [20433.487867]  [<ffffffffa0126fd0>] btrfs_ioctl_snap_create_transid+0x100/0x160 [btrfs]
> [20433.487872]  [<ffffffff8110ece3>] ? might_fault+0x53/0xb0
> [20433.487888]  [<ffffffffa01271ad>] btrfs_ioctl_snap_create_v2.clone.0+0xfd/0x110 [btrfs]
> [20433.487905]  [<ffffffffa0128a78>] btrfs_ioctl+0x588/0x1080 [btrfs]
> [20433.487909]  [<ffffffff818bd9c0>] ? do_page_fault+0x2d0/0x580
> [20433.487913]  [<ffffffff8107d6cf>] ? local_clock+0x6f/0x80
> [20433.487918]  [<ffffffff811473e8>] do_vfs_ioctl+0x98/0x560
> [20433.487922]  [<ffffffff818b9fd9>] ? retint_swapgs+0x13/0x1b
> [20433.487926]  [<ffffffff811478ff>] sys_ioctl+0x4f/0x80
> [20433.487931]  [<ffffffff818c21c2>] system_call_fastpath+0x16/0x1b
> [20433.487934] ---[ end trace d93007cf8d0a8ead ]---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

