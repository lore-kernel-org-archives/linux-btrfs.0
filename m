Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16941 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229Ab3DSIvi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Apr 2013 04:51:38 -0400
Message-ID: <517105DB.3050304@oracle.com>
Date: Fri, 19 Apr 2013 16:52:43 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Kurt Huwig <kurthuwig@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: (3.9-rc5) WARNING: at fs/btrfs/super.c:255 __btrfs_abort_transaction
References: <CAEct+bDZi1rzOPOL_Zeoi=fEPsyAen67OJ+t71K8VZy8BLYvVw@mail.gmail.com> <CAEct+bA0sFqjv3AT7Oj+pfSQJyCOpkgH+cipY71E-TVsRi7Trg@mail.gmail.com> <20130409120154.GG18193@twin.jikos.cz>
In-Reply-To: <20130409120154.GG18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Another reproducer is reporting the same effect. as below.

----
mkfs.btrfs /dev/dm-2 /dev/dm-4 -f -m raid1 -d raid1

x="0 0 3 0"; echo "scsi remove-single-device $x" > /proc/scsi/scsi

mount -o degraded /dev/dm-2 /btrfs

btrfs fi show
Label: none  uuid: 8ae8e37e-9f04-4a90-9c85-0c75a7622405
	Total devices 2 FS bytes used 28.00KB
	devid    1 size 59.99GB used 2.03GB path /dev/dm-2
	*** Some devices missing

btrfs fi bal start -mconvert=single -dconvert=single -f /btrfs
ERROR: error during balancing '/btrfs' - Input/output error
There may be more info in syslog - try dmesg | tail
----

------------------------
[692080.207670] btrfs: open /dev/dm-4 failed
[692080.228255] btrfs: allowing degraded mounts
[692080.228265] btrfs: disk space caching is enabled
[692080.229775] btrfs: mismatching generation and generation_v2 found in 
root item. This root was probably mounted with an older kernel. 
Resetting all new fields.
[692080.230068] SELinux: initialized (dev dm-2, type btrfs), uses xattr
[692129.083932] btrfs: force reducing metadata integrity
[692129.088603] BTRFS error (device dm-2) in write_all_supers:3178: IO 
failure (errors while submitting device barriers.)
[692129.088613] btrfs is forced readonly
[692129.088618] BTRFS warning (device dm-2): Skipping commit of aborted 
transaction.
[692129.088622] ------------[ cut here ]------------
[692129.088655] WARNING: at fs/btrfs/super.c:255 
__btrfs_abort_transaction+0xb9/0xd0 [btrfs]()
[692129.088659] Hardware name: SUN BLADE X6240 SERVER MODULE
[692129.088661] btrfs: Transaction aborted
[692129.088664] Modules linked in: btrfs zlib_deflate libcrc32c [last 
unloaded: libcrc32c]
[692129.088677] Pid: 30620, comm: btrfs Tainted: G        W    3.8.0+ #1
[692129.088680] Call Trace:
[692129.088695]  [<ffffffff8103d39a>] warn_slowpath_common+0x7a/0xb0
[692129.088702]  [<ffffffff8103d471>] warn_slowpath_fmt+0x41/0x50
[692129.088733]  [<ffffffffa01de819>] 
__btrfs_abort_transaction+0xb9/0xd0 [btrfs]
[692129.088768]  [<ffffffffa0209199>] cleanup_transaction+0x69/0x290 [btrfs]
[692129.088792]  [<ffffffffa01de5b1>] ? btrfs_printk+0x91/0x100 [btrfs]
[692129.088802]  [<ffffffff810608f0>] ? wake_up_bit+0x40/0x40
[692129.088833]  [<ffffffffa0209b41>] 
btrfs_commit_transaction+0x781/0xa40 [btrfs]
[692129.088861]  [<ffffffffa0201879>] ? btree_set_page_dirty+0x9/0x10 
[btrfs]
[692129.088902]  [<ffffffff810608f0>] ? wake_up_bit+0x40/0x40
[692129.088956]  [<ffffffffa022eda4>] insert_balance_item+0x374/0x390 
[btrfs]
[692129.088990]  [<ffffffffa022f763>] btrfs_balance+0x313/0xe10 [btrfs]
[692129.088999]  [<ffffffff8127924f>] ? cred_has_capability+0x6f/0xf0
[692129.089005]  [<ffffffff8113a101>] ? __sb_start_write+0x71/0x110
[692129.089012]  [<ffffffff81131ab3>] ? __kmalloc_track_caller+0x53/0x160
[692129.089034]  [<ffffffffa023a4da>] ? btrfs_ioctl_balance+0x14a/0x340 
[btrfs]
[692129.089039]  [<ffffffff81131ca4>] ? __kmalloc+0xe4/0x150
[692129.089061]  [<ffffffffa0239c7f>] ? kzalloc+0xf/0x20 [btrfs]
[692129.089082]  [<ffffffffa023a5aa>] btrfs_ioctl_balance+0x21a/0x340 
[btrfs]
[692129.089105]  [<ffffffffa023d065>] btrfs_ioctl+0x5a5/0x12a0 [btrfs]
[692129.089113]  [<ffffffff81112d8b>] ? handle_mm_fault+0x12b/0x230
[692129.089121]  [<ffffffff818b04bc>] ? __do_page_fault+0x27c/0x470
[692129.089128]  [<ffffffff81149478>] do_vfs_ioctl+0x98/0x550
[692129.089133]  [<ffffffff8127b67d>] ? file_has_perm+0x8d/0xb0
[692129.089138]  [<ffffffff811499c1>] sys_ioctl+0x91/0xa0
[692129.089144]  [<ffffffff818b4752>] system_call_fastpath+0x16/0x1b
[692129.089148] ---[ end trace da0fcdc03803014b ]---
[692129.089153] BTRFS error (device dm-2) in cleanup_transaction:1457: 
IO failure
[692129.089159] delayed_refs has NO entry
---------------------------------------------
