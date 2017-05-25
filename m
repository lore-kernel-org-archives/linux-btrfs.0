Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34618 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760691AbdEYSMh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 14:12:37 -0400
Received: by mail-wm0-f67.google.com with SMTP id d127so54840839wmf.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2017 11:12:37 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v4 0/2] Btrfs: compression fixes
Date: Thu, 25 May 2017 21:12:18 +0300
Message-Id: <20170525181220.24692-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First patch:
Fix copy paste typo in debug message for lzo.c, lzo is not deflate

Second patch:
Force btrfs to not store data as compressed,
if compression will not free at least one sector size,
because it's useless in term of saving storage space and
reading data from disk, as a result productivity suffers.

Changes since v1:
- Merge patches for zlib and lzo in one
- Sync check logic for zlib and lzo
- Check profit after all data are compressed (not while compressing)

Changes since v2:
- Fix comparassion logic, it's enough if:
  compressed size + PAGE_SIZE not bigger then input data size

Changes since v3:
- Use btrfs sector size directly instead of assume that PAGE_SIZE == sectorsize

Timofey Titovets (2):
  Btrfs: lzo.c pr_debug() deflate->lzo
  Btrfs: compression must free at least one sector size

 fs/btrfs/lzo.c  | 11 +++++++++--
 fs/btrfs/zlib.c |  7 ++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

--
2.13.0
