Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:43099 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752090AbeB0JNO (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 27 Feb 2018 04:13:14 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/4] btrfs check --check-data-csum enhancement for
Date: Tue, 27 Feb 2018 17:12:55 +0800
Message-Id: <20180227091259.10877-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Log-writes tool from Josef exposed btrfs data corruption.

Although still digging, at least enhance --check-data-csum option so
that log-replay --check can stop exactly at the point where btrfs data
get corrupted, instead of manually checking the output.

Qu Wenruo (4):
  btrfs-progs: check: Check data csum for all copies
  btrfs-progs: check: Fix data csum check return value
  btrfs-progs: check: Continue check even csum error is found
  btrfs-progs: check: Distingusih csum checking output for
    --check-data-csum

 check/main.c | 93 ++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 37 deletions(-)

-- 
2.16.2

