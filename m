Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FA9C282CE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04BCA21473
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfDHNbv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 09:31:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:52922 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbfDHNbu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 09:31:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B8045AE54
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Apr 2019 13:31:49 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 0/2] btrfs-progs: provide command to dump checksums
Date:   Mon,  8 Apr 2019 15:31:44 +0200
Message-Id: <20190408133146.21355-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Provide a command to dump checksums from 'btrfs inspect-internal'. This
command does a lookup for the given file's extents via FIEMAP (which is
handy as it already skips holes) and walks the checksum tree printing all
checksums of an extent.

It is tested against different layouts of files with and without holes,
but further testing done by others is highly appreciated.

It is also available on github @ https://github.com/morbidrsa/btrfs-progs/tree/inspect-csums

Changes since RFC:
* Complete re-write using ioctl()s (FIEMAP and BTRFS_TREE_SEARCH_V2) to
  gather the extent and checksum informtion, as per David's (private)
  comment.

* Re-named btrfs_lookup_csum() as per Qu's comment.

Johannes Thumshirn (2):
  btrfs-progs: add 'btrfs inspect-internal csum-dump' command
  btrfs-progs: completion: wire-up dump-csum

 Makefile                 |   3 +-
 btrfs-completion         |   4 +-
 cmds-inspect-dump-csum.c | 231 +++++++++++++++++++++++++++++++++++++++++++++++
 cmds-inspect.c           |   2 +
 commands.h               |   2 +
 5 files changed, 239 insertions(+), 3 deletions(-)
 create mode 100644 cmds-inspect-dump-csum.c

-- 
2.16.4

