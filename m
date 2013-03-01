Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3CAQa7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Mar 2013 11:30:59 -0500
Date: Fri, 1 Mar 2013 17:30:57 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, alex.btrfs@zadarastorage.com,
        idryomov@gmail.com
Subject: Re: [PATCH v2] btrfs: clean snapshots one by one
Message-ID: <20130301163057.GW27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAOcd+r152Ot9RYjGfCc_sW46BNKuKrhEN=xR_hw_9QKSu5Agpw@mail.gmail.com>
 <1362154654-17655-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362154654-17655-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The mail did not make it to the list on Monday, anyway, now I have a
few testing results to share.

The umount responsiveness is much improved, it took a few seconds when
there were many roots to clean scheduled.

With

$ echo 'func btrfs_drop_snapshot +pf' > /sys/debug/kernel/dynamic_debug/control
$ echo 'func btrfs_clean_one_deleted_snapshot +pf' > /sys/debug/kernel/dynamic_debug/control

one can watch how it proceeds.

After umount and and mount, the cleaning process starts again, after 30
seconds when transaction commit triggers.

Next test was to let it run with balance (just 'fi balance', no other
options). Worked well, but I've hit an oops from balance cancel command that
was triggered sometime during the balance. According to the log it happened
right after the balance finished. CCing Ilya, I'm not sure if this is somehow
induced by the patch.

3407         BUG_ON(fs_info->balance_ctl || atomic_read(&fs_info->balance_running));
3408         atomic_dec(&fs_info->balance_cancel_req);
3409         mutex_unlock(&fs_info->balance_mutex);
3410         return 0;
3411 }

 ------------[ cut here ]------------
 kernel BUG at fs/btrfs/volumes.c:3407!
 invalid opcode: 0000 [#1] SMP
 Modules linked in: btrfs aoe dm_crypt loop [last unloaded: btrfs]
 CPU 0
 Pid: 19117, comm: btrfs Tainted: G        W    3.8.0-default+ #267 Intel
 RIP: 0010:[<ffffffffa0160919>]  [<ffffffffa0160919>] btrfs_cancel_balance+0x179/0x180 [btrfs]
 RSP: 0018:ffff88005fddfd78  EFLAGS: 00010286
 RAX: ffff88005fddffd8 RBX: ffff88005adec000 RCX: 0000000000000006
 RDX: 0000000000000001 RSI: ffff880027cc88c0 RDI: 2222222222222222
 RBP: ffff88005fddfdd8 R08: 2222222222222222 R09: 2222222222222222
 R10: 2222222222222222 R11: 0000000000000000 R12: ffff88005adeeac8
 R13: ffff88005adeeb70 R14: ffff88005fddfd78 R15: ffff88005adeeb88
 FS:  00007fe136daa740(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 00007ff04c655000 CR3: 000000005fc4b000 CR4: 00000000000007f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process btrfs (pid: 19117, threadinfo ffff88005fdde000, task ffff880027cc8240)
 Stack:
  0000000000000000 ffff880027cc8240 ffffffff810745c0 ffff88005fddfd90
  ffff88005fddfd90 ffffffff810a6c6d ffff88005fddfdc8 ffff88007724d6c0
  ffff880055e6d000 0000000000000002 ffff880078ccc080 ffff880078ccc538
 Call Trace:
  [<ffffffff810745c0>] ? wake_up_bit+0x40/0x40
  [<ffffffff810a6c6d>] ? lock_release_holdtime+0x3d/0x1c0
  [<ffffffffa016c8a3>] btrfs_ioctl+0x693/0x1d80 [btrfs]
  [<ffffffff81079723>] ? up_read+0x23/0x40
  [<ffffffff8195e268>] ? __do_page_fault+0x238/0x590
  [<ffffffff81087d1f>] ? local_clock+0x6f/0x80
  [<ffffffff810a6909>] ? trace_hardirqs_off_caller+0x29/0xc0
  [<ffffffff811708f8>] do_vfs_ioctl+0x98/0x560
  [<ffffffff8195a906>] ? error_sti+0x5/0x6
  [<ffffffff8195a458>] ? retint_swapgs+0x13/0x1b
  [<ffffffff81170e17>] sys_ioctl+0x57/0x90
  [<ffffffff8139adce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff81962e99>] system_call_fastpath+0x16/0x1b
 RIP  [<ffffffffa0160919>] btrfs_cancel_balance+0x179/0x180 [btrfs]
  RSP <ffff88005fddfd78>
 ---[ end trace 930320f35566d010 ]---

