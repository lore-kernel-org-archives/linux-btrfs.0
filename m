From: Simon Kirby <sim@hostway.ca>
Subject: Re: warning and bug on 3.2-rc4 + for-linus from yesterday
Date: Fri, 9 Dec 2011 18:21:02 -0800
Message-ID: <20111210022102.GB3166@hostway.ca>
References: <20111209203948.GA12378@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111209203948.GA12378@hostway.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 09, 2011 at 12:39:48PM -0800, Simon Kirby wrote:

> Hello!
> 
> We recently upgraded our backup server kernel (rsync with snapshots and
> compression) to Linus git master from yesterday (3.2-rc4+ 09d9673d53005)
> that contains the btrfs for-linus as of yesterday. We've been seeing a
> few warnings and bugs:

Then it kept pinging but didn't accept SSH anymore, with this captured
via serial console:

[79214.481458] ------------[ cut here ]------------
[79214.485335] kernel BUG at fs/btrfs/inode.c:2893!
[79214.485335] invalid opcode: 0000 [#2] SMP
[79214.485335] CPU 0
[79214.485335] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2
[79214.485335]
[79214.485335] Pid: 24202, comm: btrfsctl Tainted: G      D W    3.2.0-rc4-hw+ #71 Dell Inc. PowerEdge 1950/0NK937
[79214.485335] RIP: 0010:[<ffffffff81304d88>]  [<ffffffff81304d88>] btrfs_unlink_subvol+0x268/0x270
[79214.485335] RSP: 0018:ffff880344babd28  EFLAGS: 00010286
[79214.485335] RAX: 00000000ffffffe4 RBX: 0000000000000c46 RCX: ffff880336fd1588
[79214.485335] RDX: 00000000ffffffe4 RSI: 0000000000000000 RDI: ffff880336fd15a8
[79214.485335] RBP: ffff880344babda8 R08: 0000000000000000 R09: 0000000000000000
[79214.485335] R10: 0000000000000000 R11: 9000000000000001 R12: ffff880405cf5e88
[79214.485335] R13: ffff880428a9ba20 R14: ffff880405158c00 R15: 0000000000000100
[79214.485335] FS:  00007f27ff13d740(0000) GS:ffff88043fc00000(0000) knlGS:0000000000000000
[79214.485335] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[79214.485335] CR2: 00007fffdf79f950 CR3: 00000003f79fe000 CR4: 00000000000006f0
[79214.485335] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[79214.485335] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[79214.485335] Process btrfsctl (pid: 24202, threadinfo ffff880344baa000, task ffff8803dcec0000)
[79214.485335] Stack:
[79214.485335]  ffff8804037d53f8 ffff880300000010 0000001044babd58 ffff8804037d53f8
[79214.485335]  00000000000008a0 ffff8803fd8b43f0 00000000000008a0 ffffffffffffff84
[79214.485335]  00000000000000ff 0000000000000268 ffff880037e73008 0000000000000000
[79214.485335] Call Trace:
[79214.485335]  [<ffffffff81323975>] btrfs_ioctl_snap_destroy+0x3b5/0x480
[79214.485335]  [<ffffffff81326ef2>] btrfs_ioctl+0x3a2/0x10d0
[79214.485335]  [<ffffffff816da594>] ? do_page_fault+0x254/0x4b0
[79214.485335]  [<ffffffff8112cdc0>] do_vfs_ioctl+0xa0/0x520
[79214.485335]  [<ffffffff8112d28a>] sys_ioctl+0x4a/0x80
[79214.485335]  [<ffffffff816de8d2>] system_call_fastpath+0x16/0x1b
[79214.485335] Code: 48 8d 54 92 65 e8 89 f2 00 00 48 8b 5d b9 4c 89 ef e8 4d 2c fd ff 48 89 5d c8 e9 ca fe ff ff 0f 0b eb fe 0f 0b eb fe 0f 1f 40 00 <0f> 0b eb fe 0f 0b eb fe 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c
[79214.485335] RIP  [<ffffffff81304d88>] btrfs_unlink_subvol+0x268/0x270
[79214.485335]  RSP <ffff880344babd28>
[79214.700401] ---[ end trace 52453f1ad38744ba ]---

Simon-
