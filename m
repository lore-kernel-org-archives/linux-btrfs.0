Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34818 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbdGXLhS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 07:37:18 -0400
Received: by mail-lf0-f68.google.com with SMTP id w199so708101lff.2
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 04:37:18 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 0/3] Btrfs: populate heuristic with detection logic
Date: Mon, 24 Jul 2017 14:37:05 +0300
Message-Id: <20170724113708.18088-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Based on kdave for-next
As heuristic skeleton already merged
Populate heuristic with basic code that:
1. Collect sample from input data
2. Calculate byte set for sample
   For detect easily compressible data
3. Calculate byte core set size
   For detect easily and not compressible data

Timofey Titovets (3):
  Btrfs: heuristic add simple sampling logic
  Btrfs: heuristic add byte set calculation
  Btrfs: heuristic add byte core set calculation

 fs/btrfs/compression.c | 111 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/compression.h |  14 +++++++
 2 files changed, 123 insertions(+), 2 deletions(-)

--
2.13.3
