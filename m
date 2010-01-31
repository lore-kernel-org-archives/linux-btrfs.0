From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: panic during rebalance, and now upon mount
Date: Sun, 31 Jan 2010 20:34:20 +0800
Message-ID: <3d0408631001310434g35b1fa4cp8a42068ef5fa5a34@mail.gmail.com>
References: <4B63CC39.1020505@gmail.com>
	 <3d0408631001300409i13326d13vac10a3f639f6db92@mail.gmail.com>
	 <4B646D08.1020307@gmail.com>
	 <3d0408631001301800y5de8a412w1d29bdb5e5e79f84@mail.gmail.com>
	 <4B6556C9.7060809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Troy Ablan <tablan@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B6556C9.7060809@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 31, 2010 at 6:09 PM, Troy Ablan <tablan@gmail.com> wrote:
> Yan, Zheng wrote:
>> Please run btrfsck and mount the fs with the new patches attached
>> below. Thank you
>>
>> Yan, Zheng,
>>
>>
>>
> During my two runs of btrfsck, the machine froze in an odd way before=
 it
> completed where the VTs were still accessible but wouldn't accept
> keystrokes. =A0I at first suspected it ran out of memory+swap. =A0I g=
ave it
> more swap through temp swapfiles the second time around. =A0During mo=
st of
> the fsck run, the process held onto 2.7 GB of RAM. =A0Toward the end,=
 it
> climbed all the way to 3.8 GB, and then the entire machine froze in t=
his
> odd way again.
>
> This was the `vmstat 1` that was running as it froze.
>
> procs -----------memory---------- ---swap-- -----io---- -system--
> ----cpu----
> =A0r =A0b =A0 swpd =A0 free =A0 buff =A0cache =A0 si =A0 so =A0 =A0bi=
 =A0 =A0bo =A0 in =A0 cs us sy
> id wa
> =A00 =A02 =A0 8296 =A030128 =A0 4240 =A0 3552 =A0 =A00 =A0 =A00 =A028=
00 =A0 =A0 0 1833 3366 =A00 =A01
> 75 24
> =A00 =A02 =A0 8296 =A029880 =A0 5204 =A0 3204 =A0 =A00 =A0 =A00 =A040=
28 =A0 =A0 0 2447 4554 =A00 =A01
> 74 24
> =A00 =A02 =A0 8296 =A030508 =A0 4400 =A0 3288 =A0 =A00 =A0 =A00 =A016=
80 =A0 =A020 1855 2422 =A00 =A01
> 75 24
> =A00 =A02 =A0 8296 =A030136 =A0 3720 =A0 3108 =A0 =A00 =A0 =A00 =A024=
64 =A0 =A0 0 2009 2672 =A00 =A01
> 73 25
> =A00 =A02 =A0 8296 =A029392 =A0 4396 =A0 3012 =A0 =A00 =A0 =A00 =A059=
96 =A0 =A0 0 2346 4089 =A00 =A02
> 71 27
> =A00 =A02 =A0 8296 =A029144 =A0 4076 =A0 2592 =A0 =A00 =A0 =A00 =A039=
52 =A0 =A0 0 4430 2910 =A00 =A01
> 77 21
> =A00 =A02 =A0 8296 =A029764 =A0 2416 =A0 2868 =A0 =A00 =A0 =A00 =A021=
68 =A0 =A012 1750 2488 =A00 =A01
> 70 28
> =A00 =A03 =A028900 =A025796 =A0 1804 =A0 1860 =A0 =A00 20604 =A03428 =
20660 1906 2766 =A00 =A02
> 75 23
> =A01 =A03 109760 =A025796 =A0 1396 =A0 1992 =A0 =A00 80852 =A0 288 80=
852 7665 =A0442 =A00 =A02
> 60 37
> =A00 =A04 113096 =A025672 =A0 1396 =A0 1992 =A0 =A00 3332 =A0 =A0 0 =A0=
3332 =A0105 =A0 43 =A00 =A00
> 74 26
>
> And the `top`
>
> top - 02:50:28 up =A03:48, =A08 users, =A0load average: 2.52, 2.01, 1=
=2E72
> Tasks: =A0 1 total, =A0 0 running, =A0 1 sleeping, =A0 0 stopped, =A0=
 0 zombie
> Cpu(s): =A00.1%us, =A00.6%sy, =A00.0%ni, 59.5%id, 39.7%wa, =A00.0%hi,=
 =A00.0%si,
> 0.0%st
> Mem: =A0 4050160k total, =A04024488k used, =A0 =A025672k free, =A0 =A0=
 1268k buffers
> Swap: 20978072k total, =A0 119136k used, 20858936k free, =A0 =A0 2072=
k cached
>
> =A0PID USER =A0 =A0 =A0PR =A0NI =A0VIRT =A0RES =A0SHR S %CPU %MEM =A0=
 =A0TIME+
> COMMAND
> =A05882 root =A0 =A0 =A020 =A0 0 3840m 3.6g =A0220 D =A0 =A02 94.2 =A0=
 8:26.44
> btrfsck
>
>
> This is as much from fsck as was available during both runs
>
> -[~:#]- ./btrfsck /dev/mapper/btra
> root 256 inode 356018 errors 2000
> root 256 inode 356022 errors 2000
> root 256 inode 356023 errors 2000
> root 256 inode 356025 errors 2000
> root 256 inode 356027 errors 2000
> root 256 inode 356033 errors 2000
> root 256 inode 356034 errors 2000
> root 256 inode 356035 errors 2000
> root 256 inode 356036 errors 2000
> root 256 inode 356037 errors 2000
> root 256 inode 356038 errors 2000
> root 256 inode 356039 errors 2000
> root 256 inode 356040 errors 2000
> root 256 inode 356044 errors 2000
> root 256 inode 356045 errors 2000
> root 256 inode 356046 errors 2000
> root 256 inode 356047 errors 2000
> root 256 inode 356049 errors 2000
> root 256 inode 356050 errors 2000
> root 256 inode 356051 errors 2000
> root 256 inode 356052 errors 2000
> root 256 inode 356053 errors 2000
> root 256 inode 356054 errors 2000
> root 256 inode 356055 errors 2000
> root 256 inode 356056 errors 2000
> root 256 inode 356058 errors 2000
> root 256 inode 356063 errors 2000
> root 256 inode 640297 errors 2000
> root 256 inode 640301 errors 2000
> root 256 inode 640302 errors 2000
> root 256 inode 640304 errors 2000
> root 256 inode 640306 errors 2000
> root 256 inode 640312 errors 2000
> root 256 inode 640313 errors 2000
> root 256 inode 640314 errors 2000
> root 256 inode 640315 errors 2000
> root 256 inode 640316 errors 2000
> root 256 inode 640317 errors 2000
> root 256 inode 640318 errors 2000
> root 256 inode 640319 errors 2000
> root 256 inode 640323 errors 2000
> root 256 inode 640324 errors 2000
> root 256 inode 640325 errors 2000
> root 256 inode 640326 errors 2000
> root 256 inode 640328 errors 2000
> root 256 inode 640329 errors 2000
> root 256 inode 640330 errors 2000
> root 256 inode 640331 errors 2000
> root 256 inode 640332 errors 2000
> root 256 inode 640333 errors 2000
> root 256 inode 640334 errors 2000
> root 256 inode 640335 errors 2000
> root 256 inode 640337 errors 2000
> root 256 inode 640342 errors 2000
> root 256 inode 831519 errors 2000
> root 257 inode 272056 errors 2000
> root 257 inode 272060 errors 2000
> root 257 inode 272061 errors 2000
> root 257 inode 272063 errors 2000
> root 257 inode 272065 errors 2000
> root 257 inode 272071 errors 2000
> root 257 inode 272072 errors 2000
> root 257 inode 272073 errors 2000
> root 257 inode 272074 errors 2000
> root 257 inode 272075 errors 2000
> root 257 inode 272076 errors 2000
> root 257 inode 272077 errors 2000
> root 257 inode 272078 errors 2000
> root 257 inode 272082 errors 2000
> root 257 inode 272083 errors 2000
> root 257 inode 272084 errors 2000
> root 257 inode 272085 errors 2000
> root 257 inode 272087 errors 2000
> root 257 inode 272088 errors 2000
> root 257 inode 272089 errors 2000
> root 257 inode 272090 errors 2000
> root 257 inode 272091 errors 2000
> root 257 inode 272092 errors 2000
> root 257 inode 272093 errors 2000
> root 257 inode 272094 errors 2000
> root 257 inode 272096 errors 2000
> root 257 inode 272101 errors 2000
> root 257 inode 799036 errors 400
> root 259 inode 47249 errors 2000
> root 259 inode 47253 errors 2000
> root 259 inode 47254 errors 2000
> root 259 inode 47256 errors 2000
> root 259 inode 47258 errors 2000
> root 259 inode 47264 errors 2000
> root 259 inode 47265 errors 2000
> root 259 inode 47266 errors 2000
> root 259 inode 47267 errors 2000
> root 259 inode 47268 errors 2000
> root 259 inode 47269 errors 2000
> root 259 inode 47270 errors 2000
> root 259 inode 47271 errors 2000
> root 259 inode 47275 errors 2000
> root 259 inode 47276 errors 2000
> root 259 inode 47277 errors 2000
> root 259 inode 47278 errors 2000
> root 259 inode 47280 errors 2000
> root 259 inode 47281 errors 2000
> root 259 inode 47282 errors 2000
> root 259 inode 47283 errors 2000
> root 259 inode 47284 errors 2000
> root 259 inode 47285 errors 2000
> root 259 inode 47286 errors 2000
> root 259 inode 47287 errors 2000
> root 259 inode 47289 errors 2000
> root 259 inode 47294 errors 2000
> root 264 inode 241037 errors 2000
> root 264 inode 242664 errors 2000
> root 264 inode 242665 errors 2000
> root 264 inode 243283 errors 2000
> root 264 inode 250001 errors 2000
> root 264 inode 250440 errors 2000
> root 264 inode 250891 errors 2000
> root 268 inode 78830 errors 2000
> root 268 inode 78834 errors 2000
> root 268 inode 78835 errors 2000
> root 268 inode 78837 errors 2000
> root 268 inode 78839 errors 2000
> root 268 inode 78845 errors 2000
> root 268 inode 78846 errors 2000
> root 268 inode 78847 errors 2000
> root 268 inode 78848 errors 2000
> root 268 inode 78849 errors 2000
> root 268 inode 78850 errors 2000
> root 268 inode 78851 errors 2000
> root 268 inode 78852 errors 2000
> root 268 inode 78856 errors 2000
> root 268 inode 78857 errors 2000
> root 268 inode 78858 errors 2000
> root 268 inode 78859 errors 2000
> root 268 inode 78861 errors 2000
> root 268 inode 78862 errors 2000
> root 268 inode 78863 errors 2000
> root 268 inode 78864 errors 2000
> root 268 inode 78865 errors 2000
> root 268 inode 78866 errors 2000
> root 268 inode 78867 errors 2000
> root 268 inode 78868 errors 2000
> root 268 inode 78870 errors 2000
> root 268 inode 78875 errors 2000
>
>
> And for the mount, done after rebooting
>
> [ =A0198.062442] device label bk0 devid 1 transid 111136 /dev/mapper/=
btra
> [ =A0198.157820] btrfs: use compression
> [ =A0246.549684] root 18446744073709551608 536
> [ =A0246.549688] node 9197760471040 refs 0 flags 0 owner 536 reloc 1 =
level
> 0 nritems 0
> [ =A0246.549695] ------------[ cut here ]------------
> [ =A0246.549780] kernel BUG at fs/btrfs/extent-tree.c:5385!
> [ =A0246.549864] invalid opcode: 0000 [#1] SMP
> [ =A0246.550016] last sysfs file:
> /sys/devices/virtual/block/md1/md/metadata_version
> [ =A0246.550145] CPU 5
> [ =A0246.550260] Pid: 5993, comm: btrfs-relocate- Tainted: G =A0 =A0 =
=A0 =A0W
> 2.6.33-rc6 #1 P55M-GD45 (MS-7588) /MS-7588
> [ =A0246.550392] RIP: 0010:[<ffffffff8129e686>] =A0[<ffffffff8129e686=
>]
> walk_up_proc+0x456/0x4c0
> [ =A0246.550560] RSP: 0018:ffff880138a93c70 =A0EFLAGS: 00010282
> [ =A0246.550644] RAX: 0000000000000058 RBX: ffff88013c12f9c0 RCX:
> 000000000003ffff
> [ =A0246.550732] RDX: ffff880028340000 RSI: 0000000000000082 RDI:
> 0000000000000000
> [ =A0246.550819] RBP: ffff880138a93cf0 R08: 0000000000000000 R09:
> ffffffff816ac59f
> [ =A0246.551695] R10: 0000000000000000 R11: 0000000000000004 R12:
> 0000000000000000
> [ =A0246.551783] R13: ffff880138a92000 R14: ffff8801396769a0 R15:
> ffff88013e69c000
> [ =A0246.551870] FS: =A00000000000000000(0000) GS:ffff880028340000(00=
00)
> knlGS:0000000000000000
> [ =A0246.552000] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ =A0246.552085] CR2: 00007f3dde7b9ea0 CR3: 00000000018d3000 CR4:
> 00000000000006e0
> [ =A0246.552172] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ =A0246.552259] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [ =A0246.552347] Process btrfs-relocate- (pid: 5993, threadinfo
> ffff880138a92000, task ffff88013c5d40c0)
> [ =A0246.552478] Stack:
> [ =A0246.552556] =A0ffff880100000000 ffff880100000000 ffff880138a93d3=
0
> ffff880000000000
> [ =A0246.552748] <0> 6db6db6db6db6db7 0000160000000000 00000000000000=
08
> 0000000000000206
> [ =A0246.553050] <0> ffff880138a93d20 ffff88013967c8e0 00000000000000=
00
> 0000000000000000
> [ =A0246.553531] Call Trace:
> [ =A0246.553613] =A0[<ffffffff8129e82f>] walk_up_tree+0x13f/0x1c0
> [ =A0246.553699] =A0[<ffffffff8129fa98>] btrfs_drop_snapshot+0x218/0x=
5e0
> [ =A0246.553786] =A0[<ffffffff812a9eb0>] ? __btrfs_end_transaction+0x=
100/0x170
> [ =A0246.553875] =A0[<ffffffff812e7e5d>] merge_func+0x7d/0xc0
> [ =A0246.553961] =A0[<ffffffff812d268a>] worker_loop+0x17a/0x540
> [ =A0246.554046] =A0[<ffffffff812d2510>] ? worker_loop+0x0/0x540
> [ =A0246.554131] =A0[<ffffffff812d2510>] ? worker_loop+0x0/0x540
> [ =A0246.554217] =A0[<ffffffff81095936>] kthread+0x96/0xa0
> [ =A0246.554303] =A0[<ffffffff81034bd4>] kernel_thread_helper+0x4/0x1=
0
> [ =A0246.554408] =A0[<ffffffff816ac969>] ? restore_args+0x0/0x30
> [ =A0246.554493] =A0[<ffffffff810958a0>] ? kthread+0x0/0xa0
> [ =A0246.554578] =A0[<ffffffff81034bd0>] ? kernel_thread_helper+0x0/0=
x10
> [ =A0246.554663] Code: 0f 95 c1 89 7c 24 08 48 8b 0c c3 4a 8b 14 e3 4=
0 0f
> b6 f6 41 83 e1 01 89 34 24 48 c7 c7 98 6a 81 81 49 8b 36 31 c0 e8 26 =
af
> 40 00 <0f> 0b eb fe 66 0f 1f 44 00 00 4c 89 f7 e8 48 70 03 00 4c 89 f=
7
> [ =A0246.557353] RIP =A0[<ffffffff8129e686>] walk_up_proc+0x456/0x4c0
> [ =A0246.557474] =A0RSP <ffff880138a93c70>
> [ =A0246.557601] ---[ end trace 18f62a4fb26ae09e ]---
>

Please try the patch attached below. It should solve the bug during mou=
nting
that fs. But I don't know why there are so many link count errors in th=
at fs.
How old is that fs? what was that fs used for?

Thank you very much.
Yan, Zheng

---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2010-01-22 12:16:34.203525744 +0800
+++ 2/fs/btrfs/extent-tree.c	2010-01-31 20:09:08.509200892 +0800
@@ -5402,14 +5402,14 @@ static noinline int walk_down_tree(struc
 	int ret;

 	while (level >=3D 0) {
-		if (path->slots[level] >=3D
-		    btrfs_header_nritems(path->nodes[level]))
-			break;
-
 		ret =3D walk_down_proc(trans, root, path, wc, lookup_info);
 		if (ret > 0)
 			break;

+		if (path->slots[level] >=3D
+		    btrfs_header_nritems(path->nodes[level]))
+			break;
+
 		if (level =3D=3D 0)
 			break;

---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
