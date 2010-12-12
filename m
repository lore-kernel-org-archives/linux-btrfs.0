From: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: Crash with btrfs rootfs on dm-crypt [ kernel BUG at
 fs/btrfs/inode.c:806! ] on linux 2.6.37-rc5
Date: Sun, 12 Dec 2010 10:22:18 +0100
Message-ID: <AANLkTi=SFJgZCWSxGYBcUzjAZiasOJQewOxx+0T_Pdzv@mail.gmail.com>
References: <AANLkTi=j9zsaYNcu=NgGV=HfE-3rNHzVswov8VrgwjQp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=j9zsaYNcu=NgGV=HfE-3rNHzVswov8VrgwjQp@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Well, this appears to be much more critical than it seemed. It
happened again, same symptoms and same call trace.

After that, my root filesystem was destroyed. Now the laptop does not
boot anymore. It look like mount segfaulting at boot time and there is
a call trace printed on the screen.

BTW, I should have mentioned in the previous email that there are no
signs of badblocks on the disk (laptop is an Asus eeePC 900, rootfs is
on the on-board ssd).

I can take a picture if needed but as for now I have no idea on how to
recover my laptop (I should find a live distro which supports root on
btrfs over dm-crypt, which seems unlikely.

Regards,
=46abio



On Fri, Dec 10, 2010 at 9:30 PM, Fabio Comolli <fabio.comolli@gmail.com=
> wrote:
> Hi.
> Just hit the BUG in the subj. Relevant part of the dmesg output I
> somehow managed to save:
>
> [ 8710.647123] ------------[ cut here ]------------
> [ 8710.647210] kernel BUG at fs/btrfs/inode.c:806!
> [ 8710.647282] invalid opcode: 0000 [#1] PREEMPT
> [ 8710.647362] last sysfs file:
> /sys/devices/platform/eeepc/hwmon/hwmon0/fan1_input
> [ 8710.647476] Modules linked in: [last unloaded: scsi_wait_scan]
> [ 8710.647577]
> [ 8710.647607] Pid: 1106, comm: flush-btrfs-1 Not tainted
> 2.6.37-rc5-dirty #1 900/900
> [ 8710.647726] EIP: 0060:[<c1118724>] EFLAGS: 00010286 CPU: 0
> [ 8710.647819] EIP is at cow_file_range+0x230/0x3f9
> [ 8710.647893] EAX: ffffffe4 EBX: 1356a000 ECX: c1491237 EDX: 0000000=
1
> [ 8710.647990] ESI: 00000000 EDI: f5c0e000 EBP: 00000000 ESP: f5f79cd=
8
> [ 8710.648006] =C2=A0DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [ 8710.648006] Process flush-btrfs-1 (pid: 1106, ti=3Df5f78000
> task=3Df5cc4dc0 task.ti=3Df5f78000)
> [ 8710.648006] Stack:
> [ 8710.648006] =C2=A000909fff 00000000 001fe000 00000000 f5c0e000 f62=
ff8b8
> 00001000 00000000
> [ 8710.648006] =C2=A000001000 f62ff7d4 f6161000 f62ff7d0 f7699a20 000=
00000
> 00000000 a8000000
> [ 8710.648006] =C2=A000000000 00000000 00000000 13767fff 00000000 f62=
ff7b8
> c1119163 12e5f000
> [ 8710.648006] Call Trace:
> [ 8710.648006] =C2=A0[<c1119163>] ? run_delalloc_range+0xa3/0xda
> [ 8710.648006] =C2=A0[<c112d8da>] ? __extent_writepage+0x206/0x6e8
> [ 8710.648006] =C2=A0[<c10577e5>] ? find_get_pages_tag+0xa0/0xc9
> [ 8710.648006] =C2=A0[<c112decd>] ?
> extent_write_cache_pages.clone.17.clone.29+0x111/0x1d8
> [ 8710.648006] =C2=A0[<c112e20c>] ? extent_writepages+0x3d/0x4f
> [ 8710.648006] =C2=A0[<c11161c9>] ? btrfs_get_extent+0x0/0x882
> [ 8710.648006] =C2=A0[<c1115868>] ? btrfs_writepages+0x18/0x1b
> [ 8710.648006] =C2=A0[<c105d99c>] ? do_writepages+0x12/0x1b
> [ 8710.648006] =C2=A0[<c108facc>] ? writeback_single_inode+0x95/0x198
> [ 8710.648006] =C2=A0[<c109042f>] ? writeback_sb_inodes+0x88/0xf9
> [ 8710.648006] =C2=A0[<c1090617>] ? writeback_inodes_wb+0xa2/0xe6
> [ 8710.648006] =C2=A0[<c1090767>] ? wb_writeback+0x10c/0x180
> [ 8710.648006] =C2=A0[<c10908ca>] ? wb_do_writeback+0xef/0x105
> [ 8710.648006] =C2=A0[<c109093c>] ? bdi_writeback_thread+0x5c/0x107
> [ 8710.648006] =C2=A0[<c10908e0>] ? bdi_writeback_thread+0x0/0x107
> [ 8710.648006] =C2=A0[<c1033d82>] ? kthread+0x62/0x67
> [ 8710.648006] =C2=A0[<c1033d20>] ? kthread+0x0/0x67
> [ 8710.648006] =C2=A0[<c1002c76>] ? kernel_thread_helper+0x6/0x10
> [ 8710.648006] Code: 50 6a 00 6a 00 8b 7c 24 34 8b 87 c8 01 00 00 52
> 89 fa 50 ff 74 24 38 ff 74 24 38 8b 44 24 5c e8 69 f8 fe ff 83 c4 34
> 85 c0 74 02 <0f> 0b b8 50 00 00 00 e8 2b 84 00 00 8b 54 24 37 8b 4c 2=
4
> 3b 89
> [ 8710.648006] EIP: [<c1118724>] cow_file_range+0x230/0x3f9 SS:ESP 00=
68:f5f79cd8
> [ 8710.697024] ---[ end trace 81ccff9fc7ce3765 ]---
>
> The kernel is dirty because of
> sched_autogroup_final_v2.6.37-rc4-12-g22a5b56.diff .
>
> After the crash the (encrypted) root filesystem was unusable until
> reboot; the /home filesystem (also btrfs) was ok (the dmesg output wa=
s
> saved there). After the reboot btrfsck on /dev/mapper/root showed no
> problems at all.
>
> Also, the dmesg output is full of messages (about 1850 lines) like th=
e
> following:
>
> [ 8616.109232] btrfs allocation failed flags 1, wanted 65536
> [ 8616.109311] space_info has 79597568 free, is full
> [ 8616.109318] space_info total=3D2807562240, used=3D2727600128,
> pinned=3D364544, reserved=3D0, may_use=3D290816, readonly=3D0
> [ 8616.109326] block group 12582912 has 8388608 bytes, 8327168 used
> 61440 pinned 0 reserved
> [ 8616.109332] block group has cluster?: no
> [ 8616.109336] 0 blocks of free space at or bigger than bytes is
> [ 8616.109343] block group 216793088 has 374865920 bytes, 370073600
> used 167936 pinned 0 reserved
> [ 8616.109349] entry offset 216793088, bytes 978944, bitmap yes
> [ 8616.109355] entry offset 351010816, bytes 790528, bitmap yes
> [ 8616.109361] entry offset 485228544, bytes 647168, bitmap yes
> [ 8616.109366] entry offset 486146048, bytes 4096, bitmap no
> [ 8616.109371] entry offset 487411712, bytes 8192, bitmap no
> [ 8616.109376] block group has cluster?: no
> [ 8616.109380] 3 blocks of free space at or bigger than bytes is
> [ 8616.109386] block group 591659008 has 374865920 bytes, 348446720
> used 12288 pinned 0 reserved
> [ 8616.109393] entry offset 591659008, bytes 528384, bitmap yes
> [ 8616.109398] entry offset 725876736, bytes 675840, bitmap yes
> [ 8616.109404] entry offset 860094464, bytes 208896, bitmap yes
> [ 8616.109408] block group has cluster?: no
> [ 8616.109413] 3 blocks of free space at or bigger than bytes is
> [ 8616.109419] block group 966524928 has 374865920 bytes, 350523392
> used 16384 pinned 0 reserved
> [ 8616.109426] entry offset 966524928, bytes 397312, bitmap yes
> [ 8616.109431] entry offset 973578240, bytes 8192, bitmap no
> [ 8616.109436] entry offset 976687104, bytes 8192, bitmap no
> [ 8616.109442] entry offset 1100742656, bytes 675840, bitmap yes
> [ 8616.109447] entry offset 1196097536, bytes 4096, bitmap no
> [ 8616.109453] entry offset 1234960384, bytes 421888, bitmap yes
> [ 8616.109458] entry offset 1236443136, bytes 4096, bitmap no
> [ 8616.109462] block group has cluster?: no
> [ 8616.109467] 3 blocks of free space at or bigger than bytes is
> [ 8616.109473] block group 1341390848 has 374865920 bytes, 368312320
> used 102400 pinned 0 reserved
> [ 8616.109480] entry offset 1341390848, bytes 991232, bitmap yes
> [ 8616.109485] entry offset 1343913984, bytes 4096, bitmap no
> [ 8616.109490] entry offset 1353039872, bytes 4096, bitmap no
> [ 8616.109496] entry offset 1475604480, bytes 4096, bitmap no
> [ 8616.109501] entry offset 1475608576, bytes 1343488, bitmap yes
> [ 8616.109507] entry offset 1477107712, bytes 4096, bitmap no
> [ 8616.109512] entry offset 1609826304, bytes 1236992, bitmap yes
> [ 8616.109518] entry offset 1688391680, bytes 8192, bitmap no
> [ 8616.109523] entry offset 1692372992, bytes 4096, bitmap no
> [ 8616.109527] block group has cluster?: no
>
> and so on. Unfortunately those messages filled the dmesg buffer, so I
> don't have other info to provide. The BUG lines were at the end.
>
> My btrfs filesystems are mounted like this:
>
> /dev/mapper/root on / type btrfs (rw,noatime,ssd)
> /dev/mapper/home on /home type btrfs (rw,noatime,ssd)
>
> Relevant part of dmesg after a clean boot:
>
> [ =C2=A0 =C2=A05.605844] device fsid 3f4f59f00ccebb53-21bc027c519339a=
d devid 1
> transid 49814 /dev/mapper/root
> [ =C2=A0 =C2=A05.625868] btrfs: disk space caching is enabled
> [ =C2=A0 12.612095] btrfs: use ssd allocation scheme
> [ =C2=A0 12.911580] btrfs: use ssd allocation scheme
> [ =C2=A0 13.077979] btrfs: unlinked 1 orphans
> [ =C2=A0 13.077985] btrfs: truncated 3 orphans
> [ =C2=A0 13.191858] device fsid 1c45fb67134eb006-bad591586362b7b1 dev=
id 1
> transid 9938 /dev/mapper/home
> [ =C2=A0 13.193316] btrfs: use ssd allocation scheme
> [ =C2=A0 13.211713] btrfs: disk space caching is enabled
>
> Please let me know if you need more details.
> Regards,
> Fabio
>
