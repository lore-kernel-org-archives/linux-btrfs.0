From: Skylar Burtenshaw <daninfuchs@gmail.com>
Subject: Re: Can't mount, power failure - recoverable?
Date: Sat, 17 Mar 2012 19:06:14 +0000 (UTC)
Message-ID: <loom.20120317T192345-893@post.gmane.org>
References: <loom.20120317T051243-551@post.gmane.org> <CAE5mzvi8oX4B+yriTRnj_g+_a3=BoC-o1BSRs4PpJsAMBOP5xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> The stack trace would be a start :p


Here's the trace. Mount attempt using 3.2.0;

[ 39.873019] device label SolaceNetArray devid 20 transid 267118 /dev/sda3
[ 39.894154] btrfs: disk space caching is enabled
[ 62.383043] BUG: unable to handle kernel NULL pointer dereference at
00000000000000d0
[ 62.383114] IP: [<ffffffffa0021161>] btrfs_put_block_group+0x11/0x70 [btrfs]
[ 62.383190] PGD 78e80067 PUD 79588067 PMD 0
[ 62.383231] Oops: 0002 [#1] SMP
[ 62.383261] CPU 0
[ 62.383277] Modules linked in: aoe radeon ttm nfsd drm_kms_helper drm nfs lockd
k8temp fscache auth_rpcgss nfs_acl lp i2c_algo_bit edac_core edac_mce_amd
i2c_nforce2 psmouse asus_atk0110 serio_raw parport sunrpc usbhid hid 3w_9xxx
floppy sata_promise pata_sil680 sata_nv forcedeth pata_amd sky2 sata_sil24 nbd
btrfs zlib_deflate libcrc32c
[ 62.383583]
[ 62.383597] Pid: 1764, comm: mount Not tainted 3.2.0-030200-generic
#201201042035 System manufacturer
System Product Name/A8N32-SLI-Deluxe
[ 62.383692] RIP: 0010:[<ffffffffa0021161>] [<ffffffffa0021161>]
btrfs_put_block_group+0x11/0x70
[btrfs]
[ 62.383772] RSP: 0018:ffff880078e79568 EFLAGS: 00010292
[ 62.383810] RAX: ffff880072e35000 RBX: 0000000000000000 RCX: 0000160000000000
[ 62.383861] RDX: 000000000004136e RSI: 0000000040000000 RDI: 0000000000000000
[ 62.383912] RBP: ffff880078e79578 R08: 0000000000000000 R09: 0000000000000002
[ 62.383962] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007b3ca000
[ 62.384013] R13: 0000000000000000 R14: ffff880077daa048 R15: ffff880000000000
[ 62.384064] FS: 00007f95889927e0(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[ 62.384121] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 62.384162] CR2: 00000000000000d0 CR3: 0000000078c90000 CR4: 00000000000006f0
[ 62.384213] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 62.384263] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 62.384314] Process mount (pid: 1764, threadinfo ffff880078e78000, task
ffff88007ab90000)
[ 62.384371] Stack:
[ 62.386171] ffff880078e79578 ffff8800729e9320 ffff880078e795d8 ffffffffa0024bdf
[ 62.386928] ffff880000000002 0000000000000000 ffff880077ff8190 000000000004136f
[ 62.386928] ffff880078e795d8 ffff88007b3ca000 ffff880072ba6460 ffff8800729e9320
[ 62.386928] Call Trace:
[ 62.386928] [<ffffffffa0024bdf>] btrfs_free_tree_block+0xef/0x1a0 [btrfs]
[ 62.386928] [<ffffffffa001b99a>] __btrfs_cow_block+0x2ca/0x4b0 [btrfs]
[ 62.386928] [<ffffffffa001c14e>] btrfs_cow_block+0xee/0x200 [btrfs]
[ 62.386928] [<ffffffffa001ee68>] btrfs_search_slot+0x328/0x730 [btrfs]
[ 62.386928] [<ffffffffa002919c>] lookup_inline_extent_backref+0xbc/0x400 [btrfs]
[ 62.386928] [<ffffffff811674ad>] ? kmem_cache_alloc+0xcd/0x120
[ 62.386928] [<ffffffffa002ac56>] __btrfs_free_extent+0xd6/0x700 [btrfs]
[ 62.386928] [<ffffffff8107720c>] ? lock_timer_base+0x3c/0x70
[ 62.386928] [<ffffffff81138c58>] ? bdi_wakeup_thread_delayed+0x38/0x40
[ 62.386928] [<ffffffffa002b3da>] run_delayed_tree_ref+0x15a/0x160 [btrfs]



