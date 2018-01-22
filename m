Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:46185 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750890AbeAVDbV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 22:31:21 -0500
Received: by mail-lf0-f48.google.com with SMTP id q194so8812949lfe.13
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jan 2018 19:31:20 -0800 (PST)
MIME-Version: 1.0
From: Liwei <xieliwei@gmail.com>
Date: Mon, 22 Jan 2018 11:30:58 +0800
Message-ID: <CAPE0SYw9Z0fx9O6sc3NhRTU5yfQhdghUs6kQcF2KMdn0JG2-xg@mail.gmail.com>
Subject: Re: Damaged Root Tree(s)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

> On Sun, Jan 21, 2018 at 12:16 PM, Liwei <xieli...@gmail.com> wrote:
> > Hi list,
> >
> > ====TLDR====
> > 1. Can I mount a filesystem using one of the roots found with btrfs-find-root?
>
> Not necessarily because more than just the tree root needs to be
> readable to do a mount.
>
> But decent chance it's possible to do an offline scrape using one of
> those root trees with btrfs restore.
>

Its starting to look like that, I'll probably have to send a separate
email troubleshooting that, as there seems to be some errors occurring
even with the best root I've found.

>
> >
> > ====Background Information====
> >     I have a 2x10TB raid0 (20TB, raid0 provided by md) volume that (my
> > theory is) experienced a headcrash while updating the root tree, or
> > maybe while it was carrying out background defragmentation.
> >
> >     This occurred while I was setting up redundancy by using LVM
> > mirroring, so in the logs you'll see some dm errors. Unfortunately the
> > lost data has not been mirrored yet (what are the chances, given that
> > the mirror was 97% complete when this happened).
> >
> >     Running a scrub on the raid shows that I have 1000+ unreadable
> > sectors, amounting to about 800kB of data. So I've got spare drives
> > and imaged the offending drive. Currently ddrescue is still trying to
> > read those sectors, but it seems unlikely that they'll ever succeed.
>
> Bad luck. What's the metadata profile? Single or DUP?


Metadata profile is DUP, but it seems like there is only one
up-to-date tree root at any time?

>
>
> >
> >     Next I ran btrfs-find-root, which gave me the following:
> > Superblock thinks the generation is 318593
> > Superblock thinks the level is 1
> > Well block 25826479144960(gen: 318346 level: 1) seems good, but
> > generation/level doesn't match, want gen: 318593 level: 1
>
>
> That there's a big gap in generation between what's wanted and what's
> found, a bunch of those more recent trees must be colocated and are
> probably missing.

I thought so too. Is there a reason why they ended up being colocated?
I'm surprised with all the redundancies btrfs is capable of, this can
happen. Was it because the volume was starting to become full? (This
whole exercise of turning on mirroring was because we're migrating to
bigger disks)

>
> Anyway I think it's best to look at restore, and my limited experience
> it tends to be more successful when restoring from snapshots

Seems like that's the way forward indeed.
