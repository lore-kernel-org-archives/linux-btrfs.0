Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35-i4.italiaonline.it ([212.48.25.220]:39029 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750867AbcLDSNp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 4 Dec 2016 13:13:45 -0500
From: Giuseppe Della Bianca <bepi@adria.it>
To: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Sun, 04 Dec 2016 19:11:23 +0100
Message-ID: <2329571.vMCvUE5AeF@exnet.gdb.it>
In-Reply-To: <CAJCQCtRpppbJb4a_zEdRFi7Fbxnhg5VkLktHuLMW2Z0H-cOkDg@mail.gmail.com>
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <5108140.l7kIxhTaVr@exnet.gdb.it> <CAJCQCtRpppbJb4a_zEdRFi7Fbxnhg5VkLktHuLMW2Z0H-cOkDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I haven't seen this with 4.7.10. I suggest running 'btrfs check'
> (without repair) using a recent btrfs-progs. You can find 4.8.3 in
> koji, just download the appropriate rpm, and 'dnf update *rpm'
> 
> As for kernel, Fedora 23 has 4.8.8 in updates (stable) and 4.8.10 is
> in updates-testing, I suggest moving to one of those.
> 
> 
> Chris Murphy

Same problem, this time on a local subvolume.
 
kernel-4.8.8-100.fc23.x86_64

btrfs-progs v4.8.5
 
P.S. Do you want to do some debugging?
     Otherwise I proceed with the reset of the partition.
	 My feeling is that in the btrfs receive function there is a random bug,
     which makes the file system unusable.
 
 
btrfs check /dev/sda2 
Checking filesystem on /dev/sda2 
UUID: d49d8f95-84ee-4452-9252-ad030a083739 
checking extents 
ref mismatch on [312324046848 16384] extent item 0, found 1 
Backref 312324046848 parent 1309 root 1309 not found in extent tree 
backpointer mismatch on [312324046848 16384] 
owner ref check failed [312324046848 16384] 
ref mismatch on [322595897344 16384] extent item 0, found 1 
Backref 322595897344 parent 1309 root 1309 not found in extent tree 
backpointer mismatch on [322595897344 16384] 
owner ref check failed [322595897344 16384] 
checking free space cache 
checking fs roots 
warning line 3822 
checking csums 
checking root refs 
found 162417897472 bytes used err is 0 
total csum bytes: 152292600 
total tree bytes: 6461636608 
total fs tree bytes: 6010830848 
total extent tree bytes: 281214976 
btree space waste bytes: 1142051927 
file data blocks allocated: 6628422606848 
referenced 961225981952

dmesg
 
[11265.556898] Call Trace: 
[11265.556908]  [<ffffffff923e493e>] dump_stack+0x63/0x85 
[11265.556916]  [<ffffffff920a0ecb>] __warn+0xcb/0xf0 
[11265.556919]  [<ffffffff920a0ffd>] warn_slowpath_null+0x1d/0x20 
[11265.556948]  [<ffffffffc0351504>] __btrfs_free_extent.isra.69+0x864/0xcc0 
[btrfs] 
[11265.556978]  [<ffffffffc0355cce>] __btrfs_run_delayed_refs+0xace/0x1220 [btrfs] 
[11265.557006]  [<ffffffffc03535dc>] ? btrfs_set_disk_extent_flags+0x7c/0xb0 
[btrfs] 
[11265.557034]  [<ffffffffc03592f3>] btrfs_run_delayed_refs+0x93/0x2b0 [btrfs] 
[11265.557077]  [<ffffffffc0395e5b>] ? free_extent_buffer+0x4b/0xa0 [btrfs] 
[11265.557112]  [<ffffffffc036e87a>] btrfs_should_end_transaction+0x5a/0x60 
[btrfs] 
[11265.557139]  [<ffffffffc0357a69>] btrfs_drop_snapshot+0x429/0x800 [btrfs] 
[11265.557172]  [<ffffffffc036fba9>] btrfs_clean_one_deleted_snapshot+0xa9/0xf0 
[btrfs] 
[11265.557202]  [<ffffffffc036650d>] cleaner_kthread+0x15d/0x1d0 [btrfs] 
[11265.557229]  [<ffffffffc03663b0>] ? btrfs_destroy_pinned_extent+0xf0/0xf0 
[btrfs] 
[11265.557235]  [<ffffffff920c0bf8>] kthread+0xd8/0xf0 
[11265.557242]  [<ffffffff927ffcbf>] ret_from_fork+0x1f/0x40 
[11265.557247]  [<ffffffff920c0b20>] ? kthread_worker_fn+0x170/0x170 
[11265.557282] ---[ end trace 577009d8a389f458 ]--- 
[11265.557288] BTRFS info (device sda2): leaf 327108411392 total ptrs 190 free 
space 88 
[11265.557292]  item 0 key (312323358720 169 0) itemoff 16142 itemsize 141 
[11265.557294]          extent refs 13 gen 2089 flags 258 
[11265.557295]          tree block backref root 1326 
[11265.557297]          tree block backref root 1324
..... long text ....
[11265.558885]          tree block backref root 1314 
[11265.558886]          shared block backref parent 322595897344 
[11265.558887]          shared block backref parent 322309390336 
[11265.558889]          shared block backref parent 322171060224 
[11265.558890]          shared block backref parent 319298207744 
[11265.558891]          shared block backref parent 312326356992 
[11265.558895] BTRFS error (device sda2): unable to find ref byte nr 
312324046848 parent 0 root 1309  owner 1 offset 0 
[11265.558901] ------------[ cut here ]------------ 
[11265.558931] WARNING: CPU: 3 PID: 6915 at fs/btrfs/extent-tree.c:6951 
__btrfs_free_extent.isra.69+0x8c8/0xcc0 [btrfs] 
[11265.558932] BTRFS: Transaction aborted (error -2)
.....  ....
[11265.559095] Call Trace: 
[11265.559102]  [<ffffffff923e493e>] dump_stack+0x63/0x85 
[11265.559108]  [<ffffffff920a0ecb>] __warn+0xcb/0xf0 
[11265.559114]  [<ffffffff920a0f4f>] warn_slowpath_fmt+0x5f/0x80 
[11265.559141]  [<ffffffffc0351568>] __btrfs_free_extent.isra.69+0x8c8/0xcc0 
[btrfs] 
[11265.559170]  [<ffffffffc0355cce>] __btrfs_run_delayed_refs+0xace/0x1220 [btrfs] 
[11265.559197]  [<ffffffffc03535dc>] ? btrfs_set_disk_extent_flags+0x7c/0xb0 
[btrfs] 
[11265.559225]  [<ffffffffc03592f3>] btrfs_run_delayed_refs+0x93/0x2b0 [btrfs] 
[11265.559265]  [<ffffffffc0395e5b>] ? free_extent_buffer+0x4b/0xa0 [btrfs] 
[11265.559298]  [<ffffffffc036e87a>] btrfs_should_end_transaction+0x5a/0x60 
[btrfs] 
[11265.559324]  [<ffffffffc0357a69>] btrfs_drop_snapshot+0x429/0x800 [btrfs] 
[11265.559355]  [<ffffffffc036fba9>] btrfs_clean_one_deleted_snapshot+0xa9/0xf0 
[btrfs] 
[11265.559384]  [<ffffffffc036650d>] cleaner_kthread+0x15d/0x1d0 [btrfs] 
[11265.559411]  [<ffffffffc03663b0>] ? btrfs_destroy_pinned_extent+0xf0/0xf0 
[btrfs] 
[11265.559416]  [<ffffffff920c0bf8>] kthread+0xd8/0xf0 
[11265.559423]  [<ffffffff927ffcbf>] ret_from_fork+0x1f/0x40 
[11265.559428]  [<ffffffff920c0b20>] ? kthread_worker_fn+0x170/0x170 
[11265.559431] ---[ end trace 577009d8a389f459 ]--- 
[11265.559434] BTRFS: error (device sda2) in __btrfs_free_extent:6951: 
errno=-2 No such entry 
[11265.559439] BTRFS info (device sda2): forced readonly 
[11265.559444] BTRFS: error (device sda2) in btrfs_run_delayed_refs:2960: 
errno=-2 No such entry 
[11265.805418] BTRFS error (device sda2): cleaner transaction attach returned 
-30

