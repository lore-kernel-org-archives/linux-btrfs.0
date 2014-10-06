Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:48854 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaJFUOw (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 6 Oct 2014 16:14:52 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 0/5] Proper error handling for the compressed write path
Date: Mon,  6 Oct 2014 22:14:21 +0100
Message-Id: <1412630066-21746-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes several issues in inode.c:submit_compressed_extents()
when one of the functions it calls fails. These issues range from hangs,
missing error reporting (silent failure), memory leaks and pages not getting
released.

Filipe Manana (5):
  Btrfs: set page and mapping error on compressed write failure
  Btrfs: fix hang on compressed write error
  Btrfs: don't leak pages and memory on compressed write error
  Btrfs: process all async extents on compressed write failure
  Btrfs: make inode.c:submit_compressed_extents() return void

 fs/btrfs/extent_io.c |  5 +++++
 fs/btrfs/extent_io.h |  1 +
 fs/btrfs/inode.c     | 56 ++++++++++++++++++++++++++++++++++------------------
 3 files changed, 43 insertions(+), 19 deletions(-)

-- 
1.9.1

