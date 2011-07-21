From: Arne Jansen <sensille@gmx.net>
Subject: Re: new metadata reader/writer locks in integration-test
Date: Thu, 21 Jul 2011 07:46:55 +0200
Message-ID: <4E27BD4F.6020900@gmx.net>
References: <1311096438-sup-1263@shiny> <1311182478-sup-9986@shiny> <4E277757.9070504@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E277757.9070504@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 21.07.2011 02:48, Tsutomu Itoh wrote:
> (2011/07/21 2:21), Chris Mason wrote:
>> Excerpts from Chris Mason's message of 2011-07-19 13:30:22 -0400:
>>> Hi everyone,
>>>
>>> I've pushed out a new integration-test branch, and it includes a new
>>> reader/writer locking scheme for the btree locks.
>>>
>>> We've seen a number of benchmarks dominated by contention on the root
>>> node lock.  This changes our locks into a simple reader/writer lock.
>>> They are based on mutexes so that we still take advantage of the mutex
>>> adaptive spins for write locks (rwsemaphores were much slower).
>>>
>>> I'm also sending the individual commits, please do take a look.
>>
>> Hi everyone,
>>
>> I just rebased Josef's enospc fixes into integration-test, it should fix
>> the warnings in extent-tree.c
>>
> 
> Unfortunately, I got the following messages.
> 
> 
> Jul 21 09:41:22 luna kernel: ------------[ cut here ]------------
> Jul 21 09:41:22 luna kernel: WARNING: at fs/btrfs/extent-tree.c:5564 btrfs_alloc_reserved_file_extent+0xf8/0x100 [btrfs]()
> Jul 21 09:41:22 luna kernel: Hardware name: PRIMERGY
> Jul 21 09:41:22 luna kernel: Modules linked in: btrfs zlib_deflate crc32c libcrc32c autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas floppy pata_acpi ata_generic ata_piix libata scsi_mod [last unloaded: microcode]
> Jul 21 09:41:22 luna kernel: Pid: 5517, comm: btrfs-endio-wri Tainted: G        W   2.6.39btrfs-tc1+ #1
> Jul 21 09:41:22 luna kernel: Call Trace:
> Jul 21 09:41:22 luna kernel: [<ffffffff8106004f>] warn_slowpath_common+0x7f/0xc0
> Jul 21 09:41:22 luna kernel: [<ffffffff810600aa>] warn_slowpath_null+0x1a/0x20
> Jul 21 09:41:22 luna kernel: [<ffffffffa044a068>] btrfs_alloc_reserved_file_extent+0xf8/0x100 [btrfs]
> Jul 21 09:41:22 luna kernel: [<ffffffffa0464121>] insert_reserved_file_extent.clone.0+0x201/0x270 [btrfs]
> Jul 21 09:41:22 luna kernel: [<ffffffffa0468c0b>] btrfs_finish_ordered_io+0x2eb/0x360 [btrfs]
> Jul 21 09:41:22 luna kernel: [<ffffffff8106fe23>] ? try_to_del_timer_sync+0x83/0xe0
> Jul 21 09:41:22 luna kernel: [<ffffffffa0468cd0>] btrfs_writepage_end_io_hook+0x50/0xa0 [btrfs]
> Jul 21 09:41:22 luna kernel: [<ffffffffa049a3c6>] end_compressed_bio_write+0x86/0xf0 [btrfs]
> Jul 21 09:41:22 luna kernel: [<ffffffff8117f96d>] bio_endio+0x1d/0x40
> Jul 21 09:41:22 luna kernel: [<ffffffffa0459d84>] end_workqueue_fn+0xf4/0x130 [btrfs]
> Jul 21 09:41:22 luna kernel: [<ffffffffa048841e>] worker_loop+0x13e/0x540 [btrfs]
> Jul 21 09:41:22 luna kernel: [<ffffffffa04882e0>] ? btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
> Jul 21 09:41:22 luna kernel: [<ffffffffa04882e0>] ? btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
> Jul 21 09:41:22 luna kernel: [<ffffffff81081756>] kthread+0x96/0xa0
> Jul 21 09:41:22 luna kernel: [<ffffffff81486004>] kernel_thread_helper+0x4/0x10
> Jul 21 09:41:22 luna kernel: [<ffffffff810816c0>] ? kthread_worker_fn+0x1a0/0x1a0
> Jul 21 09:41:22 luna kernel: [<ffffffff81486000>] ? gs_change+0x13/0x13
> Jul 21 09:41:22 luna kernel: ---[ end trace 02c1fa3044677043 ]---
> 

a very similar warning here, but without compression involved:

Jul 21 07:42:55 qualactin kernel: [57061.396898] ------------[ cut here ]------------
Jul 21 07:42:55 qualactin kernel: [57061.396923] WARNING: at fs/btrfs/extent-tree.c:5564 btrfs_alloc_reserved_file_extent+0xf8/0x100 [btrfs]()
Jul 21 07:42:55 qualactin kernel: [57061.396927] Hardware name: X8SIL
Jul 21 07:42:55 qualactin kernel: [57061.396930] Modules linked in: btrfs mpt2sas scsi_transport_sas raid_class [last unloaded: btrfs]
Jul 21 07:42:55 qualactin kernel: [57061.396943] Pid: 10500, comm: btrfs-endio-wri Tainted: G        W   2.6.39+ #53
Jul 21 07:42:55 qualactin kernel: [57061.396947] Call Trace:
Jul 21 07:42:55 qualactin kernel: [57061.396958]  [<ffffffff81091f0a>] warn_slowpath_common+0x7a/0xb0
Jul 21 07:42:55 qualactin kernel: [57061.396965]  [<ffffffff81091f55>] warn_slowpath_null+0x15/0x20
Jul 21 07:42:55 qualactin kernel: [57061.396982]  [<ffffffffa0264908>] btrfs_alloc_reserved_file_extent+0xf8/0x100 [btrfs]
Jul 21 07:42:55 qualactin kernel: [57061.396991]  [<ffffffff818742d6>] ? _raw_spin_unlock+0x26/0x30
Jul 21 07:42:55 qualactin kernel: [57061.397007]  [<ffffffffa027f6ba>] T.1250+0x20a/0x260 [btrfs]
Jul 21 07:42:55 qualactin kernel: [57061.397018]  [<ffffffffa02839cb>] btrfs_finish_ordered_io+0x2db/0x330 [btrfs]
Jul 21 07:42:55 qualactin kernel: [57061.397028]  [<ffffffffa0283a69>] btrfs_writepage_end_io_hook+0x49/0x90 [btrfs]
Jul 21 07:42:55 qualactin kernel: [57061.397039]  [<ffffffffa029778e>] end_bio_extent_writepage+0x13e/0x180 [btrfs]
Jul 21 07:42:55 qualactin kernel: [57061.397043]  [<ffffffff811ad1c8>] bio_endio+0x18/0x40
Jul 21 07:42:55 qualactin kernel: [57061.397052]  [<ffffffffa027500c>] end_workqueue_fn+0xec/0x120 [btrfs]
Jul 21 07:42:55 qualactin kernel: [57061.397062]  [<ffffffffa02a3e3c>] worker_loop+0x14c/0x540 [btrfs]
Jul 21 07:42:55 qualactin kernel: [57061.397072]  [<ffffffffa02a3cf0>] ? btrfs_queue_worker+0x320/0x320 [btrfs]
Jul 21 07:42:55 qualactin kernel: [57061.397076]  [<ffffffff810b37de>] kthread+0x9e/0xb0
Jul 21 07:42:55 qualactin kernel: [57061.397079]  [<ffffffff8187cb14>] kernel_thread_helper+0x4/0x10
Jul 21 07:42:55 qualactin kernel: [57061.397082]  [<ffffffff8187423b>] ? _raw_spin_unlock_irq+0x2b/0x40
Jul 21 07:42:55 qualactin kernel: [57061.397085]  [<ffffffff81874540>] ? retint_restore_args+0xe/0xe
Jul 21 07:42:55 qualactin kernel: [57061.397088]  [<ffffffff810b3740>] ? __init_kthread_worker+0x70/0x70
Jul 21 07:42:55 qualactin kernel: [57061.397090]  [<ffffffff8187cb10>] ? gs_change+0xb/0xb
Jul 21 07:42:55 qualactin kernel: [57061.397092] ---[ end trace dd9e6d8cc54aa5e0 ]---

