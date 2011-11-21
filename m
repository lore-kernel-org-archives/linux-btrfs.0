Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35865 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1KUXmE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Nov 2011 18:42:04 -0500
Received: by iage36 with SMTP id e36so7945504iag.19
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Nov 2011 15:42:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF3hT9D+_heqAGdXLsyRzTnVf+fOQqpUcgW1-kGbaPW9LvaRNw@mail.gmail.com>
References: <CAF3hT9Bbu1stoBQbFCct5T3ZSRfvo4KcC_NpD3GLsABmWE2Sow@mail.gmail.com>
	<CAF3hT9D+_heqAGdXLsyRzTnVf+fOQqpUcgW1-kGbaPW9LvaRNw@mail.gmail.com>
Date: Mon, 21 Nov 2011 15:42:03 -0800
Message-ID: <CAF3hT9Aj-xbfMY+PpCV_+-ZxZTXoubbMEnWUBvR0EXk=qwz25A@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2408 btrfs_orphan_cleanup
From: Gregory Farnum <gregory.farnum@dreamhost.com>
To: linux-btrfs@vger.kernel.org
Cc: samuel.just@dreamhost.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 21, 2011 at 2:25 PM, Gregory Farnum
<gregory.farnum@dreamhost.com> wrote:
> So if I don't hear anything else or see this again I guess I'll just
> hope that the cause of this corruption is now eliminated, since it's
> at least handled better in the current code.
> Thanks!
> -Greg

Well, that optimism didn't last long. After everything had been
running okay for a while, ceph-osd tried to take a snapshot and it
failed:
2011-11-21 15:11:25.477937 7fe10f204700 filestore(/mnt/osd.2) async
snap create 'snap_5153387' transid 3760845847854673523 got -1 Invalid
argument

dmesg said:

[13654.157803] ------------[ cut here ]------------
[13654.162422] WARNING: at fs/btrfs/inode.c:2189
btrfs_orphan_cleanup+0x250/0x365()
[13654.169827] Hardware name: PowerEdge R510
[13654.173822] Modules linked in:
[13654.176876] Pid: 17772, comm: ceph-osd Tainted: G        W
3.1.0-dho-00144-gabe5bbe-dirty #1
[13654.185454] Call Trace:
[13654.187895]  [<ffffffff8103c645>] ? warn_slowpath_common+0x78/0x8c
[13654.194055]  [<ffffffff81237c37>] ? btrfs_orphan_cleanup+0x250/0x365
[13654.200389]  [<ffffffff81056227>] ? finish_wait+0x35/0x60
[13654.205768]  [<ffffffff8122e512>] ?
btrfs_commit_transaction_async+0x1e4/0x1f3
[13654.212963]  [<ffffffff810561ff>] ? finish_wait+0xd/0x60
[13654.218256]  [<ffffffff8124f53f>] ? btrfs_mksubvol+0x238/0x31f
[13654.224068]  [<ffffffff8124f72d>] ?
btrfs_ioctl_snap_create_transid+0x107/0x12d
[13654.231350]  [<ffffffff8124f7d1>] ? btrfs_ioctl_snap_create_v2+0x7e/0xc0
[13654.238027]  [<ffffffff812525eb>] ? btrfs_ioctl+0x4ab/0xdcc
[13654.243582]  [<ffffffff810fed45>] ? fsnotify+0x24a/0x277
[13654.248876]  [<ffffffff810e0bf9>] ? do_vfs_ioctl+0x3d8/0x425
[13654.254515]  [<ffffffff810644f6>] ? sys_futex+0x12a/0x142
[13654.259894]  [<ffffffff810e0c82>] ? sys_ioctl+0x3c/0x5c
[13654.265104]  [<ffffffff81670abb>] ? system_call_fastpath+0x16/0x1b
[13654.271260] ---[ end trace fa3719fc17c952a3 ]---
[13654.275865] btrfs: Error removing orphan entry, stopping orphan cleanup
[13654.282452] btrfs: could not do orphan cleanup -22


I unmounted the filesystem and got more:

[14182.700035] BTRFS: inode 302700 still on the orphan list
[14182.911191] ------------[ cut here ]------------
[14182.915800] WARNING: at fs/btrfs/disk-io.c:2749 free_fs_root+0x2b/0x78()
[14182.922477] Hardware name: PowerEdge R510
[14182.922479] Modules linked in:
[14182.922484] Pid: 14382, comm: umount Tainted: G        W
3.1.0-dho-00144-gabe5bbe-dirty #1
[14182.922487] Call Trace:
[14182.922496]  [<ffffffff8103c645>] ? warn_slowpath_common+0x78/0x8c
[14182.922500]  [<ffffffff8122777b>] ? free_fs_root+0x2b/0x78
[14182.922504]  [<ffffffff81227825>] ? btrfs_free_fs_root+0x5d/0x64
[14182.922508]  [<ffffffff812278ff>] ? del_fs_roots+0xd3/0xef
[14182.922513]  [<ffffffff8122af9f>] ? close_ctree+0x220/0x360
[14182.922519]  [<ffffffff810e6dfa>] ? dispose_list+0x35/0x3f
[14182.922523]  [<ffffffff810e72d9>] ? evict_inodes+0xdd/0xe8
[14182.922530]  [<ffffffff8120f3de>] ? btrfs_put_super+0x10/0x1d
[14182.922536]  [<ffffffff810d533e>] ? generic_shutdown_super+0x4c/0xb3
[14182.922541]  [<ffffffff810d540d>] ? kill_anon_super+0x9/0x11
[14182.922545]  [<ffffffff810d55ef>] ? deactivate_locked_super+0x1e/0x4f
[14182.922551]  [<ffffffff810eb1b7>] ? sys_umount+0x2d6/0x301
[14182.922559]  [<ffffffff81670abb>] ? system_call_fastpath+0x16/0x1b
[14182.922563] ---[ end trace fa3719fc17c952a4 ]---
[14183.058889] ------------[ cut here ]------------
[14183.063496] WARNING: at fs/btrfs/disk-io.c:2749 free_fs_root+0x2b/0x78()
[14183.070172] Hardware name: PowerEdge R510
[14183.070175] Modules linked in:
[14183.070179] Pid: 14382, comm: umount Tainted: G        W
3.1.0-dho-00144-gabe5bbe-dirty #1
[14183.070182] Call Trace:
[14183.070189]  [<ffffffff8103c645>] ? warn_slowpath_common+0x78/0x8c
[14183.070193]  [<ffffffff8122777b>] ? free_fs_root+0x2b/0x78
[14183.070197]  [<ffffffff81227825>] ? btrfs_free_fs_root+0x5d/0x64
[14183.070201]  [<ffffffff812278ff>] ? del_fs_roots+0xd3/0xef
[14183.070206]  [<ffffffff8122af9f>] ? close_ctree+0x220/0x360
[14183.070210]  [<ffffffff810e6dfa>] ? dispose_list+0x35/0x3f
[14183.070214]  [<ffffffff810e72d9>] ? evict_inodes+0xdd/0xe8
[14183.070220]  [<ffffffff8120f3de>] ? btrfs_put_super+0x10/0x1d
[14183.070225]  [<ffffffff810d533e>] ? generic_shutdown_super+0x4c/0xb3
[14183.070229]  [<ffffffff810d540d>] ? kill_anon_super+0x9/0x11
[14183.070234]  [<ffffffff810d55ef>] ? deactivate_locked_super+0x1e/0x4f
[14183.070239]  [<ffffffff810eb1b7>] ? sys_umount+0x2d6/0x301
[14183.070245]  [<ffffffff81670abb>] ? system_call_fastpath+0x16/0x1b
[14183.070249] ---[ end trace fa3719fc17c952a5 ]---
[14183.386231] VFS: Busy inodes after unmount of sde1. Self-destruct
in 5 seconds.  Have a nice day...

Remounting was successful, but the ceph-osd daemon again failed to open
2011-11-21 15:22:14.494163 7f86e65c5720 filestore(/mnt/osd.2)
FileStore::mount: error opening '/mnt/osd.2/snap_5153387': error 22:
Invalid argument
and dmesg said:
[14301.953476] ------------[ cut here ]------------
[14301.958090] WARNING: at fs/btrfs/inode.c:2189
btrfs_orphan_cleanup+0x250/0x365()
[14301.965460] Hardware name: PowerEdge R510
[14301.965462] Modules linked in:
[14301.965468] Pid: 15810, comm: ceph-osd Tainted: G        W
3.1.0-dho-00144-gabe5bbe-dirty #1
[14301.965471] Call Trace:
[14301.965481]  [<ffffffff8103c645>] ? warn_slowpath_common+0x78/0x8c


                                                  2[14301.965486]
[<ffffffff81237c37>] ? btrfs_orphan_cleanup+0x250/0x365phan cleanup
-22
[14301.965492]  [<ffffffff812380d1>] ? btrfs_lookup_dentry+0x385/0x3ee
[14301.965497]  [<ffffffff81238147>] ? btrfs_lookup+0xd/0x44
[14301.965504]  [<ffffffff810db965>] ? d_alloc_and_lookup+0x43/0x60
[14301.965509]  [<ffffffff810dbd79>] ? do_lookup+0x1de/0x2e3
[14301.965513]  [<ffffffff810dc6d5>] ? link_path_walk+0x60/0x709
[14301.965518]  [<ffffffff810de6b1>] ? do_last+0x13f/0x744
[14301.965522]  [<ffffffff810ded84>] ? path_openat+0xce/0x358
[14301.965527]  [<ffffffff810df0db>] ? do_filp_open+0x2c/0x72
[14301.965534]  [<ffffffff810e82c0>] ? alloc_fd+0x69/0x10a
[14301.965538]  [<ffffffff810d1cb9>] ? do_sys_open+0x103/0x18a
[14301.965548]  [<ffffffff81670abb>] ? system_call_fastpath+0x16/0x1b
[14301.965552] ---[ end trace fa3719fc17c952a6 ]---
[14301.965558] btrfs: Error removing orphan entry, stopping orphan cleanup
[14301.965561] btrfs: could not do orphan cleanup -22

(Dunno if this is relevant, but some time later I got:
[14522.605592] btrfs: unlinked 1 orphans)

Attempting the startup a second time, it made it through the dir open
and instead failed on an ioctl snap create:
2011-11-21 15:33:46.794674 7f281c185720 filestore(/mnt/osd.2)
FileStore::mount: error ioctl(BTRFS_IOC_SNAP_CREATE) failed: error 22:
Invalid argument
with dmesg:
[14992.826804] ------------[ cut here ]------------
[14992.831418] WARNING: at fs/btrfs/inode.c:2189
btrfs_orphan_cleanup+0x250/0x365()
[14992.838785] Hardware name: PowerEdge R510
[14992.838787] Modules linked in:
[14992.838792] Pid: 23739, comm: ceph-osd Tainted: G        W
3.1.0-dho-00144-gabe5bbe-dirty #1
[14992.838795] Call Trace:
[14992.838805]  [<ffffffff8103c645>] ? warn_slowpath_common+0x78/0x8c


                                                  2[14992.838811]
[<ffffffff81237c37>] ? btrfs_orphan_cleanup+0x250/0x365phan cleanup
-22
[14992.838816]  [<ffffffff8122d141>] ? wait_current_trans+0x1e/0xdf
[14992.838824]  [<ffffffff8124f53f>] ? btrfs_mksubvol+0x238/0x31f
[14992.838829]  [<ffffffff8124f72d>] ?
btrfs_ioctl_snap_create_transid+0x107/0x12d
[14992.838834]  [<ffffffff8124f859>] ? btrfs_ioctl_snap_create+0x46/0x5d
[14992.838839]  [<ffffffff812525fd>] ? btrfs_ioctl+0x4bd/0xdcc
[14992.838846]  [<ffffffff810df0db>] ? do_filp_open+0x2c/0x72
[14992.838852]  [<ffffffff810e0bf9>] ? do_vfs_ioctl+0x3d8/0x425
[14992.838857]  [<ffffffff810e0c82>] ? sys_ioctl+0x3c/0x5c
[14992.838867]  [<ffffffff81670abb>] ? system_call_fastpath+0x16/0x1b
[14992.838870] ---[ end trace fa3719fc17c952a7 ]---
[14992.838877] btrfs: Error removing orphan entry, stopping orphan cleanup
[14992.838879] btrfs: could not do orphan cleanup -22


The node wasn't restarted in here and I haven't encountered any other
problems so it looks like btrfs just broke. :/ As before, deleting the
bad snapshot and choosing to use an earlier one for the ceph-osd
journal replay has at least bandaided the problem, but I don't know if
the b tree is broken somewhere from earlier or if we're just
successfully corrupting it due to a bug under our workload.
-Greg
