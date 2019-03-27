Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEC5C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 09:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17E7C2075C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 09:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbfC0JrC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 05:47:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:56686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726237AbfC0JrB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 05:47:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B55EAACBC
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 09:47:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH URGENT v1.1 0/2] btrfs-progs: Fix the nobarrier behavior of write
Date:   Wed, 27 Mar 2019 17:46:50 +0800
Message-Id: <20190327094652.16078-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This urgent patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/flush_super
Which is based on v4.20.2.

Before this patch, btrfs-progs writes to the fs has no barrier at all.
All metadata and superblock are just buffered write, no barrier between
super blocks and metadata writes at all.

No wonder why even clear space cache can cause serious transid
corruption to the originally good fs.

Please merge this fix as soon as possible as I really don't want to see
btrfs-progs corrupting any fs any more.

Changelog:
v1.1:
- Use one line error report other than 2 seperate lines.

Qu Wenruo (2):
  btrfs-progs: disk-io: Make super block write error easier to read
  btrfs-progs: disk-io: Flush to ensure super block write is FUA

 disk-io.c | 56 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 11 deletions(-)

-- 
2.21.0

