From: Simon Kirby <sim@hostway.ca>
Subject: 2.6.35.4 fumble-spolision
Date: Thu, 9 Sep 2010 17:17:03 -0700
Message-ID: <20100910001703.GF26862@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

We seem to have done something to our backup volumes while switching
between 2.6.33.2 and 2.6.35.4 which is now causing this crash while
booting either kernel and mounting one of the volumes.  Crash from
3.6.35.4 plus Li Zefan's free-space-cache.c patches.  extent-tree.c
is untouched, but if needed, we can try again with clean 2.6.35.4.

Simon-

device fsid b245f95d9edc2596-85b648eef09fe5b4 devid 1 transid 139257 /dev/mapper/bu002-vol02
btrfs: turning off barriers
btrfs: forcing compression
leaf 1811569336320 total ptrs 75 free space 1178
        item 0 key (2058636025856 b0 781) itemoff 3995 itemsize 0
                tree block backref
        item 1 key (2058636025856 b0 796) itemoff 3995 itemsize 0
                tree block backref
        item 2 key (2058636025856 b0 816) itemoff 3995 itemsize 0
                tree block backref
        item 3 key (2058636025856 b0 833) itemoff 3995 itemsize 0
                tree block backref
        item 4 key (2058636025856 b0 839) itemoff 3995 itemsize 0
                tree block backref
        item 5 key (2058636025856 b0 842) itemoff 3995 itemsize 0
                tree block backref
        item 6 key (2058636025856 b0 851) itemoff 3995 itemsize 0
                tree block backref
        item 7 key (2058636025856 b0 860) itemoff 3995 itemsize 0
                tree block backref
        item 8 key (2058636025856 b0 863) itemoff 3995 itemsize 0
                tree block backref
        item 9 key (2058636025856 b0 872) itemoff 3995 itemsize 0
                tree block backref
        item 10 key (2058636025856 b0 875) itemoff 3995 itemsize 0
                tree block backref
        item 11 key (2058636025856 b0 881) itemoff 3995 itemsize 0
                tree block backref
        item 12 key (2058636025856 b0 884) itemoff 3995 itemsize 0
                tree block backref
        item 13 key (2058636025856 b0 887) itemoff 3995 itemsize 0
                tree block backref
        item 14 key (2058636025856 b0 890) itemoff 3995 itemsize 0
                tree block backref
        item 15 key (2058636025856 b0 899) itemoff 3995 itemsize 0
                tree block backref
        item 16 key (2058636025856 b0 914) itemoff 3995 itemsize 0
                tree block backref
        item 17 key (2058636025856 b0 917) itemoff 3995 itemsize 0
                tree block backref
        item 18 key (2058636025856 b6 1993933545472) itemoff 3995 itemsize 0
                shared block backref
        item 19 key (2058636029952 a8 4096) itemoff 3944 itemsize 51
                extent refs 1 gen 72717 flags 258
                tree block key (7394434 c 1824613) level 0
                shared block backref parent 2058636025856
        item 20 key (2058636034048 a8 4096) itemoff 3875 itemsize 69
                extent refs 3 gen 100969 flags 258
                tree block key (9450360 1 0) level 0
                tree block backref root 795
                shared block backref parent 2058631839744
                shared block backref parent 44364496896
        item 21 key (2058636038144 a8 4096) itemoff 3824 itemsize 51
                extent refs 26 gen 90924 flags 258
                tree block key (9236717 6c 0) level 1
                tree block backref root 759
        item 22 key (2058636038144 b0 780) itemoff 3824 itemsize 0
                tree block backref
        item 23 key (2058636038144 b0 795) itemoff 3824 itemsize 0
                tree block backref
        item 24 key (2058636038144 b0 815) itemoff 3824 itemsize 0
                tree block backref
        item 25 key (2058636038144 b0 838) itemoff 3824 itemsize 0
                tree block backref
        item 26 key (2058636038144 b0 844) itemoff 3824 itemsize 0
                tree block backref
        item 27 key (2058636038144 b0 850) itemoff 3824 itemsize 0
                tree block backref
        item 28 key (2058636038144 b0 853) itemoff 3824 itemsize 0
                tree block backref
        item 29 key (2058636038144 b0 859) itemoff 3824 itemsize 0
                tree block backref
        item 30 key (2058636038144 b0 862) itemoff 3824 itemsize 0
                tree block backref
        item 31 key (2058636038144 b0 865) itemoff 3824 itemsize 0
                tree block backref
        item 32 key (2058636038144 b0 868) itemoff 3824 itemsize 0
                tree block backref
        item 33 key (2058636038144 b0 871) itemoff 3824 itemsize 0
                tree block backref
        item 34 key (2058636038144 b0 877) itemoff 3824 itemsize 0
                tree block backref
        item 35 key (2058636038144 b0 880) itemoff 3824 itemsize 0
                tree block backref
        item 36 key (2058636038144 b0 883) itemoff 3824 itemsize 0
                tree block backref
        item 37 key (2058636038144 b0 886) itemoff 3824 itemsize 0
                tree block backref
        item 38 key (2058636038144 b0 889) itemoff 3824 itemsize 0
                tree block backref
        item 39 key (2058636038144 b0 892) itemoff 3824 itemsize 0
                tree block backref
        item 40 key (2058636038144 b0 901) itemoff 3824 itemsize 0
                tree block backref
        item 41 key (2058636038144 b0 904) itemoff 3824 itemsize 0
                tree block backref
        item 42 key (2058636038144 b0 913) itemoff 3824 itemsize 0
                tree block backref
        item 43 key (2058636038144 b0 919) itemoff 3824 itemsize 0
                tree block backref
        item 44 key (2058636038144 b0 922) itemoff 3824 itemsize 0
                tree block backref
        item 45 key (2058636038144 b0 925) itemoff 3824 itemsize 0
                tree block backref
        item 46 key (2058636038144 b6 3046239690752) itemoff 3824 itemsize 0
                shared block backref
        item 47 key (2058636042240 a8 4096) itemoff 3773 itemsize 51
                extent refs 1 gen 15119 flags 258
                tree block key (5738048 60 47922) level 0
                shared block backref parent 2762299650048
        item 48 key (2058636046336 a8 4096) itemoff 3731 itemsize 42
                extent refs 10 gen 63018 flags 258
                tree block key (38795 1 0) level 1
        item 49 key (2058636046336 b0 838) itemoff 3731 itemsize 0
                tree block backref
        item 50 key (2058636046336 b0 868) itemoff 3731 itemsize 0
                tree block backref
        item 51 key (2058636046336 b0 883) itemoff 3731 itemsize 0
                tree block backref
        item 52 key (2058636046336 b0 898) itemoff 3731 itemsize 0
                tree block backref
        item 53 key (2058636046336 b6 1523466547200) itemoff 3731 itemsize 0
                shared block backref
        item 54 key (2058636046336 b6 1838262546432) itemoff 3731 itemsize 0
                shared block backref
        item 55 key (2058636046336 b6 2018665504768) itemoff 3731 itemsize 0
                shared block backref
        item 56 key (2058636046336 b6 2496621015040) itemoff 3731 itemsize 0
                shared block backref
        item 57 key (2058636046336 b6 2831420301312) itemoff 3731 itemsize 0
                shared block backref
        item 58 key (2058636046336 b6 3023954837504) itemoff 3731 itemsize 0
                shared block backref
        item 59 key (2058636054528 a8 4096) itemoff 3680 itemsize 51
                extent refs 1 gen 63018 flags 258
                tree block key (38966 60 5) level 0
                shared block backref parent 2058636046336
        item 60 key (2058636058624 a8 4096) itemoff 3629 itemsize 51
                extent refs 1 gen 63018 flags 258
                tree block key (8478409 c 39702) level 0
                shared block backref parent 2858564689920
        item 61 key (2058636066816 a8 4096) itemoff 3578 itemsize 51
                extent refs 1 gen 63018 flags 258
                tree block key (39042 c 38973) level 0
                shared block backref parent 2058636046336
        item 62 key (2058636075008 a8 4096) itemoff 3509 itemsize 69
                extent refs 3 gen 100969 flags 258
                tree block key (9450367 c 1000176) level 0
                tree block backref root 795
                shared block backref parent 2058631839744
                shared block backref parent 44364496896
        item 63 key (2058636079104 a8 4096) itemoff 3458 itemsize 51
                extent refs 1 gen 63018 flags 258
                tree block key (39048 c 39045) level 0
                shared block backref parent 2058636046336
        item 64 key (2058636083200 a8 4096) itemoff 3245 itemsize 213
                extent refs 27 gen 102425 flags 258
                tree block key (4615431 6c 0) level 1
                tree block backref root 896
                tree block backref root 893
                tree block backref root 890
                tree block backref root 887
                tree block backref root 884
                tree block backref root 881
                tree block backref root 878
                tree block backref root 875
                tree block backref root 872
                tree block backref root 869
                tree block backref root 863
                tree block backref root 860
                tree block backref root 857
                tree block backref root 854
                tree block backref root 851
                tree block backref root 842
                tree block backref root 816
                shared block backref parent 2150439845888
                shared block backref parent 2060934639616
        item 65 key (2058636083200 b0 902) itemoff 3245 itemsize 0
                tree block backref
        item 66 key (2058636083200 b0 905) itemoff 3245 itemsize 0
                tree block backref
        item 67 key (2058636083200 b0 914) itemoff 3245 itemsize 0
                tree block backref
        item 68 key (2058636083200 b0 917) itemoff 3245 itemsize 0
                tree block backref
        item 69 key (2058636083200 b0 923) itemoff 3245 itemsize 0
                tree block backref
        item 70 key (2058636083200 b0 926) itemoff 3245 itemsize 0
                tree block backref
        item 71 key (2058636083200 b0 932) itemoff 3245 itemsize 0
                tree block backref
        item 72 key (2058636083200 b6 2637838454784) itemoff 3245 itemsize 0
                shared block backref
        item 73 key (2058636099584 a8 4096) itemoff 3194 itemsize 51
                extent refs 1 gen 63018 flags 258
                tree block key (39053 54 1365479812) level 0
                shared block backref parent 2058636046336
        item 74 key (2058636103680 a8 4096) itemoff 3053 itemsize 141
                extent refs 11 gen 108180 flags 258
                tree block key (6166778 6c 0) level 2
                tree block backref root 866
                tree block backref root 863
                tree block backref root 860
                tree block backref root 857
                tree block backref root 854
                tree block backref root 851
                tree block backref root 848
                tree block backref root 845
                tree block backref root 842
                tree block backref root 833
                tree block backref root 816
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:4157 __btrfs_free_extent+0x647/0x730()
Hardware name: PowerEdge 1950
Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2
Pid: 12920, comm: btrfs-cleaner Not tainted 2.6.35.4-hw #1
Call Trace:
 [<ffffffff812cb477>] ? __btrfs_free_extent+0x647/0x730
 [<ffffffff8104c270>] warn_slowpath_common+0x80/0xd0
 [<ffffffff8104c2d5>] warn_slowpath_null+0x15/0x20
 [<ffffffff812cb477>] __btrfs_free_extent+0x647/0x730
 [<ffffffff812cb743>] ? run_clustered_refs+0x1e3/0x8c0
 [<ffffffff812cbb99>] run_clustered_refs+0x639/0x8c0
 [<ffffffff812cbee4>] btrfs_run_delayed_refs+0xc4/0x1f0
 [<ffffffff812d7018>] btrfs_should_end_transaction+0x88/0x90
 [<ffffffff812c957d>] btrfs_drop_snapshot+0x21d/0x5f0
 [<ffffffff812d578a>] btrfs_clean_old_snapshots+0x12a/0x160
 [<ffffffff812d2050>] cleaner_kthread+0x160/0x190
 [<ffffffff812d1ef0>] ? cleaner_kthread+0x0/0x190
 [<ffffffff81068f56>] kthread+0x96/0xb0
 [<ffffffff8100aca4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81068ec0>] ? kthread+0x0/0xb0
 [<ffffffff8100aca0>] ? kernel_thread_helper+0x0/0x10
---[ end trace 56165f849c424195 ]---
btrfs unable to find ref byte nr 2058636103680 parent 0 root 839  owner 2 offset 0
------------[ cut here ]------------
kernel BUG at fs/btrfs/extent-tree.c:4171!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.1/host1/target1:0:0/1:0:0:0/block/sr0/stat
CPU 3
Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2

Pid: 12920, comm: btrfs-cleaner Tainted: G        W   2.6.35.4-hw #1 0NK937/PowerEdge 1950
RIP: 0010:[<ffffffff812cb443>]  [<ffffffff812cb443>] __btrfs_free_extent+0x613/0x730
RSP: 0018:ffff880427c6db20  EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffff880428253000 RDI: ffff8804285247e0
RBP: ffff880427c6dc00 R08: ffff880427c6dad8 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000003 R12: 0000000000000000
R13: ffff8804284305a0 R14: 0000000000000065 R15: ffff8804285247e0
FS:  0000000000000000(0000) GS:ffff880001cc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f88314b7f20 CR3: 000000043847d000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-cleaner (pid: 12920, threadinfo ffff880427c6c000, task ffff88043ea712c0)
Stack:
 0000000000000000 0000000000000347 0000000000000002 0000000000000000
<0> ffff880400000000 ffff880428524480 0000000000001000 000001df50461000
<0> ffff88043cb73000 ffff880428470000 ffff880429888000 ffff88043cbaa000
Call Trace:
 [<ffffffff812cb743>] ? run_clustered_refs+0x1e3/0x8c0
 [<ffffffff812cbb99>] run_clustered_refs+0x639/0x8c0
 [<ffffffff812cbee4>] btrfs_run_delayed_refs+0xc4/0x1f0
 [<ffffffff812d7018>] btrfs_should_end_transaction+0x88/0x90
 [<ffffffff812c957d>] btrfs_drop_snapshot+0x21d/0x5f0
 [<ffffffff812d578a>] btrfs_clean_old_snapshots+0x12a/0x160
 [<ffffffff812d2050>] cleaner_kthread+0x160/0x190
 [<ffffffff812d1ef0>] ? cleaner_kthread+0x0/0x190
 [<ffffffff81068f56>] kthread+0x96/0xb0
 [<ffffffff8100aca4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81068ec0>] ? kthread+0x0/0xb0
 [<ffffffff8100aca0>] ? kernel_thread_helper+0x0/0x10
Code: 89 04 24 e8 30 ea ff ff 89 45 84 e9 ef fa ff ff 8d 43 01 41 39 45 40 0f 85 aa 00 00 00 41 89 5d 40 b8 02 00 00 00 e9 80 fe ff ff <0f> 0b eb fe 66 0f 1f 84 00 00 00 00 00 49 8b 75 00 48 8b bd 78
RIP  [<ffffffff812cb443>] __btrfs_free_extent+0x613/0x730
 RSP <ffff880427c6db20>
---[ end trace 56165f849c424196 ]---
