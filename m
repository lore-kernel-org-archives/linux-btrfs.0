Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34763 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753720AbdG2NhH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Jul 2017 09:37:07 -0400
Received: by mail-wm0-f66.google.com with SMTP id x64so6130752wmg.1
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jul 2017 06:37:06 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v3 0/3] Btrfs: populate heuristic with detection logic
Date: Sat, 29 Jul 2017 16:36:52 +0300
Message-Id: <20170729133655.31260-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Based on kdave for-next
As heuristic skeleton already merged
Populate heuristic with basic code.

First patch: add simple sampling code
It's get 16 byte samples with 256 bytes shifts
over input data. Collect info about how many
different bytes (symbols) has been found in sample data

Second patch: add code for calculate
how many unique bytes has been
found in sample data
That can fast detect easy compressible data

Third patch: add code for calculate byte core set size
i.e. how many unique bytes use 90% of sample data
That code require that numbers in bucket must be sorted
That can detect easy compressible data with many repeated bytes
That can detect not compressible data with evenly distributed bytes

Changes v1 -> v2:
  - Change input data iterator shift 512 -> 256
  - Replace magic macro numbers with direct values
  - Drop useless symbol population in bucket
    as no one care about where and what symbol stored
    in bucket at now

Changes v2 -> v3 (only update #3 patch):
  - Fix u64 division problem by use u32 for input_size
  - Fix input size calculation start - end -> end - start
  - Add missing sort.h header

Timofey Titovets (3):
  Btrfs: heuristic add simple sampling logic
  Btrfs: heuristic add byte set calculation
  Btrfs: heuristic add byte core set calculation

 fs/btrfs/compression.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/compression.h |  13 ++++++
 2 files changed, 120 insertions(+), 2 deletions(-)

--
2.13.3
