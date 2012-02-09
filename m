From: Sage Weil <sage@newdream.net>
Subject: Re: WARNING: at fs/btrfs/inode.c:2222
Date: Wed, 8 Feb 2012 18:18:30 -0800 (PST)
Message-ID: <Pine.LNX.4.64.1202081709290.20027@cobra.newdream.net>
References: <Pine.LNX.4.64.1201270912570.5607@cobra.newdream.net>
 <20120127174042.GF991@shiny> <Pine.LNX.4.64.1201270952150.5607@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1201270952150.5607@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

I've made a little progress here.  The rmdir succeeds and successfully 
adds the orphan item to the tree.  Shortly after that, we (async) snapshot 
current/ to snap_127294/.  And then the orphan cleanup gets

[87552.240450] ------------[ cut here ]------------
[87552.240477] WARNING: at /srv/autobuild-ceph/gitbuilder.git/build/fs/btrfs/inode.c:2237 btrfs_orphan_cleanup+0x44b/0x4d0 [btrfs]()
[87552.240480] Hardware name: PDSMi
[87552.240482] Modules linked in: radeon ttm drm_kms_helper drm ppdev 
parport_pc lp serio_raw parport i3000_edac edac_core i2c_algo_bit shpchp 
ahci libahci floppy e1000e btrfs zlib_deflate crc32c libcrc32c
[87552.240504] Pid: 20605, comm: ceph-osd Not tainted 3.2.0-ceph-00142-g9e98323 #1
[87552.240507] Call Trace:
[87552.240514]  [<ffffffff810634af>] warn_slowpath_common+0x7f/0xc0
[87552.240518]  [<ffffffff8106350a>] warn_slowpath_null+0x1a/0x20
[87552.240531]  [<ffffffffa004a49b>] btrfs_orphan_cleanup+0x44b/0x4d0 [btrfs]
[87552.240536]  [<ffffffff8131bffe>] ? do_raw_spin_unlock+0x5e/0xb0
[87552.240550]  [<ffffffffa006cd42>] btrfs_mksubvol+0x302/0x3d0 [btrfs]
[87552.240564]  [<ffffffffa006cef8>] btrfs_ioctl_snap_create_transid+0xe8/0x180 [btrfs]
[87552.240578]  [<ffffffffa006d019>] btrfs_ioctl_snap_create_v2+0x89/0x100 [btrfs]
[87552.240582]  [<ffffffff8109f730>] ? __lock_acquire+0x210/0x15d0
[87552.240596]  [<ffffffffa006d8fc>] btrfs_ioctl+0x41c/0x1290 [btrfs]
[87552.240601]  [<ffffffff816062b4>] ? retint_restore_args+0x13/0x13
[87552.240606]  [<ffffffff81178040>] ? fget_light+0x40/0x130
[87552.240610]  [<ffffffff81188714>] do_vfs_ioctl+0xa4/0x580
[87552.240614]  [<ffffffff811780d2>] ? fget_light+0xd2/0x130
[87552.240617]  [<ffffffff81178040>] ? fget_light+0x40/0x130
[87552.240620]  [<ffffffff81188c91>] sys_ioctl+0xa1/0xb0
[87552.240624]  [<ffffffff8160e1c2>] system_call_fastpath+0x16/0x1b
[87552.240627] ---[ end trace 3842aca7e75013c8 ]---
[87552.240643] btrfs: Error removing orphan entry, stopping orphan cleanup

causing the ioctl to return -22.  ls -al shows

drwxr-xr-x 1 ubuntu ubuntu   42 2012-02-08 16:12 current
-rw-r--r-- 1 ubuntu ubuntu   37 2012-02-08 15:00 fsid
-rw-r--r-- 1 ubuntu ubuntu   21 2012-02-08 15:00 magic
drwxr-xr-x 1 ubuntu ubuntu  234 2012-02-08 16:12 snap_127219
drwxr-xr-x 1 ubuntu ubuntu  158 2012-02-08 16:12 snap_127249
d????????? ? ?      ?         ?                ? snap_127294

(presumably just because we errored out of create_snapshot() before 
d_instantiate?)

The inode it processes has ino 28844 uid/gid 1000.1000 mode 040755 size 
60... and nlink=1.

btrfs-debug-tree output includes

        item 1 key (28844 INODE_ITEM 0) itemoff 59 itemsize 160
                inode generation 13654 size 60 block group 0 mode 40755 links 1

in three subvols: snap_127219 snap_127249 snap_127294.  Not current.

The first two snaps were taken prior to the rmdir, so that's fine.  But 
the last one just after... the sequence of operations was actually

thread 0	start async snap ioctl, current/ to snap_127294/ ...
thread 1	rmdir current/0.17_254 = 0   (this is the bad dir inode)
thread 1	unlink current/foo           (unrelated)
thread 1	unlink current/bar           (unrelated)
thread 1	rmdir current/0.17_head = 0  (unrelated)
thread 0	...ioctl returns = -EINVAL

It looks like there is some strange leakage between the snapshot and the 
rmdir nlink->0, or some strange interaction between the orphan cleanup and 
the new snapshot.  I'm not quite sure why the orphan cleanup is actually 
done there at all, though, so...

Any suggestions where to look next?

sage
