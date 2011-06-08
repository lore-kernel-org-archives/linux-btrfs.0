From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:6164!
Date: Wed, 08 Jun 2011 14:12:47 +0900
Message-ID: <4DEF04CF.8010502@jp.fujitsu.com>
References: <4DEC90CB.4050609@jp.fujitsu.com> <4DEDB7AF.2060308@cn.fujitsu.com> <4DEDBE4B.2020403@jp.fujitsu.com> <4DEDC293.30105@jp.fujitsu.com> <4DEDE03B.9050907@jp.fujitsu.com> <4DEDE328.5060405@cn.fujitsu.com> <1307461229-sup-9822@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307461229-sup-9822@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/06/08 0:46), Chris Mason wrote:
> Excerpts from liubo's message of 2011-06-07 04:36:56 -0400:
>> On 06/07/2011 04:24 PM, Tsutomu Itoh wrote:
>>> (2011/06/07 15:17), Tsutomu Itoh wrote:
>>>> (2011/06/07 14:59), Tsutomu Itoh wrote:
>>>>> Hi liubo,
>>>>>
>>>>> (2011/06/07 14:31), liubo wrote:
>>>>>> On 06/06/2011 04:33 PM, Tsutomu Itoh wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I encountered following panic using 'btrfs-unstable + for-linus'
>>>>>>> kernel.
>>>>>>>
>>>>>>> I ran "btrfs fi bal /test5" command, and mount option of /test5
>>>>>>> is as follows:
>>>>>>>
>>>>>>>  /dev/sdc3 on /test5 type btrfs (rw,space_cache,compress=lzo,inode_cache)
>>>>>>>
>>>>>> So, just a "btrfs fi bal" would lead to the bug?
>>>>> I think so.
> 
> It should be specific to the inode caching code.  The balancing code is
> finding the inode map cache extents, but it doesn't know how to relocate
> them.

However, the panic has occurred even if inode_cahce is turned off.
Is this another problem?

---
Tsutomu

====================================================================

device fsid a46d03b5cb35c93-4713fead8acc709e devid 1 transid 7 /dev/sdc3
btrfs: enabling disk space caching
btrfs: use lzo compression
device fsid 914b303425ef9825-e448135c0d20babe devid 1 transid 7 /dev/sdd4
btrfs: disk space caching is enabled
btrfs: relocating block group 1103101952 flags 9
btrfs: found 540 extents
btrfs: found 540 extents
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:1424!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/kernel/mm/ksm/run
CPU 0
Modules linked in: autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 btrfs zlib_deflate crc32c libcrc32c ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas pata_acpi ata_generic ata_piix libata scsi_mod floppy [last unloaded: microcode]

Pid: 26884, comm: btrfs Not tainted 2.6.39btrfs-test+ #4 FUJITSU-SV      PRIMERGY            /D2399
RIP: 0010:[<ffffffffa0325422>]  [<ffffffffa0325422>] lookup_inline_extent_backref+0x2d2/0x3f0 [btrfs]
RSP: 0018:ffff8801475db748  EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff880141d1a6d0 RCX: ffff8801475da000
RDX: 0000000000000008 RSI: ffff880000000000 RDI: 0000000000000000
RBP: ffff8801475db7e8 R08: 0000000000000001 R09: 6db6db6db6db6db7
R10: 0000000000000001 R11: 0000000000000014 R12: 00000000000000b8
R13: ffff880142bc8a08 R14: 0000000000000001 R15: 000000000000000d
FS:  00007fbbaa8b0740(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000033cfeda340 CR3: 0000000145c04000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs (pid: 26884, threadinfo ffff8801475da000, task ffff880160806ab0)
Stack:
 ffff8801475db778 ffffffffa0331ca6 ffff88018c1087c8 ffff8801475db830
 0000000000000821 0000000181f43000 ffff8801475db7e8 ffff88012cc27800
 000000000000082e 00000794475db9a9 0000000181f43000 00000000004000a8
Call Trace:
 [<ffffffffa0331ca6>] ? btrfs_mark_buffer_dirty+0xb6/0x130 [btrfs]
 [<ffffffffa03255a9>] insert_inline_extent_backref+0x69/0x100 [btrfs]
 [<ffffffff81140376>] ? kmem_cache_alloc+0x186/0x190
 [<ffffffffa03256e3>] __btrfs_inc_extent_ref+0xa3/0x1e0 [btrfs]
 [<ffffffffa0326d19>] ? update_block_group+0xd9/0x2a0 [btrfs]
 [<ffffffffa0327e94>] run_clustered_refs+0x664/0x7f0 [btrfs]
 [<ffffffffa03280e8>] btrfs_run_delayed_refs+0xc8/0x210 [btrfs]
 [<ffffffffa033638d>] btrfs_commit_transaction+0x7d/0x790 [btrfs]
 [<ffffffff81081de0>] ? wake_up_bit+0x40/0x40
 [<ffffffffa037922d>] prepare_to_merge+0x1fd/0x230 [btrfs]
 [<ffffffffa037f306>] relocate_block_group+0x476/0x660 [btrfs]
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
 RSP <ffff8801475db748>


> 
> I think we need to switch the inode map cache over to regular extents
> that are not preallocated.  It will fix the overflow problem and it will
> fix the balancing.
> 
> There are a lot of special cases for the free extent cache that don't
> apply to the inode map cache, and I think sharing the extent
> preallocation is hurting us.
> 
> -chris
> 
> 

