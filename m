From: briaeros007 <briaeros007@gmail.com>
Subject: btrfs fsck doesn't modify a thing, and btrfs can not balance any data
	on a new device
Date: Tue, 26 Jan 2010 22:16:42 +0100
Message-ID: <61bf8f4f1001261316u36adbd6cvfeb9bfa0da196e13@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a btrfs volume on a two 1TB disk, and i've been trying to add a
new (1.5 TB) to this volume. I've done btrfsctl -a /dev/sdb /mnt/btrfs
without trouble, and btrfs-show see the third disk.
But I've got segfault when I try to balance the data.
And when a try a fsck, he do absolutely nothing. See the commands
below (and the dmesg)

So if you have any idea, or want to do any additionnal tests (other
than throwing away data that are on theses disks, since, even if i
know btrfs is under heavy developpment, id'like to keep some data and
haven't the right device right now to do the transfer).


Cordially.


<root@oni:/home/alpha>
zsh/3 2 # umount /mnt/btrfs
umount: /mnt/btrfs: not mounted
[mar. 10/01/26 20:07
CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
<root@oni:/home/alpha>
zsh/3 3 [1] # btrfsck /dev/sdb
failed to read /dev/sr0
bad block 2064048422912
bad block 924702326784
leaf parent key incorrect 2026404634624
bad block 2026404634624
leaf parent key incorrect 2045515939840
bad block 2045515939840
owner ref check failed [924702326784 4096]
owner ref check failed [2026404634624 4096]
owner ref check failed [2045515939840 4096]
owner ref check failed [2064048422912 4096]
found 1884638785584 bytes used err is 1
total csum bytes: 1836791604
total tree bytes: 3778641920
total fs tree bytes: 1484914688
btree space waste bytes: 611092845
file data blocks allocated: 1926324310016
=C2=A0referenced 1880273379328
Btrfs v0.19-4-gab8fb4c
[mar. 10/01/26 20:10
CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
<root@oni:/home/alpha>
zsh/3 4 [1] # btrfsck /dev/sdb
failed to read /dev/sr0
bad block 2064048422912
bad block 924702326784
leaf parent key incorrect 2026404634624
bad block 2026404634624
leaf parent key incorrect 2045515939840
bad block 2045515939840
owner ref check failed [924702326784 4096]
owner ref check failed [2026404634624 4096]
owner ref check failed [2045515939840 4096]
owner ref check failed [2064048422912 4096]
found 1884638785584 bytes used err is 1
total csum bytes: 1836791604
total tree bytes: 3778641920
total fs tree bytes: 1484914688
btree space waste bytes: 611092845
file data blocks allocated: 1926324310016
=C2=A0referenced 1880273379328
Btrfs v0.19-4-gab8fb4c
[mar. 10/01/26 20:20
CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
<root@oni:/home/alpha>
zsh/3 5 [1] # mount /mnt/btrfs
[mar. 10/01/26 21:38
CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
<root@oni:/home/alpha>
zsh/3 6 # btrfs-show
failed to read /dev/sr0
Label: none=C2=A0 uuid: 3e021a76-954e-4f54-86a0-fa3849e451c2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 3 FS bytes use=
d 1.71TB
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 3 si=
ze 1.36TB used 3.99GB path /dev/sdb
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 si=
ze 931.51GB used 930.01GB path /dev/sdc
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 931.51GB used 929.00GB path /dev/sdd

Btrfs v0.19-4-gab8fb4c
[mar. 10/01/26 21:38
CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
<root@oni:/home/alpha>
zsh/3 7 # btrfs-vol -b /mnt/btrfs
zsh: segmentation fault=C2=A0 btrfs-vol -b /mnt/btrfs
[mar. 10/01/26 21:41
CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
<root@oni:/home/alpha>
zsh/3 9 [139] #=C2=A0 dmesg |grep BUG
[ 6417.151192] kernel BUG at fs/btrfs/volumes.c:1746!
[mar. 10/01/26 21:42
CET][pts/11][x86_64/linux-gnu/2.6.33-rc5-00247-gc3e6a41][4.3.9]
<root@oni:/home/alpha>
zsh/3 10 #

my dmesg, from the warning, then the bug

[ 6413.080969] btrfs: relocating block group 2917377507328 flags 9
[ 6413.942527] btrfs: relocating block group 2914156281856 flags 9
[ 6416.792048] btrfs csum failed ino 258 off 249937920 csum 3749246389
private 2282873894
[ 6416.798204] btrfs csum failed ino 258 off 249937920 csum 3749246389
private 2282873894
[ 6416.837809] btrfs csum failed ino 258 off 249937920 csum 3749246389
private 2282873894
[ 6416.841459] btrfs csum failed ino 258 off 249937920 csum 3749246389
private 2282873894
[ 6417.090891] ------------[ cut here ]------------
[ 6417.090909] WARNING: at fs/btrfs/relocation.c:3597
btrfs_relocate_block_group+0x1ff/0x300()
[ 6417.090915] Hardware name: System Product Name
[ 6417.090919] Modules linked in: nfnetlink vboxnetadp vboxnetflt
vboxdrv kvm_amd kvm autofs4 dm_crypt rtc_cmos rtc_core rtc_lib
[ 6417.090941] Pid: 6215, comm: btrfs-vol Not tainted
2.6.33-rc5-00247-gc3e6a41 #6
[ 6417.090945] Call Trace:
[ 6417.090957]=C2=A0 [<ffffffff812650ff>] ? btrfs_relocate_block_group+=
0x1ff/0x300
[ 6417.090966]=C2=A0 [<ffffffff81041188>] warn_slowpath_common+0x78/0xd=
0
[ 6417.090973]=C2=A0 [<ffffffff810411ef>] warn_slowpath_null+0xf/0x20
[ 6417.090981]=C2=A0 [<ffffffff812650ff>] btrfs_relocate_block_group+0x=
1ff/0x300
[ 6417.090988]=C2=A0 [<ffffffff8124b1c3>] btrfs_relocate_chunk+0x83/0x5=
e0
[ 6417.090998]=C2=A0 [<ffffffff81237bd1>] ? btrfs_item_offset+0xe1/0xf0
[ 6417.091004]=C2=A0 [<ffffffff8124d0a8>] btrfs_balance+0x228/0x290
[ 6417.091013]=C2=A0 [<ffffffff81095ff5>] ? filemap_fault+0xa5/0x3c0
[ 6417.091019]=C2=A0 [<ffffffff81252d37>] btrfs_ioctl+0x587/0xad0
[ 6417.091027]=C2=A0 [<ffffffff810e15c5>] vfs_ioctl+0x35/0xd0
[ 6417.091033]=C2=A0 [<ffffffff810e1b7a>] do_vfs_ioctl+0x8a/0x5c0
[ 6417.091042]=C2=A0 [<ffffffff812b627d>] ? __up_read+0x9d/0xc0
[ 6417.091049]=C2=A0 [<ffffffff8105cb99>] ? up_read+0x9/0x10
[ 6417.091055]=C2=A0 [<ffffffff810e2149>] sys_ioctl+0x99/0xa0
[ 6417.091069]=C2=A0 [<ffffffff8100256b>] system_call_fastpath+0x16/0x1=
b
[ 6417.091080] ---[ end trace d8d2dfddfdd61541 ]---
[ 6417.151188] ------------[ cut here ]------------
[ 6417.151192] kernel BUG at fs/btrfs/volumes.c:1746!
[ 6417.151194] invalid opcode: 0000 [#1] SMP
[ 6417.151195] last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[ 6417.151197] CPU 0
[ 6417.151200] Pid: 6215, comm: btrfs-vol Tainted: G=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 W
2.6.33-rc5-00247-gc3e6a41 #6 M3A78-T/System Product Name
[ 6417.151202] RIP: 0010:[<ffffffff8124b714>]=C2=A0 [<ffffffff8124b714>=
]
btrfs_relocate_chunk+0x5d4/0x5e0
[ 6417.151208] RSP: 0018:ffff8801793d7c38=C2=A0 EFLAGS: 00010282
[ 6417.151209] RAX: 00000000fffffffb RBX: ffff880100872120 RCX: 2000000=
000000081
[ 6417.151211] RDX: ffff88010d9a1200 RSI: ffffea0003af9b38 RDI: fffffff=
f81c03cc0
[ 6417.151212] RBP: ffff8801793d7d28 R08: 0000000000000000 R09: fffffff=
f81265003
[ 6417.151214] R10: 8000000000000000 R11: ffff88011223f5a0 R12: 000002a=
681400000
[ 6417.151215] R13: 0000000000000000 R14: 0000000000000100 R15: ffff880=
18ba33000
[ 6417.151217] FS:=C2=A0 00007fcc6be73730(0000) GS:ffff880028200000(000=
0)
knlGS:0000000000000000
[ 6417.151218] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6417.151220] CR2: 00007f8a30ac4000 CR3: 000000016c366000 CR4: 0000000=
0000006f0
[ 6417.151221] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[ 6417.151223] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[ 6417.151225] Process btrfs-vol (pid: 6215, threadinfo
ffff8801793d6000, task ffff8801986b8000)
[ 6417.151226] Stack:
[ 6417.151227]=C2=A0 0000000000000100 ffff88013b508990 ffff8801793d7cf8
000002a681400000
[ 6417.151229] <0> 0000000000000100 ffff8801793d7ce0 ffff8801793d7cb8
ffff88018ba30000
[ 6417.151231] <0> ffff8801793d7ce0 ffff880100000004 ffff8801793d7cd8
00000000000001f5
[ 6417.151234] Call Trace:
[ 6417.151239]=C2=A0 [<ffffffff81237bd1>] ? btrfs_item_offset+0xe1/0xf0
[ 6417.151241]=C2=A0 [<ffffffff8124d0a8>] btrfs_balance+0x228/0x290
[ 6417.151244]=C2=A0 [<ffffffff81095ff5>] ? filemap_fault+0xa5/0x3c0
[ 6417.151246]=C2=A0 [<ffffffff81252d37>] btrfs_ioctl+0x587/0xad0
[ 6417.151249]=C2=A0 [<ffffffff810e15c5>] vfs_ioctl+0x35/0xd0
[ 6417.151251]=C2=A0 [<ffffffff810e1b7a>] do_vfs_ioctl+0x8a/0x5c0
[ 6417.151254]=C2=A0 [<ffffffff812b627d>] ? __up_read+0x9d/0xc0
[ 6417.151256]=C2=A0 [<ffffffff8105cb99>] ? up_read+0x9/0x10
[ 6417.151258]=C2=A0 [<ffffffff810e2149>] sys_ioctl+0x99/0xa0
[ 6417.151261]=C2=A0 [<ffffffff8100256b>] system_call_fastpath+0x16/0x1=
b
[ 6417.151262] Code: 48 8b bd 50 ff ff ff e8 5b c6 fd ff 31 d2 e9 9f
fa ff ff 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe
0f 0
[ 6417.151278] RIP=C2=A0 [<ffffffff8124b714>] btrfs_relocate_chunk+0x5d=
4/0x5e0
[ 6417.151280]=C2=A0 RSP <ffff8801793d7c38>
[ 6417.151282] ---[ end trace d8d2dfddfdd61542 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
