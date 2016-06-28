Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38686 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbcF1M2Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 08:28:16 -0400
Received: by mail-wm0-f49.google.com with SMTP id r201so25353143wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 05:28:14 -0700 (PDT)
To: linux-btrfs@vger.kernel.org, dsterba@suse.com
Cc: clm@fb.com, SiteGround Operations <operations@siteground.com>
From: Nikolay Borisov <kernel@kyup.com>
Subject: btrfs_evit_inode doesn't handle not fully initialized inodes.
Message-ID: <57726D5B.3060300@kyup.com>
Date: Tue, 28 Jun 2016 15:28:11 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

On kernel 4.4.9 I've observed the following oops: 

[3248626.755570] BUG: unable to handle kernel NULL pointer dereference at 000000000000035c
[3248626.755839] IP: [<ffffffffa0901bcf>] btrfs_evict_inode+0x2f/0x610 [btrfs]
[3248626.756079] PGD 1eaf8d067 PUD 4096a0067 PMD 0 
[3248626.756383] Oops: 0000 [#1] SMP 
[3248626.756637] Modules linked in: <OMMITTED>
[3248626.760475] CPU: 6 PID: 16899 Comm: rsync Tainted: P        W  O    4.4.9-clouder1 #20
[3248626.760647] Hardware name: Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.0a 12/05/2013
[3248626.760932] task: ffff880338268000 ti: ffff8802a4f04000 task.ti: ffff8802a4f04000
[3248626.761102] RIP: 0010:[<ffffffffa0901bcf>]  [<ffffffffa0901bcf>] btrfs_evict_inode+0x2f/0x610 [btrfs]
[3248626.761447] RSP: 0018:ffff8802a4f07b88  EFLAGS: 00010286
[3248626.761613] RAX: 0000000000000000 RBX: ffff880011548fa0 RCX: 0000000000000034
[3248626.761784] RDX: ffff88047fffa780 RSI: 0000000000000735 RDI: ffff880011549150
[3248626.761954] RBP: ffff8802a4f07c28 R08: ffffea0009baa1d0 R09: 0000000000000000
[3248626.762127] R10: 0000000000000001 R11: 0000000000000001 R12: ffff880011549270
[3248626.762298] R13: ffffffffa0970e40 R14: ffffffffa0970e40 R15: ffff8802a4f07c88
[3248626.762469] FS:  00007f7dc9c3e700(0000) GS:ffff88047fcc0000(0000) knlGS:0000000000000000
[3248626.762642] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[3248626.762810] CR2: 000000000000035c CR3: 0000000103ca8000 CR4: 00000000000406e0
[3248626.762980] Stack:
[3248626.763143]  ffff8803cdee9870 0000000000000001 ffff8802a4f07c08 ffffffff811c95f9
[3248626.763495]  ffff8800115491f0 0000000000000000 0000000000000000 ffff880011549150
[3248626.763846]  ffff880338268000 ffffffff81095940 ffff8802a4f07bd8 ffff8802a4f07bd8
[3248626.764195] Call Trace:
[3248626.764361]  [<ffffffff811c95f9>] ? __inode_wait_for_writeback+0x69/0xc0
[3248626.764534]  [<ffffffff81095940>] ? wake_atomic_t_function+0x40/0x40
[3248626.764707]  [<ffffffff811bace6>] evict+0xc6/0x1c0
[3248626.764874]  [<ffffffff811bb058>] iput+0x198/0x270
[3248626.765043]  [<ffffffff811ba1da>] ? alloc_inode+0x3a/0x90
[3248626.765221]  [<ffffffffa08fb2bc>] btrfs_new_inode+0x47c/0x610 [btrfs]
[3248626.765400]  [<ffffffffa08e4195>] ? btrfs_find_free_objectid+0x55/0x70 [btrfs]
[3248626.765582]  [<ffffffffa08e4f17>] ? btrfs_find_free_ino+0x117/0x130 [btrfs]
[3248626.765764]  [<ffffffffa08fdf1c>] btrfs_symlink+0xfc/0x3e0 [btrfs]
[3248626.765931]  [<ffffffff811ac48d>] vfs_symlink+0x9d/0xd0
[3248626.766094]  [<ffffffff811ae425>] SyS_symlinkat+0xc5/0xf0
[3248626.766258]  [<ffffffff811a9f46>] SyS_symlink+0x16/0x20
[3248626.766422]  [<ffffffff81642ed7>] entry_SYSCALL_64_fastpath+0x12/0x6a
[3248626.766586] Code: 41 57 41 56 41 55 41 54 53 48 83 ec 78 66 66 66 66 90 48 89 7d 98 48 89 fb 48 8b 87 50 fe ff ff 48 81 eb b0 01 00 00 48 89 45 88 <8b> 90 5c 03 00 00 8b 05 ad 53 08 00 89 55 84 89 45 c0 85 c0 0f 
[3248626.769978] RIP  [<ffffffffa0901bcf>] btrfs_evict_inode+0x2f/0x610 [btrfs]
[3248626.770205]  RSP <ffff8802a4f07b88>
[3248626.770366] CR2: 000000000000035c

And right before it in the dmesg there were multiple errors like:
BTRFS error (device loop9): bad fsid on block 502972416

The RIP points to: 
/home/projects/linux-stable/fs/btrfs/ctree.h: 3391
0xffffffffa0901bcf <btrfs_evict_inode+47>:      mov    0x35c(%rax),%edx

which is btrfs_calc_trunc_metadata_size. This corresponds to the
root->nodesize lines. Essentially the root of the inode being passed is NULL 
as evident by the content of RAX. Furthermore the btrfs_inode->vfs_inode has its 
various fields set to default initialization values. Looking further into the call 
stack it seems that btrfs_new_inode fails in some of its steps and calls iput. 
Concretely I believe this is the culprit: 

ret = btrfs_set_inode_index(dir, index);                                                              
if (ret) {                                                                                            
	btrfs_free_path(path);
	iput(inode);
}

In this case if btrfs_set_inode_index fails and we call iput then, 
btrfs_evict_inode is going to be called with uninitialized inode 
which in turn leads to the null pointer deref. 

The only bogus value both inode structures have is the index_cnt: 
18446744073709551615 this is 2^64 

I'm happy to provide further info if necessary to help fix this. 

Regards, 
Nikolay 
