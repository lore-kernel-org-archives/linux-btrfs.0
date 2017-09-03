Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:54922 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751287AbdICTcQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 Sep 2017 15:32:16 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:50218)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1doaNQ-0000S1-II
        for linux-btrfs@vger.kernel.org; Sun, 03 Sep 2017 20:16:12 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1doaNL-00073l-0q
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Sep 2017 20:16:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22956.21750.526687.370823@tree.ty.sabi.co.uk>
Date: Sun, 3 Sep 2017 20:16:06 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: speed up big btrfs volumes with ssds
In-Reply-To: <7318d2b7-73a0-1cc9-f9cc-e03314c19e85@profihost.ag>
References: <7318d2b7-73a0-1cc9-f9cc-e03314c19e85@profihost.ag>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] - needed volume size is 60TB

I wonder how long that takes to 'scrub', 'balance', 'check',
'subvolume delete', 'find', etc.

> [ ... ] 4x HW Raid 5 with 1GB controller memory of 4TB 3,5"
> devices and using btrfs as raid 0 for data and metadata on top
> of those 4 raid 5. [ ... ]  the write speed is not as good as
> i would like - especially for random 8k-16k I/O. [ ... ]

Also I noticed that the rain is wet and cold - especially if one
walks around for a few hours in a t-shirt, shorts and sandals.
:-)

> My current idea is to use a pcie flash card with bcache on top
> of each raid 5. Is this something which makes sense to speed
> up the write speed.

Well 'bcache' in the role of write buffer allegedly helps
turning unaligned writes into aligned writes, so might help, but
I wonder how effective that will be in this case, plus it won't
turn low random IOPS-per-TB 4TB devices into high ones. Anyhow
if they are battery-backed the 1GB of HW HBA cache/buffer should
do exactly that, excep that again in this case that is rather
optimistic.

But this reminds me of the common story: "Doctor, if I stab
repeatedly my hand with a fork it hurts a lot, how to fix that?"
"Don't do it".
:-)

PS Random writes of 8-16KiB over 60TB might seem like storing
small records/images in small files. That would be "brave".
On a 60TB RAID50 of 20x 4TB disk drives that might mean around
5-10MB/s of random small writes, including both data and
metadata.
