Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:54392 "EHLO
        mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752571AbeGDT1E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 15:27:04 -0400
From: =?UTF-8?q?St=C3=A9phane=20Lesimple?= <stephane_btrfs@lesimple.fr>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?St=C3=A9phane=20Lesimple?= <stephane_btrfs@lesimple.fr>
Subject: [PATCH 0/2] btrfs-progs: check: enhanced progress indicator
Date: Wed,  4 Jul 2018 21:20:12 +0200
Message-Id: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch replaces the current ".oOo."-style progress indicator of
btrfs check (-p), by a more helpful live indication of the check progress.
I've been using it on a custom btrfs-progs version since 2015.

Here's how the output looks like on a 22 Tb 5-disk RAID1 FS:

# btrfs check -p /dev/mapper/luks-ST10000VN0004-XXXXXXXX
Opening filesystem to check...
Checking filesystem on /dev/mapper/luks-ST10000VN0004-XXXXXXXX
UUID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
[1/7] checking extents           (0:20:21 elapsed, 950958 items checked)
[2/7] checking root items        (0:01:29 elapsed, 15121 items checked)
[3/7] checking free space cache  (0:00:11 elapsed, 4928 items checked)
[4/7] checking fs roots          (0:51:31 elapsed, 600892 items checked)
[5/7] checking csums             (0:14:35 elapsed, 754522 items checked)
[6/7] checking root refs         (0:00:00 elapsed, 232 items checked)
[7/7] checking quota groups skipped (not enabled on this FS)
found 5286458060800 bytes used, no error found

The code is also viewable at https://github.com/kdave/btrfs-progs/pull/69

Stéphane Lesimple (2):
  btrfs-progs: fix nanosecs in task_period_start
  btrfs-progs: check: enhanced progress indicator

 check/main.c        | 176 ++++++++++++++++++++++++++++++++++------------------
 check/mode-common.h |  20 ++++++
 check/mode-lowmem.c |   1 +
 convert/main.c      |   2 +-
 qgroup-verify.c     |   7 +++
 qgroup-verify.h     |   2 +
 task-utils.c        |  10 ++-
 task-utils.h        |   3 +-
 8 files changed, 155 insertions(+), 66 deletions(-)

-- 
2.7.4

