Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FD6C10F00
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 14:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF7EA2133D
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 14:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733127AbfB1Oo7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 09:44:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:53348 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733119AbfB1Oo4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 09:44:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 94BE3ACE7
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 14:44:55 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>
Subject: [RFC PATCH 0/2] btrfs-progs: provide command to dump checksums
Date:   Thu, 28 Feb 2019 15:44:30 +0100
Message-Id: <20190228144432.17038-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Provide a command to dump checksums from 'btrfs inspect-internal'. This then
does a lookup for the given file's extents and walks the csum tree printing
all checksums of an extent.

This is marked as an RFC because up to now I've only tested it on simple files
created with 'xfs_io -f -c "pwrite 0 $SIZE"', but like to hear some feedback.

It is also missing some tests to check implementation and provide regression tests
for eventual bugs.

It is also available on github @ https://github.com/morbidrsa/btrfs-progs/tree/inspect-csums

Johannes Thumshirn (2):
  btrfs-progs: add 'btrfs inspect-internal csum-dump' command
  btrfs-progs: completion: wire-up dump-csum

 Makefile                 |   3 +-
 btrfs-completion         |   4 +-
 cmds-inspect-dump-csum.c | 266 +++++++++++++++++++++++++++++++++++++++++++++++
 cmds-inspect.c           |   2 +
 commands.h               |   2 +
 5 files changed, 274 insertions(+), 3 deletions(-)
 create mode 100644 cmds-inspect-dump-csum.c

-- 
2.16.4

