Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40160 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbcBPPiz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 10:38:55 -0500
To: linux-btrfs@vger.kernel.org
From: Colin Ian King <colin.king@canonical.com>
Subject: BZ#101951, Overlayfs on top of btrfs causes kernel oops + freeze
Message-ID: <56C3428D.1010000@canonical.com>
Date: Tue, 16 Feb 2016 15:38:53 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

bug: https://bugzilla.kernel.org/show_bug.cgi?id=101951 and also
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1532145

Commit 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01 ("overlayfs: Make f_path
always point to the overlay and f_inode to the underlay") resulted in an
issue when using a combination of btrfs and overlayfs.  This is
noticeable when doing a fsync() on a file in a chroot with overlayfs on
top of btrfs; we hit a kernel oops in btrfs_sync_file() on
atomic_inc(&root->log_batch) because root is NULL.

I've debugged this further and found that in btrfs_sync_file():

	struct inode *inode = d_inode(dentry);

does not return the inode I expected when using the stacked overlay fs,
where as:

	struct inode *inode = file_inode(file);

does.

However, I'm not well at all well versed in btrfs, so I am not confident
this is a actually correct.  Any comments?

Colin
