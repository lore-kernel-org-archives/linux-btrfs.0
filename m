Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:59694 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752296AbdCETzy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 5 Mar 2017 14:55:54 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:36206)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1ckcFa-001q1q-AU
        for linux-btrfs@vger.kernel.org; Sun, 05 Mar 2017 19:55:26 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1ckcFT-0001UU-2p
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Mar 2017 19:55:19 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22716.27942.718197.613308@tree.ty.sabi.co.uk>
Date: Sun, 5 Mar 2017 19:55:18 +0000
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
In-Reply-To: <22716.25419.146443.191478@tree.ty.sabi.co.uk>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
        <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
        <22712.48434.400550.346157@tree.ty.sabi.co.uk>
        <284e9d01-3e69-705e-dd88-ebe047e2e4b8@gmail.com>
        <22716.25419.146443.191478@tree.ty.sabi.co.uk>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... on the difference between number of devices and length of
a chunk-stripe ... ]

> Note: possibilities get even more interesting with a 4-device
> volume with 'raid1' profile chunks, and similar case involving
> other profiles than 'raid1'.

Consider for example a 4-device volume with 2 devices abruptly
missing: if 2-length 'raid1' chunk-stripes have been uniformly
laid across devices, then some chunk-stripes will be completely
missing (where both chunks in the stripe were on the 2 missing
devices), some will be 1-length, and some will be 2-length.

What to do when devices are missing?

One possibility is to simply require mount with the 'degraded'
option, by default read-only, but allowing read-write, simply as
a way to ensure the sysadm knows that some metada/data *may* not
be redundant or *may* even be unavailable (if the chunk-stripe
length is less than the minimum to reconstruct the data).

Then attempts to read unavailable metadata or data would return
an error like a checksum violation without redundancy,
dynamically (when the application or 'balance' or 'scrub'
attempt to read the unavailable data).
