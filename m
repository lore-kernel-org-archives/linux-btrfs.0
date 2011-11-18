Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49813 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab1KRWRT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Nov 2011 17:17:19 -0500
Received: by iage36 with SMTP id e36so4189130iag.19
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2011 14:17:19 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 18 Nov 2011 14:17:18 -0800
Message-ID: <CAF3hT9Bbu1stoBQbFCct5T3ZSRfvo4KcC_NpD3GLsABmWE2Sow@mail.gmail.com>
Subject: WARNING: at fs/btrfs/inode.c:2408 btrfs_orphan_cleanup
From: Gregory Farnum <gregory.farnum@dreamhost.com>
To: linux-btrfs@vger.kernel.org
Cc: samuel.just@dreamhost.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running Ceph OSDs on btrfs and have managed to corrupt several of
them so that on mount I get an error:
root@cephstore6356:~# mount /dev/sde1 /mnt/osd.2/
2011 Nov 18 10:44:52 cephstore6356 [68494.771472] btrfs: could not do
orphan cleanup -116
mount: Stale NFS file handle

Attempting to mount again works, though:
root@cephstore6356:~# mount /dev/sde1 /mnt/osd.2/
root@cephstore6356:~# ls /mnt/osd.2/
async_snap_test  ceph_fsid  current  fsid  keyring  magic
snap_5014103  snap_5027478  snap_5031904  store_version  whoami

However, once I start up the ceph-osd daemon (or do much of anything
else) I get a repeating warning:
[  715.820406] ------------[ cut here ]------------
[  715.820409] WARNING: at fs/btrfs/inode.c:2408
btrfs_orphan_cleanup+0x1f1/0x2f5()
[  715.820410] Hardware name: PowerEdge R510
[  715.820411] Modules linked in:
[  715.820413] Pid: 13238, comm: ceph-osd Tainted: G        W
3.1.0-dho-00004-g1ffcb5c-dirty #1
[  715.820414] Call Trace:
[  715.820416]  [<ffffffff8103c645>] ? warn_slowpath_common+0x78/0x8c
[  715.820419]  [<ffffffff812372e3>] ? btrfs_orphan_cleanup+0x1f1/0x2f5
[  715.820422]  [<ffffffff8123776c>] ? btrfs_lookup_dentry+0x385/0x3ee
[  715.820425]  [<ffffffff810e2bd1>] ? __d_lookup+0x71/0x108
[  715.820427]  [<ffffffff812377e2>] ? btrfs_lookup+0xd/0x43
[  715.820429]  [<ffffffff810db695>] ? d_inode_lookup+0x22/0x3c
[  715.820431]  [<ffffffff810dbd92>] ? do_lookup+0x1f7/0x2e3
[  715.820434]  [<ffffffff810dc81a>] ? link_path_walk+0x1a5/0x709
[  715.820436]  [<ffffffff810b95fb>] ? __do_fault+0x40f/0x44d
[  715.820439]  [<ffffffff810ded62>] ? path_openat+0xac/0x358
[  715.820441]  [<ffffffff810df0db>] ? do_filp_open+0x2c/0x72
[  715.820444]  [<ffffffff810e82c0>] ? alloc_fd+0x69/0x10a
[  715.820446]  [<ffffffff810d1cb9>] ? do_sys_open+0x103/0x18a
[  715.820449]  [<ffffffff8166c07b>] ? system_call_fastpath+0x16/0x1b
[  715.820450] ---[ end trace dd9e40fabcd2d83c ]---

Pretty shortly afterwards the machine goes completely unresponsive and
I need to powercycle it (in fact I believe I managed to go from one to
three dead filesystems doing this). Googe only found me one related
reference (http://comments.gmane.org/gmane.comp.file-systems.btrfs/12501)
that didn't have a solution (and the backtrace was different anyway).
This is running tag 3.1 plus the current btrfs/for-linus branch.

Any advice, solutions, requests for other information, etc are much
appreciated. :)
-Greg
