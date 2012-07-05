Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49258 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2GEQvX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 12:51:23 -0400
Received: by pbbrp8 with SMTP id rp8so13040204pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jul 2012 09:51:23 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 Jul 2012 18:51:22 +0200
Message-ID: <CAB9VWqCnbd-Mqo6Po408uqhbbSyg=W4Huiqs61HLxc8=nkdQdQ@mail.gmail.com>
Subject: [RFC] Btrfs "sendshots" and hidden snapshots
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

in IRC we had a discussion on how we could solve sending live
subvolumes and how to send subvolumes without the need to
administrate/keep old snapshots for incremental sends. One of the
ideas was to introduce "sendshots", which are basically snapshots
where no refs are counted for file data. This means, that when file
data is changed in the sendshot origin, we do not consume extra space
for two copies of the data. We would only have the metadata
duplicated.

For the initial btrfs send we could do this:
1. Create a hidden read-only snapshot of the subvolume to send. Hidden
means that it's not referenced by any subvolume. It is however still a
normal snapshot (not a sendshot!). Hidden snapshots are not possible
atm so we would have to implement that. This step allows us to send
read-write subvolumes, because we have a freezed version of it.
2. Send this new snapshot.
3. When we're done with sending, create a "sendshot" from the snapshot
and delete the invisible snapshot. As an alternative, we could convert
the invisible snapshot to a sendshot...but not sure if that would be
easy to implement.

When we later do an incremental send we can do this:
1. Do the same as point 1. from above.
2. Determine which of the previous sendshots is the correct one for
the incremental send. We could use some magic auto detection here or
the user has to specify it by himself.
3. Use the hidden snapshot from 1. and the determined sendshot from 2.
to find the incremental changes and do the send.
4. Do the same as point 3. from above.

Every incremental send will add a new sendshot for later use. To avoid
having millions of such sendshots after some time, btrfs-progs would
need to delete old ones. That's something the user needs 100% control
of, as only he knows which ones can be deleted. He could either delete
them by hand or let btrfs send do that automatically with a parameter
that for example says how much sendshots to keep.

The above steps would already make the use of btrfs send/receive a bit
easier. The next step would be to implement a network protocol that
allows on-the-fly sending/receiving without piping to a file
in-between. The protocol would allow the sending and receiving side to
agree on the sendshot to use for the incremental send. It would also
allow the sending side to do all the sendshot cleanups on its own,
because it would know which state is present on the receiving side.

What do you guys think? Problem is, I probably won't be able to
implement this due to missing time for the rest of this year...going
on a world trip and I don't know when I'm back :)
So, if anyone wants too take this idea and implement it, feel free to do so :)

Alex.
