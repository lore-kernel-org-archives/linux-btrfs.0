Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:47348 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751620AbdJROHv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 10:07:51 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:60334)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e4p0f-0003yL-7u
        for linux-btrfs@vger.kernel.org; Wed, 18 Oct 2017 15:07:49 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e4ozw-0007OY-So
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Oct 2017 15:07:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23015.24582.659282.346242@tree.ty.sabi.co.uk>
Date: Wed, 18 Oct 2017 15:07:02 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
In-Reply-To: <CAGtRCvdj6LXO8ou40u7B6KCKin6Wzh5FbayMX0-a9Y2fK_w8wg@mail.gmail.com>
References: <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
        <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
        <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
        <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
        <20171017011443.bupcsskm7joc73wb@angband.pl>
        <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
        <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
        <81e1136a-a846-9531-b1bf-9ad2aabb785d@gmail.com>
        <20171017170626.amfrohfyqlujdueu@angband.pl>
        <1d5e9875-1c1e-f67e-1f5b-0741555d9517@gmail.com>
        <20171017202135.xdop4eko6utircmz@angband.pl>
        <CAGtRCvdj6LXO8ou40u7B6KCKin6Wzh5FbayMX0-a9Y2fK_w8wg@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] After all, btrfs would just have to discard one copy
> of each chunk. [ ... ]  One more thing that is not clear to me
> is the replication profile of a volume. I see that balance can
> convert chunks between profiles, for example from single to
> raid1, but I don't see how the default profile for new chunks
> can be set or quiered. [ ... ]

My impression is that the design rationale and aims for Btrfs
two-level allocation (in other fields known as a "BIBOP" scheme)
were not fully shared among Btrfs developers, that perhaps it
could have benefited from some further reflection on its
implications, and that its behaviour may have evolved
"opportunistically", maybe without much worrying as to
conceptual integrity. (I am trying to be euphemistic)

So while I am happy with the "Rodeh" core of Btrfs (COW,
sbuvolumes, checksums), the RAID-profile functionality and
especially the multi-device layer is not something I find
particularly to my taste. (I am trying to be euphemistic)

So when it comes to allocation, RAID-profiles, multiple devices,
I usually expect some random "surprising functionality". (I am
trying to be euphemistic)
