From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: panic during rebalance, and now upon mount
Date: Sat, 30 Jan 2010 20:09:28 +0800
Message-ID: <3d0408631001300409i13326d13vac10a3f639f6db92@mail.gmail.com>
References: <4B63CC39.1020505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Troy Ablan <tablan@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B63CC39.1020505@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 30, 2010 at 2:05 PM, Troy Ablan <tablan@gmail.com> wrote:
> Hi folks,
>
> During a very lengthy btrfs-vol -b (3.5 days in), btrfs BUGged out.
> Upon rebooting and trying to mount that fs, the exact same bug (with =
the
> exact same call trace) happens. =A0I moved up to 2.6.33-rc6 from
> gentoo-maintained 2.6.32-r2 to see what would happen, and it appears =
to
> panic at the equivalent line of the same source file as before.
>
> Let me know if I can do anything to assist. =A0I won't do anything to=
 the
> disks for the next few days in case some forensics will be useful.
>
> [ =A0154.899692] device label bk0 devid 14 transid 111134 /dev/mapper=
/btrn
> [ =A0154.958264] btrfs: use compression
> [ =A0202.394048] ------------[ cut here ]------------
> [ =A0202.394136] kernel BUG at fs/btrfs/extent-tree.c:5377!
> [ =A0202.394220] invalid opcode: 0000 [#1] SMP
> [ =A0202.394372] last sysfs file:
> /sys/devices/virtual/block/md1/md/metadata_version
> [ =A0202.394500] CPU 5
> [ =A0202.394655] Pid: 5838, comm: btrfs-relocate- Tainted: G =A0 =A0 =
=A0 =A0W
> 2.6.33-rc6 #1 P55M-GD45 (MS-7588) /MS-7588
> [ =A0202.394787] RIP: 0010:[<ffffffff8129e5ad>] =A0[<ffffffff8129e5ad=
>]
> walk_up_proc+0x37d/0x3c0
> [ =A0202.394955] RSP: 0018:ffff880139729ca0 =A0EFLAGS: 00010282
> [ =A0202.395039] RAX: 0000000000000218 RBX: ffff88013c460300 RCX:
> ffff880139728000
> [ =A0202.395127] RDX: ffff880000000000 RSI: fffffffffffffff8 RDI:
> ffff880138ac08e0
> [ =A0202.395214] RBP: ffff880139729d00 R08: 0000000000000008 R09:
> 0000000000000001
> [ =A0202.395301] R10: 0000000000000001 R11: 0000000000000001 R12:
> ffff880138ab8880
> [ =A0202.395389] R13: 0000000000000000 R14: ffff88013f72f880 R15:
> ffff88013b646800
> [ =A0202.395476] FS: =A00000000000000000(0000) GS:ffff880028340000(00=
00)
> knlGS:0000000000000000
> [ =A0202.395606] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ =A0202.395691] CR2: 0000000000425f40 CR3: 00000000018d3000 CR4:
> 00000000000006e0
> [ =A0202.395778] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ =A0202.395865] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [ =A0202.395953] Process btrfs-relocate- (pid: 5838, threadinfo
> ffff880139728000, task ffff88013f0e28f0)
> [ =A0202.396083] Stack:
> [ =A0202.396162] =A0ffff880139729cf0 0000000000000002 ffff88013f72f88=
0
> 0000000000000206
> [ =A0202.397142] <0> ffff880139729d30 ffff880138ac08e0 00000000000000=
00
> 0000000000000000
> [ =A0202.397444] <0> ffff88013c460300 ffff88013f72f880 00000000000000=
00
> ffff880139728000
> [ =A0202.397856] Call Trace:
> [ =A0202.397937] =A0[<ffffffff8129e72f>] walk_up_tree+0x13f/0x1c0
> [ =A0202.398023] =A0[<ffffffff8129f99c>] btrfs_drop_snapshot+0x21c/0x=
600
> [ =A0202.398110] =A0[<ffffffff812a9dd0>] ? __btrfs_end_transaction+0x=
100/0x170
> [ =A0202.398198] =A0[<ffffffff812e7d7d>] merge_func+0x7d/0xc0
> [ =A0202.398284] =A0[<ffffffff812d25aa>] worker_loop+0x17a/0x540
> [ =A0202.398379] =A0[<ffffffff812d2430>] ? worker_loop+0x0/0x540
> [ =A0202.398487] =A0[<ffffffff812d2430>] ? worker_loop+0x0/0x540
> [ =A0202.398611] =A0[<ffffffff81095936>] kthread+0x96/0xa0
> [ =A0202.398697] =A0[<ffffffff81034bd4>] kernel_thread_helper+0x4/0x1=
0
> [ =A0202.398784] =A0[<ffffffff816ac869>] ? restore_args+0x0/0x30
> [ =A0202.398869] =A0[<ffffffff810958a0>] ? kthread+0x0/0xa0
> [ =A0202.398953] =A0[<ffffffff81034bd0>] ? kernel_thread_helper+0x0/0=
x10
> [ =A0202.399039] Code: 6d db b6 6d 48 c1 f8 03 48 0f af c2 48 ba 00 0=
0 00
> 00 00 88 ff ff 48 c1 e0 0c 48 8b 44 10 58 ff 49 1c 48 39 c6 0f 84 ab =
fd
> ff ff <0f> 0b eb fe 0f 1f 80 00 00 00 00 47 8b 4c ae 60 45 85 c9 0f 8=
5
> [ =A0202.401551] RIP =A0[<ffffffff8129e5ad>] walk_up_proc+0x37d/0x3c0
> [ =A0202.401671] =A0RSP <ffff880139729ca0>
> [ =A0202.401796] ---[ end trace 4c085bcc2bd215f6 ]---
>

Thank you for reporting this. Would you please run btrsck and mount
that fs again with the debug patch attached below.

Regards
Yan, Zheng

---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2010-01-22 12:16:34.203525744 +0800
+++ 2/fs/btrfs/extent-tree.c	2010-01-30 20:03:23.609292953 +0800
@@ -5373,8 +5373,18 @@ static noinline int walk_up_proc(struct
 		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
 			parent =3D eb->start;
 		else
-			BUG_ON(root->root_key.objectid !=3D
-			       btrfs_header_owner(eb));
+			if (root->root_key.objectid !=3D
+			    btrfs_header_owner(eb)) {
+				printk("root %llu %llu\n",
+				       root->root_key.objectid,
+				       root->root_key.offset);
+				printk("node %llu refs %llu flags %llu owner %llu reloc %d\n",
+				       eb->start, wc->refs[level], wc->flags[level],
+				       btrfs_header_owner(eb),
+				       btrfs_header_flag(eb, BTRFS_HEADER_FLAG_RELOC));
+
+				BUG();
+			}
 	} else {
 		if (wc->flags[level + 1] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
 			parent =3D path->nodes[level + 1]->start;
@@ -5496,6 +5506,8 @@ int btrfs_drop_snapshot(struct btrfs_roo
 		       sizeof(wc->update_progress));
 	} else {
 		btrfs_disk_key_to_cpu(&key, &root_item->drop_progress);
+		printk("drop progress %llu %d %llu\n", key.objectid,
+			key.type, key.offset);
 		memcpy(&wc->update_progress, &key,
 		       sizeof(wc->update_progress));
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
