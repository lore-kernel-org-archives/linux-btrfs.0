Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:52975 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755413AbdD1Rxr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 13:53:47 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:58722)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1d4A5R-0017WD-PN
        for linux-btrfs@vger.kernel.org; Fri, 28 Apr 2017 18:53:45 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1d49yQ-00042C-Ao
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 18:46:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22787.32757.987921.605023@tree.ty.sabi.co.uk>
Date: Fri, 28 Apr 2017 18:46:29 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
In-Reply-To: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Old news is that systemd-journald journals end up pretty
> heavily fragmented on Btrfs due to COW.

This has been discussed before in detail indeeed here, but also
here: http://www.sabi.co.uk/blog/15-one.html?150203#150203

> While journald uses chattr +C on journal files now, COW still
> happens if the subvolume the journal is in gets snapshot. e.g.
> a week old system.journal has 19000+ extents. [ ... ]  It
> appears to me (see below URLs pointing to example journals)
> that journald fallocated in 8MiB increments but then ends up
> doing 4KiB writes; [ ... ]

So there are three layers of silliness here:

* Writing large files slowly to a COW filesystem and
  snapshotting it frequently.
* A filesystem that does delayed allocation instead of
  allocate-ahead, and does not have psychic code.
* Working around that by using no-COW and preallocation
  with a fixed size regardless of snapshot frequency.

The primary problem here is that there is no way to have slow
small writes and frequent snapshots without generating small
extents: if a file is written at a rate of 1MiB/hour and gets
snapshot every hour the extent size will not be larger than 1MiB
*obviously*.

Filesystem-level snapshots are not designed to snapshot slowly
growing files, but to snapshots changing collections of
files. There are harsh tradeoffs involved. Application-level
shapshots (also known as log rotations :->) are needed for
special cases and finer grained policies.

The secondary problem is that a fixed preallocate of 8MiB is
good only if in betweeen snapshots the file grows by a little
less than 8MiB or by substantially more.
