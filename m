Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38421 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759959Ab2HXRme (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 13:42:34 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1T4xtx-0001TN-UY
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2012 10:42:33 -0700
Date: Fri, 24 Aug 2012 10:42:33 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: BUG: unable to handle kernel NULL pointer rcu_string_strdup.constprop.63+0x14/0x48
Message-ID: <20120824174233.GB18380@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With 3.5.2, I created 5 dm-crypted devices from 5 drives.
I created a raid0 btrfs filesystem and wrote stuff to it.
One drive died.

I rebooted and tried to do 
polgara:~# mount -o degraded -t btrfs  /dev/mapper/sdb1_crypt /mnt/mnt

In return, I got the crash below.
I don't need the data, and I can reproduce if needed.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffff811ff683>] rcu_string_strdup.constprop.63+0x14/0x48
PGD 7b938067 PUD 7b751067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
CPU 1
Modules linked in:[ 1352.208089]  loop xts gf128mul dm_crypt dm_mod aes_x86_64 sata_sil24 binfmt_misc rfcomm bluetooth rfkill nfsd lockd nfs_acl auth_rpcgss sunrpc ppdev autofs4 nls_utf8 ntfs atl1 mii lp parport fuse

Pid: 3430, comm: mount Not tainted 3.5.2-amd64-preempt-noide-20120819 #1 System manufacturer P5KC/P5KC
RIP: 0010:[<ffffffff811ff683>]  [<ffffffff811ff683>] rcu_string_strdup.constprop.63+0x14/0x48
RSP: 0018:ffff880074ca7ae8  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff880074e1d400 RCX: ffffffffffffffff
RDX: 00000000000001d8 RSI: ffff880074e1d5d8 RDI: 0000000000000010
RBP: ffff880074ca7b08 R08: 0000000000000050 R09: ffffffff81aa10e0
R10: 000000000000151c R11: 000000000000151c R12: 0000000000000010
R13: ffff880074d82958 R14: ffff880074d82978 R15: ffff880074e1d600
FS:  0000000000000000(0000) GS:ffff88007fc80000(0063) knlGS:00000000f756b920
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000010 CR3: 0000000074c1a000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 3430, threadinfo ffff880074ca6000, task ffff880074e3e3c0)
Stack:
 000000000000151c ffff880074e1d400 ffff880074d82900 ffff880074d82958
 ffff880074ca7b48 ffffffff811ff8f1 ffff880074e3e3c0 0000000000000000
 ffff880074d82900 ffff88007b20e400 ffff88007b20e000 ffff880074d82900
Call Trace:
 [<ffffffff811ff8f1>] __btrfs_close_devices+0xbc/0x19e
 [<ffffffff811ffb81>] btrfs_close_devices+0x23/0x7d
 [<ffffffff811dc061>] open_ctree+0x16ef/0x1786
 [<ffffffff8128eabc>] ? string.isra.3+0x3d/0xa4
 [<ffffffff811bf80f>] btrfs_mount+0x36f/0x4cf
 [<ffffffff810e439e>] ? pcpu_next_pop+0x38/0x45
 [<ffffffff8112ada7>] ? alloc_vfsmnt+0xa6/0x198
 [<ffffffff81117390>] mount_fs+0x64/0x150
 [<ffffffff810e5439>] ? __alloc_percpu+0xb/0xd
 [<ffffffff8112b156>] vfs_kern_mount+0x64/0xde
 [<ffffffff8112b544>] do_kern_mount+0x48/0xda
 [<ffffffff8112ce32>] do_mount+0x6a1/0x704
 [<ffffffff8112c6f7>] ? copy_mount_options+0xd4/0x13c
 [<ffffffff8114ffaa>] compat_sys_mount+0x208/0x242
 [<ffffffff81493d86>] sysenter_dispatch+0x7/0x21
Code: 00 00 00 49 8b 56 08 48 89 90 d0 00 00 00 5b 41 5c 41 5d 41 5e 5d c3 55 31 c0 48 83 c9 ff 48 89 e5 41 55 41 54 49 89 fc 53 41 52 <f2> ae 49 89 cd 49 f7 d5 49 8d 7d 10 e8 00 f8 ff ff 48 85 c0 48
RIP  [<ffffffff811ff683>] rcu_string_strdup.constprop.63+0x14/0x48
 RSP <ffff880074ca7ae8>
CR2: 0000000000000010
---[ end trace 65aa8af7efcd0e78 ]---
Kernel panic - not syncing: Fatal exception

All code
========
   0:	00 00                	add    %al,(%rax)
   2:	00 49 8b             	add    %cl,-0x75(%rcx)
   5:	56                   	push   %rsi
   6:	08 48 89             	or     %cl,-0x77(%rax)
   9:	90                   	nop
   a:	d0 00                	rolb   (%rax)
   c:	00 00                	add    %al,(%rax)
   e:	5b                   	pop    %rbx
   f:	41 5c                	pop    %r12
  11:	41 5d                	pop    %r13
  13:	41 5e                	pop    %r14
  15:	5d                   	pop    %rbp
  16:	c3                   	retq   
  17:	55                   	push   %rbp
  18:	31 c0                	xor    %eax,%eax
  1a:	48 83 c9 ff          	or     $0xffffffffffffffff,%rcx
  1e:	48 89 e5             	mov    %rsp,%rbp
  21:	41 55                	push   %r13
  23:	41 54                	push   %r12
  25:	49 89 fc             	mov    %rdi,%r12
  28:	53                   	push   %rbx
  29:	41 52                	push   %r10
  2b:*	f2 ae                	repnz scas %es     <-- trapping instruction:(%rdi),%al
  2d:	49 89 cd             	mov    %rcx,%r13
  30:	49 f7 d5             	not    %r13
  33:	49 8d 7d 10          	lea    0x10(%r13),%rdi
  37:	e8 00 f8 ff ff       	callq  0xfffffffffffff83c
  3c:	48 85 c0             	test   %rax,%rax
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	f2 ae                	repnz scas %es:(%rdi),%al
   2:	49 89 cd             	mov    %rcx,%r13
   5:	49 f7 d5             	not    %r13
   8:	49 8d 7d 10          	lea    0x10(%r13),%rdi
   c:	e8 00 f8 ff ff       	callq  0xfffffffffffff811
  11:	48 85 c0             	test   %rax,%rax
  14:	48                   	rex.W


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
