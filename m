Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:33129 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab3BEIzV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Feb 2013 03:55:21 -0500
Received: from lampka.siedziba.pl (localhost.graciarnia [127.0.0.1])
	by zlom.siedziba.pl (Postfix) with ESMTPA id D9122887695
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Feb 2013 09:55:17 +0100 (CET)
Message-ID: <c70388910a26ddb79b9f358e0ccb78f5.squirrel@lampka.siedziba.pl>
In-Reply-To: <20130204165825.GC2275@localhost.localdomain>
References: <55e4fbbdada4ee37bdccac2537683d83.squirrel@lampka.siedziba.pl>
    <20130204165825.GC2275@localhost.localdomain>
Date: Tue, 5 Feb 2013 09:55:17 +0100
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1772
From: =?utf-8?B?IlBpb3RyIFBhd8WCb3ci?= <pp@siedziba.pl>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> mounts before it panics, can you capture all the output and reply to this
> email
> with it?  Thanks,

I'm sorry, I could not keep it longer in that state. I used btrfs-image to
create metadata image from both disks, then let it run without space
cache.

Unfortunately, when I run qemu with these images:

# btrfs fi show
Label: 'root'  uuid: 8b7a0276-d331-478c-b829-7614f2e7dc6a
	Total devices 2 FS bytes used 758.99GB
	devid    2 size 1.81TB used 554.03GB path /dev/hdc
	devid    1 size 1.81TB used 766.04GB path /dev/hdb

Looks good, let's try to mount:

# mount /dev/hdb /mnt/test -odevice=/dev/hdc,ro
device label root devid 2 transid 56099 /dev/hdc
device label root devid 1 transid 56099 /dev/hdb
btrfs: disk space caching is enabled
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:4586!
invalid opcode: 0000 [#1]
Pid: 307, comm: exe Not tainted 3.7.0+ #3 Bochs Bochs
EIP: 0060:[<c115d369>] EFLAGS: 00010286 CPU: 0
EIP is at btrfs_rmap_block+0x389/0x3d0
EAX: c5c00000 EBX: 00000000 ECX: d742d000 EDX: c5c00000
ESI: 00000000 EDI: 00000000 EBP: d7933c94 ESP: d7933c34
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
CR0: 8005003b CR2: 08053000 CR3: 1790c000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process exe (pid: 307, ti=d7932000 task=d7902fa0 task.ti=d7932000)
Stack:
 00000001 00000000 d7430b80 d7933d42 00000019 00000006 d742d000 c5c00000
 00000000 00001000 000000c8 d7902fa0 00000000 00000000 00000000 d7933cac
 c1154ede d7933c84 c1167fb7 d742d0e0 d7933c94 00010000 00000000 00000000
Call Trace:
 [<c1154ede>] ? map_private_extent_buffer+0x5e/0xe0
 [<c1167fb7>] ? btrfs_set_lock_blocking_rw+0x57/0x90
 [<c111b4c2>] exclude_super_stripes.isra.67+0x82/0x170
 [<c11536a1>] ? free_extent_buffer+0x21/0x70
 [<c1124401>] btrfs_read_block_groups+0x2e1/0x610
 [<c1131f12>] open_ctree+0x12f2/0x1b70
 [<c11b1c7d>] ? strlcpy+0x1d/0x110
 [<c110c4b7>] btrfs_mount+0x677/0x850
 [<c11ae74d>] ? ida_get_new_above+0x1ed/0x220
 [<c1081310>] ? __kmalloc_track_caller+0x70/0x130
 [<c109a4a2>] ? alloc_vfsmnt+0x62/0x100
 [<c1085acc>] mount_fs+0x1c/0xc0
 [<c109a4a2>] ? alloc_vfsmnt+0x62/0x100
 [<c109b0a4>] vfs_kern_mount+0x44/0xd0
 [<c109b197>] do_kern_mount+0x37/0xf0
 [<c109c594>] do_mount+0x3b4/0x700
 [<c109c946>] sys_mount+0x66/0xa0
 [<c122c595>] syscall_call+0x7/0xb
Code: fe ff ff 0f 85 2d ff ff ff 31 ff e9 0f ff ff ff 66 90 89 c8 31 d2 f7
f6 89 c1 e9 1f fd ff ff c7 45 e8 00 00 00 00 e9 27 ff ff ff <0f> 0b ba 07
12 00 00 b8 50 f8 28 c1 89 4d b0 e8 03 30 ec ff 8b
EIP: [<c115d369>] btrfs_rmap_block+0x389/0x3d0 SS:ESP 0068:d7933c34
---[ end trace 78658a7dd47c6f96 ]---

It fails in a different way :(

4586         BUG_ON(!em || em->start != chunk_start);
(kernel from btrfs-next/piotr)

As to the original FS, balance kept running until the end and finished
without errors. I'll try to run some more balance operations to see if it
happens again.

Thanks for your support.

Regards

