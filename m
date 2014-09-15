Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:55786 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759253AbaIOWkZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 18:40:25 -0400
Received: from cpe-67-240-76-244.nycap.res.rr.com ([67.240.76.244] helo=[192.168.5.80])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:ECDHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.83)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1XTewa-00069J-0Z
	for linux-btrfs@vger.kernel.org; Mon, 15 Sep 2014 18:40:24 -0400
Message-ID: <54176AD7.7040403@intellasoft.net>
Date: Mon, 15 Sep 2014 18:40:23 -0400
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs balance enospc
References: <541706ED.4010901@intellasoft.net> <20140915170722.GA9160@sune> <541723EA.6010608@intellasoft.net> <657EBB8A-8957-4E07-829E-171A1FF702E8@colorremedies.com>
In-Reply-To: <657EBB8A-8957-4E07-829E-171A1FF702E8@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is with debugging:

cartman {~} root# btrfs balance start /
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
cartman {~} root#


Sep 15 18:31:47 localhost kernel: BTRFS info (device sdg6): disk space 
caching is enabled
Sep 15 18:31:47 localhost kernel: BTRFS info (device sdg6): disk space 
caching is enabled
Sep 15 18:31:47 localhost kernel: BTRFS info (device sdi): disk space 
caching is enabled
Sep 15 18:31:47 localhost kernel: BTRFS: bdev /dev/sdd7 errs: wr 418589, 
rd 444362, flush 11, corrupt 0, gen 0
Sep 15 18:31:47 localhost kernel: r8169 0000:02:00.0 eth0: link down
Sep 15 18:31:47 localhost kernel: r8169 0000:02:00.0 eth0: link down
Sep 15 18:31:49 localhost kernel: r8169 0000:02:00.0 eth0: link up
Sep 15 18:36:05 localhost kernel: BTRFS info (device sdg6): relocating 
block group 86631972864 flags 20
Sep 15 18:36:11 localhost kernel: BTRFS info (device sdg6): found 872 
extents
Sep 15 18:36:11 localhost kernel: ------------[ cut here ]------------
Sep 15 18:36:11 localhost kernel: WARNING: CPU: 1 PID: 3763 at 
fs/btrfs/extent-tree.c:7273 btrfs_alloc_free_block+0x455/0x4a0()
Sep 15 18:36:11 localhost kernel: BTRFS: block rsv returned -28
Sep 15 18:36:11 localhost kernel: Modules linked in:
Sep 15 18:36:11 localhost kernel: CPU: 1 PID: 3763 Comm: tail Not 
tainted 3.16.1 #2
Sep 15 18:36:11 localhost kernel: Hardware name: Gigabyte Technology 
Co., Ltd. GA-MA74GM-S2/GA-MA74GM-S2, BIOS F1 04/17/2008
Sep 15 18:36:11 localhost kernel: 0000000000000000 ffffffff819e3610 
ffffffff817e4409 ffff88006ee2fa68
Sep 15 18:36:11 localhost kernel: ffffffff8106f6f2 ffff880073fc9e00 
ffff88007525b000 0000000000001000
Sep 15 18:36:11 localhost kernel: ffff880072f58280 ffff880074196000 
ffffffff8106f7d5 ffffffff819f5978
Sep 15 18:36:11 localhost kernel: Call Trace:
Sep 15 18:36:11 localhost kernel: [<ffffffff817e4409>] ? 
dump_stack+0x49/0x6a
Sep 15 18:36:11 localhost kernel: [<ffffffff8106f6f2>] ? 
warn_slowpath_common+0x82/0xb0
Sep 15 18:36:11 localhost kernel: [<ffffffff8106f7d5>] ? 
warn_slowpath_fmt+0x45/0x50
Sep 15 18:36:11 localhost kernel: [<ffffffff8135f074>] ? 
___ratelimit+0x94/0x100
Sep 15 18:36:11 localhost kernel: [<ffffffff81296625>] ? 
btrfs_alloc_free_block+0x455/0x4a0
Sep 15 18:36:11 localhost kernel: [<ffffffff810992b7>] ? 
set_next_entity+0x37/0x80
Sep 15 18:36:11 localhost kernel: [<ffffffff812ca111>] ? 
read_extent_buffer+0xb1/0x110
Sep 15 18:36:11 localhost kernel: [<ffffffff81091de9>] ? 
finish_task_switch+0x49/0xe0
Sep 15 18:36:11 localhost kernel: [<ffffffff81280d9f>] ? 
btrfs_copy_root+0xef/0x2a0
Sep 15 18:36:11 localhost kernel: [<ffffffff812f1853>] ? 
create_reloc_root+0x1e3/0x2a0
Sep 15 18:36:11 localhost kernel: [<ffffffff812f7848>] ? 
btrfs_init_reloc_root+0xb8/0xd0
Sep 15 18:36:11 localhost kernel: [<ffffffff812a708f>] ? 
record_root_in_trans+0xaf/0x110
Sep 15 18:36:11 localhost kernel: [<ffffffff812a8496>] ? 
btrfs_record_root_in_trans+0x46/0x80
Sep 15 18:36:11 localhost kernel: [<ffffffff812a98fc>] ? 
start_transaction+0x8c/0x4f0
Sep 15 18:36:11 localhost kernel: [<ffffffff812b1168>] ? 
btrfs_dirty_inode+0x58/0xe0
Sep 15 18:36:11 localhost kernel: [<ffffffff8113b382>] ? 
touch_atime+0x152/0x160
Sep 15 18:36:11 localhost kernel: [<ffffffff810e3eb5>] ? 
generic_file_read_iter+0x545/0x5a0
Sep 15 18:36:11 localhost kernel: [<ffffffff810a1d49>] ? 
remove_wait_queue+0x19/0x60
Sep 15 18:36:11 localhost kernel: [<ffffffff810a1bc4>] ? 
prepare_to_wait+0x24/0x90
Sep 15 18:36:11 localhost kernel: [<ffffffff81122493>] ? 
new_sync_read+0x73/0xa0
Sep 15 18:36:11 localhost kernel: [<ffffffff811230ae>] ? vfs_read+0x9e/0x170
Sep 15 18:36:11 localhost kernel: [<ffffffff8112332f>] ? SyS_read+0x4f/0xd0
Sep 15 18:36:11 localhost kernel: [<ffffffff817eae12>] ? 
system_call_fastpath+0x16/0x1b
Sep 15 18:36:11 localhost kernel: ---[ end trace 8efb39cc34150d60 ]---
Sep 15 18:36:12 localhost kernel: BTRFS info (device sdg6): relocating 
block group 86598418432 flags 18
Sep 15 18:36:14 localhost kernel: BTRFS info (device sdg6): found 1 extents
Sep 15 18:36:15 localhost kernel: BTRFS info (device sdg6): relocating 
block group 86329982976 flags 20
Sep 15 18:36:49 localhost kernel: BTRFS info (device sdg6): found 55332 
extents
Sep 15 18:36:50 localhost kernel: BTRFS info (device sdg6): relocating 
block group 86061547520 flags 20
Sep 15 18:37:14 localhost kernel: BTRFS info (device sdg6): found 57486 
extents
Sep 15 18:37:14 localhost kernel: use_block_rsv: 2 callbacks suppressed
Sep 15 18:37:14 localhost kernel: ------------[ cut here ]------------
Sep 15 18:37:14 localhost kernel: WARNING: CPU: 1 PID: 3763 at 
fs/btrfs/extent-tree.c:7273 btrfs_alloc_free_block+0x455/0x4a0()
Sep 15 18:37:14 localhost kernel: BTRFS: block rsv returned -28
Sep 15 18:37:14 localhost kernel: Modules linked in:
Sep 15 18:37:14 localhost kernel: CPU: 1 PID: 3763 Comm: tail Tainted: G 
        W     3.16.1 #2
Sep 15 18:37:14 localhost kernel: Hardware name: Gigabyte Technology 
Co., Ltd. GA-MA74GM-S2/GA-MA74GM-S2, BIOS F1 04/17/2008
Sep 15 18:37:14 localhost kernel: 0000000000000000 ffffffff819e3610 
ffffffff817e4409 ffff88006ee2fa68
Sep 15 18:37:14 localhost kernel: ffffffff8106f6f2 ffff880073fc9da0 
ffff88007525b000 0000000000001000
Sep 15 18:37:14 localhost kernel: ffff880035e393c0 ffff880074196000 
ffffffff8106f7d5 ffffffff819f5978
Sep 15 18:37:14 localhost kernel: Call Trace:
Sep 15 18:37:14 localhost kernel: [<ffffffff817e4409>] ? 
dump_stack+0x49/0x6a
Sep 15 18:37:14 localhost kernel: [<ffffffff8106f6f2>] ? 
warn_slowpath_common+0x82/0xb0
Sep 15 18:37:14 localhost kernel: [<ffffffff8106f7d5>] ? 
warn_slowpath_fmt+0x45/0x50
Sep 15 18:37:14 localhost kernel: [<ffffffff8135f074>] ? 
___ratelimit+0x94/0x100
Sep 15 18:37:14 localhost kernel: [<ffffffff81296625>] ? 
btrfs_alloc_free_block+0x455/0x4a0
Sep 15 18:37:14 localhost kernel: [<ffffffff810992b7>] ? 
set_next_entity+0x37/0x80
Sep 15 18:37:14 localhost kernel: [<ffffffff812ca111>] ? 
read_extent_buffer+0xb1/0x110
Sep 15 18:37:14 localhost kernel: [<ffffffff81091de9>] ? 
finish_task_switch+0x49/0xe0
Sep 15 18:37:14 localhost kernel: [<ffffffff81280d9f>] ? 
btrfs_copy_root+0xef/0x2a0
Sep 15 18:37:14 localhost kernel: [<ffffffff812a33b5>] ? 
btrfs_read_tree_root+0xb5/0x170
Sep 15 18:37:14 localhost kernel: [<ffffffff812f1853>] ? 
create_reloc_root+0x1e3/0x2a0
Sep 15 18:37:14 localhost kernel: [<ffffffff812f19e7>] ? 
__add_reloc_root+0x87/0x120
Sep 15 18:37:14 localhost kernel: [<ffffffff812f7848>] ? 
btrfs_init_reloc_root+0xb8/0xd0
Sep 15 18:37:14 localhost kernel: [<ffffffff812a708f>] ? 
record_root_in_trans+0xaf/0x110
Sep 15 18:37:14 localhost kernel: [<ffffffff812a8496>] ? 
btrfs_record_root_in_trans+0x46/0x80
Sep 15 18:37:14 localhost kernel: [<ffffffff812a98fc>] ? 
start_transaction+0x8c/0x4f0
Sep 15 18:37:14 localhost kernel: [<ffffffff812b1168>] ? 
btrfs_dirty_inode+0x58/0xe0
Sep 15 18:37:14 localhost kernel: [<ffffffff8113b382>] ? 
touch_atime+0x152/0x160
Sep 15 18:37:14 localhost kernel: [<ffffffff810e3eb5>] ? 
generic_file_read_iter+0x545/0x5a0
Sep 15 18:37:14 localhost kernel: [<ffffffff810a1d49>] ? 
remove_wait_queue+0x19/0x60
Sep 15 18:37:14 localhost kernel: [<ffffffff810a1bc4>] ? 
prepare_to_wait+0x24/0x90
Sep 15 18:37:14 localhost kernel: [<ffffffff81122493>] ? 
new_sync_read+0x73/0xa0
Sep 15 18:37:14 localhost kernel: [<ffffffff811230ae>] ? vfs_read+0x9e/0x170
Sep 15 18:37:14 localhost kernel: [<ffffffff8112332f>] ? SyS_read+0x4f/0xd0
Sep 15 18:37:14 localhost kernel: [<ffffffff817eae12>] ? 
system_call_fastpath+0x16/0x1b
Sep 15 18:37:14 localhost kernel: ---[ end trace 8efb39cc34150d61 ]---
Sep 15 18:37:14 localhost kernel: BTRFS info (device sdg6): relocating 
block group 84987805696 flags 17
Sep 15 18:37:24 localhost kernel: BTRFS info (device sdg6): 8 enospc 
errors during balance


>
> Maybe try mount option enospc_debug and retry, see if you get more information in dmesg.
>
> I'm not sure if a balance in this case wants to create a new data and metadata chunk (on each device), or if it can start without creating any chunks. If it wants to create new chunks, it's 1GiB for data, and 256MiB for metadata. That's 1.256GiB but you only have 1.25GiB unallocated on each device: size 9.31GiB minus used 8.06GiB.

