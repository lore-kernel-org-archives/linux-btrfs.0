Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:49218 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753192AbdI1Odv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 10:33:51 -0400
Received: by mail-wm0-f46.google.com with SMTP id r74so2731664wme.4
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 07:33:50 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v8 0/6] Btrfs: populate heuristic with code
Date: Thu, 28 Sep 2017 17:33:35 +0300
Message-Id: <20170928143341.24491-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Based on linux master 4.14-rc2
Duplicated to github:
https://github.com/Nefelim4ag/linux/tree/heuristic_v8

Compile tested, hand tested on live system

Patches short:
1. Implement workspaces for heuristic
   Separate heuristic/compression workspaces
   Main target for that patch:
   Maximum code sharing, minimum changes

2. Add heuristic counters and buffer to workspaces
   Add some base macros for heuristic

3. Implement simple input data sampling
   It's get 16 byte samples with 256 bytes shifts
   over input data. Collect info about how many
   different bytes (symbols) has been found in sample data
   (i.e. systematic sampling used for now)

4. Implement check sample to repeated data
   Just iterate over sample and do memcmp()
   ex. will detect zeroed data

5. Add code for calculate how many unique bytes has been found
   in sample data.
   That heuristic can detect text like data (configs, xml, json, html & etc)
   Because in most text like data byte set are restricted to limit number
   of possible characters, and that restriction in most cases
   make data easy compressible.

6. Add code for calculate byte core set size
   i.e. how many unique bytes use 90% of sample data

   Several type of structured binary data have in general
   nearly all types of bytes, but distribution can be Uniform
   where in bucket all byte types will have the nearly same count
   (ex. Encrypted data)
   and as ex. Normal (Gaussian), where count of bytes will be not so linear

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

Change v6 -> v7
  - Add missing part of first patch
  - Make use of IS_ALIGNED() for check tail aligment

Change v7 -> v8
  - All code moved to compression.c (again)
  - Heuristic workspaces inmplemented another way
    i.e. only share logic with compression workspaces
  - Some style fixes suggested by Devid
  - Move sampling function from heuristic code
    (I'm afraid of big functions)
  - Much more comments and explanations

Timofey Titovets (6):
  Btrfs: compression.c separated heuristic/compression workspaces
  Btrfs: heuristic workspace add bucket and sample items, macros
  Btrfs: implement heuristic sampling logic
  Btrfs: heuristic add detection of repeated data patterns
  Btrfs: heuristic add byte set calculation
  Btrfs: heuristic add byte core set calculation

 fs/btrfs/compression.c | 393 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 366 insertions(+), 27 deletions(-)

--
2.14.2
