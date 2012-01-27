From: Sage Weil <sage@newdream.net>
Subject: WARNING: at fs/btrfs/inode.c:2222
Date: Fri, 27 Jan 2012 09:31:46 -0800 (PST)
Message-ID: <Pine.LNX.4.64.1201270912570.5607@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Has anyone see this one before?  We've been hitting it sporatically for a 
while now, although recently we've been able to trigger pretty easily.  
The result is EINVAL from the snap create ioctl.

The kernel is v3.2 + some ceph stuff.

The code in question is

		/* if we have links, this was a truncate, lets do that */
		if (inode->i_nlink) {
			if (!S_ISREG(inode->i_mode)) {
				WARN_ON(1);
				iput(inode);
				continue;
			}

Is this something obvious, or should we spend some time chasing it down?

sage


2012-01-27T03:45:07.863424-08:00 sepia95 kernel: [55980.217352] ------------[ cut here ]------------
2012-01-27T03:45:07.863501-08:00 sepia95 kernel: [55980.217403] WARNING: at /srv/autobuild-ceph/gitbuilder.git/build/fs/btrfs/inode.c:2222 btrfs_orphan_cleanup+0xce/0x4e0 [btrfs]()
2012-01-27T03:45:07.863881-08:00 sepia95 kernel: [55980.217413] Hardware name: X6DVA
2012-01-27T03:45:07.864092-08:00 sepia95 kernel: [55980.217420] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs exportfs reiserfs psmouse ppdev parport_pc e752x_edac lp edac_core parport serio_raw shpchp e1000 btrfs floppy zlib_deflate crc32c libcrc32c
2012-01-27T03:45:07.864322-08:00 sepia95 kernel: [55980.217502] Pid: 12666, comm: ceph-osd Not tainted 3.2.0-ceph-00037-gc68bdb1 #1
2012-01-27T03:45:07.864531-08:00 sepia95 kernel: [55980.217511] Call Trace:
2012-01-27T03:45:07.864549-08:00 sepia95 kernel: [55980.217529]  [<ffffffff810634af>] warn_slowpath_common+0x7f/0xc0
2012-01-27T03:45:07.864564-08:00 sepia95 kernel: [55980.217542]  [<ffffffff8106350a>] warn_slowpath_null+0x1a/0x20
2012-01-27T03:45:07.864605-08:00 sepia95 kernel: [55980.217578]  [<ffffffffa004215e>] btrfs_orphan_cleanup+0xce/0x4e0 [btrfs]
2012-01-27T03:45:07.864619-08:00 sepia95 kernel: [55980.217596]  [<ffffffff8131bffe>] ? do_raw_spin_unlock+0x5e/0xb0
2012-01-27T03:45:07.864648-08:00 sepia95 kernel: [55980.217632]  [<ffffffffa0068b62>] btrfs_mksubvol+0x302/0x3d0 [btrfs]
2012-01-27T03:45:07.864661-08:00 sepia95 kernel: [55980.217668]  [<ffffffffa0068d18>] btrfs_ioctl_snap_create_transid+0xe8/0x180 [btrfs]
2012-01-27T03:45:07.864675-08:00 sepia95 kernel: [55980.217704]  [<ffffffffa0068e39>] btrfs_ioctl_snap_create_v2+0x89/0x100 [btrfs]
2012-01-27T03:45:07.864688-08:00 sepia95 kernel: [55980.217719]  [<ffffffff8109f730>] ? __lock_acquire+0x210/0x15d0
2012-01-27T03:45:07.864711-08:00 sepia95 kernel: [55980.217752]  [<ffffffffa006989a>] btrfs_ioctl+0x59a/0x1060 [btrfs]
2012-01-27T03:45:07.864725-08:00 sepia95 kernel: [55980.217768]  [<ffffffff81178040>] ? fget_light+0x40/0x130
2012-01-27T03:45:07.864739-08:00 sepia95 kernel: [55980.217780]  [<ffffffff81188714>] do_vfs_ioctl+0xa4/0x580
2012-01-27T03:45:07.864752-08:00 sepia95 kernel: [55980.217793]  [<ffffffff811780d2>] ? fget_light+0xd2/0x130
2012-01-27T03:45:07.864775-08:00 sepia95 kernel: [55980.217804]  [<ffffffff81178040>] ? fget_light+0x40/0x130
2012-01-27T03:45:07.864789-08:00 sepia95 kernel: [55980.217817]  [<ffffffff81188c91>] sys_ioctl+0xa1/0xb0
2012-01-27T03:45:07.864803-08:00 sepia95 kernel: [55980.217831]  [<ffffffff8160e1c2>] system_call_fastpath+0x16/0x1b
2012-01-27T03:45:07.864816-08:00 sepia95 kernel: [55980.217841] ---[ end trace 7be8f23802b76936 ]---
2012-01-27T03:45:07.864829-08:00 sepia95 kernel: [55980.217871] btrfs: Error removing orphan entry, stopping orphan cleanup
2012-01-27T03:45:07.864852-08:00 sepia95 kernel: [55980.224667] btrfs: could not do orphan cleanup -22
