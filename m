Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19674 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751991AbdGSNNT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2017 09:13:19 -0400
Date: Wed, 19 Jul 2017 16:13:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: get fs_info from eb in btrfs_print_leaf, remove
 argument
Message-ID: <20170719131307.v7houpsugk5te247@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello David Sterba,

This is a semi-automatic email about new static checker warnings.

The patch c042dd070450: "btrfs: get fs_info from eb in
btrfs_print_leaf, remove argument" from Jun 29, 2017, leads to the
following Smatch complaint:

    fs/btrfs/print-tree.c:181 btrfs_print_leaf()
    warn: variable dereferenced before check 'l' (see line 166)

fs/btrfs/print-tree.c
   165	{
   166		struct btrfs_fs_info *fs_info = l->fs_info;
                                                ^^^^^^^^^^
New dereference.

   167		int i;
   168		u32 type, nr;
   169		struct btrfs_item *item;
   170		struct btrfs_root_item *ri;
   171		struct btrfs_dir_item *di;
   172		struct btrfs_inode_item *ii;
   173		struct btrfs_block_group_item *bi;
   174		struct btrfs_file_extent_item *fi;
   175		struct btrfs_extent_data_ref *dref;
   176		struct btrfs_shared_data_ref *sref;
   177		struct btrfs_dev_extent *dev_extent;
   178		struct btrfs_key key;
   179		struct btrfs_key found_key;
   180	
   181		if (!l)
                    ^^
Checked too late.

   182			return;
   183	

regards,
dan carpenter
