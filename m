Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:58590 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbbLaQKN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 11:10:13 -0500
Date: Thu, 31 Dec 2015 17:04:16 +0100
From: "Stephen R. van den Berg" <srb@cuci.nl>
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/send.c:1482
Message-ID: <20151231160416.GA5579@cuci.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running 4.4.0-rc7.
This exact problem was present on 4.0.5 and 4.3.3 too though.

I do a "btrfs send /var/lib/lxc/template64/rootfs", that generates
the following error consistently at the same file, over and over again:

Dec 29 14:49:04 argo kernel: kernel BUG at fs/btrfs/send.c:1482!
Dec 29 14:49:04 argo kernel: Modules linked in: nfsd
Dec 29 14:49:04 argo kernel: task: ffff880041295c40 ti: ffff88010423c000 task.ti: ffff88010423c000
Dec 29 14:49:04 argo kernel: RSP: 0018:ffff88010423fb20  EFLAGS: 00010202
Dec 29 14:49:04 argo kernel: RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000
Dec 29 14:49:04 argo kernel: R10: ffff88019d53b5e0 R11: 0000000000000000 R12: ffff8801b35ac510
Dec 29 14:49:04 argo kernel: FS:  00007fac9113f8c0(0000) GS:ffff88022fd80000(0000) knlGS:0000000000000000
Dec 29 14:49:04 argo kernel: CR2: 00007f99ba308520 CR3: 0000000154a40000 CR4: 00000000001006e0
Dec 29 14:49:04 argo kernel: 00000000000081ed 000000000009b15a 000000000000a1ff 0000000000000000
Dec 29 14:49:04 argo kernel: 000000000009b15a 0000000000000000 0000000000001a03 ffff8801baf2e800
Dec 29 14:49:04 argo kernel: [<ffffffff8129a8a3>] send_create_inode_if_needed+0x30/0x49
Dec 29 14:49:04 argo kernel: [<ffffffff81222923>] ? btrfs_item_key+0x19/0x1b
Dec 29 14:49:04 argo kernel: [<ffffffff8122a090>] btrfs_compare_trees+0x2f2/0x4fe
Dec 29 14:49:04 argo kernel: [<ffffffff8129e05b>] btrfs_ioctl_send+0x846/0xce5
Dec 29 14:49:04 argo kernel: [<ffffffff810a5c5f>] ? try_to_freeze_unsafe+0x9/0x32
Dec 29 14:49:04 argo kernel: [<ffffffff8158b499>] ? _raw_spin_lock_irq+0xf/0x11
Dec 29 14:49:04 argo kernel: [<ffffffff810a7299>] ? ptrace_do_notify+0x84/0x95
Dec 29 14:49:04 argo kernel: [<ffffffff811803a2>] SyS_ioctl+0x43/0x61
Dec 29 14:49:04 argo kernel: RIP  [<ffffffff8129a734>] send_create_inode+0x1ce/0x30d


On the receiving end, I have a "btrfs receive" which takes the above stream as
input, and *always* reports this:

receiving snapshot 20151230-141324.1451484804.965085668@argo uuid=53df0616-5715-ad40-ae81-78a023860fe0, ctransid=649684 parent_
uuid=d3f807da-1e9d-aa4d-ab01-77ce5e2fbcd7, parent_ctransid=649735
utimes 
rename bin -> o257-379784-0
mkdir o257-34888-0
rename o257-34888-0 -> bin
utimes 
chown bin - uid=0, gid=0
chmod bin - mode=0755
utimes bin
rmdir boot
ERROR: rmdir boot failed. No such file or directory
mkdir o258-34888-0
rename o258-34888-0 -> boot
utimes 
chown boot - uid=0, gid=0
chmod boot - mode=0755
utimes boot
rename dev -> o259-379784-0
mkdir o259-34888-0
rename o259-34888-0 -> dev
... rest of the logging follows as normal...
... then we get ...
rmdir media
mkdir o264-34888-0
rename o264-34888-0 -> media
utimes 
chown media - uid=0, gid=0
chmod media - mode=0755
utimes media
rmdir mnt
ERROR: rmdir mnt failed. No such file or directory
rmdir opt
mkdir o266-34888-0
rename o266-34888-0 -> opt
utimes 
... continues as normal ...

It then still creates lots of files, until it encounters the sudden EOF
due to the sending side experiencing the kernel bug and abruptly halting
the send.

Since the problem is consistently and easily reproducible, I can immediately
try any proposed patches or fixes (or provide more insight into the
subvolume this problem occurs with).
Numerous other subvolumes in the same BTRFS partition work flawlessly
using btrfs send/receive.

The sending partition is RAID0 with two 512GB SSD drives.  The receiving
partition is RAID1 with 6 6TB HDD drives.
-- 
Stephen.
