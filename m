Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab2JBL1J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Oct 2012 07:27:09 -0400
Date: Tue, 2 Oct 2012 13:27:07 +0200
From: David Sterba <dsterba@suse.cz>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [GIT PULL] btrfs-progs: Handful of fixes for 0.20-rc1
Message-ID: <20121002112707.GH4545@ds.suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

please pull a few fixes to the 0.20-rc series, these are easy to review and fix
problems that people reported. There are more fixes in the mailinglist, but
they do not IMHO fit current -rc period, the crowd is waiting for 0.20.

  git://repo.or.cz/btrfs-progs-unstable/devel.git for-chris/rc2

Based on top of master commit d88f33152f3d69240b6c690188b5d832a1663c07.

Thanks.

---
 btrfs-vol.c         |    3 ++-
 btrfsck.c           |    2 +-
 cmds-device.c       |    3 ++-
 cmds-qgroup.c       |    3 +++
 man/mkfs.btrfs.8.in |    3 ++-
 mkfs.c              |   23 ++++++++++-------------
 utils.c             |   14 ++++----------
 utils.h             |    6 ++----
 8 files changed, 26 insertions(+), 31 deletions(-)
---

David Sterba (3):
      btrfs-progs: mkfs: rename nodiscard option to K
      btrfs-progs: mkfs: create root directory with 755 permissions
      btrfs-progs: fsck: understand the -s option

Josef Bacik (1):
      Btrfs-progs: only enforce a maximum size if we specify one

Tsutomu Itoh (1):
      Btrfs-progs: fix arguments check of qgroup limit

