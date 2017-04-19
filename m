Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58491 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1761567AbdDSKvQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 06:51:16 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PULL] Btrfs, qgroup message level adjustment, for 4.11-rc8
Date: Wed, 19 Apr 2017 12:51:03 +0200
Message-Id: <cover.1492598707.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a single-patch pull request, the qgroup use can trigger an underflow warning
frequently. The warning is for debugging and should not be in the final release
of 4.11 as we won't be able to fix it.

Qu had pointed that out some time ago but I didn't get to fixing it until now.
Please pull, thanks.

----------------------------------------------------------------

The following changes since commit a967efb30b3afa3d858edd6a17f544f9e9e46eea:

  Btrfs: fix potential use-after-free for cloned bio (2017-04-11 18:49:56 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.11-rc8

for you to fetch changes up to 338bd52f3c3a86a1feea8c9a121d1cee60d68d69:

  btrfs: qgroup: move noisy underflow warning to debugging build (2017-04-19 12:40:49 +0200)

----------------------------------------------------------------
David Sterba (1):
      btrfs: qgroup: move noisy underflow warning to debugging build

 fs/btrfs/qgroup.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)
