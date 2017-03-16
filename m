Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33803 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755069AbdCPQel (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 12:34:41 -0400
Received: by mail-wm0-f68.google.com with SMTP id u132so10614893wmg.1
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Mar 2017 09:34:38 -0700 (PDT)
From: ednadolski@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: Edmund Nadolski <enadolski@suse.com>
Subject: [PATCH v2 0/2] Cleanup for some hardcoded constants
Date: Thu, 16 Mar 2017 10:04:32 -0600
Message-Id: <20170316160434.8126-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Edmund Nadolski <enadolski@suse.com>

This series replaces several hard-coded values with descriptive
symbols.

---
v2:
 + rename SEQ_NONE to SEQ_LAST and move definition to ctree.h
 + clarify comment at __merge_refs()

Edmund Nadolski (2):
  btrfs: provide enumeration for __merge_refs mode argument
  btrfs: replace hardcoded value with SEQ_LAST macro

 fs/btrfs/backref.c | 39 +++++++++++++++++++++------------------
 fs/btrfs/ctree.h   |  2 ++
 fs/btrfs/qgroup.c  |  4 ++--
 3 files changed, 25 insertions(+), 20 deletions(-)

-- 
2.10.2

