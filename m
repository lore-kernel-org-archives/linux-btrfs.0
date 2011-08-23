From: Avi Kivity <avi.kivity@gmail.com>
Subject: Suddenly, a dead filesystem
Date: Tue, 23 Aug 2011 17:15:46 +0300
Message-ID: <CAEbWaipxhyMf2VQRdfnpMcXwyf84YupLOm8hQRf4Q8wJu060ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been using btrfs for a while as my /home (converted from ext4;
encrypted lvm) when it died on me. =A0Mounting it crashes immediately,
here's a log:

[ =A0 =A06.455721] ------------[ cut here ]------------
[ =A0 =A06.456117] kernel BUG at fs/btrfs/inode.c:4586!
[ =A0 =A06.456117] invalid opcode: 0000 [#1] SMP
[ =A0 =A06.456117] CPU 0
[ =A0 =A06.456117] Modules linked in: btrfs zlib_deflate libcrc32c
[ =A0 =A06.456117]
[ =A0 =A06.456117] Pid: 243, comm: mount Not tainted
2.6.40.3-0.fc15.x86_64 #1 Bochs Bochs
[ =A0 =A06.456117] RIP: 0010:[<ffffffffa0035642>] =A0[<ffffffffa0035642=
>]
btrfs_add_link+0x123/0x17c [btrfs]
[ =A0 =A06.456117] RSP: 0018:ffff880007ac9838 =A0EFLAGS: 00010282
[ =A0 =A06.456117] RAX: 00000000ffffffef RBX: ffff880003ec3938 RCX: 000=
0000000000ed7
[ =A0 =A06.456117] RDX: 0000000000000ed6 RSI: 000060fff8e013b0 RDI: fff=
fea00000da3b0
[ =A0 =A06.456117] RBP: ffff880007ac98a8 R08: ffffffffa00123af R09: 000=
0000000000b23
[ =A0 =A06.456117] R10: 0000000000000b23 R11: 0000000000000002 R12: fff=
f880003ec3548
[ =A0 =A06.456117] R13: ffff880007863000 R14: 000000000000000d R15: fff=
f880007798500
[ =A0 =A06.456117] FS: =A000007effe7241820(0000) GS:ffff880006e00000(00=
00)
knlGS:0000000000000000
[ =A0 =A06.456117] CS: =A00010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ =A0 =A06.456117] CR2: 00007effe62cc580 CR3: 0000000007b7c000 CR4: 000=
00000000006f0
[ =A0 =A06.456117] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
[ =A0 =A06.456117] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000=
0000000000400
[ =A0 =A06.456117] Process mount (pid: 243, threadinfo ffff880007ac8000=
,
task ffff880002d40000)
[ =A0 =A06.456117] Stack:
[ =A0 =A06.456117] =A0ffff880000000001 00000000000002cb ffff880007ac987=
8
ffff880003e5d000
[ =A0 =A06.456117] =A00000000000000000 3fff880002c5f000 010000000000289=
4
0000000000000000
[ =A0 =A06.456117] =A00000000000001000 ffff880003e5a120 ffff880003ec354=
8
ffff880007ac99c7
[ =A0 =A06.456117] Call Trace:
[ =A0 =A06.456117] =A0[<ffffffffa005646e>] add_inode_ref+0x2e6/0x37c [b=
trfs]
[ =A0 =A06.456117] =A0[<ffffffffa00493f6>] ? read_extent_buffer+0xc3/0x=
e3 [btrfs]
[ =A0 =A06.456117] =A0[<ffffffffa0056e14>] replay_one_buffer+0x197/0x21=
2 [btrfs]
[ =A0 =A06.456117] =A0[<ffffffffa0054e94>] walk_down_log_tree+0x15a/0x2=
c1 [btrfs]
[ =A0 =A06.456117] =A0[<ffffffffa005507a>] walk_log_tree+0x7f/0x19e [bt=
rfs]
[ =A0 =A06.456117] =A0[<ffffffff8123a8d9>] ? radix_tree_lookup+0xb/0xd
[ =A0 =A06.456117] =A0[<ffffffffa0058148>] btrfs_recover_log_trees+0x28=
b/0x298 [btrfs]
[ =A0 =A06.456117] =A0[<ffffffffa0056c7d>] ? replay_one_dir_item+0xbd/0=
xbd [btrfs]
[ =A0 =A06.456117] =A0[<ffffffffa002a192>] open_ctree+0x10f1/0x13ff [bt=
rfs]
[ =A0 =A06.456117] =A0[<ffffffffa0010861>] btrfs_mount+0x233/0x496 [btr=
fs]
[ =A0 =A06.456117] =A0[<ffffffff810f43fc>] ? pcpu_next_pop+0x3d/0x4a
[ =A0 =A06.456117] =A0[<ffffffff810f54ca>] ? pcpu_alloc+0x7f7/0x833
[ =A0 =A06.456117] =A0[<ffffffff81129b74>] mount_fs+0x69/0x155
[ =A0 =A06.456117] =A0[<ffffffff810f5516>] ? __alloc_percpu+0x10/0x12
[ =A0 =A06.456117] =A0[<ffffffff8113d905>] vfs_kern_mount+0x63/0x9d
[ =A0 =A06.456117] =A0[<ffffffff8113e288>] do_kern_mount+0x4d/0xdf
[ =A0 =A06.456117] =A0[<ffffffff8113f90d>] do_mount+0x63c/0x69f
[ =A0 =A06.456117] =A0[<ffffffff810f1225>] ? memdup_user+0x55/0x7d
[ =A0 =A06.456117] =A0[<ffffffff810f1288>] ? strndup_user+0x3b/0x51
[ =A0 =A06.456117] =A0[<ffffffff8113fbf2>] sys_mount+0x88/0xc2
[ =A0 =A06.456117] =A0[<ffffffff8148e182>] system_call_fastpath+0x16/0x=
1b
[ =A0 =A06.456117] Code: 89 f1 4c 89 fa 4c 89 ee 48 89 44 24 08 41 8b 0=
4
24 66 c1 e8 0c 83 e0 0f 0f b6 80 78 eb 06 a0 89 04 24 e8 8c d5 fe ff
85 c0 74 02 <0f> 0b 45 01 f6 4d 63 f6 4c 03 b3 d0 00 00 00 4c 89 b3 d0
00 00
[ =A0 =A06.456117] RIP =A0[<ffffffffa0035642>] btrfs_add_link+0x123/0x1=
7c [btrfs]
[ =A0 =A06.456117] =A0RSP <ffff880007ac9838>
[ =A0 =A06.592232] ---[ end trace 44b5956456a7dc01 ]---

Tried btrfsck, immediate segfault.

Both kernel and btrfsprogs are stock Fedora 15. =A0I still have the
logical volume and would like to recover it. =A0Its fairly easy to try
out things in a virtual machine, so if you have a patch you want me to
try out, I'm here.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
