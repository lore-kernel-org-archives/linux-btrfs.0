Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:48023 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab3AQI2q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 03:28:46 -0500
From: Arne Jansen <sensille@gmx.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] Btrfs: prevent qgroup config corruption by qgroup destroy
Date: Thu, 17 Jan 2013 09:22:07 +0100
Message-Id: <cover.1358410295.git.sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When destroying an active qgroup with qgroup destroy, the internal config will
become corrupt. This series adds 2 fixes: the first add a recovery, if the config
is already corrupt, and the second prevents the destroy if it is still active.


Arne Jansen (2):
  btrfs: ignore orphan qgroup relations
  btrfs: prevent qgroup destroy when there are still relations

 fs/btrfs/qgroup.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

-- 
1.7.3.4

