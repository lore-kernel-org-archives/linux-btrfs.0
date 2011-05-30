From: James Cloos <cloos@jhcloos.com>
Subject: kernel BUG at fs/btrfs/inode.c:2260!
Date: Mon, 30 May 2011 13:33:21 -0400
Message-ID: <m3tyccay9y.fsf@jhcloos.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I got this today, running 2.6.39-07159-gf23a5e1.

The fs in question is mounted:

 /dev/sdXX on /usr/local/portage type btrfs (rw,noatime,compress=zlib)

The BUG_ON() call is from:

        if (!BTRFS_I(inode)->orphan_meta_reserved) {
                BTRFS_I(inode)->orphan_meta_reserved = 1;
                reserve = 1;
        }
/* *ELIDED* */
        /* grab metadata reservation from transaction handle */
        if (reserve) {
                ret = btrfs_orphan_reserve_metadata(trans, inode);
                BUG_ON(ret);
        }

and I cannot umount(8) that fs since this.  It claims to be in use.

A du(1) gets stuck but remains interuptable and quits cleanly when
signaled.

The load at the time of the BUG_ON(), for that fs, had significant
file creation, deletion and replacement.  It had previously (this
boot) been remotely mounted with nfs, but was not at the time of
the BUG_ON().


------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:2260!
invalid opcode: 0000 [#1] PREEMPT SMP 
CPU 1 
Modules linked in: k10temp

Pid: 1343, comm: g-common Not tainted 2.6.39-07159-gf23a5e1 #57 MSI MS-7642/890GXM-G65 (MS-7642)  
RIP: 0010:[<ffffffff8124144d>]  [<ffffffff8124144d>] btrfs_orphan_add+0xfa/0x13c
RSP: 0018:ffff88001a51bdd8  EFLAGS: 00010286
RAX: 00000000ffffffe4 RBX: ffff8802fb8e9000 RCX: ffff8802bd624530
RDX: 0000000000000000 RSI: ffff8802bd624530 RDI: ffff88001a51a000
RBP: ffff88001a51be18 R08: ffff880103c890b8 R09: ffff88001a51bdb8
R10: ffffffff8162facd R11: ffff8802f8b6c108 R12: ffff8802e58da160
R13: ffff8802e599fa80 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f13ece50700(0000) GS:ffff88030fc40000(0000) knlGS:00000000557516c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f9d29db4f68 CR3: 0000000103a1b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process g-common (pid: 1343, threadinfo ffff88001a51a000, task ffff8802bd624530)
Stack:
 ffff8802fb8e9388 00000001fb8e9000 ffff88001a51be18 ffff8802e599fa80
 0000000000000000 ffff8802e58d9d68 ffff8802e58da160 ffff8802fb8e9000
 ffff88001a51be58 ffffffff81243bb1 ffff880007dc2900 ffff880007dc2900
Call Trace:
 [<ffffffff81243bb1>] btrfs_unlink+0x8e/0xbe
 [<ffffffff8111f5af>] vfs_unlink+0x6d/0xb7
 [<ffffffff8112b0f2>] ? mnt_want_write+0x71/0x81
 [<ffffffff8111f911>] do_unlinkat+0xce/0x155
 [<ffffffff81117bde>] ? sys_newlstat+0x2a/0x33
 [<ffffffff81120375>] sys_unlink+0x16/0x18
 [<ffffffff816328d2>] system_call_fastpath+0x16/0x1b
Code: 3e 00 4d 85 f6 74 0f 48 8b bb 20 01 00 00 4c 89 f6 e8 69 bc fe ff 83 7d cc 00 74 11 4c 89 e6 4c 89 ef e8 7c bf fe ff 85 c0 74 02 <0f> 0b 41 ff cf 75 2a 49 8b 94 24 68 fe ff ff 48 81 fa 00 01 00 
RIP  [<ffffffff8124144d>] btrfs_orphan_add+0xfa/0x13c
 RSP <ffff88001a51bdd8>
---[ end trace f858840206b4cbb6 ]---


-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
