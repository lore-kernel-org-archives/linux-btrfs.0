Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:54282 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S939913AbdD1XE4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 19:04:56 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:61258)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1d4EwX-001G4t-W8
        for linux-btrfs@vger.kernel.org; Sat, 29 Apr 2017 00:04:54 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1d4EwT-0006In-LN
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Apr 2017 00:04:49 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22787.51857.303844.66350@tree.ty.sabi.co.uk>
Date: Sat, 29 Apr 2017 00:04:49 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
In-Reply-To: <CAJCQCtRt4kr6We5wB7eLbN-9mdXyfy7QMwAqs15J5biyyc+KYg@mail.gmail.com>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
        <22787.33181.491103.496790@tree.ty.sabi.co.uk>
        <CAJCQCtRt4kr6We5wB7eLbN-9mdXyfy7QMwAqs15J5biyyc+KYg@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> [ ... ] these extents are all over the place, they're not
> contiguous at all. 4K here, 4K there, 4K over there, back to
> 4K here next to this one, 4K over there...12K over there, 500K
> unwritten, 4K over there. This seems not so consequential on
> SSD, [ ... ]

Indeed there were recent reports that the 'ssd' mount option
causes that, IIRC by Hans van Kranenburg (around 2017-04-17),
which also noticed issues with the wandering trees in certain
situations (around 2017-04-08).
