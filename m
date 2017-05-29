Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34466 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdE2XSc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 19:18:32 -0400
Received: by mail-wm0-f67.google.com with SMTP id d127so21057127wmf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 May 2017 16:18:32 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v5 0/2] Btrfs: compression fixes
Date: Tue, 30 May 2017 02:18:03 +0300
Message-Id: <20170529231805.4797-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First patch:
Sync comparison logic of compressed/uncompressed sizes from zlib to lzo

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
  Thanks to Chandan

Changes since v4:
- Old first patch - merged (fix typo)
- New first patch - synced some logic (see patch) from zlib to lzo
- Check compressed/uncompressed size in right place compress_file_range()
  Thanks to David

Timofey Titovets (2):
  Btrfs: lzo.c compressed data size must be less then input size
  Btrfs: compression must free at least one sector size

 fs/btrfs/inode.c | 3 ++-
 fs/btrfs/lzo.c   | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--
2.13.0
