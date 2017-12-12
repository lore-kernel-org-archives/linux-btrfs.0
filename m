Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33683 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752288AbdLLU53 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 15:57:29 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: nefelim4ag@gmail.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3] Minor compression heuristic cleanups
Date: Tue, 12 Dec 2017 21:55:27 +0100
Message-Id: <cover.1513111931.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The callback pointers for radix_sort are not needed, we don't plan to
export the function now. The compiler is smart enough to replace the
indirect calls with direct ones, so there's no change in the resulting
asm code.

David Sterba (3):
  btrfs: heuristic: open code get_num callback of radix sort
  btrfs: heuristic: open code copy_call callback of radix sort
  btrfs: heuristic: call get4bits directly

 fs/btrfs/compression.c | 42 +++++++++++-------------------------------
 1 file changed, 11 insertions(+), 31 deletions(-)

-- 
2.15.1

