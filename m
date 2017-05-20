Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36339 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbdETSkx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 14:40:53 -0400
Received: by mail-lf0-f65.google.com with SMTP id h4so2283276lfj.3
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 11:40:52 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v3 0/2] Btrfs: compression fixes
Date: Sat, 20 May 2017 21:40:37 +0300
Message-Id: <20170520184039.31362-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First patch: fix copy paste typo in debug message in lzo.c, lzo is not deflate

Second patch: force btrfs to not store data as compressed, if compression will not
free at least one PAGE_SIZE, because it's useless in term of storage and reading data from disk, as a result
productivity suffers

Changes since v1:
- Merge patches for zlib and lzo in one
- Sync check logic for zlib and lzo
- Check profit after all data are compressed (not while compressing)

Changes since v2:
- Fix comparassion logic, it's enough if:
  compressed size + PAGE_SIZE not bigger then input data size

Timofey Titovets (2):
  Btrfs: lzo.c pr_debug() deflate->lzo
  Btrfs: compression must free at least PAGE_SIZE

 fs/btrfs/lzo.c  | 7 +++++--
 fs/btrfs/zlib.c | 3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

--
2.13.0
