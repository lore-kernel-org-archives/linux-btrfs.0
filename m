Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:35186 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423598AbdD1Tze (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 15:55:34 -0400
Received: by mail-yb0-f174.google.com with SMTP id p143so17959428yba.2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 12:55:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22787.33181.491103.496790@tree.ty.sabi.co.uk>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
 <22787.33181.491103.496790@tree.ty.sabi.co.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 28 Apr 2017 13:55:32 -0600
Message-ID: <CAJCQCtRt4kr6We5wB7eLbN-9mdXyfy7QMwAqs15J5biyyc+KYg@mail.gmail.com>
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
To: Peter Grandi <pg@btrfs.list.sabi.co.uk>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 28, 2017 at 11:53 AM, Peter Grandi <pg@btrfs.list.sabi.co.uk> wrote:

> Well, depends, but probably the single file: it is more likely
> that the 20,000 fragments will actually be contiguous, and that
> there will be less metadata IO than for 40,000 separate journal
> files.

You can see from the examples I posted that these extents are all over
the place, they're not contiguous at all. 4K here, 4K there, 4K over
there, back to 4K here next to this one, 4K over there...12K over
there, 500K unwritten, 4K over there. This seems not so consequential
on SSD, at least if it impacts performance it's not so bad I care. On
a hard drive, it's totally noticeable. And that's why journald went
with chattr +C by default a few versions ago when on Btrfs. And it
does help *if* the partent is never snapshot, which on a snapshotting
file system can't really be guaranteed. Inadvertent snapshotting could
be inhibited by putting the journals in their own subvolume though.

Anyway, it's difficult to consider Btrfs a general purpose file system
if other general purpose workloads like journal files, are causing a
problem like wandering tree. Hence the subject of what to do about it,
and that may mean short term and long term. I can't speak for systemd
developers but if there's a different way to write to the journals
that'd be better for Btrfs and no worse for ext4 and XFS, it might be
considered.


-- 
Chris Murphy
