From: Ed Tomlinson <edt@aei.ca>
Subject: [OPPS] btrfs on 33-3 with latest from btrfs-unstable.git master
Date: Sat, 8 May 2010 16:43:08 -0400
Message-ID: <201005081643.08726.edt@aei.ca>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: linux-kernel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I had a problem that forced me to reboot.  Post reboot btrfsfsck (from git) dies with:

[  523.753878] device fsid 142fc9ee92a20d2-f998b64b009f85a7 devid 3 transid 1099996 /dev/sda4
[  523.767056] device fsid 142fc9ee92a20d2-f998b64b009f85a7 devid 1 transid 1099996 /dev/sdc3
[  523.798512] device fsid 142fc9ee92a20d2-f998b64b009f85a7 devid 2 transid 1099996 /dev/sdb4
[  530.272331] btrfsck[4441]: segfault at c4 ip 0000000000413a78 sp 00007fffb64fdae0 error 4 in btrfsck[400000+24000]

and the mounting the fs with: mount -tbtrfs /dev/sdc3 /mnt/sdc3
causes the following opps:

[ 2300.375718] device fsid 142fc9ee92a20d2-f998b64b009f85a7 devid 1 transid 1099996 /dev/sdc3
[ 2302.319429] btrfs: sdb4 checksum verify failed on 1317523083264 wanted 769383BA found A6555473 level 0
[ 2302.329240] btrfs: sdb4 checksum verify failed on 1317523083264 wanted 769383BA found A6555473 level 0
[ 2302.338892] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[ 2302.339860] IP: [<ffffffffa04e42c1>] btrfs_print_leaf+0x21/0x920 [btrfs]
[ 2302.339860] PGD 1597ee067 PUD 14a06e067 PMD 0 
[ 2302.339860] Oops: 0000 [#1] PREEMPT SMP 
[ 2302.339860] last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/temp1_input
[ 2302.339860] CPU 1 
[ 2302.339860] Pid: 5369, comm: mount Not tainted 2.6.33.3-crc #125 M3A78-T/System Product Name
[ 2302.339860] RIP: 0010:[<ffffffffa04e42c1>]  [<ffffffffa04e42c1>] btrfs_print_leaf+0x21/0x920 [btrfs]
[ 2302.339860] RSP: 0018:ffff88014b0cf698  EFLAGS: 00010283
[ 2302.339860] RAX: 00000000fffffffb RBX: ffff880169dd8000 RCX: 0000000000000000
[ 2302.339860] RDX: 0000000000000008 RSI: 0000000000000000 RDI: ffff88016a97d000
[ 2302.339860] RBP: ffff88014b0cf718 R08: 0000000000000002 R09: 0000000000000000
[ 2302.339860] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000fffffffb
[ 2302.339860] R13: ffff88016a97d000 R14: 0000000000000002 R15: 00000132c2849000
[ 2302.339860] FS:  00007f0cab085740(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
[ 2302.339860] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2302.339860] CR2: 0000000000000030 CR3: 000000016b409000 CR4: 00000000000006e0
[ 2302.339860] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2302.339860] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2302.339860] Process mount (pid: 5369, threadinfo ffff88014b0ce000, task ffff88016b668000)
[ 2302.339860] Stack:
[ 2302.339860]  ffff880169dd8000 00000132c2849000 ffff88014b0cf6b8 ffff88016a97d000
[ 2302.339860] <0> ffff88014b0cf708 ffff88014a9bc000 00000132c2849000 00000000001000a8
[ 2302.339860] <0> 0000000000000000 ffff8801499c2c60 00000000fffffff4 ffff880169dd8000
[ 2302.339860] Call Trace:
[ 2302.339860]  [<ffffffffa04dda18>] __btrfs_free_extent+0x818/0x9c0 [btrfs]
[ 2302.339860]  [<ffffffff8125051e>] ? do_raw_spin_lock+0xde/0x1d0
[ 2302.339860]  [<ffffffff81081e49>] ? trace_hardirqs_on_caller+0x29/0x190
[ 2302.339860]  [<ffffffffa04def2f>] run_one_delayed_ref+0x55f/0x710 [btrfs]
[ 2302.339860]  [<ffffffff81081f00>] ? trace_hardirqs_on_caller+0xe0/0x190
[ 2302.339860]  [<ffffffff814c9eb7>] ? mutex_trylock+0x117/0x250
[ 2302.339860]  [<ffffffffa052cb5c>] ? btrfs_delayed_ref_lock+0x5c/0xc0 [btrfs]
[ 2302.339860]  [<ffffffff814d063e>] ? sub_preempt_count+0xe/0x60
[ 2302.339860]  [<ffffffffa04dffa4>] run_clustered_refs+0xc4/0x430 [btrfs]
[ 2302.339860]  [<ffffffffa04e03dd>] btrfs_run_delayed_refs+0xcd/0x290 [btrfs]
[ 2302.339860]  [<ffffffffa04f0919>] btrfs_commit_transaction+0x89/0x7c0 [btrfs]
[ 2302.339860]  [<ffffffff81081e49>] ? trace_hardirqs_on_caller+0x29/0x190
[ 2302.339860]  [<ffffffff81081fbd>] ? trace_hardirqs_on+0xd/0x10
[ 2302.339860]  [<ffffffff81117611>] ? kmem_cache_free+0x111/0x1e0
[ 2302.339860]  [<ffffffff8106ccf0>] ? autoremove_wake_function+0x0/0x40
[ 2302.339860]  [<ffffffffa0525ff9>] btrfs_recover_log_trees+0x379/0x3a0 [btrfs]
[ 2302.339860]  [<ffffffffa0526580>] ? replay_one_buffer+0x0/0x450 [btrfs]
[ 2302.339860]  [<ffffffffa04ec283>] ? btree_read_extent_buffer_pages+0x73/0xb0 [btrfs]
[ 2302.339860]  [<ffffffffa04eed2a>] open_ctree+0x146a/0x1640 [btrfs]
[ 2302.339860]  [<ffffffff811883b4>] ? disk_name+0x64/0xc0
[ 2302.339860]  [<ffffffffa04cd285>] btrfs_get_sb+0x305/0x490 [btrfs]
[ 2302.339860]  [<ffffffff8111e450>] ? __alloc_percpu+0x10/0x20
[ 2302.339860]  [<ffffffff811255e2>] vfs_kern_mount+0x72/0x1c0
[ 2302.339860]  [<ffffffff811257a5>] do_kern_mount+0x55/0x150
[ 2302.339860]  [<ffffffff814ccf33>] ? _lock_kernel+0x143/0x1e0
[ 2302.339860]  [<ffffffff811415c2>] do_mount+0x2d2/0x850
[ 2302.339860]  [<ffffffff810f6dea>] ? might_fault+0x7a/0xd0
[ 2302.339860]  [<ffffffff810f2d99>] ? strndup_user+0x69/0xc0
[ 2302.339860]  [<ffffffff81141c0f>] sys_mount+0xcf/0x110
[ 2302.339860]  [<ffffffff81002adb>] system_call_fastpath+0x16/0x1b
[ 2302.339860] Code: e0 5b 44 89 e0 41 5c c9 c3 90 55 48 89 e5 48 83 c4 80 48 89 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 0f 1f 44 00 00 <4c> 8b 66 30 49 89 fe bf 01 00 00 00 48 89 f3 e8 bb c3 fe e0 48 
[ 2302.339860] RIP  [<ffffffffa04e42c1>] btrfs_print_leaf+0x21/0x920 [btrfs]
[ 2302.339860]  RSP <ffff88014b0cf698>
[ 2302.339860] CR2: 0000000000000030
[ 2302.343138] ---[ end trace e68668d9a065c83e ]---

idea?

TIA
Ed Tomlinson
