Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47689 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755132AbeASXaI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Jan 2018 18:30:08 -0500
Date: Sat, 20 Jan 2018 00:27:56 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND v4 0/4] device_list_add() peparation to add
 reappearing missing device
Message-ID: <20180119232756.GB15713@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180118140236.25349-1-anand.jain@oracle.com>
 <20180118174717.GT13726@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180118174717.GT13726@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 18, 2018 at 06:47:17PM +0100, David Sterba wrote:
> On Thu, Jan 18, 2018 at 10:02:32PM +0800, Anand Jain wrote:
> > (Apply on top of my patchset
> >    [PATCH v4 0/6] preparatory work to add device forget
> >  for conflict free apply. They don't actually depend on
> >  each other though).
> 
> > Cleanup of device_list_add(), mainly in preparation to handle
> > reappearing missing device which its next reroll will be sent
> > separately.
> 
> I'm adding the two patchsets to the 4.16 queue but will push the updated
> branch after the current tests finish and I also test the updated branch
> as well.

So this did not survive the first fstests run, I'm going to move the patchset
to the 4.17 dev queue.

[ 2912.493351] run fstests btrfs/064 at 2018-01-19 20:55:50
[ 2914.218654] BTRFS: device fsid ee7e811a-fdb3-42e9-8a81-5ed8e1a4282b devid 1 transid 5 /dev/sdb6
[ 2914.261560] BTRFS: device fsid ee7e811a-fdb3-42e9-8a81-5ed8e1a4282b devid 2 transid 5 /dev/sdc5
[ 2914.296819] BTRFS: device fsid ee7e811a-fdb3-42e9-8a81-5ed8e1a4282b devid 3 transid 5 /dev/sdb7
[ 2914.348140] BTRFS: device fsid ee7e811a-fdb3-42e9-8a81-5ed8e1a4282b devid 4 transid 5 /dev/sdc6
[ 2914.389368] BTRFS: device fsid ee7e811a-fdb3-42e9-8a81-5ed8e1a4282b devid 5 transid 5 /dev/sdb8
[ 2914.425378] BTRFS: device fsid ee7e811a-fdb3-42e9-8a81-5ed8e1a4282b devid 6 transid 5 /dev/sdc7
[ 2914.443497] BTRFS: device fsid ee7e811a-fdb3-42e9-8a81-5ed8e1a4282b devid 7 transid 5 /dev/sdb9
[ 2914.488145] BTRFS info (device sdb9): disk space caching is enabled
[ 2914.494744] BTRFS info (device sdb9): has skinny extents
[ 2914.500328] BTRFS info (device sdb9): flagging fs with big metadata feature
[ 2914.514809] BTRFS info (device sdb9): enabling ssd optimizations
[ 2914.522114] BTRFS info (device sdb9): creating UUID tree
[ 2914.716867] BTRFS info (device sdb9): dev_replace from /dev/sdc5 (devid 2) to /dev/sdc8 started
[ 2914.852699] BTRFS info (device sdb9): dev_replace from /dev/sdc5 (devid 2) to /dev/sdc8 finished
[ 2915.028666] BTRFS info (device sdb9): dev_replace from /dev/sdb7 (devid 3) to /dev/sdc5 started
[ 2915.110374] BTRFS info (device sdb9): dev_replace from /dev/sdb7 (devid 3) to /dev/sdc5 finished
[ 2915.309674] BTRFS info (device sdb9): dev_replace from /dev/sdc6 (devid 4) to /dev/sdb7 started
[ 2915.340819] BTRFS info (device sdb9): dev_replace from /dev/sdc6 (devid 4) to /dev/sdb7 finished
[ 2915.350220] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[ 2915.358350] IP: btrfs_scan_one_device+0x127/0x180 [btrfs]
[ 2915.358353] PGD 0 P4D 0 
[ 2915.358366] Oops: 0000 [#1] PREEMPT SMP
[ 2915.358493] CPU: 2 PID: 1076 Comm: systemd-udevd Tainted: G        W        4.15.0-rc8-1.ge195904-vanilla+ #128
[ 2915.358495] Hardware name: empty empty/S3993, BIOS PAQEX0-3 02/24/2008
[ 2915.358534] RIP: 0010:btrfs_scan_one_device+0x127/0x180 [btrfs]
[ 2915.358537] RSP: 0018:ffffb35a4524be30 EFLAGS: 00010206
[ 2915.358541] RAX: fffffffffffffff0 RBX: 0000000000000081 RCX: 000000000000000f
[ 2915.358544] RDX: ffff96a791c7e10b RSI: 0000000000000001 RDI: ffff96a79f734200
[ 2915.358546] RBP: ffff96a7a2ea6000 R08: 000000000000002b R09: 0000000000000000
[ 2915.358548] R10: 0000000000000000 R11: 0000000000000004 R12: 00000000fffffff0
[ 2915.358550] R13: ffffb35a4524be60 R14: fffff07d48471f80 R15: 000055ee5775ad74
[ 2915.358554] FS:  00007f736b3648c0(0000) GS:ffff96a7a6a00000(0000) knlGS:0000000000000000
[ 2915.358556] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2915.358558] CR2: 0000000000000010 CR3: 000000021201e000 CR4: 00000000000006e0
[ 2915.358560] Call Trace:
[ 2915.358600]  btrfs_control_ioctl+0xad/0xe0 [btrfs]
[ 2915.358610]  ? trace_hardirqs_on_caller+0xf2/0x1a0
[ 2915.358618]  do_vfs_ioctl+0x90/0x6b0
[ 2915.358625]  ? __audit_syscall_entry+0xb5/0x110
[ 2915.358632]  ? syscall_trace_enter+0x1ae/0x360
[ 2915.358638]  ? return_from_SYSCALL_64+0x10/0x75
[ 2915.358643]  SyS_ioctl+0x74/0x80
[ 2915.358647]  ? do_syscall_64+0x1e/0x1a0
[ 2915.358653]  do_syscall_64+0x64/0x1a0
[ 2915.358659]  entry_SYSCALL64_slow_path+0x25/0x25
[ 2915.358663] RIP: 0033:0x7f736a1f3227
[ 2915.358665] RSP: 002b:00007fff9dcad618 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 2915.358669] RAX: ffffffffffffffda RBX: 00007fff9dcad630 RCX: 00007f736a1f3227
[ 2915.358670] RDX: 00007fff9dcad630 RSI: 0000000090009427 RDI: 000000000000000f
[ 2915.358672] RBP: 000000000000000f R08: 376264732f766564 R09: 0000000000000003
[ 2915.358674] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[ 2915.358676] R13: 000055ee59813e90 R14: 0000000000000000 R15: 000055ee5775ad74
[ 2915.358810] RIP: btrfs_scan_one_device+0x127/0x180 [btrfs] RSP: ffffb35a4524be30
[ 2915.358812] CR2: 0000000000000010
[ 2915.358970] ---[ end trace 900a4fff1ad9ece2 ]---
[ 2915.441581] BTRFS info (device sdb9): dev_replace from /dev/sdb8 (devid 5) to /dev/sdc6 started

