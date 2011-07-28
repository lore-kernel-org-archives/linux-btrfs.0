From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: WARNING: at fs/btrfs/delayed-inode.c:1247
Date: Thu, 28 Jul 2011 18:11:31 +0900
Message-ID: <4E3127C3.4090200@jp.fujitsu.com>
References: <4E311E23.2070305@jp.fujitsu.com> <4E312707.6000702@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Chris Mason <chris.mason@Oracle.COM>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E312707.6000702@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Miao,

(2011/07/28 18:08), Miao Xie wrote:
> On thu, 28 Jul 2011 17:30:27 +0900, Tsutomu Itoh wrote:
>> Hi, Chris,
>>
>> In current for-linus kernel,
>>
>> When I ran my test script such as a lot of file creation deletion and balance,
>> the following warning messages were displayed only once.
>>
>> However, I cannot have it still reproduce...
> 
> Hi, Itoh-san
> 
> Could you tell me the option of mkfs command and mount command?

option of mkfs:  none (use multiple device)
option of mount: space_cache,compress

Thanks,
Tsutomu

> 
> Thanks
> Miao
> 
>>
>>   -Tsutomu
>>
>>
>> Jul 28 12:01:00 luna kernel: [ 5985.487143] btrfs: found 27992 extents
>> Jul 28 12:01:36 luna kernel: [ 6021.867052] btrfs: found 28482 extents
>> Jul 28 12:01:37 luna kernel: [ 6022.767589] ------------[ cut here ]------------
>> Jul 28 12:01:37 luna kernel: [ 6022.767632] WARNING: at fs/btrfs/delayed-inode.c:1247 btrfs_assert_delayed_root_empty+0x32/0x34 [btrfs]()
>> Jul 28 12:01:37 luna kernel: [ 6022.767636] Hardware name: PRIMERGY
>> Jul 28 12:01:37 luna kernel: [ 6022.767638] Modules linked in: btrfs zlib_deflate crc32c libcrc32c autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif megaraid_sas sr_mod cdrom floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
>> Jul 28 12:01:37 luna kernel: [ 6022.767693] Pid: 24565, comm: flush-btrfs-11 Not tainted 3.0.0test+ #1
>> Jul 28 12:01:37 luna kernel: [ 6022.767696] Call Trace:
>> Jul 28 12:01:37 luna kernel: [ 6022.767704]  [<ffffffff81045426>] warn_slowpath_common+0x85/0x9d
>> Jul 28 12:01:37 luna kernel: [ 6022.767708]  [<ffffffff81045458>] warn_slowpath_null+0x1a/0x1c
>> Jul 28 12:01:37 luna kernel: [ 6022.767725]  [<ffffffffa03c3a81>] btrfs_assert_delayed_root_empty+0x32/0x34 [btrfs]
>> Jul 28 12:01:37 luna kernel: [ 6022.767743]  [<ffffffffa038b579>] btrfs_commit_transaction+0x3cf/0x73a [btrfs]
>> Jul 28 12:01:37 luna kernel: [ 6022.767761]  [<ffffffffa038b9a9>] ? join_transaction+0x24/0x213 [btrfs]
>> Jul 28 12:01:37 luna kernel: [ 6022.767765]  [<ffffffff81060cfd>] ? wake_up_bit+0x2a/0x2a
>> Jul 28 12:01:37 luna kernel: [ 6022.767783]  [<ffffffffa038ff9d>] btrfs_write_inode+0x8a/0x93 [btrfs]
>> Jul 28 12:01:37 luna kernel: [ 6022.767789]  [<ffffffff8112e773>] writeback_single_inode+0x12a/0x1c3
>> Jul 28 12:01:37 luna kernel: [ 6022.767793]  [<ffffffff8112ed85>] writeback_sb_inodes+0xcf/0x15b
>> Jul 28 12:01:37 luna kernel: [ 6022.767796]  [<ffffffff8112f5ce>] wb_writeback+0x217/0x385
>> Jul 28 12:01:37 luna kernel: [ 6022.767801]  [<ffffffff8112f7c5>] wb_do_writeback+0x89/0x20f
>> Jul 28 12:01:37 luna kernel: [ 6022.767806]  [<ffffffff8105265d>] ? del_timer+0x82/0x82
>> Jul 28 12:01:37 luna kernel: [ 6022.767810]  [<ffffffff8112fa06>] bdi_writeback_thread+0xbb/0x211
>> Jul 28 12:01:37 luna kernel: [ 6022.767813]  [<ffffffff8112f94b>] ? wb_do_writeback+0x20f/0x20f
>> Jul 28 12:01:37 luna kernel: [ 6022.767817]  [<ffffffff8112f94b>] ? wb_do_writeback+0x20f/0x20f
>> Jul 28 12:01:37 luna kernel: [ 6022.767821]  [<ffffffff810608ac>] kthread+0x82/0x8a
>> Jul 28 12:01:37 luna kernel: [ 6022.767826]  [<ffffffff813ac2a4>] kernel_thread_helper+0x4/0x10
>> Jul 28 12:01:37 luna kernel: [ 6022.767830]  [<ffffffff8106082a>] ? kthread_worker_fn+0x14a/0x14a
>> Jul 28 12:01:37 luna kernel: [ 6022.767833]  [<ffffffff813ac2a0>] ? gs_change+0x13/0x13
>> Jul 28 12:01:37 luna kernel: [ 6022.767836] ---[ end trace aaac4f48a0d2b77b ]---
>>

