Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55415 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3KBBeh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Nov 2013 21:34:37 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 807777C0428
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Nov 2013 19:34:36 -0600 (MDT)
Date: Fri, 1 Nov 2013 21:34:33 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: BJ Quinn <bj@placs.net>
CC: <linux-btrfs@vger.kernel.org>, Jan Schmidt <list.btrfs@jan-o-sch.net>,
        bo li liu <bo.li.liu@oracle.com>
Subject: Re: kernel BUG at fs/btrfs/ctree.c:2964!
Message-ID: <20131102013433.GF16855@localhost.localdomain>
References: <9373586.6792.1377013412620.JavaMail.root@mail.placs.net>
 <22207009.1532.1383352121296.JavaMail.root@mail.placs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <22207009.1532.1383352121296.JavaMail.root@mail.placs.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 01, 2013 at 07:28:41PM -0500, BJ Quinn wrote:
> I keep running into this issue --
> 
> Oct 31 19:45:26 localhost kernel: kernel BUG at fs/btrfs/ctree.c:2964!
> Oct 31 19:45:26 localhost kernel: invalid opcode: 0000 [#2] SMP 
> Oct 31 19:45:26 localhost kernel: Modules linked in: des_generic ecb md4 nls_utf8 cifs fscache dns_resolver usb_storage fuse ip6table_filter ip6_tables 
> ebtable_nat ebtables autofs4 bnx2fc cnic uio fcoe libfcoe libfc scsi_transport_fc scsi_t
> gt 8021q garp sunrpc bridge stp llc ipv6 ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM iptable_mangle xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables btrfs raid6_pq xor libcrc32c vhost_net macvtap macvlan vhost tun kvm_intel kvm uinput iTCO_wdt iTCO_vendor_support dcdbas i2c_i801 pcspkr microcode sg lpc_ich bnx2 freq_table mperf ext4 jbd2 mbcache sd_mod crc_t10dif sr_mod cdrom pata_acpi ata_generic pata_jmicron ahci libahci mgag200 ttm drm_kms_helper sysimgblt sysfillrect syscopyarea dm_mirror dm_region_hash dm_log dm_mod
> Oct 31 19:45:26 localhost kernel: CPU: 3 PID: 6245 Comm: btrfs-endio-wri Tainted: G      D      3.11.4-1.el6.elrepo.x86_64 #1
> Oct 31 19:45:26 localhost kernel: Hardware name: Dell Inc. PowerEdge R210 II/09T7VV, BIOS 1.2.3 07/21/2011
> Oct 31 19:45:26 localhost kernel: task: ffff880428ed2040 ti: ffff8803b041c000 task.ti: ffff8803b041c000
> Oct 31 19:45:26 localhost kernel: RIP: 0010:[<ffffffffa02cde10>]  [<ffffffffa02cde10>] btrfs_set_item_key_safe+0x190/0x1d0 [btrfs]
> Oct 31 19:45:26 localhost kernel: RSP: 0018:ffff8803b041dac8  EFLAGS: 00010287
> Oct 31 19:45:26 localhost kernel: RAX: 0000000000046738 RBX: 000000000000001d RCX: 0000000000b5b000
> Oct 31 19:45:26 localhost kernel: RDX: 000000000000006c RSI: 0000000000b4b000 RDI: ffff8803b041dae9
> Oct 31 19:45:26 localhost kernel: RBP: ffff8803b041db28 R08: 0000000000001000 R09: ffff8803b041dae0
> Oct 31 19:45:26 localhost kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff880325147e20
> Oct 31 19:45:26 localhost kernel: R13: ffff8803b041dc08 R14: ffff8803b041dad8 R15: ffff8801785b4d00
> Oct 31 19:45:26 localhost kernel: FS:  0000000000000000(0000) GS:ffff88043fcc0000(0000) knlGS:0000000000000000
> Oct 31 19:45:26 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Oct 31 19:45:26 localhost kernel: CR2: ffffffffff600400 CR3: 0000000001c0c000 CR4: 00000000000407e0
> Oct 31 19:45:26 localhost kernel: Stack:
> Oct 31 19:45:26 localhost kernel: ffff8803b041db28 ffff8804007ef000 0000000000046738 00000000b4b0006c
> Oct 31 19:45:26 localhost kernel: 0000000000000000 ffff88022d617000 ffff8803b041db28 ffff8801785b4d00
> Oct 31 19:45:26 localhost kernel: ffff880325147e20 0000000000b63000 0000000000b43000 0000000000000001
> Oct 31 19:45:26 localhost kernel: Call Trace:
> Oct 31 19:45:26 localhost kernel: [<ffffffffa030b23d>] __btrfs_drop_extents+0x59d/0xb90 [btrfs]
> Oct 31 19:45:26 localhost kernel: [<ffffffff8118e7c5>] ? kmem_cache_alloc+0x275/0x280
> Oct 31 19:45:26 localhost kernel: [<ffffffffa030c343>] btrfs_drop_extents+0x73/0xa0 [btrfs]
> Oct 31 19:45:26 localhost kernel: [<ffffffffa02fc33c>] insert_reserved_file_extent.clone.0+0x7c/0x290 [btrfs]
> Oct 31 19:45:26 localhost kernel: [<ffffffffa02f7859>] ? start_transaction+0x99/0x4e0 [btrfs]
> Oct 31 19:45:26 localhost kernel: [<ffffffffa0304082>] btrfs_finish_ordered_io+0x452/0x4f0 [btrfs]
> Oct 31 19:45:26 localhost kernel: [<ffffffffa0304135>] finish_ordered_fn+0x15/0x20 [btrfs]
> Oct 31 19:45:26 localhost kernel: [<ffffffffa03254fc>] worker_loop+0x15c/0x4b0 [btrfs]
> Oct 31 19:45:26 localhost kernel: [<ffffffffa03253a0>] ? check_pending_worker_creates+0xe0/0xe0 [btrfs]
> Oct 31 19:45:26 localhost kernel: [<ffffffffa03253a0>] ? check_pending_worker_creates+0xe0/0xe0 [btrfs]
> Oct 31 19:45:26 localhost kernel: [<ffffffff8108a14e>] kthread+0xce/0xe0
> Oct 31 19:45:26 localhost kernel: [<ffffffff8108a080>] ? kthread_freezable_should_stop+0x70/0x70
> Oct 31 19:45:26 localhost kernel: [<ffffffff81604bac>] ret_from_fork+0x7c/0xb0
> Oct 31 19:45:26 localhost kernel: [<ffffffff8108a080>] ? kthread_freezable_should_stop+0x70/0x70
> Oct 31 19:45:26 localhost kernel: Code: 8b 7d f8 c9 c3 66 0f 1f 44 00 00 72 1e 41 0f b6 55 08 38 d1 76 0d 49 8b 4d 09 eb 8c 0f 1f 80 00 00 00 00 73 2e 66 0f 1f 44 00 00 <0f> 0b eb fe 0f 1f 40 00 49 3b 55 09 0f 1f 40 00 0f 87 c3 fe ff 
> Oct 31 19:45:26 localhost kernel: RIP  [<ffffffffa02cde10>] btrfs_set_item_key_safe+0x190/0x1d0 [btrfs]
> Oct 31 19:45:26 localhost kernel: RSP <ffff8803b041dac8>
> 
> All Google will tell me related to errors in btrfs_set_item_key_safe is some vague references to memory corruption.  As I have gotten this error on several machines with different types of hardware, memory, and storage, I don't think that's the issue in my case.  I've seen what looks to be the same issue (with slightly differing line numbers in ctree.c) over several kernel versions.  Currently I'm at 3.11.4, although I remember having this issue at least as far back as 3.7 or 3.8.  It's possible that the issue predates that as well, but I was having different issues at the time as well, so I can't be sure.
> 
> All I can tell that I might be doing differently is that I generally have a fairly large filesystem with lots of snapshots and my mount options, which are noatime,nodiratime,compress-force=zlib,inode_cache.  I did mount once with space_cache.  The system that is currently having the issue has a 4x3TB striped array (btrfs is handling the RAID) =12TB, but I also got it multiple times on a system with a single 500GB SSD, but there were lots of snapshots (read: 100s) of 100GB+ of compressed data.  Much of what I'm doing is backups, so I have a daily snapshot of large amounts of highly compressible data that changes <1% daily.
> 
> Sometimes I can work around the issue by deleting the offending snapshot (I get hangs that require a hard reboot during the backup process) and retrying.

On this box can you run

gdb btrfs.ko
list *(__btrfs_drop_extents+0x59d)

I want to know where exactly this is coming from so I can start trying to figure
out how it's happening.  Thanks,

Josef
