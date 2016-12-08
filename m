Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53058 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752496AbcLHPL3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 10:11:29 -0500
Received: from mfilter36-d.gandi.net (mfilter36-d.gandi.net [217.70.178.167])
        by relay3-d.mail.gandi.net (Postfix) with ESMTP id 86982A815F
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Dec 2016 16:11:26 +0100 (CET)
Received: from relay3-d.mail.gandi.net ([IPv6:::ffff:217.70.183.195])
        by mfilter36-d.gandi.net (mfilter36-d.gandi.net [::ffff:10.0.15.180]) (amavisd-new, port 10024)
        with ESMTP id A4vwpcz7_JlE for <linux-btrfs@vger.kernel.org>;
        Thu,  8 Dec 2016 16:11:24 +0100 (CET)
Received: from [10.137.2.13] (port-mbouisso.univ-montp2.fr [162.38.105.117])
        (Authenticated sender: swami@petaramesh.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 32C17A80E5
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Dec 2016 16:11:23 +0100 (CET)
From: =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>
Subject: duperemove : some real world figures on BTRFS deduplication
To: linux-btrfs@vger.kernel.org
Message-ID: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
Date: Thu, 8 Dec 2016 16:11:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Some real world figures about running duperemove deduplication on
BTRFS :

I have an external 2,5", 5400 RPM, 1 TB HD, USB3, on which I store the
BTRFS backups (full rsync) of 5 PCs, using 2 different distros,
typically at the same update level, and all of them more of less sharing
the entirety or part of the same set of user files.

For each of these PCs I keep a series of 4-5 BTRFS subvolume snapshots
for having complete backups at different points in time.

The HD was full to 93% and made a good testbed for deduplicating.

So I ran duperemove on this HD, on a machine doing "only this", using a
hashfile. The machine being an Intel i5 with 6 GB of RAM.

Well, the damn thing has been running for 15 days uninterrupted !
...Until I [Ctrl]-C it this morning as I had to move with the machine (I
wasn't expecting it to last THAT long...).

It took about 48 hours just for calculating the files hashes.

Then it took another 48 hours just for "loading the hashes of duplicate
extents".

Then it took 11 days deduplicating until I killed it.

At the end, the disk that was 93% full is now 76% full, so I saved 17%
of 1 TB (170 GB) by deduplicating for 15 days.

Well the thing "works" and my disk isn't full anymore, so that's a very
partial success, but still l wonder if the gain is worth the effort...

Best regards.

ॐ

-- 
Swâmi Petaramesh <swami@petaramesh.org> PGP 9076E32E

