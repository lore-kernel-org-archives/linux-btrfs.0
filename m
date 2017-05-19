Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34546 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdESNip (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 09:38:45 -0400
Received: by mail-wr0-f193.google.com with SMTP id 6so3029173wrb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 06:38:44 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 0/3] Btrfs: compression fixes
Date: Fri, 19 May 2017 16:38:32 +0300
Message-Id: <20170519133835.27843-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First patch fix copy paste typo in debug message in lzo.c, lzo is not deflate

Second and third patches force btrfs not compress data if compression will not free at least one PAGE_SIZE
Because it's useless in term of storage and read data from disk, as a result productivity suffers

Timofey Titovets (3):
  Btrfs: lzo.c pr_debug() deflate->lzo
  Btrfs: lzo compression must free at least PAGE_SIZE
  Btrfs: zlib compression must free at least PAGE_SIZE

 fs/btrfs/lzo.c  | 4 ++--
 fs/btrfs/zlib.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--
2.13.0
