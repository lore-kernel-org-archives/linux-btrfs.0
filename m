Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab3LPQeJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 11:34:09 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id F29EAABE7
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 16:34:07 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/3] Send: minor cleanups, add RO checks
Date: Mon, 16 Dec 2013 17:34:07 +0100
Message-Id: <cover.1387211245.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First two patches are trivial cleanups that I've spotted while reading send.c,
can be applied independently.

The third patch contains the important bits, safety checks that the subvolumes
involved in send do not accidentally lose the RO status. I haven't seen this
documented anywhere that this is mandatory, implied from how I assume send
works. Please let me know if this is wrong.

David Sterba (3):
  btrfs: send: clean up dead code
  btrfs: remove unused mnt from send_ctx
  btrfs: Check read-only status of roots during send

 fs/btrfs/ctree.h |    6 +++
 fs/btrfs/ioctl.c |   22 +++++++++-
 fs/btrfs/send.c  |  116 +++++++++++++++++++++++++++++-------------------------
 3 files changed, 87 insertions(+), 57 deletions(-)

-- 
1.7.9

