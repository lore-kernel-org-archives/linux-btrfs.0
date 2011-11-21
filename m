Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59443 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1KUWZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Nov 2011 17:25:36 -0500
Received: by ghrr1 with SMTP id r1so252955ghr.19
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Nov 2011 14:25:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF3hT9Bbu1stoBQbFCct5T3ZSRfvo4KcC_NpD3GLsABmWE2Sow@mail.gmail.com>
References: <CAF3hT9Bbu1stoBQbFCct5T3ZSRfvo4KcC_NpD3GLsABmWE2Sow@mail.gmail.com>
Date: Mon, 21 Nov 2011 14:25:35 -0800
Message-ID: <CAF3hT9D+_heqAGdXLsyRzTnVf+fOQqpUcgW1-kGbaPW9LvaRNw@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2408 btrfs_orphan_cleanup
From: Gregory Farnum <gregory.farnum@dreamhost.com>
To: linux-btrfs@vger.kernel.org
Cc: samuel.just@dreamhost.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 18, 2011 at 2:17 PM, Gregory Farnum
<gregory.farnum@dreamhost.com> wrote:
> I'm running Ceph OSDs on btrfs and have managed to corrupt several of
> them so that on mount I get an error:
> root@cephstore6356:~# mount /dev/sde1 /mnt/osd.2/
> 2011 Nov 18 10:44:52 cephstore6356 [68494.771472] btrfs: could not do
> orphan cleanup -116
> mount: Stale NFS file handle
>
> Attempting to mount again works, though:
> root@cephstore6356:~# mount /dev/sde1 /mnt/osd.2/
> root@cephstore6356:~# ls /mnt/osd.2/
> async_snap_test  ceph_fsid  current  fsid  keyring  magic
> snap_5014103  snap_5027478  snap_5031904  store_version  whoami
>
> However, once I start up the ceph-osd daemon (or do much of anything
> else) I get a repeating warning:
> [  715.820406] ------------[ cut here ]------------
> [  715.820409] WARNING: at fs/btrfs/inode.c:2408
> btrfs_orphan_cleanup+0x1f1/0x2f5()
> [  715.820410] Hardware name: PowerEdge R510
> [  715.820411] Modules linked in:
> [  715.820413] Pid: 13238, comm: ceph-osd Tainted: G        W
> 3.1.0-dho-00004-g1ffcb5c-dirty #1
> [  715.820414] Call Trace:
> [  715.820416]  [<ffffffff8103c645>] ? warn_slowpath_common+0x78/0x8c
> [  715.820419]  [<ffffffff812372e3>] ? btrfs_orphan_cleanup+0x1f1/0x2f5
> [  715.820422]  [<ffffffff8123776c>] ? btrfs_lookup_dentry+0x385/0x3ee
> [  715.820425]  [<ffffffff810e2bd1>] ? __d_lookup+0x71/0x108
> [  715.820427]  [<ffffffff812377e2>] ? btrfs_lookup+0xd/0x43
> [  715.820429]  [<ffffffff810db695>] ? d_inode_lookup+0x22/0x3c
> [  715.820431]  [<ffffffff810dbd92>] ? do_lookup+0x1f7/0x2e3
> [  715.820434]  [<ffffffff810dc81a>] ? link_path_walk+0x1a5/0x709
> [  715.820436]  [<ffffffff810b95fb>] ? __do_fault+0x40f/0x44d
> [  715.820439]  [<ffffffff810ded62>] ? path_openat+0xac/0x358
> [  715.820441]  [<ffffffff810df0db>] ? do_filp_open+0x2c/0x72
> [  715.820444]  [<ffffffff810e82c0>] ? alloc_fd+0x69/0x10a
> [  715.820446]  [<ffffffff810d1cb9>] ? do_sys_open+0x103/0x18a
> [  715.820449]  [<ffffffff8166c07b>] ? system_call_fastpath+0x16/0x1b
> [  715.820450] ---[ end trace dd9e40fabcd2d83c ]---
>
> Pretty shortly afterwards the machine goes completely unresponsive and
> I need to powercycle it (in fact I believe I managed to go from one to
> three dead filesystems doing this). Googe only found me one related
> reference (http://comments.gmane.org/gmane.comp.file-systems.btrfs/12501)
> that didn't have a solution (and the backtrace was different anyway).
> This is running tag 3.1 plus the current btrfs/for-linus branch.

Hmm, turns out out the wrong kernel was on them. So, sorry if I scared anybody.
Now that we've upgraded properly to that tree, we no longer get a
crash, but it errors out on certain operations (ceph-sd wants to
replay its journal from a known-good snapshot, so it's opening the
snapshot) and dmesg gets a warning:
[ 7715.110612] ------------[ cut here ]------------
[ 7715.115224] WARNING: at fs/btrfs/inode.c:2189
btrfs_orphan_cleanup+0x250/0x365()
[ 7715.122593] Hardware name: PowerEdge R510
[ 7715.122595] Modules linked in:
[ 7715.122600] Pid: 29052, comm: ceph-osd Not tainted
3.1.0-dho-00144-gabe5bbe-dirty #1
[ 7715.122602] Call Trace:
[ 7715.122611]  [<ffffffff8103c645>] ? warn_slowpath_common+0x78/0x8c
[ 7715.122616]  [<ffffffff81237c37>] ? btrfs_orphan_cleanup+0x250/0x365
[ 7715.122621]  [<ffffffff812380d1>] ? btrfs_lookup_dentry+0x385/0x3ee
[ 7715.122628]  [<ffffffff8109f42d>] ? generic_file_buffered_write+0x1eb/0x24c
[ 7715.122636]  [<ffffffff810e2bd1>] ? __d_lookup+0x71/0x108
[ 7715.122641]  [<ffffffff81238147>] ? btrfs_lookup+0xd/0x44
[ 7715.122645]  [<ffffffff810db695>] ? d_inode_lookup+0x22/0x3c
[ 7715.122649]  [<ffffffff810dbd92>] ? do_lookup+0x1f7/0x2e3
[ 7715.122654]  [<ffffffff810de6b1>] ? do_last+0x13f/0x744
[ 7715.122658]  [<ffffffff810ded84>] ? path_openat+0xce/0x358
[ 7715.122662]  [<ffffffff810df0db>] ? do_filp_open+0x2c/0x72


                                                  [ 7715.122667]
[<ffffffff810e82c0>] ? alloc_fd+0x69/0x10auld not do orphan cleanup
-22
[ 7715.122672]  [<ffffffff810d1cb9>] ? do_sys_open+0x103/0x18a
[ 7715.122680]  [<ffffffff81670abb>] ? system_call_fastpath+0x16/0x1b
[ 7715.122684] ---[ end trace fa3719fc17c9529e ]---
[ 7715.122690] btrfs: Error removing orphan entry, stopping orphan cleanup
[ 7715.122693] btrfs: could not do orphan cleanup -22

Trying again we make it through the dir open that prompted this error
and warn out on an ioctl SNAP_CREATE:
[ 8564.435241] ------------[ cut here ]------------
[ 8564.439854] WARNING: at fs/btrfs/inode.c:2189
btrfs_orphan_cleanup+0x250/0x365()
[ 8564.447222] Hardware name: PowerEdge R510
[ 8564.447224] Modules linked in:
[ 8564.447229] Pid: 2132, comm: ceph-osd Tainted: G        W
3.1.0-dho-00144-gabe5bbe-dirty #1
[ 8564.447232] Call Trace:
[ 8564.447241]  [<ffffffff8103c645>] ? warn_slowpath_common+0x78/0x8c
[ 8564.447247]  [<ffffffff81237c37>] ? btrfs_orphan_cleanup+0x250/0x365
[ 8564.447253]  [<ffffffff8122d141>] ? wait_current_trans+0x1e/0xdf
[ 8564.447259]  [<ffffffff8124f53f>] ? btrfs_mksubvol+0x238/0x31f
[ 8564.447264]  [<ffffffff8124f72d>] ?
btrfs_ioctl_snap_create_transid+0x107/0x12d
[ 8564.447269]  [<ffffffff8124f859>] ? btrfs_ioctl_snap_create+0x46/0x5d
[ 8564.447274]  [<ffffffff812525fd>] ? btrfs_ioctl+0x4bd/0xdcc
[ 8564.447280]  [<ffffffff810df0db>] ? do_filp_open+0x2c/0x72
[ 8564.447286]  [<ffffffff810e0bf9>] ? do_vfs_ioctl+0x3d8/0x425
[ 8564.447290]  [<ffffffff810e0c82>] ? sys_ioctl+0x3c/0x5c
[ 8564.447298]  [<ffffffff81670abb>] ? system_call_fastpath+0x16/0x1b
[ 8564.447302] ---[ end trace fa3719fc17c9529f ]---
[ 8564.447308] btrfs: Error removing orphan entry, stopping orphan cleanup
[ 8564.447311] btrfs: could not do orphan cleanup -22
[ 8683.193377] BTRFS: inode 318333 still on the orphan list

But everything seems to work when we bypass the offending snapshot
(hurray?) and replaying the ceph-osd journal from a different
snapshot. I do get a warning line:
[10035.419884] BTRFS: inode 318333 still on the orphan list

So if I don't hear anything else or see this again I guess I'll just
hope that the cause of this corruption is now eliminated, since it's
at least handled better in the current code.
Thanks!
-Greg
