Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:42393 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751153AbdCCAti (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Mar 2017 19:49:38 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:52492)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cjbOK-0040vY-JW
        for linux-btrfs@vger.kernel.org; Fri, 03 Mar 2017 00:48:16 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cjbNq-000638-OJ
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Mar 2017 00:47:46 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22712.48434.400550.346157@tree.ty.sabi.co.uk>
Date: Fri, 3 Mar 2017 00:47:46 +0000
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
In-Reply-To: <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
        <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] Meanwhile, the problem as I understand it is that at
> the first raid1 degraded writable mount, no single-mode chunks
> exist, but without the second device, they are created.  [
> ... ]

That does not make any sense, unless there is a fundamental
mistake in the design of the 'raid1' profile, which this and
other situations make me think is a possibility: that the
category of "mirrored" 'raid1' chunk does not exist in the Btrfs
chunk manager. That is, a chunk is either 'raid1' if it has a
mirror, or if has no mirror it must be 'single'.

If a member device of a 'raid1' profile multidevice volume
disappears there will be "unmirrored" 'raid1' profile chunks and
some code path must recognize them as such, but the logic of the
code does not allow their creation. Question: how does the code
know that a specific 'raid1' chunk is mirrored or not? The chunk
must have a link (member, offset) to its mirror, do they?

What makes me think that "unmirrored" 'raid1' profile chunks are
"not a thing" is that it is impossible to remove explicitly a
member device from a 'raid1' profile volume: first one has to
'convert' to 'single', and then  the 'remove' copies back to the
remaining devices the 'single' chunks that are on the explicitly
'remove'd device. Which to me seems absurd.

Going further in my speculation, I suspect that at the core of
the Btrfs multidevice design there is a persistent "confusion"
(to use en euphemism) between volumes having a profile, and
merely chunks have a profile.

My additional guess that the original design concept had
multidevice volumes to be merely containers for chunks of
whichever mixed profiles, so a subvolume could have 'raid1'
profile metadata and 'raid0' profile data, and another could
have 'raid10' profile metadata and data, but since handling this
turned out to be too hard, this was compromised into volumes
having all metadata chunks to have the same profile and all data
of the same profile, which requires special-case handling of
corner cases, like volumes being converted or missing member
devices.

So in the case of 'raid1', a volume with say a 'raid1' data
profile should have all-'raid1' and fully mirrored profile
chunks, and the lack of a member devices fails that aim in two
ways.
