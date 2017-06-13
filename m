Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:34786 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbdFMU4W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 16:56:22 -0400
Received: by mail-wr0-f171.google.com with SMTP id 77so13567868wrb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Jun 2017 13:56:21 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2 0/2] Btrfs: if else cleanups
Date: Tue, 13 Jun 2017 23:56:06 +0300
Message-Id: <20170613205608.28483-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Both patches just make code more readable

Changes since v1:
  - Drop controversial patches from patchset for now

Timofey Titovets (2):
  Btrfs: ref_tree_add remove useless compare
  Btrfs: add_all_parents skip compare

 fs/btrfs/backref.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--
2.13.1
