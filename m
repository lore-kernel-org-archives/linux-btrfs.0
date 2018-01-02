Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:47828 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752816AbeABNI7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jan 2018 08:08:59 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:60308)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89_1)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1eWMJN-0008SU-AW
        for linux-btrfs@vger.kernel.org; Tue, 02 Jan 2018 13:08:57 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1eWMJF-0007ul-Vs
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jan 2018 13:08:50 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23115.33889.91390.589211@tree.ty.sabi.co.uk>
Date: Tue, 2 Jan 2018 13:08:49 +0000
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs reserve metadata problem
In-Reply-To: <d74d1cc471fb12f8ea55cba36e82582b@synology.com>
References: <d74d1cc471fb12f8ea55cba36e82582b@synology.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> When testing Btrfs with fio 4k random write,

That's an exceptionally narrowly defined workload. Also it is
narrower than that, because it must be without 'fsync' after
each write, or else there would be no accumulation of dirty
blocks in memory at all.

> I found that volume with smaller free space available has
> lower performance.

That's an inappropriate use of "performance"... The speed may be
lower, the performance is another matter.

> It seems that the smaller the free space of volume is, the
> smaller amount of dirty page filesystem could have.

Is this a problem? Consider: all filesystems do less well when
there is less free space (smaller chance of finding spatially
compact allocations), it is usually good to minimize the the
amont of dirty pages anyhow (even if there are reasons to keep
delay writing them out).

> [ ... ] btrfs will reserve metadata for every write.  The
> amount to reserve is calculated as follows: nodesize *
> BTRFS_MAX_LEVEL(8) * 2, i.e., it reserves 256KB of metadata.
> The maximum amount of metadata reservation depends on size of
> metadata currently in used and free space within volume(free
> chunk size /16) When metadata reaches the limit, btrfs will
> need to flush the data to release the reservation.

I don't understand here: under POSIX semantics filesystems are
not really allowed to avoid flushing *metadata* to disk for most
operations, that is metadata operations have an implied 'fsync'.
Your case of the "4k random write" with "cow disabled" the only
metadata that should get updated is the last-modified timestamp,
unless the user/application has been so amazingly stupid to not
preallocate the file, and then they deserve whatever they get.

> 1. Is there any logic behind the value (free chunk size /16)

>   /*
>    * If we have dup, raid1 or raid10 then only half of the free
>    * space is actually useable. For raid56, the space info used
>    * doesn't include the parity drive, so we don't have to
>    * change the math
>    */
>   if (profile & (BTRFS_BLOCK_GROUP_DUP |
>           BTRFS_BLOCK_GROUP_RAID1 |
>           BTRFS_BLOCK_GROUP_RAID10))
>    avail >>= 1;

As written there is a plausible logic, but it is quite crude.

>   /*
>    * If we aren't flushing all things, let us overcommit up to
>    * 1/2th of the space. If we can flush, don't let us overcommit
>    * too much, let it overcommit up to 1/8 of the space.
>    */
>   if (flush == BTRFS_RESERVE_FLUSH_ALL)
>    avail >>= 3;
>   else
>    avail >>= 1;

Presumably overcommitting beings some benefits on other workloads.

In particular other parts of Btrfs don't behave awesomely well
when free space runs out.

> 2. Is there any way to improve this problem?

Again, is it a problem? More interestingly, if it is a problem
is a solution available that does not impact other workloads?
It is simply impossible to optimize a filesystem perfectly for
every workload.

I'll try to summarize your report as I understand it:

* If:
  - The workload is "4k random write" (without 'fsync').
  - On a "cow disabled" file.
  - The file is not preallocated.
  - There is not much free space available.
* Then allocation overcommitting results in a higher frequency
  of unrequested metadata flushes, and those metadata flushes
  slow down a specific benchmark.
