Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54115 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbaAKMiX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 07:38:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W1xpU-0001oI-1p
	for linux-btrfs@vger.kernel.org; Sat, 11 Jan 2014 13:38:20 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jan 2014 13:38:20 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jan 2014 13:38:20 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: WARNING: CPU: 0 PID: 5406 at fs/btrfs/extent-tree.c:5723 __btrfs_free_extent+0x692/0xb20()
Date: Sat, 11 Jan 2014 13:38:51 +0100
Message-ID: <tjq7qa-5af.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list!

By backup btrfs device fails to delete snapshots with the following 
backtrace:

[87332.200212] WARNING: CPU: 0 PID: 5406 at fs/btrfs/extent-tree.c:5723 
__btrfs_free_extent+0x692/0xb20()
[87332.200213] Modules linked in: rfcomm af_packet bnep vmnet(O) vmblock(O) 
vsock vmmon(O) vmci(O) reiserfs coretemp hwmon x86_pkg_temp_thermal joydev 
kvm_intel kvm crc32_pclmul crc32c_intel microcode btusb i2c_i801 bluetooth 
pcspkr r8169 lpc_ich mii evdev mfd_core sr_mod cdrom usb_storage pata_cmd64x 
unix
[87332.200227] CPU: 0 PID: 5406 Comm: btrfs-transacti Tainted: G           O 
3.12.6-gentoo #1
[87332.200228] Hardware name: To Be Filled By O.E.M. To Be Filled By 
O.E.M./Z68 Pro3, BIOS P2.10 05/07/2012
[87332.200229]  0000000000000000 0000000000000009 ffffffff816d58b0 
0000000000000000
[87332.200231]  ffffffff81045496 ffff8804065ee000 00000007fbd8d000 
0000000000000000
[87332.200233]  0000000000000000 0000000000000000 ffffffff811ed152 
000000000013b4cb
[87332.200234] Call Trace:
[87332.200239]  [<ffffffff816d58b0>] ? dump_stack+0x41/0x51
[87332.200241]  [<ffffffff81045496>] ? warn_slowpath_common+0x86/0xb0
[87332.200243]  [<ffffffff811ed152>] ? __btrfs_free_extent+0x692/0xb20
[87332.200246]  [<ffffffff81249ed3>] ? btrfs_merge_delayed_refs+0x203/0x3d0
[87332.200248]  [<ffffffff811f1348>] ? run_clustered_refs+0x408/0xea0
[87332.200249]  [<ffffffff811f15f7>] ? run_clustered_refs+0x6b7/0xea0
[87332.200252]  [<ffffffff812d4001>] ? rb_first_postorder+0x11/0x30
[87332.200253]  [<ffffffff811f5960>] ? btrfs_run_delayed_refs+0xd0/0x570
[87332.200256]  [<ffffffff816d91e9>] ? mutex_lock+0x9/0x30
[87332.200258]  [<ffffffff81205d15>] ? btrfs_commit_transaction+0xb5/0x940
[87332.200260]  [<ffffffff811fe6ed>] ? transaction_kthread+0x1ad/0x220
[87332.200262]  [<ffffffff811fe540>] ? cleaner_kthread+0x180/0x180
[87332.200264]  [<ffffffff81066363>] ? kthread+0xb3/0xc0
[87332.200267]  [<ffffffff81060000>] ? __queue_delayed_work+0xb0/0x1c0
[87332.200269]  [<ffffffff810662b0>] ? kthread_create_on_node+0x110/0x110
[87332.200271]  [<ffffffff816dc67c>] ? ret_from_fork+0x7c/0xb0
[87332.200272]  [<ffffffff810662b0>] ? kthread_create_on_node+0x110/0x110
[87332.200273] ---[ end trace d93b78eca70d913b ]---
[87332.200275] BTRFS error (device sdd1): unable to find ref byte nr 
34290061312 parent 0 root 256  owner 1291467 offset 0
[87332.200277] BTRFS debug (device sdd1): run_one_delayed_ref returned -2

This is repeated a few times before the device forces itself read-only. 
Before this backtrace there are many logs like the following:

[87332.200043] BTRFS info (device sdd1): leaf 1442201382912 total ptrs 59 
free space 133
[87332.200053]  item 0 key (34287337472 168 69632) itemoff 3903 itemsize 92
[87332.200055]          extent refs 4 gen 29648 flags 1
[87332.200056]          extent data backref root 256 objectid 5365905 offset 
0 count 1
[87332.200057]          shared data backref parent 915180654592 count 1
[87332.200057]          shared data backref parent 849297317888 count 1
[87332.200058]          shared data backref parent 637800087552 count 1
[87332.200059]  item 1 key (34287407104 168 524288) itemoff 3866 itemsize 37
[87332.200060]          extent refs 1 gen 33774 flags 1
[87332.200061]          shared data backref parent 1436375404544 count 1
...

The full log is here:
https://gist.github.com/kakra/9fc1fb2f7c14371b1417

I tried to fix it with btrfsck but it fails an assertion. Before I reformat 
that device please tell me which info you need to investigate this problem 
to help making btrfs better. The data on this device is rebuildable but 
since it is my backup device I do not want to wait too long before 
reformatting and rebuilding it.

The output of "btrfs check" is very verbose full with these messages:

Extent back ref already exists for ... parent ... root 0

Then after a huge pile of those I get a lot of these:

leaf parent key incorrect 118640640
bad block 118640640
bad block 206397440
leaf parent key incorrect 462364672
bad block 462364672
leaf parent key incorrect 463065088
bad block 463065088
bad block 578629632
...

I don't know what "bad block" means. The device has no bad blocks. So this 
probably means there is some logical error in the block.

Later there are many of those:

ref mismatch on [1954885156864 2220032] extent item 27, found 28
Backref 1954885156864 parent 1430987673600 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 1954885156864 parent 1430987673600 owner 0 
offset 0 found 1 wanted 0 back 0xc7d2f3a0
backpointer mismatch on [1954885156864 2220032]
Errors found in extent allocation tree or chunk allocation

If of interest, I will post a full log of "btrfs check" output.

Thanks,
Kai

