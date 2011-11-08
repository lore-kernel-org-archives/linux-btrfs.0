From: David Sterba <dave@jikos.cz>
Subject: Re: BUG at fs/btrfs/file.c:1656 [for-linus]
Date: Tue, 8 Nov 2011 18:49:42 +0100
Message-ID: <20111108174942.GT12759@twin.jikos.cz>
References: <20111108171347.GS12759@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111108171347.GS12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

same goes with 3.2-rc1 + the

On Tue, Nov 08, 2011 at 06:13:47PM +0100, David Sterba wrote:
> commit 45ea6095c8f0d6caad5658306416a5d254f1205e
> Author: slyich@gmail.com <slyich@gmail.com>
> Date:   Mon Nov 7 16:08:01 2011 -0500
> 
>     btrfs: fix double-free 'tree_root' in 'btrfs_mount()'

commit. Same FS, no mkfs in between. There was one difference, the xfstests
proceeded, and there was no hanging 'rm' left.

[  259.788937] ------------[ cut here ]------------
[  259.792015] kernel BUG at fs/btrfs/file.c:1656!
[  259.792015] invalid opcode: 0000 [#1] SMP
[  259.792015] CPU 0
[  259.792015] Modules linked in: btrfs aoe
[  259.792015]
[  259.792015] Pid: 8173, comm: fsstress Not tainted 3.2.0-rc1-default+ #70
[  259.792015] RIP: 0010:[<ffffffffa0048e70>]  [<ffffffffa0048e70>] btrfs_fallocate+0x390/0x3e0 [btrfs]
[  259.792015] RSP: 0018:ffff88007a6edd98  EFLAGS: 00010202
[  259.792015] RAX: ffffffffffffffef RBX: 000000000021a000 RCX: 0000000000000006
[  259.792015] RDX: 0000000000000001 RSI: ffff880078200cf8 RDI: 0000000000000000
[  259.792015] RBP: ffff88007a6ede48 R08: 0000000000000001 R09: 0000000000000001
[  259.792015] R10: 0000000000000001 R11: 0000000000000001 R12: ffffffffffffffef
[  259.792015] R13: 000000000021a000 R14: ffff88006f0833f0 R15: 000000000022f000
[  259.792015] FS:  00007f0297597700(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
[  259.792015] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  259.792015] CR2: 00007f029036b588 CR3: 00000000780ff000 CR4: 00000000000006f0
[  259.792015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  259.792015] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  259.792015] Process fsstress (pid: 8173, threadinfo ffff88007a6ec000, task ffff880078200680)
[  259.792015] Stack:
[  259.792015]  0000000000000001 0000000000000000 0000000100000000 ffff88006f083000
[  259.792015]  00000000001b9000 ffff88006f0830b8 000000000022efff 000000018111db70
[  259.792015]  ffff88006f0834d0 fffffffffffff000 0000000000000fff 0000000100000246
[  259.792015] Call Trace:
[  259.792015]  [<ffffffff81145f40>] do_fallocate+0xe0/0xf0
[  259.792015]  [<ffffffff8115a49a>] ioctl_preallocate+0x8a/0xd0
[  259.792015]  [<ffffffff8115a9c7>] do_vfs_ioctl+0x4e7/0x560
[  259.792015]  [<ffffffff811492d6>] ? fget_light+0x2e6/0x3c0
[  259.792015]  [<ffffffff8115aa8f>] sys_ioctl+0x4f/0x80
[  259.792015]  [<ffffffff818b95c2>] system_call_fastpath+0x16/0x1b
[  259.792015] Code: 8b 7d 90 e8 63 60 86 e1 e9 e2 fc ff ff 66 0f 1f 44 00 00 49 39 c7 48 89 c3 49 0f 46 df e9 0a ff ff ff 66 0f 1f 84 00 00 00 00 00 <0f> 0b 66 0f 1f 44 00 00 48 89 c7 4c 89 e3 4d 89 fd e8 5a b5 00
[  259.792015] RIP  [<ffffffffa0048e70>] btrfs_fallocate+0x390/0x3e0 [btrfs]
[  259.792015]  RSP <ffff88007a6edd98>
[  260.071972] ---[ end trace 7740500b89f500d9 ]---

No other messages preceding the stacktrace, the only one I see during first test/mount is
[   57.371318] btrfs: truncated 1 orphans

but everything seems to go fine.


david
