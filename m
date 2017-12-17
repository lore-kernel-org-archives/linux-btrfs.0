Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:35930 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751926AbdLQPs2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Dec 2017 10:48:28 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:59074)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89_1)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1eQbAw-00088L-8m
        for linux-btrfs@vger.kernel.org; Sun, 17 Dec 2017 15:48:26 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1eQbAq-0002X0-Uh
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Dec 2017 15:48:21 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23094.37316.66397.431081@tree.ty.sabi.co.uk>
Date: Sun, 17 Dec 2017 15:48:20 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
In-Reply-To: <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
References: <5A357909.8010206@yandex.ru>
        <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"Duncan"'s reply is slightly optimistic in parts, so some
further information...

[ ... ]

> Basically, at this point btrfs doesn't have "dynamic" device
> handling.  That is, if a device disappears, it doesn't know
> it.

That's just the consequence of what is a completely broken
conceptual model: the current way most multi-device profiles are
designed is that block-devices and only be "added" or "removed",
and cannot be "broken"/"missing". Therefore if IO fails, that is
just one IO failing, not the entire block-device going away.
The time when a block-device is noticed as sort-of missing is
when it is not available for "add"-ing at start.

Put another way, the multi-device design is/was based on the
demented idea that block-devices that are missing are/should be
"remove"d, so that a 2-device volume with a 'raid1' profile
becomes a 1-device volume with a 'single'/'dup' profile, and not
a 2-device volume with a missing block-device and an incomplete
'raid1' profile, even if things have been awkwardly moving in
that direction in recent years.

Note the above is not totally accurate today because various
hacks have been introduced to work around the various issues.

> Thus, if a device disappears, to get it back you really have
> to reboot, or at least unload/reload the btrfs kernel module,
> in ordered to clear the stale device state and have btrfs
> rescan and reassociate devices with the matching filesystems.

IIRC that is not quite accurate: a "missing" device can be
nowadays "replace"d (by "devid") or "remove"d, the latter
possibly implying profile changes:

  https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Using_add_and_delete

Terrible tricks like this also work:

  https://www.spinics.net/lists/linux-btrfs/msg48394.html

> Meanwhile, as mentioned above, there's active work on proper
> dynamic btrfs device tracking and management. It may or may
> not be ready for 4.16, but once it goes in, btrfs should
> properly detect a device going away and react accordingly,

I haven't seen that, but I doubt that it is the radical redesign
of the multi-device layer of Btrfs that is needed to give it
operational semantics similar to those of MD RAID, and that I
have vaguely described previously.

> and it should detect a device coming back as a different
> device too.

That is disagreeable because of poor terminology: I guess that
what was intended that it should be able to detect a previous
member block-device becoming available again as a different
device inode, which currently is very dangerous in some vital
situations.

> Longer term, there's further patches that will provide a
> hot-spare functionality, automatically bringing in a device
> pre-configured as a hot- spare if a device disappears, but
> that of course requires that btrfs properly recognize devices
> disappearing and coming back first, so one thing at a time.

That would be trivial if the complete redesign of block-device
states of the Btrfs multi-device layer happened, adding an
"active" flag to an "accessible" flag to describe new member
states, for example.

My guess that while logically consistent, the current
multi-device logic is fundamentally broken from an operational
point of view, and needs a complete replacement instead of
fixes.
