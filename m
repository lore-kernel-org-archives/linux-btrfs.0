Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759756AbdAIMOg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Jan 2017 07:14:36 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs tracepoint updates for 4.10
Date: Mon,  9 Jan 2017 13:14:14 +0100
Message-Id: <cover.1483963803.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've selected a handful of tracepoint fixes and updates. The fixes a crash when
tracepoints are enabled so this can be considered urgent, the others are minor
harmless improvements. The qgroup tracepoint update is not included as it
depends on other patches so it'll possibly go later or with the rest of the
qgroup patches.

The following changes since commit 2939e1a86f758b55cdba73e29397dd3d94df13bc:

  btrfs: limit async_work allocation and worker func duration (2016-12-13 11:01:30 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tracepoint-updates-4.10

for you to fetch changes up to 562a7a07bf61e2949f7cbdb6ac7537ad9e2794d1:

  btrfs: make tracepoint format strings more compact (2017-01-09 11:27:07 +0100)

----------------------------------------------------------------
David Sterba (2):
      btrfs: fix crash when tracepoint arguments are freed by wq callbacks
      btrfs: make tracepoint format strings more compact

Liu Bo (2):
      Btrfs: add 'inode' for extent map tracepoint
      Btrfs: add truncated_len for ordered extent tracepoints

 fs/btrfs/async-thread.c      |  15 +++--
 fs/btrfs/inode.c             |   2 +-
 include/trace/events/btrfs.h | 146 +++++++++++++++++++++++--------------------
 3 files changed, 91 insertions(+), 72 deletions(-)
