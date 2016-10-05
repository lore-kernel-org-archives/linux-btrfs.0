Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40461 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752915AbcJEMXN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Oct 2016 08:23:13 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5829DAD13
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Oct 2016 12:23:12 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: remove unused headers, statfs.h
Date: Wed,  5 Oct 2016 14:23:05 +0200
Message-Id: <20161005122306.3530-2-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/file.c  | 1 -
 fs/btrfs/inode.c | 1 -
 fs/btrfs/ioctl.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fea31a4a6e36..887ed6ac016e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -27,7 +27,6 @@
 #include <linux/falloc.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
-#include <linux/statfs.h>
 #include <linux/compat.h>
 #include <linux/slab.h>
 #include <linux/btrfs.h>
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6811c42e41e..3241dfd14db3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -30,7 +30,6 @@
 #include <linux/mpage.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
-#include <linux/statfs.h>
 #include <linux/compat.h>
 #include <linux/bit_spinlock.h>
 #include <linux/xattr.h>
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7fd939bfbd99..a6959c7d9807 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -33,7 +33,6 @@
 #include <linux/namei.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
-#include <linux/statfs.h>
 #include <linux/compat.h>
 #include <linux/bit_spinlock.h>
 #include <linux/security.h>
-- 
2.10.0

