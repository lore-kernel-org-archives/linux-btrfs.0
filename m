From: David Sterba <dave@jikos.cz>
Subject: Re: please review snapshot corruption path with delayed metadata
 insertion
Date: Tue, 21 Jun 2011 02:24:35 +0200
Message-ID: <20110621002435.GK12709@twin.jikos.cz>
References: <1308345034-sup-1969@shiny>
 <4DFD7C63.6040902@jp.fujitsu.com>
 <4DFE8933.7040101@jp.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Miao Xie <miaox@cn.fujitsu.com>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DFE8933.7040101@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2011 at 08:41:39AM +0900, Tsutomu Itoh wrote:
> (2011/06/19 13:34), Tsutomu Itoh wrote:
> >> I've fixed this up by moving the delayed metadata run down into the
> >> snapshot creation code, please take a look.  If nobody objects I'll have
> >> this in the pull I send to Linus this weekend.
> > 
> 
> > I ran my balance test script about 12 hours, any problem didn't occur.
> 
> But, following panics still occur if inode_cache is specified.
> 
> [75164.963860] btrfs: relocating block group 18551406592 flags 18
> [75165.565282] btrfs: relocating block group 18282971136 flags 20
> [75165.883577] ------------[ cut here ]------------
> [75165.883779] kernel BUG at fs/btrfs/relocation.c:2502!
> [75165.883992] invalid opcode: 0000 [#1] SMP
> [75165.884002] CPU 0
> [75165.884002] Modules linked in: autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 btrfs zlib_deflate crc32c libcrc32c ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support tg3 shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sr_mod cdrom megaraid_sas pata_acpi ata_generic ata_piix libata scsi_mod floppy [last unloaded: microcode]
> [75165.884002]
> [75165.884002] Pid: 18615, comm: btrfs Not tainted 3.0.0-rc3test #1 FUJITSU-SV      PRIMERGY            /D2399
> [75165.884002] RIP: 0010:[<ffffffffa02dede3>]  [<ffffffffa02dede3>] do_relocation+0x163/0x44b [btrfs]
> [75165.884002] RSP: 0018:ffff8801026f7a08  EFLAGS: 00010202
> [75165.884002] RAX: 0000000000000001 RBX: ffff8801949e7c00 RCX: 0000000000000002
> [75165.884002] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
> [75165.884002] RBP: ffff8801026f7ad8 R08: 00000000000006c7 R09: ffff8801026f78f0
> [75165.884002] R10: ffff88009f9d7800 R11: 0000000442149000 R12: ffff880037c99180
> [75165.884002] R13: ffff880152695f30 R14: ffff88009f9d4800 R15: ffff88013cfdbf78
> [75165.884002] FS:  00007f490c045740(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
> [75165.884002] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [75165.884002] CR2: 00000033cfea6a60 CR3: 0000000100d47000 CR4: 00000000000006f0
> [75165.884002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [75165.884002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [75165.884002] Process btrfs (pid: 18615, threadinfo ffff8801026f6000, task ffff880102060000)
> [75165.884002] Stack:
> [75165.884002]  ffff88000516d000 ffff88009f9d7d80 00000001026f7a98 ffff880037c99180
> [75165.884002]  ffff880037c991c0 000000019f9d7820 ffff88011bf09ba0 ffff88009f9d7800
> [75165.884002]  ffff8801026f7ad8 ffff88011bf094c0 ffff88013cfdbf78 00ff88009f9d7800
> [75165.884002] Call Trace:
> [75165.884002]  [<ffffffffa02926ec>] ? block_rsv_add_bytes+0x24/0x4d [btrfs]
> [75165.884002]  [<ffffffffa02e137a>] relocate_tree_blocks+0x2fb/0x4a9 [btrfs]
> [75165.884002]  [<ffffffffa02de227>] ? add_tree_block+0xff/0x121 [btrfs]
> [75165.884002]  [<ffffffffa02e1b13>] relocate_block_group+0x214/0x4dc [btrfs]
> [75165.884002]  [<ffffffffa02e1f26>] btrfs_relocate_block_group+0x14b/0x285 [btrfs]
> [75165.884002]  [<ffffffffa02c7183>] ? btrfs_relocate_chunk+0x4a4/0x50d [btrfs]
> [75165.884002]  [<ffffffffa02c6d48>] btrfs_relocate_chunk+0x69/0x50d [btrfs]
> [75165.884002]  [<ffffffffa028b3f5>] ? btrfs_item_key_to_cpu+0x1a/0x36 [btrfs]
> [75165.884002]  [<ffffffffa02c0d0f>] ? read_extent_buffer+0xba/0xf6 [btrfs]
> [75165.884002]  [<ffffffffa02c561a>] ? btrfs_item_key_to_cpu+0x2a/0x46 [btrfs]
> [75165.884002]  [<ffffffffa02c77be>] btrfs_balance+0x1ca/0x219 [btrfs]
> [75165.884002]  [<ffffffffa02cfcbd>] btrfs_ioctl+0x922/0xc19 [btrfs]
> [75165.884002]  [<ffffffff810e88e4>] ? handle_mm_fault+0x233/0x24a
> [75165.884002]  [<ffffffff813a6be5>] ? do_page_fault+0x340/0x3b2
> [75165.884002]  [<ffffffff8111d828>] do_vfs_ioctl+0x474/0x4c3
> [75165.884002]  [<ffffffff810ffe41>] ? virt_to_head_page+0xe/0x31
> [75165.884002]  [<ffffffff811010e8>] ? kmem_cache_free+0x20/0xae
> [75165.884002]  [<ffffffff8111d8cd>] sys_ioctl+0x56/0x79
> [75165.884002]  [<ffffffff813aa302>] system_call_fastpath+0x16/0x1b
> [75165.884002] Code: 00 00 48 8b 95 60 ff ff ff 45 31 c0 41 b9 01 00 00 00 4c 89 e9 4c 89 f6 4c 89 ff e8 52 15 fb ff 83 f8 00 0f 8c e6 02 00 00 74 04 <0f> 0b eb fe 48 8b 53 68 0f b6 43 70 48 85 d2 75 14 49 8b 54 c5
> [75165.884002] RIP  [<ffffffffa02dede3>] do_relocation+0x163/0x44b [btrfs]
> [75165.884002]  RSP <ffff8801026f7a08>
> 
> (gdb) l *do_relocation+0x163
> 0x58e07 is in do_relocation (fs/btrfs/relocation.c:2502).
> 2497                            ret = btrfs_search_slot(trans, root, key, path, 0, 1);
> 2498                            if (ret < 0) {
> 2499                                    err = ret;
> 2500                                    break;
> 2501                            }
> 2502                            BUG_ON(ret > 0);

this translates btrfs_search_slot() result to

1600  * If the key isn't found, the path points to the slot where it should
1601  * be inserted, and 1 is returned.  If there are other errors during the
1602  * search a negative error number is returned.

ie. the key is not in the tree. If you can reproduce it reliably, add
some printks about the key and path's ->search_commit_root,
->skip_locking, and ->leave_spinning which are accessed within
btrfs_search_slot().


david
