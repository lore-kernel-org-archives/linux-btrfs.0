Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34778 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbeAUVqA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 16:46:00 -0500
Received: by mail-oi0-f44.google.com with SMTP id k15so2021729oib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jan 2018 13:45:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPE0SYzT42vq-pRYctKohr42yK0E+T1sWJv2KPLxp5Cv1z7yqg@mail.gmail.com>
References: <CAPE0SYzT42vq-pRYctKohr42yK0E+T1sWJv2KPLxp5Cv1z7yqg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 21 Jan 2018 14:45:57 -0700
Message-ID: <CAJCQCtRpGXD03BTm+yO+SQduwtEeKAonW8bHpqCaYAWz0z_XiA@mail.gmail.com>
Subject: Re: Damaged Root Tree(s)
To: Liwei <xieliwei@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 21, 2018 at 12:16 PM, Liwei <xieliwei@gmail.com> wrote:
> Hi list,
>
> ====TLDR====
> 1. Can I mount a filesystem using one of the roots found with btrfs-find-root?

Not necessarily because more than just the tree root needs to be
readable to do a mount.

But decent chance it's possible to do an offline scrape using one of
those root trees with btrfs restore.


>
> ====Background Information====
>     I have a 2x10TB raid0 (20TB, raid0 provided by md) volume that (my
> theory is) experienced a headcrash while updating the root tree, or
> maybe while it was carrying out background defragmentation.
>
>     This occurred while I was setting up redundancy by using LVM
> mirroring, so in the logs you'll see some dm errors. Unfortunately the
> lost data has not been mirrored yet (what are the chances, given that
> the mirror was 97% complete when this happened).
>
>     Running a scrub on the raid shows that I have 1000+ unreadable
> sectors, amounting to about 800kB of data. So I've got spare drives
> and imaged the offending drive. Currently ddrescue is still trying to
> read those sectors, but it seems unlikely that they'll ever succeed.

Bad luck. What's the metadata profile? Single or DUP?


>
>     Next I ran btrfs-find-root, which gave me the following:
> Superblock thinks the generation is 318593
> Superblock thinks the level is 1
> Well block 25826479144960(gen: 318346 level: 1) seems good, but
> generation/level doesn't match, want gen: 318593 level: 1


That there's a big gap in generation between what's wanted and what's
found, a bunch of those more recent trees must be colocated and are
probably missing.

Anyway I think it's best to look at restore, and my limited experience
it tends to be more successful when restoring from snapshots



-- 
Chris Murphy
