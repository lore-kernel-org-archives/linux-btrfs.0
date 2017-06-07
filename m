Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:36429 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751436AbdFGBAD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 21:00:03 -0400
Received: by mail-wr0-f181.google.com with SMTP id v111so54307831wrc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 18:00:02 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 0/7] Btrfs: if else cleanups
Date: Wed,  7 Jun 2017 03:58:37 +0300
Message-Id: <20170607005844.2078-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Most of patches regroup if else logic
in attemp to avoid useless checks

Last patch convert if else to switch case,
because in that place code work with enum
and usage of switch case can make more obvious
to compiler how to optimize that code

This is if else vs case in GCC C++,
but i think gcc do the same with C.
https://godbolt.org/g/YzPL93

Timofey Titovets (7):
  Btrfs: __compare_inode_defrag decrease max compare count
  Btrfs: backref_comp decrease max compare count
  Btrfs: ref_node_cmp decrease max compare count
  Btrfs: ref_tree_add remove useless compare
  Btrfs: add_all_parents skip compare
  Btrfs: __tree_mod_log_insert decrease max compare count
  Btrfs: end_workqueue_bio use switch case instead of else if

 fs/btrfs/backref.c | 36 ++++++++++++++++++++----------------
 fs/btrfs/ctree.c   | 20 +++++++++++---------
 fs/btrfs/disk-io.c | 17 +++++++++++++----
 fs/btrfs/file.c    | 17 +++++++++--------
 fs/btrfs/inode.c   | 21 ++++++++++++---------
 5 files changed, 65 insertions(+), 46 deletions(-)

--
2.13.0
