Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:35054 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753774AbdD1TnW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 15:43:22 -0400
Received: by mail-yw0-f174.google.com with SMTP id u70so35890431ywe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 12:43:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22787.32757.987921.605023@tree.ty.sabi.co.uk>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
 <22787.32757.987921.605023@tree.ty.sabi.co.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 28 Apr 2017 13:43:21 -0600
Message-ID: <CAJCQCtT5PVTb3+YLQPYD8Ti2g-KYrDGSmvDBU=EaD0y8e4Ox=Q@mail.gmail.com>
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
To: Peter Grandi <pg@btrfs.list.sabi.co.uk>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 28, 2017 at 11:46 AM, Peter Grandi <pg@btrfs.list.sabi.co.uk> wrote:

> So there are three layers of silliness here:
>
> * Writing large files slowly to a COW filesystem and
>   snapshotting it frequently.
> * A filesystem that does delayed allocation instead of
>   allocate-ahead, and does not have psychic code.
> * Working around that by using no-COW and preallocation
>   with a fixed size regardless of snapshot frequency.
>
> The primary problem here is that there is no way to have slow
> small writes and frequent snapshots without generating small
> extents: if a file is written at a rate of 1MiB/hour and gets
> snapshot every hour the extent size will not be larger than 1MiB
> *obviously*.

Sure.

But in my example, no snapshotting, and +C is inhibited (i.e. I set
/etc/tmpfiles.d/journal-nocow.conf which stops systemd from the new
behavior of setting +C on journals). That's resulting in a 19000+
fragment journal file. In fact snapshotting does not make it worse
though. If it's nocow, then yes snapshotting makes it worse than
nocow, but no worse than cow.

What I'm trying to get at is default Btrfs behavior and (previous)
default journald behavior, have a misalignment resulting in a lot of
fragmentation, is there a better way around this than merely setting
journals to nocow *and* making sure they stay nocow by preventing
snapshotting. If there's nothing better to be done, then I'll just
re-recommend to systemd folks that the directory containing journals
should be made a subvolume to isolate it from inadvertent
snapshotting. If people want to snapshot it anyway there's nothing we
can do about that.



> Filesystem-level snapshots are not designed to snapshot slowly
> growing files, but to snapshots changing collections of
> files. There are harsh tradeoffs involved. Application-level
> shapshots (also known as log rotations :->) are needed for
> special cases and finer grained policies.
>
> The secondary problem is that a fixed preallocate of 8MiB is
> good only if in betweeen snapshots the file grows by a little
> less than 8MiB or by substantially more.

Just to be clear, none of my own examples involve journals being
snapshot. There are no shared extents for any of those files.

-- 
Chris Murphy
