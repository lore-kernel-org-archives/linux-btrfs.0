Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:56839 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3ATPWf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 10:22:35 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so2544734eei.31
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jan 2013 07:22:34 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>, idryomov@gmail.com
Subject: [PATCH 0/5] Mutually exclusive ops fixes
Date: Sun, 20 Jan 2013 17:22:27 +0200
Message-Id: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is a set of fixes for mutually exclusive ops stuff added by Stefan
as part of the dev-replace patchset.  The main one here is the first
patch, it fixes a regression in balancing interface.  The second patch
brings EINVAL error code back.  The rest are relatively minor ordering
fixes.

Thanks,

		Ilya


Ilya Dryomov (5):
  Btrfs: bring back balance pause/resume logic
  Btrfs: fix "mutually exclusive op is running" error code
  Btrfs: fix unlock order in btrfs_ioctl_resize
  Btrfs: fix unlock order in btrfs_ioctl_rm_dev
  Btrfs: reorder locks and sanity checks in btrfs_ioctl_defrag

 fs/btrfs/ioctl.c   |  107 ++++++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/volumes.c |   10 +++-
 2 files changed, 86 insertions(+), 31 deletions(-)

-- 
1.7.9.1
