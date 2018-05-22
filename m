Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:38936 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753085AbeEVWCU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 18:02:20 -0400
Received: by mail-pf0-f195.google.com with SMTP id a22-v6so9415800pfn.6
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 15:02:20 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 0/2] Btrfs: fix partly checksummed file races
Date: Tue, 22 May 2018 15:02:11 -0700
Message-Id: <cover.1527026445.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Clone and dedupe both have checks to make sure that we're not mixing
checksummed and not checksummed extents in a single file. However, both
checks are racy; we need to have the inodes locked or else the flags can
change after we check. The clone check has always been wrong. The dedupe
check was previously correct but is broken in kdave/for-next.

Based on kdave/for-next. Note that there's a Fixes: tag in there
referencing a commit in the for-next branch, so that would have to be
updated if the commit gets rebased. These patches are also available at
https://github.com/osandov/linux/tree/btrfs-nodatasum-race.

Thanks!

Omar Sandoval (2):
  Btrfs: fix clone vs chattr NODATASUM race
  Btrfs: fix dedupe vs chattr NODATASUM race

 fs/btrfs/ioctl.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

-- 
2.17.0

