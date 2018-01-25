Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33774 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751702AbeAYLO0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 06:14:26 -0500
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs readdir fix for 4.15
Date: Thu, 25 Jan 2018 12:12:01 +0100
Message-Id: <cover.1516878041.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please consider pulling the fix to 4.15. It's been reported recently
that readdir can list stale entries under some conditions. As it is a
user visible bug I'd like to get it fix despite we're in the late rc.
Thanks.

The following changes since commit ec35e48b286959991cdbb886f1bdeda4575c80b4:

  btrfs: fix refcount_t usage when deleting btrfs_delayed_nodes (2018-01-02 18:00:14 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.15-tag

for you to fetch changes up to e4fd493c0541d36953f7b9d3bfced67a1321792f:

  Btrfs: fix stale entries in readdir (2018-01-24 20:27:48 +0100)

----------------------------------------------------------------
Josef Bacik (1):
      Btrfs: fix stale entries in readdir

 fs/btrfs/delayed-inode.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)
