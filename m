Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36122 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdHWWp5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 18:45:57 -0400
Received: by mail-wm0-f54.google.com with SMTP id x128so8602796wmg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 15:45:57 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v6 0/6] Btrfs: populate heuristic with code
Date: Thu, 24 Aug 2017 01:45:39 +0300
Message-Id: <20170823224545.16375-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Based on kdave for-next

Patches short:
1. Move heuristic to use compression workspaces
   Bit tricky, but works.

2. Add heuristic counters and buffer to workspaces

3. Implement simple input data sampling
   It's get 16 byte samples with 256 bytes shifts
   over input data. Collect info about how many
   different bytes (symbols) has been found in sample data

4. Implement check sample to repeated data
   Just iterate over sample and do memcmp()

5. Add code for calculate
   how many unique bytes has been found in sample data
   That can fast detect easy compressible data

6. Add code for calculate byte core set size
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

Changes v3 -> v4 (only update #1 patch):
  - Change counter type in bucket item u16 -> u32
  - Drop other fields from bucket item for now,
    no one use it

Change v4 -> v5
  - Move heuristic code to external file
  - Make heuristic use compression workspaces
  - Add check sample to zeroes

Change v5 -> v6
  - Add some code to hande page unaligned range start/end
  - replace sample zeroed check with check for repeated data

Timofey Titovets (6):
  Btrfs: heuristic make use compression workspaces
  Btrfs: heuristic workspace add bucket and sample items
  Btrfs: implement heuristic sampling logic
  Btrfs: heuristic add detection of repeated data patterns
  Btrfs: heuristic add byte set calculation
  Btrfs: heuristic add byte core set calculation

 fs/btrfs/heuristic.c | 162 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 159 insertions(+), 3 deletions(-)

--
2.14.1
