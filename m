From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 00/99] Error handling patchset v6
Date: Wed, 23 Nov 2011 19:35:33 -0500
Message-ID: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Here's my current error handling patchset, against Chris's current
for-linus branch.

As before, it's almost all in preparation for actual error handling.
After a chat with Chris last week about some of the bits I thought
might be contentious, I went ahead with the next step and converted
struct extent_state allocations to use a mempool in front of the slab
cache it was using already. This means that non-atomic callers can't
catch an -ENOMEM and that means that non-atomic version of
{set,clear,convert}_extent_bit can return void.  This changes the
previous patch set quite a bit since the {set,clear,convert}_extent_bit
error push-up patches are now entirely obsolete.

The run down:
- extent_state allocations -> mempool
- delayed_ref allocations -> mempool
- a ton of int -> void changes
- add btrfs_panic
- a few cleanups where I ran into them

-Jeff

