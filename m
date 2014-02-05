Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaBELRB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 06:17:01 -0500
From: David Disseldorp <ddiss@suse.de>
To: xfs@oss.sgi.com
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] __btrfs_drop_extents() BUG_ON reproducer
Date: Wed,  5 Feb 2014 12:16:47 +0100
Message-Id: <1391599009-2402-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch-set provides a reproducer for hitting the 3.14.0-rc1 BUG_ON()
at:
 692 int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
...
 839                 /*
 840                  *  | ---- range to drop ----- |
 841                  *      | -------- extent -------- |
 842                  */
 843                 if (start <= key.offset && end < extent_end) {
 844                         BUG_ON(extent_type == BTRFS_FILE_EXTENT_INLINE);
 845 
 846                         memcpy(&new_key, &key, sizeof(new_key));

The first patch adds a small cloner binary which is used by btrfs/035 to
dispatch BTRFS_IOC_CLONE_RANGE requests.

This workload resembles that of Samba's vfs_btrfs module, when a Windows
client restores a file from a shadow-copy (snapshot) using server-side
copy requests.

Feedback appreciated.

Cheers, David


 src/Makefile        |   2 +-
 src/cloner.c        | 168 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/035     |  76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/035.out |   3 +++
 tests/btrfs/group   |   1 +
 5 files changed, 249 insertions(+), 1 deletion(-)

