From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Hang when trying to access fs
Date: Sat, 28 Jan 2012 10:11:25 -0500
Message-ID: <874nvf50bm.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

When trying to rsync to btrfs, the process just hangs. dmesg output
alternates between:

Jan 28 09:42:49 vostro kernel: [  360.460076] INFO: task rsync:3484 blo=
cked for more than 120 seconds.
Jan 28 09:42:49 vostro kernel: [  360.460079] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Jan 28 09:42:49 vostro kernel: [  360.460081] rsync           D ffff880=
09d8d7850     0  3484      1 0x00000004
Jan 28 09:42:49 vostro kernel: [  360.460085]  ffff88009d8d7850 0000000=
000000082 0000000000000000 ffff88009b4d1810
Jan 28 09:42:49 vostro kernel: [  360.460089]  0000000000012f40 ffff880=
092361fd8 ffff880092361fd8 ffff88009d8d7850
Jan 28 09:42:49 vostro kernel: [  360.460092]  0000000000000246 fffffff=
f8132de1c ffff88009b5342f0 ffff880094051e80
Jan 28 09:42:49 vostro kernel: [  360.460096] Call Trace:
Jan 28 09:42:49 vostro kernel: [  360.460102]  [<ffffffff8132de1c>] ? _=
raw_spin_lock_irqsave+0x9/0x25
Jan 28 09:42:49 vostro kernel: [  360.460118]  [<ffffffffa05afd19>] ? w=
ait_current_trans.isra.22+0xae/0xdd [btrfs]
Jan 28 09:42:49 vostro kernel: [  360.460122]  [<ffffffff8105ec6b>] ? a=
dd_wait_queue+0x3c/0x3c
Jan 28 09:42:49 vostro kernel: [  360.460132]  [<ffffffffa05b0f82>] ? s=
tart_transaction+0x231/0x246 [btrfs]
Jan 28 09:42:49 vostro kernel: [  360.460144]  [<ffffffffa05b9772>] ? b=
trfs_dirty_inode+0x23/0x11d [btrfs]
Jan 28 09:42:49 vostro kernel: [  360.460148]  [<ffffffff8111001c>] ? _=
_mark_inode_dirty+0x22/0x17a
Jan 28 09:42:49 vostro kernel: [  360.460159]  [<ffffffffa05b891e>] ? b=
trfs_setattr+0x6d/0x92 [btrfs]
Jan 28 09:42:49 vostro kernel: [  360.460162]  [<ffffffff81107642>] ? n=
otify_change+0x18e/0x256
Jan 28 09:42:49 vostro kernel: [  360.460165]  [<ffffffff810353a7>] ? s=
hould_resched+0x5/0x23
Jan 28 09:42:49 vostro kernel: [  360.460168]  [<ffffffff81114930>] ? u=
times_common+0x10c/0x135
Jan 28 09:42:49 vostro kernel: [  360.460170]  [<ffffffff81114a14>] ? d=
o_utimes+0xbb/0xd6
Jan 28 09:42:49 vostro kernel: [  360.460173]  [<ffffffff810f779c>] ? s=
ys_newlstat+0x23/0x2b
Jan 28 09:42:49 vostro kernel: [  360.460175]  [<ffffffff810353a7>] ? s=
hould_resched+0x5/0x23
Jan 28 09:42:49 vostro kernel: [  360.460178]  [<ffffffff81114b1a>] ? s=
ys_utimensat+0x6e/0x77
Jan 28 09:42:49 vostro kernel: [  360.460181]  [<ffffffff81332e12>] ? s=
ystem_call_fastpath+0x16/0x1b

and

Jan 28 09:42:49 vostro kernel: [  360.460184] INFO: task rsync:3495 blo=
cked for more than 120 seconds.
Jan 28 09:42:49 vostro kernel: [  360.460185] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Jan 28 09:42:49 vostro kernel: [  360.460186] rsync           D ffff880=
0bfc92f40     0  3495      1 0x00000004
Jan 28 09:42:49 vostro kernel: [  360.460189]  ffff88009b4c47f0 0000000=
000000086 ffff880000000000 ffff8800bbf080c0
Jan 28 09:42:49 vostro kernel: [  360.460192]  0000000000012f40 ffff880=
091ff1fd8 ffff880091ff1fd8 ffff88009b4c47f0
Jan 28 09:42:49 vostro kernel: [  360.460196]  0000000000000000 0000000=
1bff5b700 ffffffff8102f71b ffff880094060a20
Jan 28 09:42:49 vostro kernel: [  360.460199] Call Trace:
Jan 28 09:42:49 vostro kernel: [  360.460202]  [<ffffffff8102f71b>] ? p=
te_alloc_one+0x2f/0x39
Jan 28 09:42:49 vostro kernel: [  360.460205]  [<ffffffff8132d437>] ? _=
_mutex_lock_common.isra.6+0xff/0x164
Jan 28 09:42:49 vostro kernel: [  360.460209]  [<ffffffff810cada2>] ? c=
opy_pte_range+0x34d/0x391
Jan 28 09:42:49 vostro kernel: [  360.460211]  [<ffffffff8132d325>] ? m=
utex_lock+0x1a/0x2d
Jan 28 09:42:49 vostro kernel: [  360.460214]  [<ffffffff810fcb6d>] ? w=
alk_component+0x1f4/0x406
Jan 28 09:42:49 vostro kernel: [  360.460217]  [<ffffffff8102f999>] ? p=
tep_set_access_flags+0x39/0x45
Jan 28 09:42:49 vostro kernel: [  360.460219]  [<ffffffff810fd9c1>] ? p=
ath_lookupat+0x7c/0x29e
Jan 28 09:42:49 vostro kernel: [  360.460222]  [<ffffffff810353a7>] ? s=
hould_resched+0x5/0x23
Jan 28 09:42:49 vostro kernel: [  360.460224]  [<ffffffff8132cb37>] ? _=
cond_resched+0x7/0x1c
Jan 28 09:42:49 vostro kernel: [  360.460227]  [<ffffffff810fdbff>] ? d=
o_path_lookup+0x1c/0x87
Jan 28 09:42:49 vostro kernel: [  360.460229]  [<ffffffff810ff47a>] ? u=
ser_path_at_empty+0x47/0x7b
Jan 28 09:42:49 vostro kernel: [  360.460232]  [<ffffffff81330dea>] ? d=
o_page_fault+0x2fc/0x337
Jan 28 09:42:49 vostro kernel: [  360.460234]  [<ffffffff810f7636>] ? v=
fs_fstatat+0x32/0x60
Jan 28 09:42:49 vostro kernel: [  360.460236]  [<ffffffff810f778b>] ? s=
ys_newlstat+0x12/0x2b
Jan 28 09:42:49 vostro kernel: [  360.460239]  [<ffffffff810353a7>] ? s=
hould_resched+0x5/0x23
Jan 28 09:42:49 vostro kernel: [  360.460241]  [<ffffffff8132e435>] ? p=
age_fault+0x25/0x30
Jan 28 09:42:49 vostro kernel: [  360.460244]  [<ffffffff81332e12>] ? s=
ystem_call_fastpath+0x16/0x1b


Kernel is 3.1.0. I'm writing to a 500 GB external USB disk.

Known bug? If not, anything I can do to help?


Best,

   -Nikolaus

--=20
 =C2=BBTime flies like an arrow, fruit flies like a Banana.=C2=AB

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
