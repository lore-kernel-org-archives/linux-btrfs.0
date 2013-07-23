Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1658 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3GWPzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 11:55:01 -0400
From: Rick van Rein <rick@vanrein.org>
Content-Type: text/plain; charset=us-ascii
Date: Tue, 23 Jul 2013 17:47:22 +0200
Subject: Manual deduplication would be useful
To: linux-btrfs@vger.kernel.org
Message-Id: <3DF45F2F-A56D-4302-AB84-31A6A3084A39@vanrein.org>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

For over a year now, I've been experimenting with stacked filesystems as a way to save on resources.  A basic OS layer is shared among Containers, each of which stacks a layer with modifications on top of it.  This approach means that Containers share buffer cache and loaded executables.  Concrete technology choices aside, the result is rock-solid and the efficiency improvements are incredible, as documented here:

http://rickywiki.vanrein.org/doku.php?id=openvz-aufs

One problem with this setup is updating software.  In lieu of stacking-support in package managers, it is necessary to do this on a per-Container basis, meaning that each installs their own versions, including overwrites of the basic OS layer.  Deduplication could remedy this, but the generic mechanism is known from ZFS to be fairly inefficient.

Interestingly however, this particular use case demonstrates that a much simpler deduplication mechanism than normally considered could be useful.  It would suffice if the filesystem could check on manual hints, or stack-specifying hints, to see if overlaid files share the same file contents; when they do, deduplication could commence.  This saves searching through the entire filesystem for every file or block written.  It might also mean that the actual stacking is not needed, but instead a basic OS could be cloned to form a new basic install, and kept around for this hint processing.

I'm not sure if this should ideally be implemented inside the stacking approach (where it would be stacking-implementation-specific) or in the filesystem (for which it might be too far off the main purpose) but I thought it wouldn't hurt to start a discussion on it, given that (1) filesystems nowadays service multiple instances, (2) filesystems like Btrfs are based on COW, and (3) deduplication is a goal but the generic mechanism could use some efficiency improvements.

I hope having seen this approach is useful to you!

Please reply-all?  I'm not on this list.

Cheers,
 -Rick