Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944FCC65BA7
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A20A20854
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:31:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A20A20854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbeJEE0P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:26:15 -0400
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45759 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbeJEE0J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 00:26:09 -0400
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id E94A1200C6
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 23:24:43 +0200 (CEST)
From:   Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] Chunk allocator DUP fix and cleanups
Date:   Thu,  4 Oct 2018 23:24:37 +0200
Message-Id: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
X-Mailer: git-send-email 2.19.0.329.g76f2f5c1e3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch set contains an additional fix for a newly exposed bug after
the previous attempt to fix a chunk allocator bug for new DUP chunks:

https://lore.kernel.org/linux-btrfs/782f6000-30c0-0085-abd2-74ec5827c903@mendix.com/T/#m609ccb5d32998e8ba5cfa9901c1ab56a38a6f374

The DUP fix is "fix more DUP stripe size handling". I did that one
before starting to change more things so it can be applied to earlier
LTS kernels.

Besides that patch, which is fixing the bug in a way that is least
intrusive, I added a bunch of other patches to help getting the chunk
allocator code in a state that is a bit less error-prone and
bug-attracting.

When running this and trying the reproduction scenario, I can now see
that the created DUP device extent is 827326464 bytes long, which is
good.

I wrote and tested this on top of linus 4.19-rc5. I still need to create
a list of related use cases and test more things to at least walk
through a bunch of obvious use cases to see if there's nothing exploding
too quickly with these changes. However, I'm quite confident about it,
so I'm sharing all of it already.

Any feedback and review is appreciated. Be gentle and keep in mind that
I'm still very much in a learning stage regarding kernel development.

The stable patches handling workflow is not 100% clear to me yet. I
guess I have to add a Fixes: in the DUP patch which points to the
previous commit 92e222df7b.

Moo!,
Knorrie

Hans van Kranenburg (6):
  btrfs: alloc_chunk: do not refurbish num_bytes
  btrfs: alloc_chunk: improve chunk size variable name
  btrfs: alloc_chunk: fix more DUP stripe size handling
  btrfs: fix ncopies raid_attr for RAID56
  btrfs: introduce nparity raid_attr
  btrfs: alloc_chunk: rework chunk/stripe calculations

 fs/btrfs/volumes.c | 84 +++++++++++++++++++++++-----------------------
 fs/btrfs/volumes.h |  4 ++-
 2 files changed, 45 insertions(+), 43 deletions(-)

-- 
2.19.0.329.g76f2f5c1e3

