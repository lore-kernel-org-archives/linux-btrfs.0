From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Kernel oops when running bonnie++ on btrfs
Date: Thu, 13 Nov 2008 13:49:07 -0500
Message-ID: <20081113184907.GA16224@tux64-02>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I wanted to see how btrfs compares to other filesystems so I have been
running bonnie++ on it. While the results are good(much faster then
ext2) every once in awhile I get a kernel oops. I am testing on xubuntu
8.10 with the 2.6.27-7-686 kernel using the latest git sources. Most of the
time the oops happens within 20min of running bonnie++ but sometimes it
takes a few hours. This happens with and without compression.

To reproduce this bug you can run

while true; do bonnie++ -s 5120 -n 4:524288:0:512; done

Nov 12 22:39:12 Intrepid-btrfs kernel: [ 2531.781731] allocation failed
flags 1, wanted 4096^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.781758] space_info has
3822407680 free, is full^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814789] block group
12582912 has 8388608 bytes, 8388608 used 0 pinned 0 reserved^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814837] 0 blocks of free
space at or bigger than bytes is^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814869] block group
424542208 has 790429696 bytes, 790429696 used 0 pinned 0 reserved^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814890] 1 blocks of free
space at or bigger than bytes is^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814893] block group
1214971904 has 790429696 bytes, 790347776 used 0 pinned 0 reserved^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814896] 1 blocks of free
space at or bigger than bytes is^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814898] block group
2005401600 has 790429696 bytes, 790421504 used 0 pinned 0 reserved^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814901] 1 blocks of free
space at or bigger than bytes is^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814903] block group
2795831296 has 790429696 bytes, 4096 used 0 pinned 0 reserved^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814906] 1 blocks of free
space at or bigger than bytes is^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814909] block group
3586260992 has 790429696 bytes, 1867776 used 0 pinned 0 reserved^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814911] 1 blocks of free
space at or bigger than bytes is^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814950] block group
4376690688 has 790429696 bytes, 0 used 0 pinned 0 reserved^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814952] 0 blocks of free
space at or bigger than bytes is^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814955] block group
5167120384 has 790429696 bytes, 0 used 0 pinned 0 reserved^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814958] 0 blocks of free
space at or bigger than bytes is^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814960] block group
5957550080 has 790429696 bytes, 127959040 used 0 pinned 0 reserved^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814963] 0 blocks of free
space at or bigger than bytes is^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814965] block group
6747979776 has 752943104 bytes, 728870912 used 0 pinned 24072192
reserved^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.814968] 0 blocks of free
space at or bigger than bytes is^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.815588] ------------[ cut
here ]------------^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.815960] kernel BUG at
/home/ltrager/btrfs/btrfs-unstable-standalone/extent-tree.c:2437!^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012] invalid opcode:
0000 [#1] SMP ^M
Nov 12 22:39:13 Intrepid-btrfsNov 12 22:39:13 Intrepid-btrfs kernel: [
2531.816012] ^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012] Pid: 5193, comm:
btrfs-delalloc- Not tainted (2.6.27-7-generic #1)^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012] EIP:
0060:[<e08d2b62>] EFLAGS: 00010257 CPU: 0^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012] EIP is at
__btrfs_reserve_extent+0x3c2/0x480 [btrfs]^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012] EAX: df72d284 EBX:
dd27c180 ECX: ffffffff EDX: 00000001^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012] ESI: dd27c1ac EDI:
df72d278 EBP: d80e7de8 ESP: d80e7d74^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  DS: 007b ES: 007b
FS: 00d8 GS: 0000 SS: 0068^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012] Process
btrfs-delalloc- (pid: 5193, ti=d80e6000 task=d80bcb60
task.ti=d80e6000)^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012] Stack: e090d750
92360000 00000001 2ce10000 00000000 2b71b000 00000000 00000000 ^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]        00000000
016f5000 00000000 00000000 00000000 00000000 00000000 00000001 ^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]        00000000
00000000 00000000 00000000 00001000 00000000 dee450a0 df61c000 ^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012] Call Trace:^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  [<e08d2ea7>] ?
btrfs_reserve_extent+0x77/0xb0 [btrfs]^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  [<e08de767>] ?
cow_file_range+0x227/0x4d0 [btrfs]^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  [<e08dee68>] ?
submit_compressed_extents+0x458/0x4d0 [btrfs]^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  [<c01284cb>] ?
finish_task_switch+0x2b/0xe0^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  [<e08def6b>] ?
async_cow_submit+0x8b/0xa0 [btrfs]^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  [<e0900634>] ?
run_ordered_completions+0x74/0xd0 [btrfs]^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  [<e0900728>] ?
worker_loop+0x98/0x180 [btrfs]^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  [<e0900690>] ?
worker_loop+0x0/0x180 [btrfs]^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  [<c0147141>] ?
kthread+0x41/0x80^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  [<c0147100>] ?
kthread+0x0/0x80^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]  [<c0105297>] ?
kernel_thread_helper+0x7/0x10^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012]
=======================^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012] Code: 98 aa df 8d
4b 44 89 c8 89 4d f0 e8 e9 ad aa df 8b 7b 38 8b 07 0f 18 00 90 83 c3 38
39 fb 89 5d ec 75 33 8b 45 f0 e8 ae 8e 87 df <0f> 0b eb fe 66 90 8b 90
90 18 00 00 8b 88 78 18 00 00 8b b0 8c ^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.816012] EIP: [<e08d2b62>]
__btrfs_reserve_extent+0x3c2/0x480 [btrfs] SS:ESP 0068:d80e7d74^M
Nov 12 22:39:13 Intrepid-btrfs kernel: [ 2531.832531] ---[ end trace
0a75a78f84ed31b6 ]---

Lee
