Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36002 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753430AbdAJSfy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:35:54 -0500
Received: by mail-wm0-f68.google.com with SMTP id r126so11434304wmr.3
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:35:54 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [RFC PATCH 00/12] Refactor btrfs_inode VS inode in delayed-inode.c
Date: Tue, 10 Jan 2017 20:35:30 +0200
Message-Id: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

After following the discussion in [1] I took a look at what's the 
state of VFS-related members being used in core BTRFS code. It turned 
out there are quite a few functions which operate on struct btrfs_inode, 
yet take struct inode. As a result they have to resort ot excessive 
usage of BTRFS_I, furthermore passing inode around doesn't help the 
poor reader inferring why inode might be passed to a particular function. 

In order to better separate core btrfs functionalities from those part,
which interface with the VFS I took a look around the code and this is 
the result. I'd like to solicit opinions whether people think this 
refactoring is useful, since I have gathered a list of a lot more
functions which might use a bit of inode VS btrfs_inode changes. Also, 
a lot of function take inode just because btrfs_ino was taking an inode.

The patches are self-explanatory, with the first one dealing with 
btrfs_ino being the bulk of it. This paves the way to restructuring 
a lot of functions. 

If the maintainers think this should be merged I'd rather resend it 
as a single patch so as not to pollute the git history. This 
version can be used for fine-grained discussion and feedback. 


[1] http://marc.info/?l=linux-btrfs&m=148388138221778

Nikolay Borisov (12):
  btrfs: Make btrfs_ino take a struct btrfs_inode
  btrfs: Make btrfs_get_delayed_node take btrfs_inode
  btrfs: Make btrfs_get_or_create_delayed_node take btrfs_inode
  btrfs: Make btrfs_delayed_inode_reserve_metadata take btrfs_inode
  btrfs: Make btrfs_insert_delayed_dir_index take btrfs_inode
  btrfs: Make btrfs_delete_delayed_dir_index take btrfs_inode
  btrfs: Make btrfs_delayed_delete_inode_ref take btrfs_inode
  btrfs: Make btrfs_kill_delayed_inode_items take btrfs_inode
  btrfs: Make btrfs_remove_delayed_node take btrfs_inode
  btrfs: Make btrfs_commit_inode_delayed_inode take btrfs_inode
  btrfs: Make btrfs_commit_inode_delayed_items take btrfs_inode
  btrfs: Make btrfs_inode_delayed_dir_index_count take btrfs_inode

 fs/btrfs/btrfs_inode.h      |  10 ++--
 fs/btrfs/compression.c      |   2 +-
 fs/btrfs/delayed-inode.c    |  54 +++++++++---------
 fs/btrfs/delayed-inode.h    |  16 +++---
 fs/btrfs/dir-item.c         |   4 +-
 fs/btrfs/export.c           |  10 ++--
 fs/btrfs/extent-tree.c      |  10 ++--
 fs/btrfs/extent_io.c        |  10 ++--
 fs/btrfs/file-item.c        |   4 +-
 fs/btrfs/file.c             |  12 ++--
 fs/btrfs/free-space-cache.c |   2 +-
 fs/btrfs/inode.c            | 134 ++++++++++++++++++++++----------------------
 fs/btrfs/ioctl.c            |  26 ++++-----
 fs/btrfs/props.c            |   4 +-
 fs/btrfs/relocation.c       |  16 +++---
 fs/btrfs/transaction.c      |   4 +-
 fs/btrfs/tree-log.c         |  46 +++++++--------
 fs/btrfs/xattr.c            |  10 ++--
 18 files changed, 186 insertions(+), 188 deletions(-)

-- 
2.7.4

