Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:53431 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdKAFAb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 01:00:31 -0400
Received: by mail-wm0-f43.google.com with SMTP id r196so2670103wmf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 22:00:30 -0700 (PDT)
MIME-Version: 1.0
From: Dave <davestechshop@gmail.com>
Date: Wed, 1 Nov 2017 01:00:08 -0400
Message-ID: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
Subject: Need help with incremental backup strategy (snapshots, defragmentingt
 & performance)
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Our use case requires snapshots. btrfs snapshots are best solution we
have found for our requirements, and over the last year snapshots have
proven their value to us.

(For this discussion I am considering both the "root" volume and the
"home" volume on a typical desktop workstation. Also, all btfs volumes
are mounted with noatime and nodiratime flags.)

For performance reasons, I now wish to minimize the number of
snapshots retained on the live btrfs volume.

However, for backup purposes, I wish to maximize the number of
snapshots retained over time. We'll keep yearly, monthly, weekly,
daily and hourly snapshots for as long as possible.

To reconcile those conflicting goals, the only idea I have come up
with so far is to use btrfs send-receive to perform incremental
backups as described here:
https://btrfs.wiki.kernel.org/index.php/Incremental_Backup .

Given the hourly snapshots, incremental backups are the only practical
option. They take mere moments. Full backups could take an hour or
more, which won't work with hourly backups.

We will delete most snapshots on the live volume, but retain many (or
all) snapshots on the backup block device. Is that a good strategy,
given my goals?

The steps:

I know step one is to do the "bootstrapping" where a full initial copy
of the live volume is sent to the backup volume. I also know the steps
for doing incremental backups.

However, the first problem I see is that performing incremental
backups requires both the live volume and the backup volume to have an
identical "parent" snapshot before each new incremental can be sent. I
have found it easy to accidentally delete that specific required
parent snapshot when hourly snapshots are being taken and many
snaphots exist.

Given that I want to retain the minimum number of snapshots on the
live volume, how do I ensure that a valid "parent" subvolume exists
there in order to perform the incremental backup? (Again, I have often
run into the error "no valid parent exists" when doing incremental
backups.)

I think the rule is like this:

Do not delete a snapshot from the live volume until the next snapshot
based on it has been sent to the backup volume.

In other words, always retain the *exact* snapshot that was the last
one sent to the backup volume. Deleting that one then taking another
one does not seem sufficient. BTRFS does not seem to recognize
parent-child-grandchild relationships of snapshots when doing
send-receive incremental backups.

However, maybe I'm wrong. Would it be sufficient to first take another
snapshot, then delete the prior snapshot? Will the send-receive
algorithm be able to infer a parent exists on the backup volume when
it receives an incremental based on a child snapshot? (My experience
says "no", but I'd like a more authoritative answer.)

The next step in my proposed procedure is to take a new snapshot, send
it to the backup volume, and only then delete the prior snapshot ( and
only from the live volume* ).

Using this strategy, the live volume will always have the current
snapshot (which I guess should not be called a snapshot -- it's the
live volume) plus at least one more snapshot. Briefly, during the
incremental backup, it will have an additional snapshot until the
older one gets deleted.

Given this minimal retention of snapshots on the live volume, should I
defrag it (assuming there is at least 50% free space available on the
device)? (BTW, is defrag OK on an NVMe drive? or an SSD?)

In the above procedure, would I perform that defrag before or after
taking the snapshot? Or should I use autodefrag?

Should I consider a dedup tool like one of these?

    g2p/bedup: Btrfs deduplication
    https://github.com/g2p/bedup

    markfasheh/duperemove: Tools for deduping file systems
    https://github.com/markfasheh/duperemove

    Zygo/bees: Best-Effort Extent-Same, a btrfs dedup agent
    https://github.com/Zygo/bees

Does anyone care to elaborate on the relationship between a dedup tool
like Bees and defragmenting a btrfs filesystem with snapshots? I
understand they do opposing things, but I think it was suggested in
another thread on defragmenting that they can be combined to good
effect. Should I consider this as a possible solution for my
situation?

Should I consider any of these options: no-holes, skinny metadata, or
extended inode refs?

Finally, are there any good BTRFS performance wiki articles or blogs I
should refer to for my situation?

* Footnote: On the backup device, maybe we will never delete
snapshots. In any event, that's not a concern now. We'll retain many,
many snapshots on the backup device.
