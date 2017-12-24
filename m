Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:44811 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756514AbdLXEzo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 23:55:44 -0500
Received: by mail-wm0-f65.google.com with SMTP id t8so27919215wmc.3
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 20:55:43 -0800 (PST)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 0/2] Btrfs: heuristic/compression convert workspace memory cache
Date: Sun, 24 Dec 2017 07:55:26 +0300
Message-Id: <20171224045528.12991-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Attemp to simplify/cleanup compression code.
Little tested under high memory pressure.
At least all looks like working as expected.

First patch include preparation work for
replace old linked list based approach
with the new one based on mempool API.
Covert only one part as proof of concept, heuristic memory managment.
Define usage pattern and mempool_alloc_wrap() - handle
pool resize and pool init errors.

Second move zlib/lzo/zstd to new mempool API

Timofey Titovets (2):
  Btrfs: heuristic: replace workspace managment code by mempool API
  Btrfs: compression: replace workspace managment code by mempool API

 fs/btrfs/compression.c | 332 ++++++++++++++++---------------------------------
 fs/btrfs/compression.h |  12 +-
 fs/btrfs/lzo.c         |  64 ++++++----
 fs/btrfs/zlib.c        |  56 +++++----
 fs/btrfs/zstd.c        |  49 +++++---
 5 files changed, 215 insertions(+), 298 deletions(-)

-- 
2.15.1
