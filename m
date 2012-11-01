Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54064 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2KAJa5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 05:30:57 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so2436633vcb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 02:30:56 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 Nov 2012 17:30:56 +0800
Message-ID: <CAFc7E1k2gg9uVAmZE_J07=Fyx4MojLihWc2_4thEduLnePVDxw@mail.gmail.com>
Subject: [PATCH] shared compression workspaces limits doesnot match
From: Rock Lee <geekerrocklee@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Rock Lee <GeekerRockLee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In function find_workspace, it's allowed to alloc cpus + 1 workspaces at most,
but in function free_workspace, it will freed the workspace if there
exists more then cpus' workspaces.

The two limits doesn't match. I thought the original itention is
allowed to alloc
cpus compression workspaces at most.

Signed-off-by: Rock Lee <GeekerRockLee@gmail.com>
---
 fs/btrfs/compression.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c6467aa..eef1811 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -779,7 +779,7 @@ again:
  return workspace;

  }
- if (atomic_read(alloc_workspace) > cpus) {
+ if (atomic_read(alloc_workspace) >= cpus) {
  DEFINE_WAIT(wait);

  spin_unlock(workspace_lock);
--
1.7.7.6
