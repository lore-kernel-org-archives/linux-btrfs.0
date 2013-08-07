Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:36340 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518Ab3HGVqy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 17:46:54 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 0/7] uselex.rb as a tiny tool to find dead code
Date: Thu,  8 Aug 2013 00:43:16 +0300
Message-Id: <1375911803-17318-1-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Hi guys!

TL;DR:

the patches remove (currently or already) dead code
and localize symbol visibility used only in one module.

Thanks!

The Story:

Once upon a time I've got very simple idea to find dead code
in large C/C++ mixed project at work.

The things of my primary interest were things of too large
visibility scope, like:
 - externally visible global variables used only in module
   defining the variable
 - and functions of the same property

Once you identify those functions and mark as 'static' you
achieve two goals:

 - minor: give compiler possibility to inline code a bit better
   (especially for one-caller case)
 - more interesting: possibility to spot that the symbol is no
   longer used at all

Hence the project idea:
1. scan all intermediate object (.o) files for exported symbols
2. find such symbols that are not imported into any .o files

Meet uselex.rb: one-file script to parse 'nm' output:

    https://github.com/trofi/uselex/blob/master/uselex.rb

For linux's kernel it's use is as simple as:

    $ make $config && make
    $ uselex.rb `find -name '*.o'`

and you've got material to look at!

It outputs 3000 symbols thus I've started small:

    $ uselex.rb `find fs/btrfs -name '*.o'

To get an impression it reports such things:

    set_state_private: [R]: exported from: fs/btrfs/built-in.o fs/btrfs/btrfs.o fs/btrfs/extent_io.o
    btrfs_get_inode_ref_index: [R]: exported from: fs/btrfs/built-in.o fs/btrfs/inode-item.o fs/btrfs/btrfs.o
    btrfs_print_tree: [R]: exported from: fs/btrfs/built-in.o fs/btrfs/print-tree.o fs/btrfs/btrfs.o
    btrfs_reada_detach: [R]: exported from: fs/btrfs/built-in.o fs/btrfs/reada.o fs/btrfs/btrfs.o
    __btrfs_getxattr: [R]: exported from: fs/btrfs/built-in.o fs/btrfs/xattr.o fs/btrfs/btrfs.o
    __btrfs_setxattr: [R]: exported from: fs/btrfs/built-in.o fs/btrfs/xattr.o fs/btrfs/btrfs.o
    btrfs_read_root_item: [R]: exported from: fs/btrfs/root-tree.o fs/btrfs/built-in.o fs/btrfs/btrfs.o
    __tracepoint_btrfs_sync_fs: [R]: exported from: fs/btrfs/super.o fs/btrfs/built-in.o fs/btrfs/btrfs.o
    btrfs_start_transaction_lflush: [R]: exported from: fs/btrfs/transaction.o fs/btrfs/built-in.o fs/btrfs/btrfs.o
    btrfs_write_and_wait_marked_extents: [R]: exported from: fs/btrfs/transaction.o fs/btrfs/built-in.o fs/btrfs/btrfs.o
    ulist_fini: [R]: exported from: fs/btrfs/ulist.o fs/btrfs/built-in.o fs/btrfs/btrfs.o
    ulist_init: [R]: exported from: fs/btrfs/ulist.o fs/btrfs/built-in.o fs/btrfs/btrfs.o

You just need to make sure it does not lie too much.

For example '__btrfs_getxattr' needs to be brought under '#ifdef CONFIG_BTRFS_FS_POSIX_ACL'
and not removed entirely.

Thanks for your patience!
