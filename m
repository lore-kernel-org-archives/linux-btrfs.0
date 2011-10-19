From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Creation of pseudo items leads to (seemingly) duplicate inodes
 (BUG inside)
Date: Wed, 19 Oct 2011 09:01:43 +0800
Message-ID: <4E9E2177.6050405@cn.fujitsu.com>
References: <4E9DA301.5050907@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E9DA301.5050907@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/19/2011 12:02 AM, Jan Schmidt wrote:
> Hi there,
> 
> while playing with snapshots for btrfs send, I also encountered
> seemingly duplicate inodes, which are multiple
> BTRFS_EMPTY_SUBVOL_DIR_OBJECTID objects within the same directory. I can
> imagine software that feels uncomfortable, here.
> 
> Such objects are created by btrfs_lookup_dentry() in fs/btrfs/inode.c
> when ENOENT is encountered.
> 

Hi,

A similar bug has been fixed by one of my patches(still queued):

http://marc.info/?l=linux-btrfs&m=131409014207238&w=2

thanks,
liubo

> The main purpose for this email is to ask: Is this going to stay like that?
> 
> David Sterba sent a related issue some days ago with effects seen on
> dcache level (subject: "WARNING: at fs/dcache.c:1256
> d_set_d_op+0xaa/0xc0() , nested snapshots").
> 
> I hit a bug when trying to rename(2) one of those objects, and I'm still
> hitting it reproducably on 3.1-rc5. However, I cannot reproduce it with
> the current for-linus branch (3.1-rc6). I don't see a commit I'd expect
> to fix this, but it may be fixed:
> 
> --
> Oct 17 13:28:26 oglaroon kernel: [266945.208573] btrfs failed to delete
> reference to snap2, inode 257 parent 256
> Oct 17 13:28:26 oglaroon kernel: [266945.208586] ------------[ cut here
> ]------------
> Oct 17 13:28:26 oglaroon kernel: [266945.264688] kernel BUG at
> fs/btrfs/inode.c:6907!
> Oct 17 13:28:26 oglaroon kernel: [266945.320807] invalid opcode: 0000
> [#1] SMP
> Oct 17 13:28:26 oglaroon kernel: [266945.370907] CPU 2
> Oct 17 13:28:26 oglaroon kernel: [266945.393831] Modules linked in:
> btrfs mpt2sas scsi_transport_sas raid_class [last unloaded: btrfs]
> Oct 17 13:28:26 oglaroon kernel: [266945.503578]
> Oct 17 13:28:26 oglaroon kernel: [266945.522353] Pid: 29567, comm: mv
> Not tainted 3.1.0-rc4+ #5 Supermicro X8SIL/X8SIL
> Oct 17 13:28:26 oglaroon kernel: [266945.613011] RIP:
> 0010:[<ffffffffa06d906a>]  [<ffffffffa06d906a>] btrfs_rename+0x42a/0x770
> [btrfs]
> Oct 17 13:28:26 oglaroon kernel: [266945.720059] RSP:
> 0018:ffff88022f933c78  EFLAGS: 00010282
> Oct 17 13:28:26 oglaroon kernel: [266945.784476] RAX: 00000000fffffffe
> RBX: 000000003b2456a4 RCX: 0000000000000054
> Oct 17 13:28:26 oglaroon kernel: [266945.870675] RDX: 0000000000000053
> RSI: 000060fdc00042c0 RDI: ffff880234330000
> Oct 17 13:28:26 oglaroon kernel: [266945.956874] RBP: ffff88022f933d48
> R08: 0000000000000000 R09: 0000000000000001
> Oct 17 13:28:26 oglaroon kernel: [266946.043072] R10: 0000000000000006
> R11: 0000000000000000 R12: 000000004e9c1157
> Oct 17 13:28:26 oglaroon kernel: [266946.129270] R13: ffff880234468368
> R14: 0000000000000000 R15: ffff880234446d58
> Oct 17 13:28:26 oglaroon kernel: [266946.215471] FS:
> 00007f3bf0b96700(0000) GS:ffff88023fc80000(0000) knlGS:0000000000000000
> Oct 17 13:28:26 oglaroon kernel: [266946.313080] CS:  0010 DS: 0000 ES:
> 0000 CR0: 0000000080050033
> Oct 17 13:28:26 oglaroon kernel: [266946.382681] CR2: 00007f3bf0072110
> CR3: 000000015c05f000 CR4: 00000000000006e0
> Oct 17 13:28:26 oglaroon kernel: [266946.468880] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Oct 17 13:28:26 oglaroon kernel: [266946.555079] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Oct 17 13:28:26 oglaroon kernel: [266946.641278] Process mv (pid: 29567,
> threadinfo ffff88022f932000, task ffff880234330000)
> Oct 17 13:28:26 oglaroon kernel: [266946.737849] Stack:
> Oct 17 13:28:26 oglaroon kernel: [266946.762849]  000000000000000a
> 0000000000000006 00000000000000d0 0000000000000000
> Oct 17 13:28:26 oglaroon kernel: [266946.852574]  ffff88022f933c01
> 0000000000000101 00ff8802346b4158 ffff8802349b81b8
> Oct 17 13:28:26 oglaroon kernel: [266946.942299]  0000000000000000
> ffff88022f9e7000 ffff88022f9e7000 ffff88019d4b6aa8
> Oct 17 13:28:26 oglaroon kernel: [266947.032025] Call Trace:
> Oct 17 13:28:26 oglaroon kernel: [266947.062215]  [<ffffffff81189ea2>]
> vfs_rename+0x162/0x3e0
> Oct 17 13:28:26 oglaroon kernel: [266947.126629]  [<ffffffff8118bfb9>]
> sys_renameat+0x239/0x270
> Oct 17 13:28:26 oglaroon kernel: [266947.193120]  [<ffffffff8187568c>] ?
> do_page_fault+0x20c/0x450
> Oct 17 13:28:26 oglaroon kernel: [266947.262722]  [<ffffffff818723ca>] ?
> retint_swapgs+0xe/0x13
> Oct 17 13:28:26 oglaroon kernel: [266947.329214]  [<ffffffff810c84dd>] ?
> trace_hardirqs_on_caller+0xfd/0x190
> Oct 17 13:28:26 oglaroon kernel: [266947.409185]  [<ffffffff8118c006>]
> sys_rename+0x16/0x20
> Oct 17 13:28:26 oglaroon kernel: [266947.471527]  [<ffffffff8187983b>]
> system_call_fastpath+0x16/0x1b
> Oct 17 13:28:26 oglaroon kernel: [266947.544240] Code: 68 ff ff ff 48 8b
> 4a 30 44 8b 4a 24 4c 8b 42 28 48 8b 55 90 4c 89 95 58 ff ff ff 44 88 9d
> 50 ff ff ff e8 ba c0 ff ff 85 c0 74 4a <0f> 0b eb fe 48 8b 45 80 48 8b
> b8 20 01 00 00 88 95 48 ff ff ff
> Oct 17 13:28:26 oglaroon kernel: [266947.777216] RIP
> [<ffffffffa06d906a>] btrfs_rename+0x42a/0x770 [btrfs]
> Oct 17 13:28:26 oglaroon kernel: [266947.856259]  RSP <ffff88022f933c78>
> Oct 17 13:28:26 oglaroon kernel: [266947.899234] ---[ end trace
> fd19520e3af48c17 ]---
> --
> 
> Reproducer for the curious:
> 
> # mkfs.btrfs /dev/sdv2
> # mount /dev/sdv2 /mnt
> # btrfs subvol snap /mnt /mnt/snap1
> # btrfs subvol snap /mnt /mnt/snap2
> # btrfs subvol snap /mnt /mnt/snap3
> 
> When snap2 was created, there was a dir item for snap1, so this is no
> surprise:
> 
> # ls -lai /mnt/snap2
> total 8
> 256 dr-xr-xr-x 1 root root 20 Jan  1  1970 .
> 256 dr-xr-xr-x 1 root root 30 Jan  1  1970 ..
>   2 drwxr-xr-x 1 root root  0 Oct 18 16:25 snap1
> 
> Inode 2 seems a bit strange, but stay tuned. When snap3 was created,
> there were dir items for snap1 and snap2, so ... *drumroll*
> 
> # ls -lai /mnt/snap3
> total 8
> 256 dr-xr-xr-x 1 root root 30 Jan  1  1970 .
> 256 dr-xr-xr-x 1 root root 30 Jan  1  1970 ..
>   2 drwxr-xr-x 1 root root  0 Oct 18 16:26 snap1
>   2 drwxr-xr-x 1 root root  0 Oct 18 16:26 snap2
> 
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

