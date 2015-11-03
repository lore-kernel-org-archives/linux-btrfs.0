Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35901 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbbKCSN5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Nov 2015 13:13:57 -0500
Received: by qkcl124 with SMTP id l124so10008279qkc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2015 10:13:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <560E6ED2.4050306@gmail.com>
References: <cover.1443583874.git.osandov@osandov.com> <560E6ED2.4050306@gmail.com>
From: Tobias Holst <tobby@tobby.eu>
Date: Tue, 3 Nov 2015 19:13:37 +0100
Message-ID: <CAGwxe4hxRZNObdkPKikNUux2w94_UfyAKXEaBNY5UyK6b+LKuw@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] Btrfs: free space B-tree
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Omar Sandoval <osandov@osandov.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Anything new on this topic?

I think it would be a great thing and should be merged as soon as it
is stable. :)

Regards,
Tobias


2015-10-02 13:47 GMT+02:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
> On 2015-09-29 23:50, Omar Sandoval wrote:
>>
>> Hi,
>>
>> Here's one more reroll of the free space B-tree patches, a more scalable
>> alternative to the free space cache. Minimal changes this time around, I
>> mainly wanted to resend this after Holger and I cleared up his bug
>> report here: http://www.spinics.net/lists/linux-btrfs/msg47165.html. It
>> initially looked like it was a bug in a patch that Josef sent, then in
>> this series, but finally Holger and I figured out that it was something
>> else in the queue of patches he carries around, we just don't know what
>> yet (I'm in the middle of looking into it). While trying to reproduce
>> that bug, I ran xfstests about a trillion times and a bunch of stress
>> tests, so this is fairly well tested now. Additionally, the last time
>> around, Holger and Austin both bravely offered their Tested-bys on the
>> series. I wasn't sure which patch(es) to tack them onto so here they
>> are:
>>
>> Tested-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
>> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>
> I've re-run the same testing I did for the last iteration, and also tested
> that the btrfs_end_transaction thing mentioned below works right now
> (Ironically that's one of the few things I didn't think of testing last time
> :)), so the Tested-by from me is current now.
>
>>
>> Thanks, everyone!
>>
>> Omar
>>
>> Changes from v3->v4:
>>
>> - Added a missing btrfs_end_transaction() to
>> btrfs_create_free_space_tree() and
>>    btrfs_clear_free_space_tree() in the error cases after we abort the
>>    transaction (see
>> http://www.spinics.net/lists/linux-btrfs/msg47545.html)
>> - Rebased the kernel patches on v4.3-rc3
>> - Rebased the progs patches on v4.2.1
>>
>> v3: http://www.spinics.net/lists/linux-btrfs/msg47095.html
>>
>> Changes from v2->v3:
>>
>> - Fixed a warning in the free space tree sanity tests caught by Zhao Lei.
>> - Moved the addition of a block group to the free space tree to occur
>> either on
>>    the first attempt to modify the free space for the block group or in
>>    btrfs_create_pending_block_groups(), whichever happens first. This
>> avoids a
>>    deadlock (lock recursion) when modifying the free space tree requires
>>    allocating a new block group. In order to do this, it was simpler to
>> change
>>    the on-disk semantics: the superblock stripes will now appear to be
>> free space
>>    according to the free space tree, but load_free_space_tree() will still
>>    exclude them when building the in-memory free space cache.
>> - Changed the free_space_tree option to space_cache=v2 and made
>> clear_cache
>>    clear the free space tree. If the free space tree has been created,
>>    the mount will fail unless space_cache=v2 or nospace_cache,clear_cache
>>    is given because we cannot allow the free space tree to get out of
>>    date.
>> - Did a once-over of the code and caught a couple of error handling typos.
>>
>> v2: http://www.spinics.net/lists/linux-btrfs/msg46796.html
>>
>> Changes from v1->v2:
>>
>> - Cleaned up a bunch of unnecessary instances of "if (ret) goto out; ret =
>> 0"
>> - Added aborts in the free space tree code closer to the site the error is
>>    encountered: where we add or remove block groups, add or remove free
>> space,
>>    and also when we convert formats
>> - Moved loading of the free space tree into caching_thread() and added a
>> new
>>    patch 3 in preparation for it
>> - Commented a bunch of stuff in the extent buffer bitmap operations and
>>    refactored some of the complicated logic
>>
>> v1: http://www.spinics.net/lists/linux-btrfs/msg46713.html
>>
>> Omar Sandoval (9):
>>    Btrfs: add extent buffer bitmap operations
>>    Btrfs: add extent buffer bitmap sanity tests
>>    Btrfs: add helpers for read-only compat bits
>>    Btrfs: refactor caching_thread()
>>    Btrfs: introduce the free space B-tree on-disk format
>>    Btrfs: implement the free space B-tree
>>    Btrfs: add free space tree sanity tests
>>    Btrfs: wire up the free space tree to the extent tree
>>    Btrfs: add free space tree mount option
>>
>>   fs/btrfs/Makefile                      |    5 +-
>>   fs/btrfs/ctree.h                       |  157 +++-
>>   fs/btrfs/disk-io.c                     |   38 +
>>   fs/btrfs/extent-tree.c                 |   98 +-
>>   fs/btrfs/extent_io.c                   |  183 +++-
>>   fs/btrfs/extent_io.h                   |   10 +-
>>   fs/btrfs/free-space-tree.c             | 1584
>> ++++++++++++++++++++++++++++++++
>>   fs/btrfs/free-space-tree.h             |   72 ++
>>   fs/btrfs/super.c                       |   56 +-
>>   fs/btrfs/tests/btrfs-tests.c           |   52 ++
>>   fs/btrfs/tests/btrfs-tests.h           |   10 +
>>   fs/btrfs/tests/extent-io-tests.c       |  138 ++-
>>   fs/btrfs/tests/free-space-tests.c      |   35 +-
>>   fs/btrfs/tests/free-space-tree-tests.c |  571 ++++++++++++
>>   fs/btrfs/tests/qgroup-tests.c          |   20 +-
>>   include/trace/events/btrfs.h           |    3 +-
>>   16 files changed, 2925 insertions(+), 107 deletions(-)
>>   create mode 100644 fs/btrfs/free-space-tree.c
>>   create mode 100644 fs/btrfs/free-space-tree.h
>>   create mode 100644 fs/btrfs/tests/free-space-tree-tests.c
>>
>
>
