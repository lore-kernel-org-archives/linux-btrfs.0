Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:41139 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaDGPpb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 11:45:31 -0400
Received: by mail-ob0-f178.google.com with SMTP id wp18so6694740obc.23
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Apr 2014 08:45:31 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 Apr 2014 23:45:30 +0800
Message-ID: <CAAcaxmWqrLUwbvmsyE+3zLLP1jSVZXGASRvN-D-BLaJp4WnpLQ@mail.gmail.com>
Subject: Is this a race bug when releasing eb?
From: ylet ylet <levin.front@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: clm@fb.com, jbacik <jbacik@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Assuming thread 1 (may be VFS want to release the page) wants to
release a CLEAN page and thus the eb attaching the page.
and thread 2 wants to access the eb and cow the eb.

Thread 1
               Thread 2

btree_releasepage

try_release_extent_buffer

release_extent_buffer
->if (atomic_dec_and_test(&eb->refs)) {
->spin_unlock(&eb->refs_lock);
 -------switch to thread 2 here------

               read_block_for_search

                btrfs_find_tree_block

     radix_tree_lookup && atomic_inc_not_zero

                  ................

                btrfs_mark_buffer_dirty(eb)

                ---------switch to thread 1 here ------

- >spin_lock(&tree->buffer_lock);
->radix_tree_delete(&tree->buffer,
 eb->start >> PAGE_CACHE_SHIFT);
->spin_unlock(&tree->buffer_lock);
-->btrfs_release_extent_buffer_page
-->trigger BUG_ON(extent_buffer_under_io(eb))!!!!


This is because Thread 2 can still find the eb while thread 1 has dec
the eb->refs to 0, so eventually trigger the BUG_ON.

I have triggered the BUG_ON while testing btrfs, but I am not sure if
the bug-on is rise by my guess above.
