Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:35834 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754187AbdASSe1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 13:34:27 -0500
Date: Thu, 19 Jan 2017 23:23:40 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Alejandro R. Mosteo" <alejandro@mosteo.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: dup vs raid1 in single disk
Message-ID: <20170119232340.64327c09@natsu>
In-Reply-To: <CACNDjuw3GqkCggUqim==Y+xj=bnL93wwdx26denvQaD4tFf7yw@mail.gmail.com>
References: <CACNDjuzntG5Saq5HHNeDUmq-=28riKAerkO=CD=zAW-QofbKSg@mail.gmail.com>
        <CACNDjuw3GqkCggUqim==Y+xj=bnL93wwdx26denvQaD4tFf7yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 19 Jan 2017 17:39:37 +0100
"Alejandro R. Mosteo" <alejandro@mosteo.com> wrote:

> I was wondering, from a point of view of data safety, if there is any
> difference between using dup or making a raid1 from two partitions in
> the same disk. This is thinking on having some protection against the
> typical aging HDD that starts to have bad sectors.

RAID1 will write slower compared to DUP, as any optimization to make RAID1
devices work in parallel will cause a total performance disaster for you as
you will start trying to write to both partitions at the same time, turning
all linear writes into random ones, which are about two orders of magnitude
slower than linear on spinning hard drives. DUP shouldn't have this issue, but
still it will be twice slower than single, since you are writing everything
twice.

You could consider DUP data for when a disk is already known to be getting bad
sectors from time to time -- but then it's a fringe exercise to try and keep
using such disk in the first place. Yeah with DUP data DUP metadata you can
likely have some more life out of such disk as a throwaway storage space for
non-essential data, at half capacity, but is it worth the effort, as it's
likely to start failing progressively worse over time.

In all other cases the performance and storage space penalty of DUP within a
single device are way too great (and gained redundancy is too low) compared
to a proper system of single profile data + backups, or a RAID5/6 system (not
Btrfs-based) + backups.

> On a related note, I see this caveat about dup in the manpage:
> 
> "For example, a SSD drive can remap the blocks internally to a single
> copy thus deduplicating them. This negates the purpose of increased
> redunancy (sic) and just wastes space"

That ability is vastly overestimated in the man page. There is no miracle
content-addressable storage system working at 500 MB/sec speeds all within a
little cheap controller on SSDs. Likely most of what it can do, is just
compress simple stuff, such as runs of zeroes or other repeating byte
sequences.

And the DUP mode is still useful on SSDs, for cases when one copy of the DUP
gets corrupted in-flight due to a bad controller or RAM or cable, you could
then restore that block from its good-CRC DUP copy.

-- 
With respect,
Roman
