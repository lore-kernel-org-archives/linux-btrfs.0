Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55689 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3HZOQp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 10:16:45 -0400
Received: by mail-wi0-f181.google.com with SMTP id ex4so831816wid.14
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 07:16:44 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 26 Aug 2013 17:16:42 +0300
Message-ID: <CAOcd+r0PfcX9Xs9ND8zXui3-YyJh+9THz1qrg7u9DsH1L-uO2g@mail.gmail.com>
Subject: btrfs:async-thread: atomic_start_pending=1 is set, but it's too late
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Josef Bacik <jbacik@fusionio.com>, Lev Vainblat <lev@zadarastorage.com>,
        Shyam Kaushik <shyam@zadarastorage.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings all,
I see a following issue with spawning new threads for btrfs_workers
that have atomic_worker_start set:

# I have BTRFS that has 24Gb of total metadata, out of which extent
tree takes 11Gb; space_cache option is not used.
# After mouting, cache_block_group() triggers ~250 work items to
cache-in the needed block groups.
# At this point, fs_info->caching_workers has one thread, which is
considered "idle".
# Work items start to add to this thread's "pending" list, until this
thread becomes considered "busy".
# Now workers->atomic_worker_start is set, but
check_pending_worker_creates() has not run yet (it is called only from
worker_loop), so the same single thread is picked as "fallback".

The problem is that this thread is still running the "caching_thread"
function, scanning for EXTENT_ITEMs of the first block-group. This
takes 3-4seconds for 1Gb block group.

# Once caching_thread() exits, check_pending_worker_creates() is
called, and creates the second thread, but it's too late, because all
the 250 work items are already sitting in the first thread's "pending"
list. So the  second thread doesn't help at all.

As a result, all block-group caching is performed by the same thread,
which, due to one-by-one scanning of EXTENT_ITEMs, takes forever for
this BTRFS.

How this can be fixed?
- can perhaps check_pending_worker_creates() be called out of
worker_loop, e.g., by find_worker()? Instead of just setting
workers->atomic_start_pending?
- maybe for fs_info->caching_workers we don't have to create new
workers asynchronously, so we can pass NULL for async_helper in
btrfs_init_workers()? (probably we have to, just checking)
- any other way?

Thanks,
Alex.
