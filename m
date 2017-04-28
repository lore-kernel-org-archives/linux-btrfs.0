Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f175.google.com ([209.85.213.175]:34251 "EHLO
        mail-yb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165814AbdD1QQH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 12:16:07 -0400
Received: by mail-yb0-f175.google.com with SMTP id 8so16621591ybw.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 09:16:07 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 28 Apr 2017 10:16:00 -0600
Message-ID: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
Subject: btrfs, journald logs, fragmentation, and fallocate
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Old news is that systemd-journald journals end up pretty heavily
fragmented on Btrfs due to COW. While journald uses chattr +C on
journal files now, COW still happens if the subvolume the journal is
in gets snapshot. e.g. a week old system.journal has 19000+ extents.

The news is I started a systemd thread.

This is the start:
https://lists.freedesktop.org/archives/systemd-devel/2017-April/038724.html

Where it gets interesting, two messages by Andrei Borzenkov: He
evaluates existing code and does some tests on ext4 and XFS.
https://lists.freedesktop.org/archives/systemd-devel/2017-April/038724.html
https://lists.freedesktop.org/archives/systemd-devel/2017-April/038728.html

And then the question.
https://lists.freedesktop.org/archives/systemd-devel/2017-April/038735.html

Given what journald is doing, is what Btrfs is doing expected? Is
there something it could do better to be more like ext4 and XFS in the
same situation? Or is it out of scope for Btrfs?

It appears to me (see below URLs pointing to example journals) that
journald fallocated in 8MiB increments but then ends up doing 4KiB
writes; there's a lot of these unused (unwritten) 8MiB extents that
appear in both filefrag and btrfs-debug -f outputs.

The +C idea just rearranges the deck chairs, it's not solving the
underlying problem except in the case where the containing subvolume
is never snapshot. And in the COW case, I'm seeing about 30 metadata
nodes being written out for what amounts to less than a 4KiB journal
append. Each time.

And that makes me wonder whether metadata fragmentation is happening
as a result. But in any case, there's a lot of metadata being written
for each journal update compared to what's being added to the journal
file.

And then that makes me wonder if a better optimization on Btrfs would
be having each write be a separate file. The small updates would have
data inline. Which is worse, a single file with 20000 fragments; or
40000 separate journal files? *shrug* At least those individual files
would be subject to compression with +c; whereas right now the open
endedness of the active journal has not a single compressed extent.
Only once rotated do they get compressed (via defragmentation which
journald does only on Btrfs). Journals contain highly compressible
data.



Anyway, two example journals. The parent directory has chattr +c, both
journals inherited it. The first URL is filefrag -v, the 2nd is
btrfs-debug -f; for each journal.

This is a rotated journal. Upon rotation on Btrfs, journald
defragments the file which ends up compressing it when chattr +c.
https://da.gd/4NKyq
https://da.gd/zEeYW

This is an active system.journal. No compressed extents (the writes I
think are too small).
https://da.gd/cBjX
https://da.gd/YXuI


Extra credit if you've followed this far... The rotated log has piles
of unwritten items in it that are making it fairly inefficient even
with compression. Just using cat to write its contents to a new file,
compression goes from a 1.27 ratio, to 5.70. Here are the results
after catting that file:
https://da.gd/rE8KT
https://da.gd/PD5qI



-- 
Chris Murphy
