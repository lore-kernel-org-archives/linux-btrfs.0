Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:37075 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdIKVMk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 17:12:40 -0400
Received: by mail-qk0-f179.google.com with SMTP id b82so21392900qkc.4
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 14:12:40 -0700 (PDT)
From: josef@toxicpanda.com
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [RFC][0/10] Cleanup and enhance delayed refs
Date: Mon, 11 Sep 2017 17:12:26 -0400
Message-Id: <1505164356-13474-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm leaving for Linux Plumbers tomorrow so I wanted to get this out for people
to look at and see if there were any general comments.  These patches have only
been compiled, not tested in any way, so I wouldn't recommend trying them.  They
do a few things

1) Cleanup empty delayed ref head handling.  We clean this up in a variety of
different ways in different places, so I've unified it all in one helper and
reduced the complexity of __btrfs_run_delayed_refs.

2) Removed the btrfs_delayed_ref_node from the btrfs_delayed_ref_head.  This
used to be this way because we had heads and nodes all on the same list.  Since
this is no longer the case it's just wasted space and weird complexity, so kill
it.

3) Track delayed ref updates in an rb_tree on the head ref instead of in a list.
Our merging stuff really sucks if we end up with lots of different changes to
the same block.  You can end up blowing loads of cpu time during the transaction
commit, which isn't helpful.  With the tree we can not loop as much, and make
our insert time merging much better.

Here is the diffstat

 fs/btrfs/backref.c           |   9 +-
 fs/btrfs/delayed-ref.c       | 294 ++++++++++++++++-----------------
 fs/btrfs/delayed-ref.h       |  54 +++----
 fs/btrfs/disk-io.c           |  22 +--
 fs/btrfs/extent-tree.c       | 376 ++++++++++++++++++++-----------------------
 include/trace/events/btrfs.h |  15 +-
 6 files changed, 363 insertions(+), 407 deletions(-)

Let me know if you have any questions or feedback.  Thanks,

Josef
