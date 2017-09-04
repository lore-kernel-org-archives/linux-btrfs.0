Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:36252 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753932AbdIDSYD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 14:24:03 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:39532)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1dow2T-0004CJ-PH
        for linux-btrfs@vger.kernel.org; Mon, 04 Sep 2017 19:24:01 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dow2M-0007Mc-Su
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Sep 2017 19:23:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22957.39482.437159.954917@tree.ty.sabi.co.uk>
Date: Mon, 4 Sep 2017 19:23:54 +0100
To: linux-btrfs@vger.kernel.org
Subject: Re: speed up big btrfs volumes with ssds
In-Reply-To: <CAGqmi7537YtkTLfkk8tUoA5Zn9SMvUoGicg+R_4Nm6LupALEow@mail.gmail.com>
References: <7318d2b7-73a0-1cc9-f9cc-e03314c19e85@profihost.ag>
        <CAPmG0jaJFUpgAbtzNO2jnqbN7u7q6RM4T_BPw_hwhx2wS+Fnhg@mail.gmail.com>
        <e43a6dea-0e4c-50e4-da0d-03ac3ab9a97f@profihost.ag>
        <CAGqmi7537YtkTLfkk8tUoA5Zn9SMvUoGicg+R_4Nm6LupALEow@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> [ ... ] Currently without any ssds i get the best speed with:
>>> - 4x HW Raid 5 with 1GB controller memory of 4TB 3,5" devices
>>> and using btrfs as raid 0 for data and metadata on top of
>>> those 4 raid 5. [ ... ] the write speed is not as good as i
>>> would like - especially for random 8k-16k I/O. [ ... ]

> [ ... ] 64kb data stripe and 16kb parity Btrfs raid0 use 64kb
> as stripe so that can make data access unaligned (or use single
> profile for btrfs) 3. Use btrfs ssd_spread to decrease RMW
> cycles.

This is not a "revolutionary" scientific discovery as the idea of
a working set of a small-size random-write workload, but it still
takes a lot of "optimism" to imagine that it is possible to
"decrease RMW cycles" for "random 8k-16k" writes on 64KiB+16KiB
RAID5 stripes, whether with 'ssd_spread' or not.

To "decrease RMW cycles" seems inded to me the better aim than
following the "radical" aim of caching the working set of a
random-small-write workload, but it may be less easy to achieve
than desirable :-). http://www.baarf.dk/
