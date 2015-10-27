Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24447 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753739AbbJ0Fsj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 01:48:39 -0400
Subject: Re: [PATCH v3 06/21] btrfs: delayed_ref: Add new function to record
 reserved space into delayed ref
To: Chris Mason <clm@fb.com>, <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1444702827-18169-7-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H7mvHDYESXYHVYxJC7Yr+yXbvmajaRkWO7nu6iZBOYmSQ@mail.gmail.com>
 <562EF9D7.50101@cn.fujitsu.com> <20151027051403.GA23134@ret.thefacebook.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <562F1032.7040103@cn.fujitsu.com>
Date: Tue, 27 Oct 2015 13:48:34 +0800
MIME-Version: 1.0
In-Reply-To: <20151027051403.GA23134@ret.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Mason wrote on 2015/10/27 01:14 -0400:
> On Tue, Oct 27, 2015 at 12:13:11PM +0800, Qu Wenruo wrote:
>>
>>
>> Filipe Manana wrote on 2015/10/25 14:39 +0000:
>>> On Tue, Oct 13, 2015 at 3:20 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>> Add new function btrfs_add_delayed_qgroup_reserve() function to record
>>>> how much space is reserved for that extent.
>>>>
>>>> As btrfs only accounts qgroup at run_delayed_refs() time, so newly
>>>> allocated extent should keep the reserved space until then.
>>>>
>>>> So add needed function with related members to do it.
>>>>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> ---
>>>> v2:
>>>>    None
>>>> v3:
>>>>    None
>>>> ---
>>>>   fs/btrfs/delayed-ref.c | 29 +++++++++++++++++++++++++++++
>>>>   fs/btrfs/delayed-ref.h | 14 ++++++++++++++
>>>>   2 files changed, 43 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>>>> index ac3e81d..bd9b63b 100644
>>>> --- a/fs/btrfs/delayed-ref.c
>>>> +++ b/fs/btrfs/delayed-ref.c
>>>> @@ -476,6 +476,8 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
>>>>          INIT_LIST_HEAD(&head_ref->ref_list);
>>>>          head_ref->processing = 0;
>>>>          head_ref->total_ref_mod = count_mod;
>>>> +       head_ref->qgroup_reserved = 0;
>>>> +       head_ref->qgroup_ref_root = 0;
>>>>
>>>>          /* Record qgroup extent info if provided */
>>>>          if (qrecord) {
>>>> @@ -746,6 +748,33 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
>>>>          return 0;
>>>>   }
>>>>
>>>> +int btrfs_add_delayed_qgroup_reserve(struct btrfs_fs_info *fs_info,
>>>> +                                    struct btrfs_trans_handle *trans,
>>>> +                                    u64 ref_root, u64 bytenr, u64 num_bytes)
>>>> +{
>>>> +       struct btrfs_delayed_ref_root *delayed_refs;
>>>> +       struct btrfs_delayed_ref_head *ref_head;
>>>> +       int ret = 0;
>>>> +
>>>> +       if (!fs_info->quota_enabled || !is_fstree(ref_root))
>>>> +               return 0;
>>>> +
>>>> +       delayed_refs = &trans->transaction->delayed_refs;
>>>> +
>>>> +       spin_lock(&delayed_refs->lock);
>>>> +       ref_head = find_ref_head(&delayed_refs->href_root, bytenr, 0);
>>>> +       if (!ref_head) {
>>>> +               ret = -ENOENT;
>>>> +               goto out;
>>>> +       }
>>>
>>> Hi Qu,
>>>
>>> So while running btrfs/063, with qgroups enabled (I modified the test
>>> to enable qgroups), ran into this 2 times:
>>>
>>> [169125.246506] BTRFS info (device sdc): disk space caching is enabled
>>> [169125.363164] ------------[ cut here ]------------
>>> [169125.365236] WARNING: CPU: 10 PID: 2827 at fs/btrfs/inode.c:2929
>>> btrfs_finish_ordered_io+0x347/0x4eb [btrfs]()
>>> [169125.367702] BTRFS: Transaction aborted (error -2)
>>> [169125.368830] Modules linked in: btrfs dm_flakey dm_mod
>>> crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs
>>> lockd grace fscache sunrpc loop fuse parport_pc parport i2c_piix4
>>> psmouse acpi_cpufreq microcode pcspkr processor evdev i2c_core
>>> serio_raw button ext4 crc16 jbd2 mbcache sd_mod sg sr_mod cdrom
>>> ata_generic virtio_scsi ata_piix libata floppy virtio_pci virtio_ring
>>> scsi_mod e1000 virtio [last unloaded: btrfs]
>>> [169125.376755] CPU: 10 PID: 2827 Comm: kworker/u32:14 Tainted: G
>>>    W       4.3.0-rc5-btrfs-next-17+ #1
>>
>> Hi Filipe,
>>
>> Although not related to the bug report, I'm a little interested in your
>> testing kernel.
>>
>> Are you testing integration-4.4 from Chris repo?
>> Or 4.3-rc from mainline repo with my qgroup reserve patchset applied?
>>
>> Although integration-4.4 already merged qgroup reserve patchset, but it's
>> causing some strange bug like over decrease data sinfo->bytes_may_use,
>> mainly in generic/127 testcase.
>>
>> But if qgroup reserve patchset is rebased to integration-4.3 (I did all my
>> old tests based on that), no generic/127 problem at all.
>
> Did I mismerge things?
>
> -chris
>
Not sure yet.

But at least some patches in 4.3 is not in integration-4.4, like the 
following patch:
btrfs: Avoid truncate tailing page if fallocate range doesn't exceed 
inode size

I'll continue testing and bisecting to see what triggers the strange 
WARN_ON() in integration-4.4.
------
Oct 27 11:05:00 vmware kernel: WARNING: CPU: 4 PID: 13711 at 
fs/btrfs//extent-tree.c:4171 
btrfs_free_reserved_data_space_noquota+0x175/0x190 [btrfs]()
Oct 27 11:05:00 vmware kernel: Modules linked in: btrfs(OE) fuse vfat 
msdos fat xfs binfmt_misc bridge stp llc dm_snapshot dm_bufio dm_flakey 
loop iptable_nat nf_conntrack_ipv4 nf
_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_raw 
iptable_filter ip_tables dm_mirror dm_region_hash dm_log xor dm_mod 
crc32c_intel vmw_balloon raid6_pq nfsd
vmw_vmci i2c_piix4 shpchp auth_rpcgss acpi_cpufreq nfs_acl lockd grace 
sunrpc ext4 mbcache jbd2 sd_mod vmwgfx drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops ttm drm
ata_piix vmxnet3 libata vmw_pvscsi floppy [last unloaded: btrfs]
Oct 27 11:05:00 vmware kernel: CPU: 4 PID: 13711 Comm: fsx Tainted: G 
      W  OE   4.3.0-rc5+ #5
Oct 27 11:05:00 vmware kernel: Hardware name: VMware, Inc. VMware 
Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 08/16/2013
Oct 27 11:05:00 vmware kernel: 0000000000000000 000000002caf2373 
ffff88021f63b760 ffffffff81302e73
Oct 27 11:05:00 vmware kernel: 0000000000000000 ffff88021f63b798 
ffffffff810600f6 ffff88021c6e9000
Oct 27 11:05:00 vmware kernel: ffff88022a4abc00 0000000000006000 
ffff88021f63b8ac ffff8800827a0820
Oct 27 11:05:00 vmware kernel: Call Trace:
Oct 27 11:05:00 vmware kernel: [<ffffffff81302e73>] dump_stack+0x4b/0x68
Oct 27 11:05:00 vmware kernel: [<ffffffff810600f6>] 
warn_slowpath_common+0x86/0xc0
Oct 27 11:05:00 vmware kernel: [<ffffffff8106023a>] 
warn_slowpath_null+0x1a/0x20
Oct 27 11:05:00 vmware kernel: [<ffffffffa04d6b25>] 
btrfs_free_reserved_data_space_noquota+0x175/0x190 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa04f6b8d>] 
btrfs_clear_bit_hook+0x2ed/0x360 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa05113ad>] 
clear_state_bit+0x5d/0x1d0 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa051174a>] 
__clear_extent_bit+0x22a/0x3d0 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa051283a>] 
extent_clear_unlock_delalloc+0x7a/0x2c0 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffff8161a547>] ? 
_raw_spin_unlock+0x27/0x40
Oct 27 11:05:00 vmware kernel: [<ffffffffa050d665>] ? 
__btrfs_add_ordered_extent+0x245/0x3b0 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa04f934b>] 
cow_file_range+0x27b/0x430 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa04fa112>] 
run_delalloc_range+0x102/0x400 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa0513152>] 
writepage_delalloc.isra.35+0x112/0x170 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa0514235>] 
__extent_writepage+0xf5/0x370 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa0514817>] 
extent_write_cache_pages.isra.32.constprop.47+0x367/0x420 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa051662c>] 
extent_writepages+0x5c/0x90 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa04f73b0>] ? 
btrfs_real_readdir+0x570/0x570 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa04f4a38>] 
btrfs_writepages+0x28/0x30 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffff81191501>] do_writepages+0x21/0x40
Oct 27 11:05:00 vmware kernel: [<ffffffff81185ad0>] 
__filemap_fdatawrite_range+0x80/0xb0
Oct 27 11:05:00 vmware kernel: [<ffffffff81185bc3>] 
filemap_fdatawrite_range+0x13/0x20
Oct 27 11:05:00 vmware kernel: [<ffffffffa05095c0>] 
btrfs_fdatawrite_range+0x20/0x50 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa0509609>] 
start_ordered_ops+0x19/0x30 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffffa05096a3>] 
btrfs_sync_file+0x83/0x420 [btrfs]
Oct 27 11:05:00 vmware kernel: [<ffffffff811bd9e0>] ? SyS_msync+0x90/0x1f0
Oct 27 11:05:00 vmware kernel: [<ffffffff8122f7cd>] 
vfs_fsync_range+0x3d/0xb0
Oct 27 11:05:00 vmware kernel: [<ffffffff811bdac1>] SyS_msync+0x171/0x1f0
Oct 27 11:05:00 vmware kernel: [<ffffffff8161af17>] 
entry_SYSCALL_64_fastpath+0x12/0x6f
------

At least, this won't cause anything wrong, as I enhanced the existing 
WARN_ON() in old btrfs_free_reserved_data_space() to handle underflow 
case quite well.
But still need investigating as it seems to be a regression.

Maybe there are some other hidden bug in my qgroup patchset... :(

Thanks,
Qu
