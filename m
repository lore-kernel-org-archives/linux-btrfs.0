Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:31736 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2HSWNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Aug 2012 18:13:41 -0400
Received: from 75.135.79.188.dynamic.jazztel.es ([188.79.135.75] helo=mail.viric.name)
	by mho-01-ewr.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <viric@viric.name>)
	id 1T3Dka-0008Sn-4p
	for linux-btrfs@vger.kernel.org; Sun, 19 Aug 2012 22:13:40 +0000
Date: Mon, 20 Aug 2012 00:13:35 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: State of btrfs on ARM
Message-ID: <20120819221335.GB1960@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I just tried to mount a btrfs on 3.4.6, on armv5tel, and it wrote an oops.
Should it work on btrfsnext? Anyone working on that, if not?

I tried "mount -o compress=lzo myfile-with-holes /mnt/btrfs".

Here is the full dmesg:
http://viric.name/tmp/btrfs-arm.txt

Thank you,
Lluís.

Excerpt and objdump -d of the function at the top of the stack:
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:3666!
Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
Modules linked in: btrfs lzo_compress sg fuse ipv6 scsi_wait_scan ums_cypress dm_mod ext4 jbd2 reiserfs
CPU: 0    Not tainted  (3.4.6 #1)
PC is at btrfs_num_copies+0xe8/0xf4 [btrfs]
LR is at __lookup_extent_mapping+0xc0/0x1f4 [btrfs]
pc : [<bf2004f4>]    lr : [<bf1daa50>]    psr: 60000013
sp : df2dfc48  ip : df2dfbf8  fp : df2dfc74
r10: c5082020  r9 : 00000000  r8 : 00001000
r7 : b8000000  r6 : 00009000  r5 : 00000000  r4 : df2de000
r3 : 00000000  r2 : 00400000  r1 : 00000000  r0 : 00000000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: 1f384000  DAC: 00000015
Process mount (pid: 29991, stack limit = 0xdf2de270)
Stack: (0xdf2dfc48 to 0xdf2e0000)
fc40:                   00001000 00000000 def0e170 00000000 00000000 df1ad800
fc60: fffffffb bf1bb0a8 df2dfcc4 df2dfc78 bf1bd89c bf20041c 00001000 00000000
fc80: 00000000 00000004 00000004 00000000 cf97b000 00000000 df1ad800 def0e170
fca0: df1ad800 cf97a000 cf97b000 00000000 df1ad800 00000000 df2dfce4 df2dfcc8
fcc0: bf1be084 bf1bd824 00001000 00000002 00000004 00000000 df2dfdec df2dfce8
fce0: bf1c2118 bf1be054 00001000 cf97a000 00000004 00000000 00000000 00000004
fd00: 00001000 10010000 df19f764 00001000 00001000 cf97a630 cf97a6b0 cf97a570
fd20: cf97a530 cf97a4f0 cf97a4b0 cf97a470 cf97a670 cf97a5f0 cf97a5b0 cf97a430
fd40: cf97a3f0 df1ad810 df1ad400 00001000 00001000 cf97a324 000000b8 00000000
fd60: 00000000 00000000 00000000 00000000 cf97a0ac cf97a1a8 cf97a3b0 00000000
fd80: cf97a33c df1a8240 00000004 00000000 df19f600 dea12c00 de89f400 df2dfdb4
fda0: df2dfddc df2dfdb8 c022dcd4 c0243cc4 c057bfb0 df19f764 00000000 00000000
fdc0: 00000000 cf97a000 df19f600 00000001 df33b000 00000000 bf251cec 00000003
fde0: df2dfe94 df2dfdf0 bf192e04 bf1c0fa4 df2dfe1c df2dfe00 c079dd88 df2dfe44
fe00: 00000000 ffffffff c6781a18 00000000 00000000 00000000 dfa952c0 00000000
fe20: df2dfe6c 706f6f6c c00c0030 c00ca210 c023a50c c00cbbb8 df1b26b8 00000000
fe40: c06ad1ac df125189 df12518c dfa952c0 000000d0 df1251a0 dfa952c0 df1a8240
fe60: 00000000 df1251a0 0000000b df1b2640 bf251cec bf251cec 00000000 df33b000
fe80: 00000000 dfa95460 df2dfec4 df2dfe98 c00d4f4c bf192828 00000005 bf251cec
fea0: bf251cec df1b2640 bf251cec dfa952c0 df33b000 00000000 df2dfeec df2dfec8
fec0: c00ef0bc c00d4f38 df33b000 bf251cec dfa95460 df33b000 dfa952c0 00000000
fee0: df2dff14 df2dfef0 c00ef17c c00ef070 df33b000 00000020 00000000 df33b000
ff00: 00000000 dfa952c0 df2dff6c df2dff18 c00f1140 c00ef148 df2dff84 c00094a4
ff20: df2de000 00000000 dea101f0 c4838a00 c009ba5c c009b344 df2dff6c df2dff48
ff40: c00f0bb0 cf97c000 000230a0 c0ed0000 00000000 c00094a4 df2de000 00000000
ff60: df2dffa4 df2dff70 c00f14e0 c00f0cfc df33b000 df2dff80 c00cfa48 dfa95460
ff80: dfa952c0 df33b000 00022ed0 c0ed0000 00022ea8 00000015 00000000 df2dffa8
ffa0: c0009260 c00f145c 00022ed0 c0ed0000 000230a0 00022ea8 00023090 c0ed0000
ffc0: 00022ed0 c0ed0000 00022ea8 00000015 00022e90 beab21b0 00022ea8 000230a0
ffe0: ffffffef beab200c 0000b684 b6ec90d4 60000010 000230a0 1fffe831 1fffec31
[<bf2004f4>] (btrfs_num_copies+0xe8/0xf4 [btrfs]) from [<bf1bd89c>] (btree_read_extent_buffer_pages.constprop.30+0x88/0x13c [btrfs])
[<bf1bd89c>] (btree_read_extent_buffer_pages.constprop.30+0x88/0x13c [btrfs]) from [<bf1be084>] (read_tree_block+0x40/0x4c [btrfs])
[<bf1be084>] (read_tree_block+0x40/0x4c [btrfs]) from [<bf1c2118>] (open_ctree+0x1184/0x18d4 [btrfs])
[<bf1c2118>] (open_ctree+0x1184/0x18d4 [btrfs]) from [<bf192e04>] (btrfs_mount+0x5ec/0xa00 [btrfs])
[<bf192e04>] (btrfs_mount+0x5ec/0xa00 [btrfs]) from [<c00d4f4c>] (mount_fs+0x24/0xdc)
[<c00d4f4c>] (mount_fs+0x24/0xdc) from [<c00ef0bc>] (vfs_kern_mount+0x5c/0xd8)
[<c00ef0bc>] (vfs_kern_mount+0x5c/0xd8) from [<c00ef17c>] (do_kern_mount+0x44/0xe4)
[<c00ef17c>] (do_kern_mount+0x44/0xe4) from [<c00f1140>] (do_mount+0x454/0x730)
[<c00f1140>] (do_mount+0x454/0x730) from [<c00f14e0>] (sys_mount+0x94/0xd4)
[<c00f14e0>] (sys_mount+0x94/0xd4) from [<c0009260>] (ret_fast_syscall+0x0/0x2c)
Code: e1a00004 e24bd024 e89dabf0 e7f001f2 (e7f001f2) 
---[ end trace a202a06e5e402bbe ]---


0007440c <btrfs_num_copies>:
   7440c:       e1a0c00d        mov     ip, sp
   74410:       e92ddbf0        push    {r4, r5, r6, r7, r8, r9, fp, ip, lr, pc}
   74414:       e24cb004        sub     fp, ip, #4
   74418:       e24dd008        sub     sp, sp, #8
   7441c:       e92d4000        push    {lr}
   74420:       ebfffffe        bl      0 <__gnu_mcount_nc>
   74424:       e1a0100d        mov     r1, sp
   74428:       e3c14d7f        bic     r4, r1, #8128   ; 0x1fc0
   7442c:       e3c4403f        bic     r4, r4, #63     ; 0x3f
   74430:       e5941004        ldr     r1, [r4, #4]
   74434:       e1a06002        mov     r6, r2
   74438:       e1a07003        mov     r7, r3
   7443c:       e2811001        add     r1, r1, #1
   74440:       e5841004        str     r1, [r4, #4]
   74444:       e1cb80d4        ldrd    r8, [fp, #4]
   74448:       e1cd80f0        strd    r8, [sp]
   7444c:       ebfffffe        bl      4eb84 <lookup_extent_mapping>
   74450:       e1a05000        mov     r5, r0
   74454:       e5943004        ldr     r3, [r4, #4]
   74458:       e2433001        sub     r3, r3, #1
   7445c:       e5843004        str     r3, [r4, #4]
   74460:       e5943000        ldr     r3, [r4]
   74464:       e3130002        tst     r3, #2
   74468:       1a000022        bne     744f8 <btrfs_num_copies+0xec>
   7446c:       e3550000        cmp     r5, #0
   74470:       0a00001f        beq     744f4 <btrfs_num_copies+0xe8>
   74474:       e1c501d0        ldrd    r0, [r5, #16]
   74478:       e1570001        cmp     r7, r1
   7447c:       01560000        cmpeq   r6, r0
   74480:       3a00001a        bcc     744f0 <btrfs_num_copies+0xe4>
   74484:       e1c521d8        ldrd    r2, [r5, #24]
   74488:       e0922000        adds    r2, r2, r0
   7448c:       e0a33001        adc     r3, r3, r1
   74490:       e1530007        cmp     r3, r7
   74494:       01520006        cmpeq   r2, r6
   74498:       3a000014        bcc     744f0 <btrfs_num_copies+0xe4>
   7449c:       e595103c        ldr     r1, [r5, #60]   ; 0x3c
   744a0:       e3a02030        mov     r2, #48 ; 0x30
   744a4:       e3a03000        mov     r3, #0
   744a8:       e1c160d0        ldrd    r6, [r1]
   744ac:       e0022006        and     r2, r2, r6
   744b0:       e0033007        and     r3, r3, r7
   744b4:       e1920003        orrs    r0, r2, r3
   744b8:       15914018        ldrne   r4, [r1, #24]
   744bc:       1a000006        bne     744dc <btrfs_num_copies+0xd0>
   744c0:       e3a02040        mov     r2, #64 ; 0x40
   744c4:       e3a03000        mov     r3, #0
   744c8:       e0022006        and     r2, r2, r6
   744cc:       e0033007        and     r3, r3, r7
   744d0:       e1920003        orrs    r0, r2, r3
   744d4:       1591401c        ldrne   r4, [r1, #28]
   744d8:       03a04001        moveq   r4, #1
   744dc:       e1a00005        mov     r0, r5
   744e0:       ebfffffe        bl      4e7b8 <free_extent_map>
   744e4:       e1a00004        mov     r0, r4
   744e8:       e24bd024        sub     sp, fp, #36     ; 0x24
   744ec:       e89dabf0        ldm     sp, {r4, r5, r6, r7, r8, r9, fp, sp, pc}
   744f0:       e7f001f2        .word   0xe7f001f2
   744f4:       e7f001f2        .word   0xe7f001f2
   744f8:       ebfffffe        bl      0 <preempt_schedule>
   744fc:       eaffffda        b       7446c <btrfs_num_copies+0x60>
