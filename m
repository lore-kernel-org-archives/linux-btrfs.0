From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [btrfs] kernel BUG at include/linux/spinlock.h:376!
Date: Thu, 14 Jan 2010 14:37:08 -0500
Message-ID: <20100114193708.GD23810@think>
References: <201001072229.33976.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001072229.33976.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 07, 2010 at 10:29:32PM +0100, Johannes Hirte wrote:
> One of my btrfs filesystems gives the following bug message on access:
> 
> Jan  6 23:08:12 datengrab kernel: ------------[ cut here ]------------
> Jan  6 23:08:12 datengrab kernel: kernel BUG at include/linux/spinlock.h:376!
> Jan  6 23:08:12 datengrab kernel: invalid opcode: 0000 [#1] SMP
> Jan  6 23:08:12 datengrab kernel: last sysfs file: 
> /sys/devices/pci0000:00/0000:00:18.3/temp1_input
> Jan  6 23:08:12 datengrab kernel: CPU 1
> Jan  6 23:08:12 datengrab kernel: Pid: 2837, comm: btrfs-endio-wri Not tainted 
> 2.6.33-rc3-00033-g03b7675 #12 TYAN Tiger K8W Dual AMD Opteron, S2875/To Be 
> Filled
> By O.E.M.
> Jan  6 23:08:12 datengrab kernel: RIP: 0010:[<ffffffff8118f7ea>]  [<ffffffff8118f7ea>] 
> btrfs_assert_tree_locked+0x16/0x1c

Well, we really should have this tree block locked, but
btrfs_mark_extent_written is doing some special things.  Is the trace
always the same?

If so, please try this patch:

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3bfe9f0..1148aa0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -572,6 +572,7 @@ again:
 	key.objectid = inode->i_ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = split;
+	path->keep_locks = 1;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret > 0 && path->slots[0] > 0)
