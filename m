Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53516 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753002AbeGEHhe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 03:37:34 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C35D2AF54
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 07:37:33 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] Some random fuzz test fixes
Date: Thu,  5 Jul 2018 15:37:27 +0800
Message-Id: <20180705073731.18459-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/fuzzed_enhance

Some random bugs exposed by the ill-fated fuzz-test (003 never seems to
pass).

It will be a big work to make fuzz/003 to pass, but at least there are
some easy fixes.

Qu Wenruo (4):
  btrfs-progs: check: Remove the ability to rebuild root overwritting
    existing tree blocks
  btrfs-progs: transaction: Error out other than panic when committing
    transaction
  btrfs-progs: check/original: Avoid infinite loop when failed to repair
    inode
  btrfs-progs: check/original: Don't overwrite return value when we
    failed to repair

 check/main.c  | 46 +++++++++++++++++++++++++---------------------
 transaction.c | 19 +++++++++++++------
 2 files changed, 38 insertions(+), 27 deletions(-)

-- 
2.18.0

