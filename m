Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbbJKSFR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 14:05:17 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL][PATCH 0/7] Updates in message printers and formatters
Date: Sun, 11 Oct 2015 20:04:08 +0200
Message-Id: <cover.1444585955.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this was inspired by recent Anand's post to change the printing format of the
btrfs_err etc. helpers to include UUID. We do not use the helpers everywhere,
so I've introduced all the missing variants that require eg printing the
rcu_string (device name), are ratelimited or are both ratelimited and using
rcu_string.

First part introduces macros and switches existing users, the patch 7/7 converts
some printks to the helpers (avoiding mostly debugging messages).

In the end we should route all user-visile messages through some common
formatter, this is preparatory work. The mount-time messages are still
printk-based.

Please consider for the 4.4 dev cycle. Thanks.

----------------------------------------------------------------

The following changes since commit 9ffecb10283508260936b96022d4ee43a7798b4c:

  Linux 4.3-rc3 (2015-09-27 07:50:08 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanup/messages

for you to fetch changes up to f14d104dbdb5044dac9acd0e983ffb60f706c746:

  btrfs: switch more printks to our helpers (2015-10-08 13:08:03 +0200)

----------------------------------------------------------------
David Sterba (7):
      btrfs: introduce _in_rcu variants of message printing functions
      btrfs: switch message printers to _in_rcu variants
      btrfs: introduce ratelimited _in_rcu variants of message printing functions
      btrfs: switch message printers to ratelimited _in_rcu variants
      btrfs: introduce ratelimited variants of message printing functions
      btrfs: switch message printers to ratelimited variants
      btrfs: switch more printks to our helpers

 fs/btrfs/check-integrity.c  |  4 +--
 fs/btrfs/ctree.h            | 88 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dev-replace.c      | 16 ++++-----
 fs/btrfs/disk-io.c          | 37 ++++++++++---------
 fs/btrfs/extent-tree.c      | 14 ++++----
 fs/btrfs/extent_io.c        | 26 +++++++-------
 fs/btrfs/free-space-cache.c | 10 +++---
 fs/btrfs/inode.c            |  7 ++--
 fs/btrfs/ioctl.c            |  8 ++---
 fs/btrfs/root-tree.c        |  5 +--
 fs/btrfs/scrub.c            | 42 +++++++++++-----------
 fs/btrfs/send.c             |  2 +-
 fs/btrfs/volumes.c          | 25 ++++++-------
 13 files changed, 187 insertions(+), 97 deletions(-)
