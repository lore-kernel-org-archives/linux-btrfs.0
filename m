Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:50067 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752280AbdI2ToJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:09 -0400
Received: by mail-qk0-f175.google.com with SMTP id u67so672512qkg.6
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:09 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 00/21] My current btrfs patch queue
Date: Fri, 29 Sep 2017 15:43:44 -0400
Message-Id: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is my current set of outstanding patches.  A lot of these had reviews and
I've incorporated the feedback.  They have been pretty thorougly tested and are
pretty solid.

[PATCH 01/21] Btrfs: rework outstanding_extents
[PATCH 02/21] btrfs: add tracepoints for outstanding extents mods
[PATCH 03/21] btrfs: make the delalloc block rsv per inode

These are simplification patches.  The way we handled metadata reservation for
multiple extents for an inode was really complicated and fragile, these patches
go a long way towards simplifying that code.  We only have one
outstanding_extents counter, and the rules for changing that counter are more
straightforward and logical.  There are some uglier cases still, but this is as
clean as I could think to do it at the moment.

[PATCH 04/21] btrfs: add ref-verify mount option
[PATCH 05/21] btrfs: pass root to various extent ref mod functions
[PATCH 06/21] Btrfs: add a extent ref verify tool

This is the ref verification set.  I've broken the patches up a little more
since I originally posted them, but it's a big feature so it's just going to be
a bit large unfortunately.  I also fixed all of the printk's so they are
btrfs_err() now.  I folded in all of the various fixes that came from Marc
Merlin's usage of the patches.

[PATCH 07/21] Btrfs: only check delayed ref usage in
[PATCH 08/21] btrfs: add a helper to return a head ref
[PATCH 09/21] btrfs: move extent_op cleanup to a helper
[PATCH 10/21] btrfs: breakout empty head cleanup to a helper
[PATCH 11/21] btrfs: move ref_mod modification into the if (ref)
[PATCH 12/21] btrfs: move all ref head cleanup to the helper function
[PATCH 13/21] btrfs: remove delayed_ref_node from ref_head

Delayed ref's cleanup.  run_delayed_refs was kind of complicated and we did two
things in two different places.  Either we ran the actual delayed ref, or we
cleaned up the delayed_ref_head, and we did this in different places depending
on how things went.  These are mostly moving code around, adding helpers to make
it clear what's happening, and to make __btrfs_run_delayed_refs smaller and
clearer.  I also made btrfs_delayed_ref_head it's own thing and took out the old
delayed_ref_node that was embedded in it.  That existed because heads and refs
used to be on the same list, but since that isn't the case anymore we don't need
it to be that way.

[PATCH 14/21] btrfs: remove type argument from comp_tree_refs
[PATCH 15/21] btrfs: switch args for comp_*_refs
[PATCH 16/21] btrfs: add a comp_refs() helper
[PATCH 17/21] btrfs: track refs in a rb_tree instead of a list

With lots of snapshots we can end up in merge_delayed_refs for _ever_ because
we're constantly going over the list to find matches.  I converted the ref list
in the ref_head to a rb_tree so we can go straight to our refs, which makes
searching and on-the-fly merging happen immediately always, and makes
post-processing of the tree significantly faster.  Now I'm no longer seeing
multi-minute commit times with lots of snapshots.

[PATCH 18/21] btrfs: fix send ioctl on 32bit with 64bit kernel
[PATCH 19/21] btrfs: don't call btrfs_start_delalloc_roots in
[PATCH 20/21] btrfs: move btrfs_truncate_block out of trans handle
[PATCH 21/21] btrfs: add assertions for releasing trans handle

Fixes for various problems I found while running xfstests.  One is for 32bit
ioctls on a 64bit kernel, two are lockdep fixes, and the last one is just so I
can catch myself doing stupid stuff in the future.

Dave this is based on for-next-20170929, and is in my btrfs-next tree in the
master branch if you want to just pull it.  Thanks,

Josef
