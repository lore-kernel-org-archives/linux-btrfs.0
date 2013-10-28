Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab3J1Tyn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 15:54:43 -0400
Message-Id: <20131028195204.611287480@sled1.home.jeffreymahoney.com>
Date: Mon, 28 Oct 2013 15:52:04 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: xfs@oss.sgi.com
Cc: jbacik@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] xfstests: for btrfs publishing/export patchset (v2)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These are the tests that Josef requested accompany the submission of
the btrfs publishing/export patchset[1].

021: Test new global metadata reservation ioctl
022: Test new sysfs exporting of allocation and device membership
023: Test new sysfs exporting of feature bits
024: Test setting/clearing feature bits via ioctl
025: Test setting/clearing feature bits via sysfs

As part of the ioctl testing, I added a helper that can be extended
easily to export simple information via ioctl. This means that the
tests can be independent of btrfsprogs version or its output formatting.

V2:
- Used next numbers in sequence
- Better commit messages
- Fixed handling of the missing feature cases
- Fixed issues raised in Josef's review

-Jeff

[1] http://thread.gmane.org/gmane.comp.file-systems.btrfs/29307

