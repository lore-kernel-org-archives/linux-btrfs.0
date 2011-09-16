From: Martin Mailand <martin@tuxadero.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2193 btrfs_orphan_commit_root+0xb0/0xc0
 [btrfs]()
Date: Fri, 16 Sep 2011 16:09:26 +0200
Message-ID: <4E735896.3000608@tuxadero.com>
References: <4E6BDAEB.7020206@tuxadero.com> <4E6EABAF.9010903@cn.fujitsu.com> <Pine.LNX.4.64.1109151137420.17623@cobra.newdream.net> <20110915195029.GD25179@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Sage Weil <sage@newdream.net>, Liu Bo <liubo2009@cn.fujitsu.com>,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20110915195029.GD25179@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
after a quick test it seems that I do not hit this Warning any longer.
But I got a new one.

[ 5241.839951] ------------[ cut here ]------------
[ 5241.839974] WARNING: at fs/btrfs/extent-tree.c:5715 
btrfs_alloc_free_block+0xac/0x330 [btrfs]()
[ 5241.839979] Hardware name: MS-96B3
[ 5241.839982] Modules linked in: radeon ttm drm_kms_helper drm 
i2c_algo_bit psmouse k8temp sp5100_tco edac_core edac_mce_amd serio_raw 
shpchp i2c_piix4 lp parport ahci pata_atiixp libahci btrfs e1000e 
zlib_deflate libcrc32c
[ 5241.840068] Pid: 1568, comm: kworker/0:1 Tainted: G        W 
3.1.0-rc6 #1
[ 5241.840072] Call Trace:
[ 5241.840084]  [<ffffffff81063d0f>] warn_slowpath_common+0x7f/0xc0
[ 5241.840101]  [<ffffffff81063d6a>] warn_slowpath_null+0x1a/0x20
[ 5241.840133]  [<ffffffffa002a9cc>] btrfs_alloc_free_block+0xac/0x330 
[btrfs]
[ 5241.840152]  [<ffffffff8110d35a>] ? unlock_page+0x2a/0x40
[ 5241.840188]  [<ffffffffa0059268>] ? read_extent_buffer+0xa8/0x180 [btrfs]
[ 5241.840222]  [<ffffffffa0031c00>] ? verify_parent_transid+0x160/0x160 
[btrfs]
[ 5241.840252]  [<ffffffffa001a0d2>] __btrfs_cow_block+0x122/0x4b0 [btrfs]
[ 5241.840283]  [<ffffffffa001a552>] btrfs_cow_block+0xf2/0x1f0 [btrfs]
[ 5241.840314]  [<ffffffffa001cb88>] push_leaf_left+0x108/0x180 [btrfs]
[ 5241.840344]  [<ffffffffa001fb78>] btrfs_del_items+0x2b8/0x440 [btrfs]
[ 5241.840379]  [<ffffffffa00300c2>] btrfs_del_csums+0x2d2/0x310 [btrfs]
[ 5241.840415]  [<ffffffffa00677a8>] ? btrfs_tree_unlock+0x28/0xb0 [btrfs]
[ 5241.840447]  [<ffffffffa002597a>] __btrfs_free_extent+0x48a/0x6f0 [btrfs]
[ 5241.840480]  [<ffffffffa0028c8d>] run_clustered_refs+0x21d/0x840 [btrfs]
[ 5241.840514]  [<ffffffffa002937a>] btrfs_run_delayed_refs+0xca/0x220 
[btrfs]
[ 5241.840551]  [<ffffffffa0053576>] ? 
btrfs_run_ordered_operations+0x1d6/0x200 [btrfs]
[ 5241.840587]  [<ffffffffa0038fa3>] btrfs_commit_transaction+0x83/0x870 
[btrfs]
[ 5241.840605]  [<ffffffff81012871>] ? __switch_to+0x261/0x2f0
[ 5241.840622]  [<ffffffff81086d70>] ? wake_up_bit+0x40/0x40
[ 5241.840656]  [<ffffffffa0039790>] ? 
btrfs_commit_transaction+0x870/0x870 [btrfs]
[ 5241.840691]  [<ffffffffa00397af>] do_async_commit+0x1f/0x30 [btrfs]
[ 5241.840708]  [<ffffffff8108110d>] process_one_work+0x11d/0x430
[ 5241.840724]  [<ffffffff81081dd9>] worker_thread+0x169/0x360
[ 5241.840741]  [<ffffffff81081c70>] ? manage_workers.clone.21+0x240/0x240
[ 5241.840758]  [<ffffffff81086616>] kthread+0x96/0xa0
[ 5241.840775]  [<ffffffff815f2434>] kernel_thread_helper+0x4/0x10
[ 5241.840792]  [<ffffffff81086580>] ? flush_kthread_worker+0xb0/0xb0
[ 5241.840808]  [<ffffffff815f2430>] ? gs_change+0x13/0x13
[ 5241.840819] ---[ end trace c8a580615cad6cb5 ]---


Best Regards,
  Martin

Am 15.09.2011 21:50, schrieb Josef Bacik:
> On Thu, Sep 15, 2011 at 11:44:09AM -0700, Sage Weil wrote:
>> On Tue, 13 Sep 2011, Liu Bo wrote:
>>> On 09/11/2011 05:47 AM, Martin Mailand wrote:
>>>> Hi
>>>> I am hitting this Warning reproducible, the workload is a ceph osd,
>>>> kernel ist 3.1.0-rc5.
>>>>
>>>
>>> Have posted a patch for this:
>>>
>>> http://marc.info/?l=linux-btrfs&m=131547325515336&w=2
>>
>> We're still seeing this with -rc6, which includes 98c9942 and 65450aa.
>>
>> I haven't looked at the reservation code in much detail.  Is there
>> anything I can do to help track this down?
>>
>
> This should be taken care of with all my enospc changes.  You can pull them down
> from my btrfs-work tree as soon as kernel.org comes back from the dead :).
> Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

