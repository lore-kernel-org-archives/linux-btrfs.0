Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46732 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaHYF04 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 01:26:56 -0400
Received: by mail-pa0-f44.google.com with SMTP id eu11so20068279pac.3
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 22:26:55 -0700 (PDT)
From: Naohiro Aota <naota@elisp.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Liu Bo <bo.li.liu@oracle.com>
Subject: btrfs-progs: initial reference count of extent buffer is correct?
Date: Mon, 25 Aug 2014 14:26:49 +0900
Message-ID: <87y4ud2l7q.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, list

I'm having trouble with my btrfs FS recently and running btrfs check to
try to fix the FS. Unfortunately, it aborted with:

btrfsck: root-tree.c:81: btrfs_update_root: Assertion `!(ret != 0)' failed.

It means that "extent tree root" is not found in "tree root tree"! Then
I added btrfs_print_leaf() there to see what is happening there. There
were "(... METADATA_ITEM 0)" keys listed. Well, I found "tree root
tree"'s root extent buffer is somewhat replaced by a extent buffer from
the extent tree.

Reading the code, it seems that free_some_buffers() reclaim extent
buffers allocated to root trees because they are not
extent_buffer_get()ed (i.e. @refs == 1). 

To reproduce this problem, try running this code. This program first
print root tree node's bytenr, and scan some trees. If your FS is large
enough to run free_some_buffers(), tree root node's bytenr after the
scan would be different.

#include <stdio.h>
#include "ctree.h"
#include "disk-io.h"

void scan_tree(struct btrfs_root *root, struct extent_buffer *eb)
{
  u32 i;
  u32 nr;
  nr = btrfs_header_nritems(eb);
  if (btrfs_is_leaf(eb)) return;
  u32 size = btrfs_level_size(root, btrfs_header_level(eb) - 1);
  for (i = 0; i < nr; i++) {
    if (btrfs_is_leaf(eb)) return;
    u64 bytenr = btrfs_node_blockptr(eb, i);
    struct extent_buffer *next = read_tree_block(root, bytenr, size,
						 btrfs_node_ptr_generation(eb, i));
    if (!next) continue;
    scan_tree(root, next);
  }
}

int main(int ac, char **av)
{
  struct btrfs_fs_info *info;
  struct btrfs_root *root;
  info = open_ctree_fs_info(av[1], 0, 0, OPEN_CTREE_PARTIAL);
  root = info->fs_root;
  printf("tree root %lld\n", info->tree_root->node->start);
  scan_tree(info->fs_root, info->extent_root->node);
  scan_tree(info->fs_root, info->csum_root->node);
  scan_tree(info->fs_root, info->fs_root->node);
  printf("tree root %lld\n", info->tree_root->node->start);
  return close_ctree(root);
}

On my environment, the above code print the following result. "Tree root
tree variable" is eventually pointing to another extent!

$ ./btrfs-reproduce /dev/sda3
tree root 91393835008
tree root 49102848

I found commit 53ee1bccf99cd5b474fe1aa857b7dd176e3a1407 changed the
initial @refs to 1, stating that "we don't give enough
free_extent_buffer() to reduce the eb's references to zero so that the
eb can finally be freed", but I don't think this is correct. Even if
initial @refs == 2, one free_extent_buffer() would make the @refs to 1
and so let it reclaimed by free_some_buffer(), so it does not seems to
be a problem for me...

I think there are some collides how to use extent buffer: should
__alloc_extent_buffer set @refs = 2 for the caller or should the code
call extent_buffer_get() by themselves everywhere you allocate eb before
any other eb allocation not to let the first eb reclaimed? How to fix
this problem? revert 53ee1bccf99cd5b474fe1aa857b7dd176e3a1407 is the
collect way? or add "missing" extent_buffer_get() everywhere allocating
is done?

Naohiro
