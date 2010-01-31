From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: panic during rebalance, and now upon mount
Date: Sun, 31 Jan 2010 10:00:26 +0800
Message-ID: <3d0408631001301800y5de8a412w1d29bdb5e5e79f84@mail.gmail.com>
References: <4B63CC39.1020505@gmail.com>
	 <3d0408631001300409i13326d13vac10a3f639f6db92@mail.gmail.com>
	 <4B646D08.1020307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Troy Ablan <tablan@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B646D08.1020307@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 31, 2010 at 1:31 AM, Troy Ablan <tablan@gmail.com> wrote:
> Yan, Zheng wrote:
>> Thank you for reporting this. Would you please run btrsck and mount
>> that fs again with the debug patch attached below.
>>
>> Regards
>> Yan, Zheng
>>
>> ---
>> diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
>> --- 1/fs/btrfs/extent-tree.c =A02010-01-22 12:16:34.203525744 +0800
>> +++ 2/fs/btrfs/extent-tree.c =A02010-01-30 20:03:23.609292953 +0800
>> @@ -5373,8 +5373,18 @@ static noinline int walk_up_proc(struct
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wc->flags[level] & BTRFS_BLOCK_FLAG_=
=46ULL_BACKREF)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent =3D eb->start;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(root->root_key.obje=
ctid !=3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_heade=
r_owner(eb));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (root->root_key.objecti=
d !=3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_header_owner=
(eb)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk("ro=
ot %llu %llu\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0root->root_key.objectid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0root->root_key.offset);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk("no=
de %llu refs %llu flags %llu owner %llu reloc %d\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0eb->start, wc->refs[level], wc->flags[level],
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0btrfs_header_owner(eb),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0btrfs_header_flag(eb, BTRFS_HEADER_FLAG_RELOC));
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG();
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wc->flags[level + 1] & BTRFS_BLOCK_F=
LAG_FULL_BACKREF)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent =3D path->nodes[l=
evel + 1]->start;
>> @@ -5496,6 +5506,8 @@ int btrfs_drop_snapshot(struct btrfs_roo
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(wc->update_progres=
s));
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_disk_key_to_cpu(&key, &root_item->=
drop_progress);
>> + =A0 =A0 =A0 =A0 =A0 =A0 printk("drop progress %llu %d %llu\n", key=
=2Eobjectid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key.type, key.offset);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&wc->update_progress, &key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(wc->update_progres=
s));
>>
> Thanks for the quick reply.
>
> btrfsck bails out
>
> -[~:#]- btrfsck /dev/mapper/btra
> btrfsck: btrfsck.c:584: splice_shared_node: Assertion `!(src =3D=3D
> &src_node->root_cache)' failed.
> Aborted
>
>
> A mount produces this. =A0 I did not use -o compress this time, but I
> suspect it doesn't matter.
>
> [ 3192.249204] device label bk0 devid 1 transid 111135 /dev/mapper/bt=
ra
> [ 3240.180895] root 18446744073709551608 536
> [ 3240.180898] node 9197760471040 refs 0 flags 0 owner 536 reloc 1
> [ 3240.180904] ------------[ cut here ]------------
> [ 3240.180957] kernel BUG at fs/btrfs/extent-tree.c:5386!
> [ 3240.181009] invalid opcode: 0000 [#1] SMP
> [ 3240.181064] last sysfs file:
> /sys/devices/virtual/block/md1/md/metadata_version
> [ 3240.181159] CPU 3
> [ 3240.181210] Pid: 6143, comm: btrfs-relocate- Tainted: G =A0 =A0 =A0=
 =A0W
> 2.6.33-rc6 #2 P55M-GD45 (MS-7588) /MS-7588
> [ 3240.181309] RIP: 0010:[<ffffffff8129e65f>] =A0[<ffffffff8129e65f>]
> walk_up_proc+0x42f/0x490
> [ 3240.181413] RSP: 0018:ffff880113183c90 =A0EFLAGS: 00010286
> [ 3240.181465] RAX: 0000000000000046 RBX: ffff88013e70eb40 RCX:
> 000000000003ffff
> [ 3240.181520] RDX: ffff8800282c0000 RSI: 0000000000000086 RDI:
> 0000000000000000
> [ 3240.181575] RBP: ffff880113183cf0 R08: 0000000000000000 R09:
> ffffffff816ac57f
> [ 3240.181630] R10: 0000000000000000 R11: 0000000000000004 R12:
> 0000000000000000
> [ 3240.181685] R13: ffff880118ce1d90 R14: ffff880113182000 R15:
> ffff88013f00a000
> [ 3240.181740] FS: =A00000000000000000(0000) GS:ffff8800282c0000(0000=
)
> knlGS:0000000000000000
> [ 3240.181837] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 3240.181890] CR2: 00007fc6e1ceb3dc CR3: 00000000018d3000 CR4:
> 00000000000006e0
> [ 3240.182733] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 3240.182788] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [ 3240.182844] Process btrfs-relocate- (pid: 6143, threadinfo
> ffff880113182000, task ffff880138c78380)
> [ 3240.182942] Stack:
> [ 3240.182988] =A0ffff880113183d20 0000000000000002 0000000000000008
> 0000000000000206
> [ 3240.183050] <0> ffff880113183d20 ffff880113e948e0 0000000000000000
> 0000000000000000
> [ 3240.183158] <0> ffff88013e70eb40 ffff88011b8d6f40 0000000000000000
> ffff880113182000
> [ 3240.183309] Call Trace:
> [ 3240.183358] =A0[<ffffffff8129e7ff>] walk_up_tree+0x13f/0x1c0
> [ 3240.183412] =A0[<ffffffff8129fa68>] btrfs_drop_snapshot+0x218/0x5e=
0
> [ 3240.183466] =A0[<ffffffff812a9e80>] ? __btrfs_end_transaction+0x10=
0/0x170
> [ 3240.183680] =A0[<ffffffff812e7e2d>] merge_func+0x7d/0xc0
> [ 3240.183735] =A0[<ffffffff812d265a>] worker_loop+0x17a/0x540
> [ 3240.183789] =A0[<ffffffff812d24e0>] ? worker_loop+0x0/0x540
> [ 3240.183842] =A0[<ffffffff812d24e0>] ? worker_loop+0x0/0x540
> [ 3240.183895] =A0[<ffffffff81095936>] kthread+0x96/0xa0
> [ 3240.183949] =A0[<ffffffff81034bd4>] kernel_thread_helper+0x4/0x10
> [ 3240.184004] =A0[<ffffffff816ac929>] ? restore_args+0x0/0x30
> [ 3240.184057] =A0[<ffffffff810958a0>] ? kthread+0x0/0xa0
> [ 3240.184109] =A0[<ffffffff81034bd0>] ? kernel_thread_helper+0x0/0x1=
0
> [ 3240.184162] Code: 4e 1c 48 c7 c7 98 6a 81 81 83 e2 02 48 8b 45 b0 =
41
> 0f 95 c1 48 8b 0c c3 4a 8b 14 e3 41 83 e1 01 49 8b 75 00 31 c0 e8 2d =
af
> 40 00 <0f> 0b eb fe 0f 1f 44 00 00 4c 89 ef e8 40 70 03 00 4c 89 ef e=
8
> [ 3240.184466] RIP =A0[<ffffffff8129e65f>] walk_up_proc+0x42f/0x490
> [ 3240.184522] =A0RSP <ffff880113183c90>
> [ 3240.184878] ---[ end trace 3c8b3f22cb58d773 ]---
>
>

Please run btrfsck and mount the fs with the new patches attached
below. Thank you

Yan, Zheng,

=46or btrfs kernel module:
---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2010-01-22 12:16:34.203525744 +0800
+++ 2/fs/btrfs/extent-tree.c	2010-01-31 09:29:01.131484542 +0800
@@ -5372,9 +5372,19 @@ static noinline int walk_up_proc(struct
 	if (eb =3D=3D root->node) {
 		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF)
 			parent =3D eb->start;
-		else
-			BUG_ON(root->root_key.objectid !=3D
-			       btrfs_header_owner(eb));
+		else {	=09
+			if (root->root_key.objectid !=3D btrfs_header_owner(eb)) {
+				printk("root %llu %llu\n",
+					root->root_key.objectid, root->root_key.offset);
+				printk("node %llu refs %llu flags %llu owner %llu "
+					"reloc %d level %d nritems %d\n",
+					eb->start, wc->refs[level], wc->flags[level],
+					btrfs_header_owner(eb),
+					btrfs_header_flag(eb, BTRFS_HEADER_FLAG_RELOC),
+					btrfs_header_level(eb), btrfs_header_nritems(eb));
+				BUG();
+			}
+		}
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

---

=46or btrfsck:
---
diff -urp btrfs-progs-unstable/btrfsck.c btrfs-progs-2/btrfsck.c
--- btrfs-progs-unstable/btrfsck.c	2009-09-28 15:54:55.980479398 +0800
+++ btrfs-progs-2/btrfsck.c	2010-01-31 09:46:24.645485459 +0800
@@ -581,7 +581,6 @@ again:
 		}
 		ret =3D insert_existing_cache_extent(dst, &ins->cache);
 		if (ret =3D=3D -EEXIST) {
-			WARN_ON(src =3D=3D &src_node->root_cache);
 			conflict =3D get_inode_rec(dst, rec->ino, 1);
 			merge_inode_recs(rec, conflict, dst);
 			if (rec->checked) {
---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
