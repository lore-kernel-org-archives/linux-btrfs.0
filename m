Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32863 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752865AbdGSS1O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2017 14:27:14 -0400
Date: Wed, 19 Jul 2017 20:25:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [bug report] btrfs: get fs_info from eb in btrfs_print_leaf,
 remove argument
Message-ID: <20170719182558.GC2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170719131307.v7houpsugk5te247@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170719131307.v7houpsugk5te247@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 19, 2017 at 04:13:07PM +0300, Dan Carpenter wrote:
> Hello David Sterba,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch c042dd070450: "btrfs: get fs_info from eb in
> btrfs_print_leaf, remove argument" from Jun 29, 2017, leads to the
> following Smatch complaint:
> 
>     fs/btrfs/print-tree.c:181 btrfs_print_leaf()
>     warn: variable dereferenced before check 'l' (see line 166)
> 
> fs/btrfs/print-tree.c
>    165	{
>    166		struct btrfs_fs_info *fs_info = l->fs_info;
>                                                 ^^^^^^^^^^
> New dereference.
> 
>    167		int i;
>    168		u32 type, nr;
>    169		struct btrfs_item *item;
>    170		struct btrfs_root_item *ri;
>    171		struct btrfs_dir_item *di;
>    172		struct btrfs_inode_item *ii;
>    173		struct btrfs_block_group_item *bi;
>    174		struct btrfs_file_extent_item *fi;
>    175		struct btrfs_extent_data_ref *dref;
>    176		struct btrfs_shared_data_ref *sref;
>    177		struct btrfs_dev_extent *dev_extent;
>    178		struct btrfs_key key;
>    179		struct btrfs_key found_key;
>    180	
>    181		if (!l)
>                     ^^
> Checked too late.

Thanks, I've moved the fs_info initialization after this check. In both
patches (btrfs_print_leaf and btrfs_print_tree).
