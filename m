Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46359 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933024AbcLVNBv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 08:01:51 -0500
Date: Thu, 22 Dec 2016 15:53:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: root->fs_info cleanup, add fs_info convenience
 variables
Message-ID: <20161222125304.GA16117@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jeff Mahoney,

This is a semi-automatic email about new static checker warnings.

The patch 0b246afa62b0: "btrfs: root->fs_info cleanup, add fs_info 
convenience variables" from Jun 22, 2016, leads to the following 
Smatch complaint:

fs/btrfs/export.c:238 btrfs_get_name()
	 warn: variable dereferenced before check 'inode' (see line 226)

fs/btrfs/export.c
   225		struct inode *dir = d_inode(parent);
   226		struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
                                                         ^^^^^^^^^^^
Patch adds dereference.

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
Old code checked for NULL.

   239			return -EINVAL;
   240	

regards,
dan carpenter
