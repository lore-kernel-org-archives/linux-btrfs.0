Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:50806 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757838Ab2EPQu7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 May 2012 12:50:59 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by mort.rzone.de (Postfix) with ESMTP id 2282323A
	for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2012 18:50:58 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/3] Btrfs-progs: support get/reset device stats via ioctl
Date: Wed, 16 May 2012 18:50:55 +0200
Message-Id: <1337187058-560-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs device stats" is used to retrieve and print the device stats.
"btrfs device stats -z" is used to atomically retrieve, reset and
print the stats.

In order to share two utility functions between scrub and the dev stats
code, these two functions are moved to utils.c and renamed.
Since these functions are using open_file_or_dir(), and since the linking
against utils.o and common.o was different, open_file_or_dir() was moved
from common.c to utils.c. And since that function makes use of the
function dirfd(3), the required XOPEN version was raised from 6 to 7.

Changes v1->v2:
- Remove a verbose printf()
- Cast u64 to unsigned long long for printf()
- Update the man page

Changes v2->v3:
- Rebase on Chris' current master branch
- Split the patch into three seperate patches because after rebasing,
  open_file_or_dir() was moved and additional changes had been necessary

Stefan Behrens (3):
  Btrfs-progs: move open_file_or_dir() to utils.c
  Btrfs-progs: make two utility functions globally available
  Btrfs-progs: add command to get/reset device stats via ioctl

 Makefile         |    4 +-
 btrfsctl.c       |   28 --------------
 cmds-balance.c   |    1 +
 cmds-device.c    |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-inspect.c   |    1 +
 cmds-scrub.c     |   72 +---------------------------------
 cmds-subvolume.c |    1 +
 commands.h       |    3 --
 common.c         |   46 ----------------------
 ctree.h          |    6 +++
 ioctl.h          |   27 +++++++++++++
 man/btrfs.8.in   |   14 +++++++
 print-tree.c     |    6 +++
 utils.c          |   97 +++++++++++++++++++++++++++++++++++++++++++++-
 utils.h          |    7 ++++
 15 files changed, 275 insertions(+), 151 deletions(-)
 delete mode 100644 common.c

-- 
1.7.10.2

