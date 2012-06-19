Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40318 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2FSNmZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 09:42:25 -0400
Received: by bkcji2 with SMTP id ji2so5098156bkc.19
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2012 06:42:24 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, Alexander Block <ablock84@googlemail.com>
Subject: [PATCH 0/2] Fix bugs in backref resolving code
Date: Tue, 19 Jun 2012 15:42:24 +0200
Message-Id: <1340113346-12987-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This bug popped up while working on btrfs send. This patchset contains 
two patches. The first one introduces btrfs_next_old_leaf which is needed
in the second patch which is the actual fix.

Both patches should probably go into 3.5 as they fix wrongly resolved
backrefs and a crash.

Big thanks to Jan Schmidt for his help here.

Alexander Block (2):
  Btrfs: introduce btrfs_next_old_item
  Btrfs: don't assume to be on the correct extent in add_all_parents

 fs/btrfs/backref.c |   94 +++++++++++++++++++++++++++++-----------------------
 fs/btrfs/ctree.h   |    9 +++--
 2 files changed, 59 insertions(+), 44 deletions(-)

-- 
1.7.10

