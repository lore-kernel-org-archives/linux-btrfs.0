Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:36543 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbcEKXuo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 19:50:44 -0400
Received: by mail-ig0-f196.google.com with SMTP id c3so5411349igl.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 May 2016 16:50:43 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH 0/1] btrfs-progs: Typo review of strings and comments
Date: Wed, 11 May 2016 19:50:35 -0400
Message-Id: <1463010636-18514-1-git-send-email-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you David Sterba for the btrfs-typos.txt which gave me a head start.  Unfortunately I wasn't able finish before btrfs-progs-4.5.3 was released, because I decided to use emacs' ispell-comments-and-strings to do a full review.  I had to rebase to kdave's 4.5.2 branch on github, and that is what this patch will cleanly apply to.

There were a couple of instances where I wasn't sure what to do; I've annotated them, and they are long lines now.  To find them, search or grep the diff for 'Steeves'.

Best regards,
Nicholas

Nicholas D Steeves (1):
  Typo review of strings and comments.

 CHANGES                                            | 12 ++++-----
 backref.c                                          |  4 +--
 btrfs-convert.c                                    |  4 +--
 btrfs-corrupt-block.c                              |  4 +--
 btrfs-debugfs                                      |  2 +-
 btrfs-image.c                                      | 22 ++++++++--------
 btrfs-list.c                                       |  4 +--
 chunk-recover.c                                    |  6 ++---
 cmds-balance.c                                     |  4 +--
 cmds-check.c                                       | 30 +++++++++++-----------
 cmds-fi-du.c                                       |  2 +-
 cmds-fi-usage.c                                    |  2 +-
 cmds-inspect-tree-stats.c                          |  2 +-
 cmds-inspect.c                                     |  2 +-
 cmds-receive.c                                     |  2 +-
 cmds-scrub.c                                       |  2 +-
 cmds-send.c                                        |  2 +-
 ctree.c                                            |  2 +-
 ctree.h                                            |  6 ++---
 dir-item.c                                         |  2 +-
 disk-io.h                                          |  4 +--
 extent-cache.h                                     |  2 +-
 file.c                                             |  4 +--
 inode.c                                            |  4 +--
 ioctl.h                                            |  6 ++---
 list_sort.c                                        |  2 +-
 mkfs.c                                             | 12 ++++-----
 send-utils.c                                       |  2 +-
 show-blocks                                        |  4 +--
 super-recover.c                                    |  4 +--
 tests/README.md                                    |  4 +--
 tests/common                                       |  2 +-
 tests/fsck-tests.sh                                |  2 +-
 tests/misc-tests.sh                                |  2 +-
 tests/misc-tests/007-subvolume-sync/test.sh        |  4 +--
 .../009-subvolume-sync-must-wait/test.sh           |  2 +-
 tests/misc-tests/013-subvolume-sync-crash/test.sh  |  2 +-
 tests/mkfs-tests.sh                                |  2 +-
 .../008-secorsize-nodesize-combination/test.sh     |  2 +-
 ulist.c                                            |  2 +-
 utils-lib.c                                        |  2 +-
 utils.c                                            |  2 +-
 volumes.c                                          |  2 +-
 43 files changed, 95 insertions(+), 95 deletions(-)

-- 
2.1.4

