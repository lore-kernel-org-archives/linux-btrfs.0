Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36485 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbdGZMuJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 08:50:09 -0400
Received: by mail-lf0-f66.google.com with SMTP id t128so6353980lff.3
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 05:50:08 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2 0/3] Btrfs: populate heuristic with detection logic
Date: Wed, 26 Jul 2017 15:49:55 +0300
Message-Id: <20170726124958.18837-1-nefelim4ag@gmail.com>
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

Timofey Titovets (3):
  Btrfs: heuristic add simple sampling logic
  Btrfs: heuristic add byte set calculation
  Btrfs: heuristic add byte core set calculation

 fs/btrfs/compression.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/compression.h |  13 ++++++
 2 files changed, 119 insertions(+), 2 deletions(-)

--
2.13.3
