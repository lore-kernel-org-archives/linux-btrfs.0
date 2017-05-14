Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:38769 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759050AbdENRiz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 13:38:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 573ED907
        for <linux-btrfs@vger.kernel.org>; Sun, 14 May 2017 13:38:54 -0400 (EDT)
Message-Id: <1494783532.2704393.976191096.6E0F2721@webmail.messagingengine.com>
From: Luis de Bethencourt <luis@other.computer>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: btrfs fi usage crash when multiple device volume contains seed device
Date: Sun, 14 May 2017 10:38:52 -0700
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Chris Murphy suggested we move the discussion in this bugzilla thread:
https://bugzilla.kernel.org/show_bug.cgi?id=115851

To here, the mailing list.

Going to quote him to give context:
"This might be better discussed on list to ensure there's congruence in
dev and user expectations; and in particular I think this needs a design
that accounts for the realistic long term goal, so that a short term
scope doesn't interfere or make the long term more difficult.

The matrix of possibilities, most of which are not yet implemented in
btrfs-progs:

1. 1 dev seed -> 1 dev sprout
2. 2+ dev seed -> 1 dev sprout
3. 1 dev seed -> 2+ dev sprout
4. 2+ dev seed -> 2+ dev sprout

Near as I can tell 2, 3, 4 are not implemented. It's an immediate
problem whether and how the profile (single, raid0, raid1) is to be
inherited from seed to sprout. If I have a 4 disk raid1 volume, to
create a sprout must I add a minimum of two devices? Or is it valid to
have raid1 profile seed chunks, where writes to go single profile sprout
chunks? Anyway point is, it needs a design to answer these things.

Next, and even more importantly as it applies to the simple case of
single to single, the way we do this right now is beyond confusing
because the remount ro to rw changes the volume UUID being mounted. The
ro mount is the seed, the rw mount is the sprout. This is not really a
remount, it's a umount of the seed, and a mount of the sprout. But what
if there's more than one sprout? This is asking for trouble so I think
the remount rw should be disallowed making it clear the ro seed cannot
be mounted rw. Instead it's necessary to umount it and explicitly mount
the rw sprout, and which sprout.

Also part of the ambiguity is that 'btrfs dev add' is more like
mkfs.btrfs in the context of seed-sprout. The new device isn't really
added to the seed, because the seed is read only. What's really
happening is a mkfs.btrfs with a "backing device" which is the seed; in
some sense it has more in common with the mkfs.btrfs --rootdir option. 

So I even wonder if 'btrfs dev add' is appropriate for creating sprouts,
and if instead it should be in mkfs.btfs with a --seed option to specify
the backing seed, and thereby what we are making is a sprout, which has
a new UUID, and possibly different chunk profiles than the seed."

Thanks,
Luis
