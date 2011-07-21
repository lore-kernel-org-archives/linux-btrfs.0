From: Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 0/7] btrfs: don't BUG_ON btrfs_alloc_path errors v2
Date: Thu, 21 Jul 2011 12:48:26 -0700
Message-ID: <1311277713-7747-1-git-send-email-mfasheh@suse.com>
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Changelog:
  - Updated patch 6 after review from Tsutomu Itoh

Hi,

	The following patches attempt to replace all the paths where we
BUG_ON the return value of btrfs_alloc_path with proper error handling. It's
pretty clear that these places aren't BUGing because of code error. To be
explicit, much of the code is doing something like this:

	path = btrfs_alloc_path();
	BUG_ON(!path);

which can be fixed by sending -ENOMEM back up the stack instead of the BUG.

	The first patch in my series fixes the most trivial sites in one go.
The patches after the 1st fix one (more complicated) site each. In the patch
descriptions I try my best to describe the thought process that went behind
each change.

	Generally my guiding principle is that we want to "bubble up" some
of the BUG_ON's that can be trapped and handled at a higher level -- the lower
layer has an error and instead of killing the machine, sends it back up the
stack for later handling

	I tested the patches with some kernel builds and snapshot commands.
Please review - comments and feedback are welcome.

The patches can also be had from git:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/btrfs-error-handling.git alloc_path
	--Mark

