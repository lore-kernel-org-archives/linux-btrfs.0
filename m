From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:6164!
Date: Tue, 07 Jun 2011 15:17:55 +0900
Message-ID: <4DEDC293.30105@jp.fujitsu.com>
References: <4DEC90CB.4050609@jp.fujitsu.com> <4DEDB7AF.2060308@cn.fujitsu.com> <4DEDBE4B.2020403@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DEDBE4B.2020403@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/06/07 14:59), Tsutomu Itoh wrote:
> Hi liubo,
> 
> (2011/06/07 14:31), liubo wrote:
>> On 06/06/2011 04:33 PM, Tsutomu Itoh wrote:
>>> Hi,
>>>
>>> I encountered following panic using 'btrfs-unstable + for-linus'
>>> kernel.
>>>
>>> I ran "btrfs fi bal /test5" command, and mount option of /test5
>>> is as follows:
>>>
>>>  /dev/sdc3 on /test5 type btrfs (rw,space_cache,compress=lzo,inode_cache)
>>>
>>
>> So, just a "btrfs fi bal" would lead to the bug?
> 
> I think so.
> 
>>
>> I've figured out the warnings, but not reproduced the bug yet...
>> I used 'btrfs-unstable + for-linus" whose top commit is
>>
>> commit aa0467d8d2a00e75b2bb6a56a4ee6d70c5d1928f
>> Author: David Sterba <dsterba@suse.cz>
>> Date:   Fri Jun 3 16:29:08 2011 +0200
>>
>>     btrfs: fix uninitialized variable warning
> 
> It's same of my environment.
> 
>>     
>> and tried on 1) a single disk, 2) 2 disks and 3) 4 disks respectively,
>> but none of them leaded to the below bug.
> 
> The test script and the volume composition that I am executing are
> same as following mail.
> 
>   http://marc.info/?l=linux-btrfs&m=130680171426371&w=2
> 
> and, in my environment, panic is done within almost 30 minutes when
> test script is executed.

Another panic occurred when I executed it again.


device fsid 794aee8608a3c563-e4baafe1f4d8eba5 devid 5 transid 4 /dev/sdc8
device fsid 794aee8608a3c563-e4baafe1f4d8eba5 devid 1 transid 7 /dev/sdc3
btrfs: enabling disk space caching
btrfs: use lzo compression
btrfs: enabling inode map caching
device fsid 624604c4bdf670bb-1c9404b53abaa6a3 devid 1 transid 7 /dev/sdd4
btrfs: disk space caching is enabled
btrfs: relocating block group 1103101952 flags 9
btrfs: found 540 extents
btrfs: found 540 extents
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:1424!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:03.0/host4/target4:2:3/4:2:3:0/block/sdd/sdd4/alignment_offset
CPU 0
Modules linked in: autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 btrfs zlib_deflate crc32c libcrc32c ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas pata_acpi ata_generic ata_piix libata scsi_mod floppy [last unloaded: microcode]

Pid: 3849, comm: btrfs Not tainted 2.6.39btrfs-test+ #4 FUJITSU-SV      PRIMERGY            /D2399
RIP: 0010:[<ffffffffa0325422>]  [<ffffffffa0325422>] lookup_inline_extent_backref+0x2d2/0x3f0 [btrfs]
RSP: 0018:ffff880156d2d7b8  EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff8801947f3e20 RCX: ffff880156d2c000
RDX: 0000000000000008 RSI: ffff880000000000 RDI: 0000000000000000
RBP: ffff880156d2d858 R08: 0000000000000000 R09: 0000000000000283
R10: 0000000000000000 R11: 0000000000000015 R12: 00000000000000b2
R13: ffff88019474b4f8 R14: 0000000000000001 R15: 00000000ffffffff
FS:  00007faaf3753740(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000017bfea0 CR3: 0000000156e53000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs (pid: 3849, threadinfo ffff880156d2c000, task ffff880192a04ab0)
Stack:
 ffff880193893000 0000000000001000 ffff880156d2d808 ffff880156d2d920
 ffff880156d2d808 0000000181f61000 0000000000000000 ffff880193893000
 0000000000000001 ffff880156d2da18 0000000181f61000 00000000009000a8
Call Trace:
 [<ffffffffa03271d6>] __btrfs_free_extent+0xd6/0x730 [btrfs]
 [<ffffffffa0356960>] ? map_extent_buffer+0xb0/0xc0 [btrfs]
 [<ffffffffa0326d19>] ? update_block_group+0xd9/0x2a0 [btrfs]
 [<ffffffffa0327ed8>] run_clustered_refs+0x6a8/0x7f0 [btrfs]
 [<ffffffffa03280e8>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa033638d>] btrfs_commit_transaction+0x7d/0x790 [btrfs]
 [<ffffffffa0335ac5>] ? join_transaction+0x25/0x250 [btrfs]
 [<ffffffff81081de0>] ? wake_up_bit+0x40/0x40
 [<ffffffffa037f377>] relocate_block_group+0x4e7/0x660 [btrfs]
 [<ffffffffa0334d15>] ? btrfs_clean_old_snapshots+0x35/0x150 [btrfs]
 [<ffffffffa037f6a3>] btrfs_relocate_block_group+0x1b3/0x2e0 [btrfs]
 [<ffffffffa0368d80>] ? btrfs_tree_unlock+0x50/0x50 [btrfs]
 [<ffffffffa035e22b>] btrfs_relocate_chunk+0x8b/0x670 [btrfs]
 [<ffffffffa031303d>] ? btrfs_set_path_blocking+0x3d/0x50 [btrfs]
 [<ffffffffa0357668>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
 [<ffffffffa031be51>] ? btrfs_previous_item+0xb1/0x150 [btrfs]
 [<ffffffffa0357668>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
 [<ffffffffa035f43a>] btrfs_balance+0x21a/0x2b0 [btrfs]
 [<ffffffff8115dc41>] ? path_openat+0x101/0x3d0
 [<ffffffffa03685bc>] btrfs_ioctl+0x51c/0xc40 [btrfs]
 [<ffffffff8111e358>] ? handle_mm_fault+0x148/0x270
 [<ffffffff814809e8>] ? do_page_fault+0x1d8/0x4b0
 [<ffffffff81160d6a>] do_vfs_ioctl+0x9a/0x540
 [<ffffffff811612b1>] sys_ioctl+0xa1/0xb0
 [<ffffffff81484ec2>] system_call_fastpath+0x16/0x1b
Code: 48 8b 75 20 48 89 c3 48 8b 7d 18 e8 c9 bd ff ff 48 39 d8 77 26 b8 1d 00 00 00 e9 15 ff ff ff a8 01 0f 85 8c fe ff ff 0f 0b eb fe <0f> 0b eb fe 0f 0b 0f 1f 84 00 00 00 00 00 eb f6 4c 89 fb 44 8b
RIP  [<ffffffffa0325422>] lookup_inline_extent_backref+0x2d2/0x3f0 [btrfs]
 RSP <ffff880156d2d7b8>

> 
> Thanks,
> Tsutomu
> 
>>
>> I guess maybe I miss something to reproduce it?
>>
>> thanks,
>> liubo
>>
>>> Thanks,
>>> Tsutomu
>>>
>>> =================================================================
>>>
>>> btrfs: relocating block group 23383244800 flags 20
>>> btrfs: found 2959 extents
>>> ------------[ cut here ]------------
>>> WARNING: at fs/btrfs/transaction.c:213 start_transaction+0x2a7/0x2b0 [btrfs]()
>>> Hardware name: PRIMERGY
>>> Modules linked in: autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufr
>>> eq freq_table mperf ipv6 btrfs zlib_deflate crc32c libcrc32c ext3 jbd dm_mirror
>>> dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i
>>> 801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac
>>> _core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas pata_a
>>> cpi ata_generic ata_piix libata scsi_mod floppy [last unloaded: microcode]
>>> Pid: 23781, comm: btrfs Tainted: G        W   2.6.39btrfs-test+ #4
>>> Call Trace:
>>>  [<ffffffff8106004f>] warn_slowpath_common+0x7f/0xc0
>>>  [<ffffffff810600aa>] warn_slowpath_null+0x1a/0x20
>>>  [<ffffffffa0337047>] start_transaction+0x2a7/0x2b0 [btrfs]
>>>  [<ffffffffa035498d>] ? btrfs_wait_ordered_range+0x10d/0x160 [btrfs]
>>>  [<ffffffffa0337323>] btrfs_start_transaction+0x13/0x20 [btrfs]
>>>  [<ffffffffa033bbca>] btrfs_evict_inode+0x11a/0x260 [btrfs]
>>>  [<ffffffff811687f8>] evict+0x78/0x170
>>>  [<ffffffff81168c92>] iput+0xe2/0x1a0
>>>  [<ffffffffa031f171>] btrfs_remove_block_group+0x141/0x3c0 [btrfs]
>>>  [<ffffffffa035e6ea>] btrfs_relocate_chunk+0x54a/0x670 [btrfs]
>>>  [<ffffffffa0357668>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
>>>  [<ffffffffa031be51>] ? btrfs_previous_item+0xb1/0x150 [btrfs]
>>>  [<ffffffffa035f43a>] btrfs_balance+0x21a/0x2b0 [btrfs]
>>>  [<ffffffff8115dc41>] ? path_openat+0x101/0x3d0
>>>  [<ffffffffa03685bc>] btrfs_ioctl+0x51c/0xc40 [btrfs]
>>>  [<ffffffff8111e358>] ? handle_mm_fault+0x148/0x270
>>>  [<ffffffff814809e8>] ? do_page_fault+0x1d8/0x4b0
>>>  [<ffffffff81160d6a>] do_vfs_ioctl+0x9a/0x540
>>>  [<ffffffff811612b1>] sys_ioctl+0xa1/0xb0
>>>  [<ffffffff81484ec2>] system_call_fastpath+0x16/0x1b
>>> ---[ end trace e5c5cb2e98a3cd1a ]---
>>> btrfs: relocating block group 20971520 flags 18
>>> btrfs: relocating block group 34925969408 flags 18
>>> btrfs: found 1 extents
>>> ------------[ cut here ]------------
>>> kernel BUG at fs/btrfs/extent-tree.c:6164!
>>> invalid opcode: 0000 [#1] SMP
>>> last sysfs file: /sys/kernel/mm/ksm/run
>>> CPU 0
>>> Modules linked in: autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 btrfs zlib_deflate crc32c libcrc32c ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas pata_acpi ata_generic ata_piix libata scsi_mod floppy [last unloaded: microcode]
>>>
>>> Pid: 4109, comm: btrfs Tainted: G        W   2.6.39btrfs-test+ #4 FUJITSU-SV      PRIMERGY            /D2399
>>> RIP: 0010:[<ffffffffa0325b95>]  [<ffffffffa0325b95>] walk_up_proc+0x375/0x420 [btrfs]
>>> RSP: 0018:ffff8801801eb9c8  EFLAGS: 00010286
>>> RAX: 0000000000000005 RBX: ffff880167a70140 RCX: fffffffffffffff8
>>> RDX: ffff8801801ea000 RSI: ffff880000000000 RDI: ffff880194909fa8
>>> RBP: ffff8801801eba18 R08: 0000000000000000 R09: 0000000000000005
>>> R10: 0000000000000001 R11: ffff880194909fa8 R12: 0000000000000000
>>> R13: ffff88013973d000 R14: ffff88015ad4d9a0 R15: ffff880042203920
>>> FS:  00007fa86bcb9740(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> CR2: 00000033cf60b0c0 CR3: 0000000181cf7000 CR4: 00000000000006f0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Process btrfs (pid: 4109, threadinfo ffff8801801ea000, task ffff88011a4914a0)
>>> Stack:
>>>  ffff8801801eba18 ffff880194909fa8 ffff880100000000 ffffffffa03280e8
>>>  ffff8801801eba58 ffff88015ad4d9a0 0000000000000000 0000000000000000
>>>  ffff8801801ea000 ffff880167a70140 ffff8801801eba78 ffffffffa0325d71
>>> Call Trace:
>>>  [<ffffffffa03280e8>] ? btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
>>>  [<ffffffffa0325d71>] walk_up_tree+0x131/0x1b0 [btrfs]
>>>  [<ffffffffa03260b0>] btrfs_drop_snapshot+0x2c0/0x5c0 [btrfs]
>>>  [<ffffffffa03328b0>] ? btrfs_read_fs_root_no_name+0x1b0/0x280 [btrfs]
>>>  [<ffffffffa037b45f>] merge_reloc_roots+0xdf/0x150 [btrfs]
>>>  [<ffffffffa037f311>] relocate_block_group+0x481/0x660 [btrfs]
>>>  [<ffffffffa0334d15>] ? btrfs_clean_old_snapshots+0x35/0x150 [btrfs]
>>>  [<ffffffffa037f6a3>] btrfs_relocate_block_group+0x1b3/0x2e0 [btrfs]
>>>  [<ffffffffa0368d80>] ? btrfs_tree_unlock+0x50/0x50 [btrfs]
>>>  [<ffffffffa035e22b>] btrfs_relocate_chunk+0x8b/0x670 [btrfs]
>>>  [<ffffffffa031303d>] ? btrfs_set_path_blocking+0x3d/0x50 [btrfs]
>>>  [<ffffffffa0357668>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
>>>  [<ffffffffa031be51>] ? btrfs_previous_item+0xb1/0x150 [btrfs]
>>>  [<ffffffffa0357668>] ? read_extent_buffer+0xd8/0x1d0 [btrfs]
>>>  [<ffffffffa035f43a>] btrfs_balance+0x21a/0x2b0 [btrfs]
>>>  [<ffffffff8115dc41>] ? path_openat+0x101/0x3d0
>>>  [<ffffffffa03685bc>] btrfs_ioctl+0x51c/0xc40 [btrfs]
>>>  [<ffffffff8111e358>] ? handle_mm_fault+0x148/0x270
>>>  [<ffffffff814809e8>] ? do_page_fault+0x1d8/0x4b0
>>>  [<ffffffff81160d6a>] do_vfs_ioctl+0x9a/0x540
>>>  [<ffffffff811612b1>] sys_ioctl+0xa1/0xb0
>>>  [<ffffffff81484ec2>] system_call_fastpath+0x16/0x1b
>>> Code: fe ff ff 0f 1f 00 4c 89 df 31 c9 4c 89 fa 4c 89 ee 44 89 55 c0 4c 89 5d b8 e8 c8 d5 ff ff 4c 8b 5d b8 44 8b 55 c0 e9 85 fe ff ff <0f> 0b eb fe 0f 1f 80 00 00 00 00 65 48 8b 14 25 c8 cc 00 00 48
>>> RIP  [<ffffffffa0325b95>] walk_up_proc+0x375/0x420 [btrfs]
>>>  RSP <ffff8801801eb9c8>
>>>
>>>

