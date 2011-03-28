From: <jasiu@kkfsa.pl>
Subject: I cannot mount two =?UTF-8?Q?=28=3Dall=29=20btrfs=20volumes=20aft?=
 =?UTF-8?Q?er=20crash=20while=20TOI=20suspending?=
Date: Mon, 28 Mar 2011 02:21:15 +0200
Message-ID: <6eba6a23403bc0d71f69bebb5dae0dd4@kkfsa.pl>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 I used btrfs on / and /var.
 After first suspending on 2.6.38.1 yesterday (screen was black,
 no disk activity, but it respond to Magic SysRq 
 [sync,remount-ro,reboot])
 system cannot boot.

 A copied system from 3-month-old backup to new disk using ext4 only fs,
 so I could have btrfs in a module and here are results of my 
 investigations:

 path->slots[0] is 0
 and I observed, that normally it should be =1 for root

 root-tree.c	line 97, btrfs_find_last_root()
 	if (path->slots[0] == 0) {
 		ret = 1;
 		goto out;
 	}

 Then find_and_setup_root() returns error:

 disk-io.c	line 1026, find_and_setup_root()
 	ret = btrfs_find_last_root(tree_root, objectid,
 		&root->root_item, &root->root_key);
 	if (ret > 0)
 		return -ENOENT;

 ...and so does open_ctree()

 disk-io.c	line 1945, open_ctree()
 	ret = find_and_setup_root(tree_root, fs_info,
 		BTRFS_EXTENT_TREE_OBJECTID, extent_root);
 	if (ret)
 		goto fail_tree_root;

 What can I do now to mount my btrfs?
 Here is log after trying to mount:

 kernel: device label jroot devid 1 transid 25083 /dev/sdb3
 kernel: btrfs: allowing degraded mounts
 kernel: parent transid verify failed on 3057614848 wanted 25083 found 
 25080
 kernel: parent transid verify failed on 3057614848 wanted 25083 found 
 25080
 kernel: parent transid verify failed on 3057614848 wanted 25083 found 
 25080
 kernel: btrfs: open_ctree failed

 btrfsck from "next" btrfs-progs-unstable:
 # ./btrfsck /dev/sdb3
 using SB copy 1, bytenr 67108864
 parent transid verify failed on 3057614848 wanted 25083 found 25080
 parent transid verify failed on 3057614848 wanted 25083 found 25080
 parent transid verify failed on 3057614848 wanted 25083 found 25080
 btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' 
 failed.
 Aborted

 Same with /var, and using -s 0 -s 1.

 What can I do to restore my data?
 (I only wanted /etc and /var/log...)

