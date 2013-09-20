Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab3ITQer (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 12:34:47 -0400
From: David Sterba <dsterba@suse.cz>
To: stable@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Handful of btrfs fixes for 3.11.x stable
Date: Fri, 20 Sep 2013 18:34:39 +0200
Message-Id: <1379694879-29402-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi stable team,

please add the following commits to 3.11 tree, they fix user visible problems,
were tested and are now present in 3.12-rc1.

3d05ca371200b3366530621abf73769024581b79
b13a004528c3e5eb060a26eee795f5a0da7bfe9f
7ef67ffda91cc0c56f33937bfdf1d057b9ee96ca
ca6d07c1d74bf7ba3083bc31a9aeeaa1d0ad86aa

Josef Bacik (4):
  Btrfs: reset ret in record_one_backref
  Btrfs: change how we queue blocks for backref checking
  Btrfs: skip subvol entries when checking if we've created a dir already
  Btrfs: remove ourselves from the cluster list under lock

 fs/btrfs/extent-tree.c |  3 ++-
 fs/btrfs/inode.c       |  3 +--
 fs/btrfs/relocation.c  | 14 +++++++-------
 fs/btrfs/send.c        |  3 ++-
 4 files changed, 12 insertions(+), 11 deletions(-)
