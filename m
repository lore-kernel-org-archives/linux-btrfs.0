Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:36602 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbbCOBaP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Mar 2015 21:30:15 -0400
Received: by wetk59 with SMTP id k59so15492851wet.3
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2015 18:30:13 -0700 (PDT)
Received: from [192.168.2.7] (ipbcc33db6.dynamic.kabel-deutschland.de. [188.195.61.182])
        by mx.google.com with ESMTPSA id fm10sm9092469wib.7.2015.03.14.18.30.12
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Mar 2015 18:30:13 -0700 (PDT)
Message-ID: <5504E0A3.3040908@gmail.com>
Date: Sun, 15 Mar 2015 02:30:11 +0100
From: Sven Witterstein <sven.witterstein@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Raid10 performance issues during copy and balance, only half
 the spindles used for reading data
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

thank you for that explanation

> The existing algorithm is a very simple even/odd PID-based algorithm.
> Thus, single-thread testing will indeed always read from the same side of
> the pair-mirror (since btrfs raid1 and raid10 are pair-mirrored, no N-way-
> mirroring available yet, tho it's the next new feature on the raid roadmap
> now that raid56 is essentially code-complete altho not yet well bug-
> flushed, with 3.19).  With a reasonably balanced mix of even/odd-PID
> readers, however, you should indeed get reasonable balanced read activity.

OK, that is really no good design for production:
eveness/oddity of PIDs is not related (not a good criterion to predict) to what PIDs
will request I/O from the pool at a given time.

In Raid10 (N0.. to come) probably all read requests from all PIDs need to be queued and
spread across the available number of redundant stripesets
(or simple mirrors, if the "striped mirrors" layout 1+0 à la zfs is used or were possible)
Would apply for pure-ssd pool as well, though some fancy "near/far/seek time"
considerations are obsoleted
Something like that...

Probably an option-parameter in analogy to (single-spindle pre-ssd ideas for the I/O scheduler) like

elevator=cfq
(for btrfs="try to balance reads between devices by common read queue" resp "max out all resources and distribute fairly to requesting apps")
(optimum for large reads (and parallel several of them such as balance / send/receive/copy/tar with the pool and the same time to external backup...)

elevator=noop (assign by even/odd, current behavior (testing)

elevator=jumpy (e.g. assign a read to the stripeset which has the smallest number of other reads on it, every rand x
secs switch stripeset if number of "customers" on other 1..N redundant stripesets has decreased
(similar to core switching of a long-running process in kernel)
(optimised for smaller r/w operations such as many users accessing a central server)
etc..

would bring room to experiment in the years till 2020 as you outlined and to review,
whether mdadms raid10 near/far/offset should be considered when most future storage will be non-rotary...
Some kind of self-optimzing should also be included, i.e. if the filesystem new,
how much is to be read, it could know if it made sense to try different methods
and find the fastest, such as gparteds' block size adapting...
Again, it would be interessting if the impact on non-rotary storage would be insignificant

In my use case it's a simple rsync or cp -a or nemo/nautilus
copying between zfs and btrfs pools. Those are single-threaded I guess
and I understand in btrfs there is not such a ton of z_read - processess that
probably account for the "flying" zfs-reads on 6disk raidz2 or 3x2 or 2x3
vdev layout compared to btrfs reads.


I still find it strange, that also a balance also only uses half the spindles,
but it is explainable when the same logic is used as for any other reading from
the array. At least the scrub reads all data and not only one copy ;-)

Interesting enough, all my other btrfses are single-SSD for operating system with auto-snap to be able to revert...
and one is a 2-disk raid 0 for throw away data, so I never had a setup that would expose this behaviour...

Goodbye,

Sven.

