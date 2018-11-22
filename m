Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7591FC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CE8B20672
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:16:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CE8B20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405904AbeKWC46 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 21:56:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:57922 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730352AbeKWC46 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 21:56:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 167DCAD12
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 16:16:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3FB79DA829; Thu, 22 Nov 2018 17:16:39 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Minor helper and struct member cleanups
Date:   Thu, 22 Nov 2018 17:16:39 +0100
Message-Id: <cover.1542902890.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Assorted updates to code vaguely related to the bio callbacks and
structures. Remove call indirection, remove redundant struct members,
etc.

David Sterba (4):
  btrfs: merge btrfs_submit_bio_done to its caller
  btrfs: replace async_cow::root with fs_info
  btrfs: remove redundant csum buffer in btrfs_io_bio
  btrfs: replace btrfs_io_bio::end_io with a simple helper

 fs/btrfs/disk-io.c   | 18 +++++++++++++++++-
 fs/btrfs/extent_io.c |  3 +--
 fs/btrfs/file-item.c | 13 +++----------
 fs/btrfs/inode.c     | 39 +++++----------------------------------
 fs/btrfs/volumes.h   | 11 ++++++++---
 5 files changed, 34 insertions(+), 50 deletions(-)

-- 
2.19.1

