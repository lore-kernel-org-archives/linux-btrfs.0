From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: kernel BUG at fs/btrfs/inode.c:806
Date: Wed, 1 Dec 2010 14:11:01 +0100
Message-ID: <201012011411.02352.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On one of my machines with btrfs I got this bug:

entry offset 29085974528, bytes 4096, bitmap no
entry offset 29162995712, bytes 20480, bitmap yes
entry offset 29171744768, bytes 4096, bitmap no
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 29834084352 has 1073741824 bytes, 1072648192 used 0 pinned 0 reserved
entry offset 29834084352, bytes 376832, bitmap yes
entry offset 29890392064, bytes 4096, bitmap no
entry offset 29895069696, bytes 4096, bitmap no
entry offset 29896048640, bytes 4096, bitmap no
entry offset 29896364032, bytes 4096, bitmap no
entry offset 29896482816, bytes 4096, bitmap no
entry offset 29905817600, bytes 4096, bitmap no
entry offset 29906878464, bytes 4096, bitmap no
entry offset 29908029440, bytes 4096, bitmap no
entry offset 29908418560, bytes 4096, bitmap no
entry offset 29910061056, bytes 4096, bitmap no
entry offset 29911105536, bytes 4096, bitmap no
entry offset 29912371200, bytes 4096, bitmap no
entry offset 29912748032, bytes 4096, bitmap no
entry offset 29914660864, bytes 4096, bitmap no
entry offset 29914755072, bytes 4096, bitmap no
entry offset 29915865088, bytes 4096, bitmap no
entry offset 29915914240, bytes 4096, bitmap no
entry offset 29916409856, bytes 4096, bitmap no
entry offset 29916471296, bytes 4096, bitmap no
entry offset 29924597760, bytes 4096, bitmap no
entry offset 29931642880, bytes 4096, bitmap no
entry offset 29931925504, bytes 4096, bitmap no
entry offset 29932732416, bytes 4096, bitmap no
entry offset 29933383680, bytes 4096, bitmap no
entry offset 29933412352, bytes 4096, bitmap no
entry offset 29933596672, bytes 4096, bitmap no
entry offset 29935316992, bytes 4096, bitmap no
entry offset 29938610176, bytes 4096, bitmap no
entry offset 29939154944, bytes 4096, bitmap no
entry offset 29944033280, bytes 4096, bitmap no
entry offset 29946318848, bytes 4096, bitmap no
entry offset 29964181504, bytes 4096, bitmap no
entry offset 29964828672, bytes 4096, bitmap no
entry offset 29966233600, bytes 4096, bitmap no
entry offset 29968302080, bytes 98304, bitmap yes
entry offset 29983170560, bytes 4096, bitmap no
entry offset 29984059392, bytes 4096, bitmap no
entry offset 29992976384, bytes 4096, bitmap no
entry offset 30008422400, bytes 4096, bitmap no
entry offset 30025895936, bytes 4096, bitmap no
entry offset 30034280448, bytes 4096, bitmap no
entry offset 30055174144, bytes 4096, bitmap no
entry offset 30067208192, bytes 4096, bitmap no
entry offset 30094012416, bytes 4096, bitmap no
entry offset 30098358272, bytes 4096, bitmap no
entry offset 30098722816, bytes 4096, bitmap no
entry offset 30102491136, bytes 4096, bitmap no
entry offset 30102519808, bytes 143360, bitmap yes
entry offset 30103207936, bytes 4096, bitmap no
entry offset 30103601152, bytes 4096, bitmap no
entry offset 30105415680, bytes 4096, bitmap no
entry offset 30112169984, bytes 4096, bitmap no
entry offset 30139326464, bytes 4096, bitmap no
entry offset 30173143040, bytes 4096, bitmap no
entry offset 30176014336, bytes 4096, bitmap no
entry offset 30202048512, bytes 4096, bitmap no
entry offset 30229487616, bytes 4096, bitmap no
entry offset 30230700032, bytes 4096, bitmap no
entry offset 30230777856, bytes 4096, bitmap no
entry offset 30232813568, bytes 4096, bitmap no
entry offset 30235348992, bytes 4096, bitmap no
entry offset 30236737536, bytes 49152, bitmap yes
entry offset 30241488896, bytes 4096, bitmap no
entry offset 30252662784, bytes 4096, bitmap no
entry offset 30370955264, bytes 49152, bitmap yes
entry offset 30425870336, bytes 4096, bitmap no
entry offset 30505172992, bytes 61440, bitmap yes
entry offset 30507831296, bytes 4096, bitmap no
entry offset 30639390720, bytes 8192, bitmap yes
entry offset 30760058880, bytes 4096, bitmap no
entry offset 30773608448, bytes 45056, bitmap yes
block group has cluster?: no
3 blocks of free space at or bigger than bytes is
block group 30907826176 has 536870912 bytes, 533860352 used 0 pinned 0 reserved
entry offset 30907826176, bytes 1441792, bitmap yes
entry offset 31042043904, bytes 995328, bitmap yes
entry offset 31176261632, bytes 212992, bitmap yes
entry offset 31310479360, bytes 8192, bitmap yes
block group has cluster?: no
3 blocks of free space at or bigger than bytes is
block group 31444697088 has 268435456 bytes, 266985472 used 0 pinned 0 reserved
entry offset 31444697088, bytes 1298432, bitmap yes
entry offset 31578914816, bytes 151552, bitmap yes
block group has cluster?: no
2 blocks of free space at or bigger than bytes is
block group 31713132544 has 268435456 bytes, 267300864 used 0 pinned 0 reserved
entry offset 31713132544, bytes 1093632, bitmap yes
entry offset 31847350272, bytes 40960, bitmap yes
block group has cluster?: no
1 blocks of free space at or bigger than bytes is
block group 31981568000 has 268435456 bytes, 268029952 used 0 pinned 0 reserved
entry offset 31981568000, bytes 360448, bitmap yes
entry offset 32115785728, bytes 45056, bitmap yes
block group has cluster?: no
1 blocks of free space at or bigger than bytes is
block group 32250003456 has 268435456 bytes, 268263424 used 0 pinned 0 reserved
entry offset 32250003456, bytes 172032, bitmap yes
block group has cluster?: no
1 blocks of free space at or bigger than bytes is
btrfs allocation failed flags 1, wanted 4096
space_info has 1138688 free, is full
space_info total=14495514624, used=14483705856, pinned=0, reserved=10670080, may_use=1118208, readonly=0
block group 15195963392 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 16269705216 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 17343447040 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 18417188864 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 19490930688 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 20564672512 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 22577938432 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 23651680256 has 1073741824 bytes, 1073741824 used 0 pinned 0 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 24725422080 has 1073741824 bytes, 1073094656 used 0 pinned 647168 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 27015512064 has 1073741824 bytes, 1069514752 used 0 pinned 4227072 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 28357689344 has 1073741824 bytes, 1072664576 used 0 pinned 290816 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 29834084352 has 1073741824 bytes, 1073577984 used 0 pinned 163840 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 30907826176 has 536870912 bytes, 534175744 used 0 pinned 2342912 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 31444697088 has 268435456 bytes, 266985472 used 0 pinned 1449984 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 31713132544 has 268435456 bytes, 267292672 used 0 pinned 1142784 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 31981568000 has 268435456 bytes, 268029952 used 0 pinned 405504 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
block group 32250003456 has 268435456 bytes, 268435456 used 0 pinned 0 reserved
block group has cluster?: no
0 blocks of free space at or bigger than bytes is
------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:806!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
Modules linked in: snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss fuse dm_crypt dm_mod usbhid fschmd snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer e1000 snd uhci_hcd sr_mod cdrom snd_page_alloc sg i2c_i801 [last unloaded: microcode]

Pid: 1902, comm: flush-btrfs-1 Not tainted 2.6.37-rc3 #2 D1561/SCENIC P / SCENICO P
EIP: 0060:[<c1160a5a>] EFLAGS: 00010286 CPU: 1
EIP is at cow_file_range+0x23d/0x406
EAX: ffffffe4 EBX: 00854000 ECX: f5abbbc8 EDX: 00000001
ESI: 00000000 EDI: f5862800 EBP: 00000000 ESP: f5abbc98
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 Process flush-btrfs-1 (pid: 1902, ti=f5aba000 task=f5b7a1c0 task.ti=f5aba000)
 Stack:
  0005ffff 00000000 0000c000 00000000 f5862800 ddb8038c 00001000 00000000
  00001000 f62f5210 ddb80284 ddb80280 ddb80288 f7944360 00000001 00000000
  a8000000 00000000 00000000 00801000 00000000 f5abbddc f5862800 c116149f
  Call Trace:
  [<c116149f>] ? run_delalloc_range+0xab/0x343
  [<c1179a34>] ? __extent_writepage+0x1fb/0x6e2
  [<c105ef65>] ? find_get_pages_tag+0xac/0xc8
  [<c117a187>] ? T.970+0x111/0x1d2
  [<c117a33c>] ? extent_writepages+0x3a/0x4c
  [<c1162799>] ? btrfs_get_extent+0x0/0x940
  [<c11626aa>] ? btrfs_writepages+0x18/0x1b
  [<c106479c>] ? do_writepages+0x14/0x20
  [<c109b80f>] ? writeback_single_inode+0x8b/0x186
  [<c109bc63>] ? writeback_sb_inodes+0x97/0xf5
  [<c109c13d>] ? writeback_inodes_wb+0xd6/0xe6
  [<c109c2b4>] ? wb_writeback+0x167/0x1d0
  [<c10942b4>] ? get_nr_dirty_inodes+0x1f/0x68
  [<c109c426>] ? wb_do_writeback+0x109/0x11f
  [<c109c4a2>] ? bdi_writeback_thread+0x66/0x108
  [<c109c43c>] ? bdi_writeback_thread+0x0/0x108
  [<c1039301>] ? kthread+0x63/0x68
  [<c103929e>] ? kthread+0x0/0x68
  [<c1002c36>] ? kernel_thread_helper+0x6/0x10
Code: 00 6a 00 8b 7c 24 34 8b 87 f8 01 00 00 31 d2 52 50 ff 74 24 38 ff 74 24 38 89 fa 8b 44 24 58 e8 7d e7 fe ff 83 c4 34 85 c0 74 04 <0f> 0b eb fe b8 50 00 00 00 e8 f0 a6 00 00 89 c7 89 58 0c 89 70 
EIP: [<c1160a5a>] cow_file_range+0x23d/0x406 SS:ESP 0068:f5abbc98
---[ end trace 442296bce7954a93 ]---

The "block group" messages where way more, too much for the dmesg log buffer.
Kernel is a 2.6.37-rc3+ without the latest btrfs-fixes. The bug occurred when
compiling openoffice.org. After the bug a 'df -h' showed:

df -h:
Filesystem            Size  Used Avail Use% Mounted on
rootfs                 21G   17G  770M  96% /
/dev/root              21G   17G  770M  96% /
rc-svcdir             1.0M  108K  916K  11% /lib/rc/init.d
udev                   10M  116K  9.9M   2% /dev
shm                  1013M     0 1013M   0% /dev/shm
/dev/sda2              66G   46G   20G  71% /home
/dev/sdb1              75G   56G   19G  75% /mnt/windows
