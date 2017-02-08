Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57252 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751809AbdBHREm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 12:04:42 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PULL] Fix ioctls on 32bit/64bit userspace/kernel, for 4.10
Date: Wed,  8 Feb 2017 17:51:28 +0100
Message-Id: <cover.1486571660.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

could you please merge this single-patch pull request, for 4.10 still?  There
are quite a few patches on top of v4.10-rc7 so this IMHO does not look like
look too bad even late in the release cycle. Though it's a fix for an uncommon
usecase of 32bit userspace on 64bit kernel, it fixes basically operation of the
ioctls. Thanks.

The following changes since commit 57b59ed2e5b91e958843609c7884794e29e6c4cb:

  Btrfs: remove ->{get, set}_acl() from btrfs_dir_ro_inode_operations (2017-01-26 15:48:56 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git fixes-4.10

for you to fetch changes up to 2a362249187a8d0f6d942d6e1d763d150a296f47:

  btrfs: fix btrfs_compat_ioctl failures on non-compat ioctls (2017-02-08 17:47:30 +0100)

----------------------------------------------------------------
Jeff Mahoney (1):
      btrfs: fix btrfs_compat_ioctl failures on non-compat ioctls

 fs/btrfs/ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)
