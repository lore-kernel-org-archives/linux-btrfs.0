Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zougloub.eu ([188.165.233.99]:47797 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab3GMQSA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jul 2013 12:18:00 -0400
Date: Sat, 13 Jul 2013 12:14:04 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Troublesome failure mode and recovery
Message-ID: <20130713121404.65fc89ea@Bidule>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

Experiencing an broken FS in a state I haven't seen before.

I was running linux-3.10 on my laptop, which I had tried to put to sleep
with an external btrfs partition attached.
On resume, the external partition was lost.
I was able to unmount it, despite many kernel warnings.
Then I remounted it... and unplugged the USB cable.
Then I couldn't unmount it.
Well, too bad, not a big deal.
I ran alt+sysrq+s, waited a little, ran alt+sysrq+b.
And on reboot, my root partition (also btrfs) was unmountable, with the error:

  [    1.150000] btrfs bad tree block start 0 1531035648
  [    1.150000] btrfs: failed to read log tree
  [    1.150000] btrfs: open_ctree failed

Then I did the following:

- Tested various mount flags (some by memory, some by looking at the
  `fs/btrfs/super.c` code (recovery,clear_cache...)

- Took the drive (Lenovo-branded Micron RealSSD 400) to another computer
  and made an image of this partition, because this issue could be of use,
  and I have some recent documents that I'd like to recover in some way.

- Run various btrfs-progs utilities on the partition

- Edit the kernel btrfs code and attempt to mount the partition from a
  user-mode linux kernel.

The results are the following:

- `btrfs-restore` only works with `-u 1`, so the first superblock data has
  an issue
- `btrfsck` was crashing because the code would progress even if fs_root
  was null... fixed with this patch:

diff --git a/cmds-check.c b/cmds-check.c
index 8015288..be3e329 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5777,6 +5777,11 @@ int cmd_check(int argc, char **argv)
 
	root = info->fs_root;
 
+	if (root == NULL) {
+		fprintf(stderr, "Error finding FS root\n");
+		return -EIO;
+	}
+
	if (init_extent_tree) {
		printf("Creating a new extent tree\n");
		ret = reinit_extent_tree(info);

- The linux kernel code patched with the following ugly hack would (somehow)
  boot:

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b8b60b6..0807f4d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2627,6 +2627,14 @@ retry_root_backup:
 	tree_root->node = read_tree_block(tree_root,
 					  btrfs_super_root(disk_super),
 					  blocksize, generation);
+
+	if (1) { // ugly hack to force using the second superblock
+		static int i = 0;
+		if (i++ == 0) {
+			goto recovery_tree_root;
+		}
+	}
+
 	if (!tree_root->node ||
 	    !test_bit(EXTENT_BUFFER_UPTODATE, &tree_root->node->bflags)) {
 		printk(KERN_WARNING "btrfs: failed to read tree root on %s\n",

  But /sbin/init, /bin/bash wouldn't fire up because of btrfs errors.
  Looks like some inodes are broken.
  Somehow /usr/bin/python could start, which made me happy.

Within the UML instance with python, I cannot do `ls` (`os.listdir()`)
on my home folder (`/home/cJ`), and btrfs-restore only restores
a few dot files in there.
But I can get inode numbers and read files or subdirectories beyond
this folder. And it looks like btrfs-debug-tree can find transactions
containing older updated directory inodes.
I can also do stat() calls on files, and to call `/sbin/btrfs`
(using `subprocess.Popen` not `os.system()`).
If this were a FAT partition, I would be able to recover data in subfolders
even if the parent folder inode is broken.
I assume the same thing is possible with btrfs, and even more,
given that there are probably older copies of the `/home/cJ` directory
entries from older transactions hanging around somewhere.
But I am no btrfs specialist, so I can't get this data.

Ideally I would like to be able to mount an older generation, or
re-patch older directory inodes where the newer directories cannot be
read.
Having btrfs-restore able to restore sub-directories of a certain generation
would also be very helpful.

So I have my disk image, linux and btrfs-progs from git, a bootable UML,
and can allocate some time to this issue.

Your help is welcome.

Thanks,

-- 
cJ
