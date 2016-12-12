Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:36020 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbcLLEGp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 23:06:45 -0500
Received: by mail-yw0-f193.google.com with SMTP id r204so6774664ywb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 20:06:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADph71xdM4A2zd0ACmm4GNVp=Jwdp7935q9ur8bkha4+PmVSHg@mail.gmail.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
 <CAJCQCtTC5T0v6jZpALTPwn=CvWn-kJXZX2vVFAEjjk9xokqoPQ@mail.gmail.com>
 <CADph71wae2AQT-v-hu0YcJdNE+dWxRZ7yQVmMEMLyhzsC-FHqQ@mail.gmail.com>
 <CAJCQCtT5CG4M4nYmmefEfWjapmg3TpMXJSVmTE89r6iPxV6xHw@mail.gmail.com>
 <CADph71zoOB72o2PoUY_qqMsg_TpvBokugR9UzZHo6kPsNm4PNg@mail.gmail.com>
 <CAJCQCtQLRRaAyCa8DBHmcizcLHTajmp_vzGU7MkEvshtO4bbNQ@mail.gmail.com>
 <CADph71yACvRhb6AWixoaR28+VHZeaGmZqawqY3MSBcSeJM=6Qw@mail.gmail.com>
 <CAJCQCtT1y+j2d9x907CZaT+g-21nQ1MkC1gR9eJdZ5xPRuPAng@mail.gmail.com> <CADph71xdM4A2zd0ACmm4GNVp=Jwdp7935q9ur8bkha4+PmVSHg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Dec 2016 21:06:43 -0700
Message-ID: <CAJCQCtS=91WcH2s91DUG+RBv=kSKHrVF61Cn124EKskavTQMQg@mail.gmail.com>
Subject: Re: btrfs-find-root duration?
To: Markus Binsteiner <makkus@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't know, maybe. This is not a new file system, clearly, it has
half million+ generations.

backup_roots[4]:
    backup 0:
        backup_tree_root:    29360128    gen: 593817    level: 1
        backup_chunk_root:    20971520    gen: 591139    level: 1
        backup_extent_root:    29376512    gen: 593817    level: 1
        backup_fs_root:        132562944    gen: 593815    level: 0
        backup_dev_root:    29409280    gen: 593817    level: 0
        backup_csum_root:    29491200    gen: 593817    level: 0
        backup_total_bytes:    254007050240
        backup_bytes_used:    43532288
        backup_num_devices:    1


    backup 1:
        backup_tree_root:    138821632    gen: 593818    level: 0
        backup_chunk_root:    21020672    gen: 593818    level: 0
        backup_extent_root:    138805248    gen: 593818    level: 0
        backup_fs_root:        132562944    gen: 593815    level: 0
        backup_dev_root:    132841472    gen: 593818    level: 0
        backup_csum_root:    138870784    gen: 593818    level: 0
        backup_total_bytes:    254007050240
        backup_bytes_used:    655360
        backup_num_devices:    1


The old chunk root and tree root might come in handy, from backup0,
which is the generation prior to the one currently set in the super
blocks. The bytes_used vs dev_item.bytes_used is also interesting,
huge difference. So it looks like this was umounted very soon after
you realized what you did.

What do you get for

btrfs restore -l <dev>

Maybe just try this, which is the oldest generation we know about
right now, which is found in backup root 2.

sudo btrfs restore -D -v -t 138788864 /dev/mapper/brick1 .

That's a dry run so the path to save stuff to doesn't matter, so I'm
just using . for that. But what you'll get is a file listing. If
there's nothing listed, then it's a dead end. But if it's listing
everything you want, it's a win. Just point to a proper destination
and remove -D. However, another possibility is that it's a partial -
i.e. it might be a generation in between the cleaner running, so some
stuff is restored but not all of it.

Yeah, maybe there's a way to get an older generation and root with an
older copy of btrfs-progs. I think the current one isn't working very
well...on yet another file system I have that is very new (week) but
has hours of writes on it,

[chris@f25s ~]$ sudo btrfs-find-root /dev/mapper/brick1
Superblock thinks the generation is 5727
Superblock thinks the level is 1
Found tree root at 426847567872 gen 5727 level 1


That's it. So no hang, but only one tree root which is just bogus.
Even the superblock has more information than this. I'm used to seeing
dozens or more.


Chris Murphy
