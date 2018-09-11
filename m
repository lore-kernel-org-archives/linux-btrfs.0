Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:42152 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbeIKW6g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:58:36 -0400
Received: by mail-qt0-f169.google.com with SMTP id z8-v6so29175391qto.9
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:58:10 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 00/35][v2] My current patch queue
Date: Tue, 11 Sep 2018 13:57:31 -0400
Message-Id: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v1->v2:
- addressed all of the issues brought up.
- added more comments.
- split up some patches.

original message:

This is the current queue of things that I've been working on.  The main thing
these patches are doing is separating out the delayed refs reservations from the
global reserve into their own block rsv.  We have been consistently hitting
issues in production where we abort a transaction because we run out of the
global reserve either while running delayed refs or while updating dirty block
groups.  This is because the math around global reserves is made up bullshit
magic that has been tweaked more and more throughout the years.  The result is
something that is inconsistent across the board and sometimes wrong.  So instead
we need a way to know exactly how much space we need to keep around in order to
satisfy our outstanding delayed refs and our dirty block groups.

Since we don't know how many delayed refs we need at the start of any
modification we simply use the nr_items passed into btrfs_start_transaction() as
a guess for what we may need.  This has the side effect of putting more pressure
on the ENOSPC system, but it's pressure we can deal with more intelligently
because we always know how much space we have outstanding, instead of guessing
with weird global reserve math.

This works similar to every other reservation we have, we reserve the worst case
up front, and then at transaction end time we free up any space we didn't
actually use for delayed refs.

My performance tests show that we are bit faster now since we can do more
intelligent flushing and don't have to fall back on simply committing the
transaction in hopes that we have enough space for everything we need to do.

That leads me to the 2nd part of this pull, there's a bunch of fixes around
ENOSPC.  Because we are a bit faster now there were a bunch of things uncovered
in testing, but they seem to be all resolved now.

The final chunk of fixes are around transaction aborts.  There were a lot of
accounting bugs I was running into while running generic/435, so I fixed a bunch
of those up so now it runs cleanly.

I have been running these patches through xfstests on multiple machines for a
while, they are pretty solid and ready for wider testing and review.  Thanks,

Josef
