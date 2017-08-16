Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:33054 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752382AbdHPXV4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 19:21:56 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:44294)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1di7dK-000469-Bp
        for linux-btrfs@vger.kernel.org; Thu, 17 Aug 2017 00:21:54 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1di7dG-0008KF-68
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 00:21:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22932.54157.816854.309537@tree.ty.sabi.co.uk>
Date: Thu, 17 Aug 2017 00:21:49 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: slow btrfs with a single kworker process using 100% CPU
In-Reply-To: <4669553.344.1502874134710.JavaMail.gkos@dynomob>
References: <eab2f725-ab6e-d2ac-30e1-d9c964ce8be8@profihost.ag>
        <4772c3f2-0074-d86f-24c4-02ff0730fce7@rqc.ru>
        <064eaaed-7748-7064-874e-19d270d0854e@profihost.ag>
        <4669553.344.1502874134710.JavaMail.gkos@dynomob>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> I've one system where a single kworker process is using 100%
>>> CPU sometimes a second process comes up with 100% CPU
>>> [btrfs-transacti]. [ ... ]

>> [ ... ]1413 Snapshots. I'm deleting 50 of them every night. But
>> btrfs-cleaner process isn't running / consuming CPU currently.

Reminder that:

https://btrfs.wiki.kernel.org/index.php/Gotchas#Having_many_subvolumes_can_be_very_slow

"The cost of several operations, including currently balance, device
delete and fs resize, is proportional to the number of subvolumes,
including snapshots, and (slightly super-linearly) the number of
extents in the subvolumes."

>> [ ... ] btrfs is mounted with compress-force=zlib

> Could be similar issue as what I had recently, with the RAID5 and
> 256kb chunk size. please provide more information about your RAID
> setup.

It is similar, but updating in-place compressed files can create
this situation even without RAID5 RMW:

https://btrfs.wiki.kernel.org/index.php/Gotchas#Fragmentation

"Files with a lot of random writes can become heavily fragmented
(10000+ extents) causing thrashing on HDDs and excessive multi-second
spikes of CPU load on systems with an SSD or large amount a RAM. ...
Symptoms include btrfs-transacti and btrfs-endio-wri taking up a lot
of CPU time (in spikes, possibly triggered by syncs)."
