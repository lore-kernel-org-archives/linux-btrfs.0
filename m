Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.xlhost.de ([84.200.252.118]:36101 "EHLO app1a.xlhost.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934001AbcHDRCw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Aug 2016 13:02:52 -0400
Message-ID: <57A372F3.5090400@5t9.de>
Date: Thu, 04 Aug 2016 18:53:07 +0200
From: Lutz Vieweg <lvml@5t9.de>
MIME-Version: 1.0
To: "cheater00 ." <cheater00@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, russell@coker.com.au
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the "usual"
 problem
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com> <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com> <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com> <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com> <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com> <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com> <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com> <20160109202659.GC6060@carfax.org.uk> <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com> <20160109210429.GD6060@carfax.org.uk> <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com> <5693A8B3.2090508@gmail.com> <CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com> <CA+9GZUg-6WrQTgCw_AmVb2qqr4aL4xeWH6mSq1zQ14qbxextzA@mail.gmail.com> <CA+9GZUgb=h9_t5fXH-qP_-MwKkoN4xLhhYNnCthccA114+KaeQ@mail.gmail.com>
In-Reply-To: <CA+9GZUgb=h9_t5fXH-qP_-MwKkoN4xLhhYNnCthccA114+KaeQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I was today hit by what I think is probably the same bug:
A btrfs on a close-to-4TB sized block device, only half filled
to almost exactly 2 TB, suddenly says "no space left on device"
upon any attempt to write to it. The filesystem was NOT automatically
switched to read-only by the kernel, I should mention.

Re-mounting (which is a pain as this filesystem is used for
$HOMEs of a multitude of active users who I have to kick from
the server for doing things like re-mounting) removed the symptom
for now, but from what I can read in linux-btrfs mailing list
archives, it pretty likely the symptom will re-appear.

Here are some more details:

Software versions:
> linux-4.6.1 (vanilla from kernel.org)
> btrfs-progs v4.1

Info obtained while the symptom occured (before re-mount):
> > btrfs filesystem show /data3
> Label: 'data3'  uuid: f4c69d29-62ac-4e15-a825-c6283c8fd74c
>         Total devices 1 FS bytes used 2.05TiB
>         devid    1 size 3.64TiB used 2.16TiB path /dev/mapper/cryptedResourceData3

(/dev/mapper/cryptedResourceData3 is a dm-crypt device,
which is based on a DRBD block device, which is based
on locally attached SATA disks on two servers - no trouble
with that setup for years, no I/O-errors or such, same
kind of block-device stack also used for another btrfs
and some XFS filesystems.)

> > btrfs filesystem df /data3
> Data, single: total=2.11TiB, used=2.01TiB
> System, single: total=4.00MiB, used=256.00KiB
> Metadata, single: total=48.01GiB, used=36.67GiB
> GlobalReserve, single: total=512.00MiB, used=5.52MiB

Currently and at the time the bug occured no snapshots existed
on "/data3". A snapshot is created once per night, a backup
created, then the snapshot is removed again.
There is lots of mixed I/O-activity during the day, both from interactive
users and from automatic build processes and such.

dmesg output from the time the "no space left on device"-symptom
appeared:

> [5171203.601620] WARNING: CPU: 4 PID: 23208 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x263/0x2a0 [btrfs]
> [5171203.602719] Modules linked in: dm_snapshot dm_bufio fuse btrfs xor raid6_pq nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter drbd lru_cache bridge stp llc kvm_amd kvm irqbypass ghash_clmulni_intel amd64_edac_mod ses edac_mce_amd enclosure edac_core sp5100_tco pcspkr k10temp fam15h_power sg i2c_piix4 shpchp acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c dm_crypt mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ixgbe crct10dif_pclmul crc32_pclmul crc32c_intel igb ahci libahci aesni_intel glue_helper libata lrw gf128mul ablk_helper mdio cryptd ptp serio_raw i2c_algo_bit pps_core i2c_core dca sd_mod dm_mirror dm_region_hash dm_log dm_mod
...
> [5171203.617358] Call Trace:
> [5171203.618543]  [<ffffffff812faac1>] dump_stack+0x4d/0x6c
> [5171203.619568]  [<ffffffff8106baf3>] __warn+0xe3/0x100
> [5171203.620660]  [<ffffffff8106bc2d>] warn_slowpath_null+0x1d/0x20
> [5171203.621779]  [<ffffffffa0728a03>] btrfs_destroy_inode+0x263/0x2a0 [btrfs]
> [5171203.622716]  [<ffffffff812090bb>] destroy_inode+0x3b/0x60
> [5171203.623774]  [<ffffffff812091fc>] evict+0x11c/0x180
...
> [5171230.306037] WARNING: CPU: 18 PID: 12656 at fs/btrfs/extent-tree.c:4233 btrfs_free_reserved_data_space_noquota+0xf3/0x100 [btrfs]
> [5171230.310298] Modules linked in: dm_snapshot dm_bufio fuse btrfs xor raid6_pq nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter drbd lru_cache bridge stp llc kvm_amd kvm irqbypass ghash_clmulni_intel amd64_edac_mod ses edac_mce_amd enclosure edac_core sp5100_tco pcspkr k10temp fam15h_power sg i2c_piix4 shpchp acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c dm_crypt mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ixgbe crct10dif_pclmul crc32_pclmul crc32c_intel igb ahci libahci aesni_intel glue_helper libata lrw gf128mul ablk_helper mdio cryptd ptp serio_raw i2c_algo_bit pps_core i2c_core dca sd_mod dm_mirror dm_region_hash dm_log dm_mod
...
> [5171230.341755] Call Trace:
> [5171230.344119]  [<ffffffff812faac1>] dump_stack+0x4d/0x6c
> [5171230.346444]  [<ffffffff8106baf3>] __warn+0xe3/0x100
> [5171230.348709]  [<ffffffff8106bc2d>] warn_slowpath_null+0x1d/0x20
> [5171230.350976]  [<ffffffffa06fb863>] btrfs_free_reserved_data_space_noquota+0xf3/0x100 [btrfs]
> [5171230.353212]  [<ffffffffa071b10f>] btrfs_clear_bit_hook+0x27f/0x350 [btrfs]
> [5171230.355392]  [<ffffffffa073527a>] ? free_extent_state+0x1a/0x20 [btrfs]
> [5171230.357556]  [<ffffffffa0735bd6>] clear_state_bit+0x66/0x1d0 [btrfs]
> [5171230.359698]  [<ffffffffa0735f64>] __clear_extent_bit+0x224/0x3a0 [btrfs]
> [5171230.361810]  [<ffffffffa06f7e35>] ? btrfs_update_reserved_bytes+0x45/0x130 [btrfs]
> [5171230.363960]  [<ffffffffa0736cfa>] extent_clear_unlock_delalloc+0x7a/0x2d0 [btrfs]
> [5171230.366079]  [<ffffffff811c9ccd>] ? kmem_cache_alloc+0x17d/0x1f0
> [5171230.368204]  [<ffffffffa0732243>] ? __btrfs_add_ordered_extent+0x43/0x310 [btrfs]
> [5171230.370350]  [<ffffffffa07323fb>] ? __btrfs_add_ordered_extent+0x1fb/0x310 [btrfs]
> [5171230.372491]  [<ffffffffa071e89a>] cow_file_range+0x28a/0x460 [btrfs]
> [5171230.374636]  [<ffffffffa071f712>] run_delalloc_range+0x102/0x3e0 [btrfs]
> [5171230.376785]  [<ffffffffa073754c>] writepage_delalloc.isra.40+0x10c/0x170 [btrfs]
> [5171230.378941]  [<ffffffffa0738729>] __extent_writepage+0xd9/0x2e0 [btrfs]
> [5171230.381107]  [<ffffffffa0738bd3>] extent_write_cache_pages.isra.36.constprop.60+0x2a3/0x450 [btrfs]
> [5171230.383319]  [<ffffffffa071a225>] ? btrfs_submit_bio_hook+0xe5/0x1c0 [btrfs]
> [5171230.385542]  [<ffffffffa0719020>] ? btrfs_fiemap+0x70/0x70 [btrfs]
> [5171230.387764]  [<ffffffffa0718770>] ? btrfs_init_inode_security+0x60/0x60 [btrfs]
> [5171230.390010]  [<ffffffffa073a9cb>] extent_writepages+0x5b/0x90 [btrfs]
> [5171230.392270]  [<ffffffffa071c240>] ? btrfs_submit_direct+0x840/0x840 [btrfs]
> [5171230.394545]  [<ffffffffa0718ba8>] btrfs_writepages+0x28/0x30 [btrfs]
> [5171230.396796]  [<ffffffff8117526e>] do_writepages+0x1e/0x30
> [5171230.399041]  [<ffffffff8121bd55>] __writeback_single_inode+0x45/0x320
> [5171230.401289]  [<ffffffff8121c566>] writeback_sb_inodes+0x266/0x550
> [5171230.403542]  [<ffffffff8121c8dc>] __writeback_inodes_wb+0x8c/0xc0
> [5171230.405799]  [<ffffffff8121cb89>] wb_writeback+0x279/0x310
> [5171230.408047]  [<ffffffff8121d32a>] wb_workfn+0x22a/0x3f0
> [5171230.410274]  [<ffffffff81084f57>] process_one_work+0x147/0x3f0
> [5171230.412506]  [<ffffffff81085324>] worker_thread+0x124/0x480
> [5171230.414686]  [<ffffffff8167ff4c>] ? __schedule+0x29c/0x8b0
> [5171230.416807]  [<ffffffff81085200>] ? process_one_work+0x3f0/0x3f0
> [5171230.418875]  [<ffffffff8108b0c8>] kthread+0xd8/0xf0
> [5171230.420880]  [<ffffffff81684052>] ret_from_fork+0x22/0x40
...
> [5255978.507519] WARNING: CPU: 8 PID: 2678 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x263/0x2a0 [btrfs]
...
> [5255978.538796] Call Trace:
> [5255978.541263]  [<ffffffff812faac1>] dump_stack+0x4d/0x6c
> [5255978.543762]  [<ffffffff8106baf3>] __warn+0xe3/0x100
> [5255978.546192]  [<ffffffff8106bc2d>] warn_slowpath_null+0x1d/0x20
> [5255978.548639]  [<ffffffffa0728a03>] btrfs_destroy_inode+0x263/0x2a0 [btrfs]
> [5255978.551044]  [<ffffffff812090bb>] destroy_inode+0x3b/0x60
> [5255978.553435]  [<ffffffff812091fc>] evict+0x11c/0x180
...
> 5256861.709481] WARNING: CPU: 16 PID: 21344 at fs/btrfs/extent-tree.c:4233 btrfs_free_reserved_data_space_noquota+0xf3/0x100 [btrfs]
...

Then, as I did "umount /data3":
> [5335831.813498] WARNING: CPU: 5 PID: 16957 at fs/btrfs/extent-tree.c:5436 btrfs_free_block_groups+0x30b/0x3b0 [btrfs]
...
> [5335831.835835] Call Trace:
> [5335831.837585]  [<ffffffff812faac1>] dump_stack+0x4d/0x6c
> [5335831.839335]  [<ffffffff8106baf3>] __warn+0xe3/0x100
> [5335831.841063]  [<ffffffff8106bc2d>] warn_slowpath_null+0x1d/0x20
> [5335831.842818]  [<ffffffffa070018b>] btrfs_free_block_groups+0x30b/0x3b0 [btrfs]
> [5335831.844576]  [<ffffffffa0711d7c>] close_ctree+0x18c/0x390 [btrfs]
> [5335831.846309]  [<ffffffff8120a07b>] ? evict_inodes+0x13b/0x160
> [5335831.848051]  [<ffffffffa06df279>] btrfs_put_super+0x19/0x20 [btrfs]
> [5335831.849781]  [<ffffffff811f043f>] generic_shutdown_super+0x6f/0xf0
> [5335831.851507]  [<ffffffff811f10b2>] kill_anon_super+0x12/0x20
> [5335831.853246]  [<ffffffffa06e5128>] btrfs_kill_super+0x18/0x110 [btrfs]
> [5335831.854979]  [<ffffffff811effe1>] deactivate_locked_super+0x51/0x90
> [5335831.856714]  [<ffffffff811f0066>] deactivate_super+0x46/0x60
> [5335831.858447]  [<ffffffff8120d06f>] cleanup_mnt+0x3f/0x80
> [5335831.860178]  [<ffffffff8120d102>] __cleanup_mnt+0x12/0x20
> [5335831.861908]  [<ffffffff81089683>] task_work_run+0x83/0xa0
> [5335831.863633]  [<ffffffff81066814>] exit_to_usermode_loop+0x6d/0x96
> [5335831.865361]  [<ffffffff81002d2d>] do_syscall_64+0xfd/0x110
> [5335831.867088]  [<ffffffff81683efc>] entry_SYSCALL64_slow_path+0x25/0x25
...
> [5335831.872552] WARNING: CPU: 5 PID: 16957 at fs/btrfs/extent-tree.c:5437 btrfs_free_block_groups+0x3a5/0x3b0 [btrfs]
...
> [5335831.896906] Call Trace:
> [5335831.898668]  [<ffffffff812faac1>] dump_stack+0x4d/0x6c
> [5335831.900414]  [<ffffffff8106baf3>] __warn+0xe3/0x100
> [5335831.902117]  [<ffffffff8106bc2d>] warn_slowpath_null+0x1d/0x20
> [5335831.903805]  [<ffffffffa0700225>] btrfs_free_block_groups+0x3a5/0x3b0 [btrfs]
> [5335831.905467]  [<ffffffffa0711d7c>] close_ctree+0x18c/0x390 [btrfs]
> [5335831.907067]  [<ffffffff8120a07b>] ? evict_inodes+0x13b/0x160
> [5335831.908642]  [<ffffffffa06df279>] btrfs_put_super+0x19/0x20 [btrfs]
> [5335831.910169]  [<ffffffff811f043f>] generic_shutdown_super+0x6f/0xf0
> [5335831.911680]  [<ffffffff811f10b2>] kill_anon_super+0x12/0x20
> [5335831.913186]  [<ffffffffa06e5128>] btrfs_kill_super+0x18/0x110 [btrfs]
> [5335831.914664]  [<ffffffff811effe1>] deactivate_locked_super+0x51/0x90
> [5335831.916152]  [<ffffffff811f0066>] deactivate_super+0x46/0x60
> [5335831.917633]  [<ffffffff8120d06f>] cleanup_mnt+0x3f/0x80
> [5335831.919094]  [<ffffffff8120d102>] __cleanup_mnt+0x12/0x20
> [5335831.920549]  [<ffffffff81089683>] task_work_run+0x83/0xa0
> [5335831.922004]  [<ffffffff81066814>] exit_to_usermode_loop+0x6d/0x96
> [5335831.923465]  [<ffffffff81002d2d>] do_syscall_64+0xfd/0x110
> [5335831.924917]  [<ffffffff81683efc>] entry_SYSCALL64_slow_path+0x25/0x25

After re-mounting, so far the only messages to "dmesg" were:
> [5335997.784884] BTRFS info (device dm-7): disk space caching is enabled
> [5335997.787007] BTRFS: has skinny extents

Does it make sense to amend
> https://bugzilla.kernel.org/show_bug.cgi?id=74101
- that report doesn't look like it sparked attention, right?

The amount of threads on "lost or unused free space" without resolutions
in the btrfs mailing list archive is really frightening. If these
symptoms commonly re-appear with no fix in sight, I'm afraid I'll have
to either resort to using XFS (with ugly block-device based snapshots
for backup) or try my luck with OpenZFS :-(

Regards,

Lutz Vieweg




On 01/11/2016 02:45 PM, cheater00 . wrote:
> After remounting, the bug doesn't transpire any more, Data gets resized.
>
> It is my experience that this bug will go untriggered for weeks at a
> time until I write a lot to that disk there, at which point it'll
> happen very quickly. I believe this has more to do with the amount of
> data that's been written to disk than anything else. It has been about
> 48 GB to trigger the last instance and I don't think that's very
> different from what happened before but I didn't keep track exactly.
>
> On Mon, Jan 11, 2016 at 2:30 PM, cheater00 . <cheater00@gmail.com> wrote:
>> The bug just happened again. Attached is a log since the time I
>> mounted the FS right after the fsck.
>>
>> Note the only things between the message I got while mounting:
>> [216798.144518] BTRFS info (device sdc1): disk space caching is enabled
>>
>> and the beginning of the crash dump:
>> [241534.760651] ------------[ cut here ]------------
>>
>> is this:
>> [218266.098344] usb 4-1.1: reset high-speed USB device number 3 using ehci-pci
>> [233647.332085] usb 4-1.1: reset high-speed USB device number 3 using ehci-pci
>>
>> I am not sure why those resets happen, though. I bought a few cables
>> and experimented with them, and the usb ports themselves are located
>> directly on the motherboard.
>> Also, they happened some considerable time before the crash dump. So
>> I'm not sure they're even related. Especially given that I was copying
>> a lot of very small files, and they all copied onto the disk fine all
>> the time between the last usb reset and the crash dump, which is
>> roughly two and a half hours. In fact I pressed ctrl-z on a move
>> operation and then wrote something like sleep $(echo '60*60*3' | bc) ;
>> fg and ran it just past 9 am, so the mv resumed past 12 pm, so as
>> things add up the last usb reset happened even before the mv was
>> resumed with fg.
>>
>> I unmounted the fs and re-mounted the it to make it writeable again.
>> This showed up in dmesg:
>>
>> [241766.485365] BTRFS error (device sdc1): cleaner transaction attach
>> returned -30
>> [241770.115897] BTRFS info (device sdc1): disk space caching is enabled
>>
>> this time there was no "info" line about the free space cache file. So
>> maybe it wasn't important for the bug to occur at all.
>>
>> The new output of btrfs fi df -g is:
>> Data, single: total=2080.01GiB, used=2078.80GiB
>> System, DUP: total=0.01GiB, used=0.00GiB
>> System, single: total=0.00GiB, used=0.00GiB
>> Metadata, DUP: total=5.50GiB, used=3.73GiB
>> Metadata, single: total=0.01GiB, used=0.00GiB
>> GlobalReserve, single: total=0.50GiB, used=0.00GiB
>>
>> I could swap this disk onto sata and the other disk back onto usb to
>> see if the usb resets have anything to do with this. But I'm skeptic.
>> Also maybe btrfs has some other issues related to just the disk being
>> on usb, resets or not, and this way if the bug doesn't trigger on sata
>> we'll think "aha it was the resets, buggy hardware etc" but instead
>> it'll have been something else that just has to do with the disk being
>> on usb operating normally.
>>
>> On Mon, Jan 11, 2016 at 2:11 PM, cheater00 . <cheater00@gmail.com> wrote:
>>> On Mon, Jan 11, 2016 at 2:05 PM, Austin S. Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>> On 2016-01-09 16:07, cheater00 . wrote:
>>>>>
>>>>> Would like to point out that this can cause data loss. If I'm writing
>>>>> to disk and the disk becomes unexpectedly read only - that data will
>>>>> be lost, because who in their right mind makes their code expect this
>>>>> and builds a contingency (e.g. caching, backpressure, etc)...
>>>>
>>>> If a data critical application (mail server, database server, anything
>>>> similar) can't gracefully handle ENOSPC, then that application is broken,
>>>> not the FS.  As an example, set up a small VM with an SMTP server, then
>>>> force the FS the server uses for queuing mail read-only, and see if you can
>>>> submit mail, then go read the RFCs for SMTP and see what clients are
>>>> supposed to do when they can't submit mail.  A properly designed piece of
>>>> software is supposed to be resilient against common failure modes of the
>>>> resources it depends on (which includes ENOSPC and read-only filesystems for
>>>> anything that works with data on disk).
>>>>>
>>>>>
>>>>> There's no loss of data on the disk because the data doesn't make it
>>>>> to disk in the first place. But it's exactly the same as if the data
>>>>> had been written to disk, and then lost.
>>>>>
>>>> No, it isn't.  If you absolutely need the data on disk, you should be
>>>> calling fsync or fdatasync, and then assuming if those return an error that
>>>> none of the data written since the last call has gotten to the disk (some of
>>>> it might have, but you need to assume it hasn't).  Every piece of software
>>>> in wide usage that requires data to be on the disk does this, because
>>>> otherwise it can't guarantee that the data is on disk.
>>>
>>> I agree that a lot of stuff goes right in a perfect world. But most of
>>> the time what you're running isn't a mail server used by billions of
>>> users, but instead a bash script someone wrote once that's supposed to
>>> do something, and no one knows how it works.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
