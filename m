Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.183.188]:59154 "EHLO
	mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbbENJxp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 05:53:45 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.palepurple.co.uk (Postfix) with ESMTP id 96D4882C2
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2015 10:53:43 +0100 (BST)
Received: from mail.palepurple.co.uk ([127.0.0.1])
	by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
	with ESMTP id OuqIYU5vp-ls for <linux-btrfs@vger.kernel.org>;
	Thu, 14 May 2015 10:53:43 +0100 (BST)
Received: from [172.30.33.200] (host81-133-46-190.in-addr.btopenworld.com [81.133.46.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: david@palepurple.co.uk)
	by mail.palepurple.co.uk (Postfix) with ESMTPSA id 5A1E3804B
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2015 10:53:43 +0100 (BST)
Message-ID: <555470A7.4030604@codepoets.co.uk>
Date: Thu, 14 May 2015 10:53:43 +0100
From: David Goodwin <david@codepoets.co.uk>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: kernel BUG at
 /build/linux-RGM_Ed/linux-3.16.7-ckt9/mm/page_alloc.c:1011!
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Debian Jessie, kernel 3.16.0-4-amd64 / 3.16.7-ckt9-3~deb8u1

Kernel oops/panic, message below.

Hopefully of some use to someone...

If this problem is/was known and may be fixed, I'd be interested to know.


thanks
David.

------------[ cut here ]------------
kernel BUG at /build/linux-RGM_Ed/linux-3.16.7-ckt9/mm/page_alloc.c:1011!
invalid opcode: 0000 [#1] SMP
Modules linked in: binfmt_misc veth xt_multiport iptable_filter 
ip_tables x_tables ip_gre ip_tunnel gre bridge stp llc nfsd auth_rpcgss 
oid_registry nfs_acl nfs lockd fscache sunrpc crc32_pclmul 
ghash_clmulni_intel ppdev aesni_intel aes_x86_64 lrw gf128mul 
glue_helper ablk_helper psmouse cryptd evdev serio_raw ttm 
drm_kms_helper drm parport_pc parport i2c_piix4 i2c_core processor 
thermal_sys button fuse autofs4 ext4 crc16 mbcache jbd2 btrfs xor 
raid6_pq ata_generic xen_blkfront crct10dif_pclmul crct10dif_common 
crc32c_intel floppy ata_piix libata scsi_mod ixgbevf
CPU: 0 PID: 17878 Comm: rsync Not tainted 3.16.0-4-amd64 #1 Debian 
3.16.7-ckt9-3~deb8u1
Hardware name: Xen HVM domU, BIOS 4.2.amazon 12/03/2014
task: ffff8800c2690c60 ti: ffff8800e539c000 task.ti: ffff8800e539c000
RIP: 0010:[<ffffffff81142037>]  [<ffffffff81142037>] 
move_freepages+0x107/0x110
RSP: 0018:ffff8800e539f948  EFLAGS: 00010006
RAX: ffff8803e08fb000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: ffffea000d922fc8 RSI: ffffea000d91c000 RDI: ffff8803e08fbe00
RBP: 0000000000000001 R08: ffff8803e08fbe00 R09: 0000000000000000
R10: 0000000000000000 R11: ffff8803e08fbeb0 R12: ffffea000d91c150
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8803e08fbe00
FS:  00007f36d0dfa700(0000) GS:ffff8803e0400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f36cec74008 CR3: 00000002cd54e000 CR4: 00000000001406f0
Stack:
  ffffffff81143a6c 0000000000000000 000000020000024c ffffea000d91c170
  ffff8803e08fbe90 0000000100000000 0000000000000000 ffff8803e08fbe00
  000000000000001f 0000000000000000 0000000000000001 0000000000000008
Call Trace:
  [<ffffffff81143a6c>] ? __rmqueue+0x37c/0x460
  [<ffffffff81145c65>] ? get_page_from_freelist+0x685/0x910
  [<ffffffff8114605d>] ? __alloc_pages_nodemask+0x16d/0xb30
  [<ffffffffa013de17>] ? btrfs_get_token_16+0x57/0xf0 [btrfs]
  [<ffffffffa00fe8d1>] ? btrfs_set_path_blocking+0x31/0x70 [btrfs]
  [<ffffffff811c10fc>] ? find_inode+0x6c/0x90
  [<ffffffffa0128920>] ? btrfs_clean_one_deleted_snapshot+0x110/0x110 
[btrfs]
  [<ffffffffa0128c90>] ? create_pinned_em+0x130/0x130 [btrfs]
  [<ffffffff8118c8fb>] ? kmem_getpages+0x5b/0x110
  [<ffffffff8118dbeb>] ? cache_grow+0x21b/0x240
  [<ffffffff8118e623>] ? kmem_cache_alloc+0x183/0x450
  [<ffffffff811bf630>] ? __d_alloc+0x20/0x170
  [<ffffffff811bf793>] ? d_alloc+0x13/0x70
  [<ffffffff811b15eb>] ? lookup_dcache+0x8b/0xc0
  [<ffffffff811b163a>] ? __lookup_hash+0x1a/0x40
  [<ffffffff81509d67>] ? lookup_slow+0x3e/0xa3
  [<ffffffff811b3c15>] ? path_lookupat+0x715/0x780
  [<ffffffff8119dcb4>] ? __mem_cgroup_commit_charge+0x84/0x370
  [<ffffffff811b3ca6>] ? filename_lookup+0x26/0xc0
  [<ffffffff811b7d94>] ? user_path_at_empty+0x54/0x90
  [<ffffffff810eb46e>] ? from_kgid_munged+0xe/0x20
  [<ffffffff811accaa>] ? cp_new_stat+0x13a/0x160
  [<ffffffff811ac856>] ? vfs_fstatat+0x46/0x90
  [<ffffffff811acd2d>] ? SYSC_newlstat+0x1d/0x40
  [<ffffffff81510e4d>] ? system_call_fast_compare_end+0x10/0x15
Code: e1 4c 89 56 10 4d 63 c1 44 89 c9 4e 8d 0c c5 00 00 00 00 49 c1 e0 
06 01 c8 4d 29 c8 4c 01 c6 48 39 f2 73 89 5b 5d 41 5c 41 5d c3 <0f> 0b 
0f 1f 80 00 00 00 00 0f 1f 44 00 00 49 b9 00 00 00 00 00
RIP  [<ffffffff81142037>] move_freepages+0x107/0x110
  RSP <ffff8800e539f948>
---[ end trace 54088e552300a011 ]---

