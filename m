Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:45835 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaKVTwg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 14:52:36 -0500
Received: by mail-yk0-f180.google.com with SMTP id 9so3186902ykp.39
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Nov 2014 11:52:35 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 22 Nov 2014 12:52:35 -0700
Message-ID: <CAJCQCtRPa9fBmvBRt+RLbGy8iSUKq1_=2oZuioTKSaWAieBihQ@mail.gmail.com>
Subject: Volume/subvolume UUID uniqueness, was: BTRFS messes up snapshot LV
 with origin
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't know how to fix this but I've convinced myself there's at
least a small problem. And not just with LVM snapshots as in the
originating thread.

- Via seed device method of creating a Btrfs volume, the resulting
volume gets a new UUID. The volume UUID from the seed device doesn't
pass through, is not inherited / copied. Therefore there's already
recognition that snapshotting a Btrfs volume, which is what volume
creation from a seed device effectively is, should result in the new
volume getting a new UUID.

Therefore it seems reasonable a mechanism to support new volume UUIDs
upon LVM snapshots being taken is needed. Maybe leveraging existing
seed code can help, consider existing volume data a virtual seed
device, and the remaining free space as a virtual added device to
enable changing volume UUID rather than rewriting possibly piles of
UUIDs.


- While the seed device method of creating a Btrfs volume results in a
new volume UUID, subvolume UUIDs from the seed pass through to the new
volume. Since I can create many new volumes from one seed device, in
effect I'm creating many instances of subvolumes with identical UUIDs
and can now no longer be differentiated, locally and remotely. This
seems to be a much bigger problem than the LVM case, since it occurs
with only Btrfs tools being used.

The grandiose idea of UUIDs is persistence in identifying a specific
object/resource for all time, anywhere in the universe. Reducing this
to something practical, it should enable a way to identify an object
or resource within one or two human lifetimes, within our solar
system. Yet the current implementation has broken this on a much
shorter time scale, on a single computer.

Since we recognize subvolume snapshots should get new subvolume UUIDs,
and volume snapshots via seed device method creation of new volumes
get new volume UUIDs; a volume snapshot of course is also snapshotting
the subvolumes too, so the subvolume UUIDs can't pass through the way
they do right now. It's not correct behavior.

Another matter is what to do with parent uuid and snapshot
relationship metadata in the new volume. Assume all subvolumes get new
UUIDs on the new volume, there are three potentials:
1. parent uuid is always blank, no relationships between subvolumes is preserved
2. parent uuid is the uuid of its identical "mirror" (the original) in
the seed device.
3. parent uuid is the new uuid of its relative parent on the current
new volume, preserving relationships between subvolumes and snapshots.

I think any of those three are better than UUID duplication (recycling
actually). Maybe I'm not thinking of a use case for preserving these
UUIDs but at the moment I think it's specious. We can't be attached to
specific UUIDs, the instant a subvolume is effectively snapshot by LVM
or Btrfs seed device, it's a unique object/resource, and should have
its own URN. Afterall by default these objects are read/write. Maybe
if by default they were readonly I could be convinced of the validity
of UUID preservation.


-- 
Chris Murphy
