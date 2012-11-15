Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.clear-code.com ([219.94.234.64]:45972 "EHLO
	mail.clear-code.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992535Ab2KOE6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 23:58:17 -0500
From: Kenji Okimoto <okimoto@clear-code.com>
To: linux-btrfs@vger.kernel.org
Cc: Kenji Okimoto <okimoto@clear-code.com>
Subject: [PATCH 0/3] btrfs-progs: fix problems reported by cppcheck
Date: Thu, 15 Nov 2012 13:47:49 +0900
Message-Id: <1352954872-13770-1-git-send-email-okimoto@clear-code.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I fixed some problems reported by cppcheck:

  [disk-io.c:462]: (error) Memory leak: log_root
  [utils.c:983]: (error) Memory leak: fullpath

Patch set based on:
  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git#master

  commit 91d9eec1ff044394f2b98ee7fcb76713dd33b994
  Author: Chris Mason <chris.mason@fusionio.com>
  Date:   Thu Oct 4 20:35:31 2012 -0400

Kenji Okimoto (3):
  btrfs-progs: plug a memory leak reported by cppcheck
  btrfs-progs: check malloc() result
  btrfs-progs: plug memory leaks in btrfs_scan_one_dir() reported by
    cppcheck.

 disk-io.c |   13 +++++++++++--
 utils.c   |    3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

-- 
1.7.10.4

