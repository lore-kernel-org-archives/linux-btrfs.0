Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:35489 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3IDPWo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:22:44 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so446073pbc.29
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:22:44 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 00/20] fix magic return value in btrfs-progs
Date: Wed,  4 Sep 2013 23:22:17 +0800
Message-Id: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset tries to fix all the magic return value in btrfs-progs.
Most commands will have three kinds of return value:

0 success
1 usage of syntax errors

Exceptions come from balance/scrub/replace. For example, replace cancel
will return 2 if there is no operations in progress.

Some tools including(btrfsck,chunk-recover) since they are still under
development. Also we should update man page if these magic return values
have been corrected.

Any comments are welcome.

Notice: this patchset is based on David integration-20130902

Wang Shilong (20):
  Btrfs-progs: return 1 rather than 129 in usage()
  Btrfs-progs: fix magic return value in cmds-subvolume.c
  Btrfs-progs: fix magic return value in cmds-chunk.c
  Btrfs-progs: fix magic return value in cmds-dedup.c
  Btrfs-progs: fix magic return value in cmds-device.c
  Btrfs-progs: fix magic return value in cmds-filesystem.c
  Btrfs-progs: fix magic return value in cmds-inspect.c
  Btrfs-progs: fix magic return value in cmds-qgroup.c
  Btrfs-progs: fix magic return value in cmds-quota.c
  Btrfs-progs: fix magic return value in cmds-receive.c
  Btrfs-progs: fix magic return value in cmds-restore.c
  Btrfs-progs: fix magic return value in cmds-send.c
  Btrfs-progs: fix magic return value in btrfs-imgae.c
  Btrfs-progs: fix magic return value in btrfs-zero-log.c
  Btrfs-progs: fix magic return value in send-test.c
  Btrfs-progs: fix magic return value in dir-test.c
  Btrfs-progs: fix magic return value in random-test.c
  Btrfs-progs: fix magic return value in cmds-balance.c
  Btrfs-progs: fix magic return value in cmds-replace.c
  Btrfs-progs: fix magic return value in cmds-scrub.c

 btrfs-image.c     |  2 +-
 btrfs-zero-log.c  |  8 +++--
 cmds-balance.c    | 93 ++++++++++++++++++++++++++++++++++---------------------
 cmds-chunk.c      |  9 ++++--
 cmds-dedup.c      |  6 ++--
 cmds-device.c     | 24 ++++++--------
 cmds-filesystem.c | 28 ++++++++---------
 cmds-inspect.c    | 10 +++---
 cmds-qgroup.c     | 26 +++++++---------
 cmds-quota.c      | 10 +++---
 cmds-receive.c    |  4 +--
 cmds-replace.c    | 16 ++++++----
 cmds-restore.c    | 18 +++++------
 cmds-scrub.c      | 20 ++++++------
 cmds-send.c       |  2 +-
 cmds-subvolume.c  | 45 ++++++++++++---------------
 dir-test.c        | 16 +++++-----
 help.c            |  2 +-
 random-test.c     | 18 +++++------
 send-test.c       |  2 +-
 20 files changed, 189 insertions(+), 170 deletions(-)

-- 
1.7.11.7

