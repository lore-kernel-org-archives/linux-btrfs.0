Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:34960 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760569AbdACSQ6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 13:16:58 -0500
Received: by mail-yw0-f175.google.com with SMTP id v81so193197003ywb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jan 2017 10:16:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1e291178-2b84-f4e1-25c8-e4cbd37718ae@gmail.com>
References: <20161206043938.3249-1-anand.jain@oracle.com> <20161212171927.GY12522@twin.jikos.cz>
 <9799c1aa-e365-f05d-2b96-017edc67ec90@oracle.com> <CANznX5FsY==9svvhmRtAG=9_GE5PHYU34B3Hboq-A36GvTf+pg@mail.gmail.com>
 <9fdde3f9-e2ed-b3d3-a8ec-da6ae27dfe95@oracle.com> <CANznX5FPg60U252u-1VDJdb6x7j562bMMSCoRJXF4zTrsayy2Q@mail.gmail.com>
 <1e291178-2b84-f4e1-25c8-e4cbd37718ae@gmail.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Tue, 3 Jan 2017 19:16:41 +0100
Message-ID: <CANznX5Ed4GNCKcMGJBSwJ8dPik5z3y2fyYNdtk=ar9PKL9kJLA@mail.gmail.com>
Subject: Re: [PATCH] recursive defrag cleanup
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 3, 2017 at 5:01 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> I agree on this point.  I actually hadn't known that it didn't recurse into
> sub-volumes, and that's a pretty significant caveat that should be
> documented (and ideally fixed, defrag doesn't need to worry about
> cross-subvolume stuff because it breaks reflinks anyway).

I think it descends into subvolumes to picks up the files (data)
inside them. I was referring to picking up the "child" subvolumes
(trees) and defrag those (as if you fed all the subvolumes to a
non-recursive defrag one-by-one with the current implementation --- if
I understand this current implementation correctly*).

To keep it simple: the recursive mode (IMO) should not ignore any
entities which the defrag tool is able to meaningfully operate on (no
matter if these are file data, directory metadata or subvolume tree
metadata, etc --- if it can be fragmented and can be defraged by this
tool, it should be done during a recursive mode operation with no
exceptions --- unless you can and do set explicit exceptions). I think
only the subvolume and/or the directory (*) metadata are currently
ignored by the recursive mode (if anything).

* But you got me a little bit confused again. After reading the first
few emails in this thread I thought only files (data) and subvolumes
(tree metadata) can be defraged by this tool and it's a no-op for
regular directories. Yet you seem to imply it's possible to defrag
regular directories (the directory metadata), meaning defrag can
operate on 3 type of entities in total (file data, subvolume tree
metadata, regular directory metadata).

> For single directories, -t almost certainly has near zero effect since
> directories are entirely in metadata.  For single files, it should only have
> an effect if it's smaller than the size of the file (it probably is for your
> usage if you've got hour long video files).  As far as the behavior above
> 128MB, stuff like that is expected to a certain extent when you have highly
> fragmented free space (the FS has to hunt harder to find a large enough free
> area to place the extent).
>
> FWIW, unless you have insanely slow storage, 32MB is a reasonable target
> fragment size.  Fragmentation is mostly an issue with sequential reads, and
> usually by the time you're through processing that 32MB of data, your
> storage device will have the next 32MB ready.  The optimal value of course
> depends on many things, but 32-64MB is reasonable for most users who aren't
> streaming multiple files simultaneously off of a slow hard drive.

Yes, I know and it's not a problem to use <=32Mb. I just wondered why
>=128Mb seems to be so incredibly slow for me.
Well, actually, I also wondered if the defrag tool can "create" big
enough continuous free space chunks by relocating other (probably
small[ish]) files (including non-fragmented files) in order to make
room for huge fragmented files to be re-assembled there as continuous
files. I just didn't make the connection between these two questions.
I mean, defrag will obviously fail with huge target extent sizes and
huge fragmented files if the free space is fragmented (and why
wouldn't it be somewhat fragmented...? deleting fragmented files will
result in fragmented free space and new files will be fragmented if
free space is fragmented, so you will delete fragmented files once
again, and it goes on forever -> that was my nightmare with ZFS... it
feels like the FS can only become more and more fragmented over time
unless you keep a lot of free space [let's say >50%] all the time and
it still remains somewhat random).

Although, this brings up complications. A really extensive defrag
would require some sort of smart planning: building a map of objects
(including free space and continuous files), divining the best
possible target and trying to achieve that shape by heavy
reorganization of (meta/)data.

> Really use case specific question, but have you tried putting each set of
> files (one for each stream) in it's own sub-volume?  Your metadata
> performance is probably degrading from the sheer number of extents involved
> (assuming H.264 encoding and full HD video with DVD quality audio, you're
> probably looking at at least 1000 extents for each file, probably more), and
> splitting into a subvolume per-stream should segregate the metadata for each
> set of files, which should in turn help avoid stuff like lock contention
> (and may actually make both balance and defrag run faster).

Before I had a dedicated disk+filesystem for these files I did think
about creating a subvolume for all these video recordings rather than
keeping them in a simple directory under a big multi-disk filesystem's
root/default subvolume. (The decision to separate these files was
forced by an external scale-ability problem --- limited number of
connectors/slots for disks and limited "working" RAID options in Btrfs
--- rather than an explicit desire for segregation -> although in the
light of these issues it might came on it's own at some point by now)
but I didn't really see the point. On the contrary, I would think
segregation by subvolumes could only complicate things further. It can
only increase the total complexity if it does anything. The total
amount of metadata will be roughly the same or more but not less. You
just add more complexity to the basket (making it bigger in some
sense) by introducing subvolumes.

But if it could "serve the common good", I could certainly try as a test-case.

The file size tends to be anywhere between 200 and 2000 Megabytes and
I observed some heavy fragmentation, like ~2k extents per ~2Gb files,
thus 1Mb/extent sizes on average. I guess it also depends on the total
write cache load (some database-like loads often result in write cache
flushing-frenzies but other times I allow up to ~1Gb to be cached in
memory before the disk has to write anything, so the extent size could
build up to >32Mb --- if the allocator is smart enough and free space
fragments are big enough...).

> You also have to factor
> in that directories tend to have more sticking power than file blocks in the
> VFS cache, since they're (usually) used more frequently, so once you've read
> the directory the first time, it's almost certainly going to be completely
> in cache.

I tired to tune that in the past (to favor metadata even more than the
default behavior) but I ended up with OOMs.

> To put it in perspective, a directory with about 20-25 entries and all
> file/directory names less than 15 characters (roughly typical root
> directory, not counting the . and .. pseudo-entries) easily fits entirely in
> one metadata block on BTRFS with a 16k block size (the current default),
> with lots of room to spare.

I use 4k nodesize. I am not sure why I picked that (probably in order
to try minimizing locking contention which I might thought I had a
problem with, years ago).

> then you're talking small enough improvements that you won't notice unless
> you're constantly listing the directory and trashing the page cache at the
> same time.

Well, actually, I do. I already filed a request on ffmpeg's bug
tracker to ask for Direct-IO support because video recording with
ffmpeg constantly flushes my page cache (and it's not the only job of
this little home server).
