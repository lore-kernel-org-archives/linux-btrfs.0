Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:38361 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3KKH1w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Nov 2013 02:27:52 -0500
Received: by mail-qa0-f43.google.com with SMTP id cm18so1553693qab.16
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 23:27:51 -0800 (PST)
From: Frank Holton <fholton@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Frank Holton <fholton@gmail.com>
Subject: [PATCH] Btrfs syslog output prefix fixes
Date: Mon, 11 Nov 2013 02:27:14 -0500
Message-Id: <1384154835-7037-1-git-send-email-fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've gone through the code and tried to find anywhere that prints to
the syslog and make sure that it uses the proper btrfs: prefix. This helps
users find the relevant lines for btrfs and makes sure a grep will return all
of the output from btrfs.

Frank Holton (1):
  Btrfs: Fixup usage of btrfs: prefix in syslog

 fs/btrfs/compression.c      |    4 ++--
 fs/btrfs/ctree.c            |   14 +++++++-------
 fs/btrfs/ctree.h            |    2 +-
 fs/btrfs/delayed-inode.c    |    4 ++--
 fs/btrfs/disk-io.c          |   34 +++++++++++++++++-----------------
 fs/btrfs/extent-tree.c      |    6 +++---
 fs/btrfs/extent_io.c        |   40 ++++++++++++++++++++--------------------
 fs/btrfs/file-item.c        |    2 +-
 fs/btrfs/free-space-cache.c |    6 +++---
 fs/btrfs/inode.c            |    6 +++---
 fs/btrfs/ioctl.c            |    6 +++---
 fs/btrfs/lzo.c              |    6 +++---
 fs/btrfs/ordered-data.c     |    6 +++---
 fs/btrfs/qgroup.c           |    4 ++--
 fs/btrfs/reada.c            |    4 ++--
 fs/btrfs/root-tree.c        |    2 +-
 fs/btrfs/scrub.c            |   10 +++++-----
 fs/btrfs/super.c            |   12 ++++++------
 18 files changed, 84 insertions(+), 84 deletions(-)

-- 
1.7.9.5

