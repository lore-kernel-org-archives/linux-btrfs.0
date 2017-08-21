Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:59579 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752542AbdHUMgH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 08:36:07 -0400
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/5] BTRFS: Fine-tuning for five function implementations
Message-ID: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
Date: Mon, 21 Aug 2017 14:35:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 21 Aug 2017 14:30:12 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (5):
  Use common error handling code in tree_mod_log_eb_copy()
  Use common error handling code in __btrfs_free_extent()
  Use common error handling code in btrfs_update_root()
  Use common error handling code in update_ref_path()
  Use common error handling code in btrfs_mark_extent_written()

 fs/btrfs/ctree.c       | 14 +++++-----
 fs/btrfs/extent-tree.c | 69 ++++++++++++++++++++------------------------------
 fs/btrfs/file.c        | 62 ++++++++++++++++++---------------------------
 fs/btrfs/root-tree.c   | 27 ++++++++------------
 fs/btrfs/send.c        |  8 +++---
 5 files changed, 72 insertions(+), 108 deletions(-)

-- 
2.14.0

