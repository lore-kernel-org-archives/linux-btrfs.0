From: Skylar Burtenshaw <daninfuchs@gmail.com>
Subject: Re: Can't mount, power failure - recoverable?
Date: Sun, 18 Mar 2012 18:49:13 +0000 (UTC)
Message-ID: <loom.20120318T193113-459@post.gmane.org>
References: <loom.20120317T051243-551@post.gmane.org> <CAE5mzvi8oX4B+yriTRnj_g+_a3=BoC-o1BSRs4PpJsAMBOP5xw@mail.gmail.com> <loom.20120317T192345-893@post.gmane.org> <20120318151615.GE3976@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> Looks like some of the bottom of this trace is missing.> 

That's because I'm amazing, Chris. I don't even know how that happened.. Trying
again:

BUG: unable to handle kernel NULL pointer dereference at 00000000000$
IP: [<ffffffffa0021161>] btrfs_put_block_group+0x11/0x70 [btrfs]
PGD 78e80067 PUD 79588067 PMD 0
Oops: 0002 [#1] SMP
CPU 0
Modules linked in: aoe radeon ttm nfsd drm_kms_helper drm nfs lockd k8temp
fscache auth_rpcgss nfs_acl lp i2c_algo_bit edac_core edac_mce_amd i2c_nforce2
psmouse asus_atk0110 serio_raw parport sunrpc usbhid hid 3w_9xxx floppy
sata_promise pata_sil680 sata_nv forcedeth pata_amd sky2 sata_sil24 nbd btrfs
zlib_deflate libcrc32c
Pid: 1764, comm: mount Not tainted 3.2.0-030200-generic #201201042035 System
manufacturer
        System Product Name/A8N32-SLI-Deluxe
RIP: 0010:[<ffffffffa0021161>]  [<ffffffffa0021161>]
btrfs_put_block_group+0x11/0x70 [btrfs]
RSP: 0018:ffff880078e79568  EFLAGS: 00010292
RAX: ffff880072e35000 RBX: 0000000000000000 RCX: 0000160000000000
RDX: 000000000004136e RSI: 0000000040000000 RDI: 0000000000000000
RBP: ffff880078e79578 R08: 0000000000000000 R09: 0000000000000002
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007b3ca000
R13: 0000000000000000 R14: ffff880077daa048 R15: ffff880000000000
FS:  00007f95889927e0(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000d0 CR3: 0000000078c90000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 1764, threadinfo ffff880078e78000, task ffff88007ab90000)
Stack:
 ffff880078e79578 ffff8800729e9320 ffff880078e795d8 ffffffffa0024bdf
 ffff880000000002 0000000000000000 ffff880077ff8190 000000000004136f
 ffff880078e795d8 ffff88007b3ca000 ffff880072ba6460 ffff8800729e9320
Call Trace:
 [<ffffffffa0024bdf>] btrfs_free_tree_block+0xef/0x1a0 [btrfs]
 [<ffffffffa001b99a>] __btrfs_cow_block+0x2ca/0x4b0 [btrfs]
 [<ffffffffa001c14e>] btrfs_cow_block+0xee/0x200 [btrfs]
 [<ffffffffa001ee68>] btrfs_search_slot+0x328/0x730 [btrfs]
 [<ffffffffa002919c>] lookup_inline_extent_backref+0xbc/0x400 [btrfs]
 [<ffffffff811674ad>] ? kmem_cache_alloc+0xcd/0x120
 [<ffffffffa002ac56>] __btrfs_free_extent+0xd6/0x700 [btrfs]
 [<ffffffff8107720c>] ? lock_timer_base+0x3c/0x70
 [<ffffffff81138c58>] ? bdi_wakeup_thread_delayed+0x38/0x40
 [<ffffffffa002b3da>] run_delayed_tree_ref+0x15a/0x160 [btrfs]
 [<ffffffffa00586be>] ? memcmp_extent_buffer+0x1de/0x230 [btrfs]
 [<ffffffffa002b5db>] run_one_delayed_ref+0x9b/0xc0 [btrfs]
 [<ffffffffa002b6c0>] run_clustered_refs+0xc0/0x220 [btrfs]
 [<ffffffffa002b8ea>] btrfs_run_delayed_refs+0xca/0x220 [btrfs]
 [<ffffffff81053033>] ? __wake_up+0x53/0x70
 [<ffffffffa003a1c6>] commit_cowonly_roots+0x86/0x1e0 [btrfs]
 [<ffffffffa003afff>] btrfs_commit_transaction+0x42f/0x900 [btrfs]
 [<ffffffffa003ab9d>] ? join_transaction+0x24d/0x280 [btrfs]
 [<ffffffff8108afd0>] ? wake_up_bit+0x40/0x40
 [<ffffffffa0035ae8>] btrfs_commit_super+0x88/0xd0 [btrfs]
 [<ffffffffa0036be0>] close_ctree+0x340/0x3b0 [btrfs]
 [<ffffffff8119648e>] ? iput+0x3e/0x50
 [<ffffffffa00437e4>] ? btrfs_iget+0xf4/0x110 [btrfs]
 [<ffffffffa0016226>] btrfs_fill_super+0x136/0x150 [btrfs]
 [<ffffffff81317c1a>] ? strlcpy+0x4a/0x60
 [<ffffffffa0018185>] btrfs_mount+0x335/0x370 [btrfs]
 [<ffffffff8117f1b3>] mount_fs+0x43/0x1a0
 [<ffffffff8119b633>] vfs_kern_mount+0x63/0xd0
 [<ffffffff8119b722>] do_kern_mount+0x52/0x110
 [<ffffffff812a2c3a>] ? security_capable+0x2a/0x30
 [<ffffffff8119d15d>] do_mount+0x1ed/0x240
 [<ffffffff8119d240>] sys_mount+0x90/0xe0
 [<ffffffff8164f242>] system_call_fastpath+0x16/0x1b
Code: 62 04 e1 eb cd be 95 00 00 00 48 c7 c7 48 fb 08 a0 e8 14 62 04 e1 eb cb 66
90 55 48 89 e5 53 48 83 ec 08 66 66 66 66 90 48 89 fb <f0> ff 8f d0 00 00 00 0f
94 c0 84 c0 74 22 48 83 7f 48 00 75 22
RIP  [<ffffffffa0021161>] btrfs_put_block_group+0x11/0x70 [btrfs]
 RSP <ffff880078e79568>
CR2: 00000000000000d0
---[ end trace dbfc4032ba5e601f ]---

