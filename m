Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28603 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbcGHQkx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 12:40:53 -0400
Date: Fri, 8 Jul 2016 19:40:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: root->fs_info cleanup, add fs_info convenience
 variables
Message-ID: <20160708164037.GA7997@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jeff Mahoney,

This is a semi-automatic email about new static checker warnings.

The patch b286384aac32: "btrfs: root->fs_info cleanup, add fs_info
convenience variables" from Jun 22, 2016, leads to the following
Smatch complaint:

fs/btrfs/export.c:238 btrfs_get_name()
	 warn: variable dereferenced before check 'inode' (see line 226)

fs/btrfs/export.c
   225		struct inode *dir = d_inode(parent);
   226		struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
                                                         ^^^^^^^^^^^
New dereference.

   227		struct btrfs_path *path;
   228		struct btrfs_root *root = BTRFS_I(dir)->root;
   229		struct btrfs_inode_ref *iref;
   230		struct btrfs_root_ref *rref;
   231		struct extent_buffer *leaf;
   232		unsigned long name_ptr;
   233		struct btrfs_key key;
   234		int name_len;
   235		int ret;
   236		u64 ino;
   237	
   238		if (!dir || !inode)
                             ^^^^^
Old code assumed it can be NULL.

   239			return -EINVAL;
   240	

regards,
dan carpenter
