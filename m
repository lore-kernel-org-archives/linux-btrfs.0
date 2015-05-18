Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:32783 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbbERJQm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 05:16:42 -0400
Received: by padbw4 with SMTP id bw4so144022173pad.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 02:16:42 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 0/6] Btrfs: show subvolume name and ID in /proc/mounts
Date: Mon, 18 May 2015 02:16:25 -0700
Message-Id: <cover.1431939732.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we've reached an agreement, I've rebased this series on top of
v4.1-rc3 (there were some minor conflicts with the ->d_inode to
d_inode() conversion merged in v4.1-rc1, no other code changes).

This change makes things just a little bit friendlier for users and also
cleans up the mount path. David mentioned that he's also using this
patchset as a base for per-subvolume mount flag support. He's reviewed
all of the patches in this series. Please consider for 4.2!

v2: https://lkml.org/lkml/2015/4/9/906
v1: https://lkml.org/lkml/2015/4/8/16

Omar Sandoval (6):
  Btrfs: lock superblock before remounting for rw subvol
  Btrfs: remove all subvol options before mounting top-level
  Btrfs: clean up error handling in mount_subvol()
  Btrfs: fail on mismatched subvol and subvolid mount options
  Btrfs: unify subvol= and subvolid= mounting
  Btrfs: show subvol= and subvolid= in /proc/mounts

 fs/btrfs/super.c | 386 ++++++++++++++++++++++++++++++++++++-------------------
 fs/seq_file.c    |   1 +
 2 files changed, 252 insertions(+), 135 deletions(-)

-- 
2.4.1

