Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:38169 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932120AbdAJRRc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 12:17:32 -0500
Received: by mail-it0-f49.google.com with SMTP id x2so93238833itf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 09:17:32 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 197sm1554981ita.14.2017.01.10.09.17.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Jan 2017 09:17:30 -0800 (PST)
Subject: Re: mkfs.btrfs/balance small-btrfs chunk size RFC
To: linux-btrfs@vger.kernel.org
References: <pan$cb31b$a126bd1f$577e9db8$38b890f5@cox.net>
 <db8aff8c-44a5-f488-56de-4a9ec87e44e0@gmail.com>
 <20170110152905.GJ19585@carfax.org.uk>
 <c934f74c-6dac-b66f-13cf-eb9bf0a79aac@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b120bcff-49fe-01c9-7852-e4a5f7528673@gmail.com>
Date: Tue, 10 Jan 2017 12:17:22 -0500
MIME-Version: 1.0
In-Reply-To: <c934f74c-6dac-b66f-13cf-eb9bf0a79aac@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-10 10:42, Austin S. Hemmelgarn wrote:
> Most of the issue in this case is with the size of the initial
> chunk. That said, I've got quite a few reasonably sized filesystems
> (I think the largest is 200GB) with moderate usage (max 90GB of
> data), and none of them are using more than the first 16kB block in
> the System chunk. While I'm not necessarily a typical user, I'd be
> willing to bet based on this that in general, most people who aren't
> storing very large amounts of data or taking huge numbers of
> snapshots aren't going to need a system chunk much bigger than 1MB.
> Perhaps making the initial system chunk 1MB for every GB of space
> (rounded up to a full MB) in the filesystem up to 16GB would be
> reasonable (and then keep the 16MB default for larger filesystems)?
I'm a bit bored, so I just ran the numbers on this.  The math assumes a
RAID1 profile system with 2 identically sized devices, and the total
sizes given are for usable space.

Given an entry size of 97 bytes (48 for the main record plus 17 for the
key, plus 32 for the second stripe), a 16kiB block can handle 675
entries, and (assuming that the entries can't cross a block boundary),
with a 16kiB node size, a 1MiB System chunk can hold 10800 entries.
Assuming a typical mixed usage filesystem with 1 metadata chunk for
every 5.5 data chunks (this is roughly the ratio I see on most of the
filesystems I've worked with), that gives about 561 data chunks and 102
metadata chunks for each 16kiB block in the System chunk, giving a total
FS size of 586.5GiB per 16kiB block in the System Chunk, or 37536GiB for
a 1MiB System chunk.  So, for a 16kiB node size and accounting for the
scaling in chunk sizes on large filesystems, a 1MiB System chunk can
easily handle a 10TB filesystem, and could probably handle a 35-40TB
filesystem provided it's kept in good condition (regular balancing and
such).  This overall means that provided ideal conditions with a 16kiB
node size, the default 32MB system chunk could easily handle a 1PB
filesystem without needing to allocate another System chunk.  The math
actually works out roughly the same for a 4kiB node size (it's at most a
few percent smaller, probably less than 1% difference).  This in turn
means that given the room for 14 system chunks, with the default system
chunk size, the practical max filesystem size is at least 14PB, and
likely not more than 60-70PB, just based on the number of possible extents.

Now, going a bit further, the theoretical max FS size based on
addressing constraints is (IIRC) something around 16EB (sum total of all
device sizes, actual usable space would be 8EB).  Assuming a worst case
usage scenario with only metadata chunks and no chunk scaling, that
requires 2199023255552 chunks.  To be able to handle that within the 14
System chunks we currently support, we would need each System chunk to
be more than 14TB, which leads to the interesting conclusion that our
addressing is actually much more grandiose than we could realistically
support (because the locking at that point is going to be absolute hell,
not because that's an unreasonable amount of metadata).

For those who care, this overall means that the idealized overhead of
the chunk tree relative to filesystem size is at worst 0.001% assuming
maximally efficient use of System chunks, and probably roughly 0.05% for
a realistic filesystem if the system chunk were exactly the size needed
to fit all the chunk entries in the FS.

Based on all of this, I would propose the following heuristic be used to
determine the size of each System chunk:
1. If the filesystem is less than 1GB accounting for replication
profiles, make the system chunk 256kiB. This gives a max size of more
than 0.5TB before a new System chunk is needed, and the likelihood of
someone expanding a filesystem that started at less than 1GB to be that
large is near enough to zero to be statistically impossible.  The 
practical max size using 256kiB System chunks would be around 8TB.
2. If the filesystem is less than 100GB accounting for replication
profiles, make the system chunk 1MiB.  This gives a roughly 35TB max
size before a new System chunk is needed, which is again well beyond
what's statistically reasonable. Practical max size for 1MiB would be 
about 490TB.
3. If the filesystem is less than 10TB accounting for replication
profiles, make the system chunk 16MiB.  This gives a roughly 560TB max
size before a new System chunk is needed, and roughly 8PB practical max 
size.
4. If the filesystem is less than 1PB accounting for replication
profiles, make the system chunk 256MiB.  This gives a rough max size of
something around 9PB before a new System chunk is needed, and roughly 
126PB max size.
5. Otherwise, use a 1GB system chunk.  That gives (for a single System
chunk) a realistic max size of at least 500PB, which is much larger
scale than anyone is likely to need on a single non-distributed
filesystem for the foreseeable future, and is probably far beyond the
point at which the locking requirements on the extent tree far outweigh
any other overhead.
6. Beyond this, add an option to override this selection heuristic and
specify an exact size for the initial system chunk (which should
probably be restricted to power-of-2 multiples of the node size, with a
minimum of the next size down from what would be selected automatically).

This also brings up a rather interesting secondary question which is 
currently functionally impossible to test without special work involved:
What error does userspace get when it does something which would create 
a chunk and it's not possible to create a new chunk because the chunk 
tree has hit max size, and what's logged by the kernel when this happens?
