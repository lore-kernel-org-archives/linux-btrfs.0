From: David Sterba <dsterba@suse.cz>
Subject: [RFC, crash][PATCH] btrfs: allow cross-subvolume file clone
Date: Wed,  3 Aug 2011 20:07:42 +0200
Message-ID: <1312394862-28143-1-git-send-email-dsterba@suse.cz>
Cc: chris.mason@oracle.com, josef@redhat.com, miaox@cn.fujitsu.com,
	David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm working on a patch to fix cross-volume cloning, worked for simple cases
like cloning a single file. When I cloned a full linux-2.6 tree there was a
immediate BUG_ON (after third cloned file) in btrfs_delayed_update_inode
with -ENOSPC :

[  925.546266] ------------[ cut here ]------------
[  925.549921] kernel BUG at fs/btrfs/delayed-inode.c:1693!
[  925.549921] invalid opcode: 0000 [#1] SMP
[  925.549921] CPU 0
[  925.549921] Modules linked in: btrfs
[  925.549921]
[  925.549921] Pid: 31167, comm: clone-file Not tainted 3.0.0-default+ #98 Intel Corporation Santa Rosa platform/Matanzas
[  925.549921] RIP: 0010:[<ffffffffa00790e0>]  [<ffffffffa00790e0>] btrfs_delayed_update_inode+0x2e0/0x2f0 [btrfs]
[  925.549921] RSP: 0018:ffff88004f229be8  EFLAGS: 00010286
[  925.549921] RAX: 00000000ffffffe4 RBX: ffff880048392c70 RCX: 0000000000018000
[  925.549921] RDX: 0000000000001b1a RSI: 0000000000000001 RDI: ffff88007a6f8420
[  925.549921] RBP: ffff88004f229c28 R08: 0000000000000004 R09: 0000000000000000
[  925.549921] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880048393bf8
[  925.549921] R13: ffff880048392cb8 R14: ffff880050ff3540 R15: ffff880052940000
[  925.549921] FS:  00007fbf18b23700(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
[  925.549921] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  925.549921] CR2: 00007fbcc68ba000 CR3: 000000004b4a8000 CR4: 00000000000006f0
[  925.549921] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  925.549921] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  925.549921] Process clone-file (pid: 31167, threadinfo ffff88004f228000, task ffff88004b4e5140)
[  925.549921] Stack:
[  925.549921]  ffff880048f7ddc0 0000000000018000 ffff88004f229c38 ffff880048393bf8
[  925.549921]  ffff880050ff3540 ffff880048393bf8 ffff880051a900a0 ffff880052940000
[  925.549921]  ffff88004f229c78 ffffffffa0034633 ffff88004f229c58 ffffffffa005f08b
[  925.549921] Call Trace:
[  925.549921]  [<ffffffffa0034633>] btrfs_update_inode+0x53/0x160 [btrfs]
[  925.549921]  [<ffffffffa005f08b>] ? btrfs_tree_unlock+0x6b/0xa0 [btrfs]
[  925.549921]  [<ffffffffa005b0ba>] btrfs_ioctl_clone+0xa0a/0xcc0 [btrfs]
[  925.549921]  [<ffffffff81168c81>] ? __do_fault+0x4a1/0x590
[  925.549921]  [<ffffffff810daa1d>] ? lock_release_holdtime+0x3d/0x1c0
[  925.549921]  [<ffffffff81b8dc20>] ? do_page_fault+0x2d0/0x580
[  925.549921]  [<ffffffffa005dfcb>] btrfs_ioctl+0x2db/0xda0 [btrfs]
[  925.549921]  [<ffffffff81b8dc20>] ? do_page_fault+0x2d0/0x580
[  925.549921]  [<ffffffff810e1467>] ? debug_check_no_locks_freed+0x177/0x180
[  925.549921]  [<ffffffff811863c5>] ? kmem_cache_free+0xb5/0x1b0
[  925.549921]  [<ffffffff811a5db8>] do_vfs_ioctl+0x98/0x570
[  925.549921]  [<ffffffff8119476d>] ? fget_light+0x2fd/0x3c0
[  925.549921]  [<ffffffff811a62df>] sys_ioctl+0x4f/0x80
[  925.549921]  [<ffffffff81b92882>] system_call_fastpath+0x16/0x1b
[  925.549921] Code: e8 06 00 00 8d 0c 49 48 89 ca 48 89 4d c8 e8 c8 0f fa ff 85 c0 48 8b 4d c8 75 10 48 89 4b 08 e9 8e fd ff ff 0f 1f 80 00 00 00 00 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 53
[  925.549921] RIP  [<ffffffffa00790e0>] btrfs_delayed_update_inode+0x2e0/0x2f0 [btrfs]
[  925.549921]  RSP <ffff88004f229be8>
[  925.876182] ---[ end trace 8b4c2031e1394913 ]---

the patch has been applied on top of current linus which contains patches from
both pull requests (ed8f37370d83).

The filesystem consists of 5 devices 23G each, about 100G of usable space,
mkfs.btrfs with defaults. The kernel tree has about 6G:

$ btrfs fi df .
Data, RAID0: total=10.00GB, used=5.55GB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.50GB, used=121.75MB
Metadata: total=8.00MB, used=0.00

$ df -h .
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda5             110G  5.8G   82G   7% /mnt/sda5

ie. plenty of free space.

It's possible that I've omitted some important bits in the patch itself, or
this exposes a bug of ENOSPC or delayed-inode.

david
---

From: David Sterba <dsterba@suse.cz>

Lift the EXDEV condition and allow different root trees for files being
cloned, then pass source inode's root when searching for extents.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0b980af..58eb0ef 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2183,7 +2183,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		goto out_fput;
 
 	ret = -EXDEV;
-	if (src->i_sb != inode->i_sb || BTRFS_I(src)->root != root)
+	if (src->i_sb != inode->i_sb)
 		goto out_fput;
 
 	ret = -ENOMEM;
@@ -2247,13 +2247,14 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 		 * note the key will change type as we walk through the
 		 * tree.
 		 */
-		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+		ret = btrfs_search_slot(NULL, BTRFS_I(src)->root, &key, path,
+				0, 0);
 		if (ret < 0)
 			goto out;
 
 		nritems = btrfs_header_nritems(path->nodes[0]);
 		if (path->slots[0] >= nritems) {
-			ret = btrfs_next_leaf(root, path);
+			ret = btrfs_next_leaf(BTRFS_I(src)->root, path);
 			if (ret < 0)
 				goto out;
 			if (ret > 0)
-- 

$ cat clone-file.c
#include <stdio.h>
#include <sys/ioctl.h>
#include <sys/fcntl.h>
#include "ioctl.h"

/*
 * usage: $0 input output
 * input: existing
 * output: newly created from input
 */
int main(int argc, char **argv) {
        int infd, outfd;
        int ret;

        printf("input: %s\n", argv[1]);
        printf("output: %s\n", argv[2]);

        infd=open(argv[1], O_RDONLY);
        if(infd == -1) {
                perror("cannot open input file");
                return 1;
        }
        outfd=open(argv[2], O_RDWR | O_CREAT | O_EXCL, 0644);
        if(outfd == -1) {
                perror("cannot open output file");
                return 2;
        }
        ret = ioctl(outfd, BTRFS_IOC_CLONE, infd);
        if(ret == -1) {
                perror("ioctl(CLONE)");
                return 3;
        }
        return 0;
}
