Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65039 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2FRRfZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 13:35:25 -0400
Received: by mail-qc0-f174.google.com with SMTP id o28so3013918qcr.19
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2012 10:35:25 -0700 (PDT)
From: Andrew Mahone <andrew.mahone@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andrew Mahone <andrew.mahone@gmail.com>
Subject: [PATCH] Ignore unfragmented file checks in defrag when compression enabled
Date: Mon, 18 Jun 2012 13:27:36 -0400
Message-Id: <1340040457-16249-1-git-send-email-andrew.mahone@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed that btrfs fi defrag -c<method> can't be used to compress files
unless they are fragmented. This patch corrects the problem, by informing
should_defrag_range if compression is enabled, and skipping tests for extent
and adjacent extents if it is.

Andrew Mahone (1):
  btrfs: ignore unfragmented file checks in defrag when compression
    enabled

 fs/btrfs/ioctl.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
1.7.10.2

