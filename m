Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6667AC65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31F2620849
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31F2620849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbeLLHmh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:42:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:40892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726242AbeLLHmh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 02:42:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 25DF6AD8B
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 07:42:36 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Cleanups around btrfs_get_extent_fiemap
Date:   Wed, 12 Dec 2018 09:42:31 +0200
Message-Id: <20181212074234.20613-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Following a conversation with Johaness this is what fell out. Turns out the
signature of btrfs_get_extent_fiemap is needlessly complext. So the first patch 
fixes it by removing the unnecessary arguments. Patch 2 is a bit of a "catch-all"
mainly renaming variables, thus helping recognise what the code does and
refreshing comments and removing one extra if. Finally, patch 3 removes an
assignment making it (at least to me) more clear what context a particular
variable is used in.

This has survived multiple xfstest runs. 

Nikolay Borisov (3):
  btrfs: Remove unused arguments from btrfs_get_extent_fiemap
  btrfs: Refactor btrfs_get_extent_fiemap
  btrfs: Remove redundant assignment

 fs/btrfs/ctree.h     |  3 +-
 fs/btrfs/extent_io.c |  3 +-
 fs/btrfs/file.c      |  3 +-
 fs/btrfs/inode.c     | 92 +++++++++++++++++++++++---------------------
 4 files changed, 51 insertions(+), 50 deletions(-)

-- 
2.17.1

