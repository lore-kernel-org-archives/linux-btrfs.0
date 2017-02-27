Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:49329 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750971AbdB0Q7z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 11:59:55 -0500
Received: from 82-132-233-90.dab.02.net ([82.132.233.90]:11881 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1ciOeM-001GhX-22
        for linux-btrfs@vger.kernel.org; Mon, 27 Feb 2017 16:59:50 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1ciOeA-0002b7-N9
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Feb 2017 16:59:38 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22708.23290.349489.765780@tree.ty.sabi.co.uk>
Date: Mon, 27 Feb 2017 16:59:38 +0000
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Low IOOP Performance
In-Reply-To: <CAAafysGxU9vaEs6actqX3ZFGkoXFvPFUAC1SjwtkZ97uuuFgJg@mail.gmail.com>
References: <CAAafysGxU9vaEs6actqX3ZFGkoXFvPFUAC1SjwtkZ97uuuFgJg@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]
> a ten disk raid1 using 7.2k 3 TB SAS drives

Those are really low IOPS-per-TB devices, but good choice for
SAS, as they will have SCT/ERC.

> and used aio to test IOOP rates. I was surprised to measure
> 215 read and 72 write IOOPs on the clean new filesystem.

For that you really want to use the 'raid10' profile, 'raid1' is
quite different, and has an odd recovery "gotcha". Also so far
'raid1' in Btrfs only reads from one of the two mirrors per
thread.

Anyhow the 72 write IOPS look like single member device IOPS
rate and that's puzzling, as if Btrfs is not going
multithreading to a many-device 'raid1' profile volume.

I have a 6-device test setup at home and I tried various setups
and I think I got rather better than that.

> Sequential writes ran as expected at roughly 650 MB/s.

That's a bit too high: on single similar drive I get around
65MB/s average with relatively large files, I would expect
around 4-5x that from a 10-device mirrored profile, regardless
of filesystem type.

I strongly suspect that we have a different notion of "IOPS",
perhaps either logical vs. physical IOPS, or randomish vs.
sequentialish IOPS. I'll have a look at your attachments in more
detail.

> I created a zfs filesystem for comparison on another
> checksumming filesystem using the same layout and measured
> IOOP rates at 4315 read, 1449 write with sync enabled (without
> sync it's clearly just writing to RAM), sequential performance
> was comparable to btrfs.

It seems unlikely to me that you got that with a 10-device
mirror 'vdev', most likely you configured it as a stripe of 5x
2-device mirror vdevs, that is RAID10.
