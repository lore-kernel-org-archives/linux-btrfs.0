Return-Path: <SRS0=0Ua4=ZK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241B4C432C0
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 06:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF2E820730
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 06:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfKRGa7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 01:30:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:38334 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726538AbfKRGa7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Nov 2019 01:30:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3C17AB246;
        Mon, 18 Nov 2019 06:30:58 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     osandov@osandov.com
Subject: [PATCH 0/4] btrfs-progs: Compiling warning fixes for devel branch
Date:   Mon, 18 Nov 2019 14:30:48 +0800
Message-Id: <20191118063052.56970-1-wqu@suse.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have several compiling errors, in devel branch.
One looks like a false alert from compiler, the first patch will
workaround it.

3 warning from libbtrfsutils are due to python3.8 changes.
Handle it properly by using designated initialization, which also saves
us quite some lines.

Qu Wenruo (4):
  btrfs-progs: check/lowmem: Fix a false alert on uninitialized value
  btrfs-progs: libbtrfsutil: Convert to designated initialization for
    BtrfsUtilError_type
  btrfs-progs: libbtrfsutil: Convert to designated initialization for
    QgroupInherit_type
  btrfs-progs: libbtrfsutil: Convert to designated initialization for
    SubvolumeIterator_type

 check/mode-common.c             |  2 +-
 libbtrfsutil/python/error.c     | 49 ++++++++-------------------------
 libbtrfsutil/python/qgroup.c    | 43 ++++++-----------------------
 libbtrfsutil/python/subvolume.c | 44 ++++++-----------------------
 4 files changed, 30 insertions(+), 108 deletions(-)

-- 
2.24.0

