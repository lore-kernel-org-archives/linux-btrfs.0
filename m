Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbcFWT0O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 15:26:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id F0D70AC0B
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 19:26:07 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: check improve 'checking extents' scalability
Date: Thu, 23 Jun 2016 15:26:03 -0400
Message-Id: <1466709966-31506-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

While running xfstests generic/291, which creates a single file populated
with reflinks to the same extent, I found that fsck had been running for
hours.  perf top lead me to find_data_backref as the culprit, and a litte
more digging made it clear: For every extent record we add, we iterate
the entire list first.  My test case had ~2M records.  That math doesn't
go well.

This patchset converts the extent_backref list to an rbtree.  The test
that used to run for more than 8 hours without completing now takes
less than 20 seconds.

-Jeff

---

Jeff Mahoney (3):
  btrfs-progs: check: add helpers for converting between structures
  btrfs-progs: check: supplement extent backref list with rbtree
  btrfs-progs: check: switch to iterating over the backref_tree

 cmds-check.c | 355 +++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 237 insertions(+), 118 deletions(-)

-- 
2.7.1

