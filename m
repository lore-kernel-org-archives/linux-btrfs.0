Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:51520 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752489AbdCaLhR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 07:37:17 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:57232)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cturj-0039d8-B3
        for linux-btrfs@vger.kernel.org; Fri, 31 Mar 2017 12:37:15 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cture-0006W6-9f
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 12:37:10 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22750.16229.909821.2740@tree.ty.sabi.co.uk>
Date: Fri, 31 Mar 2017 12:37:09 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Shrinking a device - performance?
In-Reply-To: <CAP8EXU2ufgLWL+kgKtaLjqHDBGV1OB8GWy+efCJf4Knb0DaEPQ@mail.gmail.com>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <b0f6b00e-4c70-72d1-8683-c05bb72a0968@siedziba.pl>
        <22749.11946.474065.536986@tree.ty.sabi.co.uk>
        <67132222-17c3-b198-70c1-c3ae0c1cb8e7@siedziba.pl>
        <CAP8EXU2ufgLWL+kgKtaLjqHDBGV1OB8GWy+efCJf4Knb0DaEPQ@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Can you try to first dedup the btrfs volume?  This is probably
> out of date, but you could try one of these: [ ... ] Yep,
> that's probably a lot of work. [ ... ] My recollection is that
> btrfs handles deduplication differently than zfs, but both of
> them can be very, very slow

But the big deal there is that dedup is indeed a very expensive
operation, even worse than 'balance'. A balanced, deduped volume
will shrink faster in most cases, but the time taken simply
moved from shrinking to preparing.

> Again, I'm not an expert in btrfs, but in most cases a full
> balance and scrub takes care of any problems on the root
> partition, but that is a relatively small partition.  A full
> balance (without the options) and scrub on 20 TiB must take a
> very long time even with robust hardware, would it not?

There have been reports of several months for volumes of that
size subject to ordinary workload.

> CentOS, Redhat, and Oracle seem to take the position that very
> large data subvolumes using btrfs should work fine.

This is a long standing controvery, and for example there have
been "interesting" debates in the XFS mailing list. Btrfs in
this is not really different from others, with one major
difference in context, that many Btrfs developers work for a
company that relies of large numbers of small servers, to the
point that fixing multidevice issues has not been a priority.

The controversy of large volumes is that while no doubt the
logical structures of recent filesystem types can support single
volumes of many petabytes (or even much larger), and such
volumes have indeed been created and "work"-ish, so they are
unquestionably "syntactically valid", the tradeoffs involved
especially as to maintainability may mean that they don't "work"
well and sustainably so.

The fundamental issue is metadata: while the logical structures,
using 48-64 bit pointers, unquestionably scale "syntactically",
they don't scale pragmatically when considering whole-volume
maintenance like checking, repair, balancing, scrubbing,
indexing (which includes making incremental backups etc.).

Note: large volumes don't have just a speed problem for
whole-volume operations, they also have a memory problem, as
most tools hold in memory copy of the metadata. There have been
cases where indexing or repair of a volume requires a lot more
RAM (many hundreds GiB or some TiB of RAM) than the system on
which the volume was being used.

The problem is of course smaller if the large volume contains
mostly large files, and bigger if the volume is stored on low
IOPS-per-TB devices and used on small-memory systems. But even
with large files even if filetree object metadata (inodes etc.)
are relatively few eventually space metadata must at least
potentially resolve down to single sectors, and that can be a
lot of metadata unless both used and free space are very
unfragmented.

The fundamental technological issue is: *data* IO rates, in both
random IOPS and sequential ones, can be scaled "almost" linearly
by parallelizing them using RAID or equivalent, allowing large
volumes to serve scalably large and parallel *data* workloads,
but *metadata* IO rates cannot be easily parallelized, because
metadata structures are graphs, not arrays of bytes like files.

So a large volume on 100 storage devices can serve in parallel a
significant percentage of 100 times the data workload of a small
volume on 1 storage device, but not so much for the metadata
workload.

For example, I have never seen a parallel 'fsck' tool that can
take advantage of 100 storage devices to complete a scan of a
single volume on 100 storage devices in not much longer time
than the scan of a volume on 1 of the storage device.

> But I would be curious what the rest of the list thinks about
> 20 TiB in one volume/subvolume.

Personally I think that while volumes of many petabytes "work"
syntactically, there are serious maintainability problem (which
I have seen happen at a number of sites) with volumes larger
than 4TB-8TB with any current local filesystem design.

That depends also on number/size of storage devices, and their
nature, that is IOPS, as after all metadata workloads do scale a
bit with number of available IOPS, even if far more slowly than
data workloads.

For for example I think that an 8TB volume is not desirable on a
single 8TB disk for ordinary workloads (but then I think that
disks above 1-2TB are just not suitable for ordinary filesystem
workloads), but with lots of smaller/faster disks a 12TB volume
would probably be acceptable, and maybe a number of flash SSDs
might make acceptable even a 20TB volume.

Of course there are lots of people who know better. :-)
