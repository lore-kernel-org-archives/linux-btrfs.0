Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085AbaBFN7W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 08:59:22 -0500
From: David Disseldorp <ddiss@suse.de>
To: xfs@oss.sgi.com
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] __btrfs_drop_extents() BUG_ON reproducer
Date: Thu,  6 Feb 2014 14:59:11 +0100
Message-Id: <1391695154-2039-1-git-send-email-ddiss@suse.de>
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

Changes since V1:
- Use strtoull instead of atoi
- Print error conditions in cloner
- Check for cloner binary before running test
- Continue test on failure
- Add cloner to .gitignore

Feedback appreciated.

Cheers, David


 .gitignore          |   1 +
 configure.ac        |   1 +
 src/Makefile        |   2 +-
 src/cloner.c        | 192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/035     |  77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/035.out |   3 +++
 tests/btrfs/group   |   1 +
 7 files changed, 276 insertions(+), 1 deletion(-)
 create mode 100644 src/cloner.c
 create mode 100755 tests/btrfs/035
 create mode 100644 tests/btrfs/035.out
