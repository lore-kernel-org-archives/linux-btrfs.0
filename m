Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40010 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbaAAUPI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jan 2014 15:15:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VySBz-0001kq-R2
	for linux-btrfs@vger.kernel.org; Wed, 01 Jan 2014 21:15:03 +0100
Received: from 80-121-61-38.adsl.highway.telekom.at ([80.121.61.38])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 21:15:03 +0100
Received: from sulla by 80-121-61-38.adsl.highway.telekom.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 21:15:03 +0100
To: linux-btrfs@vger.kernel.org
From: Sulla <sulla@gmx.at>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Date: Wed, 1 Jan 2014 20:08:21 +0000 (UTC)
Message-ID: <loom.20140101T204832-543@post.gmane.org>
References: <52C2AE7C.5020601@gmx.at> <pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Duncan!

Thanks very much for your exhaustive answer.

Hm, I also thought of fragmentation. Alhtough I don't think this is really
very likely, as my server doesn't serve things that likely cause fragmentation.
It is a mailserver (but only maildir-format), fileserver for windows clients
(huge files that hardly don't get rewritten), a server for TV-records (but
only copy recordings from a sat receiver after they have been recorded, so
no heavy rewriting here), a tiny webserver and all kinds of such things, but
not a storage for huge databases, virtual machines or a target for
filesharing clients.
It however serves as a target for a hardlink-based backupprogram run on
windows PCs, but only once per month or so, so that shouldn't bee too much.

The problem must lie somewhere on the root partition itslef, because the
system is already slow before mounting the fat data-partitions.

I'll give the defragmentation a try. But
# sudo btrfs filesystem defrag -r
doesn't work, because "-r" is an unknown option (I'm running 
Btrfs v0.20-rc1 on an Ubuntu 3.11.0-14-generic kernel).

I'm doing a
# sudo btrfs filesystem defrag / &
on the root directory at the moment.

Question: will this defragment everything or just the root-fs and will I
need to run a defragment on /home as well, as /home is a separate btrfs
filesystem?

I've also added autodefrag mountoptions and will do a "mount -a" after the
defragmentation.

I've considered a
# sudo btrfs balance start
as well, would this do any good? How close should I let the data fill the
partition? The large data partitions are 85% used, root is 70% used. Is this
safe or should I add space?

Thanx, Wolfgang

