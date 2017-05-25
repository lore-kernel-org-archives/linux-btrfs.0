Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:36063 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdEYBqK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 21:46:10 -0400
Received: by mail-it0-f48.google.com with SMTP id o5so49139034ith.1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2017 18:46:10 -0700 (PDT)
MIME-Version: 1.0
From: Justin Maggard <jmaggard10@gmail.com>
Date: Wed, 24 May 2017 18:46:08 -0700
Message-ID: <CAKgsxVQpfo8MeMBBvFC+tj8pYgLGKRDB7ZKLNAZ2G1oFXjBmHQ@mail.gmail.com>
Subject: Global reserve values
To: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've run into a few systems where we start getting immediate ENOSPC
errors on any operation as soon as we update to a recent kernel.
These are all small filesystems (not MIXED), which should have had
plenty of free metadata space but no unallocated chunks.

I was able to trace this back to commit ae2e47288165 (Btrfs: change
how we calculate the global block rsv).  This commit changes from
guessing how much reserve space we need, to using the sum of the
reported sizes of the extent, csum, and tree roots.  But on the
affected systems, the extent tree root item claimed to be very large
-- even larger than the total amount of metadata used.  This caused
the global reserve to crowd out any new metadata allocation, resulting
in ENOSPC errors.

I have no idea how, when, or why the chunk tree root item's bytes_used
value got so out of whack; and I haven't been able to reproduce it so
far on a fresh system.  But in any case, it looks like we'll need to
sanity-check it.  My main question is, what is a reasonable way to
sanity-check it?  The old code did:

    if (num_bytes * 3 > meta_used)
            num_bytes = div_u64(meta_used, 3);

But adding that breaks generic/333 again.  Changing 3 to 2 works, but
then I'm just guessing.  What would be appropriate?

-Justin
