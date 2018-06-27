Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:44407 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbeF0ER3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 00:17:29 -0400
From: Chengguang Xu <cgxu519@gmx.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v4 0/5] code cleanups for btrfs_get_acl()
Date: Wed, 27 Jun 2018 12:16:33 +0800
Message-Id: <20180627041638.13210-1-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch set does code cleanups for btrfs_get_acl().

Chengguang Xu (5):
  btrfs: return error instead of crash when detecting unexpected type in
    btrfs_get_acl()
  btrfs: replace empty string with NULL when getting attribute length in
    btrfs_get_acl()
  btrfs: remove unnecessary -ERANGE check in btrfs_get_acl()
  btrfs: avoid error code overriding in btrfs_get_acl()
  btrfs: remove unnecessary bracket in btrfs_get_acl()

 fs/btrfs/acl.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

-- 
2.17.1

