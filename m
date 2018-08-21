Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:45477 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbeHUNnE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 09:43:04 -0400
Received: by mail-pl0-f67.google.com with SMTP id j8-v6so8577180pll.12
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 03:23:30 -0700 (PDT)
From: damenly.su@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 0/2] btrfs-progs: task: add prefn() to task_info and simplify task_start()
Date: Tue, 21 Aug 2018 18:23:09 +0000
Message-Id: <20180821182311.13997-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

This patchset is a prepare work for further process of check.

patch[1] adds prefn() to task_info and call it before pthread_create().

patch[2] moves time and count initializations into the new init_ctx(),
assign it to prefun(). Remove arguments start_time and item_count.


Su Yue (2):
  btrfs-progs: task: add prefn() into struct task_info
  btrfs-progs: task: add init_ctx and clean up arguments of task_start()

 check/main.c   | 27 +++++++++++++++++++--------
 convert/main.c |  6 +++---
 task-utils.c   | 17 +++++++++--------
 task-utils.h   |  5 +++--
 4 files changed, 34 insertions(+), 21 deletions(-)

-- 
2.17.1
