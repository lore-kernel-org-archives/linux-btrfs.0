Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58700 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaD3GkH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 02:40:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WfOBX-0008SE-Up
	for linux-btrfs@vger.kernel.org; Wed, 30 Apr 2014 08:40:03 +0200
Received: from 80-218-32-173.dclient.hispeed.ch ([80.218.32.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 08:40:03 +0200
Received: from auslands-kv by 80-218-32-173.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 08:40:03 +0200
To: linux-btrfs@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: task sync:2450 blocked for more than 120 seconds.
Date: Wed, 30 Apr 2014 08:37:58 +0200
Message-ID: <ljq5o6$f0d$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I have a non-rootfs btrfs partition that I use for some work where I
like to keep some snapshots. The partition is about 160GB big and has
about 80-90 GB of data.

I often see the following errors:

Apr 29 20:41:24 DesktopMB kernel: [47030.195270] INFO: task sync:2450
blocked for more than 120 seconds.
Apr 29 20:41:24 DesktopMB kernel: [47030.195275]       Tainted: GF
    O 3.14.1-031401-generic #201404141220
Apr 29 20:41:24 DesktopMB kernel: [47030.195276] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 29 20:41:24 DesktopMB kernel: [47030.195277] sync            D
ffffffff818118e0     0  2450  29298 0x00000004
Apr 29 20:41:24 DesktopMB kernel: [47030.195280]  ffff8801261bbc68
0000000000000002 ffff8801261bbc18 ffff8801261bbfd8
Apr 29 20:41:24 DesktopMB kernel: [47030.195282]  00000000000144c0
00000000000144c0 ffff88022341b1e0 ffff88012606cad0
Apr 29 20:41:24 DesktopMB kernel: [47030.195284]  ffff8801261bbc68
ffff88022f3d4dc8 ffff88012606cad0 ffffffff8115f460
Apr 29 20:41:24 DesktopMB kernel: [47030.195286] Call Trace:
Apr 29 20:41:24 DesktopMB kernel: [47030.195292]  [<ffffffff8115f460>] ?
__lock_page+0x70/0x70
Apr 29 20:41:24 DesktopMB kernel: [47030.195295]  [<ffffffff817650e9>]
schedule+0x29/0x70
Apr 29 20:41:24 DesktopMB kernel: [47030.195297]  [<ffffffff817651bf>]
io_schedule+0x8f/0xd0
Apr 29 20:41:24 DesktopMB kernel: [47030.195299]  [<ffffffff8115f46e>]
sleep_on_page+0xe/0x20
Apr 29 20:41:24 DesktopMB kernel: [47030.195300]  [<ffffffff81765882>]
__wait_on_bit+0x62/0x90
Apr 29 20:41:24 DesktopMB kernel: [47030.195302]  [<ffffffff8115ff0b>] ?
find_get_pages_tag+0xcb/0x170
Apr 29 20:41:24 DesktopMB kernel: [47030.195304]  [<ffffffff8115f5d0>]
wait_on_page_bit+0x80/0x90
Apr 29 20:41:24 DesktopMB kernel: [47030.195307]  [<ffffffff810b51c0>] ?
wake_atomic_t_function+0x40/0x40
Apr 29 20:41:24 DesktopMB kernel: [47030.195309]  [<ffffffff8115f6d4>]
filemap_fdatawait_range+0xf4/0x180
Apr 29 20:41:24 DesktopMB kernel: [47030.195312]  [<ffffffff8108624a>] ?
__queue_delayed_work+0xaa/0x1a0
Apr 29 20:41:24 DesktopMB kernel: [47030.195314]  [<ffffffff810867c5>] ?
try_to_grab_pending+0x65/0x80
Apr 29 20:41:24 DesktopMB kernel: [47030.195316]  [<ffffffff8115f78b>]
filemap_fdatawait+0x2b/0x30
Apr 29 20:41:24 DesktopMB kernel: [47030.195319]  [<ffffffff811fa6a5>]
wait_sb_inodes+0xc5/0x120
Apr 29 20:41:24 DesktopMB kernel: [47030.195321]  [<ffffffff81202300>] ?
fdatawrite_one_bdev+0x20/0x20
Apr 29 20:41:24 DesktopMB kernel: [47030.195323]  [<ffffffff811fa7a3>]
sync_inodes_sb+0xa3/0xd0
Apr 29 20:41:24 DesktopMB kernel: [47030.195325]  [<ffffffff8120231d>]
sync_inodes_one_sb+0x1d/0x30
Apr 29 20:41:24 DesktopMB kernel: [47030.195328]  [<ffffffff811d5711>]
iterate_supers+0xf1/0x100
Apr 29 20:41:24 DesktopMB kernel: [47030.195330]  [<ffffffff81202485>]
sys_sync+0x35/0x90
Apr 29 20:41:24 DesktopMB kernel: [47030.195333]  [<ffffffff8177247f>]
tracesys+0xe1/0xe6
Apr 29 20:43:24 DesktopMB kernel: [47150.168257] INFO: task sync:2450
blocked for more than 120 seconds.

In such a case I can only emergency remount and
power of the system. Nothing else.

I am still not sure how to exactly reproduce the error. But it only
happens, when the filesysstem has been used extensively for some time (I
am doing kernel compilation on that fs).

When I mount the system and then sync, nothing happens. After a full day
of work with some compiles, I can no longer unmount the fs as the sync
then blocks.

A btrfs scrub reports no errors. A btrfs check report hundreds of errors:

...
Incorrect global backref count on 91295694848 found 1 wanted 2
backpointer mismatch on [91295694848 16384]
ref mismatch on [91295711232 16384] extent item 1, found 2
Incorrect global backref count on 91295711232 found 1 wanted 2
backpointer mismatch on [91295711232 16384]
ref mismatch on [91295727616 16384] extent item 1, found 2
Incorrect global backref count on 91295727616 found 1 wanted 2
backpointer mismatch on [91295727616 16384]
ref mismatch on [91295744000 16384] extent item 1, found 2
Incorrect global backref count on 91295744000 found 1 wanted 2
backpointer mismatch on [91295744000 16384]
ref mismatch on [91295760384 16384] extent item 1, found 2
Incorrect global backref count on 91295760384 found 1 wanted 2
backpointer mismatch on [91295760384 16384]
ref mismatch on [91295776768 16384] extent item 1, found 2
Incorrect global backref count on 91295776768 found 1 wanted 2
backpointer mismatch on [91295776768 16384]
ref mismatch on [91295793152 16384] extent item 1, found 2
Incorrect global backref count on 91295793152 found 1 wanted 2
backpointer mismatch on [91295793152 16384]
ref mismatch on [91295809536 16384] extent item 1, found 2
Incorrect global backref count on 91295809536 found 1 wanted 2
backpointer mismatch on [91295809536 16384]
ref mismatch on [91295825920 16384] extent item 1, found 2
Incorrect global backref count on 91295825920 found 1 wanted 2
backpointer mismatch on [91295825920 16384]
Errors found in extent allocation tree or chunk allocation
checking free space cache
free space inode generation (0) did not match free space cache
generation (3272)
checking fs roots
checking csums
checking root refs
found 42565280463 bytes used err is 0
total csum bytes: 82221224
total tree bytes: 3689676800
total fs tree bytes: 3475308544
total extent tree bytes: 109215744
btree space waste bytes: 609518812
file data blocks allocated: 118278844416
 referenced 117607366656
Btrfs v3.12

Kernel is 3.14.1, Ubuntu 14.04.

The question is: What shall I do? btrfs check --repair? Or better just
copy all data to a new fs and delete the partition?

Michael

