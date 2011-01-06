From: cwillu <cwillu@cwillu.com>
Subject: BUG in /mnt mount kills / mount as well
Date: Thu, 6 Jan 2011 17:33:19 -0600
Message-ID: <AANLkTi=62FnKd4GrCeXwjuksb8bDgLYfdWW1n+xHM_6+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After doing something silly (not sure what yet) with a server's
4-drive btrfs raid1 root, I've been booting off a 5th drive (also on
btrfs) while poking at the original array.  I've found that errors
triggered by poking around on the mounted-but-broken 4-drive raid (on
/mnt) cause the system to gradually lock up.

This is a 2.6.37rc8 build without any extra patches;  I'm going to
update to 2.6.37, although I don't expect much difference there;  I'm
also going to try a kernel built straight from btrfs-unstable/next.

[    7.846392] device fsid ef4aa1cf39b99f92-f6123d23580f395 devid 1
transid 8745 /dev/sde1
[    7.890712] device fsid e04f9a3d2d6daa99-4d8c1db77a98c8a2 devid 4
transid 28468 /dev/sdd1
[    7.952720] device fsid e04f9a3d2d6daa99-4d8c1db77a98c8a2 devid 3
transid 28468 /dev/sdc1
[    8.009989] device fsid e04f9a3d2d6daa99-4d8c1db77a98c8a2 devid 2
transid 28468 /dev/sdb1
[    8.075711] device fsid e04f9a3d2d6daa99-4d8c1db77a98c8a2 devid 1
transid 28468 /dev/sda5

The BUG that triggers it:

Jan  6 16:58:36 repository kernel: [  146.180201] ------------[ cut
here ]------------
Jan  6 16:58:36 repository kernel: [  146.190020] kernel BUG at
/home/kernel-ppa/COD/linux/fs/btrfs/extent-tree.c:5480!
Jan  6 16:58:36 repository kernel: [  146.190020] invalid opcode: 0000 [#1] SMP
Jan  6 16:58:36 repository kernel: [  146.190020] last sysfs file:
/sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
Jan  6 16:58:36 repository kernel: [  146.190020] CPU 0
Jan  6 16:58:36 repository kernel: [  146.190020] Modules linked in:
binfmt_misc ppdev ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv
Jan  6 16:58:36 repository kernel: [  146.190020]
Jan  6 16:58:36 repository kernel: [  146.190020] Pid: 4476, comm:
btrfs-transacti Not tainted 2.6.37-020637rc8-generic #201012290905 P5Q
Jan  6 16:58:36 repository kernel: [  146.190020] RIP:
0010:[<ffffffffa01ebc63>]  [<ffffffffa01ebc63>]
alloc_reserved_tree_block+0x1b3/0x
Jan  6 16:58:36 repository kernel: [  146.190020] RSP:
0000:ffff8802063b1be0  EFLAGS: 00010282
Jan  6 16:58:36 repository kernel: [  146.190020] RAX:
00000000ffffffef RBX: ffff8802060c8000 RCX: 0000000000000003
Jan  6 16:58:36 repository kernel: [  146.190020] RDX:
0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
Jan  6 16:58:36 repository kernel: [  146.190020] RBP:
ffff8802063b1c40 R08: ffff8802063b0000 R09: 0000000000000001
Jan  6 16:58:36 repository kernel: [  146.190020] R10:
0000000000000001 R11: 0000000000000001 R12: ffff880206305b40
Jan  6 16:58:36 repository kernel: [  146.190020] R13:
ffff88022c62d990 R14: ffff880206013000 R15: ffff88023f7e4600
Jan  6 16:58:36 repository kernel: [  146.190020] FS:
0000000000000000(0000) GS:ffff8800bfc00000(0000)
knlGS:0000000000000000
Jan  6 16:58:36 repository kernel: [  146.190020] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan  6 16:58:36 repository kernel: [  146.190020] CR2:
00007fbd6d9bc380 CR3: 000000021c1c1000 CR4: 00000000000006f0
Jan  6 16:58:36 repository kernel: [  146.190020] DR0:
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan  6 16:58:36 repository kernel: [  146.190020] DR3:
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan  6 16:58:36 repository kernel: [  146.190020] Process
btrfs-transacti (pid: 4476, threadinfo ffff8802063b0000, task
ffff8802063a96c0)
Jan  6 16:58:36 repository kernel: [  146.190020] Stack:
Jan  6 16:58:36 repository kernel: [  146.190020]  ffff880206305b40
0000000000000000 0000000000000005 0000000000000000
Jan  6 16:58:36 repository kernel: [  146.190020]  ffff880206013000
ffff8800bfc13a30 00000033063b1c30 ffff88022e33b0c0
Jan  6 16:58:36 repository kernel: [  146.190020]  ffff880206305b40
ffff88023f7e4600 ffff880206013000 0000000000000001
Jan  6 16:58:36 repository kernel: [  146.190020] Call Trace:
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffffa01ec781>] run_delayed_tree_ref+0x121/0x170 [btrfs]
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffff815a931e>] ? _raw_spin_lock+0xe/0x20
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffffa01ec994>] run_one_delayed_ref+0x64/0xe0 [btrfs]
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffffa01ecacb>] run_clustered_refs+0xbb/0x220 [btrfs]
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffffa01ecce0>] btrfs_run_delayed_refs+0xb0/0x200 [btrfs]
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffffa01f8a6f>] btrfs_commit_transaction+0x7f/0x620 [btrfs]
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffff815a7dbe>] ? mutex_lock+0x1e/0x50
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffff81085b70>] ? autoremove_wake_function+0x0/0x40
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffffa01f3762>] transaction_kthread+0x242/0x250 [btrfs]
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffffa01f3520>] ? transaction_kthread+0x0/0x250 [btrfs]
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffff81085497>] kthread+0x97/0xa0
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffff8100cee4>] kernel_thread_helper+0x4/0x10
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffff81085400>] ? kthread+0x0/0xa0
Jan  6 16:58:36 repository kernel: [  146.190020]
[<ffffffff8100cee0>] ? kernel_thread_helper+0x0/0x10
Jan  6 16:58:36 repository kernel: [  146.190020] Code: 84 48 02 00 eb
9d 48 8b 45 18 48 c7 c7 90 e3 23 a0 48 8b 50 09 48 8b 30 31 c0 e8
Jan  6 16:58:36 repository kernel: [  146.190020] RIP
[<ffffffffa01ebc63>] alloc_reserved_tree_block+0x1b3/0x1c0 [btrfs]
Jan  6 16:58:36 repository kernel: [  146.190020]  RSP <ffff8802063b1be0>
Jan  6 16:58:36 repository kernel: [  147.350407] ---[ end trace
88ca45c80af9162f ]---
