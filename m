Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18767 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932684AbeAKKLP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 05:11:15 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 0/2] btrfs-progs: Update btrfs-progs to match kernel sources
Date: Thu, 11 Jan 2018 18:11:06 +0800
Message-ID: <1515665468-7450-1-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1512471667-8555-1-git-send-email-gujx@cn.fujitsu.com>
References: <1512471667-8555-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v2->v1:
Modify btrfs-progs by refer to the two patches list below:
commit a717531942f4 ("Btrfs: do less aggressive btree readahead")
commit e4058b54d1e4 ("btrfs: cleanup, use enum values for btrfs_path reada")

Gu Jinxiang (2):
  btrfs-progs: do less aggressive btree readahead
  btrfs-progs: cleanup, use enum values for btrfs_path reada

 cmds-restore.c    |  4 ++--
 ctree.c           | 33 +++++++++++----------------------
 ctree.h           |  2 +-
 extent-tree.c     | 12 ++++++------
 free-space-tree.c |  2 +-
 qgroup-verify.c   |  2 +-
 volumes.c         |  4 ++--
 7 files changed, 24 insertions(+), 35 deletions(-)

-- 
2.14.3



