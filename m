Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:35964 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdKVVQK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 16:16:10 -0500
Received: by mail-qt0-f171.google.com with SMTP id a19so25578197qtb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 13:16:09 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: hannes@cmpxchg.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 00/11] Metadata specific accouting and dirty writeout
Date: Wed, 22 Nov 2017 16:15:55 -0500
Message-Id: <1511385366-20329-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These patches are to support having metadata accounting and dirty handling
in a generic way.  For dirty metadata ext4 and xfs currently are limited by
their journal size, which allows them to handle dirty metadata flushing in a
relatively easy way.  Btrfs does not have this limiting factor, we can have as
much dirty metadata on the system as we have memory, so we have a dummy inode
that all of our metadat pages are allocated from so we can call
balance_dirty_pages() on it and make sure we don't overwhelm the system with
dirty metadata pages.

The problem with this is it severely limits our ability to do things like
support sub-pagesize blocksizes.  Btrfs also supports metadata blocksizes > page
size, which makes keeping track of our metadata and it's pages particularly
tricky.  We have the inode mapping with our pages, and we have another radix
tree for our actual metadata buffers.  This double accounting leads to some fun
shenanigans around reclaim and evicting pages we know we are done using.

To solve this we would like to switch to a scheme like xfs has, where we simply
have our metadata structures tied into the slab shrinking code, and we just use
alloc_page() for our pages, or kmalloc() when we add sub-pagesize blocksizes.
In order to do this we need infrastructure in place to make sure we still don't
overwhelm the system with dirty metadata pages.

Enter these patches.  Because metadata is tracked on a non-pagesize amount we
need to convert a bunch of our existing counters to bytes.  From there I've
added various counters for metadata, to keep track of overall metadata bytes,
how many are dirty and how many are under writeback.  I've added a super
operation to handle the dirty writeback, which is going to be handled mostly
inside the fs since we will need a little more smarts around what we writeback.

The last three patches are just there to show how we use the infrastructure in
the first 8 patches.  The actuall kill btree_inode patch is pretty big,
unfortunately ripping out all of the pagecache based handling and replacing it
with the new infrastructure has to be done whole-hog and can't be broken up
anymore than it already has been without making it un-bisectable.

Thanks,

Josef
