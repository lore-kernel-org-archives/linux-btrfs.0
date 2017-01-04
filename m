Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:33441 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934222AbdADWVZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jan 2017 17:21:25 -0500
Received: by mail-yw0-f172.google.com with SMTP id r204so327574433ywb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jan 2017 14:20:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e63a01d8-d47b-5e4a-795f-4a40e0b4854e@gmail.com>
References: <20161206043938.3249-1-anand.jain@oracle.com> <20161212171927.GY12522@twin.jikos.cz>
 <9799c1aa-e365-f05d-2b96-017edc67ec90@oracle.com> <CANznX5FsY==9svvhmRtAG=9_GE5PHYU34B3Hboq-A36GvTf+pg@mail.gmail.com>
 <9fdde3f9-e2ed-b3d3-a8ec-da6ae27dfe95@oracle.com> <CANznX5FPg60U252u-1VDJdb6x7j562bMMSCoRJXF4zTrsayy2Q@mail.gmail.com>
 <1e291178-2b84-f4e1-25c8-e4cbd37718ae@gmail.com> <CANznX5Ed4GNCKcMGJBSwJ8dPik5z3y2fyYNdtk=ar9PKL9kJLA@mail.gmail.com>
 <e63a01d8-d47b-5e4a-795f-4a40e0b4854e@gmail.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Wed, 4 Jan 2017 23:12:20 +0100
Message-ID: <CANznX5HPOR92p18jFcGbLuLAXnYGkr-z0FhSJ=GqX=7RbnTrbg@mail.gmail.com>
Subject: Re: [PATCH] recursive defrag cleanup
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I separated these 9 camera storages into 9 subvolumes (so now I have
10 subvols in total in this filesystem with the "root" subvol). It's
obviously way too early to talk about long term performance but now I
can tell that recursive defrag does NOT descend into "child"
subvolumes (it does not pick up the files located in these "child"
subvolumes when I point it to the "root" subvolume with the -r
option). That's very inconvenient (one might need to write a scrip
with a long static list of subvolumes and maintain it over time or
write a scrip which acquires the list from the subvolume list command
and feeds it to the defrag command one-by-one).

> Because each subvolume is functionally it's own tree, it has it's own
> locking for changes and other stuff, which means that splitting into
> subvolumes will usually help with concurrency.  A lot of high concurrency
> performance benchmarks do significantly better if you split things into
> individual subvolumes (and this drives a couple of the other kernel
> developers crazy to no end).  It's not well published, but this is actually
> the recommended usage if you can afford the complexity and don't need
> snapshots.

I am not a developer but this idea drives me crazy as well. I know
it's a silly reasoning but if you blindly extrapolate this idea you
come to the conclusion that every single file should be transparently
placed in it's own unique subvolume (by some automatic background
task) and every directory should automatically be a subvolume. I guess
there must be some inconveniently sub-optimal behavior in the tree
handling which could theoretically be optimized (or the observed
performance improvement of the subvolume segregation is some kind of
measurement error which does not really translate into actual real
life overall performance befit but only looks like that from some
specific perspective of the tests).

> As far as how much your buffering for write-back, that should depend
> entirely on how fast your RAM is relative to your storage device.  The
> smaller the gap between your storage and your RAM in terms of speed, the
> more you should be buffering (up to a point).  FWIW, I find that with
> DDR3-1600 RAM and a good (~540MB/s sequential write) SATA3 SSD, about
> 160-320MB gets a near ideal balance of performance, throughput, and
> fragmentation, but of course YMMV.

I don't think I share your logic on this. I usually consider the write
load random and I don't like my softwares possibly stalling while
there is plenty of RAM laying around to be used as a buffer until some
other tasks might stop trashing the disks (e.g. "bigger is always
better").

> Out of curiosity, just on this part, have you tried using cgroups to keep
> the memory usage isolated better?

No, I didn't even know cgroups can control the pagecache based on the
process which generates the cache-able IO.
To be honest, I don't think it's worth the effort for me (I would need
to learn how to use cgroups, I have zero experience with that).

> Also, if you can get ffmpeg to spit out the stream on stdout, you could pipe
> to dd and have that use Direct-IO.  The dd command should be something along
> the lines of:
> dd of=<filename> oflag=direct iflag=fullblock bs=<arbitrary large multiple
> of node-size>
> The oflag will force dd to open the output file with O_DIRECT, the iflag
> will force it to collect full blocks of data before writing them (the size
> is set by bs=, I'd recommend using a power of 2 that's a multiple of your
> node-size, larger numbers will increase latency but reduce fragmentation and
> improve throughput).  This may still use a significant amount of RAM (the
> pipe is essentially an in-memory buffer), and may crowd out other
> applications, but I have no idea how much it may or may not help.

This I can try (when I have no better things to play with). Thank you.
