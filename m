Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522B0C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E32022064E
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:25:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E32022064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbeJEPXJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:23:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:35596 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727703AbeJEPXJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 11:23:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36BE1AFC0
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Oct 2018 08:25:30 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] Enhance btrfs_verify_dev_extents() to do more checks on dev extents
Date:   Fri,  5 Oct 2018 16:25:23 +0800
Message-Id: <20181005082525.22441-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Inspired by Hans' possible flawed DUP chunk allocator, add the following
dev extents checker:

1) Dev extent overlap check
   Dev extents don't use extent_cache so it can't report dev extents
   overlap.
   So manually check dev extents overlap.
   This check is pretty simple since we're already iterating dev extents
   by its physical offset, we only need to remember previous checked dev
   extents to do such check.

2) Dev extent end check
   No dev extent should go beyond device boundary.

These two checks are pretty cheap so it shouldn't bring any performance
overhead.

Qu Wenruo (2):
  btrfs: volumes: Make sure there is no overlap dev extents at mount
    time
  btrfs: volumes: Make sure no dev extent is beyond device boundary

 fs/btrfs/volumes.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

-- 
2.19.0

