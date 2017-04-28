Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:52974 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755430AbdD1Rxr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 13:53:47 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:58720)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1d4A5R-0017W8-7A
        for linux-btrfs@vger.kernel.org; Fri, 28 Apr 2017 18:53:45 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1d4A5F-000454-Qu
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 18:53:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22787.33181.491103.496790@tree.ty.sabi.co.uk>
Date: Fri, 28 Apr 2017 18:53:33 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
In-Reply-To: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] And that makes me wonder whether metadata
> fragmentation is happening as a result. But in any case,
> there's a lot of metadata being written for each journal
> update compared to what's being added to the journal file. [
> ... ]

That's the "wandering trees" problem in COW filesystems, and
manifestations of it in Btrfs have also been reported before.
If there is a workload that triggers a lot of "wandering trees"
updates, then a filesystem that has "wandering trees" perhaps
should not be used :-).

> [ ... ] worse, a single file with 20000 fragments; or 40000
> separate journal files? *shrug* [ ... ]

Well, depends, but probably the single file: it is more likely
that the 20,000 fragments will actually be contiguous, and that
there will be less metadata IO than for 40,000 separate journal
files.

The deeper "strategic" issue is that storage systems and
filesystems in particular have very anisotropic performance
envelopes, and mismatches between the envelopes of application
and filesystem can be very expensive:
  http://www.sabi.co.uk/blog/15-two.html?151023#151023
