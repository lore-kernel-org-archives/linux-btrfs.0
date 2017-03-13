Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:36403 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdCMUb0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 16:31:26 -0400
Received: by mail-wr0-f181.google.com with SMTP id u108so111275920wrb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 13:31:25 -0700 (PDT)
From: ednadolski@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: Edmund Nadolski <enadolski@suse.com>
Subject: [PATCH 0/2] Cleanup for some hardcoded constants
Date: Mon, 13 Mar 2017 14:32:02 -0600
Message-Id: <20170313203204.11857-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Edmund Nadolski <enadolski@suse.com>

This series replaces several hard-coded values with descriptive
symbols.

Edmund Nadolski (2):
  btrfs: provide enumeration for __merge_refs mode argument
  btrfs: replace hardcoded value with SEQ_NONE macro

 fs/btrfs/backref.c | 31 +++++++++++++++++--------------
 fs/btrfs/backref.h |  2 ++
 fs/btrfs/qgroup.c  |  4 ++--
 3 files changed, 21 insertions(+), 16 deletions(-)

-- 
2.10.2

