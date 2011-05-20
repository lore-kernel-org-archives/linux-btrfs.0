From: Craig Johnson <crajohns@gmail.com>
Subject: btrfsck: couldn't open because of unsupported option features (8)
Date: Fri, 20 May 2011 08:08:16 -0500
Message-ID: <BANLkTimkczntdTaPYOGznnPp6xfA+=wNSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After upgrading from 2.6.39-rc7 to 2.6.39 this morning, I tried to
mount my 3 disk btrfs volume (no subvolumes, space caching enabled,
lzo compression) and received some parent transid errors (going back
to rc7 didn't help, though):

btrfs: disk space caching is enabled
parent transid verify failed on 6038227976192 wanted 337418 found 337853
parent transid verify failed on 6038227976192 wanted 337418 found 337853
parent transid verify failed on 6038227976192 wanted 337418 found 337853
parent transid verify failed on 6038227976192 wanted 337418 found 337853
parent transid verify failed on 6038227976192 wanted 337418 found 337853
Failed to read block groups: -5
btrfs: open_ctree failed

Tried to mount without space_cache give the same message.

Trying to run btrfsck (or btrfs-debug-tree), compiled from git gives me this:


couldn't open because of unsupported option features (8).
btrfsck: disk-io.c:683: open_ctree_fd: Assertion `!(1)' failed.
Aborted


I see an Ubuntu bug (748340 -
https://bugs.launchpad.net/ubuntu/+source/btrfs-tools/+bug/748340)
with a similar output (they get an unsupported option features (2)
instead of (8)), but there isn't any resolution that I see.  Is there
anything I can do to resolve this?  I can't mount degraded or ro or
anything.  Thanks!
